From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Report inner RSS capability
Date: Sun, 24 Dec 2017 14:51:25 +0200
Message-ID: <20171224125125.15661-3-leon@kernel.org>
References: <20171224125125.15661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125125.15661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add missing inner RSS support capability as part of
the RSS supported fields.

In addition change MLX5_RX_HASH_INNER to 1UL << 31 in
order to define it as unsigned.

Fixes: 309fa3470fca ("IB/mlx5: Add support for RSS on the inner packet")
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 ++-
 include/uapi/rdma/mlx5-abi.h      | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6775e440e23f..96cc51455b09 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -682,7 +682,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 						MLX5_RX_HASH_SRC_PORT_TCP |
 						MLX5_RX_HASH_DST_PORT_TCP |
 						MLX5_RX_HASH_SRC_PORT_UDP |
-						MLX5_RX_HASH_DST_PORT_UDP;
+						MLX5_RX_HASH_DST_PORT_UDP |
+						MLX5_RX_HASH_INNER;
 			resp.response_length += sizeof(resp.rss_caps);
 		}
 	} else {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index a33e0517d3fd..062d14f07b61 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -307,7 +307,7 @@ enum mlx5_rx_hash_fields {
 	MLX5_RX_HASH_SRC_PORT_UDP	= 1 << 6,
 	MLX5_RX_HASH_DST_PORT_UDP	= 1 << 7,
 	/* Save bits for future fields */
-	MLX5_RX_HASH_INNER		= 1 << 31
+	MLX5_RX_HASH_INNER		= (1UL << 31),
 };
 
 struct mlx5_ib_create_qp_rss {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
