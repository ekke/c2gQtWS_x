// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0

import "../common"

ScrollView {
    id: flickable
    // index to get access to Loader (Destination)
    property int myIndex: index
    contentHeight: appWindow.height
    contentWidth: appWindow.width
    // StackView manages this, so please no anchors here
    // anchors.fill: parent
    property string name: "VenuePage"

    Pane {
        id: root
        anchors.fill: parent
        topPadding: 0
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
        Image {
            id: conferenceImage
            property real portraitScale: 1.0
            property real landscapeScale: 1.0
            scale: isLandscape? landscapeScale : portraitScale
            anchors.top: parent.top
            anchors.topMargin: isLandscape? 16 : undefined
            anchors.left: parent.left
            width: sourceSize.width
            height: sourceSize.height
            fillMode: Image.PreserveAspectFit
            source: currentConference? currentConference.id === 201801? "qrc:/data-assets/conference/floorplan/QtWS2018_Boston.png" : "qrc:/data-assets/conference/floorplan/QtWS2018_Berlin.png" : ""
            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop
            transformOrigin: Item.TopLeft
        } // image

        ColumnLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            transform: Translate {
                x: isLandscape ? conferenceImage.width*conferenceImage.scale:0
                y: isLandscape? 0 : conferenceImage.height*conferenceImage.scale
            } // translate

            RowLayout {
                LabelTitle {
                    topPadding: 16
                    leftPadding: 16
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: "QtWS2018 in " + currentConference.conferenceCity
                    color: accentColor
                }
            }
            RowLayout {
                LabelTitle {
                    leftPadding: 16
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: currentConference.address
                    color: primaryColor
                }
            }
            RowLayout {
                LabelSubheading {
                    topPadding: 10
                    leftPadding: 16
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: "<a href=\"" + currentConference.homePage + qsTr("\">Conference Homepage") + "</a>"
                    onLinkActivated: Qt.openUrlExternally(currentConference.homePage)
                }
            }
            RowLayout {
                LabelSubheading {
                    topPadding: 10
                    leftPadding: 16
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: "<a href=\"" + currentConference.homePage + qsTr("\">See in Google Maps") + "</a>"
                    onLinkActivated: Qt.openUrlExternally("https://www.google.com/maps/search/?api=1&query="+currentConference.coordinate+"&query_place_id="+currentConference.placeId)
                }
            }
            RowLayout {
                LabelSubheading {
                    topPadding: 10
                    leftPadding: 16
                    rightPadding: 10
                    wrapMode: Text.WordWrap
                    text: "<a href=\"" + currentConference.homePage + qsTr("\">See in Apple Map") + "</a>"
                    onLinkActivated: Qt.openUrlExternally("http://maps.apple.com/maps/?sll="+currentConference.coordinate+"&address="+currentConference.mapAddress)
                }
            }
        } // col layout
    } // root
    // ScrollIndicator.vertical: ScrollIndicator { }

    // emitting a Signal could be another option
    Component.onDestruction: {
        cleanup()
    }

    function fitIntoWindow() {
        var portraitWidth = Math.min(appWindow.width,appWindow.height)
        var portraitHeight = Math.max(appWindow.width,appWindow.height)-60
        var portraitWidthScale = portraitWidth / conferenceImage.sourceSize.width
        var portraitHeightScale = portraitHeight / conferenceImage.sourceSize.height
        conferenceImage.portraitScale = Math.min(portraitWidthScale, portraitHeightScale)
        var landscapeWidth = Math.max(appWindow.width,appWindow.height)-300
        var landscapeHeight = Math.min(appWindow.width,appWindow.height)-80
        var landscapeWidthScale = landscapeWidth / conferenceImage.sourceSize.width
        var landscapeHeightScale = landscapeHeight / conferenceImage.sourceSize.height
        conferenceImage.landscapeScale = Math.min(landscapeWidthScale, landscapeHeightScale)
        //flickable.contentX = 0
        //flickable.contentY = 0
        console.log("Portrait HEIGHT "+portraitHeight)
        console.log("Portrait WIDTH "+portraitWidth)
    }

    // called immediately after Loader.loaded
    function init() {
        fitIntoWindow()
        console.log("Init done from VenuePage")
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from VenuePage")
    }
} // flickable
