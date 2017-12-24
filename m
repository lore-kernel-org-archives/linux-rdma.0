From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx4: Add support to RSS hash for inner headers
Date: Sun, 24 Dec 2017 14:51:24 +0200
Message-ID: <20171224125125.15661-2-leon@kernel.org>
References: <20171224125125.15661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125125.15661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support RSS hash for inner headers according to a new flag,
MLX4_IB_RX_HASH_INNER provided by the vendor channel.

In case the flag is set, RSS hash will be done on the inner headers of
VXLAN packets (which are encapsulated).
Non-encapsulated packets will be hashed according to the outer headers.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |  6 ++++++
 drivers/infiniband/hw/mlx4/qp.c   | 14 ++++++++++++++
 include/uapi/rdma/mlx4-abi.h      |  7 ++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8c8a16791a3f..5695ce53fddb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -589,6 +589,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		if (props->rss_caps.supported_qpts) {
 			resp.rss_caps.rx_hash_function =
 				MLX4_IB_RX_HASH_FUNC_TOEPLITZ;
+
 			resp.rss_caps.rx_hash_fields_mask =
 				MLX4_IB_RX_HASH_SRC_IPV4 |
 				MLX4_IB_RX_HASH_DST_IPV4 |
@@ -598,6 +599,11 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 				MLX4_IB_RX_HASH_DST_PORT_TCP |
 				MLX4_IB_RX_HASH_SRC_PORT_UDP |
 				MLX4_IB_RX_HASH_DST_PORT_UDP;
+
+			if (dev->dev->caps.tunnel_offload_mode ==
+			    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
+				resp.rss_caps.rx_hash_fields_mask |=
+					MLX4_IB_RX_HASH_INNER;
 		}
 	}
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 16dea0e3d50f..c305189eb4af 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -722,6 +722,20 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 		return (-EOPNOTSUPP);
 	}
 
+	if (ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_INNER) {
+		if (dev->dev->caps.tunnel_offload_mode ==
+		    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
+			/*
+			 * Hash according to inner headers if exist, otherwise
+			 * according to outer headers.
+			 */
+			rss_ctx->flags |= MLX4_RSS_BY_INNER_HEADERS_IPONLY;
+		} else {
+			pr_debug("RSS Hash for inner headers isn't supported\n");
+			return (-EOPNOTSUPP);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index 224b52b6279c..7f9c37346613 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -97,8 +97,8 @@ struct mlx4_ib_create_srq_resp {
 };
 
 struct mlx4_ib_create_qp_rss {
-	__u64   rx_hash_fields_mask;
-	__u8    rx_hash_function;
+	__u64   rx_hash_fields_mask; /* Use  enum mlx4_ib_rx_hash_fields */
+	__u8    rx_hash_function; /* Use enum mlx4_ib_rx_hash_function_flags */
 	__u8    reserved[7];
 	__u8    rx_hash_key[40];
 	__u32   comp_mask;
@@ -152,7 +152,8 @@ enum mlx4_ib_rx_hash_fields {
 	MLX4_IB_RX_HASH_SRC_PORT_TCP	= 1 << 4,
 	MLX4_IB_RX_HASH_DST_PORT_TCP	= 1 << 5,
 	MLX4_IB_RX_HASH_SRC_PORT_UDP	= 1 << 6,
-	MLX4_IB_RX_HASH_DST_PORT_UDP	= 1 << 7
+	MLX4_IB_RX_HASH_DST_PORT_UDP	= 1 << 7,
+	MLX4_IB_RX_HASH_INNER		= 1ULL << 31,
 };
 
 #endif /* MLX4_ABI_USER_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
