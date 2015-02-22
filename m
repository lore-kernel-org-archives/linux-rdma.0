From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Sat, 21 Feb 2015 19:26:59 -0500
Message-ID: <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Create a an ipoib_flush_ah and ipoib_stop_ah routines to use at
appropriate times to flush out all remaining ah entries before we shut
the device down.

Because neighbors and mcast entries can each have a reference on any
given ah, we must make sure to free all of those first before our ah
will actually have a 0 refcount and be able to be reaped.

This factoring is needed in preparation for having per-device work
queues.  The original per-device workqueue code resulted in the following
error message:

<ibdev>: ib_dealloc_pd failed

That error was tracked down to this issue.  With the changes to which
workqueues were flushed when, there were no flushes of the per device
workqueue after the last ah's were freed, resulting in an attempt to
dealloc the pd with outstanding resources still allocated.  This code
puts the explicit flushes in the needed places to avoid that problem.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 46 ++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 72626c34817..cb02466a0eb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -659,6 +659,24 @@ void ipoib_reap_ah(struct work_struct *work)
 				   round_jiffies_relative(HZ));
 }
 
+static void ipoib_flush_ah(struct net_device *dev, int flush)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	cancel_delayed_work(&priv->ah_reap_task);
+	if (flush)
+		flush_workqueue(ipoib_workqueue);
+	ipoib_reap_ah(&priv->ah_reap_task.work);
+}
+
+static void ipoib_stop_ah(struct net_device *dev, int flush)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	set_bit(IPOIB_STOP_REAPER, &priv->flags);
+	ipoib_flush_ah(dev, flush);
+}
+
 static void ipoib_ib_tx_timer_func(unsigned long ctx)
 {
 	drain_tx_cq((struct net_device *)ctx);
@@ -877,24 +895,7 @@ timeout:
 	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
 		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
 
-	/* Wait for all AHs to be reaped */
-	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	cancel_delayed_work(&priv->ah_reap_task);
-	if (flush)
-		flush_workqueue(ipoib_workqueue);
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
+	ipoib_flush_ah(dev, flush);
 
 	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
 
@@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	if (level == IPOIB_FLUSH_LIGHT) {
 		ipoib_mark_paths_invalid(dev);
 		ipoib_mcast_dev_flush(dev);
+		ipoib_flush_ah(dev, 0);
 	}
 
 	if (level >= IPOIB_FLUSH_NORMAL)
@@ -1100,6 +1102,14 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
 	ipoib_mcast_stop_thread(dev, 1);
 	ipoib_mcast_dev_flush(dev);
 
+	/*
+	 * All of our ah references aren't free until after
+	 * ipoib_mcast_dev_flush(), ipoib_flush_paths, and
+	 * the neighbor garbage collection is stopped and reaped.
+	 * That should all be done now, so make a final ah flush.
+	 */
+	ipoib_stop_ah(dev, 1);
+
 	ipoib_transport_dev_cleanup(dev);
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
