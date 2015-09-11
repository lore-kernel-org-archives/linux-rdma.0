From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-4.3] IB/ipoib: add module option for auto-creating mcast groups
Date: Thu, 10 Sep 2015 21:21:05 -0400
Message-ID: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During the recent rework of the mcast handling in ipoib, the join
task for regular and send-only joins were merged.  In the old code,
the comments indicated that the ipoib driver didn't send enough
information to auto-create IB multicast groups when the join was a
send-only join.  The reality is that the comments said we didn't, but
we actually did.  Since we merged the two join tasks, we now follow
the comments and don't auto-create IB multicast groups for an ipoib
send-only multicast join.  This has been reported to cause problems
in certain environments that rely on this behavior.  Specifically,
if you have an IB <-> Ethernet gateway then there is a fundamental
mismatch between the methodologies used on the two fabrics.  On
Ethernet, an app need not subscribe to a multicast group, merely
listen.  As such, the Ethernet side of the gateway has no way of
knowing if there are listeners.  If we don't create groups for sends
in this case, and the listeners are only on the Ethernet side of
the gateway, the listeners will not get any of the packets sent
on the IB side of the gateway.  There are instances of installations
with 100's (maybe 1000's) of multicast groups where static creation
of all the groups is not practical that rely upon the send-only
joins creating the IB multicast group in order to function, so to
preserve these existing installations, add a module option to the
ipoib module to restore the previous behavior.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 32 +++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 09a1748f9d13..2d95b8ae379b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -47,6 +47,11 @@
 
 #include "ipoib.h"
 
+static bool __read_mostly mcast_auto_create;
+
+module_param(mcast_auto_create, bool, 0644);
+MODULE_PARM_DESC(mcast_auto_create, "Should multicast sends auto-create the IB multicast group? (Default: false)");
+
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
 static int mcast_debug_level;
 
@@ -514,9 +519,34 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		 * detect if there are full members or not. A major problem
 		 * with supporting SEND ONLY is detecting when the group is
 		 * auto-destroyed as IPoIB will cache the MLID..
+		 *
+		 * An additional problem is that if we auto-create the IB
+		 * mcast group in response to a send-only action, then we
+		 * will be the creating entity, but we will not have any
+		 * mechanism by which we will track when we should leave
+		 * the group ourselves.  We will occasionally leave and
+		 * re-join the group when these events occur:
+		 *
+		 * 1) ifdown/ifup
+		 * 2) a regular mcast join/leave happens and we run
+		 *    ipoib_mcast_restart_task
+		 * 3) a REREGISTER event comes in from the SM
+		 * 4) any other event that might cause a mcast flush
+		 *
+		 * However, these events are not deterministic and we can
+		 * leave unused groups subscribed for long periods of time.
+		 * In addition, since the core IB layer does not yet support
+		 * send-only IB joins, we have to do a regular join and then
+		 * simply never attach a QP to listen to the incoming data.
+		 * This means that phantom, wasted data will end up coming
+		 * across our inbound physical link only to be thrown away
+		 * by the multicast dispatch mechanism on the card or in
+		 * the kernel driver.  For these reasons, we default to not
+		 * auto creating groups for send-only multicast operations.
 		 */
 #if 1
-		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
+		    !mcast_auto_create)
 			comp_mask &= ~IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
 #else
 		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
