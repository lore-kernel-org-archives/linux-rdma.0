From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Enlarge autogroup flow table
Date: Wed, 29 Mar 2017 06:09:01 +0300
Message-ID: <20170329030901.5772-2-leon@kernel.org>
References: <20170329030901.5772-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329030901.5772-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to enlarge the flow group size to 8k, we decrease
the number of flow group types to 6 and increase the flow
table size to 64k.

Flow group size is calculated as follow:
  group_size = table_size / (#group_types + 1)

Fixes: 038d2ef87572 ('IB/mlx5: Add flow steering support')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1bef4f5da31c..ca2cb2861afc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2038,8 +2038,8 @@ enum flow_table_type {
 	MLX5_IB_FT_TX
 };
 
-#define MLX5_FS_MAX_TYPES	 10
-#define MLX5_FS_MAX_ENTRIES	 32000UL
+#define MLX5_FS_MAX_TYPES	 6
+#define MLX5_FS_MAX_ENTRIES	 BIT(16)
 static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 						struct ib_flow_attr *flow_attr,
 						enum flow_table_type ft_type)
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
