From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH rdma-next 10/14] RDMA: Annotate create QP callers
Date: Thu, 21 Dec 2017 20:17:44 +0200
Message-ID: <20171221181748.17126-11-leon@kernel.org>
References: <20171221181748.17126-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update all callers to provide owner name through QP attribute
structure and connect create_qp with helper which supports
resource tracking.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c              | 1 +
 drivers/infiniband/core/mad.c              | 1 +
 drivers/infiniband/core/uverbs_cmd.c       | 3 +--
 drivers/infiniband/core/verbs.c            | 4 ++--
 drivers/infiniband/hw/mlx4/mad.c           | 1 +
 drivers/infiniband/hw/mlx4/qp.c            | 1 +
 drivers/infiniband/hw/mlx5/gsi.c           | 2 ++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 4 +++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 1 +
 drivers/infiniband/ulp/srp/ib_srp.c        | 1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c      | 1 +
 net/smc/smc_ib.c                           | 1 +
 12 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e5c9f42a7e4b..b13968cc5a30 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -857,6 +857,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
 		return -EINVAL;

 	qp_init_attr->port_num = id->port_num;
+	strncpy(qp_init_attr->comm, "rdma-cm", TASK_COMM_LEN);
 	qp = ib_create_qp(pd, qp_init_attr);
 	if (IS_ERR(qp))
 		return PTR_ERR(qp);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index cb91245e9163..f58a2b8e6979 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3104,6 +3104,7 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	qp_init_attr.port_num = qp_info->port_priv->port_num;
 	qp_init_attr.qp_context = qp_info;
 	qp_init_attr.event_handler = qp_event_handler;
+	strncpy(qp_init_attr.comm, "rdma-mad", TASK_COMM_LEN);
 	qp_info->qp = ib_create_qp(qp_info->port_priv->pd, &qp_init_attr);
 	if (IS_ERR(qp_info->qp)) {
 		dev_err(&qp_info->port_priv->device->dev,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 16d55710b116..24609be0c5cf 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1517,7 +1517,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
-		qp = device->create_qp(pd, &attr, uhw);
+		qp = _ib_create_qp(device, pd, &attr, uhw);

 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
@@ -1530,7 +1530,6 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_cb;

 		qp->real_qp	  = qp;
-		qp->device	  = device;
 		qp->pd		  = pd;
 		qp->send_cq	  = attr.send_cq;
 		qp->recv_cq	  = attr.recv_cq;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b53fb0e98751..6d95263a40d6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -866,7 +866,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (qp_init_attr->cap.max_rdma_ctxs)
 		rdma_rw_init_qp(device, qp_init_attr);

-	qp = device->create_qp(pd, qp_init_attr, NULL);
+	qp = _ib_create_qp(device, pd, qp_init_attr, NULL);
 	if (IS_ERR(qp))
 		return qp;

@@ -876,7 +876,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		return ERR_PTR(ret);
 	}

-	qp->device     = device;
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
@@ -1503,6 +1502,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);

+	rdma_restrack_del(&qp->res, RDMA_RESTRACK_QP);
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
 		if (pd)
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 0793a21d76f4..f816df420fb9 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1834,6 +1834,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 	qp_init_attr.init_attr.port_num = ctx->port;
 	qp_init_attr.init_attr.qp_context = ctx;
 	qp_init_attr.init_attr.event_handler = pv_qp_event_handler;
+	strncpy(qp_init_attr.init_attr.comm, "mlx4-sriov", TASK_COMM_LEN);
 	tun_qp->qp = ib_create_qp(ctx->pd, &qp_init_attr.init_attr);
 	if (IS_ERR(tun_qp->qp)) {
 		ret = PTR_ERR(tun_qp->qp);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 0172e1514527..6aebc50dae79 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1677,6 +1677,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 		if (is_eth &&
 		    dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2) {
 			init_attr->create_flags |= MLX4_IB_QP_CREATE_ROCE_V2_GSI;
+			strncpy(init_attr->comm, "mlx4-gsi", TASK_COMM_LEN);
 			sqp->roce_v2_gsi = ib_create_qp(pd, init_attr);

 			if (IS_ERR(sqp->roce_v2_gsi)) {
diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 79e6309460dc..b1b177d1a0dd 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -184,6 +184,7 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 		hw_init_attr.cap.max_send_sge = 0;
 		hw_init_attr.cap.max_inline_data = 0;
 	}
+	strncpy(hw_init_attr.comm, "mlx5-gsi", TASK_COMM_LEN);
 	gsi->rx_qp = ib_create_qp(pd, &hw_init_attr);
 	if (IS_ERR(gsi->rx_qp)) {
 		mlx5_ib_warn(dev, "unable to create hardware GSI QP. error %ld\n",
@@ -264,6 +265,7 @@ static struct ib_qp *create_gsi_ud_qp(struct mlx5_ib_gsi_qp *gsi)
 		.sq_sig_type = gsi->sq_sig_type,
 		.qp_type = IB_QPT_UD,
 		.create_flags = mlx5_ib_create_qp_sqpn_qp1(),
+		.comm = "mlx5-gsi",
 	};

 	return ib_create_qp(pd, &init_attr);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 87f4bd99cdf7..e660db0f8884 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -263,6 +263,7 @@ static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
 		.sq_sig_type = IB_SIGNAL_ALL_WR,
 		.qp_type = IB_QPT_RC,
 		.qp_context = p,
+		.comm = "ipoib-cm",
 	};

 	if (!ipoib_cm_has_srq(dev)) {
@@ -1060,7 +1061,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 		.sq_sig_type		= IB_SIGNAL_ALL_WR,
 		.qp_type		= IB_QPT_RC,
 		.qp_context		= tx,
-		.create_flags		= 0
+		.create_flags		= 0,
+		.comm			= "ipoib-cm",
 	};
 	struct ib_qp *tx_qp;

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index a1ed25422b72..9fd0a9c9022e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -206,6 +206,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	if (priv->hca_caps & IB_DEVICE_MANAGED_FLOW_STEERING)
 		init_attr.create_flags |= IB_QP_CREATE_NETIF_QP;

+	strncpy(init_attr.comm, "ipoib-verbs", TASK_COMM_LEN);
 	priv->qp = ib_create_qp(priv->pd, &init_attr);
 	if (IS_ERR(priv->qp)) {
 		printk(KERN_WARNING "%s: failed to create QP\n", ca->name);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 972d4b3c5223..65ef854cb640 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -521,6 +521,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	init_attr->send_cq             = send_cq;
 	init_attr->recv_cq             = recv_cq;

+	strncpy(init_attr->comm, "srp", TASK_COMM_LEN);
 	qp = ib_create_qp(dev->pd, init_attr);
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8a1bd354b1cc..a35563da9b47 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1673,6 +1673,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		qp_init->cap.max_recv_sge = qp_init->cap.max_send_sge;
 	}

+	strncpy(qp_init->comm, "srpt", TASK_COMM_LEN);
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
 	if (IS_ERR(ch->qp)) {
 		ret = PTR_ERR(ch->qp);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 90f1a7f9085c..9f5bca333cce 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -243,6 +243,7 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 		},
 		.sq_sig_type = IB_SIGNAL_REQ_WR,
 		.qp_type = IB_QPT_RC,
+		.comm = "sec-ib",
 	};
 	int rc;

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
