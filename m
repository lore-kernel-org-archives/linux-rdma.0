From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 08/17] IB/mlx4: Enclose 46 expressions for sizeof by
 parentheses
Date: Fri, 21 Apr 2017 20:38:59 +0200
Message-ID: <85d70370-773f-f194-d7d5-e20632494ef7@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 15:27:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/mlx4/mad.c  | 30 +++++++++++++++---------------
 drivers/infiniband/hw/mlx4/main.c | 35 +++++++++++++++++------------------
 drivers/infiniband/hw/mlx4/qp.c   | 31 ++++++++++++++++---------------
 3 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 0a5b46791335..41461aeb7c5e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -195,7 +195,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 	if (!dev->send_agent[port_num - 1][0])
 		return;
 
-	memset(&ah_attr, 0, sizeof ah_attr);
+	memset(&ah_attr, 0, sizeof(ah_attr));
 	ah_attr.dlid     = lid;
 	ah_attr.sl       = sl;
 	ah_attr.port_num = port_num;
@@ -400,7 +400,7 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, const struct ib_m
 		 * it's OK for our devices).
 		 */
 		spin_lock_irqsave(&dev->sm_lock, flags);
-		memcpy(send_buf->mad, mad, sizeof *mad);
+		memcpy(send_buf->mad, mad, sizeof(*mad));
 		send_buf->ah = dev->sm_ah[port_num - 1];
 		if (send_buf->ah)
 			ret = ib_post_send_mad(send_buf, NULL);
@@ -555,7 +555,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	/* create ah. Just need an empty one with the port num for the post send.
 	 * The driver will set the force loopback bit in post_send */
-	memset(&attr, 0, sizeof attr);
+	memset(&attr, 0, sizeof(attr));
 	attr.port_num = port;
 	if (is_eth) {
 		union ib_gid sgid;
@@ -590,8 +590,8 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 	/* copy over to tunnel buffer */
 	if (grh)
-		memcpy(&tun_mad->grh, grh, sizeof *grh);
-	memcpy(&tun_mad->mad, mad, sizeof *mad);
+		memcpy(&tun_mad->grh, grh, sizeof(*grh));
+	memcpy(&tun_mad->mad, mad, sizeof(*mad));
 
 	/* adjust tunnel data */
 	tun_mad->hdr.pkey_index = cpu_to_be16(tun_pkey_ix);
@@ -961,7 +961,7 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	}
 	mutex_unlock(&dev->counters_table[port_num - 1].mutex);
 	if (stats_avail) {
-		memset(out_mad->data, 0, sizeof out_mad->data);
+		memset(out_mad->data, 0, sizeof(out_mad->data));
 		switch (counter_stats.counter_mode & 0xf) {
 		case 0:
 			edit_counter(&counter_stats,
@@ -1136,8 +1136,8 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
 		return;
 
-	in_mad  = kmalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kmalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -1146,8 +1146,8 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	for (i = 0; i < 4; i++) {
 		if (change_bitmap && (!((change_bitmap >> (8 * i)) & 0xff)))
 			continue;
-		memset(in_mad, 0, sizeof *in_mad);
-		memset(out_mad, 0, sizeof *out_mad);
+		memset(in_mad, 0, sizeof(*in_mad));
+		memset(out_mad, 0, sizeof(*out_mad));
 
 		in_mad->base_version  = 1;
 		in_mad->mgmt_class    = IB_MGMT_CLASS_SUBN_LID_ROUTED;
@@ -1417,7 +1417,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 				   sizeof (struct mlx4_mad_snd_buf),
 				   DMA_TO_DEVICE);
 
-	memcpy(&sqp_mad->payload, mad, sizeof *mad);
+	memcpy(&sqp_mad->payload, mad, sizeof(*mad));
 
 	ib_dma_sync_single_for_device(&dev->ib_dev,
 				      sqp->tx_ring[wire_tx_ix].buf.map,
@@ -1800,7 +1800,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 
 	tun_qp = &ctx->qp[qp_type];
 
-	memset(&qp_init_attr, 0, sizeof qp_init_attr);
+	memset(&qp_init_attr, 0, sizeof(qp_init_attr));
 	qp_init_attr.init_attr.send_cq = ctx->cq;
 	qp_init_attr.init_attr.recv_cq = ctx->cq;
 	qp_init_attr.init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
@@ -1833,7 +1833,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 		return ret;
 	}
 
-	memset(&attr, 0, sizeof attr);
+	memset(&attr, 0, sizeof(attr));
 	attr.qp_state = IB_QPS_INIT;
 	ret = 0;
 	if (create_tun)
@@ -2180,7 +2180,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_mcg;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibt%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibt%d", port);
 	ctx->wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->wq) {
 		pr_err("Failed to create tunnelling WQ for port %d\n", port);
@@ -2188,7 +2188,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_wq;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibud%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibud%d", port);
 	ctx->ud_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->ud_wq) {
 		pr_err("Failed to create up/down WQ for port %d\n", port);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 232f556b1121..8f0e37c4f381 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -460,8 +460,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	resp.response_length = offsetof(typeof(resp), response_length) +
 		sizeof(resp.response_length);
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!in_mad || !out_mad)
 		goto out;
@@ -474,8 +474,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	if (err)
 		goto out;
 
-	memset(props, 0, sizeof *props);
-
+	memset(props, 0, sizeof(*props));
 	have_ib_ports = num_ib_ports(dev->dev);
 
 	props->fw_ver = dev->dev->caps.fw_ver;
@@ -598,8 +597,8 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -774,8 +773,8 @@ int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	int clear = 0;
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -911,8 +910,8 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -1283,7 +1282,7 @@ static struct ib_pd *mlx4_ib_alloc_pd(struct ib_device *ibdev,
 	struct mlx4_ib_pd *pd;
 	int err;
 
-	pd = kmalloc(sizeof *pd, GFP_KERNEL);
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1322,7 +1321,7 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 	if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
 		return ERR_PTR(-ENOSYS);
 
-	xrcd = kmalloc(sizeof *xrcd, GFP_KERNEL);
+	xrcd = kmalloc(sizeof(*xrcd), GFP_KERNEL);
 	if (!xrcd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1370,7 +1369,7 @@ static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_ib_gid_entry *ge;
 
-	ge = kzalloc(sizeof *ge, GFP_KERNEL);
+	ge = kzalloc(sizeof(*ge), GFP_KERNEL);
 	if (!ge)
 		return -ENOMEM;
 
@@ -2092,8 +2091,8 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	in_mad  = kzalloc(sizeof(*in_mad), GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!in_mad || !out_mad)
 		goto out;
 
@@ -2603,7 +2602,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (num_ports == 0)
 		return NULL;
 
-	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof *ibdev);
+	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof(*ibdev));
 	if (!ibdev) {
 		dev_err(&dev->persist->pdev->dev,
 			"Device struct alloc failed\n");
@@ -3302,12 +3301,12 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 		break;
 
 	case MLX4_DEV_EVENT_PORT_MGMT_CHANGE:
-		ew = kmalloc(sizeof *ew, GFP_ATOMIC);
+		ew = kmalloc(sizeof(*ew), GFP_ATOMIC);
 		if (!ew)
 			break;
 
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
-		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
+		memcpy(&ew->ib_eqe, eqe, sizeof(*eqe));
 		ew->ib_dev = ibdev;
 		/* need to queue only for port owner, which uses GEN_EQE */
 		if (mlx4_is_master(dev))
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9269cd503443..c2a0f75d7d07 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -247,9 +247,10 @@ static void post_nop_wqe(struct mlx4_ib_qp *qp, int n, int size)
 	s = sizeof(struct mlx4_wqe_ctrl_seg);
 
 	if (qp->ibqp.qp_type == IB_QPT_UD) {
-		struct mlx4_wqe_datagram_seg *dgram = wqe + sizeof *ctrl;
+		struct mlx4_wqe_datagram_seg *dgram = wqe + sizeof(*ctrl);
 		struct mlx4_av *av = (struct mlx4_av *)dgram->av;
-		memset(dgram, 0, sizeof *dgram);
+
+		memset(dgram, 0, sizeof(*dgram));
 		av->port_pd = cpu_to_be32((qp->port << 24) | to_mpd(qp->ibqp.pd)->pdn);
 		s += sizeof(struct mlx4_wqe_datagram_seg);
 	}
@@ -257,7 +258,8 @@ static void post_nop_wqe(struct mlx4_ib_qp *qp, int n, int size)
 	/* Pad the remainder of the WQE with an inline data segment. */
 	if (size > s) {
 		inl = wqe + s;
-		inl->byte_count = cpu_to_be32(1 << 31 | (size - s - sizeof *inl));
+		inl->byte_count = cpu_to_be32(1 << 31
+					      | (size - s - sizeof(*inl)));
 	}
 	ctrl->srcrb_flags = 0;
 	ctrl->qpn_vlan.fence_size = size / 16;
@@ -726,7 +728,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (pd->uobject) {
 		struct mlx4_ib_create_qp ucmd;
 
-		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
 			err = -EFAULT;
 			goto err;
 		}
@@ -1179,7 +1181,7 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_RAW_PACKET:
-		qp = kzalloc(sizeof *qp, gfp);
+		qp = kzalloc(sizeof(*qp), gfp);
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
 		qp->pri.vid = 0xFFFF;
@@ -1634,7 +1636,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	    IB_LINK_LAYER_ETHERNET)
 		return -ENOTSUPP;
 
-	context = kzalloc(sizeof *context, GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -2298,7 +2300,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	struct mlx4_ib_dev *mdev = to_mdev(sqp->qp.ibqp.device);
 	struct ib_device *ib_dev = &mdev->ib_dev;
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
-	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof(*mlx);
 	struct mlx4_ib_ah *ah = to_mah(wr->ah);
 	u16 pkey;
 	u32 qkey;
@@ -2447,7 +2449,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	struct mlx4_ib_dev *ibdev = to_mdev(ib_dev);
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
 	struct mlx4_wqe_ctrl_seg *ctrl = wqe;
-	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof(*mlx);
 	struct mlx4_ib_ah *ah = to_mah(wr->ah);
 	union ib_gid sgid;
 	u16 pkey;
@@ -2820,7 +2822,7 @@ static void build_tunnel_header(struct ib_ud_wr *wr, void *wqe, unsigned *mlx_se
 	int spc;
 	int i;
 
-	memcpy(&hdr.av, &ah->av, sizeof hdr.av);
+	memcpy(&hdr.av, &ah->av, sizeof(hdr.av));
 	hdr.remote_qpn = cpu_to_be32(wr->remote_qpn);
 	hdr.pkey_index = cpu_to_be16(wr->pkey_index);
 	hdr.qkey = cpu_to_be32(wr->remote_qkey);
@@ -2899,7 +2901,7 @@ static int build_lso_seg(struct mlx4_wqe_lso_seg *wqe, struct ib_ud_wr *wr,
 			 struct mlx4_ib_qp *qp, unsigned *lso_seg_len,
 			 __be32 *lso_hdr_sz, __be32 *blh)
 {
-	unsigned halign = ALIGN(sizeof *wqe + wr->hlen, 16);
+	unsigned int halign = ALIGN(sizeof(*wqe) + wr->hlen, 16);
 
 	if (unlikely(halign > MLX4_IB_CACHE_LINE_SIZE))
 		*blh = cpu_to_be32(1 << 6);
@@ -3017,9 +3019,8 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			qp->sq_signal_bits;
 
 		ctrl->imm = send_ieth(wr);
-
-		wqe += sizeof *ctrl;
-		size = sizeof *ctrl / 16;
+		wqe += sizeof(*ctrl);
+		size = sizeof(*ctrl) / 16;
 
 		switch (qp->mlx4_ib_qp_type) {
 		case MLX4_IB_QPT_RC:
@@ -3400,7 +3401,7 @@ static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 	struct mlx4_dev *dev = ibdev->dev;
 	int is_eth;
 
-	memset(ib_ah_attr, 0, sizeof *ib_ah_attr);
+	memset(ib_ah_attr, 0, sizeof(*ib_ah_attr));
 	ib_ah_attr->port_num	  = path->sched_queue & 0x40 ? 2 : 1;
 
 	if (ib_ah_attr->port_num == 0 || ib_ah_attr->port_num > dev->caps.num_ports)
@@ -3426,7 +3427,7 @@ static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 		ib_ah_attr->grh.flow_label =
 			be32_to_cpu(path->tclass_flowlabel) & 0xfffff;
 		memcpy(ib_ah_attr->grh.dgid.raw,
-			path->rgid, sizeof ib_ah_attr->grh.dgid.raw);
+			path->rgid, sizeof(ib_ah_attr->grh.dgid.raw));
 	}
 }
 
-- 
2.12.2
