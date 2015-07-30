From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/4] IB/mlx4: Use correct SL on AH query under RoCE
Date: Thu, 30 Jul 2015 17:34:24 +0300
Message-ID: <1438266864-3584-5-git-send-email-ogerlitz@mellanox.com>
References: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438266864-3584-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 IB driver implementation for ib_query_ah used a wrong offset
(28 instead of 29) when link type is Ethernet. Fixed to use the correct one.

Fixes: fa417f7b520e ('IB/mlx4: Add support for IBoE')
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index f50a546..33fdd50 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -148,9 +148,13 @@ int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 	enum rdma_link_layer ll;
 
 	memset(ah_attr, 0, sizeof *ah_attr);
-	ah_attr->sl = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
 	ah_attr->port_num = be32_to_cpu(ah->av.ib.port_pd) >> 24;
 	ll = rdma_port_get_link_layer(ibah->device, ah_attr->port_num);
+	if (ll == IB_LINK_LAYER_ETHERNET)
+		ah_attr->sl = be32_to_cpu(ah->av.eth.sl_tclass_flowlabel) >> 29;
+	else
+		ah_attr->sl = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
+
 	ah_attr->dlid = ll == IB_LINK_LAYER_INFINIBAND ? be16_to_cpu(ah->av.ib.dlid) : 0;
 	if (ah->av.ib.stat_rate)
 		ah_attr->static_rate = ah->av.ib.stat_rate - MLX4_STAT_RATE_OFFSET;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
