From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/15] net/mlx5: E-Switch, Normalize the name of uplink vport number
Date: Tue, 12 Feb 2019 22:55:40 -0800
Message-ID: <20190213065546.3013-10-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Driver used to name uplink vport as FDB_UPLINK_VPORT, it's hard to
comply with the same naming convention along with the introduction of
other vports. Use MLX5_VPORT as the prefix for such vports and
relocate the uplink vport definition to public header file for the
benefits of both net and IB drivers.

This patch doesn't change any functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 22 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  6 ++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  8 +++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 --
 .../mellanox/mlx5/core/eswitch_offloads.c     | 14 ++++++------
 include/linux/mlx5/vport.h                    |  4 ++++
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 3fb22967c098..99cae9a10195 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
  */
 
+#include <linux/mlx5/vport.h>
 #include "ib_rep.h"
 #include "srq.h"
 
@@ -48,11 +49,10 @@ static const struct mlx5_ib_profile vf_rep_profile = {
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
-#define FDB_UPLINK_VPORT 0xffff
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
 
-	if (rep->vport == FDB_UPLINK_VPORT)
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		profile = &uplink_rep_profile;
 	else
 		profile = &vf_rep_profile;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 96cc0c6a4014..c78d21b2501e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -152,7 +152,7 @@ static void mlx5e_rep_update_hw_counters(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 
-	if (rep->vport == FDB_UPLINK_VPORT)
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_uplink_rep_update_hw_counters(priv);
 	else
 		mlx5e_vf_rep_update_hw_counters(priv);
@@ -1207,7 +1207,7 @@ bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv)
 		return false;
 
 	rep = rpriv->rep;
-	return (rep->vport == FDB_UPLINK_VPORT);
+	return (rep->vport == MLX5_VPORT_UPLINK);
 }
 
 static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_id)
@@ -1343,7 +1343,7 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->sw_mtu      = netdev->mtu;
 
 	/* SQ */
-	if (rep->vport == FDB_UPLINK_VPORT)
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		params->log_sq_size = MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
 	else
 		params->log_sq_size = MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE;
@@ -1370,7 +1370,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (rep->vport == FDB_UPLINK_VPORT) {
+	if (rep->vport == MLX5_VPORT_UPLINK) {
 		SET_NETDEV_DEV(netdev, &priv->mdev->pdev->dev);
 		netdev->netdev_ops = &mlx5e_netdev_ops_uplink_rep;
 		/* we want a persistent mac for the uplink rep */
@@ -1402,7 +1402,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 	netdev->hw_features    |= NETIF_F_TSO6;
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
-	if (rep->vport != FDB_UPLINK_VPORT)
+	if (rep->vport != MLX5_VPORT_UPLINK)
 		netdev->features |= NETIF_F_VLAN_CHALLENGED;
 
 	netdev->features |= netdev->hw_features;
@@ -1555,7 +1555,7 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
-	if (rpriv->rep->vport == FDB_UPLINK_VPORT) {
+	if (rpriv->rep->vport == MLX5_VPORT_UPLINK) {
 		uplink_priv = &rpriv->uplink_priv;
 
 		/* init shared tc flow table */
@@ -1591,7 +1591,7 @@ static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 	for (tc = 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 
-	if (rpriv->rep->vport == FDB_UPLINK_VPORT) {
+	if (rpriv->rep->vport == MLX5_VPORT_UPLINK) {
 		/* clean indirect TC block notifications */
 		unregister_netdevice_notifier(&rpriv->uplink_priv.netdevice_nb);
 		mlx5e_rep_indr_clean_block_privs(rpriv);
@@ -1710,7 +1710,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	rpriv->rep = rep;
 
 	nch = mlx5e_get_max_num_channels(dev);
-	profile = (rep->vport == FDB_UPLINK_VPORT) ? &mlx5e_uplink_rep_profile : &mlx5e_vf_rep_profile;
+	profile = (rep->vport == MLX5_VPORT_UPLINK) ? &mlx5e_uplink_rep_profile : &mlx5e_vf_rep_profile;
 	netdev = mlx5e_create_netdev(dev, profile, nch, rpriv);
 	if (!netdev) {
 		pr_warn("Failed to create representor netdev for vport %d\n",
@@ -1723,7 +1723,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	rep->rep_if[REP_ETH].priv = rpriv;
 	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
 
-	if (rep->vport == FDB_UPLINK_VPORT) {
+	if (rep->vport == MLX5_VPORT_UPLINK) {
 		err = mlx5e_create_mdev_resources(dev);
 		if (err)
 			goto err_destroy_netdev;
@@ -1759,7 +1759,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	mlx5e_detach_netdev(netdev_priv(netdev));
 
 err_destroy_mdev_resources:
-	if (rep->vport == FDB_UPLINK_VPORT)
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_destroy_mdev_resources(dev);
 
 err_destroy_netdev:
@@ -1779,7 +1779,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	unregister_netdev(netdev);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
-	if (rep->vport == FDB_UPLINK_VPORT)
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_destroy_mdev_resources(priv->mdev);
 	mlx5e_destroy_netdev(priv);
 	kfree(ppriv); /* mlx5e_rep_priv */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cae6c6d48984..1a73e661056a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1834,7 +1834,7 @@ static int parse_cls_flower(struct mlx5e_priv *priv,
 
 	if (!err && (flow->flags & MLX5E_TC_FLOW_ESWITCH)) {
 		rep = rpriv->rep;
-		if (rep->vport != FDB_UPLINK_VPORT &&
+		if (rep->vport != MLX5_VPORT_UPLINK &&
 		    (esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE &&
 		    esw->offloads.inline_mode < match_level)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -2724,7 +2724,7 @@ static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv, int flags)
 static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
-	bool is_rep_ingress = attr->in_rep->vport != FDB_UPLINK_VPORT &&
+	bool is_rep_ingress = attr->in_rep->vport != MLX5_VPORT_UPLINK &&
 			      flow->flags & MLX5E_TC_FLOW_INGRESS;
 	bool act_is_encap = !!(attr->action &
 			       MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT);
@@ -2849,7 +2849,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct tc_cls_flower_offload *f,
 	 * original flow and packets redirected from uplink use the
 	 * peer mdev.
 	 */
-	if (flow->esw_attr->in_rep->vport == FDB_UPLINK_VPORT)
+	if (flow->esw_attr->in_rep->vport == MLX5_VPORT_UPLINK)
 		in_mdev = peer_priv->mdev;
 	else
 		in_mdev = priv->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d7382892e81c..0db56b4b7009 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -40,8 +40,6 @@
 #include "eswitch.h"
 #include "fs_core.h"
 
-#define UPLINK_VPORT 0xFFFF
-
 enum {
 	MLX5_ACTION_NONE = 0,
 	MLX5_ACTION_ADD  = 1,
@@ -188,7 +186,7 @@ __esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u16 vport, bool rx_rule,
 					misc_parameters);
 		mc_misc  = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 					misc_parameters);
-		MLX5_SET(fte_match_set_misc, mv_misc, source_port, UPLINK_VPORT);
+		MLX5_SET(fte_match_set_misc, mv_misc, source_port, MLX5_VPORT_UPLINK);
 		MLX5_SET_TO_ONES(fte_match_set_misc, mc_misc, source_port);
 	}
 
@@ -499,7 +497,7 @@ static int esw_add_mc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 		return -ENOMEM;
 
 	esw_mc->uplink_rule = /* Forward MC MAC to Uplink */
-		esw_fdb_set_vport_rule(esw, mac, UPLINK_VPORT);
+		esw_fdb_set_vport_rule(esw, mac, MLX5_VPORT_UPLINK);
 
 	/* Add this multicast mac to all the mc promiscuous vports */
 	update_allmulti_vports(esw, vaddr, esw_mc);
@@ -736,7 +734,7 @@ static void esw_apply_vport_rx_mode(struct mlx5_eswitch *esw, u16 vport_num,
 		if (!allmulti_addr->uplink_rule)
 			allmulti_addr->uplink_rule =
 				esw_fdb_set_vport_allmulti_rule(esw,
-								UPLINK_VPORT);
+								MLX5_VPORT_UPLINK);
 		allmulti_addr->refcnt++;
 	} else if (vport->allmulti_rule) {
 		mlx5_del_flow_rules(vport->allmulti_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9c89eea9b2c3..94da74b1e6ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -49,8 +49,6 @@
 #define MLX5_MAX_MC_PER_VPORT(dev) \
 	(1 << MLX5_CAP_GEN(dev, log_max_current_mc_list))
 
-#define FDB_UPLINK_VPORT 0xffff
-
 #define MLX5_MIN_BW_SHARE 1
 
 #define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 53065b6ae593..b0b1267eab07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -359,15 +359,15 @@ static int esw_add_vlan_action_check(struct mlx5_esw_flow_attr *attr,
 	in_rep  = attr->in_rep;
 	out_rep = attr->dests[0].rep;
 
-	if (push && in_rep->vport == FDB_UPLINK_VPORT)
+	if (push && in_rep->vport == MLX5_VPORT_UPLINK)
 		goto out_notsupp;
 
-	if (pop && out_rep->vport == FDB_UPLINK_VPORT)
+	if (pop && out_rep->vport == MLX5_VPORT_UPLINK)
 		goto out_notsupp;
 
 	/* vport has vlan push configured, can't offload VF --> wire rules w.o it */
 	if (!push && !pop && fwd)
-		if (in_rep->vlan && out_rep->vport == FDB_UPLINK_VPORT)
+		if (in_rep->vlan && out_rep->vport == MLX5_VPORT_UPLINK)
 			goto out_notsupp;
 
 	/* protects against (1) setting rules with different vlans to push and
@@ -409,7 +409,7 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 
 	if (!push && !pop && fwd) {
 		/* tracks VF --> wire rules without vlan push action */
-		if (attr->dests[0].rep->vport == FDB_UPLINK_VPORT) {
+		if (attr->dests[0].rep->vport == MLX5_VPORT_UPLINK) {
 			vport->vlan_refcount++;
 			attr->vlan_handled = true;
 		}
@@ -469,7 +469,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 
 	if (!push && !pop && fwd) {
 		/* tracks VF --> wire rules without vlan push action */
-		if (attr->dests[0].rep->vport == FDB_UPLINK_VPORT)
+		if (attr->dests[0].rep->vport == MLX5_VPORT_UPLINK)
 			vport->vlan_refcount--;
 
 		return 0;
@@ -1227,7 +1227,7 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 		ether_addr_copy(rep->hw_id, hw_id);
 	}
 
-	offloads->vport_reps[0].vport = FDB_UPLINK_VPORT;
+	offloads->vport_reps[0].vport = MLX5_VPORT_UPLINK;
 
 	return 0;
 }
@@ -1811,7 +1811,7 @@ void *mlx5_eswitch_get_proto_dev(struct mlx5_eswitch *esw,
 	struct mlx5_esw_offload *offloads = &esw->offloads;
 	struct mlx5_eswitch_rep *rep;
 
-	if (vport == FDB_UPLINK_VPORT)
+	if (vport == MLX5_VPORT_UPLINK)
 		vport = UPLINK_REP_INDEX;
 
 	rep = &offloads->vport_reps[vport];
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 1654b911cdb2..2e2928eacd97 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -42,6 +42,10 @@ enum {
 	MLX5_CAP_INLINE_MODE_NOT_REQUIRED,
 };
 
+enum {
+	MLX5_VPORT_UPLINK		= 0xffff
+};
+
 u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 state);
-- 
2.20.1
