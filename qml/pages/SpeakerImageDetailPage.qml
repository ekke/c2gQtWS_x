// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0

import "../common"

Page {
    id: speakerImageDetailPage
    focus: true
    property string name: "SpeakerImageDetailPage"

    property SpeakerImage speakerImage

    property string assetsSource: "qrc:/data-assets/conference/speakerImages/speaker_"
    property string dataSource: dataUtil.conferenceDataPath4QML()+"speakerImages/speaker_"

    property int speakerImageId: -2
    onSpeakerImageIdChanged: {
        if(speakerImageId > 0) {
            speakerImage = dataManager.findSpeakerImageBySpeakerId(speakerImageId)
        }
    }

    Flickable {
        id: flickable
        property string name: "speakerImageDetail"
        // need some extra space if scrolling to bottom
        // and nothing covered by the FAB
        contentHeight: theImage.sourceSize.height * theImage.scale + 60
        contentWidth: theImage.sourceSize.width * theImage.scale
        anchors.fill: parent

            Image {
                id: theImage
                anchors.top: parent.top
                anchors.left: parent.left
                width: sourceSize.width
                height: sourceSize.height
                fillMode: Image.PreserveAspectFit
                source: speakerImage.inAssets? assetsSource+speakerImage.speakerId+"_origin."+speakerImage.suffix
                                : speakerImage.inData? dataSource+speakerImage.speakerId+"_origin."+speakerImage.suffix : ""
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignTop
                transformOrigin: Item.TopLeft
                transform: Translate { y: 6; x:6 }
            } // image


    } // flickable

    FloatingActionMiniButton {
        visible: theImage.scale >= 0.2
        property string imageName: "/remove.png"
        z: 1
        anchors.leftMargin: 20
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        imageSource: "qrc:/images/"+iconOnAccentFolder+imageName
        backgroundColor: accentColor
        showShadow: true
        onClicked: {
            theImage.scale = theImage.scale - 0.2
        }
    } // FAB
    FloatingActionMiniButton {
        property string imageName: "/aspect_ratio.png"
        z: 1
        anchors.leftMargin: 80
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        imageSource: "qrc:/images/"+iconOnAccentFolder+imageName
        backgroundColor: accentColor
        showShadow: true
        onClicked: {
            fitIntoWindow()
        }
    } // FAB
    FloatingActionMiniButton {
        visible: theImage.scale <= 1.0
        property string imageName: "/add.png"
        z: 1
        anchors.leftMargin: 140
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        imageSource: "qrc:/images/"+iconOnAccentFolder+imageName
        backgroundColor: accentColor
        showShadow: true
        onClicked: {
            theImage.scale = theImage.scale + 0.2
        }
    } // FAB

    function fitIntoWindow() {
        var widthScale = (appWindow.safeWidth-20) / theImage.sourceSize.width
        var heightScale = (appWindow.safeHeight-20) / theImage.sourceSize.height
        theImage.scale = Math.min(widthScale, heightScale)
        flickable.contentX = 0
        flickable.contentY = 0
    }

    Component.onDestruction: {
        cleanup()
    }

    // called immediately after Loader.loaded
    function init() {
        fitIntoWindow()
        console.log("Init done from SpeakerImageDetailPage")
        appWindow.setDefaultTitleBarInLandscape()
    }
    // called from Component.destruction
    function cleanup() {
        console.log("Cleanup done from SpeakerImageDetailPage")
        appWindow.resetDefaultTitleBarInLandscape()
    }

} // speakerImageDetailPage
