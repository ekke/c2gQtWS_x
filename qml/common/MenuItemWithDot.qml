// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

MenuItem {
    id: menuItem
    property alias dotColor: theDot.color
    property alias itemText: theLabel.text
    focusPolicy: Qt.NoFocus
    contentItem:
        Row {
        topPadding: 0
        bottomPadding: 0
        spacing: 12
        Rectangle {
            id: theDot
            width: 16
            height: 16
            radius: width / 2
            color: "White"
            anchors.verticalCenter: parent.verticalCenter
        }
        LabelSubheading {
            id: theLabel
            text: ""
            anchors.verticalCenter: parent.verticalCenter
        }
    } // row
}
