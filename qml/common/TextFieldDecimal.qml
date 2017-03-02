// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

TextField {
    id: valueText
    property real minValue: 0.0
    property real maxValue: 999.0
    property int maxDecimals: 2
    validator: DoubleValidator{bottom: minValue; top: maxValue; decimals: maxDecimals; notation: DoubleValidator.StandardNotation; locale: "de"} // Qt.locale().name
    onTextChanged: {
        text = text.replace(".", ",")
    }
    color: acceptableInput? Material.foreground : "Red"
    placeholderText: qsTr("%1...%2").arg(minValue).arg(maxValue)
    // ImhFormattedNumbersOnly shows and allows digits and ',' on ios, shows and allows also +, - on android
    inputMethodHints: Qt.ImhFormattedNumbersOnly
}
