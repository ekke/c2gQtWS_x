// ekke (Ekkehard Gentz) @ekkescorner
#include "applicationui.hpp"
#include "uiconstants.hpp"

#include <QtQml>
#include <QGuiApplication>

#include <QJsonObject>
#include <QFile>

#include <QDebug>

#include <statusbar.h>

const QString settingsDataFile = "/settingsData.json";

using namespace ekke::constants;

ApplicationUI::ApplicationUI(QObject *parent) : QObject(parent), mDataManager(new DataManager(this)), mDataUtil(new DataUtil(this)),
    mDataServer(new DataServer(this)), mUnsafeArea(new UnsafeArea(this))
{
    mSettingsData = mDataManager->settingsData();

    mDataServer->init(mDataManager);
    mDataUtil->init(mDataManager, mDataServer);

    mCachingDone = false;
    mCachingInWork = false;

    qmlRegisterType<StatusBar>("StatusBar", 0, 1, "StatusBar");

}

void ApplicationUI::addContextProperty(QQmlContext *context)
{
    context->setContextProperty("dataManager", mDataManager);
    context->setContextProperty("dataUtil", mDataUtil);
    context->setContextProperty("dataServer", mDataServer);
    context->setContextProperty("unsafeArea", mUnsafeArea);
}

/* Change Theme Palette */
QStringList ApplicationUI::swapThemePalette()
{
    mSettingsData->setDarkTheme(!mSettingsData->darkTheme());
    if (mSettingsData->darkTheme()) {
        return darkPalette;
    }
    return lightPalette;
}

/* Get current default Theme Palette */
QStringList ApplicationUI::defaultThemePalette()
{
    if (mSettingsData->darkTheme()) {
        return darkPalette;
    }
    return lightPalette;
}

/* Get one of the Primary Palettes */
QStringList ApplicationUI::primaryPalette(const int paletteIndex)
{
    mSettingsData->setPrimaryColor(paletteIndex);
    switch (paletteIndex) {
    case 0:
        return materialRed;
    case 1:
        return materialPink;
    case 2:
        return materialPurple;
    case 3:
        return materialDeepPurple;
    case 4:
        return materialIndigo;
    case 5:
        return materialBlue;
    case 6:
        return materialLightBlue;
    case 7:
        return materialCyan;
    case 8:
        return materialTeal;
    case 9:
        return materialGreen;
    case 10:
        return materialLightGreen;
    case 11:
        return materialLime;
    case 12:
        return materialYellow;
    case 13:
        return materialAmber;
    case 14:
        return materialOrange;
    case 15:
        return materialDeepOrange;
    case 16:
        return materialBrown;
    case 17:
        return materialGrey;
    default:
        return materialBlueGrey;
    }
}

/* Get one of the Accent Palettes */
QStringList ApplicationUI::accentPalette(const int paletteIndex)
{
    mSettingsData->setAccentColor(paletteIndex);
    int currentPrimary = mSettingsData->primaryColor();
    QStringList thePalette = primaryPalette(paletteIndex);
    mSettingsData->setPrimaryColor(currentPrimary);
    // we need: primaryColor, textOnPrimary, iconOnPrimaryFolder
    return QStringList{thePalette.at(1), thePalette.at(4), thePalette.at(7)};
}

/* Get Default Primary Palette */
QStringList ApplicationUI::defaultPrimaryPalette()
{
    // fix - no settings in this app
    // mSettingsData->primaryColor()
    return primaryPalette(9);
}

/* Get Default Accent Palette */
QStringList ApplicationUI::defaultAccentPalette()
{
    // fix no settings in this app
    // mSettingsData->accentColor()
    // also changed from 15 (Deep orange) to 4 (Indigo)
    return accentPalette(4);
}

bool ApplicationUI::isDebugBuild()
{
#ifdef QT_DEBUG
    return true;
#else
    qDebug() << "Running a RELEASE build";
    return false;
#endif
}


// ATTENTION
// iOS: NO SIGNAL
// Android: SIGNAL if leaving the App with Android BACK Key
// Android: NO SIGNAL if using HOME or OVERVIEW and THEN CLOSE from there
void ApplicationUI::onAboutToQuit()
{
    qDebug() << "On About to Q U I T Signal received";
    startCaching();
}

void ApplicationUI::onApplicationStateChanged(Qt::ApplicationState applicationState)
{
    qDebug() << "S T A T E changed into: " << applicationState;
    if(applicationState == Qt::ApplicationState::ApplicationSuspended) {
        startCaching();
        return;
    }
    if(applicationState == Qt::ApplicationState::ApplicationActive) {
        resetCaching();
    }
}

void ApplicationUI::resetCaching()
{
    if(mCachingInWork) {
        qDebug() << "no reset caching - already in work";
        return;
    }
    qDebug() << "reset caching";
    mCachingDone = false;
}

void ApplicationUI::startCaching()
{
    if(mCachingInWork || mCachingDone) {
        qDebug() << "no start caching - already in work ? " << mCachingInWork << " done ? " << mCachingDone;
        return;
    }
    doCaching();
}

void ApplicationUI::doCaching()
{
    qDebug() << "DO Caching BEGIN";
    mCachingInWork = true;
    mCachingDone = false;

    mDataUtil->saveSessionFavorites();
    mDataManager->finish();

    mCachingInWork = false;
    mCachingDone = QGuiApplication::applicationState() != Qt::ApplicationState::ApplicationActive;
    qDebug() << "DO Caching END - Done ? " << mCachingDone;
}



