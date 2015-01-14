From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 FIX For 3.19 0/3] IB/ipoib: fixup multicast join thread usage
Date: Wed, 14 Jan 2015 14:05:25 -0500
Message-ID: <cover.1421261785.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series fixes the multicast join behavior problems introduced
by my previous patchset.  In particular, the original code did not use
the send only join code from the multicast thread context, and so it
did not need to restart the multicast thread.  After my previous patchset,
it does get called from the thread context, and so the send only join
completion areas need to restart the join thread but they don't.  This
patchset makes them do so.  It then adds in some cleanups for restarting
the thread, and fixes the fact that one delayed join holds up the entire
list of joins.

Doug Ledford (3):
  IB/ipoib: Fix failed multicast joins/sends
  IB/ipoib: Add a helper to restart the multicast task
  IB/ipoib: make delayed tasks not hold up everything

 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 94 ++++++++++++++++++--------
 2 files changed, 66 insertions(+), 29 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
