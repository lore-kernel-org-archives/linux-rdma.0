From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
Date: Wed, 14 Jan 2015 14:52:51 -0500
Message-ID: <cover.1421264928.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

v3: Resend because the last send didn't register in patchworks properly
    (because the subject-prefix was not on all of the emails, only the
    first) and because the Cc: list didn't not pass from cover letter
    to patches

v2: Added two new patches, the first creates a helper to restart the
    multicast join thread and also adds using it in the two places where
    it should have been used but wasn't, the second allows the joins to
    proceed around a delayed join instead of stalling everything.

v1: Addressed the usage of the IPOIB_MCAST_RUN flag

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
