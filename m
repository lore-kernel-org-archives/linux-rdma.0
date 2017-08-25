From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v1 07/11] IB/rxe: Fix up rxe_qp_cleanup()
Date: Fri, 25 Aug 2017 15:05:52 -0400
Message-ID: <1503687956-7110-8-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace sk_dst_get()/dst_release() in rxe_qp_cleanup() with sk_dst_reset().
sk_dst_get() takes a new reference on dst, so the dst_release() doesn't
actually release the original reference, which was the design intent.

Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 80ccc7c..00bda93 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -851,13 +851,8 @@ void rxe_qp_cleanup(struct rxe_pool_entry *arg)
 		qp->resp.mr = NULL;
 	}
 
-	if (qp_type(qp) == IB_QPT_RC) {
-		struct dst_entry *dst = NULL;
-
-		dst = sk_dst_get(qp->sk->sk);
-		if (dst)
-			dst_release(dst);
-	}
+	if (qp_type(qp) == IB_QPT_RC)
+		sk_dst_reset(qp->sk->sk);
 
 	free_rd_atomic_resources(qp);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
