// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import "../common"
import "../tabs"

Page {
    id: navSwipePage
    // index to get access to Loader (Destination)
    property int myIndex: index
    property string name: "dayNavPage"

    // because of https://bugreports.qt.io/browse/QTBUG-54260
    // lastCurrentIndex will remember currentIndex, so we can reset before Page becomes currentItem on StackView
    property int lastCurrentIndex: 0

    property alias currentIndex: navSwipePane.currentIndex

    function goToIndex(theItemIndex) {
        dayPagerepeater.itemAt(currentIndex).goToItemIndex(theItemIndex)
    }

    property bool tabBarIsFixed: true

    header: ScheduleTabBar {
        id: tabBar
        currentIndex: navSwipePane.currentIndex
    }

    SwipeView {
        id: navSwipePane
        focus: true
        anchors.top: parent.top
        anchors.topMargin: isLandscape? 6 : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        currentIndex: 0
        // currentIndex is the NEXT index swiped to
        onCurrentIndexChanged: {
            console.log("Day Swipe View current index changed: "+currentIndex)
            if(tabBar.currentIndex !== currentIndex) {
                tabBar.currentIndex = currentIndex
            }
        }

        function goToPage(pageIndex) {
            if(pageIndex == navSwipePane.currentIndex) {
                // it's the current page
                return
            }
            if(pageIndex > (currentConference.daysPropertyList.length-1) || pageIndex < 0) {
                return
            }
            navSwipePane.currentIndex = pageIndex
        } // goToPage

        // only less Pages - all preloaded
        Repeater {
            id: dayPagerepeater
            model: currentConference.daysPropertyList.length
            DayPage {
                dayIndex: index
                conferenceDay: currentConference.daysPropertyList[index]
                theModel: conferenceDay.sessionsPropertyList
            }
        } // day repeater

    } // navSwipePane

    // emitting a Signal could be another option
    Component.onDestruction: {
        cleanup()
    }

    function init() {
        console.log("INIT day DaySwiperPage")
        console.log("conference: "+ currentConference.conferenceCity)
        console.log("days: "+ currentConference.daysPropertyList.length)
    }
    function cleanup() {
        console.log("CLEANUP DaySwiperPage")
    }

} // navSwipePage
