// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import "../common"

// you must imoplent function doCommunication() and Menus in main.qml !!
FloatingActionMiniButton {
    id: phoneButton
    property string phoneNumber: ""
    imageSource: "qrc:/images/"+iconOnPrimaryFolder+"/call.png"
    showShadow: true
    anchors.right: parent.right
    anchors.top: parent.top
    onClicked: {
        appWindow.doCommunication(phoneButton, phoneButton.phoneNumber)
    }
} // phoneButton
