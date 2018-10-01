#ifndef UNSAFEAREA_HPP
#define UNSAFEAREA_HPP

#include <QObject>

class UnsafeArea : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int unsafeTopMargin READ unsafeTopMargin WRITE setUnsafeTopMargin NOTIFY unsafeTopMarginChanged FINAL)
    Q_PROPERTY(int unsafeBottomMargin READ unsafeBottomMargin WRITE setUnsafeBottomMargin NOTIFY unsafeBottomMarginChanged FINAL)
    Q_PROPERTY(int unsafeLeftMargin READ unsafeLeftMargin WRITE setUnsafeLeftMargin NOTIFY unsafeLeftMarginChanged FINAL)
    Q_PROPERTY(int unsafeRightMargin READ unsafeRightMargin WRITE setUnsafeRightMargin NOTIFY unsafeRightMarginChanged FINAL)

    Q_ENUMS(MyDevice)

public:
    UnsafeArea(QObject *parent = nullptr);

    int unsafeTopMargin() const;
    int unsafeBottomMargin() const;
    int unsafeLeftMargin() const;
    int unsafeRightMargin() const;

    void setUnsafeTopMargin(int unsafeTopMargin);
    void setUnsafeBottomMargin(int unsafeBottomMargin);
    void setUnsafeLeftMargin(int unsafeLeftMargin);
    void setUnsafeRightMargin(int unsafeRightMargin);

    Q_INVOKABLE
    void configureDevice(int height, int width, int devicePixelRatio);

    Q_INVOKABLE
    void orientationChanged(int orientation);

    Q_INVOKABLE
    bool isKnownIPhone();

    Q_INVOKABLE
    bool isKnownIPad();

    virtual ~UnsafeArea();

    enum MyDevice {
        OTHER,
        IPHONE_5_5S_5C,
        IPHONE_6_6S_7_8,
        IPHONE_6PLUS_6SPLUS_7PLUS_8PLUS,
        IPHONE_X_XS,
        IPHONE_XSMAX,
        IPHONE_XR,
        IPADPRO_129,
        IPADPRO_105,
        IPADPRO_97_AIR_MINI
         };

signals:
    void unsafeTopMarginChanged(int unsafeTopMargin);
    void unsafeBottomMarginChanged(int unsafeBottomMargin);
    void unsafeLeftMarginChanged(int unsafeLeftMargin);
    void unsafeRightMarginChanged(int unsafeRightMargin);

private:
    int mUnsafeTopMargin;
    int mUnsafeBottomMargin;
    int mUnsafeLeftMargin;
    int mUnsafeRightMargin;

    void portrait();
    void portraitInverted();
    void landscapeLeft();
    void landscapeRight();

    MyDevice mMyDevice;

    Q_DISABLE_COPY (UnsafeArea)
};
Q_DECLARE_METATYPE(UnsafeArea*)

#endif // UNSAFEAREA_HPP
