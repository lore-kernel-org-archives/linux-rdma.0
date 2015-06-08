From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 11/11] IB/iser: Unify fast memory registration flows
Date: Mon,  8 Jun 2015 16:15:23 +0300
Message-ID: <1433769323-790-12-git-send-email-sagig@mellanox.com>
References: <1433769323-790-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769323-790-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

iser_reg_rdma_mem_[fastreg|fmr] share a lot of code, and
logically do the same thing other than the buffer registration
method itself (iser_fast_reg_mr vs. iser_fast_reg_fmr).
The DIF logic is not implemented in the FMR flow as there is no
existing device that supports FMRs and Signature feature.

This patch unifies the flow in a single routine iser_reg_rdma_mem
and just split to fmr/frwr for the buffer registration itself.

Also, for symmetry reasons, unify iser_unreg_rdma_mem (which will
call the relevant device specific unreg routine).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   23 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   11 +-
 drivers/infiniband/ulp/iser/iser_memory.c    |  210 ++++++++++++--------------
 3 files changed, 113 insertions(+), 131 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 758e56b..9365343 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -239,6 +239,7 @@ struct iser_data_buf {
 struct iser_device;
 struct iscsi_iser_task;
 struct iscsi_endpoint;
+struct iser_reg_resources;
 
 /**
  * struct iser_mem_reg - iSER memory registration info
@@ -329,8 +330,8 @@ struct iser_comp {
  *
  * @alloc_reg_res:     Allocate registration resources
  * @free_reg_res:      Free registration resources
- * @reg_rdma_mem:      Register memory buffers
- * @unreg_rdma_mem:    Un-register memory buffers
+ * @fast_reg_mem:      Register memory buffers
+ * @unreg_mem:         Un-register memory buffers
  * @reg_desc_get:      Get a registration descriptor for pool
  * @reg_desc_put:      Get a registration descriptor to pool
  */
@@ -338,10 +339,12 @@ struct iser_reg_ops {
 	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
 					unsigned cmds_max);
 	void           (*free_reg_res)(struct ib_conn *ib_conn);
-	int            (*reg_rdma_mem)(struct iscsi_iser_task *iser_task,
-				       enum iser_data_dir cmd_dir);
-	void           (*unreg_rdma_mem)(struct iscsi_iser_task *iser_task,
-					 enum iser_data_dir cmd_dir);
+	int            (*reg_mem)(struct iscsi_iser_task *iser_task,
+				  struct iser_data_buf *mem,
+				  struct iser_reg_resources *rsc,
+				  struct iser_mem_reg *reg);
+	void           (*unreg_mem)(struct iscsi_iser_task *iser_task,
+				    enum iser_data_dir cmd_dir);
 	struct iser_fr_desc * (*reg_desc_get)(struct ib_conn *ib_conn);
 	void           (*reg_desc_put)(struct ib_conn *ib_conn,
 				       struct iser_fr_desc *desc);
@@ -620,10 +623,10 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *mem,
 				     enum iser_data_dir cmd_dir);
 
-int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
-			   enum iser_data_dir cmd_dir);
-int  iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *task,
-			       enum iser_data_dir cmd_dir);
+int iser_reg_rdma_mem(struct iscsi_iser_task *task,
+		      enum iser_data_dir dir);
+void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
+			 enum iser_data_dir dir);
 
 int  iser_connect(struct iser_conn *iser_conn,
 		  struct sockaddr *src_addr,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 56c1efc..9382f94 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -49,7 +49,6 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_mem_reg *mem_reg;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -73,7 +72,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 			return err;
 	}
 
-	err = device->reg_ops->reg_rdma_mem(iser_task, ISER_DIR_IN);
+	err = iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
@@ -103,7 +102,6 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 		       unsigned int edtl)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_device  *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_mem_reg *mem_reg;
 	int err;
 	struct iser_hdr *hdr = &iser_task->desc.iser_header;
@@ -128,7 +126,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	err = device->reg_ops->reg_rdma_mem(iser_task, ISER_DIR_OUT);
+	err = iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
@@ -666,7 +664,6 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
-	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 	int is_rdma_data_aligned = 1;
 	int is_rdma_prot_aligned = 1;
 	int prot_count = scsi_prot_sg_count(iser_task->sc);
@@ -703,7 +700,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	}
 
 	if (iser_task->dir[ISER_DIR_IN]) {
-		device->reg_ops->unreg_rdma_mem(iser_task, ISER_DIR_IN);
+		iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->data[ISER_DIR_IN],
@@ -715,7 +712,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	}
 
 	if (iser_task->dir[ISER_DIR_OUT]) {
-		device->reg_ops->unreg_rdma_mem(iser_task, ISER_DIR_OUT);
+		iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
 		if (is_rdma_data_aligned)
 			iser_dma_unmap_task_data(iser_task,
 						 &iser_task->data[ISER_DIR_OUT],
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 7ee7f44..b1261d5 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -38,12 +38,22 @@
 #include <linux/scatterlist.h>
 
 #include "iscsi_iser.h"
+static
+int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
+		      struct iser_data_buf *mem,
+		      struct iser_reg_resources *rsc,
+		      struct iser_mem_reg *mem_reg);
+static
+int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
+		     struct iser_data_buf *mem,
+		     struct iser_reg_resources *rsc,
+		     struct iser_mem_reg *mem_reg);
 
 static struct iser_reg_ops fastreg_ops = {
 	.alloc_reg_res	= iser_alloc_fastreg_pool,
 	.free_reg_res	= iser_free_fastreg_pool,
-	.reg_rdma_mem	= iser_reg_rdma_mem_fastreg,
-	.unreg_rdma_mem	= iser_unreg_mem_fastreg,
+	.reg_mem	= iser_fast_reg_mr,
+	.unreg_mem	= iser_unreg_mem_fastreg,
 	.reg_desc_get	= iser_reg_desc_get_fr,
 	.reg_desc_put	= iser_reg_desc_put_fr,
 };
@@ -51,8 +61,8 @@ static struct iser_reg_ops fastreg_ops = {
 static struct iser_reg_ops fmr_ops = {
 	.alloc_reg_res	= iser_alloc_fmr_pool,
 	.free_reg_res	= iser_free_fmr_pool,
-	.reg_rdma_mem	= iser_reg_rdma_mem_fmr,
-	.unreg_rdma_mem	= iser_unreg_mem_fmr,
+	.reg_mem	= iser_fast_reg_fmr,
+	.unreg_mem	= iser_unreg_mem_fmr,
 	.reg_desc_get	= iser_reg_desc_get_fmr,
 	.reg_desc_put	= iser_reg_desc_put_fmr,
 };
@@ -574,62 +584,6 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 	reg->mem_h = NULL;
 }
 
-/**
- * iser_reg_rdma_mem_fmr - Registers memory intended for RDMA,
- * using FMR (if possible) obtaining rkey and va
- *
- * returns 0 on success, errno code on failure
- */
-int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
-			  enum iser_data_dir cmd_dir)
-{
-	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_device   *device = ib_conn->device;
-	struct ib_device     *ibdev = device->ib_device;
-	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
-	struct iser_mem_reg *mem_reg;
-	int aligned_len;
-	int err;
-	int i;
-
-	mem_reg = &iser_task->rdma_reg[cmd_dir];
-
-	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
-	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, mem, cmd_dir);
-		if (err) {
-			iser_err("failed to allocate bounce buffer\n");
-			return err;
-		}
-	}
-
-	/* if there a single dma entry, FMR is not needed */
-	if (mem->dma_nents == 1) {
-		return iser_reg_dma(device, mem, mem_reg);
-	} else { /* use FMR for multiple dma entries */
-		struct iser_fr_desc *desc;
-
-		desc = device->reg_ops->reg_desc_get(ib_conn);
-		err = iser_fast_reg_fmr(iser_task, mem, &desc->rsc, mem_reg);
-		if (err && err != -EAGAIN) {
-			iser_data_buf_dump(mem, ibdev);
-			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
-				 mem->dma_nents,
-				 ntoh24(iser_task->desc.iscsi_header.dlength));
-			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 desc->rsc.page_vec->data_size,
-				 desc->rsc.page_vec->length,
-				 desc->rsc.page_vec->offset);
-			for (i = 0; i < desc->rsc.page_vec->length; i++)
-				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long)desc->rsc.page_vec->pages[i]);
-		}
-		if (err)
-			return err;
-	}
-	return 0;
-}
-
 static void
 iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_attrs *sig_attrs,
 		    struct ib_sig_domain *domain)
@@ -775,19 +729,12 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
-	struct ib_mr *mr;
-	struct ib_fast_reg_page_list *frpl;
+	struct ib_mr *mr = rsc->mr;
+	struct ib_fast_reg_page_list *frpl = rsc->frpl;
 	struct ib_send_wr fastreg_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
 	int ret, offset, size, plen;
 
-	/* if there a single dma entry, dma mr suffices */
-	if (mem->dma_nents == 1)
-		return iser_reg_dma(device, mem, reg);
-
-	mr = rsc->mr;
-	frpl = rsc->frpl;
-
 	plen = iser_sg_to_page_vec(mem, device->ib_device, frpl->page_list,
 				   &offset, &size);
 	if (plen * SIZE_4K < size) {
@@ -834,78 +781,113 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	return ret;
 }
 
-/**
- * iser_reg_rdma_mem_fastreg - Registers memory intended for RDMA,
- * using Fast Registration WR (if possible) obtaining rkey and va
- *
- * returns 0 on success, errno code on failure
- */
-int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
-			      enum iser_data_dir cmd_dir)
+static int
+iser_handle_unaligned_buf(struct iscsi_iser_task *task,
+			  struct iser_data_buf *mem,
+			  enum iser_data_dir dir)
 {
-	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_device *device = ib_conn->device;
-	struct ib_device *ibdev = device->ib_device;
-	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
-	struct iser_mem_reg *mem_reg = &iser_task->rdma_reg[cmd_dir];
-	struct iser_fr_desc *desc = NULL;
+	struct iser_conn *iser_conn = task->iser_conn;
+	struct iser_device *device = iser_conn->ib_conn.device;
 	int err, aligned_len;
 
-	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
+	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, mem, cmd_dir);
-		if (err) {
-			iser_err("failed to allocate bounce buffer\n");
+		err = fall_to_bounce_buf(task, mem, dir);
+		if (err)
 			return err;
-		}
 	}
 
+	return 0;
+}
+
+static int
+iser_reg_prot_sg(struct iscsi_iser_task *task,
+		 struct iser_data_buf *mem,
+		 struct iser_fr_desc *desc,
+		 struct iser_mem_reg *reg)
+{
+	struct iser_device *device = task->iser_conn->ib_conn.device;
+
+	if (mem->dma_nents == 1)
+		return iser_reg_dma(device, mem, reg);
+
+	return device->reg_ops->reg_mem(task, mem, &desc->pi_ctx->rsc, reg);
+}
+
+static int
+iser_reg_data_sg(struct iscsi_iser_task *task,
+		 struct iser_data_buf *mem,
+		 struct iser_fr_desc *desc,
+		 struct iser_mem_reg *reg)
+{
+	struct iser_device *device = task->iser_conn->ib_conn.device;
+
+	if (mem->dma_nents == 1)
+		return iser_reg_dma(device, mem, reg);
+
+	return device->reg_ops->reg_mem(task, mem, &desc->rsc, reg);
+}
+
+int iser_reg_rdma_mem(struct iscsi_iser_task *task,
+		      enum iser_data_dir dir)
+{
+	struct ib_conn *ib_conn = &task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+	struct iser_data_buf *mem = &task->data[dir];
+	struct iser_mem_reg *reg = &task->rdma_reg[dir];
+	struct iser_fr_desc *desc = NULL;
+	int err;
+
+	err = iser_handle_unaligned_buf(task, mem, dir);
+	if (unlikely(err))
+		return err;
+
 	if (mem->dma_nents != 1 ||
-	    scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
+	    scsi_get_prot_op(task->sc) != SCSI_PROT_NORMAL) {
 		desc = device->reg_ops->reg_desc_get(ib_conn);
-		mem_reg->mem_h = desc;
+		reg->mem_h = desc;
 	}
 
-	err = iser_fast_reg_mr(iser_task, mem,
-			       desc ? &desc->rsc : NULL, mem_reg);
-	if (err)
+	err = iser_reg_data_sg(task, mem, desc, reg);
+	if (unlikely(err))
 		goto err_reg;
 
-	if (scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
+	if (scsi_get_prot_op(task->sc) != SCSI_PROT_NORMAL) {
 		struct iser_mem_reg prot_reg;
 
 		memset(&prot_reg, 0, sizeof(prot_reg));
-		if (scsi_prot_sg_count(iser_task->sc)) {
-			mem = &iser_task->prot[cmd_dir];
-			aligned_len = iser_data_buf_aligned_len(mem, ibdev);
-			if (aligned_len != mem->dma_nents) {
-				err = fall_to_bounce_buf(iser_task, mem,
-							 cmd_dir);
-				if (err) {
-					iser_err("failed to allocate bounce buffer\n");
-					return err;
-				}
-			}
+		if (scsi_prot_sg_count(task->sc)) {
+			mem = &task->prot[dir];
+			err = iser_handle_unaligned_buf(task, mem, dir);
+			if (unlikely(err))
+				goto err_reg;
 
-			err = iser_fast_reg_mr(iser_task, mem,
-					       &desc->pi_ctx->rsc, &prot_reg);
-			if (err)
+			err = iser_reg_prot_sg(task, mem, desc, &prot_reg);
+			if (unlikely(err))
 				goto err_reg;
 		}
 
-		err = iser_reg_sig_mr(iser_task, desc->pi_ctx, mem_reg,
-				      &prot_reg, mem_reg);
-		if (err) {
-			iser_err("Failed to register signature mr\n");
-			return err;
-		}
+		err = iser_reg_sig_mr(task, desc->pi_ctx, reg,
+				      &prot_reg, reg);
+		if (unlikely(err))
+			goto err_reg;
+
 		desc->pi_ctx->sig_protected = 1;
 	}
 
 	return 0;
+
 err_reg:
 	if (desc)
 		device->reg_ops->reg_desc_put(ib_conn, desc);
 
 	return err;
 }
+
+void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
+			 enum iser_data_dir dir)
+{
+	struct iser_device *device = task->iser_conn->ib_conn.device;
+
+	device->reg_ops->unreg_mem(task, dir);
+}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
