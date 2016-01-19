From: Lucas Tanure <tanure-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband: Replace memset with eth_zero_addr
Date: Tue, 19 Jan 2016 12:06:30 -0200
Message-ID: <1453212390-6478-1-git-send-email-tanure@linux.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.

Signed-off-by: Lucas Tanure <tanure-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c       | 2 +-
 drivers/infiniband/hw/nes/nes_utils.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 86af713..44d4164 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -92,7 +92,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 				ah_attr->grh.sgid_index, &sgid, &gid_attr);
 	if (ret)
 		return ERR_PTR(ret);
-	memset(ah->av.eth.s_mac, 0, ETH_ALEN);
+	eth_zero_addr(ah->av.eth.s_mac);
 	if (gid_attr.ndev) {
 		if (is_vlan_dev(gid_attr.ndev))
 			vlan_tag = vlan_dev_vlan_id(gid_attr.ndev);
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 2042c0f..6d3a169 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -727,7 +727,7 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip_addr, u8 *mac_addr, u32 acti
 	if (action == NES_ARP_DELETE) {
 		nes_debug(NES_DBG_NETDEV, "DELETE, arp_index=%d\n", arp_index);
 		nesadapter->arp_table[arp_index].ip_addr = 0;
-		memset(nesadapter->arp_table[arp_index].mac_addr, 0x00, ETH_ALEN);
+		eth_zero_addr(nesadapter->arp_table[arp_index].mac_addr);
 		nes_free_resource(nesadapter, nesadapter->allocated_arps, arp_index);
 		return arp_index;
 	}
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
