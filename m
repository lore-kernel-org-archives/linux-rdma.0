From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/22] IB/ipoib: Fixups for multicast issues
Date: Wed, 11 Feb 2015 20:43:23 -0500
Message-ID: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patchset revives the 8 patches that were reverted from 3.19,
the 11 patches that fixed the problems with the first 8, the single
patch that was related to reaping of ah's and failure to dealloc
resources on shutdown, and then adds two new patches that would
have been enhancements and not bugfixes and hence weren't appropriate
to post in the 3.19 tussle.

Testing of this patchset is currently underway, but it has done
well so far.  IPv4 multicast, IPv6 multicast, connected mode,
datagram mode, rmmod/insmod while active, restart opensm while
active, ifconfig up/ifconfig down in a tight while loop have
all passed.

There are two outstanding issues that I think stilll need addressed
(while performing all the other testing I ran across these issues,
and I think they existed prior to my patchset, but I haven't booted
up a clean kernel to verify it yet...I'll do that tomorrow and if
things are not as I expect, I'll report back here):

1) In connected mode, the initial ip6 ping to any host takes almost
exactly 1 second to complete.  The debug messages show this delay
very clearly:

[19059.689967] qib_ib0: joining MGID ff12:601b:ffff:0000:0000:0001:ff31:7791
[19059.689970] qib_ib0: successfully started all multicast joins
[19059.690313] qib_ib0: sendonly join completion for ff12:601b:ffff:0000:0000:0001:ff31:7791 (status 0)
[19059.690314] qib_ib0: Created ah ffff88080cc0ef60
[19059.690315] qib_ib0: MGID ff12:601b:ffff:0000:0000:0001:ff31:7791 AV ffff88080cc0ef60, LID 0xc035, SL 0 <- Final debug message from creating our AH and when we should have requeued our sends
[19060.694190] qib_ib0: REQ arrived <- almost exactly 1 second later, we
finally start setting up our connection

In datagram mode, this does not happen and initial startup of ping6
is mostly immediate.

2) In connected mode, restartng opensm repeatedly can cause some of
the machines to start failing to find other machines when trying to
use ping6.  However, they don't loose connectivity to all machines,
only specific machines.  A rmmod/insmod cycle solves the problem.
So does a full ifdown/ifup cycle.  Given enough idle time, the
problem goes away.  I suspect that neighbor flushing when in
connected mode is not reliable/sufficient when opensm events come
in.  Again, I think this exists in the upstream kernel and I'll
test more on that tomorrow.

Doug Ledford (22):
  IB/ipoib: Consolidate rtnl_lock tasks in workqueue
  IB/ipoib: Make the carrier_on_task race aware
  IB/ipoib: fix MCAST_FLAG_BUSY usage
  IB/ipoib: fix mcast_dev_flush/mcast_restart_task race
  IB/ipoib: change init sequence ordering
  IB/ipoib: Use dedicated workqueues per interface
  IB/ipoib: Make ipoib_mcast_stop_thread flush the workqueue
  IB/ipoib: No longer use flush as a parameter
  IB/ipoib: fix IPOIB_MCAST_RUN flag usage
  IB/ipoib: Add a helper to restart the multicast task
  IB/ipoib: make delayed tasks not hold up everything
  IB/ipoib: Handle -ENETRESET properly in our callback
  IB/ipoib: don't restart our thread on ENETRESET
  IB/ipoib: remove unneeded locks
  IB/ipoib: fix race between mcast_dev_flush and mcast_join
  IB/ipoib: fix ipoib_mcast_restart_task
  IB/ipoib: flush the ipoib_workqueue on unregister
  IB/ipoib: cleanup a couple debug messages
  IB/ipoib: make sure we reap all our ah on shutdown
  IB/ipoib: don't queue a work struct up twice
  IB/ipoib: deserialize multicast joins
  IB/ipoib: drop mcast_mutex usage

 drivers/infiniband/ulp/ipoib/ipoib.h           |  20 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  69 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  51 ++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 479 ++++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  24 +-
 6 files changed, 356 insertions(+), 305 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
