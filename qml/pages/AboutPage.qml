// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

import "../common"

Flickable {
    id: flickable
    // index to get access to Loader (Destination)
    property int myIndex: index
    contentHeight: root.implicitHeight
    // StackView manages this, so please no anchors here
    // anchors.fill: parent
    property string name: "About"

    Pane {
        id: root
        anchors.fill: parent
        ColumnLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            RowLayout {
                Image {
                    source: "qrc:/images/extra/qtws-app.png"
                }
                LabelHeadline {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Conference2Go\nQtWS 2016, San Francisco\n(Qt 5.7 - Android + iOS)")
                    color: primaryColor
                }
            }
            HorizontalDivider {}
            RowLayout {
                Image {
                    source: "qrc:/images/extra/ekke-thumbnail.png"
                }
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Conference2Go QtWS 2016\ndeveloped by ekke (@ekkescorner)")
                    color: accentColor
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("This is one of my first APPs for Android and iOS. Last years I developed for BlackBerry 10 / Cascades.")
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("This is also one of my first APPs I developed using Qt. This APP is developed with Qt 5.7 and brandnew <a href=\"http://doc.qt.io/qt-5/qtquickcontrols2-index.html\">QtQuickControls2</a>.")
                    onLinkActivated: Qt.openUrlExternally("http://doc.qt.io/qt-5/qtquickcontrols2-index.html")
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("All work is done in my spare time and complete sourcecode is available at <a href=\"https://github.com/ekke/c2gQtWS_x\">Github</a>")
                    onLinkActivated: Qt.openUrlExternally("https://github.com/ekke/c2gQtWS_x")
                }
            }
//
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("My blog series about <a href=\"http://j.mp/qt-x\">Qt for x-platform Business Apps</a>")
                    onLinkActivated: Qt.openUrlExternally("http://j.mp/qt-x")
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Please report bugs, feature requests or discuss the APP in the <a href=\"http://bit.ly/qtWS2016App\">Comments</a>")
                    onLinkActivated: Qt.openUrlExternally("http://bit.ly/qtWS2016App")
                }
            }
            HorizontalDivider {}
            RowLayout {
                LabelTitle {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Thanks !")
                    color: primaryColor
                }
            }
            RowLayout {
                LabelBodySecondary {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Thanks to 'Tero Kojo, qt.io' managing all around the Conference App.")
                }
            }
            RowLayout {
                LabelBodySecondary {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Thanks for great Design of APP Icons and (iOS)-Splashscreen by 'Diana de Sousa, qt.io'")
                }
            }
            RowLayout {
                LabelBodySecondary {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Thanks supporting my requests at Server Site (JSON, API): 'Olli Puurunen, qt.io'")
                }
            }
            RowLayout {
                LabelBodySecondary {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Thanks J-P Nurmi, Mitch Curtis and others @qt.io for help, bug-fixing and inspirations.")
                }
            }
            HorizontalDivider {}
            RowLayout {
                LabelTitle {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Need a Business APP for BlackBerry10, Android, iOS ?")
                    color: primaryColor
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("ekke is doing international development for Enterprise and SMB (Small and Medium Business). Most APPs are 'hidden' because they're running as inhouse APP at customer site.\nThis Conference App will give you some impressions what kind of APPs you can expect. Need an APP ? ask ekke")
                }
            }
            HorizontalDivider {}
            RowLayout {
                LabelBodySecondary {
                    leftPadding: 10
                    rightPadding: 10
                    font.italic: true
                    wrapMode: Text.WordWrap
                    text: qsTr("ekke is BlackBerry Elite Developer, Enterprise Platinum Partner and certified Builder for Native.")
                }
            }
            RowLayout {
                Image {
                    source: "qrc:/images/extra/bb-elite.png"
                }
            }
            RowLayout {
                Image {
                    source: "qrc:/images/extra/bb-builder-native.png"
                }
            }
            HorizontalDivider {}
        } // col layout
    } // root
    ScrollIndicator.vertical: ScrollIndicator { }

    // emitting a Signal could be another option
    Component.onDestruction: {
        cleanup()
    }

    // called immediately after Loader.loaded
    function init() {
        console.log("Init done from ABOUT")
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from ABOUT")
    }
} // flickable
