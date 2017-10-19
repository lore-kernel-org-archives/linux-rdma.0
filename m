From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Add support for RSS on the inner packet
Date: Thu, 19 Oct 2017 08:25:56 +0300
Message-ID: <20171019052556.8514-7-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some user space application would like to do RSS on the inner
packet fields instead on the outer.
When MLX5_RX_HASH_INNER is set with one or more of the other
hash fields, then the RSS will be done using the inner packet.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 11 +++++++++++
 include/uapi/rdma/mlx5-abi.h    |  4 +++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0f1106040a45..c6735a2979a8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1405,6 +1405,12 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return -EOPNOTSUPP;
 	}
 
+	if (ucmd.rx_hash_fields_mask & MLX5_RX_HASH_INNER &&
+	    !(ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS)) {
+		mlx5_ib_dbg(dev, "Tunnel offloads must be set for inner RSS\n");
+		return -EOPNOTSUPP;
+	}
+
 	err = ib_copy_to_udata(udata, &resp, min_resp_len);
 	if (err) {
 		mlx5_ib_dbg(dev, "copy failed\n");
@@ -1428,6 +1434,11 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS)
 		MLX5_SET(tirc, tirc, tunneled_offload_en, 1);
 
+	if (ucmd.rx_hash_fields_mask & MLX5_RX_HASH_INNER)
+		hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_inner);
+	else
+		hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
+
 	switch (ucmd.rx_hash_function) {
 	case MLX5_RX_HASH_FUNC_TOEPLITZ:
 	{
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 791655ec4aff..442b46b74a3a 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -303,7 +303,9 @@ enum mlx5_rx_hash_fields {
 	MLX5_RX_HASH_SRC_PORT_TCP	= 1 << 4,
 	MLX5_RX_HASH_DST_PORT_TCP	= 1 << 5,
 	MLX5_RX_HASH_SRC_PORT_UDP	= 1 << 6,
-	MLX5_RX_HASH_DST_PORT_UDP	= 1 << 7
+	MLX5_RX_HASH_DST_PORT_UDP	= 1 << 7,
+	/* Save bits for future fields */
+	MLX5_RX_HASH_INNER		= 1 << 31
 };
 
 struct mlx5_ib_create_qp_rss {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
