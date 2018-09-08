#ifndef SESSIONTRACKAPI_HPP_
#define SESSIONTRACKAPI_HPP_

#include <QObject>
#include <qvariant.h>




class SessionTrackAPI: public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString uuid READ uuid WRITE setUuid NOTIFY uuidChanged FINAL)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
	Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged FINAL)


public:
	SessionTrackAPI(QObject *parent = 0);


	void fillFromMap(const QVariantMap& sessionTrackAPIMap);
	void fillFromForeignMap(const QVariantMap& sessionTrackAPIMap);
	void fillFromCacheMap(const QVariantMap& sessionTrackAPIMap);
	
	void prepareNew();
	
	bool isValid();

	Q_INVOKABLE
	QVariantMap toMap();
	QVariantMap toForeignMap();
	QVariantMap toCacheMap();

	QString uuid() const;
	void setUuid(QString uuid);
	QString name() const;
	void setName(QString name);
	QString color() const;
	void setColor(QString color);



	virtual ~SessionTrackAPI();

	Q_SIGNALS:

	void uuidChanged(QString uuid);
	void nameChanged(QString name);
	void colorChanged(QString color);
	

private:

	QString mUuid;
	QString mName;
	QString mColor;

	Q_DISABLE_COPY (SessionTrackAPI)
};
Q_DECLARE_METATYPE(SessionTrackAPI*)

#endif /* SESSIONTRACKAPI_HPP_ */

