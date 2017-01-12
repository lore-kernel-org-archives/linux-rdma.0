From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 14/26] IB/mlx4: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:06 -0800
Message-ID: <20170112190718.6728-15-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx4/cq.c  |  8 ++--
 drivers/infiniband/hw/mlx4/mad.c | 79 ++++++++++++++++++++--------------------
 drivers/infiniband/hw/mlx4/mr.c  |  8 ++--
 drivers/infiniband/hw/mlx4/qp.c  | 29 ++++++++-------
 4 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 6a0fec357dae..22b88c10e86d 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -584,10 +584,10 @@ static void use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct
 {
 	struct mlx4_ib_proxy_sqp_hdr *hdr;
 
-	ib_dma_sync_single_for_cpu(qp->ibqp.device,
-				   qp->sqp_proxy_rcv[tail].map,
-				   sizeof (struct mlx4_ib_proxy_sqp_hdr),
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(qp->ibqp.device->dma_device,
+				qp->sqp_proxy_rcv[tail].map,
+				sizeof(struct mlx4_ib_proxy_sqp_hdr),
+				DMA_FROM_DEVICE);
 	hdr = (struct mlx4_ib_proxy_sqp_hdr *) (qp->sqp_proxy_rcv[tail].addr);
 	wc->pkey_index	= be16_to_cpu(hdr->tun.pkey_index);
 	wc->src_qp	= be32_to_cpu(hdr->tun.flags_src_qp) & 0xFFFFFF;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index db564ccc0f92..b23a29bb29e9 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -582,10 +582,10 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (tun_qp->tx_ring[tun_tx_ix].ah)
 		ib_destroy_ah(tun_qp->tx_ring[tun_tx_ix].ah);
 	tun_qp->tx_ring[tun_tx_ix].ah = ah;
-	ib_dma_sync_single_for_cpu(&dev->ib_dev,
-				   tun_qp->tx_ring[tun_tx_ix].buf.map,
-				   sizeof (struct mlx4_rcv_tunnel_mad),
-				   DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->ib_dev.dma_device,
+				tun_qp->tx_ring[tun_tx_ix].buf.map,
+				sizeof(struct mlx4_rcv_tunnel_mad),
+				DMA_TO_DEVICE);
 
 	/* copy over to tunnel buffer */
 	if (grh)
@@ -624,10 +624,10 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16(wc->slid);
 	}
 
-	ib_dma_sync_single_for_device(&dev->ib_dev,
-				      tun_qp->tx_ring[tun_tx_ix].buf.map,
-				      sizeof (struct mlx4_rcv_tunnel_mad),
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->ib_dev.dma_device,
+				   tun_qp->tx_ring[tun_tx_ix].buf.map,
+				   sizeof(struct mlx4_rcv_tunnel_mad),
+				   DMA_TO_DEVICE);
 
 	list.addr = tun_qp->tx_ring[tun_tx_ix].buf.map;
 	list.length = sizeof (struct mlx4_rcv_tunnel_mad);
@@ -1321,8 +1321,8 @@ static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_demux_pv_ctx *ctx,
 	recv_wr.num_sge = 1;
 	recv_wr.wr_id = (u64) index | MLX4_TUN_WRID_RECV |
 		MLX4_TUN_SET_WRID_QPN(tun_qp->proxy_qpt);
-	ib_dma_sync_single_for_device(ctx->ib_dev, tun_qp->ring[index].map,
-				      size, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ctx->ib_dev->dma_device, tun_qp->ring[index].map,
+				   size, DMA_FROM_DEVICE);
 	return ib_post_recv(tun_qp->qp, &recv_wr, &bad_recv_wr);
 }
 
@@ -1412,17 +1412,17 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (sqp->tx_ring[wire_tx_ix].ah)
 		ib_destroy_ah(sqp->tx_ring[wire_tx_ix].ah);
 	sqp->tx_ring[wire_tx_ix].ah = ah;
-	ib_dma_sync_single_for_cpu(&dev->ib_dev,
-				   sqp->tx_ring[wire_tx_ix].buf.map,
-				   sizeof (struct mlx4_mad_snd_buf),
-				   DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->ib_dev.dma_device,
+				sqp->tx_ring[wire_tx_ix].buf.map,
+				sizeof(struct mlx4_mad_snd_buf),
+				DMA_TO_DEVICE);
 
 	memcpy(&sqp_mad->payload, mad, sizeof *mad);
 
-	ib_dma_sync_single_for_device(&dev->ib_dev,
-				      sqp->tx_ring[wire_tx_ix].buf.map,
-				      sizeof (struct mlx4_mad_snd_buf),
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->ib_dev.dma_device,
+				   sqp->tx_ring[wire_tx_ix].buf.map,
+				   sizeof(struct mlx4_mad_snd_buf),
+				   DMA_TO_DEVICE);
 
 	list.addr = sqp->tx_ring[wire_tx_ix].buf.map;
 	list.length = sizeof (struct mlx4_mad_snd_buf);
@@ -1504,9 +1504,10 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 	}
 
 	/* Map transaction ID */
-	ib_dma_sync_single_for_cpu(ctx->ib_dev, tun_qp->ring[wr_ix].map,
-				   sizeof (struct mlx4_tunnel_mad),
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ctx->ib_dev->dma_device,
+				tun_qp->ring[wr_ix].map,
+				sizeof(struct mlx4_tunnel_mad),
+				DMA_FROM_DEVICE);
 	switch (tunnel->mad.mad_hdr.method) {
 	case IB_MGMT_METHOD_SET:
 	case IB_MGMT_METHOD_GET:
@@ -1627,11 +1628,11 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 		tun_qp->ring[i].addr = kmalloc(rx_buf_size, GFP_KERNEL);
 		if (!tun_qp->ring[i].addr)
 			goto err;
-		tun_qp->ring[i].map = ib_dma_map_single(ctx->ib_dev,
-							tun_qp->ring[i].addr,
-							rx_buf_size,
-							DMA_FROM_DEVICE);
-		if (ib_dma_mapping_error(ctx->ib_dev, tun_qp->ring[i].map)) {
+		tun_qp->ring[i].map = dma_map_single(ctx->ib_dev->dma_device,
+						     tun_qp->ring[i].addr,
+						     rx_buf_size,
+						     DMA_FROM_DEVICE);
+		if (dma_mapping_error(ctx->ib_dev->dma_device, tun_qp->ring[i].map)) {
 			kfree(tun_qp->ring[i].addr);
 			goto err;
 		}
@@ -1643,11 +1644,10 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 		if (!tun_qp->tx_ring[i].buf.addr)
 			goto tx_err;
 		tun_qp->tx_ring[i].buf.map =
-			ib_dma_map_single(ctx->ib_dev,
-					  tun_qp->tx_ring[i].buf.addr,
-					  tx_buf_size,
-					  DMA_TO_DEVICE);
-		if (ib_dma_mapping_error(ctx->ib_dev,
+			dma_map_single(ctx->ib_dev->dma_device,
+				       tun_qp->tx_ring[i].buf.addr,
+				       tx_buf_size, DMA_TO_DEVICE);
+		if (dma_mapping_error(ctx->ib_dev->dma_device,
 					 tun_qp->tx_ring[i].buf.map)) {
 			kfree(tun_qp->tx_ring[i].buf.addr);
 			goto tx_err;
@@ -1664,8 +1664,9 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 tx_err:
 	while (i > 0) {
 		--i;
-		ib_dma_unmap_single(ctx->ib_dev, tun_qp->tx_ring[i].buf.map,
-				    tx_buf_size, DMA_TO_DEVICE);
+		dma_unmap_single(ctx->ib_dev->dma_device,
+				 tun_qp->tx_ring[i].buf.map,
+				 tx_buf_size, DMA_TO_DEVICE);
 		kfree(tun_qp->tx_ring[i].buf.addr);
 	}
 	kfree(tun_qp->tx_ring);
@@ -1674,8 +1675,8 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 err:
 	while (i > 0) {
 		--i;
-		ib_dma_unmap_single(ctx->ib_dev, tun_qp->ring[i].map,
-				    rx_buf_size, DMA_FROM_DEVICE);
+		dma_unmap_single(ctx->ib_dev->dma_device, tun_qp->ring[i].map,
+				 rx_buf_size, DMA_FROM_DEVICE);
 		kfree(tun_qp->ring[i].addr);
 	}
 	kfree(tun_qp->ring);
@@ -1704,14 +1705,14 @@ static void mlx4_ib_free_pv_qp_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 
 
 	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
-		ib_dma_unmap_single(ctx->ib_dev, tun_qp->ring[i].map,
-				    rx_buf_size, DMA_FROM_DEVICE);
+		dma_unmap_single(ctx->ib_dev->dma_device, tun_qp->ring[i].map,
+				 rx_buf_size, DMA_FROM_DEVICE);
 		kfree(tun_qp->ring[i].addr);
 	}
 
 	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
-		ib_dma_unmap_single(ctx->ib_dev, tun_qp->tx_ring[i].buf.map,
-				    tx_buf_size, DMA_TO_DEVICE);
+		dma_unmap_single(ctx->ib_dev->dma_device, tun_qp->tx_ring[i].buf.map,
+				 tx_buf_size, DMA_TO_DEVICE);
 		kfree(tun_qp->tx_ring[i].buf.addr);
 		if (tun_qp->tx_ring[i].ah)
 			ib_destroy_ah(tun_qp->tx_ring[i].ah);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 5d73989d9771..00d08e6b3b09 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -538,13 +538,13 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 
 	mr->npages = 0;
 
-	ib_dma_sync_single_for_cpu(ibmr->device, mr->page_map,
-				   mr->page_map_size, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(ibmr->device->dma_device, mr->page_map,
+				mr->page_map_size, DMA_TO_DEVICE);
 
 	rc = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
 
-	ib_dma_sync_single_for_device(ibmr->device, mr->page_map,
-				      mr->page_map_size, DMA_TO_DEVICE);
+	dma_sync_single_for_device(ibmr->device->dma_device, mr->page_map,
+				   mr->page_map_size, DMA_TO_DEVICE);
 
 	return rc;
 }
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c068add8838b..a8f4e4d37e4f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -570,10 +570,11 @@ static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 		if (!qp->sqp_proxy_rcv[i].addr)
 			goto err;
 		qp->sqp_proxy_rcv[i].map =
-			ib_dma_map_single(dev, qp->sqp_proxy_rcv[i].addr,
-					  sizeof (struct mlx4_ib_proxy_sqp_hdr),
-					  DMA_FROM_DEVICE);
-		if (ib_dma_mapping_error(dev, qp->sqp_proxy_rcv[i].map)) {
+			dma_map_single(dev->dma_device,
+				       qp->sqp_proxy_rcv[i].addr,
+				       sizeof (struct mlx4_ib_proxy_sqp_hdr),
+				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev->dma_device, qp->sqp_proxy_rcv[i].map)) {
 			kfree(qp->sqp_proxy_rcv[i].addr);
 			goto err;
 		}
@@ -583,9 +584,9 @@ static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 err:
 	while (i > 0) {
 		--i;
-		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
-				    sizeof (struct mlx4_ib_proxy_sqp_hdr),
-				    DMA_FROM_DEVICE);
+		dma_unmap_single(dev->dma_device, qp->sqp_proxy_rcv[i].map,
+				 sizeof (struct mlx4_ib_proxy_sqp_hdr),
+				 DMA_FROM_DEVICE);
 		kfree(qp->sqp_proxy_rcv[i].addr);
 	}
 	kfree(qp->sqp_proxy_rcv);
@@ -598,9 +599,9 @@ static void free_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 	int i;
 
 	for (i = 0; i < qp->rq.wqe_cnt; i++) {
-		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
-				    sizeof (struct mlx4_ib_proxy_sqp_hdr),
-				    DMA_FROM_DEVICE);
+		dma_unmap_single(dev->dma_device, qp->sqp_proxy_rcv[i].map,
+				 sizeof (struct mlx4_ib_proxy_sqp_hdr),
+				 DMA_FROM_DEVICE);
 		kfree(qp->sqp_proxy_rcv[i].addr);
 	}
 	kfree(qp->sqp_proxy_rcv);
@@ -3306,10 +3307,10 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
 		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI)) {
-			ib_dma_sync_single_for_device(ibqp->device,
-						      qp->sqp_proxy_rcv[ind].map,
-						      sizeof (struct mlx4_ib_proxy_sqp_hdr),
-						      DMA_FROM_DEVICE);
+			dma_sync_single_for_device(ibqp->device->dma_device,
+						   qp->sqp_proxy_rcv[ind].map,
+						   sizeof(struct mlx4_ib_proxy_sqp_hdr),
+						   DMA_FROM_DEVICE);
 			scat->byte_count =
 				cpu_to_be32(sizeof (struct mlx4_ib_proxy_sqp_hdr));
 			/* use dma lkey from upper layer entry */
-- 
2.11.0
