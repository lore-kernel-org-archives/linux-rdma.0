From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/10] IPoIB locking fixes and a couple minor other patches
Date: Wed, 10 Dec 2014 11:46:57 -0500
Message-ID: <cover.1418229671.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As the locking fixes have missed two releases now, I'm resending them.
The other two items are minor (the pr_* function one at least makes
the system more usable by making output message point to the module
making all of the dmesg noise, the other is one I contend is the right
thing to do until we have a replacement for the cache).

These can also be pulled from my github repo as:

git://github.com/dledford/linux.git for-next

Bart Van Assche (1):
  IB/srp: Use P_Key cache for P_Key lookups

Doug Ledford (9):
  IPoIB: Consolidate rtnl_lock tasks in workqueue
  IPoIB: Make the carrier_on_task race aware
  IPoIB: fix MCAST_FLAG_BUSY usage
  IPoIB: fix mcast_dev_flush/mcast_restart_task race
  IPoIB: change init sequence ordering
  IPoIB: Use dedicated workqueues per interface
  IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
  IPoIB: No longer use flush as a parameter
  ib_srpt: convert printk's to pr_* functions

 drivers/infiniband/ulp/srp/ib_srp.c   |   9 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 188 ++++++++++++++++------------------
 2 files changed, 96 insertions(+), 101 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
