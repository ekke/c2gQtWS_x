#include <cassert>
#include <mutex>

#include <Foundation/Foundation.h>

#include "ReachabilityListener.h"
#include "Reachability.h"


@interface  ReachabilityListener : NSObject
@end

@implementation ReachabilityListener
{
    utility::ReachabilityDelegate *delegate;
    Reachability *reachability;
}

- (instancetype)initWithDelegate:(utility::ReachabilityDelegate *) aDelegate
{
    assert(aDelegate);

    if (self = [super init]) {
        delegate = aDelegate;
        reachability = [Reachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver : self selector : @selector(reachabilityStatusChanged:) name : kReachabilityChangedNotification object : nil];
        [reachability startNotifier];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reachability stopNotifier];
    [reachability release];

    [super dealloc];
}

- (void) reachabilityStatusChanged : (Reachability *) notUsed
{
#pragma unused(notUsed)
    assert(delegate);
    delegate->statusChanged(([reachability currentReachabilityStatus]));
}

- (utility::NetworkStatus) status
{
    return [reachability currentReachabilityStatus];
}

@end

namespace utility {

ReachabilityDelegate::ReachabilityDelegate()
{
    listener = [[ReachabilityListener alloc] initWithDelegate:this];
}

ReachabilityDelegate::~ReachabilityDelegate()
{
    [listener release];
}

NetworkStatus ReachabilityDelegate::status() const
{
    return [listener status];
}

}
