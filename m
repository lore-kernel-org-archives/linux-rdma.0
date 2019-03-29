From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 14/14] net/mlx5: Fix false compilation warning
Date: Fri, 29 Mar 2019 15:38:04 -0700
Message-ID: <20190329223804.8954-15-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>, Alex Vesker <valex@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Fix the following warning:
drivers/net/ethernet/mellanox/mlx5/core//fs_core.c:845:5:
warning: 'err' may be used uninitialized in this function
[-Wmaybe-uninitialized]

No real issue here. This is only a false compiler warning.
The 'err' variable is guaranteed to be init by time of usage.

gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-4)

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0be3eb86dd84..78e073243f40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -819,7 +819,7 @@ static int update_root_ft_create(struct mlx5_flow_table *ft, struct fs_prio
 	struct mlx5_flow_root_namespace *root = find_root(&prio->node);
 	struct mlx5_ft_underlay_qp *uqp;
 	int min_level = INT_MAX;
-	int err;
+	int err = 0;
 	u32 qpn;
 
 	if (root->root_ft)
-- 
2.20.1
