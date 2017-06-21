From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] (IB, net)/mlx4: Add resource utilization support
Date: Wed, 21 Jun 2017 09:29:36 +0300
Message-ID: <20170621062936.7894-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Adding visibility of resource usage of QPs, CQs and counters used by
virtual functions. This feature will be used to give the PF administrator
more data while debugging VF status. Usage info was added to ALLOC_RES
command, to notify the PF if the resource which is being reserved or
allocated for the VF will be used by kernel driver or by user verbs.

Updated reservation and allocation functions of QP, CQ and counter with
additional usage parameter.

Signed-off-by: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c                |  2 ++
 drivers/infiniband/hw/mlx4/main.c              |  6 ++++--
 drivers/infiniband/hw/mlx4/qp.c                | 13 +++++++++----
 drivers/net/ethernet/mellanox/mlx4/cq.c        |  7 ++++---
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |  1 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |  3 ++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |  6 ++++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c     |  3 ++-
 drivers/net/ethernet/mellanox/mlx4/main.c      |  7 ++++---
 drivers/net/ethernet/mellanox/mlx4/qp.c        |  5 +++--
 include/linux/mlx4/device.h                    | 12 ++++++++++--
 11 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 4f5a143fc0a7..25d307846492 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -218,6 +218,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 			goto err_mtt;

 		uar = &to_mucontext(context)->uar;
+		cq->mcq.usage = MLX4_RES_USAGE_USER_VERBS;
 	} else {
 		err = mlx4_db_alloc(dev->dev, &cq->db, 1, GFP_KERNEL);
 		if (err)
@@ -233,6 +234,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 			goto err_db;

 		uar = &dev->priv_uar;
+		cq->mcq.usage = MLX4_RES_USAGE_DRIVER;
 	}

 	if (dev->eq_table)
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75b2f7d4cd95..56c775dfb07a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2772,7 +2772,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		allocated = 0;
 		if (mlx4_ib_port_link_layer(&ibdev->ib_dev, i + 1) ==
 						IB_LINK_LAYER_ETHERNET) {
-			err = mlx4_counter_alloc(ibdev->dev, &counter_index);
+			err = mlx4_counter_alloc(ibdev->dev, &counter_index,
+						 MLX4_RES_USAGE_DRIVER);
 			/* if failed to allocate a new counter, use default */
 			if (err)
 				counter_index =
@@ -2827,7 +2828,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->steer_qpn_count = MLX4_IB_UC_MAX_NUM_QPS;
 		err = mlx4_qp_reserve_range(dev, ibdev->steer_qpn_count,
 					    MLX4_IB_UC_STEER_QPN_ALIGN,
-					    &ibdev->steer_qpn_base, 0);
+					    &ibdev->steer_qpn_base, 0,
+					    MLX4_RES_USAGE_DRIVER);
 		if (err)
 			goto err_counter;

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 996e9058e515..b37107f93c39 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -759,6 +759,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			if (err)
 				goto err_mtt;
 		}
+		qp->mqp.usage = MLX4_RES_USAGE_USER_VERBS;
 	} else {
 		qp->sq_no_prefetch = 0;

@@ -826,6 +827,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			err = -ENOMEM;
 			goto err_wrid;
 		}
+		qp->mqp.usage = MLX4_RES_USAGE_DRIVER;
 	}

 	if (sqpn) {
@@ -845,13 +847,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 						    (init_attr->cap.max_send_wr ?
 						     MLX4_RESERVE_ETH_BF_QP : 0) |
 						    (init_attr->cap.max_recv_wr ?
-						     MLX4_RESERVE_A0_QP : 0));
+						     MLX4_RESERVE_A0_QP : 0),
+						    qp->mqp.usage);
 		else
 			if (qp->flags & MLX4_IB_QP_NETIF)
 				err = mlx4_ib_steer_qp_alloc(dev, 1, &qpn);
 			else
 				err = mlx4_qp_reserve_range(dev->dev, 1, 1,
-							    &qpn, 0);
+							    &qpn, 0, qp->mqp.usage);
 		if (err)
 			goto err_proxy;
 	}
@@ -1208,7 +1211,9 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 		if (udata)
 			return ERR_PTR(-EINVAL);
 		if (init_attr->create_flags & MLX4_IB_QP_CREATE_ROCE_V2_GSI) {
-			int res = mlx4_qp_reserve_range(to_mdev(pd->device)->dev, 1, 1, &sqpn, 0);
+			int res = mlx4_qp_reserve_range(to_mdev(pd->device)->dev,
+							1, 1, &sqpn, 0,
+							MLX4_RES_USAGE_DRIVER);

 			if (res)
 				return ERR_PTR(res);
@@ -1572,7 +1577,7 @@ static int create_qp_lb_counter(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 	    !(dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_LB_SRC_CHK))
 		return 0;

-	err = mlx4_counter_alloc(dev->dev, &tmp_idx);
+	err = mlx4_counter_alloc(dev->dev, &tmp_idx, MLX4_RES_USAGE_DRIVER);
 	if (err)
 		return err;

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index fa6d2354a0e9..68f5588e5a84 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -241,13 +241,14 @@ int __mlx4_cq_alloc_icm(struct mlx4_dev *dev, int *cqn)
 	return err;
 }

-static int mlx4_cq_alloc_icm(struct mlx4_dev *dev, int *cqn)
+static int mlx4_cq_alloc_icm(struct mlx4_dev *dev, int *cqn, u8 usage)
 {
+	u32 in_modifier = RES_CQ | (((u32)usage & 3) << 30);
 	u64 out_param;
 	int err;

 	if (mlx4_is_mfunc(dev)) {
-		err = mlx4_cmd_imm(dev, 0, &out_param, RES_CQ,
+		err = mlx4_cmd_imm(dev, 0, &out_param, in_modifier,
 				   RES_OP_RESERVE_AND_MAP, MLX4_CMD_ALLOC_RES,
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (err)
@@ -303,7 +304,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,

 	cq->vector = vector;

-	err = mlx4_cq_alloc_icm(dev, &cq->cqn);
+	err = mlx4_cq_alloc_icm(dev, &cq->cqn, cq->usage);
 	if (err)
 		return err;

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_cq.c b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
index 09dd3776db76..f91ffb7d7a86 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_cq.c
@@ -140,6 +140,7 @@ int mlx4_en_activate_cq(struct mlx4_en_priv *priv, struct mlx4_en_cq *cq,
 	    (cq->type == RX && priv->hwtstamp_config.rx_filter))
 		timestamp_en = 1;

+	cq->mcq.usage = MLX4_RES_USAGE_DRIVER;
 	err = mlx4_cq_alloc(mdev->dev, cq->size, &cq->wqres.mtt,
 			    &mdev->priv_uar, cq->wqres.db.dma, &cq->mcq,
 			    cq->vector, 0, timestamp_en);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 51ce111b719e..4d85a351a645 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -604,7 +604,8 @@ static int mlx4_en_get_qp(struct mlx4_en_priv *priv)
 		return 0;
 	}

-	err = mlx4_qp_reserve_range(dev, 1, 1, qpn, MLX4_RESERVE_A0_QP);
+	err = mlx4_qp_reserve_range(dev, 1, 1, qpn, MLX4_RESERVE_A0_QP,
+				    MLX4_RES_USAGE_DRIVER);
 	en_dbg(DRV, priv, "Reserved qp %d\n", *qpn);
 	if (err) {
 		en_err(priv, "Failed to reserve qp for mac registration\n");
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index c4edae854f1b..19f1bc85de79 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1060,7 +1060,8 @@ int mlx4_en_create_drop_qp(struct mlx4_en_priv *priv)
 	u32 qpn;

 	err = mlx4_qp_reserve_range(priv->mdev->dev, 1, 1, &qpn,
-				    MLX4_RESERVE_A0_QP);
+				    MLX4_RESERVE_A0_QP,
+				    MLX4_RES_USAGE_DRIVER);
 	if (err) {
 		en_err(priv, "Failed reserving drop qpn\n");
 		return err;
@@ -1106,7 +1107,8 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 	flags = priv->rx_ring_num == 1 ? MLX4_RESERVE_A0_QP : 0;
 	err = mlx4_qp_reserve_range(mdev->dev, priv->rx_ring_num,
 				    priv->rx_ring_num,
-				    &rss_map->base_qpn, flags);
+				    &rss_map->base_qpn, flags,
+				    MLX4_RES_USAGE_DRIVER);
 	if (err) {
 		en_err(priv, "Failed reserving %d qps\n", priv->rx_ring_num);
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 37386abea54c..054b96574204 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -105,7 +105,8 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	       (unsigned long long) ring->sp_wqres.buf.direct.map);

 	err = mlx4_qp_reserve_range(mdev->dev, 1, 1, &ring->qpn,
-				    MLX4_RESERVE_ETH_BF_QP);
+				    MLX4_RESERVE_ETH_BF_QP,
+				    MLX4_RES_USAGE_DRIVER);
 	if (err) {
 		en_err(priv, "failed reserving qp for TX ring\n");
 		goto err_hwq_res;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 457e070bca46..c27c2cf590ab 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2475,7 +2475,7 @@ static int mlx4_allocate_default_counters(struct mlx4_dev *dev)
 		priv->def_counter[port] = -1;

 	for (port = 0; port < dev->caps.num_ports; port++) {
-		err = mlx4_counter_alloc(dev, &idx);
+		err = mlx4_counter_alloc(dev, &idx, MLX4_RES_USAGE_DRIVER);

 		if (!err || err == -ENOSPC) {
 			priv->def_counter[port] = idx;
@@ -2517,13 +2517,14 @@ int __mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
 	return 0;
 }

-int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx, u8 usage)
 {
+	u32 in_modifier = RES_COUNTER | (((u32)usage & 3) << 30);
 	u64 out_param;
 	int err;

 	if (mlx4_is_mfunc(dev)) {
-		err = mlx4_cmd_imm(dev, 0, &out_param, RES_COUNTER,
+		err = mlx4_cmd_imm(dev, 0, &out_param, in_modifier,
 				   RES_OP_RESERVE, MLX4_CMD_ALLOC_RES,
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (!err)
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 5a310d313e94..de3f556bc35f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -245,8 +245,9 @@ int __mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
 }

 int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
-			  int *base, u8 flags)
+			  int *base, u8 flags, u8 usage)
 {
+	u32 in_modifier = RES_QP | (((u32)usage & 3) << 30);
 	u64 in_param = 0;
 	u64 out_param;
 	int err;
@@ -258,7 +259,7 @@ int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
 		set_param_l(&in_param, (((u32)flags) << 24) | (u32)cnt);
 		set_param_h(&in_param, align);
 		err = mlx4_cmd_imm(dev, in_param, &out_param,
-				   RES_QP, RES_OP_RESERVE,
+				   in_modifier, RES_OP_RESERVE,
 				   MLX4_CMD_ALLOC_RES,
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (err)
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index d5bed0875d30..815bd3eed244 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -428,6 +428,12 @@ enum mlx4_steer_type {
 	MLX4_NUM_STEERS
 };

+enum mlx4_resource_usage {
+	MLX4_RES_USAGE_NONE,
+	MLX4_RES_USAGE_DRIVER,
+	MLX4_RES_USAGE_USER_VERBS,
+};
+
 enum {
 	MLX4_NUM_FEXCH          = 64 * 1024,
 };
@@ -748,6 +754,7 @@ struct mlx4_cq {
 	} tasklet_ctx;
 	int		reset_notify_added;
 	struct list_head	reset_notify;
+	u8			usage;
 };

 struct mlx4_qp {
@@ -757,6 +764,7 @@ struct mlx4_qp {

 	atomic_t		refcount;
 	struct completion	free;
+	u8			usage;
 };

 struct mlx4_srq {
@@ -1121,7 +1129,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 		  unsigned vector, int collapsed, int timestamp_en);
 void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq);
 int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
-			  int *base, u8 flags);
+			  int *base, u8 flags, u8 usage);
 void mlx4_qp_release_range(struct mlx4_dev *dev, int base_qpn, int cnt);

 int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp,
@@ -1419,7 +1427,7 @@ int mlx4_get_phys_port_id(struct mlx4_dev *dev);
 int mlx4_wol_read(struct mlx4_dev *dev, u64 *config, int port);
 int mlx4_wol_write(struct mlx4_dev *dev, u64 config, int port);

-int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx);
+int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx, u8 usage);
 void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
 int mlx4_get_default_counter_index(struct mlx4_dev *dev, int port);

--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
