#ifndef DATAUTIL_H
#define DATAUTIL_H

#include <QObject>
#include "gen/DataManager.hpp"
#include "imageloader.hpp"
#include "dataserver.hpp"

class DataUtil : public QObject
{
    Q_OBJECT
public:
    explicit DataUtil(QObject *parent = nullptr);

    void init(DataManager *dataManager, DataServer* dataServer);

    void prepareConference();

    Q_INVOKABLE
    void checkVersion();

    Q_INVOKABLE
    void startUpdate();

    Q_INVOKABLE
    void setSessionFavorites();
    void saveSessionFavorites();

    Q_INVOKABLE
    void resolveSessionsForSchedule();

    Q_INVOKABLE
    void resolveSessionsForTracks();

    Q_INVOKABLE
    void resolveSessionsForRooms();

    Q_INVOKABLE
    void resolveSessionsForSpeaker(Speaker *speaker);

    Q_INVOKABLE
    QString scheduleTabName(int tabBarIndex);

    Q_INVOKABLE
    SessionLists* mySchedule();

    Q_INVOKABLE
    void refreshMySchedule();

    Q_INVOKABLE
    int findFirstSessionItem(int conferenceDayIndex, QString pickedTime);

    Q_INVOKABLE
    int findFirstSpeakerItem(QString letter);

    Q_INVOKABLE
    QString localWeekdayAndTime(QString sessionSortkey);

    Q_INVOKABLE
    QString apiInfo();

    Q_INVOKABLE
    void reloadData();

    // some helpers for QML UI
    Q_INVOKABLE
    QString conferenceDataPath4QML();

    Q_INVOKABLE
    bool isDateTooLate();

    Q_INVOKABLE
    bool isOldConference();

    Q_INVOKABLE
    QString sessionInfoForSpeaker(Speaker* speaker);

    Q_INVOKABLE
    QString speakerNamesForSession(Session* session);

    Q_INVOKABLE
    QString scheduleItemImageForSession(Session* session);

    Q_INVOKABLE
    QString letterForButton(Session* session);

    Q_INVOKABLE
    QString textForSessionTrack(SessionTrack *sessionTrack);

    Q_INVOKABLE
    QString textForSessionType(Session* session);

    Q_INVOKABLE
    QString trackColorFirstTrack(Session* session);

    Q_INVOKABLE
    Conference *currentConference();

    Q_INVOKABLE
    Conference *switchConference();

    Q_INVOKABLE
    bool isNoConference();

    Q_INVOKABLE
    QString conferenceCity(const int conferenceId);

    Q_INVOKABLE
    QString otherConferenceCity();

    Q_INVOKABLE
    QString displayStartToEnd(Session *session);

signals:
    void myScheduleRefreshed();

    void updateAvailable(const QString apiVersion);
    void noUpdateRequired();
    void checkForUpdateFailed(const QString message);

    void updateDone();
    void updateFailed(const QString message);

    void progressInfo(const QString progressInfo);

public slots:
    void onSpeakerImageUpdateLoaded(QObject *dataObject, int width, int height);
    void onSpeakerImageUpdateFailed(QObject *dataObject, QString message);

private slots:
    void onServerSuccess();
    void onServerFailed(const QString message);

    void onVersionSuccess(QByteArray currentVersionBytes);
    void onVersionFailed(const QString message);

private:

    DataManager* mDataManager;
    DataServer* mDataServer;

    Conference* mCurrentConference;

    ImageLoader* mImageLoader;

    SessionLists* mSessionLists;

    void prepareHighDpiImages(SpeakerImage *speakerImage, int width, int height);

    void prepareEventData();
    void prepareRooms();
    void prepareSanFrancisco201601();
    void prepareTokyo201902();
    void prepareBerlin201901();
    void addGenericSessionsBerlin201901();
    void addGenericSessionsTokyo201902();

    bool checkDirs();
    QString mConferenceDataPath;
    QString mCacheDataPath;

    // UPDATE
    void continueUpdate();
    QString mNewApi;
    QString mProgressInfotext;
    QMultiMap<QString, Session*> mMultiSession;
    QMultiMap<QString, Speaker*> mMultiSpeaker;
    QMultiMap<bool, SpeakerImage*> mMultiSpeakerImages;
    QVariantMap readScheduleFile(const QString schedulePath);
    QVariantList readSpeakerFile(const QString speakerPath);
    QVariantList readRoomMappingFile(const QString path);
    void calcSpeakerName(Speaker *speaker, SpeakerAPI *speakerAPI);
    void updateSpeakerImages();
    bool updateSessions(const int conferenceId);
    Day *findDayForServerDate(const QString &dayDate, Conference *conference);
    void adjustPersons(QVariantMap &sessionMap);
    void adjustTracks(QVariantMap &sessionMap, Conference *conference, const bool isUpdate);
    bool checkIfIgnored(SessionAPI *sessionAPI);
    void setDuration(SessionAPI *sessionAPI, Session* session);
    void setType(Session *session);
    void finishUpdate();
    void sortedSessionsIntoRoomDayTrackSpeaker();

    // helper as workaround for generator bug
    QList<Session *> listOfSessionForSortedKeys(QStringList keyList);
};

#endif // DATAUTIL_H
