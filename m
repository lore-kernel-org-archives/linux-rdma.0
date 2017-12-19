From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 10/11] net/mlx5: Fix ingress/egress naming mistake
Date: Tue, 19 Dec 2017 12:33:39 -0800
Message-ID: <20171219203340.2600-11-saeedm@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171219203340.2600-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Gal Pressman <galp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Gal Pressman <galp@mellanox.com>

The functions names do not represent their actions, switch the mistaken
ingress/egress naming.

Fixes: fba53f7b5719 ("net/mlx5: Introduce mlx5_flow_steering structure")
Signed-off-by: Gal Pressman <galp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
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
2.14.2
