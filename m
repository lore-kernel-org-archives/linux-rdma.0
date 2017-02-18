From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 10/29] IB/mlx4: Enclose 15 expressions for the sizeof operator
 by parentheses
Date: Sat, 18 Feb 2017 21:58:39 +0100
Message-ID: <c535767b-0cbd-e8e6-e7b0-f2b05cfd05e5@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 18 Feb 2017 09:54:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 860fec8b9601..b26817f0669f 100644
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
@@ -1136,11 +1136,11 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
 		return;
 
-	in_mad  = kmalloc(sizeof *in_mad, GFP_KERNEL);
+	in_mad  = kmalloc(sizeof(*in_mad), GFP_KERNEL);
 	if (!in_mad)
 		return;
 
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof(*out_mad), GFP_KERNEL);
 	if (!out_mad)
 		goto free_in_mad;
 
@@ -1149,8 +1149,8 @@ static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
 	for (i = 0; i < 4; i++) {
 		if (change_bitmap && (!((change_bitmap >> (8 * i)) & 0xff)))
 			continue;
-		memset(in_mad, 0, sizeof *in_mad);
-		memset(out_mad, 0, sizeof *out_mad);
+		memset(in_mad, 0, sizeof(*in_mad));
+		memset(out_mad, 0, sizeof(*out_mad));
 
 		in_mad->base_version  = 1;
 		in_mad->mgmt_class    = IB_MGMT_CLASS_SUBN_LID_ROUTED;
@@ -1421,7 +1421,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 				   sizeof (struct mlx4_mad_snd_buf),
 				   DMA_TO_DEVICE);
 
-	memcpy(&sqp_mad->payload, mad, sizeof *mad);
+	memcpy(&sqp_mad->payload, mad, sizeof(*mad));
 
 	ib_dma_sync_single_for_device(&dev->ib_dev,
 				      sqp->tx_ring[wire_tx_ix].buf.map,
@@ -1804,7 +1804,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 
 	tun_qp = &ctx->qp[qp_type];
 
-	memset(&qp_init_attr, 0, sizeof qp_init_attr);
+	memset(&qp_init_attr, 0, sizeof(qp_init_attr));
 	qp_init_attr.init_attr.send_cq = ctx->cq;
 	qp_init_attr.init_attr.recv_cq = ctx->cq;
 	qp_init_attr.init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
@@ -1837,7 +1837,7 @@ static int create_pv_sqp(struct mlx4_ib_demux_pv_ctx *ctx,
 		return ret;
 	}
 
-	memset(&attr, 0, sizeof attr);
+	memset(&attr, 0, sizeof(attr));
 	attr.qp_state = IB_QPS_INIT;
 	ret = 0;
 	if (create_tun)
@@ -2184,7 +2184,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_mcg;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibt%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibt%d", port);
 	ctx->wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->wq) {
 		pr_err("Failed to create tunnelling WQ for port %d\n", port);
@@ -2192,7 +2192,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_wq;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibud%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibud%d", port);
 	ctx->ud_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->ud_wq) {
 		pr_err("Failed to create up/down WQ for port %d\n", port);
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
