From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and multicast traffic
Date: Mon, 26 Jan 2015 15:00:27 +0200
Message-ID: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage" both
IPv6 traffic and for the most cases all IPv4 multicast traffic aren't
working.

After this change there is no mechanism to handle the work that does the
join process for the rest of the mcg's. For example, if in the list of
all the mcg's there is a send-only request, after its processing, the
code in ipoib_mcast_sendonly_join_complete() will not requeue the
mcast task, but leaves the bit that signals this task is running,
and hence the task will never run.

Also, whenever the kernel sends multicast packet (w.o joining to this
group), we don't call ipoib_send_only_join(), the code tries to start
the mcast task but it failed because the bit IPOIB_MCAST_RUN is always
set, As a result the multicast packet will never be sent.

The fix handles all the join requests via the same logic, and call
explicitly to sendonly join whenever there is a packet from sendonly
type.

Since ipoib_mcast_sendonly_join() is now called from the driver TX flow, we
can't take mutex there. We avoid this locking by using temporary pointer when
calling ib_sa_join_multicast and testing that pointer object to be valid (not
error), if it is an error the driver knows that the completion will not be
called, and the driver can set the mcast->mc value.


Fixes: 016d9fb25cd9 ('IPoIB: fix MCAST_FLAG_BUSY usage')
Reported-by: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
Changes from V1:
1. always do clear_bit(IPOIB_MCAST_FLAG_BUSY) in
ipoib_mcast_sendonly_join_complete()
2. Sync between ipoib_mcast_sendonly_join() to
ipoib_mcast_sendonly_join_complete using
an IS_ERR_OR_NULL(mcast->mc) test

Changes from V2:
1. ipoib_mcast_sendonly_join will not  abuse mcast->mc pointer.

 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   38 ++++++++++++------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index bc50dd0..bbb4d3d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -306,6 +306,8 @@ out:
 	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	if (status)
 		mcast->mc = NULL;
+	else
+		mcast->mc = multicast;
 	complete(&mcast->done);
 	if (status == -ENETRESET)
 		status = 0;
@@ -317,6 +319,7 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_sa_multicast	 *mc_ret;
 	struct ib_sa_mcmember_rec rec = {
 #if 0				/* Some SMs don't support send-only yet */
 		.join_state = 4
@@ -342,20 +345,20 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	rec.port_gid = priv->local_gid;
 	rec.pkey     = cpu_to_be16(priv->pkey);
 
-	mutex_lock(&mcast_mutex);
 	init_completion(&mcast->done);
 	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
-					 priv->port, &rec,
-					 IB_SA_MCMEMBER_REC_MGID	|
-					 IB_SA_MCMEMBER_REC_PORT_GID	|
-					 IB_SA_MCMEMBER_REC_PKEY	|
-					 IB_SA_MCMEMBER_REC_JOIN_STATE,
-					 GFP_ATOMIC,
-					 ipoib_mcast_sendonly_join_complete,
-					 mcast);
-	if (IS_ERR(mcast->mc)) {
-		ret = PTR_ERR(mcast->mc);
+	mc_ret = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
+				      priv->port, &rec,
+				      IB_SA_MCMEMBER_REC_MGID	|
+				      IB_SA_MCMEMBER_REC_PORT_GID	|
+				      IB_SA_MCMEMBER_REC_PKEY	|
+				      IB_SA_MCMEMBER_REC_JOIN_STATE,
+				      GFP_ATOMIC,
+				      ipoib_mcast_sendonly_join_complete,
+				      mcast);
+	if (IS_ERR(mc_ret)) {
+		mcast->mc = mc_ret;
+		ret = PTR_ERR(mc_ret);
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 		complete(&mcast->done);
 		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
@@ -364,7 +367,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
 				"sendonly join\n", mcast->mcmember.mgid.raw);
 	}
-	mutex_unlock(&mcast_mutex);
 
 	return ret;
 }
@@ -622,10 +624,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			break;
 		}
 
-		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
-			ipoib_mcast_sendonly_join(mcast);
-		else
-			ipoib_mcast_join(dev, mcast, 1);
+		ipoib_mcast_join(dev, mcast, 1);
+
 		return;
 	}
 
@@ -725,8 +725,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
-		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 	}
 
 	if (!mcast->ah) {
@@ -740,6 +738,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			ipoib_dbg_mcast(priv, "no address vector, "
 					"but multicast join already started\n");
+		else if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+			ipoib_mcast_sendonly_join(mcast);
 
 		/*
 		 * If lookup completes between here and out:, don't
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
