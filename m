From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V3 08/11] net/mlx5e: E-Switch, Move send-to-vport rule struct to en_rep
Date: Fri, 29 Dec 2017 01:23:11 +0200
Message-ID: <20171228232314.13678-9-saeedm@mellanox.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171228232314.13678-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Move struct mlx5_esw_sq which keeps send-to-vport rule to from the eswitch
code to mlx5e and rename it to better reflect where it belongs

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 22 +++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h  |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h |  5 -----
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5b2b673c0b13..c6a77f8e99a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -193,17 +193,17 @@ int mlx5e_attr_get(struct net_device *dev, struct switchdev_attr *attr)
 static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep)
 {
-	struct mlx5_esw_sq *esw_sq, *tmp;
+	struct mlx5e_rep_sq *rep_sq, *tmp;
 	struct mlx5e_rep_priv *rpriv;
 
 	if (esw->mode != SRIOV_OFFLOADS)
 		return;
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
-	list_for_each_entry_safe(esw_sq, tmp, &rpriv->vport_sqs_list, list) {
-		mlx5_eswitch_del_send_to_vport_rule(esw_sq->send_to_vport_rule);
-		list_del(&esw_sq->list);
-		kfree(esw_sq);
+	list_for_each_entry_safe(rep_sq, tmp, &rpriv->vport_sqs_list, list) {
+		mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
+		list_del(&rep_sq->list);
+		kfree(rep_sq);
 	}
 }
 
@@ -213,7 +213,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5e_rep_priv *rpriv;
-	struct mlx5_esw_sq *esw_sq;
+	struct mlx5e_rep_sq *rep_sq;
 	int err;
 	int i;
 
@@ -222,8 +222,8 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 
 	rpriv = mlx5e_rep_to_rep_priv(rep);
 	for (i = 0; i < sqns_num; i++) {
-		esw_sq = kzalloc(sizeof(*esw_sq), GFP_KERNEL);
-		if (!esw_sq) {
+		rep_sq = kzalloc(sizeof(*rep_sq), GFP_KERNEL);
+		if (!rep_sq) {
 			err = -ENOMEM;
 			goto out_err;
 		}
@@ -234,11 +234,11 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 								sqns_array[i]);
 		if (IS_ERR(flow_rule)) {
 			err = PTR_ERR(flow_rule);
-			kfree(esw_sq);
+			kfree(rep_sq);
 			goto out_err;
 		}
-		esw_sq->send_to_vport_rule = flow_rule;
-		list_add(&esw_sq->list, &rpriv->vport_sqs_list);
+		rep_sq->send_to_vport_rule = flow_rule;
+		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
 	}
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index e4473a9ebd50..b9b481f2833a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -133,6 +133,11 @@ struct mlx5e_encap_entry {
 	int encap_size;
 };
 
+struct mlx5e_rep_sq {
+	struct mlx5_flow_handle	*send_to_vport_rule;
+	struct list_head	 list;
+};
+
 void *mlx5e_alloc_nic_rep_priv(struct mlx5_core_dev *mdev);
 void mlx5e_register_vport_reps(struct mlx5e_priv *priv);
 void mlx5e_unregister_vport_reps(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 91175965df7f..3b481182f13a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -138,11 +138,6 @@ struct mlx5_eswitch_fdb {
 	};
 };
 
-struct mlx5_esw_sq {
-	struct mlx5_flow_handle	*send_to_vport_rule;
-	struct list_head	 list;
-};
-
 struct mlx5_eswitch_rep;
 struct mlx5_eswitch_rep_if {
 	int		       (*load)(struct mlx5_core_dev *dev,
-- 
2.13.0
