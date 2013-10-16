From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 5/7] IB/ipoib: Fix usage of uninitialized multicast objects
Date: Wed, 16 Oct 2013 17:37:51 +0300
Message-ID: <1381934273-29683-6-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The driver should avoid calling ib_sa_free_multicast over the mcast->mc object
until it finishes its initialization state. Otherwise it can end with kernel crash
when the flow of ipoib_mcast_dev_flush attempts to use uninitialized multicast object.

Instead, wait_for_completion() is called only for multicast entries that
started the join process, meaning that ib_sa_join_multicast() finished.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 ++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ec9190e..c639f90 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -101,6 +101,7 @@ enum {
 	IPOIB_MCAST_FLAG_SENDONLY = 1,
 	IPOIB_MCAST_FLAG_BUSY	  = 2,	/* joining or already joined */
 	IPOIB_MCAST_FLAG_ATTACHED = 3,
+	IPOIB_MCAST_JOIN_STARTED  = 4,
 
 	MAX_SEND_CQE		  = 16,
 	IPOIB_CM_COPYBREAK	  = 256,
@@ -151,6 +152,7 @@ struct ipoib_mcast {
 	struct sk_buff_head pkt_queue;
 
 	struct net_device *dev;
+	struct completion done;
 };
 
 struct ipoib_rx_buf {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index cecb98a..780a2a0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -386,8 +386,10 @@ static int ipoib_mcast_join_complete(int status,
 			mcast->mcmember.mgid.raw, status);
 
 	/* We trap for port events ourselves. */
-	if (status == -ENETRESET)
-		return 0;
+	if (status == -ENETRESET) {
+		status = 0;
+		goto out;
+	}
 
 	if (!status)
 		status = ipoib_mcast_join_finish(mcast, &multicast->rec);
@@ -407,7 +409,8 @@ static int ipoib_mcast_join_complete(int status,
 		if (mcast == priv->broadcast)
 			queue_work(ipoib_workqueue, &priv->carrier_on_task);
 
-		return 0;
+		status = 0;
+		goto out;
 	}
 
 	if (mcast->logcount++ < 20) {
@@ -434,7 +437,8 @@ static int ipoib_mcast_join_complete(int status,
 				   mcast->backoff * HZ);
 	spin_unlock_irq(&priv->lock);
 	mutex_unlock(&mcast_mutex);
-
+out:
+	complete(&mcast->done);
 	return status;
 }
 
@@ -484,11 +488,15 @@ static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast,
 	}
 
 	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+	init_completion(&mcast->done);
+	set_bit(IPOIB_MCAST_JOIN_STARTED, &mcast->flags);
+
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
 					 &rec, comp_mask, GFP_KERNEL,
 					 ipoib_mcast_join_complete, mcast);
 	if (IS_ERR(mcast->mc)) {
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
+		complete(&mcast->done);
 		ret = PTR_ERR(mcast->mc);
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
 
@@ -751,6 +759,11 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* seperate between the wait to the leave*/
+	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
+		if (test_bit(IPOIB_MCAST_JOIN_STARTED, &mcast->flags))
+			wait_for_completion(&mcast->done);
+
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(dev, mcast);
 		ipoib_mcast_free(mcast);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
