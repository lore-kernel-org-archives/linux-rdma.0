From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] IPoIB: Free ipoib neigh on path record failure so path rec queries are retried
Date: Mon, 25 Feb 2013 09:46:49 -0800
Message-ID: <1361814409-6704-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

If IPoIB fails to look up a path record (eg if it tries during an SM
failover when one SM is dead but the new one hasn't taken over yet), the
driver ends up with a neighbour structure but no address handle (AH).
There's no mechanism to recover from this: any further packets sent to
this destination will be silently dumped in ipoib_start_xmit().

Fix this by freeing the neighbour structures when a path rec query
fails, so that the next packet queued to be sent will trigger a new path
record query.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
We actually hit this while testing SM failover.  Let me know if there
are any objections to merging this for 3.9.

 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 66d6da9..8534afd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -510,6 +510,9 @@ static void path_rec_completion(int status,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	if (IS_ERR_OR_NULL(ah))
+		ipoib_del_neighs_by_gid(dev, path->pathrec.dgid.raw);
+
 	if (old_ah)
 		ipoib_put_ah(old_ah);
 
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
