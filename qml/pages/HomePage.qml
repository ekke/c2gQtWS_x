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

            // open modal dialog and wait if update required
            updatePopup.text = qsTr("Checking QtCon Server\nfor new Schedule Data ...")
            updatePopup.buttonsVisible = false
            updatePopup.isUpdate = false
            updatePopup.open()
        }
    } // FAB

    PopupUpdate {
        id: updatePopup
        modal: true
        closePolicy: Popup.NoAutoClose
        onOpened: {
            dataUtil.checkVersion()
        }
        onClosed: {
            if(updatePopup.isUpdate) {
                rootPane.startUpdate()
            }
        }
    } // updatePopup

    function updateAvailable(apiVersion) {
        console.log("QML updateAvailable " + apiVersion)
        updatePopup.text = qsTr("Update available.\nAPI Version: ")+apiVersion
        updatePopup.showUpdateButton = true
        updatePopup.buttonsVisible = true

    }
    function noUpdateRequired() {
        console.log("QML noUpdateRequired")
        updatePopup.text = qsTr("No Update required.")
        updatePopup.showUpdateButton = false
        updatePopup.buttonsVisible = true
    }
    function checkFailed(message) {
        console.log("QML checkFailed "+message)
        updatePopup.text = qsTr("Version Check failed:\n")+message
        updatePopup.showUpdateButton = false
        updatePopup.buttonsVisible = true
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
