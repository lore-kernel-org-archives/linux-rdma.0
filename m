From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] RDMA/nes: Fix for incorrect MSS when tso is on
Date: Thu, 20 Sep 2012 14:34:20 -0500
Message-ID: <20120920193420.GA4220@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In nes tso handling code, skb_shared_info is used to get the MSS instead of bool function skb_is_gso() which returns 1

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index f3a3ecf..1c02ba7 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -390,10 +390,10 @@ static int nes_nic_send(struct sk_buff *skb, struct net_device *netdev)
 		tcph = tcp_hdr(skb);
 		if (1) {
 			if (skb_is_gso(skb)) {
-				/* nes_debug(NES_DBG_NIC_TX, "%s: TSO request... seg size = %u\n",
-						netdev->name, skb_is_gso(skb)); */
+				/* nes_debug(NES_DBG_NIC_TX, "%s: TSO request... is_gso = %u seg size = %u\n",
+						netdev->name, skb_is_gso(skb), skb_shinfo(skb)->gso_size); */
 				wqe_misc |= NES_NIC_SQ_WQE_LSO_ENABLE |
-						NES_NIC_SQ_WQE_COMPLETION | (u16)skb_is_gso(skb);
+						NES_NIC_SQ_WQE_COMPLETION | (u16)skb_shinfo(skb)->gso_size;
 				set_wqe_32bit_value(nic_sqe->wqe_words, NES_NIC_SQ_WQE_LSO_INFO_IDX,
 						((u32)tcph->doff) |
 						(((u32)(((unsigned char *)tcph) - skb->data)) << 4));
@@ -597,10 +597,10 @@ tso_sq_no_longer_full:
 					nes_debug(NES_DBG_NIC_TX, "ERROR: SKB header too big, headlen=%u, FIRST_FRAG_SIZE=%u\n",
 							original_first_length, NES_FIRST_FRAG_SIZE);
 					nes_debug(NES_DBG_NIC_TX, "%s Request to tx NIC packet length %u, headlen %u,"
-							" (%u frags), tso_size=%u\n",
+							" (%u frags), is_gso = %u tso_size=%u\n",
 							netdev->name,
 							skb->len, skb_headlen(skb),
-							skb_shinfo(skb)->nr_frags, skb_is_gso(skb));
+							skb_shinfo(skb)->nr_frags, skb_is_gso(skb), skb_shinfo(skb)->gso_size);
 				}
 				memcpy(&nesnic->first_frag_vbase[nesnic->sq_head].buffer,
 						skb->data, min(((unsigned int)NES_FIRST_FRAG_SIZE),
@@ -652,8 +652,8 @@ tso_sq_no_longer_full:
 				} else {
 					nesnic->tx_skb[nesnic->sq_head] = NULL;
 				}
-				wqe_misc |= NES_NIC_SQ_WQE_COMPLETION | (u16)skb_is_gso(skb);
-				if ((tso_wqe_length + original_first_length) > skb_is_gso(skb)) {
+				wqe_misc |= NES_NIC_SQ_WQE_COMPLETION | (u16)skb_shinfo(skb)->gso_size;
+				if ((tso_wqe_length + original_first_length) > skb_shinfo(skb)->gso_size) {
 					wqe_misc |= NES_NIC_SQ_WQE_LSO_ENABLE;
 				} else {
 					iph->tot_len = htons(tso_wqe_length + original_first_length - nhoffset);
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
