From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 06/11] net/mlx5e: Move ethernet representors data into separate struct
Date: Tue, 19 Dec 2017 12:33:35 -0800
Message-ID: <20171219203340.2600-7-saeedm@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171219203340.2600-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Ethernet representors have a need to store data which is applicable
only for them. Create a priv void pointer in struct mlx5_eswitch_rep
and move mlx5e to store the relevant data there. As part of this change
we also initialize rep_if in mlx5e_rep_register_vf_vports() as otherwise the
E-Switch code will copy a priv value which is garbage.

We also rename mlx5_eswitch_get_uplink_netdev() to
mlx5_eswitch_get_uplink_priv() and make it return void *.
This way E-Switch code doesn't need to deal with net devices and
we leave the task of getting it to mlx5e.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 58 ++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  9 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  7 +--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  7 ++-
 5 files changed, 60 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 01bf4e3c8afa..3c74f0599ad3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -194,11 +194,13 @@ static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5_esw_sq *esw_sq, *tmp;
+	struct mlx5e_rep_priv *rpriv;
 
 	if (esw->mode != SRIOV_OFFLOADS)
 		return;
 
-	list_for_each_entry_safe(esw_sq, tmp, &rep->vport_sqs_list, list) {
+	rpriv = mlx5e_rep_to_rep_priv(rep);
+	list_for_each_entry_safe(esw_sq, tmp, &rpriv->vport_sqs_list, list) {
 		mlx5_eswitch_del_send_to_vport_rule(esw_sq->send_to_vport_rule);
 		list_del(&esw_sq->list);
 		kfree(esw_sq);
@@ -210,6 +212,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 				 u16 *sqns_array, int sqns_num)
 {
 	struct mlx5_flow_handle *flow_rule;
+	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_esw_sq *esw_sq;
 	int err;
 	int i;
@@ -217,6 +220,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 	if (esw->mode != SRIOV_OFFLOADS)
 		return 0;
 
+	rpriv = mlx5e_rep_to_rep_priv(rep);
 	for (i = 0; i < sqns_num; i++) {
 		esw_sq = kzalloc(sizeof(*esw_sq), GFP_KERNEL);
 		if (!esw_sq) {
@@ -234,7 +238,7 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 			goto out_err;
 		}
 		esw_sq->send_to_vport_rule = flow_rule;
-		list_add(&esw_sq->list, &rep->vport_sqs_list);
+		list_add(&esw_sq->list, &rpriv->vport_sqs_list);
 	}
 	return 0;
 
@@ -291,7 +295,7 @@ static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rpriv)
 #endif
 	unsigned long ipv4_interval = NEIGH_VAR(&arp_tbl.parms,
 						DELAY_PROBE_TIME);
-	struct net_device *netdev = rpriv->rep->netdev;
+	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
 	rpriv->neigh_update.min_interval = min_t(unsigned long, ipv6_interval, ipv4_interval);
@@ -312,7 +316,7 @@ static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
 {
 	struct mlx5e_rep_priv *rpriv = container_of(work, struct mlx5e_rep_priv,
 						    neigh_update.neigh_stats_work.work);
-	struct net_device *netdev = rpriv->rep->netdev;
+	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_neigh_hash_entry *nhe;
 
@@ -408,7 +412,7 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
 						    neigh_update.netevent_nb);
 	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	struct net_device *netdev = rpriv->rep->netdev;
+	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_neigh_hash_entry *nhe = NULL;
 	struct mlx5e_neigh m_neigh = {};
@@ -536,7 +540,7 @@ static int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv)
 static void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv)
 {
 	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	struct mlx5e_priv *priv = netdev_priv(rpriv->rep->netdev);
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 
 	unregister_netevent_notifier(&neigh_update->netevent_nb);
 
@@ -957,7 +961,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 		err = PTR_ERR(flow_rule);
 		goto err_destroy_direct_tirs;
 	}
-	rep->vport_rx_rule = flow_rule;
+	rpriv->vport_rx_rule = flow_rule;
 
 	err = mlx5e_tc_init(priv);
 	if (err)
@@ -966,7 +970,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	return 0;
 
 err_del_flow_rule:
-	mlx5_del_flow_rules(rep->vport_rx_rule);
+	mlx5_del_flow_rules(rpriv->vport_rx_rule);
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv);
 err_destroy_direct_rqts:
@@ -977,10 +981,9 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
 
 	mlx5e_tc_cleanup(priv);
-	mlx5_del_flow_rules(rep->vport_rx_rule);
+	mlx5_del_flow_rules(rpriv->vport_rx_rule);
 	mlx5e_destroy_direct_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv);
 }
@@ -1022,8 +1025,8 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 static int
 mlx5e_nic_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
-	struct mlx5e_priv *priv = netdev_priv(rep->netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 
 	int err;
 
@@ -1047,8 +1050,8 @@ mlx5e_nic_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 static void
 mlx5e_nic_rep_unload(struct mlx5_eswitch_rep *rep)
 {
-	struct mlx5e_priv *priv = netdev_priv(rep->netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 
 	if (test_bit(MLX5E_STATE_OPENED, &priv->state))
 		mlx5e_remove_sqs_fwd_rules(priv);
@@ -1063,6 +1066,7 @@ mlx5e_nic_rep_unload(struct mlx5_eswitch_rep *rep)
 static int
 mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
+	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5e_rep_priv *rpriv;
 	struct net_device *netdev;
 	struct mlx5e_priv *upriv;
@@ -1080,8 +1084,10 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		return -EINVAL;
 	}
 
-	rep->netdev = netdev;
+	rpriv->netdev = netdev;
 	rpriv->rep = rep;
+	rep->priv = rpriv;
+	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
 
 	err = mlx5e_attach_netdev(netdev_priv(netdev));
 	if (err) {
@@ -1097,7 +1103,8 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(dev->priv.eswitch));
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(dev->priv.eswitch);
+	upriv = netdev_priv(uplink_rpriv->netdev);
 	err = tc_setup_cb_egdev_register(netdev, mlx5e_setup_tc_block_cb,
 					 upriv);
 	if (err)
@@ -1131,14 +1138,16 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 static void
 mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 {
-	struct net_device *netdev = rep->netdev;
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
+	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_rep_priv *uplink_rpriv;
 	void *ppriv = priv->ppriv;
 	struct mlx5e_priv *upriv;
 
-	unregister_netdev(rep->netdev);
-	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(priv->mdev->priv.eswitch));
+	unregister_netdev(netdev);
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch);
+	upriv = netdev_priv(uplink_rpriv->netdev);
 	tc_setup_cb_egdev_unregister(netdev, mlx5e_setup_tc_block_cb,
 				     upriv);
 	mlx5e_rep_neigh_cleanup(rpriv);
@@ -1155,7 +1164,7 @@ static void mlx5e_rep_register_vf_vports(struct mlx5e_priv *priv)
 	int vport;
 
 	for (vport = 1; vport < total_vfs; vport++) {
-		struct mlx5_eswitch_rep rep;
+		struct mlx5_eswitch_rep rep = {};
 
 		rep.load = mlx5e_vport_rep_load;
 		rep.unload = mlx5e_vport_rep_unload;
@@ -1178,11 +1187,16 @@ void mlx5e_register_vport_reps(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_eswitch *esw   = mdev->priv.eswitch;
+	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_eswitch_rep rep;
 
+	rpriv = priv->ppriv;
+	rpriv->netdev = priv->netdev;
+
 	rep.load = mlx5e_nic_rep_load;
 	rep.unload = mlx5e_nic_rep_unload;
-	rep.netdev = priv->netdev;
+	rep.priv = rpriv;
+	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
 	mlx5_eswitch_register_vport_rep(esw, 0, &rep); /* UPLINK PF vport*/
 
 	mlx5e_rep_register_vf_vports(priv); /* VFs vports */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 5659ed9f51e6..8db68369367e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -56,8 +56,17 @@ struct mlx5e_neigh_update_table {
 struct mlx5e_rep_priv {
 	struct mlx5_eswitch_rep *rep;
 	struct mlx5e_neigh_update_table neigh_update;
+	struct net_device      *netdev;
+	struct mlx5_flow_handle *vport_rx_rule;
+	struct list_head       vport_sqs_list;
 };
 
+static inline
+struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
+{
+	return (struct mlx5e_rep_priv *)rep->priv;
+}
+
 struct mlx5e_neigh {
 	struct net_device *dev;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 55979ec2e88a..f462496cce7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -617,7 +617,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 						  FLOW_DISSECTOR_KEY_ENC_PORTS,
 						  f->mask);
 		struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-		struct net_device *up_dev = mlx5_eswitch_get_uplink_netdev(esw);
+		struct mlx5e_rep_priv *uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw);
+		struct net_device *up_dev = uplink_rpriv->netdev;
 		struct mlx5e_priv *up_priv = netdev_priv(up_dev);
 
 		/* Full udp dst port must be given */
@@ -1507,6 +1508,7 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 				   int *out_ttl)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_rep_priv *uplink_rpriv;
 	struct rtable *rt;
 	struct neighbour *n = NULL;
 
@@ -1520,9 +1522,10 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 #else
 	return -EOPNOTSUPP;
 #endif
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw);
 	/* if the egress device isn't on the same HW e-switch, we use the uplink */
 	if (!switchdev_port_same_parent_id(priv->netdev, rt->dst.dev))
-		*out_dev = mlx5_eswitch_get_uplink_netdev(esw);
+		*out_dev = uplink_rpriv->netdev;
 	else
 		*out_dev = rt->dst.dev;
 
@@ -1543,6 +1546,7 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 				   struct neighbour **out_n,
 				   int *out_ttl)
 {
+	struct mlx5e_rep_priv *uplink_rpriv;
 	struct neighbour *n = NULL;
 	struct dst_entry *dst;
 
@@ -1557,9 +1561,10 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 
 	*out_ttl = ip6_dst_hoplimit(dst);
 
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw);
 	/* if the egress device isn't on the same HW e-switch, we use the uplink */
 	if (!switchdev_port_same_parent_id(priv->netdev, dst->dev))
-		*out_dev = mlx5_eswitch_get_uplink_netdev(esw);
+		*out_dev = uplink_rpriv->netdev;
 	else
 		*out_dev = dst->dev;
 #else
@@ -1859,7 +1864,8 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct net_device *up_dev = mlx5_eswitch_get_uplink_netdev(esw);
+	struct mlx5e_rep_priv *uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw);
+	struct net_device *up_dev = uplink_rpriv->netdev;
 	unsigned short family = ip_tunnel_info_af(tun_info);
 	struct mlx5e_priv *up_priv = netdev_priv(up_dev);
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9ed401225225..3a21ea4e4d24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -142,12 +142,9 @@ struct mlx5_eswitch_rep {
 	int		       (*load)(struct mlx5_core_dev *dev,
 				       struct mlx5_eswitch_rep *rep);
 	void		       (*unload)(struct mlx5_eswitch_rep *rep);
+	void			*priv;
 	u16		       vport;
 	u8		       hw_id[ETH_ALEN];
-	struct net_device      *netdev;
-
-	struct mlx5_flow_handle *vport_rx_rule;
-	struct list_head       vport_sqs_list;
 	u16		       vlan;
 	u32		       vlan_refcount;
 	bool		       valid;
@@ -274,7 +271,7 @@ void mlx5_eswitch_register_vport_rep(struct mlx5_eswitch *esw,
 				     struct mlx5_eswitch_rep *rep);
 void mlx5_eswitch_unregister_vport_rep(struct mlx5_eswitch *esw,
 				       int vport_index);
-struct net_device *mlx5_eswitch_get_uplink_netdev(struct mlx5_eswitch *esw);
+void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 				 struct mlx5_esw_flow_attr *attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b37f8ac01e43..6560e5943e1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1131,9 +1131,8 @@ void mlx5_eswitch_register_vport_rep(struct mlx5_eswitch *esw,
 
 	rep->load   = __rep->load;
 	rep->unload = __rep->unload;
-	rep->netdev = __rep->netdev;
+	rep->priv = __rep->priv;
 
-	INIT_LIST_HEAD(&rep->vport_sqs_list);
 	rep->valid = true;
 }
 
@@ -1151,12 +1150,12 @@ void mlx5_eswitch_unregister_vport_rep(struct mlx5_eswitch *esw,
 	rep->valid = false;
 }
 
-struct net_device *mlx5_eswitch_get_uplink_netdev(struct mlx5_eswitch *esw)
+void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw)
 {
 #define UPLINK_REP_INDEX 0
 	struct mlx5_esw_offload *offloads = &esw->offloads;
 	struct mlx5_eswitch_rep *rep;
 
 	rep = &offloads->vport_reps[UPLINK_REP_INDEX];
-	return rep->netdev;
+	return rep->priv;
 }
-- 
2.14.2
