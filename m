From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 07/12] RDMA/mlx5: Move rep into port struct
Date: Thu, 28 Mar 2019 15:27:37 +0200
Message-ID: <20190328132742.12070-8-leon@kernel.org>
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

In preparation of moving into a model of single IB device multiple ports
move rep to be part of the port structure. We mark a representor device
by setting is_rep, no functional change with this patch.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |  2 +-
 drivers/infiniband/hw/mlx5/flow.c    |  2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c  |  7 ++++---
 drivers/infiniband/hw/mlx5/main.c    | 22 +++++++++++++---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 ++-
 drivers/infiniband/hw/mlx5/mr.c      |  6 +++---
 drivers/infiniband/hw/mlx5/qp.c      |  4 ++--
 7 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 9e08df7914aa..687425ccc870 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1900,7 +1900,7 @@ static bool devx_is_supported(struct ib_device *device)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 
-	return !dev->rep && MLX5_CAP_GEN(dev->mdev, log_max_uctx);
+	return !dev->is_rep && MLX5_CAP_GEN(dev->mdev, log_max_uctx);
 }
 
 const struct uapi_definition mlx5_ib_devx_defs[] = {
diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 798591a18484..969fafb6ed9b 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -621,7 +621,7 @@ DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER,
 
 static bool flow_is_supported(struct ib_device *device)
 {
-	return !to_mdev(device)->rep;
+	return !to_mdev(device)->is_rep;
 }
 
 const struct uapi_definition mlx5_ib_flow_defs[] = {
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 14ac728b460c..64256dc1d1de 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -69,7 +69,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		return -ENOMEM;
 	}
 
-	ibdev->rep = rep;
+	ibdev->is_rep = true;
+	ibdev->port[0].rep = rep;
 	ibdev->mdev = dev;
 	ibdev->num_ports = num_ports;
 
@@ -151,12 +152,12 @@ int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
 
-	if (!dev->rep)
+	if (!dev->is_rep)
 		return 0;
 
 	flow_rule =
 		mlx5_eswitch_add_send_to_vport_rule(esw,
-						    dev->rep->vport,
+						    dev->port[0].rep->vport,
 						    sq->base.mqp.qpn);
 	if (IS_ERR(flow_rule))
 		return PTR_ERR(flow_rule);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 14cc4c56e2b1..d9dfc9975164 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -173,12 +173,12 @@ static int mlx5_netdev_event(struct notifier_block *this,
 	switch (event) {
 	case NETDEV_REGISTER:
 		write_lock(&roce->netdev_lock);
-		if (ibdev->rep) {
+		if (ibdev->is_rep) {
 			struct mlx5_eswitch *esw = ibdev->mdev->priv.eswitch;
+			struct mlx5_eswitch_rep	*rep = ibdev->port[0].rep;
 			struct net_device *rep_ndev;
 
-			rep_ndev = mlx5_ib_get_rep_netdev(esw,
-							  ibdev->rep->vport);
+			rep_ndev = mlx5_ib_get_rep_netdev(esw, rep->vport);
 			if (rep_ndev == ndev)
 				roce->netdev = ndev;
 		} else if (ndev->dev.parent == &mdev->pdev->dev) {
@@ -3149,10 +3149,10 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 		if (ft_type == MLX5_IB_FT_RX) {
 			fn_type = MLX5_FLOW_NAMESPACE_BYPASS;
 			prio = &dev->flow_db->prios[priority];
-			if (!dev->rep &&
+			if (!dev->is_rep &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
-			if (!dev->rep &&
+			if (!dev->is_rep &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					reformat_l3_tunnel_to_l2))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
@@ -3162,7 +3162,7 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 							      log_max_ft_size));
 			fn_type = MLX5_FLOW_NAMESPACE_EGRESS;
 			prio = &dev->flow_db->egress_prios[priority];
-			if (!dev->rep &&
+			if (!dev->is_rep &&
 			    MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		}
@@ -3368,7 +3368,7 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	if (!is_valid_attr(dev->mdev, flow_attr))
 		return ERR_PTR(-EINVAL);
 
-	if (dev->rep && is_egress)
+	if (dev->is_rep && is_egress)
 		return ERR_PTR(-EINVAL);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
@@ -3399,13 +3399,17 @@ static struct mlx5_ib_flow_handler *_create_flow_rule(struct mlx5_ib_dev *dev,
 	if (!flow_is_multicast_only(flow_attr))
 		set_underlay_qp(dev, spec, underlay_qpn);
 
-	if (dev->rep) {
+	if (dev->is_rep) {
 		void *misc;
 
+		if (!dev->port[flow_attr->port - 1].rep) {
+			err = -EINVAL;
+			goto free;
+		}
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
 		MLX5_SET(fte_match_set_misc, misc, source_port,
-			 dev->rep->vport);
+			 dev->port[flow_attr->port - 1].rep->vport);
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 				    misc_parameters);
 		MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 662cc73b7b6b..885f87d0a3f9 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -724,6 +724,7 @@ struct mlx5_ib_port {
 	struct mlx5_ib_multiport mp;
 	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
 	struct mlx5_roce roce;
+	struct mlx5_eswitch_rep		*rep;
 };
 
 struct mlx5_ib_dbg_param {
@@ -944,7 +945,7 @@ struct mlx5_ib_dev {
 	struct mlx5_sq_bfreg	fp_bfreg;
 	struct mlx5_ib_delay_drop	delay_drop;
 	const struct mlx5_ib_profile	*profile;
-	struct mlx5_eswitch_rep		*rep;
+	bool			is_rep;
 	int				lag_active;
 
 	struct mlx5_ib_lb_state		lb;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c85f00255884..02119fe8338f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -600,7 +600,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 
 static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
-	if (!mlx5_debugfs_root || dev->rep)
+	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
 
 	debugfs_remove_recursive(dev->cache.root);
@@ -614,7 +614,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 	struct dentry *dir;
 	int i;
 
-	if (!mlx5_debugfs_root || dev->rep)
+	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
 
 	cache->root = debugfs_create_dir("mr_cache", dev->mdev->priv.dbg_root);
@@ -677,7 +677,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 			   MLX5_IB_UMR_OCTOWORD;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
-		    !dev->rep &&
+		    !dev->is_rep &&
 		    mlx5_core_is_pf(dev->mdev))
 			ent->limit = dev->mdev->profile->mr_cache[i].limit;
 		else
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d84c7f478513..c597e0b7f904 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1430,7 +1430,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 	if (*qp_flags_en & MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC)
 		lb_flag |= MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST;
 
-	if (dev->rep) {
+	if (dev->is_rep) {
 		lb_flag |= MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST;
 		*qp_flags_en |= MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC;
 	}
@@ -1642,7 +1642,7 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return -EOPNOTSUPP;
 	}
 
-	if (ucmd.flags & MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC || dev->rep) {
+	if (ucmd.flags & MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC || dev->is_rep) {
 		lb_flag |= MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST;
 		qp->flags_en |= MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC;
 	}
-- 
2.20.1
