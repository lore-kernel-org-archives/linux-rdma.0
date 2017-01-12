From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 24/26] net/rds: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:16 -0800
Message-ID: <20170112190718.6728-25-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/ib.h      | 39 ---------------------------------------
 net/rds/ib_cm.c   | 42 ++++++++++++++++++++++--------------------
 net/rds/ib_fmr.c  | 10 +++++-----
 net/rds/ib_frmr.c | 12 ++++++------
 net/rds/ib_rdma.c | 13 ++++++-------
 net/rds/ib_recv.c | 19 +++++++++----------
 net/rds/ib_send.c | 50 +++++++++++++++++++++++++-------------------------
 7 files changed, 73 insertions(+), 112 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index d21ca88ab628..02e5fe8d6af8 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -275,45 +275,6 @@ struct rds_ib_statistics {
 
 extern struct workqueue_struct *rds_ib_wq;
 
-/*
- * Fake ib_dma_sync_sg_for_{cpu,device} as long as ib_verbs.h
- * doesn't define it.
- */
-static inline void rds_ib_dma_sync_sg_for_cpu(struct ib_device *dev,
-					      struct scatterlist *sglist,
-					      unsigned int sg_dma_len,
-					      int direction)
-{
-	struct scatterlist *sg;
-	unsigned int i;
-
-	for_each_sg(sglist, sg, sg_dma_len, i) {
-		ib_dma_sync_single_for_cpu(dev,
-				ib_sg_dma_address(dev, sg),
-				ib_sg_dma_len(dev, sg),
-				direction);
-	}
-}
-#define ib_dma_sync_sg_for_cpu	rds_ib_dma_sync_sg_for_cpu
-
-static inline void rds_ib_dma_sync_sg_for_device(struct ib_device *dev,
-						 struct scatterlist *sglist,
-						 unsigned int sg_dma_len,
-						 int direction)
-{
-	struct scatterlist *sg;
-	unsigned int i;
-
-	for_each_sg(sglist, sg, sg_dma_len, i) {
-		ib_dma_sync_single_for_device(dev,
-				ib_sg_dma_address(dev, sg),
-				ib_sg_dma_len(dev, sg),
-				direction);
-	}
-}
-#define ib_dma_sync_sg_for_device	rds_ib_dma_sync_sg_for_device
-
-
 /* ib.c */
 extern struct rds_transport rds_ib_transport;
 struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 5b2ab95afa07..a6d3726ea27d 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -456,31 +456,32 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto out;
 	}
 
-	ic->i_send_hdrs = ib_dma_alloc_coherent(dev,
-					   ic->i_send_ring.w_nr *
+	ic->i_send_hdrs = dma_alloc_coherent(dev->dma_device,
+					     ic->i_send_ring.w_nr *
 						sizeof(struct rds_header),
-					   &ic->i_send_hdrs_dma, GFP_KERNEL);
+					     &ic->i_send_hdrs_dma, GFP_KERNEL);
 	if (!ic->i_send_hdrs) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent send failed\n");
+		rdsdebug("dma_alloc_coherent send failed\n");
 		goto out;
 	}
 
-	ic->i_recv_hdrs = ib_dma_alloc_coherent(dev,
-					   ic->i_recv_ring.w_nr *
+	ic->i_recv_hdrs = dma_alloc_coherent(dev->dma_device,
+					     ic->i_recv_ring.w_nr *
 						sizeof(struct rds_header),
-					   &ic->i_recv_hdrs_dma, GFP_KERNEL);
+					     &ic->i_recv_hdrs_dma, GFP_KERNEL);
 	if (!ic->i_recv_hdrs) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent recv failed\n");
+		rdsdebug("dma_alloc_coherent recv failed\n");
 		goto out;
 	}
 
-	ic->i_ack = ib_dma_alloc_coherent(dev, sizeof(struct rds_header),
+	ic->i_ack = dma_alloc_coherent(dev->dma_device,
+				       sizeof(struct rds_header),
 				       &ic->i_ack_dma, GFP_KERNEL);
 	if (!ic->i_ack) {
 		ret = -ENOMEM;
-		rdsdebug("ib_dma_alloc_coherent ack failed\n");
+		rdsdebug("dma_alloc_coherent ack failed\n");
 		goto out;
 	}
 
@@ -781,22 +782,23 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 
 		/* then free the resources that ib callbacks use */
 		if (ic->i_send_hdrs)
-			ib_dma_free_coherent(dev,
-					   ic->i_send_ring.w_nr *
+			dma_free_coherent(dev->dma_device,
+					  ic->i_send_ring.w_nr *
 						sizeof(struct rds_header),
-					   ic->i_send_hdrs,
-					   ic->i_send_hdrs_dma);
+					  ic->i_send_hdrs,
+					  ic->i_send_hdrs_dma);
 
 		if (ic->i_recv_hdrs)
-			ib_dma_free_coherent(dev,
-					   ic->i_recv_ring.w_nr *
+			dma_free_coherent(dev->dma_device,
+					  ic->i_recv_ring.w_nr *
 						sizeof(struct rds_header),
-					   ic->i_recv_hdrs,
-					   ic->i_recv_hdrs_dma);
+					  ic->i_recv_hdrs,
+					  ic->i_recv_hdrs_dma);
 
 		if (ic->i_ack)
-			ib_dma_free_coherent(dev, sizeof(struct rds_header),
-					     ic->i_ack, ic->i_ack_dma);
+			dma_free_coherent(dev->dma_device,
+					  sizeof(struct rds_header),
+					  ic->i_ack, ic->i_ack_dma);
 
 		if (ic->i_sends)
 			rds_ib_send_clear_ring(ic);
diff --git a/net/rds/ib_fmr.c b/net/rds/ib_fmr.c
index 4fe8f4fec4ee..150e8f756bd9 100644
--- a/net/rds/ib_fmr.c
+++ b/net/rds/ib_fmr.c
@@ -100,7 +100,7 @@ int rds_ib_map_fmr(struct rds_ib_device *rds_ibdev, struct rds_ib_mr *ibmr,
 	int i, j;
 	int ret;
 
-	sg_dma_len = ib_dma_map_sg(dev, sg, nents, DMA_BIDIRECTIONAL);
+	sg_dma_len = dma_map_sg(dev->dma_device, sg, nents, DMA_BIDIRECTIONAL);
 	if (unlikely(!sg_dma_len)) {
 		pr_warn("RDS/IB: %s failed!\n", __func__);
 		return -EBUSY;
@@ -110,8 +110,8 @@ int rds_ib_map_fmr(struct rds_ib_device *rds_ibdev, struct rds_ib_mr *ibmr,
 	page_cnt = 0;
 
 	for (i = 0; i < sg_dma_len; ++i) {
-		unsigned int dma_len = ib_sg_dma_len(dev, &scat[i]);
-		u64 dma_addr = ib_sg_dma_address(dev, &scat[i]);
+		unsigned int dma_len = sg_dma_len(&scat[i]);
+		u64 dma_addr = sg_dma_address(&scat[i]);
 
 		if (dma_addr & ~PAGE_MASK) {
 			if (i > 0)
@@ -140,8 +140,8 @@ int rds_ib_map_fmr(struct rds_ib_device *rds_ibdev, struct rds_ib_mr *ibmr,
 
 	page_cnt = 0;
 	for (i = 0; i < sg_dma_len; ++i) {
-		unsigned int dma_len = ib_sg_dma_len(dev, &scat[i]);
-		u64 dma_addr = ib_sg_dma_address(dev, &scat[i]);
+		unsigned int dma_len = sg_dma_len(&scat[i]);
+		u64 dma_addr = sg_dma_address(&scat[i]);
 
 		for (j = 0; j < dma_len; j += PAGE_SIZE)
 			dma_pages[page_cnt++] =
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index d921adc62765..2d44bf11d97f 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -169,8 +169,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 	ibmr->sg_dma_len = 0;
 	frmr->sg_byte_len = 0;
 	WARN_ON(ibmr->sg_dma_len);
-	ibmr->sg_dma_len = ib_dma_map_sg(dev, ibmr->sg, ibmr->sg_len,
-					 DMA_BIDIRECTIONAL);
+	ibmr->sg_dma_len = dma_map_sg(dev->dma_device, ibmr->sg, ibmr->sg_len,
+				      DMA_BIDIRECTIONAL);
 	if (unlikely(!ibmr->sg_dma_len)) {
 		pr_warn("RDS/IB: %s failed!\n", __func__);
 		return -EBUSY;
@@ -182,8 +182,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 
 	ret = -EINVAL;
 	for (i = 0; i < ibmr->sg_dma_len; ++i) {
-		unsigned int dma_len = ib_sg_dma_len(dev, &ibmr->sg[i]);
-		u64 dma_addr = ib_sg_dma_address(dev, &ibmr->sg[i]);
+		unsigned int dma_len = sg_dma_len(&ibmr->sg[i]);
+		u64 dma_addr = sg_dma_address(&ibmr->sg[i]);
 
 		frmr->sg_byte_len += dma_len;
 		if (dma_addr & ~PAGE_MASK) {
@@ -221,8 +221,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 	return ret;
 
 out_unmap:
-	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
-			DMA_BIDIRECTIONAL);
+	dma_unmap_sg(rds_ibdev->dev->dma_device, ibmr->sg, ibmr->sg_len,
+		     DMA_BIDIRECTIONAL);
 	ibmr->sg_dma_len = 0;
 	return ret;
 }
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 977f69886c00..9f5acba71a05 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -221,12 +221,12 @@ void rds_ib_sync_mr(void *trans_private, int direction)
 
 	switch (direction) {
 	case DMA_FROM_DEVICE:
-		ib_dma_sync_sg_for_cpu(rds_ibdev->dev, ibmr->sg,
-			ibmr->sg_dma_len, DMA_BIDIRECTIONAL);
+		dma_sync_sg_for_cpu(rds_ibdev->dev->dma_device, ibmr->sg,
+				    ibmr->sg_dma_len, DMA_BIDIRECTIONAL);
 		break;
 	case DMA_TO_DEVICE:
-		ib_dma_sync_sg_for_device(rds_ibdev->dev, ibmr->sg,
-			ibmr->sg_dma_len, DMA_BIDIRECTIONAL);
+		dma_sync_sg_for_device(rds_ibdev->dev->dma_device, ibmr->sg,
+				       ibmr->sg_dma_len, DMA_BIDIRECTIONAL);
 		break;
 	}
 }
@@ -236,9 +236,8 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 	struct rds_ib_device *rds_ibdev = ibmr->device;
 
 	if (ibmr->sg_dma_len) {
-		ib_dma_unmap_sg(rds_ibdev->dev,
-				ibmr->sg, ibmr->sg_len,
-				DMA_BIDIRECTIONAL);
+		dma_unmap_sg(rds_ibdev->dev->dma_device, ibmr->sg, ibmr->sg_len,
+			     DMA_BIDIRECTIONAL);
 		ibmr->sg_dma_len = 0;
 	}
 
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 606a11f681d2..32bc2df27e5a 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -225,7 +225,8 @@ static void rds_ib_recv_clear_one(struct rds_ib_connection *ic,
 		recv->r_ibinc = NULL;
 	}
 	if (recv->r_frag) {
-		ib_dma_unmap_sg(ic->i_cm_id->device, &recv->r_frag->f_sg, 1, DMA_FROM_DEVICE);
+		dma_unmap_sg(ic->i_cm_id->device->dma_device,
+			     &recv->r_frag->f_sg, 1, DMA_FROM_DEVICE);
 		rds_ib_frag_free(ic, recv->r_frag);
 		recv->r_frag = NULL;
 	}
@@ -331,8 +332,8 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 	if (!recv->r_frag)
 		goto out;
 
-	ret = ib_dma_map_sg(ic->i_cm_id->device, &recv->r_frag->f_sg,
-			    1, DMA_FROM_DEVICE);
+	ret = dma_map_sg(ic->i_cm_id->device->dma_device, &recv->r_frag->f_sg,
+			 1, DMA_FROM_DEVICE);
 	WARN_ON(ret != 1);
 
 	sge = &recv->r_sge[0];
@@ -340,8 +341,8 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 	sge->length = sizeof(struct rds_header);
 
 	sge = &recv->r_sge[1];
-	sge->addr = ib_sg_dma_address(ic->i_cm_id->device, &recv->r_frag->f_sg);
-	sge->length = ib_sg_dma_len(ic->i_cm_id->device, &recv->r_frag->f_sg);
+	sge->addr = sg_dma_address(&recv->r_frag->f_sg);
+	sge->length = sg_dma_len(&recv->r_frag->f_sg);
 
 	ret = 0;
 out:
@@ -408,9 +409,7 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 		ret = ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, &failed_wr);
 		rdsdebug("recv %p ibinc %p page %p addr %lu ret %d\n", recv,
 			 recv->r_ibinc, sg_page(&recv->r_frag->f_sg),
-			 (long) ib_sg_dma_address(
-				ic->i_cm_id->device,
-				&recv->r_frag->f_sg),
+			 (long)sg_dma_address(&recv->r_frag->f_sg),
 			ret);
 		if (ret) {
 			rds_ib_conn_error(conn, "recv post on "
@@ -968,8 +967,8 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connection *ic,
 
 	rds_ib_stats_inc(s_ib_rx_cq_event);
 	recv = &ic->i_recvs[rds_ib_ring_oldest(&ic->i_recv_ring)];
-	ib_dma_unmap_sg(ic->i_cm_id->device, &recv->r_frag->f_sg, 1,
-			DMA_FROM_DEVICE);
+	dma_unmap_sg(ic->i_cm_id->device->dma_device, &recv->r_frag->f_sg, 1,
+		     DMA_FROM_DEVICE);
 
 	/* Also process recvs in connecting state because it is possible
 	 * to get a recv completion _before_ the rdmacm ESTABLISHED
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 84d90c97332f..aa79b6aa488e 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -74,9 +74,8 @@ static void rds_ib_send_unmap_data(struct rds_ib_connection *ic,
 				   int wc_status)
 {
 	if (op->op_nents)
-		ib_dma_unmap_sg(ic->i_cm_id->device,
-				op->op_sg, op->op_nents,
-				DMA_TO_DEVICE);
+		dma_unmap_sg(ic->i_cm_id->device->dma_device, op->op_sg,
+			     op->op_nents, DMA_TO_DEVICE);
 }
 
 static void rds_ib_send_unmap_rdma(struct rds_ib_connection *ic,
@@ -84,9 +83,9 @@ static void rds_ib_send_unmap_rdma(struct rds_ib_connection *ic,
 				   int wc_status)
 {
 	if (op->op_mapped) {
-		ib_dma_unmap_sg(ic->i_cm_id->device,
-				op->op_sg, op->op_nents,
-				op->op_write ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		dma_unmap_sg(ic->i_cm_id->device->dma_device, op->op_sg,
+			     op->op_nents, op->op_write ? DMA_TO_DEVICE :
+			     DMA_FROM_DEVICE);
 		op->op_mapped = 0;
 	}
 
@@ -106,7 +105,7 @@ static void rds_ib_send_unmap_rdma(struct rds_ib_connection *ic,
 	 * handling in the ACK processing code.
 	 *
 	 * Note: There's no need to explicitly sync any RDMA buffers using
-	 * ib_dma_sync_sg_for_cpu - the completion for the RDMA
+	 * dma_sync_sg_for_cpu - the completion for the RDMA
 	 * operation itself unmapped the RDMA buffers, which takes care
 	 * of synching.
 	 */
@@ -125,8 +124,8 @@ static void rds_ib_send_unmap_atomic(struct rds_ib_connection *ic,
 {
 	/* unmap atomic recvbuf */
 	if (op->op_mapped) {
-		ib_dma_unmap_sg(ic->i_cm_id->device, op->op_sg, 1,
-				DMA_FROM_DEVICE);
+		dma_unmap_sg(ic->i_cm_id->device->dma_device, op->op_sg, 1,
+			     DMA_FROM_DEVICE);
 		op->op_mapped = 0;
 	}
 
@@ -546,10 +545,10 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	/* map the message the first time we see it */
 	if (!ic->i_data_op) {
 		if (rm->data.op_nents) {
-			rm->data.op_count = ib_dma_map_sg(dev,
-							  rm->data.op_sg,
-							  rm->data.op_nents,
-							  DMA_TO_DEVICE);
+			rm->data.op_count = dma_map_sg(dev->dma_device,
+						       rm->data.op_sg,
+						       rm->data.op_nents,
+						       DMA_TO_DEVICE);
 			rdsdebug("ic %p mapping rm %p: %d\n", ic, rm, rm->data.op_count);
 			if (rm->data.op_count == 0) {
 				rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
@@ -640,16 +639,16 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		if (i < work_alloc
 		    && scat != &rm->data.op_sg[rm->data.op_count]) {
 			len = min(RDS_FRAG_SIZE,
-				ib_sg_dma_len(dev, scat) - rm->data.op_dmaoff);
+				sg_dma_len(scat) - rm->data.op_dmaoff);
 			send->s_wr.num_sge = 2;
 
-			send->s_sge[1].addr = ib_sg_dma_address(dev, scat);
+			send->s_sge[1].addr = sg_dma_address(scat);
 			send->s_sge[1].addr += rm->data.op_dmaoff;
 			send->s_sge[1].length = len;
 
 			bytes_sent += len;
 			rm->data.op_dmaoff += len;
-			if (rm->data.op_dmaoff == ib_sg_dma_len(dev, scat)) {
+			if (rm->data.op_dmaoff == sg_dma_len(scat)) {
 				scat++;
 				rm->data.op_dmasg++;
 				rm->data.op_dmaoff = 0;
@@ -797,7 +796,8 @@ int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op)
 	rds_message_addref(container_of(send->s_op, struct rds_message, atomic));
 
 	/* map 8 byte retval buffer to the device */
-	ret = ib_dma_map_sg(ic->i_cm_id->device, op->op_sg, 1, DMA_FROM_DEVICE);
+	ret = dma_map_sg(ic->i_cm_id->device->dma_device, op->op_sg, 1,
+			 DMA_FROM_DEVICE);
 	rdsdebug("ic %p mapping atomic op %p. mapped %d pg\n", ic, op, ret);
 	if (ret != 1) {
 		rds_ib_ring_unalloc(&ic->i_send_ring, work_alloc);
@@ -807,8 +807,8 @@ int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op)
 	}
 
 	/* Convert our struct scatterlist to struct ib_sge */
-	send->s_sge[0].addr = ib_sg_dma_address(ic->i_cm_id->device, op->op_sg);
-	send->s_sge[0].length = ib_sg_dma_len(ic->i_cm_id->device, op->op_sg);
+	send->s_sge[0].addr = sg_dma_address(op->op_sg);
+	send->s_sge[0].length = sg_dma_len(op->op_sg);
 	send->s_sge[0].lkey = ic->i_pd->local_dma_lkey;
 
 	rdsdebug("rva %Lx rpa %Lx len %u\n", op->op_remote_addr,
@@ -861,9 +861,10 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 
 	/* map the op the first time we see it */
 	if (!op->op_mapped) {
-		op->op_count = ib_dma_map_sg(ic->i_cm_id->device,
-					     op->op_sg, op->op_nents, (op->op_write) ?
-					     DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		op->op_count = dma_map_sg(ic->i_cm_id->device->dma_device,
+					  op->op_sg, op->op_nents,
+					  op->op_write ? DMA_TO_DEVICE :
+					  DMA_FROM_DEVICE);
 		rdsdebug("ic %p mapping op %p: %d\n", ic, op, op->op_count);
 		if (op->op_count == 0) {
 			rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
@@ -920,9 +921,8 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 
 		for (j = 0; j < send->s_rdma_wr.wr.num_sge &&
 		     scat != &op->op_sg[op->op_count]; j++) {
-			len = ib_sg_dma_len(ic->i_cm_id->device, scat);
-			send->s_sge[j].addr =
-				 ib_sg_dma_address(ic->i_cm_id->device, scat);
+			len = sg_dma_len(scat);
+			send->s_sge[j].addr = sg_dma_address(scat);
 			send->s_sge[j].length = len;
 			send->s_sge[j].lkey = ic->i_pd->local_dma_lkey;
 
-- 
2.11.0
