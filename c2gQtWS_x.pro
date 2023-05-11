# ekke (Ekkehard Gentz) @ekkescorner
TEMPLATE = app
TARGET = c2gQtWS_x

QT += qml quick core network
CONFIG += c++11

include(../../_qt_ws/statusbar/src/statusbar.pri)

# QT_NO_DEPRECATED_WARNINGS will show no deprecated warnings
# comment out and build-clean-project to see them all
# should be done from time to time
# while preparing src for Qt6
# DEFINES += QT_NO_DEPRECATED_WARNINGS

HEADERS += \
    cpp/applicationui.hpp \
    cpp/uiconstants.hpp \
    cpp/gen/SettingsData.hpp \ 
    cpp/gen/Conference.hpp \
    cpp/gen/DataManager.hpp \
    cpp/gen/Day.hpp \
    cpp/gen/Favorite.hpp \
    cpp/gen/PersonsAPI.hpp \
    cpp/gen/Room.hpp \
    cpp/gen/Session.hpp \
    cpp/gen/SessionAPI.hpp \
    cpp/gen/SessionTrack.hpp \
    cpp/gen/Speaker.hpp \
    cpp/gen/SpeakerAPI.hpp \
    cpp/gen/SpeakerImage.hpp \
    cpp/datautil.hpp \
    cpp/imageloader.hpp \
    cpp/gen/SessionTrackAPI.hpp \
    cpp/gen/SessionLists.hpp \
    cpp/dataserver.hpp \
    cpp/unsafearea.hpp

SOURCES += cpp/main.cpp \
    cpp/applicationui.cpp \
    cpp/gen/SettingsData.cpp \ 
    cpp/gen/Conference.cpp \
    cpp/gen/DataManager.cpp \
    cpp/gen/Day.cpp \
    cpp/gen/Favorite.cpp \
    cpp/gen/PersonsAPI.cpp \
    cpp/gen/Room.cpp \
    cpp/gen/Session.cpp \
    cpp/gen/SessionAPI.cpp \
    cpp/gen/SessionTrack.cpp \
    cpp/gen/Speaker.cpp \
    cpp/gen/SpeakerAPI.cpp \
    cpp/gen/SpeakerImage.cpp \
    cpp/datautil.cpp \
    cpp/imageloader.cpp \
    cpp/gen/SessionTrackAPI.cpp \
    cpp/gen/SessionLists.cpp \
    cpp/dataserver.cpp \
    cpp/unsafearea.cpp

# displays qml files in QML node in project tree
# easier to access vs Resources
OTHER_FILES +=  qml/main.qml \
    qml/common/*.qml \
    qml/navigation/*.qml \
    qml/pages/*.qml \
    qml/popups/*.qml \
    qml/tabs/*.qml

OTHER_FILES += images/black/*.png \
    images/black/x18/*.png \
    images/black/x36/*.png \
    images/black/x48/*.png \
    images/white/*.png \
    images/white/x18/*.png \
    images/white/x36/*.png \
    images/white/x48/*.png \
    images/extra/*.png \
    images/extra/*.jpg \
    translations/*.* \
    data-assets/*.json \
    data-assets/prod/*.json \
    data-assets/test/*.json \
    data-assets/conference/*.json \
    data-assets/conference/speakerImages/*.* \
    data-assets/conference/roomImages/*.* \
    data-assets/conference/floorplan/*.png \
    images/LICENSE \
    LICENSE \
    *.md \
    ios/*.png \
    ios/Images.xcassets/AppIcon.appiconset/*.*

RESOURCES += qml.qrc \
    translations.qrc \
    images.qrc \
    data-assets.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

# T R A N S L A T I O N S

# if languages are added:
# 1. rebuild project to generate *.qm
# 2. add existing .qm files to translations.qrc

# if changes to translatable strings:
# 1. Run Tools-External-Linguist-Update
# 2. Run Linguist and do translations
# 3. Build and run on iOS and Android to verify translations
# 4. Optional: if translations not done: Run Tools-External-Linguist-Release

# Supported languages
LANGUAGES = de en fr

# used to create .ts files
 defineReplace(prependAll) {
     for(a,$$1):result += $$2$${a}$$3
     return($$result)
 }
# Available translations
tsroot = $$join(TARGET,,,.ts)
tstarget = $$join(TARGET,,,_)
TRANSLATIONS = $$PWD/translations/$$tsroot
TRANSLATIONS += $$prependAll(LANGUAGES, $$PWD/translations/$$tstarget, .ts)
# run LRELEASE to generate the qm files
qtPrepareTool(LRELEASE, lrelease)
 for(tsfile, TRANSLATIONS) {
     command = $$LRELEASE $$tsfile
     system($$command)|error("Failed to run: $$command")
 }

DISTFILES += \
    gen-model/README.md \
    gen-model/*.pdf \
    gen-model/*.txt \
    gen-model/*.dtos \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    QT += androidextras

    # deploying 32-bit and 64-bit APKs you need different VersionCode
    # here's my way to solve this - per ex. Version 1.2.3
    # aabcddeef aa: 21 (MY_MIN_API), b: 0 (32 Bit) or 1 (64 Bit)  c: 0 (unused)
    # dd: 01 (Major Release), ee: 02 (Minor Release), f:  3 (Patch Release)
    # VersionName 1.2.3
    # VersionCode 32 Bit: 210001023
    # VersionCode 64 Bit: 211001023
    defineReplace(droidVersionCode) {
        segments = $$split(1, ".")
        for (segment, segments): vCode = "$$first(vCode)$$format_number($$segment, width=2 zeropad)"
        equals(ANDROID_ABIS, arm64-v8a): \
            prefix = 1
        else: equals(ANDROID_ABIS, armeabi-v7a): \
            prefix = 0
        else: prefix = 2
        # add more cases as needed
        return($$first(prefix)0$$first(vCode))
    }
    MY_VERSION = 2.3
    MY_PATCH_VERSION = 0
    MY_MIN_API = 21
    ANDROID_VERSION_NAME = $$MY_VERSION"."$$MY_PATCH_VERSION
    ANDROID_VERSION_CODE = $$MY_MIN_API$$droidVersionCode($$MY_VERSION)$$MY_PATCH_VERSION

    # find this in shadow build android-build gradle.properties
    ANDROID_MIN_SDK_VERSION = "21"
    ANDROID_TARGET_SDK_VERSION = "31"
}

ios {
    # framework needed for Reachability classes
    LIBS += -framework SystemConfiguration
    # Reachability to get reliable online state
    SOURCES += ios/src/Reachability.mm \
    ios/src/ReachabilityListener.mm

    QMAKE_INFO_PLIST = ios/Info.plist

    QMAKE_ASSET_CATALOGS = $$PWD/ios/Images.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    ios_artwork.files = $$files($$PWD/ios/iTunesArtwork*.png)
    QMAKE_BUNDLE_DATA += ios_artwork
    app_launch_screen.files = $$files($$PWD/ios/MyLaunchScreen.xib)
    QMAKE_BUNDLE_DATA += app_launch_screen

    QMAKE_IOS_DEPLOYMENT_TARGET = 12.0

    disable_warning.name = GCC_WARN_64_TO_32_BIT_CONVERSION
    disable_warning.value = NO
    QMAKE_MAC_XCODE_SETTINGS += disable_warning

    # QtCreator 4.3 provides an easy way to select the development team
    # see Project - Build - iOS Settings
    # I have to deal with different development teams,
    # so I include my signature here
    # ios_signature.pri not part of project repo because of private signature details
    # contains:
    # QMAKE_XCODE_CODE_SIGN_IDENTITY = "iPhone Developer"
    # MY_DEVELOPMENT_TEAM.name = DEVELOPMENT_TEAM
    # MY_DEVELOPMENT_TEAM.value = your team Id from Apple Developer Account
    # QMAKE_MAC_XCODE_SETTINGS += MY_DEVELOPMENT_TEAM

    # include(ios_signature.pri)

    # see https://bugreports.qt.io/browse/QTBUG-70072
    QMAKE_TARGET_BUNDLE_PREFIX = org.ekkescorner
    QMAKE_BUNDLE = c2g.qtws

    # Note for devices: 1=iPhone, 2=iPad, 1,2=Universal.
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2
}
# do not move to other location in .pro
# otherwise build settings can loose the info
android: include(/Applications/daten/_android/android-sdk-26_1_1/android_openssl/openssl.pri)
