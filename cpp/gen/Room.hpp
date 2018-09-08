#ifndef ROOM_HPP_
#define ROOM_HPP_

#include <QObject>
#include <qvariant.h>
#include <QQmlListProperty>
#include <QStringList>


// forward declaration (target references to this)
class Session;


class Room: public QObject
{
	Q_OBJECT

	Q_PROPERTY(int roomId READ roomId WRITE setRoomId NOTIFY roomIdChanged FINAL)
	Q_PROPERTY(QString roomName READ roomName WRITE setRoomName NOTIFY roomNameChanged FINAL)
	Q_PROPERTY(bool inAssets READ inAssets WRITE setInAssets NOTIFY inAssetsChanged FINAL)

	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<Session> sessionsPropertyList READ sessionsPropertyList NOTIFY sessionsPropertyListChanged)

public:
	Room(QObject *parent = 0);

	Q_INVOKABLE
	bool isAllResolved();

	void fillFromMap(const QVariantMap& roomMap);
	void fillFromForeignMap(const QVariantMap& roomMap);
	void fillFromCacheMap(const QVariantMap& roomMap);
	
	void prepareNew();
	
	bool isValid();

	Q_INVOKABLE
	QVariantMap toMap();
	QVariantMap toForeignMap();
	QVariantMap toCacheMap();

	int roomId() const;
	void setRoomId(int roomId);
	QString roomName() const;
	void setRoomName(QString roomName);
	bool inAssets() const;
	void setInAssets(bool inAssets);

	
	Q_INVOKABLE
	QVariantList sessionsAsQVariantList();
	
	Q_INVOKABLE
	QVariantList sessionsAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList sessionsAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToSessions(Session* session);
	
	Q_INVOKABLE
	bool removeFromSessions(Session* session);

	Q_INVOKABLE
	void clearSessions();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool areSessionsKeysResolved();

	Q_INVOKABLE
	QStringList sessionsKeys();

	Q_INVOKABLE
	void resolveSessionsKeys(QList<Session*> sessions);
	
	Q_INVOKABLE
	int sessionsCount();
	
	 // access from C++ to sessions
	QList<Session*> sessions();
	void setSessions(QList<Session*> sessions);
	// access from QML to sessions
	QQmlListProperty<Session> sessionsPropertyList();


	virtual ~Room();

	Q_SIGNALS:

	void roomIdChanged(int roomId);
	void roomNameChanged(QString roomName);
	void inAssetsChanged(bool inAssets);
	void sessionsChanged(QList<Session*> sessions);
	void addedToSessions(Session* session);
	void sessionsPropertyListChanged();
	
	

private:

	int mRoomId;
	QString mRoomName;
	bool mInAssets;
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mSessionsKeys;
	bool mSessionsKeysResolved;
	QList<Session*> mSessions;
	// implementation for QQmlListProperty to use
	// QML functions for List of Session*
	static void appendToSessionsProperty(QQmlListProperty<Session> *sessionsList,
		Session* session);
	static int sessionsPropertyCount(QQmlListProperty<Session> *sessionsList);
	static Session* atSessionsProperty(QQmlListProperty<Session> *sessionsList, int pos);
	static void clearSessionsProperty(QQmlListProperty<Session> *sessionsList);
	

	Q_DISABLE_COPY (Room)
};
Q_DECLARE_METATYPE(Room*)

#endif /* ROOM_HPP_ */

