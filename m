From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 05/11] IB/rxe: Fix destination cache for IPv6
Date: Mon, 28 Aug 2017 16:11:53 -0400
Message-ID: <1503951119-25573-6-git-send-email-andrew.boyer@dell.com>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503951119-25573-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To successfully match an IPv6 path, the path cookie must match. Store it
in the QP so that the IPv6 path can be reused.

Replace open-coded version of dst_check() with the actual call, fixing the
logic. The open-coded version skips the check call if dst->obsolete is 0
(DST_OBSOLETE_NONE), proceeding to replace the route. DST_OBSOLETE_NONE
means that the route may continue to be used, though.

Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c   | 7 ++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0810f38..a93ae3a 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -191,7 +191,7 @@ static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
 	if (qp_type(qp) == IB_QPT_RC)
 		dst = sk_dst_get(qp->sk->sk);
 
-	if (!dst || !(dst->obsolete && dst->ops->check(dst, 0))) {
+	if (!dst || !dst_check(dst, qp->dst_cookie)) {
 		if (dst)
 			dst_release(dst);
 
@@ -209,6 +209,11 @@ static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
 			saddr6 = &av->sgid_addr._sockaddr_in6.sin6_addr;
 			daddr6 = &av->dgid_addr._sockaddr_in6.sin6_addr;
 			dst = rxe_find_route6(rxe->ndev, saddr6, daddr6);
+#if IS_ENABLED(CONFIG_IPV6)
+			if (dst)
+				qp->dst_cookie =
+					rt6_get_cookie((struct rt6_info *)dst);
+#endif
 		}
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index b09a9e2..0c2dbe4 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -248,6 +248,7 @@ struct rxe_qp {
 	struct rxe_rq		rq;
 
 	struct socket		*sk;
+	u32			dst_cookie;
 
 	struct rxe_av		pri_av;
 	struct rxe_av		alt_av;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
