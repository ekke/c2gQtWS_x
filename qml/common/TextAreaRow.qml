// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

RowLayout {
    id: theTextRow
    signal done()
    property alias text: theTextField.text
    property alias placeholderText: theTextField.placeholderText
    property alias textField: theTextField
    property int minHeightTextPane: 140
    property bool doubleTapIsDefault: true
    Pane {
        id: textPane
        anchors.top: parent.top
        Material.elevation: 6
        Layout.fillWidth: true
        Layout.minimumHeight: theTextField.activeFocus? minHeightTextPane : 60
        TextArea {
            id: theTextField
            // Qt 5.8
            // only iof set to true we can mark words by double tap
            selectByMouse: doubleTapIsDefault
            // important - otherwise text goes endless without wrapping
            width: parent.width
            text: ""
            wrapMode: TextArea.WordWrap
        } // theTextField
    } // text pane
    Column {
        spacing: 0
        anchors.top: textPane.top
        Layout.minimumWidth: textClearButton.visible || textSelectToggleButton.visible || textDoneButton.visible? 48 : 0
        ButtonIconActive {
            id: textClearButton
            anchors.horizontalCenter: parent.horizontalCenter
            visible: theTextField.activeFocus || theTextField.text.length
            focusPolicy: Qt.ClickFocus
            imageName: "clear.png"
            onClicked: {
                theTextField.text = ""
            }
        } // textClearButton
        ButtonIconActive {
            id: textSelectToggleButton
            anchors.horizontalCenter: parent.horizontalCenter
            visible: theTextField.activeFocus
            focusPolicy: Qt.ClickFocus
            imageName: "code.png"
            onClicked: {
                theTextField.selectByMouse = !theTextField.selectByMouse
                if(theTextField.selectByMouse) {
                    appWindow.showToast(qsTr("Word Selection by Double Tap switched ON"))
                } else {
                    appWindow.showToast(qsTr("Word Selection by Double Tap switched OFF"))
                }
            }
        } // textSelectButton
        ButtonIconActive {
            id: textDoneButton
            anchors.horizontalCenter: parent.horizontalCenter
            visible: theTextField.activeFocus
            focusPolicy: Qt.ClickFocus
            imageName: "done.png"
            onClicked: {
                // we only need the focus
                // emit signal so users can give another field the activeFocus
                theTextRow.done()
            }
        } // textDoneButton
    }
} // row w text area
