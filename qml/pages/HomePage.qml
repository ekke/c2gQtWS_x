// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0

import "../common"
import "../popups"

Pane {
    id: homePage
    height: appWindow.height
    property string name: "HomePage"
    property Conference conference
    property bool isAutoVersionCheckMode: true
    onIsAutoVersionCheckModeChanged: {
        checkVersionPopup.isAutoVersionCheckMode = homePage.isAutoVersionCheckMode
        appWindow.autoVersionCheck = homePage.isAutoVersionCheckMode
    }

    //topPadding: 12
    padding: 0

    Image {
        id: conferenceImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: isLandscape? "qrc:/images/extra/sf_landscape.jpg" : "qrc:/images/extra/sf_portrait.jpg"
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop
        transformOrigin: Item.TopLeft
    } // image

    LabelDisplay1 {
        anchors.centerIn: parent
        text: qsTr("October, 18-20\nSan Francisco, USA\n\nWelcome")
        color: "white"
        opacity: 1.0
    }


    FloatingActionButton {
        visible: !homePage.isAutoVersionCheckMode
        property string imageName: "/refresh.png"
        z: 1
        anchors.margins: 20
        anchors.bottomMargin: isLandscape? 60 : 112
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        imageSource: "qrc:/images/"+iconOnAccentFolder+imageName
        backgroundColor: accentColor
        onClicked: {
            // check if date is OK
            if(dataUtil.isDateTooLate()) {
                appWindow.showToast(qsTr("Sorry - the Conference is closed.\nNo more Updates available"))
                return
            }
            checkVersionExplicitely()
        }
    } // FAB

    // open modal dialog and wait if update required
    function checkVersionExplicitely() {
        homePage.isAutoVersionCheckMode = false
        checkVersionPopup.text = qsTr("Checking QtWS Server\nfor new Schedule Data ...")
        checkVersionPopup.buttonsVisible = false
        checkVersionPopup.isUpdate = false
        checkVersionPopup.open()
    }
    function checkVersionAutomatically() {
        homePage.isAutoVersionCheckMode = true
        dataUtil.checkVersion()
    }

    PopupUpdate {
        id: checkVersionPopup
        modal: true
        closePolicy: Popup.NoAutoClose
        onOpened: {
            dataUtil.checkVersion()
        }
        onClosed: {
            if(checkVersionPopup.isUpdate) {
                rootPane.startUpdate()
                return
            }
            if(checkVersionPopup.doItManually) {
                homePage.isAutoVersionCheckMode = false
                return
            }
            // try it later
            homePage.isAutoVersionCheckMode = true
            rootPane.startAutoVersionCheckTimer()
        }
    } // checkVersionPopup

    function updateDone() {
        // update was done with success
        // so we switch back to auto version check if coming from manually version check
        homePage.isAutoVersionCheckMode = true
    }

    function updateAvailable(apiVersion) {
        console.log("QML updateAvailable " + apiVersion)
        checkVersionPopup.text = qsTr("Update available.\nAPI Version: ")+apiVersion
        checkVersionPopup.showUpdateButton = true
        checkVersionPopup.buttonsVisible = true
        checkVersionPopup.isAutoVersionCheckMode = homePage.isAutoVersionCheckMode
        if(isAutoVersionCheckMode) {
            rootPane.gotoFirstDestination()
            checkVersionPopup.open()
        }
    }
    function noUpdateRequired() {
        console.log("QML noUpdateRequired")
        if(isAutoVersionCheckMode) {
            rootPane.startAutoVersionCheckTimer()
            return
        }
        checkVersionPopup.text = qsTr("No Update required.")
        checkVersionPopup.showUpdateButton = false
        checkVersionPopup.buttonsVisible = true
    }
    function checkFailed(message) {
        console.log("QML checkFailed "+message)
        if(isAutoVersionCheckMode) {
            rootPane.startAutoVersionCheckTimer()
            return
        }
        checkVersionPopup.text = qsTr("Version Check failed:\n")+message
        checkVersionPopup.showUpdateButton = false
        checkVersionPopup.buttonsVisible = true
    }
    Connections {
        target: dataUtil
        onUpdateAvailable: updateAvailable(apiVersion)
    }
    Connections {
        target: dataUtil
        onNoUpdateRequired: noUpdateRequired()
    }
    Connections {
        target: dataUtil
        onCheckForUpdateFailed: checkFailed(message)
    }
    Connections {
        target: appWindow
        onDoAutoVersionCheck: checkVersionAutomatically()
    }
    // also catched from main
    Connections {
        target: dataUtil
        onUpdateDone: rootPane.updateDone()
    }

    // emitting a Signal could be another option
    Component.onDestruction: {
        cleanup()
    }


    // called immediately after Loader.loaded
    function init() {
        conference = dataManager.conferencePropertyList[0]
        console.log("Init done from Home Page")
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from Home Page")
    }
} // flickable
