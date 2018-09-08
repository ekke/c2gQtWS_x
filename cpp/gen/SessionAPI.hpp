#ifndef SESSIONAPI_HPP_
#define SESSIONAPI_HPP_

#include <QObject>
#include <qvariant.h>
#include <QQmlListProperty>
#include <QStringList>
#include <QTime>


#include "SessionTrackAPI.hpp"
#include "PersonsAPI.hpp"


class SessionAPI: public QObject
{
	Q_OBJECT

	Q_PROPERTY(int sessionId READ sessionId WRITE setSessionId NOTIFY sessionIdChanged FINAL)
	Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged FINAL)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged FINAL)
	Q_PROPERTY(QTime startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged FINAL)
	Q_PROPERTY(QString duration READ duration WRITE setDuration NOTIFY durationChanged FINAL)
	Q_PROPERTY(QString room READ room WRITE setRoom NOTIFY roomChanged FINAL)

	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<SessionTrackAPI> sessionTracksPropertyList READ sessionTracksPropertyList NOTIFY sessionTracksPropertyListChanged)
	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<PersonsAPI> presenterPropertyList READ presenterPropertyList NOTIFY presenterPropertyListChanged)

public:
	SessionAPI(QObject *parent = 0);

	Q_INVOKABLE
	bool isAllResolved();

	void fillFromMap(const QVariantMap& sessionAPIMap);
	void fillFromForeignMap(const QVariantMap& sessionAPIMap);
	void fillFromCacheMap(const QVariantMap& sessionAPIMap);
	
	void prepareNew();
	
	bool isValid();

	Q_INVOKABLE
	QVariantMap toMap();
	QVariantMap toForeignMap();
	QVariantMap toCacheMap();

	int sessionId() const;
	void setSessionId(int sessionId);
	QString title() const;
	void setTitle(QString title);
	QString description() const;
	void setDescription(QString description);
	QTime startTime() const;

	Q_INVOKABLE
	bool hasStartTime();

	Q_INVOKABLE
	void setStartTimeFromPickerValue(QString startTimeValue);
	void setStartTime(QTime startTime);
	QString duration() const;
	void setDuration(QString duration);
	QString room() const;
	void setRoom(QString room);

	
	Q_INVOKABLE
	QVariantList sessionTracksAsQVariantList();
	
	Q_INVOKABLE
	QVariantList sessionTracksAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList sessionTracksAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToSessionTracks(SessionTrackAPI* sessionTrackAPI);
	
	Q_INVOKABLE
	bool removeFromSessionTracks(SessionTrackAPI* sessionTrackAPI);

	Q_INVOKABLE
	void clearSessionTracks();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool areSessionTracksKeysResolved();

	Q_INVOKABLE
	QStringList sessionTracksKeys();

	Q_INVOKABLE
	void resolveSessionTracksKeys(QList<SessionTrackAPI*> sessionTracks);
	
	Q_INVOKABLE
	int sessionTracksCount();
	
	 // access from C++ to sessionTracks
	QList<SessionTrackAPI*> sessionTracks();
	void setSessionTracks(QList<SessionTrackAPI*> sessionTracks);
	// access from QML to sessionTracks
	QQmlListProperty<SessionTrackAPI> sessionTracksPropertyList();
	
	Q_INVOKABLE
	QVariantList presenterAsQVariantList();
	
	Q_INVOKABLE
	QVariantList presenterAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList presenterAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToPresenter(PersonsAPI* personsAPI);
	
	Q_INVOKABLE
	bool removeFromPresenter(PersonsAPI* personsAPI);

	Q_INVOKABLE
	void clearPresenter();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool arePresenterKeysResolved();

	Q_INVOKABLE
	QStringList presenterKeys();

	Q_INVOKABLE
	void resolvePresenterKeys(QList<PersonsAPI*> presenter);
	
	Q_INVOKABLE
	int presenterCount();
	
	 // access from C++ to presenter
	QList<PersonsAPI*> presenter();
	void setPresenter(QList<PersonsAPI*> presenter);
	// access from QML to presenter
	QQmlListProperty<PersonsAPI> presenterPropertyList();


	virtual ~SessionAPI();

	Q_SIGNALS:

	void sessionIdChanged(int sessionId);
	void titleChanged(QString title);
	void descriptionChanged(QString description);
	void startTimeChanged(QTime startTime);
	void durationChanged(QString duration);
	void roomChanged(QString room);
	void sessionTracksChanged(QList<SessionTrackAPI*> sessionTracks);
	void addedToSessionTracks(SessionTrackAPI* sessionTrackAPI);
	void sessionTracksPropertyListChanged();
	
	void presenterChanged(QList<PersonsAPI*> presenter);
	void addedToPresenter(PersonsAPI* personsAPI);
	void presenterPropertyListChanged();
	
	

private:

	int mSessionId;
	QString mTitle;
	QString mDescription;
	QTime mStartTime;
	QString mDuration;
	QString mRoom;
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mSessionTracksKeys;
	bool mSessionTracksKeysResolved;
	QList<SessionTrackAPI*> mSessionTracks;
	// implementation for QQmlListProperty to use
	// QML functions for List of SessionTrackAPI*
	static void appendToSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList,
		SessionTrackAPI* sessionTrackAPI);
	static int sessionTracksPropertyCount(QQmlListProperty<SessionTrackAPI> *sessionTracksList);
	static SessionTrackAPI* atSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList, int pos);
	static void clearSessionTracksProperty(QQmlListProperty<SessionTrackAPI> *sessionTracksList);
	
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mPresenterKeys;
	bool mPresenterKeysResolved;
	QList<PersonsAPI*> mPresenter;
	// implementation for QQmlListProperty to use
	// QML functions for List of PersonsAPI*
	static void appendToPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList,
		PersonsAPI* personsAPI);
	static int presenterPropertyCount(QQmlListProperty<PersonsAPI> *presenterList);
	static PersonsAPI* atPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList, int pos);
	static void clearPresenterProperty(QQmlListProperty<PersonsAPI> *presenterList);
	

	Q_DISABLE_COPY (SessionAPI)
};
Q_DECLARE_METATYPE(SessionAPI*)

#endif /* SESSIONAPI_HPP_ */

