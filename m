From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 11/16] IB/iser: Remove redundant is_mr indicator
Date: Sun,  7 Dec 2014 16:10:02 +0200
Message-ID: <1417961407-10139-12-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It is enough to check mem_h pointer assignment, mem_h == NULL
will indicate that buffer is not registered using mr.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    2 --
 drivers/infiniband/ulp/iser/iser_memory.c |    9 ++-------
 drivers/infiniband/ulp/iser/iser_verbs.c  |    6 ++----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8a5663d..e34263c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -252,7 +252,6 @@ struct iscsi_endpoint;
  * @va:           MR start address (buffer va)
  * @len:          MR length
  * @mem_h:        pointer to registration context (FMR/Fastreg)
- * @is_mr:        indicates weather we registered the buffer
  */
 struct iser_mem_reg {
 	u32  lkey;
@@ -260,7 +259,6 @@ struct iser_mem_reg {
 	u64  va;
 	u64  len;
 	void *mem_h;
-	int  is_mr;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index a70fd9a..d832705 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -408,7 +408,6 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 		regd_buf->reg.rkey = device->mr->rkey;
 		regd_buf->reg.len  = ib_sg_dma_len(ibdev, &sg[0]);
 		regd_buf->reg.va   = ib_sg_dma_address(ibdev, &sg[0]);
-		regd_buf->reg.is_mr = 0;
 
 		iser_dbg("PHYSICAL Mem.register: lkey: 0x%08X rkey: 0x%08X  "
 			 "va: 0x%08lX sz: %ld]\n",
@@ -769,15 +768,11 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		regd_buf->reg.rkey = desc->pi_ctx->sig_mr->rkey;
 		regd_buf->reg.va = sig_sge.addr;
 		regd_buf->reg.len = sig_sge.length;
-		regd_buf->reg.is_mr = 1;
 	} else {
-		if (desc) {
+		if (desc)
 			regd_buf->reg.rkey = desc->data_mr->rkey;
-			regd_buf->reg.is_mr = 1;
-		} else {
+		else
 			regd_buf->reg.rkey = device->mr->rkey;
-			regd_buf->reg.is_mr = 0;
-		}
 
 		regd_buf->reg.lkey = data_sge.lkey;
 		regd_buf->reg.va = data_sge.addr;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index fb5ec35..ad493d2 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1009,7 +1009,6 @@ int iser_reg_page_vec(struct ib_conn *ib_conn,
 	mem_reg->rkey  = mem->fmr->rkey;
 	mem_reg->len   = page_vec->length * SIZE_4K;
 	mem_reg->va    = io_addr;
-	mem_reg->is_mr = 1;
 	mem_reg->mem_h = (void *)mem;
 
 	mem_reg->va   += page_vec->offset;
@@ -1036,7 +1035,7 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	int ret;
 
-	if (!reg->is_mr)
+	if (!reg->mem_h)
 		return;
 
 	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n",reg->mem_h);
@@ -1056,11 +1055,10 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct fast_reg_descriptor *desc = reg->mem_h;
 
-	if (!reg->is_mr)
+	if (!desc)
 		return;
 
 	reg->mem_h = NULL;
-	reg->is_mr = 0;
 	spin_lock_bh(&ib_conn->lock);
 	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
 	spin_unlock_bh(&ib_conn->lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
