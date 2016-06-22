From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 06/11] IB/mlx5: Fix wrong naming of port_rcv_data counter
Date: Wed, 22 Jun 2016 17:27:27 +0300
Message-ID: <1466605652-24798-7-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

port_xmit_data is written instead of port_rcv_data.

Fixes: 3efd9a11212d ('IB/mlx5: Modify MAD reading counters method to use counter registers')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 1534af1..364aab9 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -121,7 +121,7 @@ static void pma_cnt_ext_assign(struct ib_pma_portcounters_ext *pma_cnt_ext,
 	pma_cnt_ext->port_xmit_data =
 		cpu_to_be64(MLX5_SUM_CNT(out, transmitted_ib_unicast.octets,
 					 transmitted_ib_multicast.octets) >> 2);
-	pma_cnt_ext->port_xmit_data =
+	pma_cnt_ext->port_rcv_data =
 		cpu_to_be64(MLX5_SUM_CNT(out, received_ib_unicast.octets,
 					 received_ib_multicast.octets) >> 2);
 	pma_cnt_ext->port_xmit_packets =
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
