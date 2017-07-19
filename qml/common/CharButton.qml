// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Button {
    id: charButton
    property alias character: theLabel.text
    // default: isDarkTheme? "lightgrey" : "darkgrey"
    property alias backgroundColor: buttonBackground.color
    // default isDarkTheme? "black" : "white"
    property alias textColor: theLabel.color
    property bool showShadow: false
    property int size: 36
    implicitHeight: charButton.size
    implicitWidth: charButton.size
    focusPolicy: Qt.NoFocus
    contentItem:
        Item {
        //implicitHeight: charButton.size
        //implicitWidth: charButton.size
        Label {
            id: theLabel
            anchors.leftMargin: 0
            anchors.centerIn: parent
            text: "?"
            font.pixelSize: charButton.size*2/3
            color: isDarkTheme? "black" : "white"
            verticalAlignment: Text.AlignVCenter
        }
    }
    background:
        Rectangle {
        id: buttonBackground
        //implicitWidth: charButton.size
        //implicitHeight: charButton.size
        color: isDarkTheme? "lightgrey" : "darkgrey"
        radius: width / 2
        opacity: charButton.pressed ? 0.75 : 1.0
        layer.enabled: charButton.showShadow
        layer.effect: DropShadow {
            verticalOffset: 3
            horizontalOffset: 1
            color: dropShadow
            samples: charButton.pressed ? 20 : 10
            spread: 0.5
        }
    }
}
