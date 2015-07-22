From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 36/43] iser: Port to new fast registration api
Date: Wed, 22 Jul 2015 09:55:36 +0300
Message-ID: <1437548143-24893-37-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |  6 +----
 drivers/infiniband/ulp/iser/iser_memory.c | 40 ++++++++++++-------------------
 drivers/infiniband/ulp/iser/iser_verbs.c  | 16 +------------
 3 files changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 6c7efe6..88d0ffc 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -413,7 +413,6 @@ struct iser_device {
  *
  * @mr:         memory region
  * @fmr_pool:   pool of fmrs
- * @frpl:       fast reg page list used by frwrs
  * @page_vec:   fast reg page list used by fmr pool
  * @mr_valid:   is mr valid indicator
  */
@@ -422,10 +421,7 @@ struct iser_reg_resources {
 		struct ib_mr             *mr;
 		struct ib_fmr_pool       *fmr_pool;
 	};
-	union {
-		struct ib_fast_reg_page_list     *frpl;
-		struct iser_page_vec             *page_vec;
-	};
+	struct iser_page_vec             *page_vec;
 	u8				  mr_valid:1;
 };
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index d6d980b..094cf8a 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -732,19 +732,19 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct iser_reg_resources *rsc,
 			    struct iser_mem_reg *reg)
 {
-	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_device *device = ib_conn->device;
-	struct ib_mr *mr = rsc->mr;
-	struct ib_fast_reg_page_list *frpl = rsc->frpl;
 	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	struct ib_mr *mr = rsc->mr;
 	struct ib_send_wr *wr;
-	int offset, size, plen;
-
-	plen = iser_sg_to_page_vec(mem, device->ib_device, frpl->page_list,
-				   &offset, &size);
-	if (plen * SIZE_4K < size) {
-		iser_err("fast reg page_list too short to hold this SG\n");
-		return -EINVAL;
+	int err;
+	int access = IB_ACCESS_LOCAL_WRITE  |
+		     IB_ACCESS_REMOTE_WRITE |
+		     IB_ACCESS_REMOTE_READ;
+
+	err = ib_map_mr_sg(mr, mem->sg, mem->size, access);
+	if (err) {
+		iser_err("failed to map sg %p with %d entries\n",
+			 mem->sg, mem->dma_nents);
+		return err;
 	}
 
 	if (!rsc->mr_valid) {
@@ -753,24 +753,14 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	}
 
 	wr = iser_tx_next_wr(tx_desc);
-	wr->opcode = IB_WR_FAST_REG_MR;
-	wr->wr_id = ISER_FASTREG_LI_WRID;
-	wr->send_flags = 0;
-	wr->wr.fast_reg.iova_start = frpl->page_list[0] + offset;
-	wr->wr.fast_reg.page_list = frpl;
-	wr->wr.fast_reg.page_list_len = plen;
-	wr->wr.fast_reg.page_shift = SHIFT_4K;
-	wr->wr.fast_reg.length = size;
-	wr->wr.fast_reg.rkey = mr->rkey;
-	wr->wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
-					IB_ACCESS_REMOTE_WRITE |
-					IB_ACCESS_REMOTE_READ);
+	ib_set_fastreg_wr(mr, mr->rkey, ISER_FASTREG_LI_WRID,
+			  false, wr);
 	rsc->mr_valid = 0;
 
 	reg->sge.lkey = mr->lkey;
 	reg->rkey = mr->rkey;
-	reg->sge.addr = frpl->page_list[0] + offset;
-	reg->sge.length = size;
+	reg->sge.addr = mr->iova;
+	reg->sge.length = mr->length;
 
 	iser_dbg("fast reg: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
 		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ecc3265..332f784 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -288,35 +288,21 @@ iser_alloc_reg_res(struct ib_device *ib_device,
 {
 	int ret;
 
-	res->frpl = ib_alloc_fast_reg_page_list(ib_device, size);
-	if (IS_ERR(res->frpl)) {
-		ret = PTR_ERR(res->frpl);
-		iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n",
-			 ret);
-		return PTR_ERR(res->frpl);
-	}
-
 	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, size, 0);
 	if (IS_ERR(res->mr)) {
 		ret = PTR_ERR(res->mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
-		goto fast_reg_mr_failure;
+		return ret;
 	}
 	res->mr_valid = 1;
 
 	return 0;
-
-fast_reg_mr_failure:
-	ib_free_fast_reg_page_list(res->frpl);
-
-	return ret;
 }
 
 static void
 iser_free_reg_res(struct iser_reg_resources *rsc)
 {
 	ib_dereg_mr(rsc->mr);
-	ib_free_fast_reg_page_list(rsc->frpl);
 }
 
 static int
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
