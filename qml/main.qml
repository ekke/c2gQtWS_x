// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Window 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0
import "common"
import "pages"
import "popups"
import "tabs"
import "navigation"

// ekke (Ekkehard gentz) @ekkescorner
// this App was done in my rare spare time to support Qt community

ApplicationWindow {
    id: appWindow
    // running on mobiles you don't need width and height
    // ApplicationWindow will always fill entire screen
    // testing also on desktop it makes sense to set values
    width: 410
    height: 680

    property int safeWidth: width - unsafeArea.unsafeLeftMargin - unsafeArea.unsafeRightMargin
    property int safeHeight: height - unsafeArea.unsafeTopMargin - unsafeArea.unsafeBottomMargin

    // fills iPhone and iPad devices screen totally
    // ATTENTION: you must check for ios - if not, on Android the BACK key wasn't detected anymore !!
    flags: Qt.platform.os === "ios"? Qt.MaximizeUsingFullscreenGeometryHint : undefined

    // https://bugreports.qt.io/browse/QTBUG-64574
    // https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
    // TODO HowTo deal with Android - Notch - Devices ?
    property int lastOrientation: 0
    property int myOrientation: (Qt.platform.os === "ios")? Screen.orientation : 0
    onMyOrientationChanged: {
        if(lastOrientation === 0) {
            Screen.orientationUpdateMask = Qt.LandscapeOrientation | Qt.PortraitOrientation | Qt.InvertedLandscapeOrientation | Qt.InvertedPortraitOrientation
            console.log("First time orientation changes: set the mask to "+Screen.orientationUpdateMask)
            // detect the device to know about unsafe areas
            unsafeArea.configureDevice(Screen.height, Screen.width, Screen.devicePixelRatio)
            isTablet = unsafeArea.isKnownIPad()
        }
        // triggers unsafe areas and sets margins
        unsafeArea.orientationChanged(myOrientation)
        lastOrientation = myOrientation
    }

    // visibile must set to true - default is false
    visible: true

    signal doAutoVersionCheck()
    signal oldConference()
    signal conferenceSwitched()
    property bool autoVersionCheck: true
    //
    property Conference currentConference
    //
    property bool appIsActive: Qt.application.state === Qt.ApplicationActive
    onAppIsActiveChanged: {
        if(appIsActive) {
            if(autoVersionCheck && initDone) {
                console.log("App becomes active - we check again the version")
                appWindow.doAutoVersionCheck()
            }
        } else {
            if(autoVersionCheck) {
                console.log("App becomes inactive again - stop the version check timer")
                autoVersionCheckTimer.stop()
            }
        }
    }

    //
    property bool isLandscape: width > height
    // Samsung XCover3 has 320
    property bool isSmallDevice: !isLandscape && width < 360
    // iOS: set from configure unsafe areas (see above)
    property bool isTablet: false

    property bool backKeyfreezed: false
    property bool modalPopupActive: false
    property bool modalMenuOpen: false

    property bool myScheduleActive: false
    onMyScheduleActiveChanged: {
        if(myScheduleActive) {
            //navigationModel[2].icon = "schedule_my.png"
            drawerLoader.item.replaceIcon(scheduleNavigationIndex,"stars.png")
            drawerLoader.item.replaceText(scheduleNavigationIndex,qsTr("My Schedule"))
            favoritesLoader.item.replaceIcon(scheduleFavoritesIndex,"stars.png")
            favoritesLoader.item.replaceText(scheduleFavoritesIndex,qsTr("My Schedule"))
        } else {
            //navigationModel[2].icon = "schedule.png"
            drawerLoader.item.replaceIcon(scheduleNavigationIndex,"schedule.png")
            drawerLoader.item.replaceText(scheduleNavigationIndex,qsTr("Schedule"))
            favoritesLoader.item.replaceIcon(scheduleFavoritesIndex,"schedule.png")
            favoritesLoader.item.replaceText(scheduleFavoritesIndex,qsTr("Schedule"))
        }
    }

    // ONLINE - OFFLINE - NETWORK STATE
    property bool isOnline: dataServer.isOnline()
    // TODO include into palette
    property color titleBarOnlineColor: "LightGreen"
    property color titleBarOfflineColor: "Red"

    // primary and accent properties:
    property variant primaryPalette: myApp.defaultPrimaryPalette()
    property color primaryLightColor: primaryPalette[0]
    property color primaryColor: primaryPalette[1]
    property color primaryDarkColor: primaryPalette[2]
    property color textOnPrimaryLight: primaryPalette[3]
    property color textOnPrimary: primaryPalette[4]
    property color textOnPrimaryDark: primaryPalette[5]
    property string iconOnPrimaryLightFolder: primaryPalette[6]
    property string iconOnPrimaryFolder: primaryPalette[7]
    property string iconOnPrimaryDarkFolder: primaryPalette[8]
    property variant accentPalette: myApp.defaultAccentPalette()
    property color accentColor: accentPalette[0]
    property color textOnAccent: accentPalette[1]
    property string iconOnAccentFolder: accentPalette[2]
    Material.primary: primaryColor
    Material.accent: accentColor
    // theme Dark vs Light properties:
    property variant themePalette: myApp.defaultThemePalette()
    property color dividerColor: themePalette[0]
    property color cardAndDialogBackground: themePalette[1]
    property real primaryTextOpacity: themePalette[2]
    property real secondaryTextOpacity: themePalette[3]
    property real dividerOpacity: themePalette[4]
    property real iconActiveOpacity: themePalette[5]
    property real iconInactiveOpacity: themePalette[6]
    property string iconFolder: themePalette[7]
    property int isDarkTheme: themePalette[8]
    property color flatButtonTextColor: themePalette[9]
    property color popupTextColor: themePalette[10]
    property real toolBarActiveOpacity: themePalette[11]
    property real toolBarInactiveOpacity: themePalette[12]
    property color toastColor: themePalette[13]
    property real toastOpacity: themePalette[14]
    // 5.7: dropShadowColor is ok - the shadow is darker as the background
    // but not so easy to distinguish as in light theme
    // optional:
    // isDarkTheme? "#E4E4E4" : Material.dropShadowColor
    property color dropShadow: Material.dropShadowColor
    onIsDarkThemeChanged: {
        if(isDarkTheme == 1) {
            Material.theme = Material.Dark
        } else {
            Material.theme = Material.Light
        }
    }
    // font sizes - defaults from Google Material Design Guide
    property int fontSizeDisplay4: 112
    property int fontSizeDisplay3: 56
    property int fontSizeDisplay2: 45
    property int fontSizeDisplay1: 34
    property int fontSizeHeadline: 24
    property int fontSizeTitle: 20
    property int fontSizeSubheading: 16
    property int fontSizeBodyAndButton: 14 // is Default
    property int fontSizeCaption: 12
    property int fontSizeActiveNavigationButton: 14
    property int fontSizeInactiveNavigationButton: 12
    // fonts are grouped into primary and secondary with different Opacity
    // to make it easier to get the right property,
    // here's the opacity per size:
    property real opacityDisplay4: secondaryTextOpacity
    property real opacityDisplay3: secondaryTextOpacity
    property real opacityDisplay2: secondaryTextOpacity
    property real opacityDisplay1: secondaryTextOpacity
    property real opacityHeadline: primaryTextOpacity
    property real opacityTitle: primaryTextOpacity
    property real opacitySubheading: primaryTextOpacity
    // body can be both: primary or secondary text
    property real opacityBodyAndButton: primaryTextOpacity
    property real opacityBodySecondary: secondaryTextOpacity
    property real opacityCaption: secondaryTextOpacity
    // using Icons as Toggle to recognize 'checked'
    property real opacityToggleInactive: 0.2
    property real opacityToggleActive: 1.0
    //
    // TODO C++ ENUM
    // Destination
    // TabBar-SwipeView
    // StackView
    property var activationPolicy: {
        "NONE":0, "IMMEDIATELY":1, "LAZY":2, "WHILE_CURRENT":3
    }

    // NAVIGATION BAR PROPRTIES (a_p == activationPolicy)
    // IMMEDIATELY: Home
    // LAZY: customer, orders
    // WHILE_CURRENT: About, Settings
    // StackView: Home --> QtPage, Settings --> primary / Accent
    // if reordering adjust properties
    property int homeNavigationIndex: 0
    property int scheduleNavigationIndex: 2
    property int speakerNavigationIndex: 3
    property int tracksNavigationIndex: 4
    property int venueNavigationIndex: 5
    property int roomsNavigationIndex: 6
    property int settingsNavigationIndex: 8
    property int helpNavigationIndex: 8
    property int aboutNavigationIndex: 9
    property var navigationModel: [
        {"type": "../navigation/DrawerNavigationButton.qml", "name": "QtWS18", "icon": "home.png", "source": "../pages/HomePage.qml", "showCounter":false, "showMarker":false, "a_p":1, "canGoBack":false},
        {"type": "../navigation/DrawerDivider.qml", "name": "", "icon": "", "source": "", "a_p":1, "canGoBack":false},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Schedule"), "icon": "schedule.png", "source": "../navigation/ScheduleNavigation.qml", "showCounter":false, "showMarker":false, "a_p":2, "canGoBack":true},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Speakers"), "icon": "speaker.png", "source": "../navigation/SpeakerNavigation.qml", "showCounter":false, "showMarker":false, "a_p":2, "canGoBack":true},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": "Tracks", "icon": "tag.png", "source": "../navigation/TrackNavigation.qml", "showCounter":false, "showMarker":false, "a_p":2, "canGoBack":true},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": "Venue", "icon": "venue.png", "source": "../navigation/VenueNavigation.qml", "showCounter":false, "showMarker":false, "a_p":2, "canGoBack":true},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Rooms"), "icon": "directions.png", "source": "../navigation/RoomsNavigation.qml", "showCounter":false, "showMarker":false, "a_p":2, "canGoBack":true},
        {"type": "../navigation/DrawerDivider.qml", "name": "", "icon": "", "source": "", "a_p":1, "canGoBack":false},
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Help"), "icon": "help.png", "source": "../pages/HelpPage.qml", "showCounter":false, "showMarker":false, "a_p":3, "canGoBack":false},
        {"type": "../navigation/DrawerNavigationTextButton.qml", "name": qsTr("About this App"), "icon": "", "source": "../pages/AboutPage.qml", "showCounter":false, "showMarker":false, "a_p":3, "canGoBack":false}
    ]
    property bool initDone: false

    property var navigationTitles: [
        qsTr("Qt World Summit 2018"),
        "",
        qsTr("QtWS 2018 Schedule"),
        qsTr("QtWS 2018 Speakers"),
        qsTr("QtWS 2018 Tracks"),
        qsTr("QtWS 2018 Venue"),
        qsTr("QtWS 2018 Rooms"),
        "",
        qsTr("QtWS 2018 Help"),
        qsTr("QtWS 2018 About")
    ]
    property string currentTitle: navigationTitles[navigationIndex]
    // Counter: orders
    // Marker: customer
    property var navigationData: [
        {"counter":0, "marker":""},
        {},
        {"counter":0, "marker":""},
        {"counter":0, "marker":""},
        {"counter":0, "marker":""},
        {"counter":0, "marker":""},
        {"counter":0, "marker":""},
        {},
        {"counter":0, "marker":""},
        {"counter":0, "marker":""}
    ]
    // Menu Button
    // plus max 4 from drawer: home, customer, orders, settings
    // favoritesModel maps to index from navigationModel
    // if reordering adjust properties
    property int homeFavoritesIndex: 0
    property int scheduleFavoritesIndex: 1
    property int speakerFavoritesIndex: 2
    property int tracksFavoritesIndex: 3
    property var favoritesModel: [
        homeNavigationIndex, scheduleNavigationIndex, speakerNavigationIndex, tracksNavigationIndex
    ]
    property int firstActiveDestination: homeNavigationIndex
    property int navigationIndex: firstActiveDestination
    onNavigationIndexChanged: {
        rootPane.activateDestination(navigationIndex)
    }
    property alias navigationBar: drawerLoader.item

    property bool highlightActiveNavigationButton : true

    // NAVIGATION STYLE
    // for this app the navigation style, colors (primary, accent) and theme (dark, light) are fix
    property bool isClassicNavigationStyle: false
    property bool isBottomNavigationStyle: false
    property bool isComfortNavigationStyle: true
    property bool hasOnlyOneMenu: true

    // header per Page, footer global in Portrait + perhaps per Page, too
    // header and footer invisible until initDone
    footer: initDone && (!isLandscape || isTablet) && drawerLoader.status == Loader.Ready && navigationBar.position === 0 ? favoritesLoader.item : null
    header: (isLandscape && !useDefaultTitleBarInLandscape) || !initDone ? null : titleBar
    // show TITLE  BARS is delayed until INIT DONE
    property bool useDefaultTitleBarInLandscape: false
    Loader {
        id: titleBar
        visible: (!isLandscape || useDefaultTitleBarInLandscape) && initDone
        active: (!isLandscape || useDefaultTitleBarInLandscape) && initDone
        source: "navigation/DrawerTitleBar.qml"
    }
    // in LANDSCAPE header is null and we have a floating TitleBar
    Loader {
        id: titleBarFloating
        visible: !useDefaultTitleBarInLandscape && isLandscape && initDone
        active: !useDefaultTitleBarInLandscape && isLandscape && initDone
        source: "navigation/DrawerTitleBar.qml"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
    // end TITLE BARS
    function resetDefaultTitleBarInLandscape() {
        useDefaultTitleBarInLandscape = false
    }
    function setDefaultTitleBarInLandscape() {
        useDefaultTitleBarInLandscape = true
    }

    // STACK VIEW (rootPane)
    // the ROOT contains always only one Page,
    // which will be replaced if root node changed
    StackView {
        id: rootPane
        focus: true
        anchors.top: isLandscape ? titleBarFloating.bottom : parent.top
        anchors.left: parent.left
        anchors.topMargin: isLandscape ? 6 : 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // STACK VIEW TRANSITIONS
        replaceEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 300
            }
        }
        replaceExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 300
            }
        }
        // end STACKVIEW TRANSITIONS

        // STACK VIEW KEYS and SHORTCUTS
        // support of BACK key
        // can be used from StackView pushed on ROOT
        // or to exit the app
        // https://wiki.qt.io/Qt_for_Android_known_issues
        // By default the Back key will terminate Qt for Android apps, unless the key event is accepted.
        Keys.onBackPressed: {
            event.accepted = true
            if(appWindow.backKeyfreezed) {
                showToast(qsTr("Please wait. Back key not allowed at the moment."))
                return
            }
            if(appWindow.modalPopupActive) {
                showToast(qsTr("Back key not allowed - please select an option."))
                return
            }
            // we don't have to check for appWindow.modalMenuOpen
            // because my modal menus allow close by ESCAPE (== Android BACK key)
            if(!initDone) {
                return
            }

            if(navigationModel[navigationIndex].canGoBack && destinations.itemAt(navigationIndex).item.depth > 1) {
                destinations.itemAt(navigationIndex).item.goBack()
                return
            }
            if(initDone && navigationBar.position === 0) {
                openNavigationBar()
                return
            }
            if (Qt.platform.os === "android") {
                popupExitApp.open()
                return
            }
            showToast(qsTr("No more Pages"))
        }
        // TODO some Shortcuts
        // end STACK VIEW KEYS and SHORTCUTS

        // STACK VIEW INITIAL ITEM (BUSY INDICATOR)
        // immediately activated and pushed on stack as initialItem
        Loader {
            id: initialPlaceholder
            property bool isUpdate: false
            source: "pages/InitialItemPage.qml"
            active: true
            visible: false
            onLoaded: {
                // Show BUSY INDICATOR
                if(isUpdate) {
                    rootPane.replace(item)
                    item.update()
                    // now doing the UPDATE stuff
                    updateTimer.start()
                } else {
                    rootPane.initialItem = item
                    item.init()
                    // Now something is VISIBLE - do the other time-consuming stuff
                    startupDelayedTimer.start()
                }
            }
        }
        // end STACK VIEW INITIAL ITEM

        // U P D A T E
        Timer {
            id: updateTimer
            interval: 300
            repeat: false
            onTriggered: {
                // cleanup all running stuff in QML
                destinations.model = []
                // start update schedule (C++)
                dataUtil.startUpdate()
            }
        } // updateTimer
        function startUpdate() {
            myScheduleActive = false
            // remove drawer and bottom navigation
            initDone = false
            // replace root item
            initialPlaceholder.isUpdate = true
            // updateTimer started from initialPlaceholder
            initialPlaceholder.active = true
        }
        PopupUpdate {
            id: updatePopup
            modal: true
            closePolicy: Popup.NoAutoClose
            onClosed: {
                // read all data
                startupDelayedTimer.start()
            }
        } // updatePopup

        // update failed
        // auto version check remains same (manual or automatically)
        // if auto version check was done again after init
        function updateFailed(message) {
            dataUtil.reloadData()
            // info and reload prev stuff
            updatePopup.text = message
            updatePopup.buttonsVisible = true
            updatePopup.isUpdate = false
            updatePopup.open()
        }
        Timer {
            id: updateDoneTimer
            interval: 2500
            repeat: false
            onTriggered: {
                // read all data
                startupDelayedTimer.start()
            }
        } // updateTimer
        function updateDone() {
            // reset from manual check to auto check if update was success
            autoVersionCheck = true
            // read all data
            updateDoneTimer.start()
        }
        function showUpdateProgress(progressInfo) {
            initialPlaceholder.item.showProgress(progressInfo)
        }
        Connections {
            target: dataUtil
            onProgressInfo: rootPane.showUpdateProgress(progressInfo)
        }
        // also catched from HomePage
        Connections {
            target: dataUtil
            onUpdateDone: rootPane.updateDone()
        }
        Connections {
            target: dataUtil
            onUpdateFailed: rootPane.updateFailed(message)
        }
        // END   U P D A T E

        // DELAYED STARTUP TIMER
        // do the hevy stuff while initialItem is visible
        // initialize Data, create Navigation, make Title visible, ...
        Timer {
            id: startupDelayedTimer
            interval: 300
            repeat: false
            onTriggered: {
                console.log("startupDelayedTimer START")
                initialPlaceholder.item.showInfo("Initialize Data ...")
                if(!initialPlaceholder.isUpdate) {
                    dataManager.init()
                }
                dataUtil.setSessionFavorites()
                dataManager.resolveReferencesForAllSpeaker()
                dataManager.resolveReferencesForAllSession()
                dataUtil.resolveSessionsForSchedule()
                currentConference = dataUtil.currentConference()
                if(currentConference) {
                    console.log("QML Current Conference: "+currentConference.conferenceCity)
                } else {
                    console.log("No Conference ! - do the first Update now")
                }
                initialPlaceholder.item.showInfo("Create Navigation Controls ...")
                // inject model into Destinations Repeater
                console.log("now inject navigation model")
                destinations.model = navigationModel
                // show the Navigation Bars (Drawer and Favorites)
                initDone = true
                console.log("init DONE")
                // show first destination (should always be IMMEDIATELY)
                rootPane.activateDestination(firstActiveDestination)
                console.log("startupDelayedTimer DONE")
                if(dataUtil.isNoConference()) {
                    console.log("startupDelayedTimer: isNoConference")
                    appWindow.oldConference()
                    return
                }
                if(dataUtil.isOldConference()) {
                    console.log("startupDelayedTimer: isOldConference")
                    appWindow.oldConference()
                    return
                }
                if(dataUtil.isDateTooLate()) {
                    console.log("startupDelayedTimer: isDateTooLate")
                    // no version checks anymore - conference closed
                    return
                }
                if(appWindow.autoVersionCheck) {
                    console.log("now doing first Version Check from startup")
                    appWindow.doAutoVersionCheck()
                } else {
                    console.log("running in manual version check mode")
                }
            }
        }
        // will check for new versions every hour
        // as long as conference is ended
        Timer {
            id: autoVersionCheckTimer
            interval: 3600000 // 60*60*1000
            repeat: false
            onTriggered: {
                appWindow.doAutoVersionCheck()
            }
        }
        function startAutoVersionCheckTimer() {
            autoVersionCheckTimer.start()
        }
        function gotoFirstDestination() {
            navigationIndex = firstActiveDestination
        }

        // ASYNC STARTUP: Destinations will be loaded from Timer
        // that's why no model is attached at the beginning
        // startupDelayedTimer will set the model
        Repeater {
            id: destinations
            // model: navigationModel
            // Destination encapsulates Loader
            // depends from activationPolicy how to load dynamically
            Destination {
                id: destinationLoader
            }
            // Repeater creates all destinations (Loader)
            // all destinatation items w activationPolicy IMMEDIATELY are activated
        }

        // STACK VIEW (rootPane) FUNCTIONS
        // switch to new Destination
        // Destinations are lazy loaded via Loader
        function activateDestination(navigationIndex) {
            if(destinations.itemAt(navigationIndex).status === Loader.Ready) {
                console.log("replace item on root stack: "+navigationIndex)
                replaceDestination(destinations.itemAt(navigationIndex))
            } else {
                console.log("first time item to be replaced: "+navigationIndex)
                destinations.itemAt(navigationIndex).active = true
            }
        }
        // called from activeDestination() and also from Destination.onLoaded()
        function replaceDestination(theItemLoader) {
            var previousIndex = rootPane.currentItem.myIndex
            var previousItemLoader
            if(previousIndex >= 0) {
                previousItemLoader  = destinations.itemAt(previousIndex)
            }
            // because of https://bugreports.qt.io/browse/QTBUG-54260
            // remember currentIndex before being replaced
            console.log("replace destination for name: "+rootPane.currentItem.name)
            if(rootPane.currentItem.name === "ScheduleNavPage") {
                if(!appWindow.myScheduleActive) {
                    rootPane.currentItem.lastCurrentIndex = rootPane.currentItem.getCurrentIndex()
                    console.log("dayNavPage remember "+rootPane.currentItem.getCurrentIndex())
                }
            }
            // reset currentIndex to the last one
            if(theItemLoader.item.name === "ScheduleNavPage") {
                //theItemLoader.item.currentIndex = theItemLoader.item.lastCurrentIndex
                // the SwipeView is one level deeper, so we delegate this to the next StackView
                if(!appWindow.myScheduleActive) {
                    theItemLoader.item.setCurrentIndex()
                }
            }

            // here you can call work to be done if user changes destination
            // should also be called if app will be paused or exit
            if(rootPane.currentItem.name === "ScheduleNavPage") {
                // TODO do this for all stackViews on top of root StackView
                rootPane.currentItem.destinationAboutToChange()
            }

            // now replace the Page
            rootPane.replace(theItemLoader.item)
            // check if previous should be unloaded

            if(previousIndex >= 0) {
                if(destinations.itemAt(previousIndex).pageActivationPolicy === activationPolicy.WHILE_CURRENT) {
                    destinations.itemAt(previousIndex).active = false
                }
            } else {
                initialPlaceholder.active = false
            }
        }

        // example HowTo set a counter
        // first time called from startupDelayedTimer
        function updateOrderCounter() {
            //            var counter = dataManager.orderPropertyList.length
            //            navigationData[4].counter = counter
            //            navigationBar.navigationButtons.itemAt(4).item.counter = counter
        }
        // update counter if Orders deleted or added
        // connect C++ SIGNAL to QML SLOT
        //        Connections {
        //                target: dataManager
        //                onOrderPropertyListChanged: rootPane.updateOrderCounter()
        //            }

        // example HowTo set a marker
        function updateCustomerMarker(abc) {
            //            switch(abc) {
            //                case 0:
            //                    navigationData[3].marker = "green"
            //                    break;
            //                case 1:
            //                    navigationData[3].marker = "grey"
            //                    break;
            //                case 2:
            //                    navigationData[3].marker = "red"
            //                    break;
            //                default:
            //                    navigationData[3].marker = "transparent"
            //            }
            //            navigationBar.navigationButtons.itemAt(3).item.marker = navigationData[3].marker
        }
        // end STACKVIEW FUNCTIONS

    } // rootPane

    // INIT DONE: show TITLE and NAVIGATION BARS

    // NAVIGATION BARS (DRAWER and FAVORITES)
    // The sliding Drawer
    // there's an alias in appWindow: navigationBar --> drawerLoader.item
    Loader {
        id: drawerLoader
        active: initDone
        visible: initDone
        source: "navigation/DrawerNavigationBar.qml"
    }

    Loader {
        id: favoritesLoader
        active: initDone
        // attention: set also footer !
        visible: initDone && !isLandscape && drawerLoader.status == Loader.Ready && navigationBar.position === 0
        source: "navigation/DrawerFavoritesNavigationBar.qml"
    }
    function openNavigationBar() {
        navigationBar.open()
    }
    function closeNavigationBar() {
        navigationBar.close()
    }
    // end NAVIGATION BARS

    // APP WINDOW FUNCTIONS

    function switchPrimaryPalette(paletteIndex) {
        primaryPalette = myApp.primaryPalette(paletteIndex)
    }
    function switchAccentPalette(paletteIndex) {
        accentPalette = myApp.accentPalette(paletteIndex)
    }

    // we can loose the focus if Menu or Popup is opened
    function resetFocus() {
        rootPane.focus = true
    }

    function showToast(info) {
        popupToast.start(info)
    }
    function showError(info) {
        popupError.start(info)
    }

    function showInfo(info) {
        popupInfo.text = info
        popupInfo.buttonText = qsTr("OK")
        popupInfo.open()
    }
    // end APP WINDOW FUNCTIONS

    // APP WINDOW CONNECTIONS
    function onOnlineChanged(currentState) {
        console.log("QML ONLINE: "+currentState);
        appWindow.isOnline = currentState
    }

    Connections {
        target: dataServer
        onOnlineChanged: onOnlineChanged(currentState)
    }
    // end APP WINDOW CONNECTIONS

    // APP WINDOW POPUPS
    PopupExit {
        id: popupExitApp
        onAboutToHide: {
            popupExitApp.stopTimer()
            resetFocus()
            if(popupExitApp.isExit) {
                Qt.quit()
            }
        }
    } // popupExitApp

    PopupInfo {
        id: popupInfo
        onAboutToHide: {
            popupInfo.stopTimer()
            resetFocus()
        }
    } // popupInfo
    // PopupToast
    PopupToast {
        id: popupToast
        onAboutToHide: {
            resetFocus()
        }
    } // popupToast
    // PopupToast
    PopupError {
        id: popupError
        onAboutToHide: {
            resetFocus()
        }
    } // popupError
    // end APP WINDOW POPUPS

    // global Communication Menu to speed up
    function doCommunication(button, phoneNumber) {
        mainCommunicationMenu.doCommunication(button, phoneNumber)
    }
    CommunicationMenu {
        id: mainCommunicationMenu
    }

} // app window
