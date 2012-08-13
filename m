From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fix/for-3.6 0/2] IB/ipoib: bug fixes for the neighbour / hash change
Date: Mon, 13 Aug 2012 17:39:48 +0300
Message-ID: <1344868790-21146-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

Commit b63b70d8 "IPoIB: Use a private hash table for path lookup
in xmit path" introduced bugs found when further stress tests were
applied to IPoIB, this patch set contains the fixes.

Or.

Shlomo Pongratz (2):
  IB/ipoib: Add missing locking when CM object is deleted
  IB/ipoib: Fix RCU pointer dereference to wrong object

 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |    3 +++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
