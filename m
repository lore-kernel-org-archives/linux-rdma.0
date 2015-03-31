From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 16/18] IB/iser: Remove code duplication for a single DMA entry
Date: Tue, 31 Mar 2015 19:45:56 +0300
Message-ID: <1427820358-15087-17-git-send-email-sagig@mellanox.com>
References: <1427820358-15087-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427820358-15087-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In singleton scatterlists, DMA memory registration code
is taken both for Fastreg and FMR code paths. Move it to
a function.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   48 ++++++++++++----------------
 1 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index b4b0098..e78ce53 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -334,6 +334,24 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 	ib_dma_unmap_sg(dev, data->sg, data->size, dir);
 }
 
+static int
+iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
+	     struct iser_mem_reg *reg)
+{
+	struct scatterlist *sg = mem->sg;
+
+	reg->sge.lkey = device->mr->lkey;
+	reg->rkey = device->mr->rkey;
+	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
+	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
+
+	iser_dbg("Single DMA entry: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
+		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
+		 reg->sge.addr, reg->sge.length);
+
+	return 0;
+}
+
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 			      struct iser_data_buf *mem,
 			      enum iser_data_dir cmd_dir,
@@ -461,7 +479,6 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	int aligned_len;
 	int err;
 	int i;
-	struct scatterlist *sg;
 
 	mem_reg = &iser_task->rdma_reg[cmd_dir];
 
@@ -477,19 +494,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 
 	/* if there a single dma entry, FMR is not needed */
 	if (mem->dma_nents == 1) {
-		sg = mem->sg;
-
-		mem_reg->sge.lkey = device->mr->lkey;
-		mem_reg->rkey = device->mr->rkey;
-		mem_reg->sge.length = ib_sg_dma_len(ibdev, &sg[0]);
-		mem_reg->sge.addr = ib_sg_dma_address(ibdev, &sg[0]);
-
-		iser_dbg("PHYSICAL Mem.register: lkey: 0x%08X rkey: 0x%08X  "
-			 "va: 0x%08lX sz: %ld]\n",
-			 (unsigned int)mem_reg->sge.lkey,
-			 (unsigned int)mem_reg->rkey,
-			 (unsigned long)mem_reg->sge.addr,
-			 (unsigned long)mem_reg->sge.length);
+		return iser_reg_dma(device, mem, mem_reg);
 	} else { /* use FMR for multiple dma entries */
 		err = iser_reg_page_vec(iser_task, mem, ib_conn->fmr.page_vec,
 					mem_reg);
@@ -660,7 +665,6 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	struct fast_reg_descriptor *desc = mem_reg->mem_h;
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
-	struct ib_device *ibdev = device->ib_device;
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *frpl;
 	struct ib_send_wr fastreg_wr, inv_wr;
@@ -668,18 +672,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	int ret, offset, size, plen;
 
 	/* if there a single dma entry, dma mr suffices */
-	if (mem->dma_nents == 1) {
-		struct scatterlist *sg = mem->sg;
-
-		reg->sge.lkey = device->mr->lkey;
-		reg->rkey = device->mr->rkey;
-		reg->sge.addr = ib_sg_dma_address(ibdev, &sg[0]);
-		reg->sge.length = ib_sg_dma_len(ibdev, &sg[0]);
-
-		iser_dbg("Single DMA entry: lkey=0x%x, addr=0x%llx, length=0x%x\n",
-			 reg->sge.lkey, reg->sge.addr, reg->sge.length);
-		return 0;
-	}
+	if (mem->dma_nents == 1)
+		return iser_reg_dma(device, mem, mem_reg);
 
 	if (ind == ISER_DATA_KEY_VALID) {
 		mr = desc->data_mr;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
