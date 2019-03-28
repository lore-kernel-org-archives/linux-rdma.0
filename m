From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 01/12] net/mlx5: E-Switch, don't use hardcoded values for FDB prios
Date: Thu, 28 Mar 2019 15:27:31 +0200
Message-ID: <20190328132742.12070-2-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

When creating the FDB prios, use the enum values already defined and not
the hardcoded values.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 -----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          | 5 +++--
 include/linux/mlx5/fs.h                                    | 5 +++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f2260391be5b..6c8a17ca236e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -43,11 +43,6 @@
 #include "ecpf.h"
 #include "lib/eq.h"
 
-enum {
-	FDB_FAST_PATH = 0,
-	FDB_SLOW_PATH
-};
-
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
  */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0be3eb86dd84..f34515d03a3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2517,7 +2517,8 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		return -ENOMEM;
 
 	levels = 2 * FDB_MAX_PRIO * (FDB_MAX_CHAIN + 1);
-	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns, 0,
+	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
+					  FDB_FAST_PATH,
 					  levels);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
@@ -2542,7 +2543,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		steering->fdb_sub_ns[chain] = ns;
 	}
 
-	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, 1, 1);
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_SLOW_PATH, 1);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
 		goto out_err;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 9df51da04621..3eeb04154317 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -75,6 +75,11 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_EGRESS,
 };
 
+enum {
+	FDB_FAST_PATH,
+	FDB_SLOW_PATH,
+};
+
 struct mlx5_flow_table;
 struct mlx5_flow_group;
 struct mlx5_flow_namespace;
-- 
2.20.1
