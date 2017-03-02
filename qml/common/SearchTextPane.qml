// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Pane {
    id: searchPane
    // to see the topmost row in listview add this to parent (Page)
//        property bool keyboardVisible: Qt.inputMethod.visible
//        onKeyboardVisibleChanged: {
//            if(keyboardVisible) {
//                topPadding = 86
//            } else {
//                topPadding = 6
//            }
//        }
    property alias searchTextField: theSearchTextField
    // don't use text ! won't work on Android or iOS but on OSX
    // displayText is always working
    property alias currentSearchText: theSearchTextField.displayText

    topPadding: 0
    z: 1
    Material.elevation: 12
    width: appWindow.width * 2/3
    height: 54
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 10
    anchors.bottom: parent.bottom
    RowLayout {
        width: parent.width - 30
        TextField {
            id: theSearchTextField
            Layout.fillWidth: true
            Layout.topMargin: 6
            Layout.leftMargin: 6
            placeholderText: qsTr("Search")
            // Keys.onReturnPressed: not used here
        }

    } // row
    ButtonIconActive {
        visible: theSearchTextField.displayText.length > 0
        focusPolicy: Qt.ClickFocus
        anchors.right: parent.right
        imageName: "clear.png"
        onClicked: {
            theSearchTextField.text = ""
            theSearchTextField.forceActiveFocus()
        }
    }
} // searchPane
