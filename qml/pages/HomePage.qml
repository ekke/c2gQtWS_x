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
        anchors.top: parent
        x: 16
        y: 16
        width: isLandscape? undefined : appWindow.width - 32
        height: isLandscape? appWindow.height - 32 : undefined
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/extra/globe.png"
        horizontalAlignment: isLandscape? Image.AlignLeft : Image.AlignHCenter
        verticalAlignment: Image.AlignTop
        transformOrigin: Item.TopLeft
    } // image

    LabelHeadline {
        id: conferenceTitle
        anchors.top: isLandscape? parent.top : conferenceImage.bottom
        anchors.topMargin: 10
        anchors.left: isLandscape? conferenceImage.right : parent.left
        anchors.leftMargin: isLandscape? 6 : 24
        text: currentConference? currentConference.id === 201801? qsTr("October, 29-30\nBOSTON, Massachusetts") : qsTr("December, 05-06\nBERLIN, Germany") : ""
        color: accentColor
    }

    ButtonRaised {
        visible: currentConference
        id: conferenceSwitchButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: isLandscape? 72 : 124
        anchors.left: conferenceTitle.left
        text: qsTr("Switch Conference")
        onClicked: {
            currentConference = dataUtil.switchConference()
            appWindow.conferenceSwitched()
        }
    }


    FloatingActionButton {
        visible: !homePage.isAutoVersionCheckMode || !currentConference
        property string imageName: "/refresh.png"
        z: 1
        anchors.margins: 20
        anchors.bottomMargin: isLandscape? 60 : 112
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        imageSource: "qrc:/images/"+iconOnAccentFolder+imageName
        backgroundColor: accentColor
        onClicked: {
            // check if there's no conference yet
            if(dataUtil.isNoConference()) {
                checkVersionExplicitely()
                return
            }
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
    // open modal dialog and wait
    function updateFromOldConference() {
        homePage.isAutoVersionCheckMode = false
        checkVersionPopup.text = qsTr("New Conference Data available ...")
        checkVersionPopup.buttonsVisible = false
        checkVersionPopup.isUpdate = false
        checkVersionPopup.open()
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
    Connections {
        target: appWindow
        onOldConference: updateFromOldConference()
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
        conference = dataManager.conferencePropertyList.length > 0? dataManager.conferencePropertyList[0] : dataManager.createConference()
        console.log("Init done from Home Page")
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from Home Page")
    }
} // flickable
