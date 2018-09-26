// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
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
        anchors.leftMargin: unsafeArea.unsafeLeftMargin
        anchors.rightMargin: unsafeArea.unsafeRightMargin
        ColumnLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            RowLayout {
                Image {
                    source: "qrc:/images/extra/qtws-app.png"
                }
                LabelHeadline {
                    visible: Qt.platform.os !== "ios"
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Conference2Go\nQtWS 2018\nBoston + Berlin\n(Qt 5.11 - Android + iOS)")
                    color: primaryColor
                }
                // Hint: I got Apps rejected by apple because I mentioned Android ;-)
                LabelHeadline {
                    visible: Qt.platform.os === "ios"
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Conference2Go\nQtWS 2018\nBoston + Berlin\n(Qt 5.11 - crossplatform)")
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
                    text: qsTr("Conference2Go QtWS 2018\ndeveloped by ekke (@ekkescorner)")
                    color: accentColor
                }
            }
            RowLayout {
                LabelSubheading {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("This APP is developed with Qt 5.11 and <a href=\"http://doc.qt.io/qt-5/qtquickcontrols2-index.html\">QtQuickControls2</a>.")
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
                    text: qsTr("You want to discuss about this App or Qt for Mobile App Development ? <a href=\"http://slackin.qtmob.org/\">Join QtMob</a>")
                    onLinkActivated: Qt.openUrlExternally("http://slackin.qtmob.org/")
                }
            }
            HorizontalDivider {}
            RowLayout {
                visible: Qt.platform.os !== "ios"
                LabelTitle {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Need a Business APP for Android and iOS ?")
                    color: primaryColor
                }
            }
            RowLayout {
                visible: Qt.platform.os === "ios"
                LabelTitle {
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Need a Business APP for mobile ?")
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
                    text: qsTr("ekke is BlackBerry Elite Developer and QtChampion.")
                }
            }
            RowLayout {
                Image {
                    source: "qrc:/images/extra/bb-elite.png"
                }
            }
            RowLayout {
                Image {
                    source: "qrc:/images/extra/qt_champion_small.png"
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
