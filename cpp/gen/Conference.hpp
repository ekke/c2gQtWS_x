#ifndef CONFERENCE_HPP_
#define CONFERENCE_HPP_

#include <QObject>
#include <qvariant.h>
#include <QQmlListProperty>
#include <QStringList>
#include <QDate>


#include "Day.hpp"
#include "SessionTrack.hpp"
#include "Room.hpp"


class Conference: public QObject
{
	Q_OBJECT

	Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged FINAL)
	Q_PROPERTY(QString conferenceName READ conferenceName WRITE setConferenceName NOTIFY conferenceNameChanged FINAL)
	Q_PROPERTY(QString conferenceCity READ conferenceCity WRITE setConferenceCity NOTIFY conferenceCityChanged FINAL)
	Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged FINAL)
	Q_PROPERTY(QString timeZoneName READ timeZoneName WRITE setTimeZoneName NOTIFY timeZoneNameChanged FINAL)
	Q_PROPERTY(int timeZoneOffsetSeconds READ timeZoneOffsetSeconds WRITE setTimeZoneOffsetSeconds NOTIFY timeZoneOffsetSecondsChanged FINAL)
	Q_PROPERTY(QDate conferenceFrom READ conferenceFrom WRITE setConferenceFrom NOTIFY conferenceFromChanged FINAL)
	Q_PROPERTY(QDate conferenceTo READ conferenceTo WRITE setConferenceTo NOTIFY conferenceToChanged FINAL)
	Q_PROPERTY(QString hashTag READ hashTag WRITE setHashTag NOTIFY hashTagChanged FINAL)
	Q_PROPERTY(QString homePage READ homePage WRITE setHomePage NOTIFY homePageChanged FINAL)
	Q_PROPERTY(QString coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged FINAL)
	Q_PROPERTY(int lastRoomId READ lastRoomId WRITE setLastRoomId NOTIFY lastRoomIdChanged FINAL)
	Q_PROPERTY(int lastSessionTrackId READ lastSessionTrackId WRITE setLastSessionTrackId NOTIFY lastSessionTrackIdChanged FINAL)
	Q_PROPERTY(int lastGenericSessionId READ lastGenericSessionId WRITE setLastGenericSessionId NOTIFY lastGenericSessionIdChanged FINAL)

	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<Day> daysPropertyList READ daysPropertyList NOTIFY daysPropertyListChanged)
	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<SessionTrack> tracksPropertyList READ tracksPropertyList NOTIFY tracksPropertyListChanged)
	// QQmlListProperty to get easy access from QML
	Q_PROPERTY(QQmlListProperty<Room> roomsPropertyList READ roomsPropertyList NOTIFY roomsPropertyListChanged)

public:
	Conference(QObject *parent = 0);

	Q_INVOKABLE
	bool isAllResolved();

	void fillFromMap(const QVariantMap& conferenceMap);
	void fillFromForeignMap(const QVariantMap& conferenceMap);
	void fillFromCacheMap(const QVariantMap& conferenceMap);
	
	void prepareNew();
	
	bool isValid();

	Q_INVOKABLE
	QVariantMap toMap();
	QVariantMap toForeignMap();
	QVariantMap toCacheMap();

	int id() const;
	void setId(int id);
	QString conferenceName() const;
	void setConferenceName(QString conferenceName);
	QString conferenceCity() const;
	void setConferenceCity(QString conferenceCity);
	QString address() const;
	void setAddress(QString address);
	QString timeZoneName() const;
	void setTimeZoneName(QString timeZoneName);
	int timeZoneOffsetSeconds() const;
	void setTimeZoneOffsetSeconds(int timeZoneOffsetSeconds);
	QDate conferenceFrom() const;

	Q_INVOKABLE
	bool hasConferenceFrom();
	void setConferenceFrom(QDate conferenceFrom);
	QDate conferenceTo() const;

	Q_INVOKABLE
	bool hasConferenceTo();
	void setConferenceTo(QDate conferenceTo);
	QString hashTag() const;
	void setHashTag(QString hashTag);
	QString homePage() const;
	void setHomePage(QString homePage);
	QString coordinate() const;
	void setCoordinate(QString coordinate);
	int lastRoomId() const;
	void setLastRoomId(int lastRoomId);
	int lastSessionTrackId() const;
	void setLastSessionTrackId(int lastSessionTrackId);
	int lastGenericSessionId() const;
	void setLastGenericSessionId(int lastGenericSessionId);

	
	Q_INVOKABLE
	QVariantList daysAsQVariantList();
	
	Q_INVOKABLE
	QVariantList daysAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList daysAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToDays(Day* day);
	
	Q_INVOKABLE
	bool removeFromDays(Day* day);

	Q_INVOKABLE
	void clearDays();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool areDaysKeysResolved();

	Q_INVOKABLE
	QStringList daysKeys();

	Q_INVOKABLE
	void resolveDaysKeys(QList<Day*> days);
	
	Q_INVOKABLE
	int daysCount();
	
	 // access from C++ to days
	QList<Day*> days();
	void setDays(QList<Day*> days);
	// access from QML to days
	QQmlListProperty<Day> daysPropertyList();
	
	Q_INVOKABLE
	QVariantList tracksAsQVariantList();
	
	Q_INVOKABLE
	QVariantList tracksAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList tracksAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToTracks(SessionTrack* sessionTrack);
	
	Q_INVOKABLE
	bool removeFromTracks(SessionTrack* sessionTrack);

	Q_INVOKABLE
	void clearTracks();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool areTracksKeysResolved();

	Q_INVOKABLE
	QStringList tracksKeys();

	Q_INVOKABLE
	void resolveTracksKeys(QList<SessionTrack*> tracks);
	
	Q_INVOKABLE
	int tracksCount();
	
	 // access from C++ to tracks
	QList<SessionTrack*> tracks();
	void setTracks(QList<SessionTrack*> tracks);
	// access from QML to tracks
	QQmlListProperty<SessionTrack> tracksPropertyList();
	
	Q_INVOKABLE
	QVariantList roomsAsQVariantList();
	
	Q_INVOKABLE
	QVariantList roomsAsCacheQVariantList();
	
	Q_INVOKABLE
	QVariantList roomsAsForeignQVariantList();

	
	Q_INVOKABLE
	void addToRooms(Room* room);
	
	Q_INVOKABLE
	bool removeFromRooms(Room* room);

	Q_INVOKABLE
	void clearRooms();

	// lazy Array of independent Data Objects: only keys are persisted
	Q_INVOKABLE
	bool areRoomsKeysResolved();

	Q_INVOKABLE
	QStringList roomsKeys();

	Q_INVOKABLE
	void resolveRoomsKeys(QList<Room*> rooms);
	
	Q_INVOKABLE
	int roomsCount();
	
	 // access from C++ to rooms
	QList<Room*> rooms();
	void setRooms(QList<Room*> rooms);
	// access from QML to rooms
	QQmlListProperty<Room> roomsPropertyList();


	virtual ~Conference();

	Q_SIGNALS:

	void idChanged(int id);
	void conferenceNameChanged(QString conferenceName);
	void conferenceCityChanged(QString conferenceCity);
	void addressChanged(QString address);
	void timeZoneNameChanged(QString timeZoneName);
	void timeZoneOffsetSecondsChanged(int timeZoneOffsetSeconds);
	void conferenceFromChanged(QDate conferenceFrom);
	void conferenceToChanged(QDate conferenceTo);
	void hashTagChanged(QString hashTag);
	void homePageChanged(QString homePage);
	void coordinateChanged(QString coordinate);
	void lastRoomIdChanged(int lastRoomId);
	void lastSessionTrackIdChanged(int lastSessionTrackId);
	void lastGenericSessionIdChanged(int lastGenericSessionId);
	void daysChanged(QList<Day*> days);
	void addedToDays(Day* day);
	void daysPropertyListChanged();
	
	void tracksChanged(QList<SessionTrack*> tracks);
	void addedToTracks(SessionTrack* sessionTrack);
	void tracksPropertyListChanged();
	
	void roomsChanged(QList<Room*> rooms);
	void addedToRooms(Room* room);
	void roomsPropertyListChanged();
	
	

private:

	int mId;
	QString mConferenceName;
	QString mConferenceCity;
	QString mAddress;
	QString mTimeZoneName;
	int mTimeZoneOffsetSeconds;
	QDate mConferenceFrom;
	QDate mConferenceTo;
	QString mHashTag;
	QString mHomePage;
	QString mCoordinate;
	int mLastRoomId;
	int mLastSessionTrackId;
	int mLastGenericSessionId;
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mDaysKeys;
	bool mDaysKeysResolved;
	QList<Day*> mDays;
	// implementation for QQmlListProperty to use
	// QML functions for List of Day*
	static void appendToDaysProperty(QQmlListProperty<Day> *daysList,
		Day* day);
	static int daysPropertyCount(QQmlListProperty<Day> *daysList);
	static Day* atDaysProperty(QQmlListProperty<Day> *daysList, int pos);
	static void clearDaysProperty(QQmlListProperty<Day> *daysList);
	
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mTracksKeys;
	bool mTracksKeysResolved;
	QList<SessionTrack*> mTracks;
	// implementation for QQmlListProperty to use
	// QML functions for List of SessionTrack*
	static void appendToTracksProperty(QQmlListProperty<SessionTrack> *tracksList,
		SessionTrack* sessionTrack);
	static int tracksPropertyCount(QQmlListProperty<SessionTrack> *tracksList);
	static SessionTrack* atTracksProperty(QQmlListProperty<SessionTrack> *tracksList, int pos);
	static void clearTracksProperty(QQmlListProperty<SessionTrack> *tracksList);
	
	// lazy Array of independent Data Objects: only keys are persisted
	QStringList mRoomsKeys;
	bool mRoomsKeysResolved;
	QList<Room*> mRooms;
	// implementation for QQmlListProperty to use
	// QML functions for List of Room*
	static void appendToRoomsProperty(QQmlListProperty<Room> *roomsList,
		Room* room);
	static int roomsPropertyCount(QQmlListProperty<Room> *roomsList);
	static Room* atRoomsProperty(QQmlListProperty<Room> *roomsList, int pos);
	static void clearRoomsProperty(QQmlListProperty<Room> *roomsList);
	

	Q_DISABLE_COPY (Conference)
};
Q_DECLARE_METATYPE(Conference*)

#endif /* CONFERENCE_HPP_ */

