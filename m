From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 1/9] IB/mlx4: Set traffic class in ah
Date: Sat,  5 Nov 2016 21:57:14 +0200
Message-ID: <1478375842-21513-2-git-send-email-leonro@mellanox.com>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478375842-21513-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set traffic class within sl_tclass_flowlabel when create iboe ah.
Without this the tos value will be empty when running VLAN tagged
traffic,  because the tos value is taken from the traffic class in the
address handle attributes.

Fixes: 9106c4106974 ('IB/mlx4: Fix SL to 802.1Q priority-bits mapping
for IBoE')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 5fc6233..6be7dc3 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -111,7 +111,9 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 		       !(1 << ah->av.eth.stat_rate & dev->caps.stat_rate_support))
 			--ah->av.eth.stat_rate;
 	}
-
+	ah->av.eth.sl_tclass_flowlabel |=
+			cpu_to_be32((ah_attr->grh.traffic_class << 20) |
+				    ah_attr->grh.flow_label);
 	/*
 	 * HW requires multicast LID so we just choose one.
 	 */
@@ -119,7 +121,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 		ah->av.ib.dlid = cpu_to_be16(0xc000);
 
 	memcpy(ah->av.eth.dgid, ah_attr->grh.dgid.raw, 16);
-	ah->av.eth.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 29);
+	ah->av.eth.sl_tclass_flowlabel |= cpu_to_be32(ah_attr->sl << 29);
 
 	return &ah->ibah;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
