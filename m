From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V3 09/11] net/mlx5e: E-Switch, Use the name of static array instead of its address
Date: Fri, 29 Dec 2017 01:23:12 +0200
Message-ID: <20171228232314.13678-10-saeedm@mellanox.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171228232314.13678-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Gal Pressman <galp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Gal Pressman <galp@mellanox.com>

Using the address of a static array is the same as using its name (in
this specific use-case), but it's confusing and makes the code less
readable.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Fixes: bd77bf1cb595 ("net/mlx5: Add SRIOV VF max rate configuration support")
Signed-off-by: Gal Pressman <galp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 26 +++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6d4cbdb69823..cdf65ed8714c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1290,7 +1290,7 @@ static int esw_create_tsar(struct mlx5_eswitch *esw)
 
 	err = mlx5_create_scheduling_element_cmd(dev,
 						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 &tsar_ctx,
+						 tsar_ctx,
 						 &esw->qos.root_tsar_id);
 	if (err) {
 		esw_warn(esw->dev, "E-Switch create TSAR failed (%d)\n", err);
@@ -1333,20 +1333,20 @@ static int esw_vport_enable_qos(struct mlx5_eswitch *esw, int vport_num,
 	if (vport->qos.enabled)
 		return -EEXIST;
 
-	MLX5_SET(scheduling_context, &sched_ctx, element_type,
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, &sched_ctx,
+	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
 				  element_attributes);
 	MLX5_SET(vport_element, vport_elem, vport_number, vport_num);
-	MLX5_SET(scheduling_context, &sched_ctx, parent_element_id,
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id,
 		 esw->qos.root_tsar_id);
-	MLX5_SET(scheduling_context, &sched_ctx, max_average_bw,
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw,
 		 initial_max_rate);
-	MLX5_SET(scheduling_context, &sched_ctx, bw_share, initial_bw_share);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, initial_bw_share);
 
 	err = mlx5_create_scheduling_element_cmd(dev,
 						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 &sched_ctx,
+						 sched_ctx,
 						 &vport->qos.esw_tsar_ix);
 	if (err) {
 		esw_warn(esw->dev, "E-Switch create TSAR vport element failed (vport=%d,err=%d)\n",
@@ -1392,22 +1392,22 @@ static int esw_vport_qos_config(struct mlx5_eswitch *esw, int vport_num,
 	if (!vport->qos.enabled)
 		return -EIO;
 
-	MLX5_SET(scheduling_context, &sched_ctx, element_type,
+	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, &sched_ctx,
+	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
 				  element_attributes);
 	MLX5_SET(vport_element, vport_elem, vport_number, vport_num);
-	MLX5_SET(scheduling_context, &sched_ctx, parent_element_id,
+	MLX5_SET(scheduling_context, sched_ctx, parent_element_id,
 		 esw->qos.root_tsar_id);
-	MLX5_SET(scheduling_context, &sched_ctx, max_average_bw,
+	MLX5_SET(scheduling_context, sched_ctx, max_average_bw,
 		 max_rate);
-	MLX5_SET(scheduling_context, &sched_ctx, bw_share, bw_share);
+	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
 	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
 	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_BW_SHARE;
 
 	err = mlx5_modify_scheduling_element_cmd(dev,
 						 SCHEDULING_HIERARCHY_E_SWITCH,
-						 &sched_ctx,
+						 sched_ctx,
 						 vport->qos.esw_tsar_ix,
 						 bitmask);
 	if (err) {
-- 
2.13.0
