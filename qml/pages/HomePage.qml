// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0

import "../common"
import "../popups"

Pane {
    id: homePage
    height: appWindow.height
    property string name: "HomePage"
    property Conference conference
    property bool isSilentMode: true
    onIsSilentModeChanged: {
        checkVersionPopup.isSilentMode = homePage.isSilentMode
    }

    //topPadding: 12
    padding: 0

    Image {
        id: conferenceImage
        anchors.fill: parent
        //width: appWindow.width
        //height: appWindow.height
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
        visible: !homePage.isSilentMode
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
        homePage.isSilentMode = false
        checkVersionPopup.text = qsTr("Checking QtWS Server\nfor new Schedule Data ...")
        checkVersionPopup.buttonsVisible = false
        checkVersionPopup.isUpdate = false
        checkVersionPopup.open()
    }
    function checkVersionSilently() {
        homePage.isSilentMode = true
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
            // TODO if cancel: restart timer now or later or do it manually
            if(checkVersionPopup.doItManually) {
                isSilentMode = false
                return
            }
            // has canceled - try it later
            isSilentMode = true
            rootPane.startSilentVersionCheckTimer()
        }
    } // checkVersionPopup

    function updateAvailable(apiVersion) {
        console.log("QML updateAvailable " + apiVersion)
        checkVersionPopup.text = qsTr("Update available.\nAPI Version: ")+apiVersion
        checkVersionPopup.showUpdateButton = true
        checkVersionPopup.buttonsVisible = true
        if(isSilentMode) {
            rootPane.gotoFirstDestination()
            checkVersionPopup.open()
        }

    }
    function noUpdateRequired() {
        console.log("QML noUpdateRequired")
        if(isSilentMode) {
            rootPane.startSilentVersionCheckTimer()
            return
        }
        checkVersionPopup.text = qsTr("No Update required.")
        checkVersionPopup.showUpdateButton = false
        checkVersionPopup.buttonsVisible = true
    }
    function checkFailed(message) {
        console.log("QML checkFailed "+message)
        if(isSilentMode) {
            rootPane.startSilentVersionCheckTimer()
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
        onDoSilentVersionCheck: checkVersionSilently()
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
