From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 08/12] RDMA/mlx5: Move default representors SQ steering to rule to modify QP
Date: Thu, 28 Mar 2019 15:27:38 +0200
Message-ID: <20190328132742.12070-9-leon@kernel.org>
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

Currently the steering for SQs created on representors is done on creation,
once we move to representors as ports of an IB device we need the port
argument which is given only at the modify QP stage, adjust the code
appropriately.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 25 +++++++++---------
 drivers/infiniband/hw/mlx5/ib_rep.h | 13 ++++++----
 drivers/infiniband/hw/mlx5/qp.c     | 40 ++++++++++++++++++++---------
 3 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 64256dc1d1de..d3988f6ae2ae 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -146,22 +146,21 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw, int vport)
 	return mlx5_eswitch_vport_rep(esw, vport);
 }
 
-int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
-			      struct mlx5_ib_sq *sq)
+struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
+						   struct mlx5_ib_sq *sq,
+						   u16 port)
 {
-	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
+	struct mlx5_eswitch_rep *rep;
 
-	if (!dev->is_rep)
-		return 0;
+	if (!dev->is_rep || !port)
+		return NULL;
 
-	flow_rule =
-		mlx5_eswitch_add_send_to_vport_rule(esw,
-						    dev->port[0].rep->vport,
-						    sq->base.mqp.qpn);
-	if (IS_ERR(flow_rule))
-		return PTR_ERR(flow_rule);
-	sq->flow_rule = flow_rule;
+	if (!dev->port[port - 1].rep)
+		return ERR_PTR(-EINVAL);
 
-	return 0;
+	rep = dev->port[port - 1].rep;
+
+	return mlx5_eswitch_add_send_to_vport_rule(esw, rep->vport,
+						   sq->base.mqp.qpn);
 }
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index 798d41e61fb4..1d9778da8a50 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -20,8 +20,9 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 					   int vport_index);
 void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev);
 void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev);
-int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
-			      struct mlx5_ib_sq *sq);
+struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
+						   struct mlx5_ib_sq *sq,
+						   u16 port);
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  int vport_index);
 #else /* CONFIG_MLX5_ESWITCH */
@@ -52,10 +53,12 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
 
 static inline void mlx5_ib_register_vport_reps(struct mlx5_core_dev *mdev) {}
 static inline void mlx5_ib_unregister_vport_reps(struct mlx5_core_dev *mdev) {}
-static inline int create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
-					    struct mlx5_ib_sq *sq)
+static inline
+struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
+						   struct mlx5_ib_sq *sq,
+						   u16 port)
 {
-	return 0;
+	return NULL;
 }
 
 static inline
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index c597e0b7f904..3ff7c32207b9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -93,6 +93,7 @@ struct mlx5_modify_raw_qp_param {
 	struct mlx5_rate_limit rl;
 
 	u8 rq_q_ctr_id;
+	u16 port;
 };
 
 static void get_cqs(enum ib_qp_type qp_type,
@@ -1207,11 +1208,11 @@ static void destroy_raw_packet_qp_tis(struct mlx5_ib_dev *dev,
 	mlx5_cmd_destroy_tis(dev->mdev, sq->tisn, to_mpd(pd)->uid);
 }
 
-static void destroy_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
-				       struct mlx5_ib_sq *sq)
+static void destroy_flow_rule_vport_sq(struct mlx5_ib_sq *sq)
 {
 	if (sq->flow_rule)
 		mlx5_del_flow_rules(sq->flow_rule);
+	sq->flow_rule = NULL;
 }
 
 static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
@@ -1279,15 +1280,8 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	if (err)
 		goto err_umem;
 
-	err = create_flow_rule_vport_sq(dev, sq);
-	if (err)
-		goto err_flow;
-
 	return 0;
 
-err_flow:
-	mlx5_core_destroy_sq_tracked(dev->mdev, &sq->base.mqp);
-
 err_umem:
 	ib_umem_release(sq->ubuffer.umem);
 	sq->ubuffer.umem = NULL;
@@ -1298,7 +1292,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 static void destroy_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 				     struct mlx5_ib_sq *sq)
 {
-	destroy_flow_rule_vport_sq(dev, sq);
+	destroy_flow_rule_vport_sq(sq);
 	mlx5_core_destroy_sq_tracked(dev->mdev, &sq->base.mqp);
 	ib_umem_release(sq->ubuffer.umem);
 }
@@ -3262,6 +3256,8 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	if (modify_sq) {
+		struct mlx5_flow_handle *flow_rule;
+
 		if (tx_affinity) {
 			err = modify_raw_packet_tx_affinity(dev->mdev, sq,
 							    tx_affinity,
@@ -3270,8 +3266,25 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				return err;
 		}
 
-		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state,
-					       raw_qp_param, qp->ibqp.pd);
+		flow_rule = create_flow_rule_vport_sq(dev, sq,
+						      raw_qp_param->port);
+		if (IS_ERR(flow_rule))
+			return err;
+
+		err = modify_raw_packet_qp_sq(dev->mdev, sq, sq_state,
+					      raw_qp_param, qp->ibqp.pd);
+		if (err) {
+			if (flow_rule)
+				mlx5_del_flow_rules(flow_rule);
+			return err;
+		}
+
+		if (flow_rule) {
+			destroy_flow_rule_vport_sq(sq);
+			sq->flow_rule = flow_rule;
+		}
+
+		return err;
 	}
 
 	return 0;
@@ -3588,6 +3601,9 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			raw_qp_param.set_mask |= MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
 		}
 
+		if (attr_mask & IB_QP_PORT)
+			raw_qp_param.port = attr->port_num;
+
 		if (attr_mask & IB_QP_RATE_LIMIT) {
 			raw_qp_param.rl.rate = attr->rate_limit;
 
-- 
2.20.1
