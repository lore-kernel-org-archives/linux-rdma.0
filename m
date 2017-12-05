From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/4] IB/mlx4: Fix RSS hash fields restrictions
Date: Tue,  5 Dec 2017 22:30:03 +0200
Message-ID: <20171205203004.28386-4-leon@kernel.org>
References: <20171205203004.28386-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205203004.28386-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Mistakenly the driver didn't allow RSS hash fields combinations which
involve both IPv4 and IPv6 protocols. This bug caused to failures for
user's use cases for RSS.

Consequently, this patch fixes this bug and allows any combination that
the HW can support.

Additionally, the patch fixes the driver to return an error in case the
user provides an unsupported mask for RSS hash fields.

Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 013049bcdb53..caf490ab24c8 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -666,6 +666,19 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 		return (-EOPNOTSUPP);
 	}
 
+	if (ucmd->rx_hash_fields_mask & ~(MLX4_IB_RX_HASH_SRC_IPV4	|
+					  MLX4_IB_RX_HASH_DST_IPV4	|
+					  MLX4_IB_RX_HASH_SRC_IPV6	|
+					  MLX4_IB_RX_HASH_DST_IPV6	|
+					  MLX4_IB_RX_HASH_SRC_PORT_TCP	|
+					  MLX4_IB_RX_HASH_DST_PORT_TCP	|
+					  MLX4_IB_RX_HASH_SRC_PORT_UDP	|
+					  MLX4_IB_RX_HASH_DST_PORT_UDP)) {
+		pr_debug("RX Hash fields_mask has unsupported mask (0x%llx)\n",
+			 ucmd->rx_hash_fields_mask);
+		return (-EOPNOTSUPP);
+	}
+
 	if ((ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_SRC_IPV4) &&
 	    (ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_DST_IPV4)) {
 		rss_ctx->flags = MLX4_RSS_IPV4;
@@ -691,11 +704,11 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 			return (-EOPNOTSUPP);
 		}
 
-		if (rss_ctx->flags & MLX4_RSS_IPV4) {
+		if (rss_ctx->flags & MLX4_RSS_IPV4)
 			rss_ctx->flags |= MLX4_RSS_UDP_IPV4;
-		} else if (rss_ctx->flags & MLX4_RSS_IPV6) {
+		if (rss_ctx->flags & MLX4_RSS_IPV6)
 			rss_ctx->flags |= MLX4_RSS_UDP_IPV6;
-		} else {
+		if (!(rss_ctx->flags & (MLX4_RSS_IPV6 | MLX4_RSS_IPV4))) {
 			pr_debug("RX Hash fields_mask is not supported - UDP must be set with IPv4 or IPv6\n");
 			return (-EOPNOTSUPP);
 		}
@@ -707,15 +720,14 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 
 	if ((ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_SRC_PORT_TCP) &&
 	    (ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_DST_PORT_TCP)) {
-		if (rss_ctx->flags & MLX4_RSS_IPV4) {
+		if (rss_ctx->flags & MLX4_RSS_IPV4)
 			rss_ctx->flags |= MLX4_RSS_TCP_IPV4;
-		} else if (rss_ctx->flags & MLX4_RSS_IPV6) {
+		if (rss_ctx->flags & MLX4_RSS_IPV6)
 			rss_ctx->flags |= MLX4_RSS_TCP_IPV6;
-		} else {
+		if (!(rss_ctx->flags & (MLX4_RSS_IPV6 | MLX4_RSS_IPV4))) {
 			pr_debug("RX Hash fields_mask is not supported - TCP must be set with IPv4 or IPv6\n");
 			return (-EOPNOTSUPP);
 		}
-
 	} else if ((ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_SRC_PORT_TCP) ||
 		   (ucmd->rx_hash_fields_mask & MLX4_IB_RX_HASH_DST_PORT_TCP)) {
 		pr_debug("RX Hash fields_mask is not supported - both TCP SRC and DST must be set\n");
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
