From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next V3 10/11] net/mlx5: Fix ingress/egress naming mistake
Date: Fri, 29 Dec 2017 01:23:13 +0200
Message-ID: <20171228232314.13678-11-saeedm@mellanox.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228232314.13678-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gal Pressman <galp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Gal Pressman <galp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The functions names do not represent their actions, switch the mistaken
ingress/egress naming.

Fixes: fba53f7b5719 ("net/mlx5: Introduce mlx5_flow_steering structure")
Signed-off-by: Gal Pressman <galp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c70fd663a633..5e786e29f93a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2406,7 +2406,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	return PTR_ERR(prio);
 }
 
-static int init_ingress_acl_root_ns(struct mlx5_flow_steering *steering)
+static int init_egress_acl_root_ns(struct mlx5_flow_steering *steering)
 {
 	struct fs_prio *prio;
 
@@ -2420,7 +2420,7 @@ static int init_ingress_acl_root_ns(struct mlx5_flow_steering *steering)
 	return PTR_ERR_OR_ZERO(prio);
 }
 
-static int init_egress_acl_root_ns(struct mlx5_flow_steering *steering)
+static int init_ingress_acl_root_ns(struct mlx5_flow_steering *steering)
 {
 	struct fs_prio *prio;
 
-- 
2.13.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
