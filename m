From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/7] IB/mlx5: Fix coverity warning
Date: Sun, 28 Aug 2016 14:16:32 +0300
Message-ID: <1472382994-32091-6-git-send-email-leon@kernel.org>
References: <1472382994-32091-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix covertiy warning of passing "&flow_attr" to function
"create_flow_rule" which uses it as an array.

In addition pass flow attributes argument as const.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 049c1a0..ed524d7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1406,7 +1406,7 @@ static bool outer_header_zero(u32 *match_criteria)
 }
 
 static int parse_flow_attr(u32 *match_c, u32 *match_v,
-			   union ib_flow_spec *ib_spec)
+			   const union ib_flow_spec *ib_spec)
 {
 	void *outer_headers_c = MLX5_ADDR_OF(fte_match_param, match_c,
 					     outer_headers);
@@ -1574,7 +1574,7 @@ static bool flow_is_multicast_only(struct ib_flow_attr *ib_attr)
 	       is_multicast_ether_addr(eth_spec->val.dst_mac);
 }
 
-static bool is_valid_attr(struct ib_flow_attr *flow_attr)
+static bool is_valid_attr(const struct ib_flow_attr *flow_attr)
 {
 	union ib_flow_spec *ib_spec = (union ib_flow_spec *)(flow_attr + 1);
 	bool has_ipv4_spec = false;
@@ -1698,13 +1698,13 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 
 static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 						     struct mlx5_ib_flow_prio *ft_prio,
-						     struct ib_flow_attr *flow_attr,
+						     const struct ib_flow_attr *flow_attr,
 						     struct mlx5_flow_destination *dst)
 {
 	struct mlx5_flow_table	*ft = ft_prio->flow_table;
 	struct mlx5_ib_flow_handler *handler;
 	struct mlx5_flow_spec *spec;
-	void *ib_flow = flow_attr + 1;
+	const void *ib_flow = (const void *)flow_attr + sizeof(*flow_attr);
 	unsigned int spec_index;
 	u32 action;
 	int err = 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
