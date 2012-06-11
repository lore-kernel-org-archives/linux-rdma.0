From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 15/29] IB/mlx4: Initialize SRIOV IB support for slaves in master context
Date: Mon, 11 Jun 2012 13:45:56 +0300
Message-ID: <1339411570-4689-16-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allocate sriov paravirtualization resources and mad demuxing contexts
on the master.

This has two parts.  The first part is to initialize the structures
to contain the contexts.  This is done at master startup time
(mlx4_ib_init_sriov).

The second part is to actually create the tunneling resources required
on the master to support a slave.  This is performed the master detects
that a slave has started up (MLX4_DEV_EVENT_SLAVE_INIT event generated
when a slave initializes its comm channel).

For the master, there is no such startup event, so it creates its own
tunneling resources when it starts up.  In addition, the master also
creates the real special QPs. (The ib_core layer on the master causes
creation of proxy special qp's, since the master is also
paravirtualized at the ib_core layer).

Note: in V1, we plan to modify the slave_num macro defined here
to be usable in mlx4_core as well.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c         |  683 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/main.c        |   80 ++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h     |   39 ++
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    3 +
 include/linux/mlx4/device.h              |    3 +-
 include/linux/mlx4/driver.h              |    2 +
 6 files changed, 802 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d633faf..365521d 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -44,6 +44,35 @@ enum {
 	MLX4_IB_VENDOR_CLASS2 = 0xa
 };
 
+#define MLX4_TUN_SEND_WRID_SHIFT 34
+#define MLX4_TUN_QPN_SHIFT 32
+#define MLX4_TUN_WRID_RECV (((u64) 1) << MLX4_TUN_SEND_WRID_SHIFT)
+#define MLX4_TUN_SET_WRID_QPN(a) (((u64) ((a) & 0x3)) << MLX4_TUN_QPN_SHIFT)
+
+#define MLX4_TUN_IS_RECV(a)  (((a) >>  MLX4_TUN_SEND_WRID_SHIFT) & 0x1)
+#define MLX4_TUN_WRID_QPN(a) (((a) >> MLX4_TUN_QPN_SHIFT) & 0x3)
+
+struct mlx4_mad_rcv_buf {
+	struct ib_grh grh;
+	u8 payload[256];
+} __packed;
+
+struct mlx4_mad_snd_buf {
+	u8 payload[256];
+} __packed;
+
+struct mlx4_tunnel_mad {
+	struct ib_grh grh;
+	struct mlx4_ib_tunnel_header hdr;
+	struct ib_mad mad;
+} __packed;
+
+struct mlx4_rcv_tunnel_mad {
+	struct mlx4_rcv_tunnel_hdr hdr;
+	struct ib_grh grh;
+	struct ib_mad mad;
+} __packed;
+
 static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num);
 static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num);
 
@@ -560,3 +589,657 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 
 	kfree(ew);
 }
+
+static void mlx4_ib_tunnel_comp_handler(struct ib_cq *cq, void *arg)
+{
+	unsigned long flags;
+	struct mlx4_ib_demux_pv_ctx *ctx = cq->cq_context;
+	struct mlx4_ib_dev *dev = to_mdev(ctx->ib_dev);
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	if (!dev->sriov.is_going_down && ctx->state == DEMUX_PV_STATE_ACTIVE)
+		queue_work(ctx->wq, &ctx->work);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+}
+
+static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_demux_pv_ctx *ctx,
+				  struct mlx4_ib_demux_pv_qp *tun_qp,
+				  int index)
+{
+	struct ib_sge sg_list;
+	struct ib_recv_wr recv_wr, *bad_recv_wr;
+	int size;
+
+	size = (tun_qp->qp->qp_type == IB_QPT_UD) ?
+		sizeof(struct mlx4_tunnel_mad) : sizeof(struct mlx4_mad_rcv_buf);
+
+	sg_list.addr = tun_qp->ring[index].map;
+	sg_list.length = size;
+	sg_list.lkey = ctx->mr->lkey;
+
+	recv_wr.next = NULL;
+	recv_wr.sg_list = &sg_list;
+	recv_wr.num_sge = 1;
+	recv_wr.wr_id = (u64) index | MLX4_TUN_WRID_RECV |
+		MLX4_TUN_SET_WRID_QPN(tun_qp->proxy_qpt);
+	ib_dma_sync_single_for_device(ctx->ib_dev, tun_qp->ring[index].map,
+				      size, DMA_FROM_DEVICE);
+	return ib_post_recv(tun_qp->qp, &recv_wr, &bad_recv_wr);
+}
+
+static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
+				 enum ib_qp_type qp_type, int is_tun)
+{
+	int i;
+	struct mlx4_ib_demux_pv_qp *tun_qp;
+	int rx_buf_size, tx_buf_size;
+
+	if (qp_type > IB_QPT_GSI)
+		return -EINVAL;
+
+	tun_qp = &ctx->qp[qp_type];
+
+	tun_qp->ring = kzalloc(sizeof(struct mlx4_ib_buf) * MLX4_NUM_TUNNEL_BUFS,
+			       GFP_KERNEL);
+	if (!tun_qp->ring)
+		return -ENOMEM;
+
+	tun_qp->tx_ring = kzalloc(sizeof(struct mlx4_ib_tun_tx_buf) *
+				  MLX4_NUM_TUNNEL_BUFS,
+				  GFP_KERNEL);
+	if (!tun_qp->tx_ring) {
+		kfree(tun_qp->ring);
+		tun_qp->ring = NULL;
+		return -ENOMEM;
+	}
+
+	if (is_tun) {
+		rx_buf_size = sizeof(struct mlx4_tunnel_mad);
+		tx_buf_size = sizeof(struct mlx4_rcv_tunnel_mad);
+	} else {
+		rx_buf_size = sizeof(struct mlx4_mad_rcv_buf);
+		tx_buf_size = sizeof(struct mlx4_mad_snd_buf);
+	}
+
+	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
+		tun_qp->ring[i].addr = kmalloc(rx_buf_size, GFP_KERNEL);
+		if (!tun_qp->ring[i].addr)
+			goto err;
+		tun_qp->ring[i].map = ib_dma_map_single(ctx->ib_dev,
+							tun_qp->ring[i].addr,
+							rx_buf_size,
+							DMA_FROM_DEVICE);
+	}
+
+	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
+		tun_qp->tx_ring[i].buf.addr =
+			kmalloc(tx_buf_size, GFP_KERNEL);
+		if (!tun_qp->tx_ring[i].buf.addr)
+			goto tx_err;
+		tun_qp->tx_ring[i].buf.map =
+			ib_dma_map_single(ctx->ib_dev,
+					  tun_qp->tx_ring[i].buf.addr,
+					  tx_buf_size,
+					  DMA_TO_DEVICE);
+		tun_qp->tx_ring[i].ah = NULL;
+	}
+	spin_lock_init(&tun_qp->tx_lock);
+	tun_qp->tx_ix_head = 0;
+	tun_qp->tx_ix_tail = 0;
+	tun_qp->proxy_qpt = qp_type;
+
+	return 0;
+
+tx_err:
+	while (i > 0) {
+		--i;
+		ib_dma_unmap_single(ctx->ib_dev, tun_qp->tx_ring[i].buf.map,
+				    tx_buf_size, DMA_TO_DEVICE);
+		kfree(tun_qp->tx_ring[i].buf.addr);
+	}
+	kfree(tun_qp->tx_ring);
+	tun_qp->tx_ring = NULL;
+	i = MLX4_NUM_TUNNEL_BUFS;
+err:
+	while (i > 0) {
+		--i;
+		ib_dma_unmap_single(ctx->ib_dev, tun_qp->ring[i].map,
+				    rx_buf_size, DMA_FROM_DEVICE);
+		kfree(tun_qp->ring[i].addr);
+	}
+	kfree(tun_qp->ring);
+	tun_qp->ring = NULL;
+	return -ENOMEM;
+}
+
+static void mlx4_ib_free_pv_qp_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
+				     enum ib_qp_type qp_type, int is_tun)
+{
+	int i;
+	struct mlx4_ib_demux_pv_qp *tun_qp;
+	int rx_buf_size, tx_buf_size;
+
+	if (qp_type > IB_QPT_GSI)
+		return;
+
+	tun_qp = &ctx->qp[qp_type];
+	if (is_tun) {
+		rx_buf_size = sizeof(struct mlx4_tunnel_mad);
+		tx_buf_size = sizeof(struct mlx4_rcv_tunnel_mad);
+	} else {
+		rx_buf_size = sizeof(struct mlx4_mad_rcv_buf);
+		tx_buf_size = sizeof(struct mlx4_mad_snd_buf);
+	}
+
+
+	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
+		ib_dma_unmap_single(ctx->ib_dev, tun_qp->ring[i].map,
+				    rx_buf_size, DMA_FROM_DEVICE);
+		kfree(tun_qp->ring[i].addr);
+	}
+
+	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
+		ib_dma_unmap_single(ctx->ib_dev, tun_qp->tx_ring[i].buf.map,
+				    tx_buf_size, DMA_TO_DEVICE);
+		kfree(tun_qp->tx_ring[i].buf.addr);
+		if (tun_qp->tx_ring[i].ah)
+			ib_destroy_ah(tun_qp->tx_ring[i].ah);
+	}
+	kfree(tun_qp->tx_ring);
+	kfree(tun_qp->ring);
+}
+
+static void mlx4_ib_tunnel_comp_worker(struct work_struct *work)
+{
+	/* dummy until next patch in series */
+}
+
+static void pv_qp_event_handler(struct ib_event *event, void *qp_context)
+{
+	struct mlx4_ib_demux_pv_ctx *sqp = qp_context;
+
+	/* It's worse than that! He's dead, Jim! */
+	pr_err("Fatal error (%d) on a MAD QP on port %d\n",
+	       event->event, sqp->port);
+}
+
+static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
+			    enum ib_qp_type qp_type, int create_tun)
+{
+	int i, ret;
+	struct mlx4_ib_demux_pv_qp *tun_qp;
+	struct mlx4_ib_qp_tunnel_init_attr qp_init_attr;
+	struct ib_qp_attr attr;
+	int qp_attr_mask_INIT;
+
+	if (qp_type > IB_QPT_GSI)
+		return -EINVAL;
+
+	tun_qp = &ctx->qp[qp_type];
+
+	memset(&qp_init_attr, 0, sizeof qp_init_attr);
+	qp_init_attr.init_attr.send_cq = ctx->cq;
+	qp_init_attr.init_attr.recv_cq = ctx->cq;
+	qp_init_attr.init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
+	qp_init_attr.init_attr.cap.max_send_wr = MLX4_NUM_TUNNEL_BUFS;
+	qp_init_attr.init_attr.cap.max_recv_wr = MLX4_NUM_TUNNEL_BUFS;
+	qp_init_attr.init_attr.cap.max_send_sge = 1;
+	qp_init_attr.init_attr.cap.max_recv_sge = 1;
+	if (create_tun) {
+		qp_init_attr.init_attr.qp_type = IB_QPT_UD;
+		qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
+		qp_init_attr.port = ctx->port;
+		qp_init_attr.slave = ctx->slave;
+		qp_init_attr.proxy_qp_type = qp_type;
+		qp_attr_mask_INIT = IB_QP_STATE | IB_QP_PKEY_INDEX |
+			   IB_QP_QKEY | IB_QP_PORT;
+	} else {
+		qp_init_attr.init_attr.qp_type = qp_type;
+		qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
+		qp_attr_mask_INIT = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_QKEY;
+	}
+	qp_init_attr.init_attr.port_num = ctx->port;
+	qp_init_attr.init_attr.qp_context = ctx;
+	qp_init_attr.init_attr.event_handler = pv_qp_event_handler;
+	tun_qp->qp = ib_create_qp(ctx->pd, &qp_init_attr.init_attr);
+	if (IS_ERR(tun_qp->qp)) {
+		ret = PTR_ERR(tun_qp->qp);
+		tun_qp->qp = NULL;
+		pr_err("Couldn't create %s QP (%d)\n",
+		       create_tun ? "tunnel" : "special", ret);
+		return ret;
+	}
+
+	memset(&attr, 0, sizeof attr);
+	attr.qp_state = IB_QPS_INIT;
+	attr.pkey_index =
+		to_mdev(ctx->ib_dev)->pkeys.virt2phys_pkey[ctx->slave][ctx->port - 1][0];
+	attr.qkey = IB_QP1_QKEY;
+	attr.port_num = ctx->port;
+	ret = ib_modify_qp(tun_qp->qp, &attr, qp_attr_mask_INIT);
+	if (ret) {
+		pr_err("Couldn't change %s qp state to INIT (%d)\n",
+		       create_tun ? "tunnel" : "special", ret);
+		goto err_qp;
+	}
+	attr.qp_state = IB_QPS_RTR;
+	ret = ib_modify_qp(tun_qp->qp, &attr, IB_QP_STATE);
+	if (ret) {
+		pr_err("Couldn't change %s qp state to RTR (%d)\n",
+		       create_tun ? "tunnel" : "special", ret);
+		goto err_qp;
+	}
+	attr.qp_state = IB_QPS_RTS;
+	attr.sq_psn = 0;
+	ret = ib_modify_qp(tun_qp->qp, &attr, IB_QP_STATE | IB_QP_SQ_PSN);
+	if (ret) {
+		pr_err("Couldn't change %s qp state to RTS (%d)\n",
+		       create_tun ? "tunnel" : "special", ret);
+		goto err_qp;
+	}
+
+	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
+		ret = mlx4_ib_post_pv_qp_buf(ctx, tun_qp, i);
+		if (ret) {
+			pr_err(" mlx4_ib_post_pv_buf error"
+			       " (err = %d, i = %d)\n", ret, i);
+			goto err_qp;
+		}
+	}
+	return 0;
+
+err_qp:
+	ib_destroy_qp(tun_qp->qp);
+	tun_qp->qp = NULL;
+	return ret;
+}
+
+/*
+ * IB MAD completion callback for real SQPs
+ */
+static void mlx4_ib_sqp_comp_worker(struct work_struct *work)
+{
+	/* dummy until next patch in series */
+}
+
+static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int port,
+			       struct mlx4_ib_demux_pv_ctx **ret_ctx)
+{
+	struct mlx4_ib_demux_pv_ctx *ctx;
+
+	*ret_ctx = NULL;
+	ctx = kzalloc(sizeof(struct mlx4_ib_demux_pv_ctx), GFP_KERNEL);
+	if (!ctx) {
+		pr_err("failed allocating pv resource context "
+		       "for port %d, slave %d\n", port, slave);
+		return -ENOMEM;
+	}
+
+	ctx->ib_dev = &dev->ib_dev;
+	ctx->port = port;
+	ctx->slave = slave;
+	*ret_ctx = ctx;
+	return 0;
+}
+
+static void free_pv_object(struct mlx4_ib_dev *dev, int slave, int port)
+{
+	if (dev->sriov.demux[port - 1].tun[slave]) {
+		kfree(dev->sriov.demux[port - 1].tun[slave]);
+		dev->sriov.demux[port - 1].tun[slave] = NULL;
+	}
+}
+
+static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
+			       int create_tun, struct mlx4_ib_demux_pv_ctx *ctx)
+{
+	int ret, cq_size;
+
+	ctx->state = DEMUX_PV_STATE_STARTING;
+	/* have QP0 only on port owner, and only if link layer is IB */
+	if (ctx->slave == slave_num(to_mdev(ctx->ib_dev)) &&
+	    rdma_port_get_link_layer(ibdev, ctx->port) == IB_LINK_LAYER_INFINIBAND)
+		ctx->has_smi = 1;
+
+	if (ctx->has_smi) {
+		ret = mlx4_ib_alloc_pv_bufs(ctx, IB_QPT_SMI, create_tun);
+		if (ret) {
+			pr_err("Failed allocating qp0 tunnel bufs (%d)\n", ret);
+			goto err_out;
+		}
+	}
+
+	ret = mlx4_ib_alloc_pv_bufs(ctx, IB_QPT_GSI, create_tun);
+	if (ret) {
+		pr_err("Failed allocating qp1 tunnel bufs (%d)\n", ret);
+		goto err_out_qp0;
+	}
+
+	cq_size = 2 * MLX4_NUM_TUNNEL_BUFS;
+	if (ctx->has_smi)
+		cq_size *= 2;
+
+	ctx->cq = ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler,
+			       NULL, ctx, cq_size, 0);
+	if (IS_ERR(ctx->cq)) {
+		ret = PTR_ERR(ctx->cq);
+		pr_err("Couldn't create tunnel CQ (%d)\n", ret);
+		goto err_buf;
+	}
+
+	ctx->pd = ib_alloc_pd(ctx->ib_dev);
+	if (IS_ERR(ctx->pd)) {
+		ret = PTR_ERR(ctx->pd);
+		pr_err("Couldn't create tunnel PD (%d)\n", ret);
+		goto err_cq;
+	}
+
+	ctx->mr = ib_get_dma_mr(ctx->pd, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(ctx->mr)) {
+		ret = PTR_ERR(ctx->mr);
+		pr_err("Couldn't get tunnel DMA MR (%d)\n", ret);
+		goto err_pd;
+	}
+
+	if (ctx->has_smi) {
+		ret = create_pv_sqp(ctx, IB_QPT_SMI, create_tun);
+		if (ret) {
+			pr_err("Couldn't create %s QP0 (%d)\n",
+			       create_tun ? "tunnel for" : "",  ret);
+			goto err_mr;
+		}
+	}
+
+	ret = create_pv_sqp(ctx, IB_QPT_GSI, create_tun);
+	if (ret) {
+		pr_err("Couldn't create %s QP1 (%d)\n",
+		       create_tun ? "tunnel for" : "",  ret);
+		goto err_qp0;
+	}
+
+	if (create_tun)
+		INIT_WORK(&ctx->work, mlx4_ib_tunnel_comp_worker);
+	else
+		INIT_WORK(&ctx->work, mlx4_ib_sqp_comp_worker);
+
+	ctx->wq = to_mdev(ibdev)->sriov.demux[port - 1].wq;
+
+	ret = ib_req_notify_cq(ctx->cq, IB_CQ_NEXT_COMP);
+	if (ret) {
+		pr_err("Couldn't arm tunnel cq (%d)\n", ret);
+		goto err_wq;
+	}
+	ctx->state = DEMUX_PV_STATE_ACTIVE;
+	return 0;
+
+err_wq:
+	ctx->wq = NULL;
+	ib_destroy_qp(ctx->qp[1].qp);
+	ctx->qp[1].qp = NULL;
+
+
+err_qp0:
+	if (ctx->has_smi)
+		ib_destroy_qp(ctx->qp[0].qp);
+	ctx->qp[0].qp = NULL;
+
+err_mr:
+	ib_dereg_mr(ctx->mr);
+	ctx->mr = NULL;
+
+err_pd:
+	ib_dealloc_pd(ctx->pd);
+	ctx->pd = NULL;
+
+err_cq:
+	ib_destroy_cq(ctx->cq);
+	ctx->cq = NULL;
+
+err_buf:
+	mlx4_ib_free_pv_qp_bufs(ctx, IB_QPT_GSI, create_tun);
+
+err_out_qp0:
+	if (ctx->has_smi)
+		mlx4_ib_free_pv_qp_bufs(ctx, IB_QPT_SMI, create_tun);
+err_out:
+	ctx->state = DEMUX_PV_STATE_DOWN;
+	return ret;
+}
+
+static void destroy_pv_resources(struct mlx4_ib_dev *dev, int slave, int port,
+				 struct mlx4_ib_demux_pv_ctx *ctx, int flush)
+{
+	if (!ctx)
+		return;
+	if (ctx->state > DEMUX_PV_STATE_DOWN) {
+		ctx->state = DEMUX_PV_STATE_DOWNING;
+		if (flush)
+			flush_workqueue(ctx->wq);
+		if (ctx->has_smi) {
+			ib_destroy_qp(ctx->qp[0].qp);
+			ctx->qp[0].qp = NULL;
+			mlx4_ib_free_pv_qp_bufs(ctx, IB_QPT_SMI, 1);
+		}
+		ib_destroy_qp(ctx->qp[1].qp);
+		ctx->qp[1].qp = NULL;
+		mlx4_ib_free_pv_qp_bufs(ctx, IB_QPT_GSI, 1);
+		ib_dereg_mr(ctx->mr);
+		ctx->mr = NULL;
+		ib_dealloc_pd(ctx->pd);
+		ctx->pd = NULL;
+		ib_destroy_cq(ctx->cq);
+		ctx->cq = NULL;
+		ctx->state = DEMUX_PV_STATE_DOWN;
+	}
+}
+
+static int mlx4_ib_tunnels_update(struct mlx4_ib_dev *dev, int slave,
+				  int port, int do_init)
+{
+	int ret = 0;
+
+	if (!do_init) {
+		/* for master, destroy real sqp resources */
+		if (slave == slave_num(dev))
+			destroy_pv_resources(dev, slave, port,
+					     dev->sriov.sqps[port - 1], 1);
+		/* destroy the tunnel qp resources */
+		destroy_pv_resources(dev, slave, port,
+				     dev->sriov.demux[port - 1].tun[slave], 1);
+		return 0;
+	}
+
+	/* create the tunnel qp resources */
+	ret = create_pv_resources(&dev->ib_dev, slave, port, 1,
+				  dev->sriov.demux[port - 1].tun[slave]);
+
+	/* for master, create the real sqp resources */
+	if (!ret && slave == slave_num(dev))
+		ret = create_pv_resources(&dev->ib_dev, slave, port, 0,
+					  dev->sriov.sqps[port - 1]);
+	return ret;
+}
+
+void mlx4_ib_tunnels_update_work(struct work_struct *work)
+{
+	struct mlx4_ib_demux_work *dmxw;
+
+	dmxw = container_of(work, struct mlx4_ib_demux_work, work);
+	mlx4_ib_tunnels_update(dmxw->dev, dmxw->slave, (int) dmxw->port,
+			       dmxw->do_init);
+	kfree(dmxw);
+	return;
+}
+
+static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
+				       struct mlx4_ib_demux_ctx *ctx,
+				       int port)
+{
+	char name[12];
+	int ret = 0;
+	int i;
+
+	ctx->tun = kzalloc(dev->dev->caps.sqp_demux *
+			   sizeof(struct mlx4_ib_demux_pv_ctx *), GFP_KERNEL);
+	if (!ctx->tun)
+		return -ENOMEM;
+
+	ctx->dev = dev;
+	ctx->port = port;
+	ctx->ib_dev = &dev->ib_dev;
+
+	for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
+		ret = alloc_pv_object(dev, i, port, &ctx->tun[i]);
+		if (ret) {
+			ret = -ENOMEM;
+			goto err_wq;
+		}
+	}
+
+	snprintf(name, sizeof name, "mlx4_ibt%d", port);
+	ctx->wq = create_singlethread_workqueue(name);
+	if (!ctx->wq) {
+		pr_err("Failed to create tunnelling WQ for port %d\n", port);
+		ret = -ENOMEM;
+		goto err_wq;
+	}
+
+	snprintf(name, sizeof name, "mlx4_ibud%d", port);
+	ctx->ud_wq = create_singlethread_workqueue(name);
+	if (!ctx->ud_wq) {
+		pr_err("Failed to create up/down WQ for port %d\n", port);
+		ret = -ENOMEM;
+		goto err_udwq;
+	}
+
+	return 0;
+
+err_udwq:
+	destroy_workqueue(ctx->wq);
+	ctx->wq = NULL;
+
+err_wq:
+	for (i = 0; i < dev->dev->caps.sqp_demux; i++)
+		free_pv_object(dev, i, port);
+	kfree(ctx->tun);
+	ctx->tun = NULL;
+	return ret;
+}
+
+static void mlx4_ib_free_sqp_ctx(struct mlx4_ib_demux_pv_ctx *sqp_ctx)
+{
+	if (sqp_ctx->state > DEMUX_PV_STATE_DOWN) {
+		sqp_ctx->state = DEMUX_PV_STATE_DOWNING;
+		flush_workqueue(sqp_ctx->wq);
+		if (sqp_ctx->has_smi) {
+			ib_destroy_qp(sqp_ctx->qp[0].qp);
+			sqp_ctx->qp[0].qp = NULL;
+			mlx4_ib_free_pv_qp_bufs(sqp_ctx, IB_QPT_SMI, 0);
+		}
+		ib_destroy_qp(sqp_ctx->qp[1].qp);
+		sqp_ctx->qp[1].qp = NULL;
+		mlx4_ib_free_pv_qp_bufs(sqp_ctx, IB_QPT_GSI, 0);
+		ib_dereg_mr(sqp_ctx->mr);
+		sqp_ctx->mr = NULL;
+		ib_dealloc_pd(sqp_ctx->pd);
+		sqp_ctx->pd = NULL;
+		ib_destroy_cq(sqp_ctx->cq);
+		sqp_ctx->cq = NULL;
+		sqp_ctx->state = DEMUX_PV_STATE_DOWN;
+	}
+}
+
+static void mlx4_ib_free_demux_ctx(struct mlx4_ib_demux_ctx *ctx)
+{
+	int i;
+	if (ctx) {
+		struct mlx4_ib_dev *dev = to_mdev(ctx->ib_dev);
+		for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
+			if (!ctx->tun[i])
+				continue;
+			if (ctx->tun[i]->state > DEMUX_PV_STATE_DOWN)
+				ctx->tun[i]->state = DEMUX_PV_STATE_DOWNING;
+		}
+		flush_workqueue(ctx->wq);
+		for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
+			destroy_pv_resources(dev, i, ctx->port, ctx->tun[i], 0);
+			free_pv_object(dev, i, ctx->port);
+		}
+		kfree(ctx->tun);
+		destroy_workqueue(ctx->ud_wq);
+		destroy_workqueue(ctx->wq);
+	}
+}
+
+static void mlx4_ib_master_tunnels(struct mlx4_ib_dev *dev, int do_init)
+{
+	int i;
+
+	if (!mlx4_is_master(dev->dev))
+		return;
+	/* initialize or tear down tunnel QPs for the master */
+	for (i = 0; i < dev->dev->caps.num_ports; i++)
+		mlx4_ib_tunnels_update(dev, slave_num(dev), i + 1, do_init);
+	return;
+}
+
+int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
+{
+	int i = 0;
+	int err;
+
+	if (!mlx4_is_mfunc(dev->dev))
+		return 0;
+
+	dev->sriov.is_going_down = 0;
+	spin_lock_init(&dev->sriov.going_down_lock);
+
+	mlx4_ib_warn(&dev->ib_dev, "multi-function enabled\n");
+
+	if (!mlx4_is_master(dev->dev))
+		mlx4_ib_warn(&dev->ib_dev, "operating in qp1 tunnel mode\n");
+	else {
+		mlx4_ib_warn(&dev->ib_dev, "initializing demux service for %d qp1 clients\n",
+			     dev->dev->caps.sqp_demux);
+		for (i = 0; i < dev->num_ports; i++) {
+			err = alloc_pv_object(dev, slave_num(dev), i + 1,
+					      &dev->sriov.sqps[i]);
+			if (err)
+				goto demux_err;
+			err = mlx4_ib_alloc_demux_ctx(dev, &dev->sriov.demux[i], i + 1);
+			if (err)
+				goto demux_err;
+		}
+		mlx4_ib_master_tunnels(dev, 1);
+	}
+	return 0;
+
+demux_err:
+	while (i > 0) {
+		free_pv_object(dev, slave_num(dev), i + 1);
+		mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
+		--i;
+	}
+
+	return err;
+}
+
+void mlx4_ib_close_sriov(struct mlx4_ib_dev *dev)
+{
+	int i;
+	unsigned long flags;
+
+	if (!mlx4_is_mfunc(dev->dev))
+		return;
+
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	dev->sriov.is_going_down = 1;
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	if (mlx4_is_master(dev->dev))
+		for (i = 0; i < dev->num_ports; i++) {
+			flush_workqueue(dev->sriov.demux[i].ud_wq);
+			mlx4_ib_free_sqp_ctx(dev->sriov.sqps[i]);
+			kfree(dev->sriov.sqps[i]);
+			dev->sriov.sqps[i] = NULL;
+			mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
+		}
+}
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 443f357..66f28b6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1319,11 +1319,14 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
 
+	if (mlx4_ib_init_sriov(ibdev))
+		goto err_mad;
+
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE && !iboe->nb.notifier_call) {
 		iboe->nb.notifier_call = mlx4_ib_netdev_event;
 		err = register_netdevice_notifier(&iboe->nb);
 		if (err)
-			goto err_reg;
+			goto err_sriov;
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
@@ -1341,6 +1344,12 @@ err_notif:
 		pr_warn("failure unregistering notifier\n");
 	flush_workqueue(wq);
 
+err_sriov:
+	mlx4_ib_close_sriov(ibdev);
+
+err_mad:
+	mlx4_ib_mad_cleanup(ibdev);
+
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);
 
@@ -1369,6 +1378,7 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	struct mlx4_ib_dev *ibdev = ibdev_ptr;
 	int p;
 
+	mlx4_ib_close_sriov(ibdev);
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
 	if (ibdev->iboe.nb.notifier_call) {
@@ -1390,6 +1400,51 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	ib_dealloc_device(&ibdev->ib_dev);
 }
 
+static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
+{
+	struct mlx4_ib_demux_work **dm = NULL;
+	struct mlx4_dev *dev = ibdev->dev;
+	int i;
+	unsigned long flags;
+
+	if (!mlx4_is_master(dev))
+		return;
+
+	dm = kzalloc(sizeof(*dm) * dev->caps.num_ports, GFP_ATOMIC);
+	if (!dm) {
+		pr_err("failed to allocate memory for tunneling qp update\n");
+		goto out;
+	}
+
+	for (i = 0; i < dev->caps.num_ports; i++) {
+		dm[i] = kmalloc(sizeof(struct mlx4_ib_demux_work), GFP_ATOMIC);
+		if (!dm[i]) {
+			pr_err("failed to allocate memory for tunneling qp update work struct\n");
+			for (i = 0; i < dev->caps.num_ports; i++) {
+				if (dm[i])
+					kfree(dm[i]);
+			}
+			goto out;
+		}
+	}
+	/* initialize or tear down tunnel QPs for the slave */
+	for (i = 0; i < dev->caps.num_ports; i++) {
+		INIT_WORK(&dm[i]->work, mlx4_ib_tunnels_update_work);
+		dm[i]->port = i + 1;
+		dm[i]->slave = slave;
+		dm[i]->do_init = do_init;
+		dm[i]->dev = ibdev;
+		spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
+		if (!ibdev->sriov.is_going_down)
+			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
+		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
+	}
+out:
+	if (dm)
+		kfree(dm);
+	return;
+}
+
 static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 			  enum mlx4_dev_event event, unsigned long param)
 {
@@ -1397,22 +1452,23 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	struct mlx4_ib_dev *ibdev = to_mdev((struct ib_device *) ibdev_ptr);
 	struct mlx4_eqe *eqe = NULL;
 	struct ib_event_work *ew;
-	int port = 0;
+	int p = 0;
 
 	if (event == MLX4_DEV_EVENT_PORT_MGMT_CHANGE)
 		eqe = (struct mlx4_eqe *)param;
 	else
-		port = (u8)param;
-
-	if (port > ibdev->num_ports)
-		return;
+		p = (int) param;
 
 	switch (event) {
 	case MLX4_DEV_EVENT_PORT_UP:
+		if (p > ibdev->num_ports)
+			return;
 		ibev.event = IB_EVENT_PORT_ACTIVE;
 		break;
 
 	case MLX4_DEV_EVENT_PORT_DOWN:
+		if (p > ibdev->num_ports)
+			return;
 		ibev.event = IB_EVENT_PORT_ERR;
 		break;
 
@@ -1434,12 +1490,22 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 		handle_port_mgmt_change_event(&ew->work);
 		return;
 
+	case MLX4_DEV_EVENT_SLAVE_INIT:
+		/* here, p is the slave id */
+		do_slave_init(ibdev, p, 1);
+		return;
+
+	case MLX4_DEV_EVENT_SLAVE_SHUTDOWN:
+		/* here, p is the slave id */
+		do_slave_init(ibdev, p, 0);
+		return;
+
 	default:
 		return;
 	}
 
 	ibev.device	      = ibdev_ptr;
-	ibev.element.port_num = port;
+	ibev.element.port_num = (u8) p;
 
 	ib_dispatch_event(&ibev);
 }
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 3100f62..058881f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -184,6 +184,10 @@ enum mlx4_ib_qp_type {
 	MLX4_IB_QPT_TUN_GSI,
 };
 
+enum {
+	MLX4_NUM_TUNNEL_BUFS		= 256,
+};
+
 struct mlx4_ib_tunnel_header {
 	struct mlx4_av av;
 	__be32 remote_qpn;
@@ -265,6 +269,15 @@ struct mlx4_ib_ah {
 	union mlx4_ext_av       av;
 };
 
+struct mlx4_ib_demux_work {
+	struct work_struct	work;
+	struct mlx4_ib_dev     *dev;
+	int			slave;
+	int			do_init;
+	u8			port;
+
+};
+
 struct mlx4_ib_tun_tx_buf {
 	struct mlx4_ib_buf buf;
 	struct ib_ah *ah;
@@ -280,9 +293,17 @@ struct mlx4_ib_demux_pv_qp {
 	unsigned tx_ix_tail;
 };
 
+enum mlx4_ib_demux_pv_state {
+	DEMUX_PV_STATE_DOWN,
+	DEMUX_PV_STATE_STARTING,
+	DEMUX_PV_STATE_ACTIVE,
+	DEMUX_PV_STATE_DOWNING,
+};
+
 struct mlx4_ib_demux_pv_ctx {
 	int port;
 	int slave;
+	enum mlx4_ib_demux_pv_state state;
 	int has_smi;
 	struct ib_device *ib_dev;
 	struct ib_cq *cq;
@@ -322,6 +343,13 @@ struct mlx4_ib_iboe {
 	union ib_gid		gid_table[MLX4_MAX_PORTS][128];
 };
 
+struct pkey_mgt {
+	u8			virt2phys_pkey[MLX4_MFUNC_MAX][MLX4_MAX_PORTS][MLX4_MAX_PORT_PKEYS];
+	u16			phys_pkey_cache[MLX4_MAX_PORTS][MLX4_MAX_PORT_PKEYS];
+	struct list_head	pkey_port_list[MLX4_MFUNC_MAX];
+	struct kobject	       *device_parent[MLX4_MFUNC_MAX];
+};
+
 struct mlx4_ib_dev {
 	struct ib_device	ib_dev;
 	struct mlx4_dev	       *dev;
@@ -343,6 +371,7 @@ struct mlx4_ib_dev {
 	int			counters[MLX4_MAX_PORTS];
 	int		       *eq_table;
 	int			eq_added;
+	struct pkey_mgt		pkeys;
 };
 
 struct ib_event_work {
@@ -358,6 +387,11 @@ struct mlx4_ib_qp_tunnel_init_attr {
 	u8 port;
 };
 
+static inline int slave_num(struct mlx4_ib_dev *dev)
+{
+	return dev->dev->caps.function;
+}
+
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
@@ -427,6 +461,9 @@ static inline struct mlx4_ib_ah *to_mah(struct ib_ah *ibah)
 	return container_of(ibah, struct mlx4_ib_ah, ibah);
 }
 
+int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev);
+void mlx4_ib_close_sriov(struct mlx4_ib_dev *dev);
+
 int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
 			struct mlx4_db *db);
 void mlx4_ib_db_unmap_user(struct mlx4_ib_ucontext *context, struct mlx4_db *db);
@@ -515,4 +552,6 @@ static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 		   union ib_gid *gid);
 
+void mlx4_ib_tunnels_update_work(struct work_struct *work);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 842c8ce..fc5e701 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1276,6 +1276,8 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 		if (MLX4_COMM_CMD_FLR == slave_state[slave].last_cmd)
 			goto inform_slave_state;
 
+		mlx4_dispatch_event(dev, MLX4_DEV_EVENT_SLAVE_SHUTDOWN, slave);
+
 		/* write the version in the event field */
 		reply |= mlx4_comm_get_version();
 
@@ -1312,6 +1314,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 			goto reset_slave;
 		slave_state[slave].vhcr_dma |= param;
 		slave_state[slave].active = true;
+		mlx4_dispatch_event(dev, MLX4_DEV_EVENT_SLAVE_INIT, slave);
 		break;
 	case MLX4_COMM_CMD_VHCR_POST:
 		if ((slave_state[slave].last_cmd != MLX4_COMM_CMD_VHCR_EN) &&
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 73c0bb9..fd53a26 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -53,7 +53,8 @@ enum {
 };
 
 enum {
-	MLX4_MAX_PORTS		= 2
+	MLX4_MAX_PORTS		= 2,
+	MLX4_MAX_PORT_PKEYS	= 128
 };
 
 /* base qkey for use in sriov tunnel-qp/proxy-qp communication.
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 0f50922..86160f3 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -43,6 +43,8 @@ enum mlx4_dev_event {
 	MLX4_DEV_EVENT_PORT_DOWN,
 	MLX4_DEV_EVENT_PORT_REINIT,
 	MLX4_DEV_EVENT_PORT_MGMT_CHANGE,
+	MLX4_DEV_EVENT_SLAVE_INIT,
+	MLX4_DEV_EVENT_SLAVE_SHUTDOWN,
 };
 
 struct mlx4_interface {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
