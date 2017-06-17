// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

TextField {
    id: valueText
    selectByMouse: true
    property int minValue: 0
    property int maxValue: 999
    validator: RegExpValidator{regExp: /\d{2,3}[\.\,\/]\d{2,3}/}
    onTextChanged: {
        text = text.replace(".", "/").replace(",","/")
    }
    color: acceptableInput? Material.foreground : "Red"
    placeholderText: "n/n " + (Qt.platform.os == "ios"? "(, = /)" : "(. = /)")
    // ImhFormattedNumbersOnly shows and allows digits and ',' on ios, shows and allows also +, - on android
    inputMethodHints: Qt.ImhFormattedNumbersOnly
}
