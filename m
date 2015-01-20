From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH FIX For-3.19 v4 5/7] IB/ipoib: don't restart our thread on ENETRESET
Date: Mon, 19 Jan 2015 22:58:44 -0500
Message-ID: <22c4b7c5fe45d4a648f4fc120160db4b47e145c8.1421725318.git.dledford@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the send only join completion handler behave like the normal join
completion handler in that we should restart the multicast join thread
whenever our join completes with either an error or success, but don't
restart the thread if we got a net reset event, let ipoib_event queue
up a device flush, which will then call ipoib_mcast_dev_flush to remove
all of the current mcast entries, and ipoib_mcase_restart_task to check
out current mcast entry list against the netdev list of mcast entries
we are supposed to have and requeue the ones we need to get back.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 50d2de2270a..a03b6a04203 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -336,17 +336,18 @@ ipoib_mcast_sendonly_join_complete(int status,
 			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
 		}
 		netif_tx_unlock_bh(dev);
+		__ipoib_mcast_continue_join_thread(priv, mcast, 1);
 	} else {
 		/* Join completed, so reset any backoff parameters */
 		mcast->backoff = 1;
 		mcast->delay_until = jiffies;
+		__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	}
 out:
 	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
 	if (status)
 		mcast->mc = NULL;
 	complete(&mcast->done);
-	__ipoib_mcast_continue_join_thread(priv, NULL, 0);
 	mutex_unlock(&mcast_mutex);
 	return status;
 }
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
