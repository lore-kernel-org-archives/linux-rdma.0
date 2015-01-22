From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Thu, 22 Jan 2015 15:31:19 +0200
Message-ID: <1421933479-18214-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

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
explicitly to sendonly join whenever there is a packet from sendonly type.

Since ipoib_mcast_sendonly_join() is now called from the driver TX flow,
we can't take mutex there. We avoid locking by testing the multicast
object to be valid (not error or null).

Fixes: 016d9fb25cd9 ('IPoIB: fix MCAST_FLAG_BUSY usage')
Reported-by: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Changes from V1:

1. always do clear_bit(IPOIB_MCAST_FLAG_BUSY) inipoib_mcast_sendonly_join_complete()

2. Sync between ipoib_mcast_sendonly_join() to ipoib_mcast_sendonly_join_complete 
using a IS_ERR_OR_NULL() test

 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index bc50dd0..212cfb4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -342,7 +342,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	rec.port_gid = priv->local_gid;
 	rec.pkey     = cpu_to_be16(priv->pkey);
 
-	mutex_lock(&mcast_mutex);
 	init_completion(&mcast->done);
 	set_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
@@ -354,8 +353,8 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 					 GFP_ATOMIC,
 					 ipoib_mcast_sendonly_join_complete,
 					 mcast);
-	if (IS_ERR(mcast->mc)) {
-		ret = PTR_ERR(mcast->mc);
+	if (IS_ERR_OR_NULL(mcast->mc)) {
+		ret = mcast->mc ? PTR_ERR(mcast->mc) : -EAGAIN;
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 		complete(&mcast->done);
 		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
@@ -364,7 +363,6 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
 				"sendonly join\n", mcast->mcmember.mgid.raw);
 	}
-	mutex_unlock(&mcast_mutex);
 
 	return ret;
 }
@@ -622,10 +620,8 @@ void ipoib_mcast_join_task(struct work_struct *work)
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
 
@@ -725,8 +721,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
 		__ipoib_mcast_add(dev, mcast);
 		list_add_tail(&mcast->list, &priv->multicast_list);
-		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
-			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
 	}
 
 	if (!mcast->ah) {
@@ -740,6 +734,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
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
