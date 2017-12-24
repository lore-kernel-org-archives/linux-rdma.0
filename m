From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next V2 04/11] net/mlx5: E-Switch, Move mlx5e only logic outside E-Switch
Date: Sun, 24 Dec 2017 15:45:40 +0200
Message-ID: <20171224134547.600-5-saeedm@mellanox.com>
References: <20171224134547.600-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134547.600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In our pursuit to cleanup e-switch sub-module from mlx5e specific code,
we move the functions that insert/remove the flow steering rules that
allow mlx5e representors to send packets directly to VFs into the EN
driver code.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 57 +++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  9 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 55 +--------------------
 3 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6d2219f3acf6..19edaa155062 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -190,6 +190,59 @@ int mlx5e_attr_get(struct net_device *dev, struct switchdev_attr *attr)
 	return 0;
 }
 
+static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
+				 struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5_esw_sq *esw_sq, *tmp;
+
+	if (esw->mode != SRIOV_OFFLOADS)
+		return;
+
+	list_for_each_entry_safe(esw_sq, tmp, &rep->vport_sqs_list, list) {
+		mlx5_del_flow_rules(esw_sq->send_to_vport_rule);
+		list_del(&esw_sq->list);
+		kfree(esw_sq);
+	}
+}
+
+static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
+				 struct mlx5_eswitch_rep *rep,
+				 u16 *sqns_array, int sqns_num)
+{
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_esw_sq *esw_sq;
+	int err;
+	int i;
+
+	if (esw->mode != SRIOV_OFFLOADS)
+		return 0;
+
+	for (i = 0; i < sqns_num; i++) {
+		esw_sq = kzalloc(sizeof(*esw_sq), GFP_KERNEL);
+		if (!esw_sq) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+
+		/* Add re-inject rule to the PF/representor sqs */
+		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw,
+								rep->vport,
+								sqns_array[i]);
+		if (IS_ERR(flow_rule)) {
+			err = PTR_ERR(flow_rule);
+			kfree(esw_sq);
+			goto out_err;
+		}
+		esw_sq->send_to_vport_rule = flow_rule;
+		list_add(&esw_sq->list, &rep->vport_sqs_list);
+	}
+	return 0;
+
+out_err:
+	mlx5e_sqs2vport_stop(esw, rep);
+	return err;
+}
+
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -210,7 +263,7 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 			sqs[num_sqs++] = c->sq[tc].sqn;
 	}
 
-	err = mlx5_eswitch_sqs2vport_start(esw, rep, sqs, num_sqs);
+	err = mlx5e_sqs2vport_start(esw, rep, sqs, num_sqs);
 	kfree(sqs);
 
 out:
@@ -225,7 +278,7 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 
-	mlx5_eswitch_sqs2vport_stop(esw, rep);
+	mlx5e_sqs2vport_stop(esw, rep);
 }
 
 static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rpriv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 23808a65889c..21b506fd2b67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -222,6 +222,9 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 int vport,
 				 struct ifla_vf_stats *vf_stats);
+struct mlx5_flow_handle *
+mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport,
+				    u32 sqn);
 
 struct mlx5_flow_spec;
 struct mlx5_esw_flow_attr;
@@ -258,12 +261,6 @@ struct mlx5_esw_flow_attr {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
-int mlx5_eswitch_sqs2vport_start(struct mlx5_eswitch *esw,
-				 struct mlx5_eswitch_rep *rep,
-				 u16 *sqns_array, int sqns_num);
-void mlx5_eswitch_sqs2vport_stop(struct mlx5_eswitch *esw,
-				 struct mlx5_eswitch_rep *rep);
-
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode);
 int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode);
 int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index aa20f51c0a99..90a30c51d92e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -302,7 +302,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static struct mlx5_flow_handle *
+struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport, u32 sqn)
 {
 	struct mlx5_flow_act flow_act = {0};
@@ -339,59 +339,6 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, int vport, u32 sqn
 	return flow_rule;
 }
 
-void mlx5_eswitch_sqs2vport_stop(struct mlx5_eswitch *esw,
-				 struct mlx5_eswitch_rep *rep)
-{
-	struct mlx5_esw_sq *esw_sq, *tmp;
-
-	if (esw->mode != SRIOV_OFFLOADS)
-		return;
-
-	list_for_each_entry_safe(esw_sq, tmp, &rep->vport_sqs_list, list) {
-		mlx5_del_flow_rules(esw_sq->send_to_vport_rule);
-		list_del(&esw_sq->list);
-		kfree(esw_sq);
-	}
-}
-
-int mlx5_eswitch_sqs2vport_start(struct mlx5_eswitch *esw,
-				 struct mlx5_eswitch_rep *rep,
-				 u16 *sqns_array, int sqns_num)
-{
-	struct mlx5_flow_handle *flow_rule;
-	struct mlx5_esw_sq *esw_sq;
-	int err;
-	int i;
-
-	if (esw->mode != SRIOV_OFFLOADS)
-		return 0;
-
-	for (i = 0; i < sqns_num; i++) {
-		esw_sq = kzalloc(sizeof(*esw_sq), GFP_KERNEL);
-		if (!esw_sq) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-
-		/* Add re-inject rule to the PF/representor sqs */
-		flow_rule = mlx5_eswitch_add_send_to_vport_rule(esw,
-								rep->vport,
-								sqns_array[i]);
-		if (IS_ERR(flow_rule)) {
-			err = PTR_ERR(flow_rule);
-			kfree(esw_sq);
-			goto out_err;
-		}
-		esw_sq->send_to_vport_rule = flow_rule;
-		list_add(&esw_sq->list, &rep->vport_sqs_list);
-	}
-	return 0;
-
-out_err:
-	mlx5_eswitch_sqs2vport_stop(esw, rep);
-	return err;
-}
-
 static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_act flow_act = {0};
-- 
2.13.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
