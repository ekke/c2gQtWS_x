// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0

FloatingActionMiniButton {
    id: phoneButton
    property string phoneNumber: ""
    imageSource: "qrc:/images/"+iconOnPrimaryFolder+"/call.png"
    showShadow: true
    anchors.right: parent.right
    anchors.top: parent.top
    onClicked: {
        if(Qt.platform.os == "ios") {
            callMenuIOS.open()
        } else {
            callMenu.open()
        }
    }

    Menu {
        id: callMenu
        MenuItemWithIcon {
            itemText: qsTr("Phone Call")
            imageName: "call.png"
            onTriggered: {
                Qt.openUrlExternally("tel:%1".arg(phoneButton.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("SMS")
            imageName: "sms.png"
            onTriggered: {
                Qt.openUrlExternally("sms:%1".arg(phoneButton.phoneNumber))
            }
        }
    } // end callMenu
    Menu {
        id: callMenuIOS
        MenuItemWithIcon {
            itemText: qsTr("Phone Call")
            imageName: "call.png"
            onTriggered: {
                Qt.openUrlExternally("telprompt:%1".arg(phoneButton.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("SMS")
            imageName: "sms.png"
            onTriggered: {
                Qt.openUrlExternally("sms:%1".arg(phoneButton.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("Facetime")
            imageName: "videocam.png"
            onTriggered: {
                Qt.openUrlExternally("facetime:%1".arg(phoneButton.phoneNumber))
            }
        }
    } // end callMenuIOS

} // phoneButton
