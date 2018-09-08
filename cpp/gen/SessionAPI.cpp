#include "SessionAPI.hpp"
#include <QDebug>
#include <quuid.h>

// keys of QVariantMap used in this APP
static const QString sessionIdKey = "sessionId";
static const QString titleKey = "title";
static const QString descriptionKey = "description";
static const QString startTimeKey = "startTime";
static const QString durationKey = "duration";
static const QString roomKey = "room";
static const QString sessionTracksKey = "sessionTracks";
static const QString presenterKey = "presenter";

// keys used from Server API etc
static const QString sessionIdForeignKey = "id";
static const QString titleForeignKey = "title";
static const QString descriptionForeignKey = "description";
static const QString startTimeForeignKey = "start";
static const QString durationForeignKey = "duration";
static const QString roomForeignKey = "room";
static const QString sessionTracksForeignKey = "tracks";
static const QString presenterForeignKey = "persons";

/*
 * Default Constructor if SessionAPI not initialized from QVariantMap
 */
SessionAPI::SessionAPI(QObject *parent) :
        QObject(parent), mSessionId(-1), mTitle(""), mDescription(""), mDuration(""), mRoom("")
{
	// Date, Time or Timestamp ? construct null value
	mStartTime = QTime();
		// lazy Arrays where only keys are persisted
		mSessionTracksKeysResolved = false;
		mPresenterKeysResolved = false;
}

bool SessionAPI::isAllResolved()
{
    if(!areSessionTracksKeysResolved()) {
        return false;
    }
    if(!arePresenterKeysResolved()) {
        return false;
    }
    return true;
}

/*
 * initialize SessionAPI from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses own property names
 * corresponding export method: toMap()
 */
void SessionAPI::fillFromMap(const QVariantMap& sessionAPIMap)
{
	mSessionId = sessionAPIMap.value(sessionIdKey).toInt();
	mTitle = sessionAPIMap.value(titleKey).toString();
	mDescription = sessionAPIMap.value(descriptionKey).toString();
	if (sessionAPIMap.contains(startTimeKey)) {
		// always getting the Date as a String (from server or JSON)
		QString startTimeAsString = sessionAPIMap.value(startTimeKey).toString();
		mStartTime = QTime::fromString(startTimeAsString, "HH:mm");
		if (!mStartTime.isValid()) {
			mStartTime = QTime();
			qDebug() << "mStartTime is not valid for String: " << startTimeAsString;
		}
	}
	mDuration = sessionAPIMap.value(durationKey).toString();
	mRoom = sessionAPIMap.value(roomKey).toString();
	// mSessionTracks is (lazy loaded) Array of SessionTrackAPI*
	mSessionTracksKeys = sessionAPIMap.value(sessionTracksKey).toStringList();
	// mSessionTracks must be resolved later if there are keys
	mSessionTracksKeysResolved = (mSessionTracksKeys.size() == 0);
	mSessionTracks.clear();
	// mPresenter is (lazy loaded) Array of PersonsAPI*
	mPresenterKeys = sessionAPIMap.value(presenterKey).toStringList();
	// mPresenter must be resolved later if there are keys
	mPresenterKeysResolved = (mPresenterKeys.size() == 0);
	mPresenter.clear();
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses foreign property names - per ex. from Server API
 * corresponding export method: toForeignMap()
 */
void SessionAPI::fillFromForeignMap(const QVariantMap& sessionAPIMap)
{
	mSessionId = sessionAPIMap.value(sessionIdForeignKey).toInt();
	mTitle = sessionAPIMap.value(titleForeignKey).toString();
	mDescription = sessionAPIMap.value(descriptionForeignKey).toString();
	if (sessionAPIMap.contains(startTimeForeignKey)) {
		// always getting the Date as a String (from server or JSON)
		QString startTimeAsString = sessionAPIMap.value(startTimeForeignKey).toString();
		mStartTime = QTime::fromString(startTimeAsString, "HH:mm");
		if (!mStartTime.isValid()) {
			mStartTime = QTime();
			qDebug() << "mStartTime is not valid for String: " << startTimeAsString;
		}
	}
	mDuration = sessionAPIMap.value(durationForeignKey).toString();
	mRoom = sessionAPIMap.value(roomForeignKey).toString();
	// mSessionTracks is (lazy loaded) Array of SessionTrackAPI*
	mSessionTracksKeys = sessionAPIMap.value(sessionTracksForeignKey).toStringList();
	// mSessionTracks must be resolved later if there are keys
	mSessionTracksKeysResolved = (mSessionTracksKeys.size() == 0);
	mSessionTracks.clear();
	// mPresenter is (lazy loaded) Array of PersonsAPI*
	mPresenterKeys = sessionAPIMap.value(presenterForeignKey).toStringList();
	// mPresenter must be resolved later if there are keys
	mPresenterKeysResolved = (mPresenterKeys.size() == 0);
	mPresenter.clear();
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * excludes transient values
 * uses own property names
 * corresponding export method: toCacheMap()
 */
void SessionAPI::fillFromCacheMap(const QVariantMap& sessionAPIMap)
{
	mSessionId = sessionAPIMap.value(sessionIdKey).toInt();
	mTitle = sessionAPIMap.value(titleKey).toString();
	mDescription = sessionAPIMap.value(descriptionKey).toString();
	if (sessionAPIMap.contains(startTimeKey)) {
		// always getting the Date as a String (from server or JSON)
		QString startTimeAsString = sessionAPIMap.value(startTimeKey).toString();
		mStartTime = QTime::fromString(startTimeAsString, "HH:mm");
		if (!mStartTime.isValid()) {
			mStartTime = QTime();
			qDebug() << "mStartTime is not valid for String: " << startTimeAsString;
		}
	}
	mDuration = sessionAPIMap.value(durationKey).toString();
	mRoom = sessionAPIMap.value(roomKey).toString();
	// mSessionTracks is (lazy loaded) Array of SessionTrackAPI*
	mSessionTracksKeys = sessionAPIMap.value(sessionTracksKey).toStringList();
	// mSessionTracks must be resolved later if there are keys
	mSessionTracksKeysResolved = (mSessionTracksKeys.size() == 0);
	mSessionTracks.clear();
	// mPresenter is (lazy loaded) Array of PersonsAPI*
	mPresenterKeys = sessionAPIMap.value(presenterKey).toStringList();
	// mPresenter must be resolved later if there are keys
	mPresenterKeysResolved = (mPresenterKeys.size() == 0);
	mPresenter.clear();
}

void SessionAPI::prepareNew()
{
}

/*
 * Checks if all mandatory attributes, all DomainKeys and uuid's are filled
 */
bool SessionAPI::isValid()
{
	if (mSessionId == -1) {
		return false;
	}
	return true;
}
	
/*
 * Exports Properties from SessionAPI as QVariantMap
 * exports ALL data including transient properties
 * To store persistent Data in JsonDataAccess use toCacheMap()
 */
QVariantMap SessionAPI::toMap()
{
	QVariantMap sessionAPIMap;
	// mSessionTracks points to SessionTrackAPI*
	// lazy array: persist only keys
	//
	// if keys alreadyy resolved: clear them
	// otherwise reuse the keys and add objects from mPositions
	// this can happen if added to objects without resolving keys before
	if(mSessionTracksKeysResolved) {
		mSessionTracksKeys.clear();
	}
	// add objects from mPositions
	for (int i = 0; i < mSessionTracks.size(); ++i) {
		SessionTrackAPI* sessionTrackAPI;
		sessionTrackAPI = mSessionTracks.at(i);
		mSessionTracksKeys << sessionTrackAPI->uuid();
	}
	sessionAPIMap.insert(sessionTracksKey, mSessionTracksKeys);
	// mPresenter points to PersonsAPI*
	// lazy array: persist only keys
	//
	// if keys alreadyy resolved: clear them
	// otherwise reuse the keys and add objects from mPositions
	// this can happen if added to objects without resolving keys before
	if(mPresenterKeysResolved) {
		mPresenterKeys.clear();
	}
	// add objects from mPositions
	for (int i = 0; i < mPresenter.size(); ++i) {
		PersonsAPI* personsAPI;
		personsAPI = mPresenter.at(i);
		mPresenterKeys << QString::number(personsAPI->speakerId());
	}
	sessionAPIMap.insert(presenterKey, mPresenterKeys);
	sessionAPIMap.insert(sessionIdKey, mSessionId);
	sessionAPIMap.insert(titleKey, mTitle);
	sessionAPIMap.insert(descriptionKey, mDescription);
	if (hasStartTime()) {
		sessionAPIMap.insert(startTimeKey, mStartTime.toString("HH:mm"));
	}
	sessionAPIMap.insert(durationKey, mDuration);
	sessionAPIMap.insert(roomKey, mRoom);
	return sessionAPIMap;
}

/*
 * Exports Properties from SessionAPI as QVariantMap
 * To send data as payload to Server
 * Makes it possible to use defferent naming conditions
 */
QVariantMap SessionAPI::toForeignMap()
{
	QVariantMap sessionAPIMap;
	// mSessionTracks points to SessionTrackAPI*
	// lazy array: persist only keys
	//
	// if keys alreadyy resolved: clear them
	// otherwise reuse the keys and add objects from mPositions
	// this can happen if added to objects without resolving keys before
	if(mSessionTracksKeysResolved) {
		mSessionTracksKeys.clear();
	}
	// add objects from mPositions
	for (int i = 0; i < mSessionTracks.size(); ++i) {
		SessionTrackAPI* sessionTrackAPI;
		sessionTrackAPI = mSessionTracks.at(i);
		mSessionTracksKeys << sessionTrackAPI->uuid();
	}
	sessionAPIMap.insert(sessionTracksForeignKey, mSessionTracksKeys);
	// mPresenter points to PersonsAPI*
	// lazy array: persist only keys
	//
	// if keys alreadyy resolved: clear them
	// otherwise reuse the keys and add objects from mPositions
	// this can happen if added to objects without resolving keys before
	if(mPresenterKeysResolved) {
		mPresenterKeys.clear();
	}
	// add objects from mPositions
	for (int i = 0; i < mPresenter.size(); ++i) {
		PersonsAPI* personsAPI;
		personsAPI = mPresenter.at(i);
		mPresenterKeys << QString::number(personsAPI->speakerId());
	}
	sessionAPIMap.insert(presenterForeignKey, mPresenterKeys);
	sessionAPIMap.insert(sessionIdForeignKey, mSessionId);
	sessionAPIMap.insert(titleForeignKey, mTitle);
	sessionAPIMap.insert(descriptionForeignKey, mDescription);
	if (hasStartTime()) {
		sessionAPIMap.insert(startTimeForeignKey, mStartTime.toString("HH:mm"));
	}
	sessionAPIMap.insert(durationForeignKey, mDuration);
	sessionAPIMap.insert(roomForeignKey, mRoom);
	return sessionAPIMap;
}


/*
 * Exports Properties from SessionAPI as QVariantMap
 * transient properties are excluded:
 * To export ALL data use toMap()
 */
QVariantMap SessionAPI::toCacheMap()
{
	// no transient properties found from data model
	// use default toMao()
	return toMap();
}
// ATT 
// Mandatory: sessionId
// Domain KEY: sessionId
int SessionAPI::sessionId() const
{
	return mSessionId;
}

void SessionAPI::setSessionId(int sessionId)
{
	if (sessionId != mSessionId) {
		mSessionId = sessionId;
		emit sessionIdChanged(sessionId);
	}
}
// ATT 
// Optional: title
QString SessionAPI::title() const
{
	return mTitle;
}

void SessionAPI::setTitle(QString title)
{
	if (title != mTitle) {
		mTitle = title;
		emit titleChanged(title);
	}
}
// ATT 
// Optional: description
QString SessionAPI::description() const
{
	return mDescription;
}

void SessionAPI::setDescription(QString description)
{
	if (description != mDescription) {
		mDescription = description;
		emit descriptionChanged(description);
	}
}
// ATT 
// Optional: startTime
/**
 * in QML set DateTimePicker value this way:
 * myPicker.value = myPicker.dateFromTime(startTime)
 */
QTime SessionAPI::startTime() const
{
	return mStartTime;
}

void SessionAPI::setStartTime(QTime startTime)
{
	if (startTime != mStartTime) {
		mStartTime = startTime;
		emit startTimeChanged(startTime);
	}
}
/**
 * INVOKABLE
 * Convenience method to make it easy to set the value from QML
 * use myPicker.value.toTimeString() as Parameter
 */
void SessionAPI::setStartTimeFromPickerValue(QString startTimeValue)
{
    QTime startTime = QTime::fromString(startTimeValue.left(8), "HH:mm:ss");
    if (startTime != mStartTime) {
        mStartTime = startTime;
        emit startTimeChanged(startTime);
    }
}
bool SessionAPI::hasStartTime()
{
	return !mStartTime.isNull() && mStartTime.isValid();
}
// ATT 
// Optional: duration
QString SessionAPI::duration() const
{
	return mDuration;
}

void SessionAPI::setDuration(QString duration)
{
	if (duration != mDuration) {
		mDuration = duration;
		emit durationChanged(duration);
	}
}
// ATT 
// Optional: room
QString SessionAPI::room() const
{
	return mRoom;
}

void SessionAPI::setRoom(QString room)
{
	if (room != mRoom) {
		mRoom = room;
		emit roomChanged(room);
	}
}
// ATT 
// Optional: sessionTracks
QVariantList SessionAPI::sessionTracksAsQVariantList()
{
	QVariantList sessionTracksList;
	for (int i = 0; i < mSessionTracks.size(); ++i) {
        sessionTracksList.append((mSessionTracks.at(i))->toMap());
    }
	return sessionTracksList;
}
QVariantList SessionAPI::sessionTracksAsCacheQVariantList()
{
	QVariantList sessionTracksList;
	for (int i = 0; i < mSessionTracks.size(); ++i) {
        sessionTracksList.append((mSessionTracks.at(i))->toCacheMap());
    }
	return sessionTracksList;
}
QVariantList SessionAPI::sessionTracksAsForeignQVariantList()
{
	QVariantList sessionTracksList;
	for (int i = 0; i < mSessionTracks.size(); ++i) {
        sessionTracksList.append((mSessionTracks.at(i))->toForeignMap());
    }
	return sessionTracksList;
}
// no create() or undoCreate() because dto is root object
// see methods in DataManager
/**
 * you can add sessionTracks without resolving existing keys before
 * attention: before looping through the objects
 * you must resolveSessionTracksKeys
 */
void SessionAPI::addToSessionTracks(SessionTrackAPI* sessionTrackAPI)
{
    mSessionTracks.append(sessionTrackAPI);
    emit addedToSessionTracks(sessionTrackAPI);
    emit sessionTracksPropertyListChanged();
}

bool SessionAPI::removeFromSessionTracks(SessionTrackAPI* sessionTrackAPI)
{
    bool ok = false;
    ok = mSessionTracks.removeOne(sessionTrackAPI);
    if (!ok) {
    	qDebug() << "SessionTrackAPI* not found in sessionTracks";
    	return false;
    }
    emit sessionTracksPropertyListChanged();
    // sessionTracks are independent - DON'T delete them
    return true;
}
void SessionAPI::clearSessionTracks()
{
    for (int i = mSessionTracks.size(); i > 0; --i) {
        removeFromSessionTracks(mSessionTracks.last());
    }
    mSessionTracksKeys.clear();
}

/**
 * lazy Array of independent Data Objects: only keys are persited
 * so we get a list of keys (uuid or domain keys) from map
 * and we persist only the keys toMap()
 * after initializing the keys must be resolved:
 * - get the list of keys: sessionTracksKeys()
 * - resolve them from DataManager
 * - then resolveSessionTracksKeys()
 */
bool SessionAPI::areSessionTracksKeysResolved()
{
    return mSessionTracksKeysResolved;
}

QStringList SessionAPI::sessionTracksKeys()
{
    return mSessionTracksKeys;
}

/**
 * Objects from sessionTracksKeys will be added to existing sessionTracks
 * This enables to use addToSessionTracks() without resolving before
 * Hint: it's your responsibility to resolve before looping thru sessionTracks
 */
void SessionAPI::resolveSessionTracksKeys(QList<SessionTrackAPI*> sessionTracks)
{
    if(mSessionTracksKeysResolved){
        return;
    }
    // don't clear mSessionTracks (see above)
    for (int i = 0; i < sessionTracks.size(); ++i) {
        addToSessionTracks(sessionTracks.at(i));
    }
    mSessionTracksKeysResolved = true;
}

int SessionAPI::sessionTracksCount()
{
    return mSessionTracks.size();
}
QList<SessionTrackAPI*> SessionAPI::sessionTracks()
{
	return mSessionTracks;
}
void SessionAPI::setSessionTracks(QList<SessionTrackAPI*> sessionTracks) 
{
	if (sessionTracks != mSessionTracks) {
		mSessionTracks = sessionTracks;
		emit sessionTracksChanged(sessionTracks);
		emit sessionTracksPropertyListChanged();
	}
}

/**
 * to access lists from QML we're using QQmlListProperty
 * and implement methods to append, count and clear
 * now from QML we can use
 * sessionAPI.sessionTracksPropertyList.length to get the size
 * sessionAPI.sessionTracksPropertyList[2] to get SessionTrackAPI* at position 2
 * sessionAPI.sessionTracksPropertyList = [] to clear the list
 * or get easy access to properties like
 * sessionAPI.sessionTracksPropertyList[2].myPropertyName
 */
QQmlListProperty<SessionTrackAPI> SessionAPI::sessionTracksPropertyList()
{
    return QQmlListProperty<SessionTrackAPI>(this, 0, &SessionAPI::appendToSessionTracksProperty,
            &SessionAPI::sessionTracksPropertyCount, &SessionAPI::atSessionTracksProperty,
            &SessionAPI::clearSessionTracksProperty);
}
void SessionAPI::appendToSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList,
        SessionTrackAPI* sessionTrackAPI)
{
    SessionAPI *sessionAPIObject = qobject_cast<SessionAPI *>(sessionTracksList->object);
    if (sessionAPIObject) {
        sessionAPIObject->mSessionTracks.append(sessionTrackAPI);
        emit sessionAPIObject->addedToSessionTracks(sessionTrackAPI);
    } else {
        qWarning() << "cannot append SessionTrackAPI* to sessionTracks " << "Object is not of type SessionAPI*";
    }
}
int SessionAPI::sessionTracksPropertyCount(QQmlListProperty<SessionTrackAPI> *sessionTracksList)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(sessionTracksList->object);
    if (sessionAPI) {
        return sessionAPI->mSessionTracks.size();
    } else {
        qWarning() << "cannot get size sessionTracks " << "Object is not of type SessionAPI*";
    }
    return 0;
}
SessionTrackAPI* SessionAPI::atSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList, int pos)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(sessionTracksList->object);
    if (sessionAPI) {
        if (sessionAPI->mSessionTracks.size() > pos) {
            return sessionAPI->mSessionTracks.at(pos);
        }
        qWarning() << "cannot get SessionTrackAPI* at pos " << pos << " size is "
                << sessionAPI->mSessionTracks.size();
    } else {
        qWarning() << "cannot get SessionTrackAPI* at pos " << pos << "Object is not of type SessionAPI*";
    }
    return 0;
}
void SessionAPI::clearSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(sessionTracksList->object);
    if (sessionAPI) {
        // sessionTracks are independent - DON'T delete them
        sessionAPI->mSessionTracks.clear();
    } else {
        qWarning() << "cannot clear sessionTracks " << "Object is not of type SessionAPI*";
    }
}

// ATT 
// Optional: presenter
QVariantList SessionAPI::presenterAsQVariantList()
{
	QVariantList presenterList;
	for (int i = 0; i < mPresenter.size(); ++i) {
        presenterList.append((mPresenter.at(i))->toMap());
    }
	return presenterList;
}
QVariantList SessionAPI::presenterAsCacheQVariantList()
{
	QVariantList presenterList;
	for (int i = 0; i < mPresenter.size(); ++i) {
        presenterList.append((mPresenter.at(i))->toCacheMap());
    }
	return presenterList;
}
QVariantList SessionAPI::presenterAsForeignQVariantList()
{
	QVariantList presenterList;
	for (int i = 0; i < mPresenter.size(); ++i) {
        presenterList.append((mPresenter.at(i))->toForeignMap());
    }
	return presenterList;
}
// no create() or undoCreate() because dto is root object
// see methods in DataManager
/**
 * you can add presenter without resolving existing keys before
 * attention: before looping through the objects
 * you must resolvePresenterKeys
 */
void SessionAPI::addToPresenter(PersonsAPI* personsAPI)
{
    mPresenter.append(personsAPI);
    emit addedToPresenter(personsAPI);
    emit presenterPropertyListChanged();
}

bool SessionAPI::removeFromPresenter(PersonsAPI* personsAPI)
{
    bool ok = false;
    ok = mPresenter.removeOne(personsAPI);
    if (!ok) {
    	qDebug() << "PersonsAPI* not found in presenter";
    	return false;
    }
    emit presenterPropertyListChanged();
    // presenter are independent - DON'T delete them
    return true;
}
void SessionAPI::clearPresenter()
{
    for (int i = mPresenter.size(); i > 0; --i) {
        removeFromPresenter(mPresenter.last());
    }
    mPresenterKeys.clear();
}

/**
 * lazy Array of independent Data Objects: only keys are persited
 * so we get a list of keys (uuid or domain keys) from map
 * and we persist only the keys toMap()
 * after initializing the keys must be resolved:
 * - get the list of keys: presenterKeys()
 * - resolve them from DataManager
 * - then resolvePresenterKeys()
 */
bool SessionAPI::arePresenterKeysResolved()
{
    return mPresenterKeysResolved;
}

QStringList SessionAPI::presenterKeys()
{
    return mPresenterKeys;
}

/**
 * Objects from presenterKeys will be added to existing presenter
 * This enables to use addToPresenter() without resolving before
 * Hint: it's your responsibility to resolve before looping thru presenter
 */
void SessionAPI::resolvePresenterKeys(QList<PersonsAPI*> presenter)
{
    if(mPresenterKeysResolved){
        return;
    }
    // don't clear mPresenter (see above)
    for (int i = 0; i < presenter.size(); ++i) {
        addToPresenter(presenter.at(i));
    }
    mPresenterKeysResolved = true;
}

int SessionAPI::presenterCount()
{
    return mPresenter.size();
}
QList<PersonsAPI*> SessionAPI::presenter()
{
	return mPresenter;
}
void SessionAPI::setPresenter(QList<PersonsAPI*> presenter) 
{
	if (presenter != mPresenter) {
		mPresenter = presenter;
		emit presenterChanged(presenter);
		emit presenterPropertyListChanged();
	}
}

/**
 * to access lists from QML we're using QQmlListProperty
 * and implement methods to append, count and clear
 * now from QML we can use
 * sessionAPI.presenterPropertyList.length to get the size
 * sessionAPI.presenterPropertyList[2] to get PersonsAPI* at position 2
 * sessionAPI.presenterPropertyList = [] to clear the list
 * or get easy access to properties like
 * sessionAPI.presenterPropertyList[2].myPropertyName
 */
QQmlListProperty<PersonsAPI> SessionAPI::presenterPropertyList()
{
    return QQmlListProperty<PersonsAPI>(this, 0, &SessionAPI::appendToPresenterProperty,
            &SessionAPI::presenterPropertyCount, &SessionAPI::atPresenterProperty,
            &SessionAPI::clearPresenterProperty);
}
void SessionAPI::appendToPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList,
        PersonsAPI* personsAPI)
{
    SessionAPI *sessionAPIObject = qobject_cast<SessionAPI *>(presenterList->object);
    if (sessionAPIObject) {
        sessionAPIObject->mPresenter.append(personsAPI);
        emit sessionAPIObject->addedToPresenter(personsAPI);
    } else {
        qWarning() << "cannot append PersonsAPI* to presenter " << "Object is not of type SessionAPI*";
    }
}
int SessionAPI::presenterPropertyCount(QQmlListProperty<PersonsAPI> *presenterList)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(presenterList->object);
    if (sessionAPI) {
        return sessionAPI->mPresenter.size();
    } else {
        qWarning() << "cannot get size presenter " << "Object is not of type SessionAPI*";
    }
    return 0;
}
PersonsAPI* SessionAPI::atPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList, int pos)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(presenterList->object);
    if (sessionAPI) {
        if (sessionAPI->mPresenter.size() > pos) {
            return sessionAPI->mPresenter.at(pos);
        }
        qWarning() << "cannot get PersonsAPI* at pos " << pos << " size is "
                << sessionAPI->mPresenter.size();
    } else {
        qWarning() << "cannot get PersonsAPI* at pos " << pos << "Object is not of type SessionAPI*";
    }
    return 0;
}
void SessionAPI::clearPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList)
{
    SessionAPI *sessionAPI = qobject_cast<SessionAPI *>(presenterList->object);
    if (sessionAPI) {
        // presenter are independent - DON'T delete them
        sessionAPI->mPresenter.clear();
    } else {
        qWarning() << "cannot clear presenter " << "Object is not of type SessionAPI*";
    }
}



SessionAPI::~SessionAPI()
{
	// place cleanUp code here
}
	
