#ifndef REACHABILITYLISTENER_H
#define REACHABILITYLISTENER_H

#include <QtGlobal>

Q_FORWARD_DECLARE_OBJC_CLASS(ReachabilityListener);

namespace utility
{

enum NetworkStatus
{
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
};

class ReachabilityDelegate
{
public:
    ReachabilityDelegate();
    virtual ~ReachabilityDelegate();

    virtual void statusChanged(NetworkStatus n) = 0;
    NetworkStatus status() const;
private:
    ReachabilityListener *listener = nullptr;
};

}

#endif // REACHABILITYLISTENER_H
