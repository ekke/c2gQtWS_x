#include "GenericScheduleItem.hpp"
#include <QDebug>
#include <quuid.h>
// target also references to this
#include "Session.hpp"

// keys of QVariantMap used in this APP
static const QString sessionIdKey = "sessionId";
static const QString isBreakKey = "isBreak";
static const QString isLunchKey = "isLunch";
static const QString isEventKey = "isEvent";
static const QString isRegistrationKey = "isRegistration";
static const QString sessionKey = "session";

// keys used from Server API etc
static const QString sessionIdForeignKey = "sessionId";
static const QString isBreakForeignKey = "isBreak";
static const QString isLunchForeignKey = "isLunch";
static const QString isEventForeignKey = "isEvent";
static const QString isRegistrationForeignKey = "isRegistration";
static const QString sessionForeignKey = "session";

/*
 * Default Constructor if GenericScheduleItem not initialized from QVariantMap
 */
GenericScheduleItem::GenericScheduleItem(QObject *parent) :
        QObject(parent), mSessionId(-1), mIsBreak(false), mIsLunch(false), mIsEvent(false), mIsRegistration(false)
{
	// lazy references:
	mSession = -1;
	mSessionAsDataObject = 0;
	mSessionInvalid = false;
}

bool GenericScheduleItem::isAllResolved()
{
	if (hasSession() && !isSessionResolvedAsDataObject()) {
		return false;
	}
    return true;
}

/*
 * initialize GenericScheduleItem from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses own property names
 * corresponding export method: toMap()
 */
void GenericScheduleItem::fillFromMap(const QVariantMap& genericScheduleItemMap)
{
	mSessionId = genericScheduleItemMap.value(sessionIdKey).toInt();
	mIsBreak = genericScheduleItemMap.value(isBreakKey).toBool();
	mIsLunch = genericScheduleItemMap.value(isLunchKey).toBool();
	mIsEvent = genericScheduleItemMap.value(isEventKey).toBool();
	mIsRegistration = genericScheduleItemMap.value(isRegistrationKey).toBool();
	// session lazy pointing to Session* (domainKey: sessionId)
	if (genericScheduleItemMap.contains(sessionKey)) {
		mSession = genericScheduleItemMap.value(sessionKey).toInt();
		if (mSession != -1) {
			// resolve the corresponding Data Object on demand from DataManager
		}
	}
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses foreign property names - per ex. from Server API
 * corresponding export method: toForeignMap()
 */
void GenericScheduleItem::fillFromForeignMap(const QVariantMap& genericScheduleItemMap)
{
	mSessionId = genericScheduleItemMap.value(sessionIdForeignKey).toInt();
	mIsBreak = genericScheduleItemMap.value(isBreakForeignKey).toBool();
	mIsLunch = genericScheduleItemMap.value(isLunchForeignKey).toBool();
	mIsEvent = genericScheduleItemMap.value(isEventForeignKey).toBool();
	mIsRegistration = genericScheduleItemMap.value(isRegistrationForeignKey).toBool();
	// session lazy pointing to Session* (domainKey: sessionId)
	if (genericScheduleItemMap.contains(sessionForeignKey)) {
		mSession = genericScheduleItemMap.value(sessionForeignKey).toInt();
		if (mSession != -1) {
			// resolve the corresponding Data Object on demand from DataManager
		}
	}
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * excludes transient values
 * uses own property names
 * corresponding export method: toCacheMap()
 */
void GenericScheduleItem::fillFromCacheMap(const QVariantMap& genericScheduleItemMap)
{
	mSessionId = genericScheduleItemMap.value(sessionIdKey).toInt();
	mIsBreak = genericScheduleItemMap.value(isBreakKey).toBool();
	mIsLunch = genericScheduleItemMap.value(isLunchKey).toBool();
	mIsEvent = genericScheduleItemMap.value(isEventKey).toBool();
	mIsRegistration = genericScheduleItemMap.value(isRegistrationKey).toBool();
	// session lazy pointing to Session* (domainKey: sessionId)
	if (genericScheduleItemMap.contains(sessionKey)) {
		mSession = genericScheduleItemMap.value(sessionKey).toInt();
		if (mSession != -1) {
			// resolve the corresponding Data Object on demand from DataManager
		}
	}
}

void GenericScheduleItem::prepareNew()
{
}

/*
 * Checks if all mandatory attributes, all DomainKeys and uuid's are filled
 */
bool GenericScheduleItem::isValid()
{
	if (mSessionId == -1) {
		return false;
	}
	// session lazy pointing to Session* (domainKey: sessionId)
	if (mSession == -1) {
		return false;
	}
	return true;
}
	
/*
 * Exports Properties from GenericScheduleItem as QVariantMap
 * exports ALL data including transient properties
 * To store persistent Data in JsonDataAccess use toCacheMap()
 */
QVariantMap GenericScheduleItem::toMap()
{
	QVariantMap genericScheduleItemMap;
	// session lazy pointing to Session* (domainKey: sessionId)
	if (mSession != -1) {
		genericScheduleItemMap.insert(sessionKey, mSession);
	}
	genericScheduleItemMap.insert(sessionIdKey, mSessionId);
	genericScheduleItemMap.insert(isBreakKey, mIsBreak);
	genericScheduleItemMap.insert(isLunchKey, mIsLunch);
	genericScheduleItemMap.insert(isEventKey, mIsEvent);
	genericScheduleItemMap.insert(isRegistrationKey, mIsRegistration);
	return genericScheduleItemMap;
}

/*
 * Exports Properties from GenericScheduleItem as QVariantMap
 * To send data as payload to Server
 * Makes it possible to use defferent naming conditions
 */
QVariantMap GenericScheduleItem::toForeignMap()
{
	QVariantMap genericScheduleItemMap;
	// session lazy pointing to Session* (domainKey: sessionId)
	if (mSession != -1) {
		genericScheduleItemMap.insert(sessionForeignKey, mSession);
	}
	genericScheduleItemMap.insert(sessionIdForeignKey, mSessionId);
	genericScheduleItemMap.insert(isBreakForeignKey, mIsBreak);
	genericScheduleItemMap.insert(isLunchForeignKey, mIsLunch);
	genericScheduleItemMap.insert(isEventForeignKey, mIsEvent);
	genericScheduleItemMap.insert(isRegistrationForeignKey, mIsRegistration);
	return genericScheduleItemMap;
}


/*
 * Exports Properties from GenericScheduleItem as QVariantMap
 * transient properties are excluded:
 * To export ALL data use toMap()
 */
QVariantMap GenericScheduleItem::toCacheMap()
{
	// no transient properties found from data model
	// use default toMao()
	return toMap();
}
// REF
// Lazy: session
// Mandatory: session
// session lazy pointing to Session* (domainKey: sessionId)
int GenericScheduleItem::session() const
{
	return mSession;
}
Session* GenericScheduleItem::sessionAsDataObject() const
{
	return mSessionAsDataObject;
}
void GenericScheduleItem::setSession(int session)
{
	if (session != mSession) {
        // remove old Data Object if one was resolved
        if (mSessionAsDataObject) {
            // reset pointer, don't delete the independent object !
            mSessionAsDataObject = 0;
        }
        // set the new lazy reference
        mSession = session;
        mSessionInvalid = false;
        emit sessionChanged(session);
        if (session != -1) {
            // resolve the corresponding Data Object on demand from DataManager
        }
    }
}
void GenericScheduleItem::removeSession()
{
	if (mSession != -1) {
		setSession(-1);
	}
}
bool GenericScheduleItem::hasSession()
{
    if (!mSessionInvalid && mSession != -1) {
        return true;
    } else {
        return false;
    }
}
bool GenericScheduleItem::isSessionResolvedAsDataObject()
{
    if (!mSessionInvalid && mSessionAsDataObject) {
        return true;
    } else {
        return false;
    }
}

// lazy bound Data Object was resolved. overwrite sessionId if different
void GenericScheduleItem::resolveSessionAsDataObject(Session* session)
{
    if (session) {
        if (session->sessionId() != mSession) {
            setSession(session->sessionId());
        }
        mSessionAsDataObject = session;
        mSessionInvalid = false;
    }
}
void GenericScheduleItem::markSessionAsInvalid()
{
    mSessionInvalid = true;
}
// ATT 
// Mandatory: sessionId
// Domain KEY: sessionId
int GenericScheduleItem::sessionId() const
{
	return mSessionId;
}

void GenericScheduleItem::setSessionId(int sessionId)
{
	if (sessionId != mSessionId) {
		mSessionId = sessionId;
		emit sessionIdChanged(sessionId);
	}
}
// ATT 
// Optional: isBreak
bool GenericScheduleItem::isBreak() const
{
	return mIsBreak;
}

void GenericScheduleItem::setIsBreak(bool isBreak)
{
	if (isBreak != mIsBreak) {
		mIsBreak = isBreak;
		emit isBreakChanged(isBreak);
	}
}
// ATT 
// Optional: isLunch
bool GenericScheduleItem::isLunch() const
{
	return mIsLunch;
}

void GenericScheduleItem::setIsLunch(bool isLunch)
{
	if (isLunch != mIsLunch) {
		mIsLunch = isLunch;
		emit isLunchChanged(isLunch);
	}
}
// ATT 
// Optional: isEvent
bool GenericScheduleItem::isEvent() const
{
	return mIsEvent;
}

void GenericScheduleItem::setIsEvent(bool isEvent)
{
	if (isEvent != mIsEvent) {
		mIsEvent = isEvent;
		emit isEventChanged(isEvent);
	}
}
// ATT 
// Optional: isRegistration
bool GenericScheduleItem::isRegistration() const
{
	return mIsRegistration;
}

void GenericScheduleItem::setIsRegistration(bool isRegistration)
{
	if (isRegistration != mIsRegistration) {
		mIsRegistration = isRegistration;
		emit isRegistrationChanged(isRegistration);
	}
}


GenericScheduleItem::~GenericScheduleItem()
{
	// place cleanUp code here
}
	
