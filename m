From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 14/18] IB/iser: Modify struct iser_mem_reg members
Date: Tue, 31 Mar 2015 19:45:54 +0300
Message-ID: <1427820358-15087-15-git-send-email-sagig@mellanox.com>
References: <1427820358-15087-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427820358-15087-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to keep lkey, va, len variables, we can keep
them as struct ib_sge. This will help when we change the
memory registration logic.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   14 ++++-------
 drivers/infiniband/ulp/iser/iser_initiator.c |   18 +++++++-------
 drivers/infiniband/ulp/iser/iser_memory.c    |   30 +++++++++++++-------------
 3 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 185d2ec..5fd0963 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -247,18 +247,14 @@ struct iscsi_endpoint;
 /**
  * struct iser_mem_reg - iSER memory registration info
  *
- * @lkey:         MR local key
- * @rkey:         MR remote key
- * @va:           MR start address (buffer va)
- * @len:          MR length
+ * @sge:          memory region sg element
+ * @rkey:         memory region remote key
  * @mem_h:        pointer to registration context (FMR/Fastreg)
  */
 struct iser_mem_reg {
-	u32  lkey;
-	u32  rkey;
-	u64  va;
-	u64  len;
-	void *mem_h;
+	struct ib_sge	 sge;
+	u32		 rkey;
+	void		*mem_h;
 };
 
 enum iser_desc_type {
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 420a613..b2e3b77 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -82,11 +82,11 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 
 	hdr->flags    |= ISER_RSV;
 	hdr->read_stag = cpu_to_be32(mem_reg->rkey);
-	hdr->read_va   = cpu_to_be64(mem_reg->va);
+	hdr->read_va   = cpu_to_be64(mem_reg->sge.addr);
 
 	iser_dbg("Cmd itt:%d READ tags RKEY:%#.4X VA:%#llX\n",
 		 task->itt, mem_reg->rkey,
-		 (unsigned long long)mem_reg->va);
+		 (unsigned long long)mem_reg->sge.addr);
 
 	return 0;
 }
@@ -139,20 +139,20 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 	if (unsol_sz < edtl) {
 		hdr->flags     |= ISER_WSV;
 		hdr->write_stag = cpu_to_be32(mem_reg->rkey);
-		hdr->write_va   = cpu_to_be64(mem_reg->va + unsol_sz);
+		hdr->write_va   = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
 
 		iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
 			 "VA:%#llX + unsol:%d\n",
 			 task->itt, mem_reg->rkey,
-			 (unsigned long long)mem_reg->va, unsol_sz);
+			 (unsigned long long)mem_reg->sge.addr, unsol_sz);
 	}
 
 	if (imm_sz > 0) {
 		iser_dbg("Cmd itt:%d, WRITE, adding imm.data sz: %d\n",
 			 task->itt, imm_sz);
-		tx_dsg->addr   = mem_reg->va;
+		tx_dsg->addr = mem_reg->sge.addr;
 		tx_dsg->length = imm_sz;
-		tx_dsg->lkey   = mem_reg->lkey;
+		tx_dsg->lkey = mem_reg->sge.lkey;
 		iser_task->desc.num_sge = 2;
 	}
 
@@ -479,9 +479,9 @@ int iser_send_data_out(struct iscsi_conn *conn,
 
 	mem_reg = &iser_task->rdma_reg[ISER_DIR_OUT];
 	tx_dsg = &tx_desc->tx_sg[1];
-	tx_dsg->addr    = mem_reg->va + buf_offset;
-	tx_dsg->length  = data_seg_len;
-	tx_dsg->lkey    = mem_reg->lkey;
+	tx_dsg->addr = mem_reg->sge.addr + buf_offset;
+	tx_dsg->length = data_seg_len;
+	tx_dsg->lkey = mem_reg->sge.lkey;
 	tx_desc->num_sge = 2;
 
 	if (buf_offset + data_seg_len > iser_task->data[ISER_DIR_OUT].data_len) {
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 45f5120..40d22d5 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -400,10 +400,10 @@ int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		return ret;
 	}
 
-	mem_reg->lkey = fmr->fmr->lkey;
+	mem_reg->sge.lkey = fmr->fmr->lkey;
 	mem_reg->rkey = fmr->fmr->rkey;
-	mem_reg->va = page_vec->pages[0] + page_vec->offset;
-	mem_reg->len = page_vec->data_size;
+	mem_reg->sge.addr = page_vec->pages[0] + page_vec->offset;
+	mem_reg->sge.length = page_vec->data_size;
 	mem_reg->mem_h = fmr;
 
 	return 0;
@@ -479,17 +479,17 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1) {
 		sg = mem->sg;
 
-		mem_reg->lkey = device->mr->lkey;
+		mem_reg->sge.lkey = device->mr->lkey;
 		mem_reg->rkey = device->mr->rkey;
-		mem_reg->len  = ib_sg_dma_len(ibdev, &sg[0]);
-		mem_reg->va   = ib_sg_dma_address(ibdev, &sg[0]);
+		mem_reg->sge.length = ib_sg_dma_len(ibdev, &sg[0]);
+		mem_reg->sge.addr = ib_sg_dma_address(ibdev, &sg[0]);
 
 		iser_dbg("PHYSICAL Mem.register: lkey: 0x%08X rkey: 0x%08X  "
 			 "va: 0x%08lX sz: %ld]\n",
-			 (unsigned int)mem_reg->lkey,
+			 (unsigned int)mem_reg->sge.lkey,
 			 (unsigned int)mem_reg->rkey,
-			 (unsigned long)mem_reg->va,
-			 (unsigned long)mem_reg->len);
+			 (unsigned long)mem_reg->sge.addr,
+			 (unsigned long)mem_reg->sge.length);
 	} else { /* use FMR for multiple dma entries */
 		err = iser_reg_page_vec(iser_task, mem, ib_conn->fmr.page_vec,
 					mem_reg);
@@ -799,19 +799,19 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		}
 		desc->reg_indicators |= ISER_FASTREG_PROTECTED;
 
-		mem_reg->lkey = sig_sge.lkey;
+		mem_reg->sge.lkey = sig_sge.lkey;
 		mem_reg->rkey = desc->pi_ctx->sig_mr->rkey;
-		mem_reg->va = sig_sge.addr;
-		mem_reg->len = sig_sge.length;
+		mem_reg->sge.addr = sig_sge.addr;
+		mem_reg->sge.length = sig_sge.length;
 	} else {
 		if (desc)
 			mem_reg->rkey = desc->data_mr->rkey;
 		else
 			mem_reg->rkey = device->mr->rkey;
 
-		mem_reg->lkey = data_sge.lkey;
-		mem_reg->va = data_sge.addr;
-		mem_reg->len = data_sge.length;
+		mem_reg->sge.lkey = data_sge.lkey;
+		mem_reg->sge.addr = data_sge.addr;
+		mem_reg->sge.length = data_sge.length;
 	}
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
