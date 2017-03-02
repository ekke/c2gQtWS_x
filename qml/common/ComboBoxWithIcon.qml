// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

// thx J-P Nurmi (@jpnurmi) for helping
// this custom ComboBox works using a JS datamodel where the model is something like this:
// [{"imageName":"download.png", "itemText":qsTr("Download")}, ...]
// using same model as a QML ListModel you must change the delegate: model.imageName
// and contentItem: listModel.get(comboBox.currentIndex).imageName
ComboBox {
    id: comboBox
    focusPolicy: Qt.NoFocus
    property bool containsInvalidItems: false

    delegate: ItemDelegate {
                width: comboBox.width
                Material.foreground: comboBox.currentIndex === index ? comboBox.Material.accent : comboBox.Material.foreground
                highlighted: comboBox.highlightedIndex === index
                contentItem: Row {
                    spacing: 6
                    IconInactive {
                        imageName: modelData.imageName
                    }
                    LabelSubheading {
                        text: modelData.itemText
                        anchors.verticalCenter: parent.verticalCenter
                        font.strikeout: comboBox.containsInvalidItems && modelData.invalidItem
                    }
                }
            }

    contentItem:
        Row {
        // need some space to see the indicator
        // need some extra space for the rows to display Icon and text if displayText is used
        rightPadding: comboBox.displayText.length? 24+16 : 16
        spacing: 6
        IconInactive {
            visible: !comboBox.displayText.length
            imageName: comboBox.model[comboBox.currentIndex].imageName
        }
        LabelSubheading {
            text: comboBox.displayText.length? comboBox.displayText : comboBox.model[comboBox.currentIndex].itemText
            anchors.verticalCenter: parent.verticalCenter
            font.strikeout: comboBox.displayText.length? false : comboBox.containsInvalidItems && comboBox.model[comboBox.currentIndex].invalidItem
        }
    } // row
}
