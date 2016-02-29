From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 04/10] IB/mlx5: Create multiple transmission GSI QPs
Date: Mon, 29 Feb 2016 15:45:06 +0200
Message-ID: <1456753512-17688-5-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to send GSI MADs on different P_Keys, mlx5 needs different QPs to
be created, each with a different P_Key set when the QP is modified to the
INIT state.

Create QPs for each non-zero P_Key in the P_Key table.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/gsi.c | 170 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 711655400ca5..91bd20eb59b7 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -40,6 +40,12 @@ struct mlx5_ib_gsi_qp {
 	enum ib_sig_type sq_sig_type;
 	/* Serialize qp state modifications */
 	struct mutex mutex;
+	int num_qps;
+	/* Protects access to the tx_qps. Post send operations synchronize
+	 * with tx_qp creation in setup_qp().
+	 */
+	spinlock_t lock;
+	struct ib_qp **tx_qps;
 };
 
 static struct mlx5_ib_gsi_qp *gsi_qp(struct ib_qp *qp)
@@ -47,6 +53,11 @@ static struct mlx5_ib_gsi_qp *gsi_qp(struct ib_qp *qp)
 	return container_of(qp, struct mlx5_ib_gsi_qp, ibqp);
 }
 
+static bool mlx5_ib_deth_sqpn_cap(struct mlx5_ib_dev *dev)
+{
+	return MLX5_CAP_GEN(dev->mdev, set_deth_sqpn);
+}
+
 struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 				    struct ib_qp_init_attr *init_attr)
 {
@@ -54,6 +65,8 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 	struct mlx5_ib_gsi_qp *gsi;
 	struct ib_qp_init_attr hw_init_attr = *init_attr;
 	const u8 port_num = init_attr->port_num;
+	const int num_pkeys = pd->device->attrs.max_pkeys;
+	const int num_qps = mlx5_ib_deth_sqpn_cap(dev) ? num_pkeys : 0;
 	int ret;
 
 	mlx5_ib_dbg(dev, "creating GSI QP\n");
@@ -69,6 +82,12 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 	if (!gsi)
 		return ERR_PTR(-ENOMEM);
 
+	gsi->tx_qps = kcalloc(num_qps, sizeof(*gsi->tx_qps), GFP_KERNEL);
+	if (!gsi->tx_qps) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
 	mutex_init(&gsi->mutex);
 
 	mutex_lock(&dev->devr.mutex);
@@ -77,8 +96,10 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 		mlx5_ib_warn(dev, "GSI QP already exists on port %d\n",
 			     port_num);
 		ret = -EBUSY;
-		goto err_free;
+		goto err_free_tx;
 	}
+	gsi->num_qps = num_qps;
+	spin_lock_init(&gsi->lock);
 
 	gsi->cap = init_attr->cap;
 	gsi->sq_sig_type = init_attr->sq_sig_type;
@@ -91,7 +112,7 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 		mlx5_ib_warn(dev, "unable to create hardware GSI QP. error %ld\n",
 			     PTR_ERR(gsi->rx_qp));
 		ret = PTR_ERR(gsi->rx_qp);
-		goto err_free;
+		goto err_free_tx;
 	}
 
 	dev->devr.ports[init_attr->port_num - 1].gsi = gsi;
@@ -100,8 +121,10 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 
 	return &gsi->ibqp;
 
-err_free:
+err_free_tx:
 	mutex_unlock(&dev->devr.mutex);
+	kfree(gsi->tx_qps);
+err_free:
 	kfree(gsi);
 	return ERR_PTR(ret);
 }
@@ -111,6 +134,7 @@ int mlx5_ib_gsi_destroy_qp(struct ib_qp *qp)
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
 	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
 	const int port_num = gsi->port_num;
+	int qp_index;
 	int ret;
 
 	mlx5_ib_dbg(dev, "destroying GSI QP\n");
@@ -125,12 +149,143 @@ int mlx5_ib_gsi_destroy_qp(struct ib_qp *qp)
 	}
 	dev->devr.ports[port_num - 1].gsi = NULL;
 	mutex_unlock(&dev->devr.mutex);
+	gsi->rx_qp = NULL;
+
+	for (qp_index = 0; qp_index < gsi->num_qps; ++qp_index) {
+		if (!gsi->tx_qps[qp_index])
+			continue;
+		WARN_ON_ONCE(ib_destroy_qp(gsi->tx_qps[qp_index]));
+		gsi->tx_qps[qp_index] = NULL;
+	}
 
+	kfree(gsi->tx_qps);
 	kfree(gsi);
 
 	return 0;
 }
 
+static struct ib_qp *create_gsi_ud_qp(struct mlx5_ib_gsi_qp *gsi)
+{
+	struct ib_pd *pd = gsi->rx_qp->pd;
+	struct ib_qp_init_attr init_attr = {
+		.event_handler = gsi->rx_qp->event_handler,
+		.qp_context = gsi->rx_qp->qp_context,
+		.send_cq = gsi->rx_qp->send_cq,
+		.recv_cq = gsi->rx_qp->recv_cq,
+		.cap = {
+			.max_send_wr = gsi->cap.max_send_wr,
+			.max_send_sge = gsi->cap.max_send_sge,
+			.max_inline_data = gsi->cap.max_inline_data,
+		},
+		.sq_sig_type = gsi->sq_sig_type,
+		.qp_type = IB_QPT_UD,
+		.create_flags = mlx5_ib_create_qp_sqpn_qp1(),
+	};
+
+	return ib_create_qp(pd, &init_attr);
+}
+
+static int modify_to_rts(struct mlx5_ib_gsi_qp *gsi, struct ib_qp *qp,
+			 u16 qp_index)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct ib_qp_attr attr;
+	int mask;
+	int ret;
+
+	mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_QKEY | IB_QP_PORT;
+	attr.qp_state = IB_QPS_INIT;
+	attr.pkey_index = qp_index;
+	attr.qkey = IB_QP1_QKEY;
+	attr.port_num = gsi->port_num;
+	ret = ib_modify_qp(qp, &attr, mask);
+	if (ret) {
+		mlx5_ib_err(dev, "could not change QP%d state to INIT: %d\n",
+			    qp->qp_num, ret);
+		return ret;
+	}
+
+	attr.qp_state = IB_QPS_RTR;
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		mlx5_ib_err(dev, "could not change QP%d state to RTR: %d\n",
+			    qp->qp_num, ret);
+		return ret;
+	}
+
+	attr.qp_state = IB_QPS_RTS;
+	attr.sq_psn = 0;
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE | IB_QP_SQ_PSN);
+	if (ret) {
+		mlx5_ib_err(dev, "could not change QP%d state to RTS: %d\n",
+			    qp->qp_num, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
+{
+	struct ib_device *device = gsi->rx_qp->device;
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct ib_qp *qp;
+	unsigned long flags;
+	u16 pkey;
+	int ret;
+
+	ret = ib_query_pkey(device, gsi->port_num, qp_index, &pkey);
+	if (ret) {
+		mlx5_ib_warn(dev, "unable to read P_Key at port %d, index %d\n",
+			     gsi->port_num, qp_index);
+		return;
+	}
+
+	if (!pkey) {
+		mlx5_ib_dbg(dev, "invalid P_Key at port %d, index %d.  Skipping.\n",
+			    gsi->port_num, qp_index);
+		return;
+	}
+
+	spin_lock_irqsave(&gsi->lock, flags);
+	qp = gsi->tx_qps[qp_index];
+	spin_unlock_irqrestore(&gsi->lock, flags);
+	if (qp) {
+		mlx5_ib_dbg(dev, "already existing GSI TX QP at port %d, index %d. Skipping\n",
+			    gsi->port_num, qp_index);
+		return;
+	}
+
+	qp = create_gsi_ud_qp(gsi);
+	if (IS_ERR(qp)) {
+		mlx5_ib_warn(dev, "unable to create hardware UD QP for GSI: %ld\n",
+			     PTR_ERR(qp));
+		return;
+	}
+
+	ret = modify_to_rts(gsi, qp, qp_index);
+	if (ret)
+		goto err_destroy_qp;
+
+	spin_lock_irqsave(&gsi->lock, flags);
+	WARN_ON_ONCE(gsi->tx_qps[qp_index]);
+	gsi->tx_qps[qp_index] = qp;
+	spin_unlock_irqrestore(&gsi->lock, flags);
+
+	return;
+
+err_destroy_qp:
+	WARN_ON_ONCE(qp);
+}
+
+static void setup_qps(struct mlx5_ib_gsi_qp *gsi)
+{
+	u16 qp_index;
+
+	for (qp_index = 0; qp_index < gsi->num_qps; ++qp_index)
+		setup_qp(gsi, qp_index);
+}
+
 int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask)
 {
@@ -142,6 +297,15 @@ int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 
 	mutex_lock(&gsi->mutex);
 	ret = ib_modify_qp(gsi->rx_qp, attr, attr_mask);
+	if (ret) {
+		mlx5_ib_warn(dev, "unable to modify GSI rx QP: %d\n", ret);
+		goto unlock;
+	}
+
+	if (to_mqp(gsi->rx_qp)->state == IB_QPS_RTS)
+		setup_qps(gsi);
+
+unlock:
 	mutex_unlock(&gsi->mutex);
 
 	return ret;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
