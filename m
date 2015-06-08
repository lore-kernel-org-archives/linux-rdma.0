From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/5] IB/iser: Add indirect registration support
Date: Mon,  8 Jun 2015 16:15:38 +0300
Message-ID: <1433769339-949-5-git-send-email-sagig@mellanox.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769339-949-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case the SG list handed to us is not nicely page
aligned, we can now use indirect registration instead
of using a bounce buffer. This saves dramatic load for
large unaligned IOs.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    8 +++
 drivers/infiniband/ulp/iser/iser_memory.c |   98 +++++++++++++++++++++++++++--
 drivers/infiniband/ulp/iser/iser_verbs.c  |   35 ++++++++++-
 3 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 9365343..3cabccd 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -225,6 +225,7 @@ enum iser_data_dir {
  * @orig_sg:      pointer to the original sg list (in case
  *                we used a copy)
  * @orig_size:    num entris of orig sg list
+ * @aligned:      indicate if the data buffer is block aligned
  */
 struct iser_data_buf {
 	struct scatterlist *sg;
@@ -233,6 +234,7 @@ struct iser_data_buf {
 	unsigned int       dma_nents;
 	struct scatterlist *orig_sg;
 	unsigned int       orig_size;
+	bool               aligned;
   };
 
 /* fwd declarations */
@@ -389,7 +391,10 @@ struct iser_device {
  * @fmr_pool:   pool of fmrs
  * @frpl:       fast reg page list used by frwrs
  * @page_vec:   fast reg page list used by fmr pool
+ * @indir_mr:   indirect memory region
+ * @indir_rl:   indirect registration list
  * @mr_valid:   is mr valid indicator
+ * @indirmr_valid: is indirect mr valid indicator
  */
 struct iser_reg_resources {
 	union {
@@ -400,7 +405,10 @@ struct iser_reg_resources {
 		struct ib_fast_reg_page_list     *frpl;
 		struct iser_page_vec             *page_vec;
 	};
+	struct ib_mr                     *indir_mr;
+	struct ib_indir_reg_list         *indir_rl;
 	u8				  mr_valid:1;
+	u8                                indir_mr_valid:1;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index b1261d5..de5c7da 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -782,6 +782,79 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 }
 
 static int
+iser_sg_to_ivec(struct iser_data_buf *mem,
+		struct iser_device *device,
+		struct ib_sge *sg_list)
+{
+	struct scatterlist *sg;
+	struct ib_sge *sge;
+	int i, total_len = 0;
+
+	for_each_sg(mem->sg, sg, mem->dma_nents, i) {
+		sge = &sg_list[i];
+		sge->addr = ib_sg_dma_address(device->ib_device, sg);
+		sge->length = ib_sg_dma_len(device->ib_device, sg);
+		sge->lkey = device->mr->lkey;
+		total_len += sge->length;
+	}
+
+	return total_len;
+}
+
+static int
+iser_reg_indir_mem(struct iscsi_iser_task *iser_task,
+		   struct iser_data_buf *mem,
+		   struct iser_reg_resources *rsc,
+		   struct iser_mem_reg *reg)
+{
+	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+	struct ib_send_wr indir_wr, inv_wr;
+	struct ib_send_wr *bad_wr, *wr = NULL;
+	int total_len;
+	int ret;
+
+	iser_task->iser_conn->iscsi_conn->fmr_unalign_cnt++;
+
+	total_len = iser_sg_to_ivec(mem, device, rsc->indir_rl->sg_list);
+
+	if (!rsc->indir_mr_valid) {
+		iser_inv_rkey(&inv_wr, rsc->indir_mr);
+		wr = &inv_wr;
+	}
+
+	memset(&indir_wr, 0, sizeof(indir_wr));
+	indir_wr.opcode = IB_WR_REG_INDIR_MR;
+	indir_wr.wr_id = ISER_FASTREG_LI_WRID;
+	indir_wr.wr.indir_reg.mkey = rsc->indir_mr->rkey;
+	indir_wr.wr.indir_reg.iova_start = rsc->indir_rl->sg_list[0].addr;
+	indir_wr.wr.indir_reg.indir_list = rsc->indir_rl;
+	indir_wr.wr.indir_reg.indir_list_len = mem->size;
+	indir_wr.wr.indir_reg.length = (u64)total_len;
+	indir_wr.wr.indir_reg.access_flags = IB_ACCESS_REMOTE_READ  |
+					     IB_ACCESS_REMOTE_WRITE |
+					     IB_ACCESS_LOCAL_WRITE;
+	if (!wr)
+		wr = &indir_wr;
+	else
+		wr->next = &indir_wr;
+
+	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
+	if (ret) {
+		iser_err("indirect_reg failed, ret:%d\n", ret);
+		return ret;
+	}
+	rsc->indir_mr_valid = 0;
+
+	reg->sge.lkey = rsc->indir_mr->lkey;
+	reg->rkey = rsc->indir_mr->rkey;
+	reg->sge.addr = indir_wr.wr.indir_reg.iova_start;
+	reg->sge.length = indir_wr.wr.indir_reg.length;
+
+	return 0;
+}
+
+static int
 iser_handle_unaligned_buf(struct iscsi_iser_task *task,
 			  struct iser_data_buf *mem,
 			  enum iser_data_dir dir)
@@ -792,11 +865,20 @@ iser_handle_unaligned_buf(struct iscsi_iser_task *task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(task, mem, dir);
-		if (err)
-			return err;
+		if (device->dev_attr.device_cap_flags &
+		    IB_DEVICE_INDIR_REGISTRATION) {
+			mem->aligned = false;
+			goto done;
+		} else {
+			err = fall_to_bounce_buf(task, mem, dir);
+			if (err)
+				return err;
+		}
 	}
 
+	mem->aligned = true;
+
+done:
 	return 0;
 }
 
@@ -810,8 +892,11 @@ iser_reg_prot_sg(struct iscsi_iser_task *task,
 
 	if (mem->dma_nents == 1)
 		return iser_reg_dma(device, mem, reg);
+	else if (mem->aligned)
+		return device->reg_ops->reg_mem(task, mem,
+						&desc->pi_ctx->rsc, reg);
 
-	return device->reg_ops->reg_mem(task, mem, &desc->pi_ctx->rsc, reg);
+	return iser_reg_indir_mem(task, mem, &desc->rsc, reg);
 }
 
 static int
@@ -824,8 +909,11 @@ iser_reg_data_sg(struct iscsi_iser_task *task,
 
 	if (mem->dma_nents == 1)
 		return iser_reg_dma(device, mem, reg);
+	else if (mem->aligned)
+		return device->reg_ops->reg_mem(task, mem,
+						&desc->rsc, reg);
 
-	return device->reg_ops->reg_mem(task, mem, &desc->rsc, reg);
+	return iser_reg_indir_mem(task, mem, &desc->rsc, reg);
 }
 
 int iser_reg_rdma_mem(struct iscsi_iser_task *task,
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 3267a9c..713f3a9 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -286,7 +286,7 @@ iser_alloc_reg_res(struct iser_device *device,
 	struct ib_device *ib_device = device->ib_device;
 	int ret;
 
-	res->frpl = ib_alloc_fast_reg_page_list(ib_device,
+	res->frpl = ib_alloc_fast_reg_page_list(device->ib_device,
 						ISCSI_ISER_SG_TABLESIZE + 1);
 	if (IS_ERR(res->frpl)) {
 		ret = PTR_ERR(res->frpl);
@@ -303,8 +303,37 @@ iser_alloc_reg_res(struct iser_device *device,
 	}
 	res->mr_valid = 1;
 
+	if (device->dev_attr.device_cap_flags & IB_DEVICE_INDIR_REGISTRATION) {
+		struct ib_mr_init_attr mr_attr;
+
+		res->indir_rl = ib_alloc_indir_reg_list(ib_device,
+						ISCSI_ISER_SG_TABLESIZE);
+		if (IS_ERR(res->indir_rl)) {
+			ret = PTR_ERR(res->indir_rl);
+			iser_err("Failed to allocate ib_indir_reg_list err=%d\n",
+				 ret);
+			goto indir_reg_list_failure;
+		}
+
+		memset(&mr_attr, 0, sizeof(mr_attr));
+		mr_attr.flags = IB_MR_INDIRECT_REG;
+		mr_attr.max_reg_descriptors = ISCSI_ISER_SG_TABLESIZE;
+		res->indir_mr = ib_create_mr(pd, &mr_attr);
+		if (IS_ERR(res->indir_mr)) {
+			ret = PTR_ERR(res->indir_mr);
+			iser_err("Failed to allocate indir mr err=%d\n",
+				 ret);
+			goto indir_mr_failure;
+		}
+		res->indir_mr_valid = 1;
+	}
+
 	return 0;
 
+indir_mr_failure:
+	ib_free_indir_reg_list(res->indir_rl);
+indir_reg_list_failure:
+	ib_dereg_mr(res->mr);
 fast_reg_mr_failure:
 	ib_free_fast_reg_page_list(res->frpl);
 
@@ -316,6 +345,10 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 {
 	ib_dereg_mr(rsc->mr);
 	ib_free_fast_reg_page_list(rsc->frpl);
+	if (rsc->indir_mr)
+		ib_dereg_mr(rsc->indir_mr);
+	if (rsc->indir_rl)
+		ib_free_indir_reg_list(rsc->indir_rl);
 }
 
 static int
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
