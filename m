From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19] IB/ipoib: make sure we reap all our ah on shutdown
Date: Thu, 22 Jan 2015 17:02:19 -0500
Message-ID: <31ba9a1b4528599de17670083aad043b28eff755.1421964024.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The introduction of garbage collection for neighbors in the ipoib stack
caused a leak of resources.  In particular, an ah can have a refcount
from a mcast struct, from a neigh struct, and from a path struct.  When
we put an ah ref, the ah gets moved to a dead list to be reaped later if
the refcount goes to 0.

During ipoib_ib_dev_stop we attempt to reap these ah entries, but since
that function does not force the neigh garbage collection to be run, it
can leak any entries held by a neighbor.  And even though the code
attempts to warn us that we will leak entries, that warning is broken
because the entries we are leaking will not yet be on the dead_ahs list
because they still have valid references held elsewhere.  It is during
shutdown, when we finally kill the neighbor garbage collection, that our
final ahs will get put on the dead_ahs list, but after the point at
which we run the neighbor garbage collection, no attempt is made to reap
the newly added ahs, and because during ipoib_ib_dev_stop we killed the
ah_reap task, no timed attempt will be made to clear them either.

Instead, create a an ipoib_flush_ah and ipoib_stop_ah routines to use at
appropriate times to flush out all remaining ah entries before we shut
the device down.

Additionally do one final flush of our priv->wq before we start tearing
down ib resources to make sure all possible queued work is done and
all possible resources freed.

This is done to prevent resource leaks on shutdown, which manifest with
this message on ib_ipoib module remove:

<ibdev>: ib_dealloc_pd failed

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    | 44 ++++++++++++++++++------------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  4 ++-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index fe65abb5150..e144d07d53c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -659,6 +659,23 @@ void ipoib_reap_ah(struct work_struct *work)
 				   round_jiffies_relative(HZ));
 }
 
+static void ipoib_flush_ah(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	cancel_delayed_work(&priv->ah_reap_task);
+	flush_workqueue(priv->wq);
+	ipoib_reap_ah(&priv->ah_reap_task.work);
+}
+
+static void ipoib_stop_ah(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	set_bit(IPOIB_STOP_REAPER, &priv->flags);
+	ipoib_flush_ah(dev);
+}
+
 static void ipoib_ib_tx_timer_func(unsigned long ctx)
 {
 	drain_tx_cq((struct net_device *)ctx);
@@ -877,23 +894,7 @@ timeout:
 	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
 		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
 
-	/* Wait for all AHs to be reaped */
-	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	cancel_delayed_work(&priv->ah_reap_task);
-	flush_workqueue(priv->wq);
-
-	begin = jiffies;
-
-	while (!list_empty(&priv->dead_ahs)) {
-		__ipoib_reap_ah(dev);
-
-		if (time_after(jiffies, begin + HZ)) {
-			ipoib_warn(priv, "timing out; will leak address handles\n");
-			break;
-		}
-
-		msleep(1);
-	}
+	ipoib_flush_ah(dev);
 
 	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
 
@@ -1036,6 +1037,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	if (level == IPOIB_FLUSH_LIGHT) {
 		ipoib_mark_paths_invalid(dev);
 		ipoib_mcast_dev_flush(dev);
+		ipoib_flush_ah(dev);
 	}
 
 	if (level >= IPOIB_FLUSH_NORMAL)
@@ -1099,6 +1101,14 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	ipoib_mcast_stop_thread(dev);
 	ipoib_mcast_dev_flush(dev);
 
+	/*
+	 * All of our ah references aren't free until after
+	 * ipoib_mcast_dev_flush(), ipoib_flush_paths, and
+	 * the neighbor garbage collection is stopped and reaped.
+	 * That should all be done now, so make a final ah flush.
+	 */
+	ipoib_stop_ah(dev);
+
 	ipoib_transport_dev_cleanup(dev);
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index b72a753eb41..66df78382a4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -263,6 +263,9 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	if (priv->wq)
+		flush_workqueue(priv->wq);
+
 	if (priv->qp) {
 		if (ib_destroy_qp(priv->qp))
 			ipoib_warn(priv, "ib_qp_destroy failed\n");
@@ -286,7 +289,6 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 		ipoib_warn(priv, "ib_dealloc_pd failed\n");
 
 	if (priv->wq) {
-		flush_workqueue(priv->wq);
 		destroy_workqueue(priv->wq);
 		priv->wq = NULL;
 	}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
