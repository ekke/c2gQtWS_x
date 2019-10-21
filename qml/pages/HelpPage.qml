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
    property string name: "Help"

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
                    text: qsTr("Conference2Go\nQtWS 2019\nBerlin + Tokyo\n(Qt 5.13.1 - Android + iOS)")
                    color: primaryColor
                }
                LabelHeadline {
                    visible: Qt.platform.os === "ios"
                    leftPadding: 10
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: qsTr("Conference2Go\nQtWS 2019\nBerlin + Tokyo\n(Qt 5.13.1 crossplatform)")
                    color: primaryColor
                }
            }
            HorizontalDivider {}
            LabelTitle {
                leftPadding: 10
                text: qsTr("Misc")
                color: accentColor
            }
            HelpRow {
                iconName: "menu.png"
                helpText: qsTr("Menu Button: Opens the Drawer. Drawer can also be opened with Gestures: swiping from left site.")
            }
            HelpRow {
                iconName: "more_vert.png"
                helpText: qsTr("Options Button: Opens a Menu with some options.")
            }
            HelpRow {
                iconName: "arrow_back.png"
                helpText: qsTr("Back Button: Top/Left from TitleBar goes one Page back. On Android you can also use OS - specific Back Button below the Page.")
            }
            HelpRow {
                iconName: "list.png"
                helpText: qsTr("Speed Navigation: Back to the List below in the stack without the need to move fingers to Top/Left Back Button.")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("QtWS 2019")
                color: accentColor
            }
            HelpRow {
                iconName: "home.png"
                helpText: qsTr("Homepage - the first Page. QtWS 2019 App supports both 2019 conferences in Berlin and Tokyo. Form this Page you can switch between Conferences.")
            }
            HelpRow {
                iconName: "refresh.png"
                helpText: qsTr("QtWS checks automatically if an Update is required. To start Schedule- and Speaker Updates manually please tap on the Refresh Button. This Button is only visible if you rejected Auto - Update")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("Schedule")
                color: accentColor
            }
            HelpRow {
                iconName: "schedule.png"
                helpText: qsTr("Complete Conference Schedule separated by Days and sorted by Starttime. Switch between Conference Days by Swiping left/right or tapping on a Tab from Tab Bar.")
            }
            HelpRow {
                iconName: "stars.png"
                helpText: qsTr("Button to see your Personal Conference Schedule. Mark Sessions for your Personal Schedule by checking the Favorites Button.")
            }
            HelpRow {
                iconName: "goto.png"
                helpText: qsTr("There are many Sessions listed for a Day - to make it easier to jump to a specific Timeslot tap on this Button and select the Time.")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("Speaker")
                color: accentColor
            }
            HelpRow {
                iconName: "speaker.png"
                helpText: qsTr("List of all Speakers sorted by Last Name. This List contains Speakers from both Conferences (Boston, Berlin)")
            }
            HelpRow {
                iconName: "goto.png"
                helpText: qsTr("To find a specific Speaker tap on this Button and select the Letter.")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("Tracks")
                color: accentColor
            }
            HelpRow {
                iconName: "tag.png"
                helpText: qsTr("List of all Conference Tracks. Tap on a row to see all Sessions of selected Track.")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("Venue")
                color: accentColor
            }
            HelpRow {
                iconName: "venue.png"
                helpText: qsTr("Informations and Address of the Venue.")
            }
            HelpRow {
                iconName: "directions.png"
                helpText: qsTr("List of all Rooms. Tap on a Row to see all Sessions running in this Room. Tap on the Thumbnail to see the Floorplan of the selected Room.")
            }
            LabelTitle {
                leftPadding: 10
                text: qsTr("Sessions")
                color: accentColor
            }
            HelpRow {
                iconName: "stars.png"
                helpText: qsTr("The Favorites Button. Tap on it to mark a Session and to add this to your Personal Schedule. Button is a Toggle - tap again to remove from your Personal Schedule.")
            }
            HelpRow {
                iconName: "directions.png"
                helpText: qsTr("See the Floorplan of the Room where the Session runs.")
            }
            HelpRow {
                iconName: "calendar.png"
                helpText: qsTr("Conference Date.")
            }
            HelpRow {
                iconName: "time.png"
                helpText: qsTr("Session Time from - to.")
            }
            HorizontalDivider {}
            LabelSubheading {
                leftPadding: 10
                rightPadding: 16
                text: qsTr("Need more Infos ?\nFollow @ekkescorner at Twitter\nfollow ekkes blogs:\nhttp://appbus.org and http://ekkes-corner.org")
                font.italic: true
                wrapMode: Text.WordWrap
            }
        } // col layout
    } // root
    ScrollIndicator.vertical: ScrollIndicator { }

    // emitting a Signal could be another option
    Component.onDestruction: {
        cleanup()
    }

    // called immediately after Loader.loaded
    function init() {
        console.log("Init done from HELP")
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from HELP")
    }
} // flickable
