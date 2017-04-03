import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

// Main Communication menu
// must be placed in main.qml
// sets visual parent to calling button
// onCLosed sets visual parent to rootPane (StackView)
// this Menu is used inside FloatingActionButton (CommunicationButton)
// having the Menu directly inside the FAB makes listViews jerky (Qt 5.8)
// thx @JPNurmi I got much better performance now using one global Menu
Item {
    id: theCommunicationMenu

    function doCommunication(button, phoneNumber) {
        if(Qt.platform.os == "ios") {
            callMenuIOS.parent = button
            callMenuIOS.phoneNumber = phoneNumber
            callMenuIOS.open()
        } else {
            callMenu.parent = button
            callMenu.phoneNumber = phoneNumber
            callMenu.open()
        }
    } // doCommunication

    Menu {
        id: callMenu
        property string phoneNumber: ""
        MenuItemWithIcon {
            itemText: qsTr("Phone Call")
            imageName: "call.png"
            onTriggered: {
                Qt.openUrlExternally("tel:%1".arg(callMenu.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("SMS")
            imageName: "sms.png"
            onTriggered: {
                Qt.openUrlExternally("sms:%1".arg(callMenu.phoneNumber))
            }
        }
        onClosed: {
            callMenu.parent = rootPane
        }
    } // end callMenu

    Menu {
        id: callMenuIOS
        property string phoneNumber: ""
        MenuItemWithIcon {
            itemText: qsTr("Phone Call")
            imageName: "call.png"
            onTriggered: {
                Qt.openUrlExternally("telprompt:%1".arg(callMenuIOS.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("SMS")
            imageName: "sms.png"
            onTriggered: {
                Qt.openUrlExternally("sms:%1".arg(callMenuIOS.phoneNumber))
            }
        }
        MenuItemWithIcon {
            itemText: qsTr("Facetime")
            imageName: "videocam.png"
            onTriggered: {
                Qt.openUrlExternally("facetime:%1".arg(callMenuIOS.phoneNumber))
            }
        }
        onClosed: {
            callMenuIOS.parent = rootPane
        }
    } // end callMenuIOS


} // theCommunicationMenu
