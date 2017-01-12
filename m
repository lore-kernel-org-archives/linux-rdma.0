From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 19/26] IB/srp: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:11 -0800
Message-ID: <20170112190718.6728-20-bart.vanassche@sandisk.com>
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
---
 drivers/infiniband/ulp/srp/ib_srp.c | 80 +++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cd150c19d0d2..3b411c40a8ab 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -233,9 +233,9 @@ static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
 	if (!iu->buf)
 		goto out_free_iu;
 
-	iu->dma = ib_dma_map_single(host->srp_dev->dev, iu->buf, size,
-				    direction);
-	if (ib_dma_mapping_error(host->srp_dev->dev, iu->dma))
+	iu->dma = dma_map_single(host->srp_dev->dev->dma_device, iu->buf, size,
+				 direction);
+	if (dma_mapping_error(host->srp_dev->dev->dma_device, iu->dma))
 		goto out_free_buf;
 
 	iu->size      = size;
@@ -256,8 +256,8 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
 	if (!iu)
 		return;
 
-	ib_dma_unmap_single(host->srp_dev->dev, iu->dma, iu->size,
-			    iu->direction);
+	dma_unmap_single(host->srp_dev->dev->dma_device, iu->dma, iu->size,
+			 iu->direction);
 	kfree(iu->buf);
 	kfree(iu);
 }
@@ -843,9 +843,8 @@ static void srp_free_req_data(struct srp_target_port *target,
 			kfree(req->map_page);
 		}
 		if (req->indirect_dma_addr) {
-			ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
-					    target->indirect_size,
-					    DMA_TO_DEVICE);
+			dma_unmap_single(ibdev->dma_device, req->indirect_dma_addr,
+					 target->indirect_size, DMA_TO_DEVICE);
 		}
 		kfree(req->indirect_desc);
 	}
@@ -888,10 +887,9 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 		if (!req->indirect_desc)
 			goto out;
 
-		dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
-					     target->indirect_size,
-					     DMA_TO_DEVICE);
-		if (ib_dma_mapping_error(ibdev, dma_addr))
+		dma_addr = dma_map_single(ibdev->dma_device, req->indirect_desc,
+					  target->indirect_size, DMA_TO_DEVICE);
+		if (dma_mapping_error(ibdev->dma_device, dma_addr))
 			goto out;
 
 		req->indirect_dma_addr = dma_addr;
@@ -1096,8 +1094,8 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			ib_fmr_pool_unmap(*pfmr);
 	}
 
-	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
-			scmnd->sc_data_direction);
+	dma_unmap_sg(ibdev->dma_device, scsi_sglist(scmnd), scsi_sg_count(scmnd),
+		     scmnd->sc_data_direction);
 }
 
 /**
@@ -1411,8 +1409,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	*state->fr.next++ = desc;
 	state->nmdesc++;
 
-	srp_map_desc(state, desc->mr->iova,
-		     desc->mr->length, desc->mr->rkey);
+	srp_map_desc(state, desc->mr->iova, desc->mr->length, desc->mr->rkey);
 
 	err = ib_post_send(ch->qp, &wr.wr, &bad_wr);
 	if (unlikely(err)) {
@@ -1429,9 +1426,8 @@ static int srp_map_sg_entry(struct srp_map_state *state,
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_device *ibdev = dev->dev;
-	dma_addr_t dma_addr = ib_sg_dma_address(ibdev, sg);
-	unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
+	dma_addr_t dma_addr = sg_dma_address(sg);
+	unsigned int dma_len = sg_dma_len(sg);
 	unsigned int len = 0;
 	int ret;
 
@@ -1525,13 +1521,11 @@ static int srp_map_sg_dma(struct srp_map_state *state, struct srp_rdma_ch *ch,
 			  int count)
 {
 	struct srp_target_port *target = ch->target;
-	struct srp_device *dev = target->srp_host->srp_dev;
 	struct scatterlist *sg;
 	int i;
 
 	for_each_sg(scat, sg, count, i) {
-		srp_map_desc(state, ib_sg_dma_address(dev->dev, sg),
-			     ib_sg_dma_len(dev->dev, sg),
+		srp_map_desc(state, sg_dma_address(sg), sg_dma_len(sg),
 			     target->pd->unsafe_global_rkey);
 	}
 
@@ -1659,7 +1653,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	dev = target->srp_host->srp_dev;
 	ibdev = dev->dev;
 
-	count = ib_dma_map_sg(ibdev, scat, nents, scmnd->sc_data_direction);
+	count = dma_map_sg(ibdev->dma_device, scat, nents, scmnd->sc_data_direction);
 	if (unlikely(count == 0))
 		return -EIO;
 
@@ -1691,9 +1685,9 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 		 */
 		struct srp_direct_buf *buf = (void *) cmd->add_data;
 
-		buf->va  = cpu_to_be64(ib_sg_dma_address(ibdev, scat));
+		buf->va  = cpu_to_be64(sg_dma_address(scat));
 		buf->key = cpu_to_be32(pd->unsafe_global_rkey);
-		buf->len = cpu_to_be32(ib_sg_dma_len(ibdev, scat));
+		buf->len = cpu_to_be32(sg_dma_len(scat));
 
 		req->nmdesc = 0;
 		/* Debugging help. */
@@ -1707,8 +1701,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	 */
 	indirect_hdr = (void *) cmd->add_data;
 
-	ib_dma_sync_single_for_cpu(ibdev, req->indirect_dma_addr,
-				   target->indirect_size, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(ibdev->dma_device, req->indirect_dma_addr,
+				target->indirect_size, DMA_TO_DEVICE);
 
 	memset(&state, 0, sizeof(state));
 	state.desc = req->indirect_desc;
@@ -1789,8 +1783,8 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	else
 		cmd->data_in_desc_cnt = count;
 
-	ib_dma_sync_single_for_device(ibdev, req->indirect_dma_addr, table_len,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(ibdev->dma_device, req->indirect_dma_addr,
+				   table_len, DMA_TO_DEVICE);
 
 map_complete:
 	/* Debugging help. */
@@ -2084,9 +2078,9 @@ static int srp_response_common(struct srp_rdma_ch *ch, s32 req_delta,
 		return 1;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, iu->dma, len, DMA_TO_DEVICE);
 	memcpy(iu->buf, rsp, len);
-	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, iu->dma, len, DMA_TO_DEVICE);
 
 	err = srp_post_send(ch, iu, len);
 	if (err) {
@@ -2144,8 +2138,8 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, ch->max_ti_iu_len,
-				   DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, iu->dma, ch->max_ti_iu_len,
+				DMA_FROM_DEVICE);
 
 	opcode = *(u8 *) iu->buf;
 
@@ -2181,8 +2175,8 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		break;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, ch->max_ti_iu_len,
-				      DMA_FROM_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, iu->dma, ch->max_ti_iu_len,
+				   DMA_FROM_DEVICE);
 
 	res = srp_post_recv(ch, iu);
 	if (res != 0)
@@ -2267,8 +2261,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	req = &ch->req_ring[idx];
 	dev = target->srp_host->srp_dev->dev;
-	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
-				   DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, iu->dma, target->max_iu_len,
+				DMA_TO_DEVICE);
 
 	scmnd->host_scribble = (void *) req;
 
@@ -2302,8 +2296,8 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_iu;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, iu->dma, target->max_iu_len,
+				   DMA_TO_DEVICE);
 
 	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
@@ -2689,8 +2683,8 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
 		return -1;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
-				   DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dev->dma_device, iu->dma, sizeof *tsk_mgmt,
+				DMA_TO_DEVICE);
 	tsk_mgmt = iu->buf;
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
@@ -2700,8 +2694,8 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag	= req_tag;
 
-	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
-				      DMA_TO_DEVICE);
+	dma_sync_single_for_device(dev->dma_device, iu->dma, sizeof *tsk_mgmt,
+				   DMA_TO_DEVICE);
 	if (srp_post_send(ch, iu, sizeof(*tsk_mgmt))) {
 		srp_put_tx_iu(ch, iu, SRP_IU_TSK_MGMT);
 		mutex_unlock(&rport->mutex);
-- 
2.11.0
