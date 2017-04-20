From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/rxe: Cache dst in QP instead of getting it for each send
Date: Thu, 20 Apr 2017 20:55:56 +0300
Message-ID: <20170420175556.8573-2-leon@kernel.org>
References: <20170420175556.8573-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175556.8573-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In RC QP there is no need to resolve the outgoing interface
for each packet, as this does not change during QP life cycle.

Instead cache the interface on the socket and use that one.
This improves performance by 12% by sparing redundant
calls to rxe_find_route.

ib_send_bw -d rxe0  -x 1 -n 9000 -e  -s $((1024 * 1024 )) -l 100

----------------------------------------------------------------------------------------
|        | bytes   | iterations | BW peak[MB/sec] | BW average[MB/sec] | MsgRate[Mpps] |
----------------------------------------------------------------------------------------
| before | 1048576 | 9000       | inf             | 551.21             | 0.000551      |
| after  | 1048576 | 9000       | inf             | 615.54             | 0.000616      |
----------------------------------------------------------------------------------------

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 55 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/sw/rxe/rxe_qp.c  |  8 ++++++
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index d8610960630a..bf2c5324e107 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -210,6 +210,39 @@ static struct dst_entry *rxe_find_route6(struct net_device *ndev,

 #endif

+static struct dst_entry *rxe_find_route(struct rxe_dev *rxe,
+					struct rxe_qp *qp,
+					struct rxe_av *av)
+{
+	struct dst_entry *dst = NULL;
+
+	if (qp_type(qp) == IB_QPT_RC)
+		dst = sk_dst_get(qp->sk->sk);
+
+	if (!dst || !(dst->obsolete && dst->ops->check(dst, 0))) {
+		if (dst)
+			dst_release(dst);
+
+		if (av->network_type == RDMA_NETWORK_IPV4) {
+			struct in_addr *saddr;
+			struct in_addr *daddr;
+
+			saddr = &av->sgid_addr._sockaddr_in.sin_addr;
+			daddr = &av->dgid_addr._sockaddr_in.sin_addr;
+			dst = rxe_find_route4(rxe->ndev, saddr, daddr);
+		} else if (av->network_type == RDMA_NETWORK_IPV6) {
+			struct in6_addr *saddr6;
+			struct in6_addr *daddr6;
+
+			saddr6 = &av->sgid_addr._sockaddr_in6.sin6_addr;
+			daddr6 = &av->dgid_addr._sockaddr_in6.sin6_addr;
+			dst = rxe_find_route6(rxe->ndev, saddr6, daddr6);
+		}
+	}
+
+	return dst;
+}
+
 static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct udphdr *udph;
@@ -301,7 +334,7 @@ static void prepare_ipv4_hdr(struct dst_entry *dst, struct sk_buff *skb,
 	skb_scrub_packet(skb, xnet);

 	skb_clear_hash(skb);
-	skb_dst_set(skb, dst);
+	skb_dst_set(skb, dst_clone(dst));
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));

 	skb_push(skb, sizeof(struct iphdr));
@@ -349,13 +382,14 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
 static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		    struct sk_buff *skb, struct rxe_av *av)
 {
+	struct rxe_qp *qp = pkt->qp;
 	struct dst_entry *dst;
 	bool xnet = false;
 	__be16 df = htons(IP_DF);
 	struct in_addr *saddr = &av->sgid_addr._sockaddr_in.sin_addr;
 	struct in_addr *daddr = &av->dgid_addr._sockaddr_in.sin_addr;

-	dst = rxe_find_route4(rxe->ndev, saddr, daddr);
+	dst = rxe_find_route(rxe, qp, av);
 	if (!dst) {
 		pr_err("Host not reachable\n");
 		return -EHOSTUNREACH;
@@ -369,17 +403,24 @@ static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,

 	prepare_ipv4_hdr(dst, skb, saddr->s_addr, daddr->s_addr, IPPROTO_UDP,
 			 av->grh.traffic_class, av->grh.hop_limit, df, xnet);
+
+	if (qp_type(qp) == IB_QPT_RC)
+		sk_dst_set(qp->sk->sk, dst);
+	else
+		dst_release(dst);
+
 	return 0;
 }

 static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		    struct sk_buff *skb, struct rxe_av *av)
 {
-	struct dst_entry *dst;
+	struct rxe_qp *qp = pkt->qp;
+	struct dst_entry *dst = NULL;
 	struct in6_addr *saddr = &av->sgid_addr._sockaddr_in6.sin6_addr;
 	struct in6_addr *daddr = &av->dgid_addr._sockaddr_in6.sin6_addr;

-	dst = rxe_find_route6(rxe->ndev, saddr, daddr);
+	dst = rxe_find_route(rxe, qp, av);
 	if (!dst) {
 		pr_err("Host not reachable\n");
 		return -EHOSTUNREACH;
@@ -394,6 +435,12 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	prepare_ipv6_hdr(dst, skb, saddr, daddr, IPPROTO_UDP,
 			 av->grh.traffic_class,
 			 av->grh.hop_limit);
+
+	if (qp_type(qp) == IB_QPT_RC)
+		sk_dst_set(qp->sk->sk, dst);
+	else
+		dst_release(dst);
+
 	return 0;
 }

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f98a19e61a3d..aaaad3fb6849 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -846,6 +846,14 @@ void rxe_qp_cleanup(struct rxe_pool_entry *arg)
 		qp->resp.mr = NULL;
 	}

+	if (qp_type(qp) == IB_QPT_RC) {
+		struct dst_entry *dst = NULL;
+
+		dst = sk_dst_get(qp->sk->sk);
+		if (dst)
+			dst_release(dst);
+	}
+
 	free_rd_atomic_resources(qp);

 	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
