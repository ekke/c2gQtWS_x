#include "SessionTrackAPI.hpp"
#include <QDebug>
#include <quuid.h>

// keys of QVariantMap used in this APP
static const QString uuidKey = "uuid";
static const QString nameKey = "name";
static const QString colorKey = "color";

// keys used from Server API etc
static const QString uuidForeignKey = "uuid";
static const QString nameForeignKey = "name";
static const QString colorForeignKey = "color";

/*
 * Default Constructor if SessionTrackAPI not initialized from QVariantMap
 */
SessionTrackAPI::SessionTrackAPI(QObject *parent) :
        QObject(parent), mUuid(""), mName(""), mColor("")
{
}

/*
 * initialize SessionTrackAPI from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses own property names
 * corresponding export method: toMap()
 */
void SessionTrackAPI::fillFromMap(const QVariantMap& sessionTrackAPIMap)
{
	mUuid = sessionTrackAPIMap.value(uuidKey).toString();
	if (mUuid.isEmpty()) {
		mUuid = QUuid::createUuid().toString();
		mUuid = mUuid.right(mUuid.length() - 1);
		mUuid = mUuid.left(mUuid.length() - 1);
	}	
	mName = sessionTrackAPIMap.value(nameKey).toString();
	mColor = sessionTrackAPIMap.value(colorKey).toString();
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * includes also transient values
 * uses foreign property names - per ex. from Server API
 * corresponding export method: toForeignMap()
 */
void SessionTrackAPI::fillFromForeignMap(const QVariantMap& sessionTrackAPIMap)
{
	mUuid = sessionTrackAPIMap.value(uuidForeignKey).toString();
	if (mUuid.isEmpty()) {
		mUuid = QUuid::createUuid().toString();
		mUuid = mUuid.right(mUuid.length() - 1);
		mUuid = mUuid.left(mUuid.length() - 1);
	}	
	mName = sessionTrackAPIMap.value(nameForeignKey).toString();
	mColor = sessionTrackAPIMap.value(colorForeignKey).toString();
}
/*
 * initialize OrderData from QVariantMap
 * Map got from JsonDataAccess or so
 * excludes transient values
 * uses own property names
 * corresponding export method: toCacheMap()
 */
void SessionTrackAPI::fillFromCacheMap(const QVariantMap& sessionTrackAPIMap)
{
	mUuid = sessionTrackAPIMap.value(uuidKey).toString();
	if (mUuid.isEmpty()) {
		mUuid = QUuid::createUuid().toString();
		mUuid = mUuid.right(mUuid.length() - 1);
		mUuid = mUuid.left(mUuid.length() - 1);
	}	
	mName = sessionTrackAPIMap.value(nameKey).toString();
	mColor = sessionTrackAPIMap.value(colorKey).toString();
}

void SessionTrackAPI::prepareNew()
{
	mUuid = QUuid::createUuid().toString();
	mUuid = mUuid.right(mUuid.length() - 1);
	mUuid = mUuid.left(mUuid.length() - 1);
}

/*
 * Checks if all mandatory attributes, all DomainKeys and uuid's are filled
 */
bool SessionTrackAPI::isValid()
{
	if (mUuid.isNull() || mUuid.isEmpty()) {
		return false;
	}
	return true;
}
	
/*
 * Exports Properties from SessionTrackAPI as QVariantMap
 * exports ALL data including transient properties
 * To store persistent Data in JsonDataAccess use toCacheMap()
 */
QVariantMap SessionTrackAPI::toMap()
{
	QVariantMap sessionTrackAPIMap;
	sessionTrackAPIMap.insert(uuidKey, mUuid);
	sessionTrackAPIMap.insert(nameKey, mName);
	sessionTrackAPIMap.insert(colorKey, mColor);
	return sessionTrackAPIMap;
}

/*
 * Exports Properties from SessionTrackAPI as QVariantMap
 * To send data as payload to Server
 * Makes it possible to use defferent naming conditions
 */
QVariantMap SessionTrackAPI::toForeignMap()
{
	QVariantMap sessionTrackAPIMap;
	sessionTrackAPIMap.insert(uuidForeignKey, mUuid);
	sessionTrackAPIMap.insert(nameForeignKey, mName);
	sessionTrackAPIMap.insert(colorForeignKey, mColor);
	return sessionTrackAPIMap;
}


/*
 * Exports Properties from SessionTrackAPI as QVariantMap
 * transient properties are excluded:
 * To export ALL data use toMap()
 */
QVariantMap SessionTrackAPI::toCacheMap()
{
	// no transient properties found from data model
	// use default toMao()
	return toMap();
}
// ATT 
// Mandatory: uuid
// Domain KEY: uuid
QString SessionTrackAPI::uuid() const
{
	return mUuid;
}

void SessionTrackAPI::setUuid(QString uuid)
{
	if (uuid != mUuid) {
		mUuid = uuid;
		emit uuidChanged(uuid);
	}
}
// ATT 
// Optional: name
QString SessionTrackAPI::name() const
{
	return mName;
}

void SessionTrackAPI::setName(QString name)
{
	if (name != mName) {
		mName = name;
		emit nameChanged(name);
	}
}
// ATT 
// Optional: color
QString SessionTrackAPI::color() const
{
	return mColor;
}

void SessionTrackAPI::setColor(QString color)
{
	if (color != mColor) {
		mColor = color;
		emit colorChanged(color);
	}
}


SessionTrackAPI::~SessionTrackAPI()
{
	// place cleanUp code here
}
	
