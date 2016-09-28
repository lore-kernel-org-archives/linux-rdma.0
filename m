From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rxe: Fix sending out loopback packet on netdev interface.
Date: Wed, 28 Sep 2016 20:24:42 +0000
Message-ID: <1475094282-18352-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Bug: prepare4 and prepare6 sets loopback mask in pkt_info structure
instance of skb.
While xmit_packet and other requester side functions use
pkt_info from stack. Due to which loopback mask bit set to wrong
pkt_info structure. This resuilts into sending out packet to actual
netdev and loopback functionality is broken.

Fix: Similar to other requester side functions, prepare() variants to
set loopback mask bit on pkt_info structure used by other functions.
Verified with perftest applications.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index eedf2f1..549aa84 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -350,14 +350,14 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
 	ip6h->payload_len = htons(skb->len - sizeof(*ip6h));
 }
 
-static int prepare4(struct rxe_dev *rxe, struct sk_buff *skb, struct rxe_av *av)
+static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		    struct sk_buff *skb, struct rxe_av *av)
 {
 	struct dst_entry *dst;
 	bool xnet = false;
 	__be16 df = htons(IP_DF);
 	struct in_addr *saddr = &av->sgid_addr._sockaddr_in.sin_addr;
 	struct in_addr *daddr = &av->dgid_addr._sockaddr_in.sin_addr;
-	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 
 	dst = rxe_find_route4(rxe->ndev, saddr, daddr);
 	if (!dst) {
@@ -376,12 +376,12 @@ static int prepare4(struct rxe_dev *rxe, struct sk_buff *skb, struct rxe_av *av)
 	return 0;
 }
 
-static int prepare6(struct rxe_dev *rxe, struct sk_buff *skb, struct rxe_av *av)
+static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		    struct sk_buff *skb, struct rxe_av *av)
 {
 	struct dst_entry *dst;
 	struct in6_addr *saddr = &av->sgid_addr._sockaddr_in6.sin6_addr;
 	struct in6_addr *daddr = &av->dgid_addr._sockaddr_in6.sin6_addr;
-	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 
 	dst = rxe_find_route6(rxe->ndev, saddr, daddr);
 	if (!dst) {
@@ -408,9 +408,9 @@ static int prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	struct rxe_av *av = rxe_get_av(pkt);
 
 	if (av->network_type == RDMA_NETWORK_IPV4)
-		err = prepare4(rxe, skb, av);
+		err = prepare4(rxe, pkt, skb, av);
 	else if (av->network_type == RDMA_NETWORK_IPV6)
-		err = prepare6(rxe, skb, av);
+		err = prepare6(rxe, pkt, skb, av);
 
 	*crc = rxe_icrc_hdr(pkt, skb);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
