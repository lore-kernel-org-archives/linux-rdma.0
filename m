From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v3] {net, IB}/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Wed, 16 May 2018 21:07:20 +0200
Message-ID: <20180516190720.11633-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-rdma@vger.kernel.org

When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
free it.

Fixes: 1cbe6fc86ccfe ("IB/mlx5: Add support for CQE compressing")
Fixes: fed9ce22bf8ae ("net/mlx5: E-Switch, Add API to create vport rx rules")
Fixes: 9efa75254593d ("net/mlx5_core: Introduce access functions to query vport RoCE fields")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1 -> v2: More places to update have been added to the patch
v2 -> v3: Add Fixes tag

3 patches with one Fixes tag each should probably be better, but honestly, I won't send a v4.
Fill free to split it if needed.
---
 drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 77d257ec899b..6d52ea03574e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -849,7 +849,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	return 0;
 
 err_cqb:
-	kfree(*cqb);
+	kvfree(*cqb);
 
 err_db:
 	mlx5_ib_db_unmap_user(to_mucontext(context), &cq->db);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 35e256eb2f6e..b123f8a52ad8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -663,7 +663,7 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 
 	esw->offloads.vport_rx_group = g;
 out:
-	kfree(flow_group_in);
+	kvfree(flow_group_in);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 177e076b8d17..719cecb182c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -511,7 +511,7 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
 					nic_vport_context.system_image_guid);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
@@ -531,7 +531,7 @@ int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid)
 	*node_guid = MLX5_GET64(query_nic_vport_context_out, out,
 				nic_vport_context.node_guid);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
@@ -587,7 +587,7 @@ int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
 	*qkey_viol_cntr = MLX5_GET(query_nic_vport_context_out, out,
 				   nic_vport_context.qkey_violation_counter);
 
-	kfree(out);
+	kvfree(out);
 
 	return 0;
 }
-- 
2.17.0
