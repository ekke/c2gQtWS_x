// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0
import "../common"

Page {
    id: speakerListPage
    focus: true
    property string name: "SpeakerListPage"
    bottomPadding: 6
    topPadding: 6

    // SECTION HEADER
    Component {
        id: sectionHeading
        ColumnLayout {
            width: parent.width
            LabelTitle {
                topPadding: 6
                bottomPadding: 6
                leftPadding: 16
                text: section
                // anchors.verticalCenter: parent.verticalCenter
                Layout.alignment: Qt.AlignVCenter
                color: primaryColor
                font.bold: true
            }
            HorizontalListDivider{}
        } // col layout
    }

    // LIST ROW DELEGTE
    Component {
        id: speakerRowComponent
        ItemDelegate {
            id: theItem
            height: speakerRow.height
            implicitWidth: appWindow.safeWidth
            onClicked: {
                navPane.pushSpeakerDetail(model.modelData.speakerId)
            }
            ColumnLayout {
                id: speakerRow
                // without this divider not over total width
                implicitWidth: appWindow.safeWidth
                RowLayout {
                    spacing: 20
                    Layout.leftMargin: 16+12
                    Layout.rightMargin: 6
                    Layout.topMargin: 6
                    SpeakerImageItem {
                        speaker: model.modelData
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        // without setting a maximum width, word wrap not working
                        Layout.maximumWidth: appWindow.width-140
                        spacing: 0
                        LabelSubheading {
                            rightPadding: 12
                            text: model.modelData.name.length? model.modelData.name : qsTr("Unnamed Speaker")
                            font.bold: true
                            wrapMode: Label.WordWrap
                        } // label
                        LabelBody {
                            visible: model.modelData.title.length > 0
                            bottomPadding: 6
                            rightPadding: 12
                            text: model.modelData.title
                            wrapMode: Label.WordWrap
                            maximumLineCount: 2
                            elide: Label.ElideRight
                            font.italic: true
                        }

                        LabelBody {
                            rightPadding: 12
                            text: dataUtil.sessionInfoForSpeaker(model.modelData)
                            wrapMode: Label.WordWrap
                            maximumLineCount: 3
                            elide: Label.ElideRight
                        }
                    }
                } // end Row Layout
                HorizontalListDivider{}
            } // end Col Layout speaker row
        } // item delegate
    } // speakerRowComponent

    // LIST VIEW
    ListView {
        id: listView
        focus: true
        clip: true
        // highlight: Rectangle {color: Material.listHighlightColor }
        currentIndex: -1
        anchors.fill: parent
        // setting the margin to be able to scroll the list above the FAB to use the Switch on last row
        // bottomMargin: 40
        // QList<Speaker*>
        //model: dataManager.speakerPropertyList

        delegate: speakerRowComponent
        // header: headerComponent
        // in Landscape header scrolls away
        // in protrait header always visible
        // headerPositioning: isLandscape? ListView.PullBackHeader : ListView.OverlayHeader

        section.property: "sortGroup"
        section.criteria: ViewSection.FullString
        section.delegate: sectionHeading

        ScrollIndicator.vertical: ScrollIndicator { }
    } // end listView

    function goToItemIndex(theIndex) {
        if(theIndex === -1) {
            return
        }
        if(theIndex > 0) {
            theIndex = theIndex-1
        }

        listView.positionViewAtIndex(theIndex, ListView.Beginning)
    }

    Component.onDestruction: {
        cleanup()
    }

    // called immediately after Loader.loaded
    function init() {
        console.log("Init done from SpeakerListPage")
        console.log("Speaker# "+dataManager.speakerPropertyList.length)
        listView.model = dataManager.speakerPropertyList
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from SpeakerListPage")
    }
} // end primaryPage
