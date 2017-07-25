From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 5/7] IB/rxe: Fix destination cache for IPv6
Date: Tue, 25 Jul 2017 09:39:26 -0400
Message-ID: <1500989968-30889-6-git-send-email-andrew.boyer@dell.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To successfully match an IPv6 path, the path cookie must match. Store it
in the QP so that the IPv6 path can be reused.

Replace open-coded version of dst_check() with the actual call, fixing the
logic. The open-coded version skips the check call if dst->obsolete is 0
(DST_OBSOLETE_NONE), proceeding to replace the route. DST_OBSOLETE_NONE
means that the route may continue to be used, though.

Add dst_clone() in prepare_ipv6_hdr(). Otherwise the reference count goes
negative as packets complete.

Replace sk_dst_get()/dst_release() in rxe_qp_cleanup() with sk_dst_reset().
sk_dst_get() takes a new reference on dst, so the dst_release() doesn't
actually release the original reference, which was the design intent.

Remove unneeded initialization in prepare6().

Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c   | 9 ++++++---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 9 ++-------
 drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 0810f38..6aeda61 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -191,7 +191,7 @@ static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
 	if (qp_type(qp) == IB_QPT_RC)
 		dst = sk_dst_get(qp->sk->sk);
 
-	if (!dst || !(dst->obsolete && dst->ops->check(dst, 0))) {
+	if (!dst || !dst_check(dst, qp->dst_cookie)) {
 		if (dst)
 			dst_release(dst);
 
@@ -209,6 +209,9 @@ static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
 			saddr6 = &av->sgid_addr._sockaddr_in6.sin6_addr;
 			daddr6 = &av->dgid_addr._sockaddr_in6.sin6_addr;
 			dst = rxe_find_route6(rxe->ndev, saddr6, daddr6);
+			if (dst)
+				qp->dst_cookie =
+					rt6_get_cookie((struct rt6_info *)dst);
 		}
 	}
 
@@ -337,7 +340,7 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED
 			    | IPSKB_REROUTED);
-	skb_dst_set(skb, dst);
+	skb_dst_set(skb, dst_clone(dst));
 
 	__skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
@@ -388,7 +391,7 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		    struct sk_buff *skb, struct rxe_av *av)
 {
 	struct rxe_qp *qp = pkt->qp;
-	struct dst_entry *dst = NULL;
+	struct dst_entry *dst;
 	struct in6_addr *saddr = &av->sgid_addr._sockaddr_in6.sin6_addr;
 	struct in6_addr *daddr = &av->dgid_addr._sockaddr_in6.sin6_addr;
 
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
