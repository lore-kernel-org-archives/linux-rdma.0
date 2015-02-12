From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/22] IB/ipoib: cleanup a couple debug messages
Date: Wed, 11 Feb 2015 20:43:41 -0500
Message-ID: <7aeffef3862526da5a472c15f94564897a4d7537.1423703861.git.dledford@redhat.com>
References: <cover.1423703861.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The one I removed in particular can prevent progress in the driver from
happening because it isn't rate limited.  In my testing, I have seen the
flood of messages from that debug message delay multicast joins for in
excess of 30 seconds.

The added debug message was just so I would know when we were leaving a
multicast group that we didn't fully join.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 10e05437c83..ad2bcd105e4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -711,6 +711,8 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 
 	if (!IS_ERR_OR_NULL(mcast->mc))
 		ib_sa_free_multicast(mcast->mc);
+	else
+		ipoib_dbg(priv, "ipoib_mcast_leave with mcast->mc invalid\n");
 
 	if (test_and_clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
 		ipoib_dbg_mcast(priv, "leaving MGID %pI6\n",
@@ -721,7 +723,9 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 				      be16_to_cpu(mcast->mcmember.mlid));
 		if (ret)
 			ipoib_warn(priv, "ib_detach_mcast failed (result = %d)\n", ret);
-	}
+	} else if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+		ipoib_dbg(priv, "leaving with no mcmember but not a "
+			  "SENDONLY join\n");
 
 	return 0;
 }
@@ -772,11 +776,6 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 			++dev->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
 		}
-
-		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-			ipoib_dbg_mcast(priv, "no address vector, "
-					"but multicast join already started\n");
-
 		/*
 		 * If lookup completes between here and out:, don't
 		 * want to send packet twice.
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
