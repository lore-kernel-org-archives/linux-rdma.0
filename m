From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] RDMA/nes: Cosmetic changes
Date: Thu, 20 Sep 2012 15:53:27 -0500
Message-ID: <20120920205327.GA7460@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Removing unnecessary statement if(1)
Refactoring a statement (wqe_misc |= NES_NIC_SQ_WQE_COMPLETION) out of if/else statement, because it is independant of the flow
Defining netdev->features in one line for clarity

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_nic.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 1c02ba7..d0391ac 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -385,24 +385,20 @@ static int nes_nic_send(struct sk_buff *skb, struct net_device *netdev)
 	/* bump past the vlan tag */
 	wqe_fragment_length++;
 	/*	wqe_fragment_address = (u64 *)&nic_sqe->wqe_words[NES_NIC_SQ_WQE_FRAG0_LOW_IDX]; */
+	wqe_misc |= NES_NIC_SQ_WQE_COMPLETION;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		tcph = tcp_hdr(skb);
-		if (1) {
-			if (skb_is_gso(skb)) {
-				/* nes_debug(NES_DBG_NIC_TX, "%s: TSO request... is_gso = %u seg size = %u\n",
-						netdev->name, skb_is_gso(skb), skb_shinfo(skb)->gso_size); */
-				wqe_misc |= NES_NIC_SQ_WQE_LSO_ENABLE |
-						NES_NIC_SQ_WQE_COMPLETION | (u16)skb_shinfo(skb)->gso_size;
-				set_wqe_32bit_value(nic_sqe->wqe_words, NES_NIC_SQ_WQE_LSO_INFO_IDX,
-						((u32)tcph->doff) |
-						(((u32)(((unsigned char *)tcph) - skb->data)) << 4));
-			} else {
-				wqe_misc |= NES_NIC_SQ_WQE_COMPLETION;
-			}
+		if (skb_is_gso(skb)) {
+			tcph = tcp_hdr(skb);
+			/* nes_debug(NES_DBG_NIC_TX, "%s: TSO request... is_gso = %u seg size = %u\n",
+					netdev->name, skb_is_gso(skb), skb_shinfo(skb)->gso_size); */
+			wqe_misc |= NES_NIC_SQ_WQE_LSO_ENABLE | (u16)skb_shinfo(skb)->gso_size;
+			set_wqe_32bit_value(nic_sqe->wqe_words, NES_NIC_SQ_WQE_LSO_INFO_IDX,
+					((u32)tcph->doff) |
+					(((u32)(((unsigned char *)tcph) - skb->data)) << 4));
 		}
 	} else {	/* CHECKSUM_HW */
-		wqe_misc |= NES_NIC_SQ_WQE_DISABLE_CHKSUM | NES_NIC_SQ_WQE_COMPLETION;
+		wqe_misc |= NES_NIC_SQ_WQE_DISABLE_CHKSUM;
 	}
 
 	set_wqe_32bit_value(nic_sqe->wqe_words, NES_NIC_SQ_WQE_TOTAL_LENGTH_IDX,
@@ -1679,12 +1675,10 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	netdev->hard_header_len = ETH_HLEN;
 	netdev->addr_len = ETH_ALEN;
 	netdev->type = ARPHRD_ETHER;
-	netdev->features = NETIF_F_HIGHDMA;
 	netdev->netdev_ops = &nes_netdev_ops;
 	netdev->ethtool_ops = &nes_ethtool_ops;
 	netif_napi_add(netdev, &nesvnic->napi, nes_netdev_poll, 128);
 	nes_debug(NES_DBG_INIT, "Enabling VLAN Insert/Delete.\n");
-	netdev->features |= NETIF_F_HW_VLAN_TX;
 
 	/* Fill in the port structure */
 	nesvnic->netdev = netdev;
@@ -1711,11 +1705,11 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	netdev->dev_addr[5] = (u8)u64temp;
 	memcpy(netdev->perm_addr, netdev->dev_addr, 6);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_IP_CSUM |
-			      NETIF_F_HW_VLAN_RX;
+	netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM | NETIF_F_HW_VLAN_RX;
 	if ((nesvnic->logical_port < 2) || (nesdev->nesadapter->hw_rev != NE020_REV))
 		netdev->hw_features |= NETIF_F_TSO;
-	netdev->features |= netdev->hw_features;
+
+	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_TX;
 	netdev->hw_features |= NETIF_F_LRO;
 
 	nes_debug(NES_DBG_INIT, "nesvnic = %p, reported features = 0x%lX, QPid = %d,"
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
