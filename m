From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES] IB/iser: Use correct dma direction when unmapping SGs
Date: Sun, 28 Dec 2014 14:26:11 +0200
Message-ID: <1419769571-22801-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We always unmap SGs with the same direction instead of unmapping
with the direction the mapping was done, fix that.

Fixes: 9a8b08fad2ef "IB/iser: Generalize iser_unmap_task_data and [...]"
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    4 +++-
 drivers/infiniband/ulp/iser/iser_initiator.c |   12 ++++++++----
 drivers/infiniband/ulp/iser/iser_memory.c    |    9 ++++++---
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5ce2681..b47aea1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -654,7 +654,9 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			   enum dma_data_direction dma_dir);
 
 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
-			      struct iser_data_buf *data);
+			      struct iser_data_buf *data,
+			      enum dma_data_direction dir);
+
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 3821633..bdf2b22 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -714,19 +714,23 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->data[ISER_DIR_IN]);
+						 &iser_task->data[ISER_DIR_IN],
+						 DMA_FROM_DEVICE);
 		if (prot_count && is_rdma_prot_aligned)
 			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->prot[ISER_DIR_IN]);
+						 &iser_task->prot[ISER_DIR_IN],
+						 DMA_FROM_DEVICE);
 	}
 
 	if (iser_task->dir[ISER_DIR_OUT]) {
 		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->data[ISER_DIR_OUT]);
+						 &iser_task->data[ISER_DIR_OUT],
+						 DMA_TO_DEVICE);
 		if (prot_count && is_rdma_prot_aligned)
 			iser_dma_unmap_task_data(iser_task,
-						 &iser_task->prot[ISER_DIR_OUT]);
+						 &iser_task->prot[ISER_DIR_OUT],
+						 DMA_TO_DEVICE);
 	}
 }
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index abce933..341040b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -332,12 +332,13 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 }
 
 void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
-			      struct iser_data_buf *data)
+			      struct iser_data_buf *data,
+			      enum dma_data_direction dir)
 {
 	struct ib_device *dev;
 
 	dev = iser_task->iser_conn->ib_conn.device->ib_device;
-	ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
+	ib_dma_unmap_sg(dev, data->buf, data->size, dir);
 }
 
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
@@ -357,7 +358,9 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 		iser_data_buf_dump(mem, ibdev);
 
 	/* unmap the command data before accessing it */
-	iser_dma_unmap_task_data(iser_task, mem);
+	iser_dma_unmap_task_data(iser_task, mem,
+				 (cmd_dir == ISER_DIR_OUT) ?
+				 DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	/* allocate copy buf, if we are writing, copy the */
 	/* unaligned scatterlist, dma map the copy        */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
