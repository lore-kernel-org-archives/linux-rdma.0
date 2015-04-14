From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v3 15/18] IB/iser: Pass struct iser_mem_reg to iser_fast_reg_mr and iser_reg_sig_mr
Date: Tue, 14 Apr 2015 18:08:25 +0300
Message-ID: <1429024108-7221-16-git-send-email-sagig@mellanox.com>
References: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024108-7221-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead of passing ib_sge as output variable, we pass the mem_reg
pointer to have the routines fill the rkey as well. This reduces
code duplication and extra assignments. This is a preparation step
to unify some registration logics together. Also, pass iser_fast_reg_mr
the fastreg descriptor directly.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   75 ++++++++++++----------------
 1 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 40d22d5..0575052 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -590,8 +590,10 @@ iser_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 
 static int
 iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
-		struct fast_reg_descriptor *desc, struct ib_sge *data_sge,
-		struct ib_sge *prot_sge, struct ib_sge *sig_sge)
+		struct fast_reg_descriptor *desc,
+		struct iser_mem_reg *data_reg,
+		struct iser_mem_reg *prot_reg,
+		struct iser_mem_reg *sig_reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_pi_context *pi_ctx = desc->pi_ctx;
@@ -615,12 +617,12 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	memset(&sig_wr, 0, sizeof(sig_wr));
 	sig_wr.opcode = IB_WR_REG_SIG_MR;
 	sig_wr.wr_id = ISER_FASTREG_LI_WRID;
-	sig_wr.sg_list = data_sge;
+	sig_wr.sg_list = &data_reg->sge;
 	sig_wr.num_sge = 1;
 	sig_wr.wr.sig_handover.sig_attrs = &sig_attrs;
 	sig_wr.wr.sig_handover.sig_mr = pi_ctx->sig_mr;
 	if (scsi_prot_sg_count(iser_task->sc))
-		sig_wr.wr.sig_handover.prot = prot_sge;
+		sig_wr.wr.sig_handover.prot = &prot_reg->sge;
 	sig_wr.wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE |
 					      IB_ACCESS_REMOTE_READ |
 					      IB_ACCESS_REMOTE_WRITE;
@@ -637,24 +639,24 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	}
 	desc->reg_indicators &= ~ISER_SIG_KEY_VALID;
 
-	sig_sge->lkey = pi_ctx->sig_mr->lkey;
-	sig_sge->addr = 0;
-	sig_sge->length = scsi_transfer_length(iser_task->sc);
+	sig_reg->sge.lkey = pi_ctx->sig_mr->lkey;
+	sig_reg->rkey = pi_ctx->sig_mr->rkey;
+	sig_reg->sge.addr = 0;
+	sig_reg->sge.length = scsi_transfer_length(iser_task->sc);
 
-	iser_dbg("sig_sge: addr: 0x%llx  length: %u lkey: 0x%x\n",
-		 sig_sge->addr, sig_sge->length,
-		 sig_sge->lkey);
+	iser_dbg("sig_sge: lkey: 0x%x, rkey: 0x%x, addr: 0x%llx, length: %u\n",
+		 sig_reg->sge.lkey, sig_reg->rkey, sig_reg->sge.addr,
+		 sig_reg->sge.length);
 err:
 	return ret;
 }
 
 static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
-			    struct iser_mem_reg *mem_reg,
 			    struct iser_data_buf *mem,
+			    struct fast_reg_descriptor *desc,
 			    enum iser_reg_indicator ind,
-			    struct ib_sge *sge)
+			    struct iser_mem_reg *reg)
 {
-	struct fast_reg_descriptor *desc = mem_reg->mem_h;
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 	struct ib_device *ibdev = device->ib_device;
@@ -668,12 +670,13 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	if (mem->dma_nents == 1) {
 		struct scatterlist *sg = mem->sg;
 
-		sge->lkey = device->mr->lkey;
-		sge->addr   = ib_sg_dma_address(ibdev, &sg[0]);
-		sge->length  = ib_sg_dma_len(ibdev, &sg[0]);
+		reg->sge.lkey = device->mr->lkey;
+		reg->rkey = device->mr->rkey;
+		reg->sge.addr = ib_sg_dma_address(ibdev, &sg[0]);
+		reg->sge.length = ib_sg_dma_len(ibdev, &sg[0]);
 
 		iser_dbg("Single DMA entry: lkey=0x%x, addr=0x%llx, length=0x%x\n",
-			 sge->lkey, sge->addr, sge->length);
+			 reg->sge.lkey, reg->sge.addr, reg->sge.length);
 		return 0;
 	}
 
@@ -723,9 +726,10 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	}
 	desc->reg_indicators &= ~ind;
 
-	sge->lkey = mr->lkey;
-	sge->addr = frpl->page_list[0] + offset;
-	sge->length = size;
+	reg->sge.lkey = mr->lkey;
+	reg->rkey = mr->rkey;
+	reg->sge.addr = frpl->page_list[0] + offset;
+	reg->sge.length = size;
 
 	return ret;
 }
@@ -745,7 +749,6 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_mem_reg *mem_reg = &iser_task->rdma_reg[cmd_dir];
 	struct fast_reg_descriptor *desc = NULL;
-	struct ib_sge data_sge;
 	int err, aligned_len;
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
@@ -764,15 +767,15 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		mem_reg->mem_h = desc;
 	}
 
-	err = iser_fast_reg_mr(iser_task, mem_reg, mem,
-			       ISER_DATA_KEY_VALID, &data_sge);
+	err = iser_fast_reg_mr(iser_task, mem, desc,
+			       ISER_DATA_KEY_VALID, mem_reg);
 	if (err)
 		goto err_reg;
 
 	if (scsi_get_prot_op(iser_task->sc) != SCSI_PROT_NORMAL) {
-		struct ib_sge prot_sge, sig_sge;
+		struct iser_mem_reg prot_reg;
 
-		memset(&prot_sge, 0, sizeof(prot_sge));
+		memset(&prot_reg, 0, sizeof(prot_reg));
 		if (scsi_prot_sg_count(iser_task->sc)) {
 			mem = &iser_task->prot[cmd_dir];
 			aligned_len = iser_data_buf_aligned_len(mem, ibdev);
@@ -785,33 +788,19 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 				}
 			}
 
-			err = iser_fast_reg_mr(iser_task, mem_reg, mem,
-					       ISER_PROT_KEY_VALID, &prot_sge);
+			err = iser_fast_reg_mr(iser_task, mem, desc,
+					       ISER_PROT_KEY_VALID, &prot_reg);
 			if (err)
 				goto err_reg;
 		}
 
-		err = iser_reg_sig_mr(iser_task, desc, &data_sge,
-				      &prot_sge, &sig_sge);
+		err = iser_reg_sig_mr(iser_task, desc, mem_reg,
+				      &prot_reg, mem_reg);
 		if (err) {
 			iser_err("Failed to register signature mr\n");
 			return err;
 		}
 		desc->reg_indicators |= ISER_FASTREG_PROTECTED;
-
-		mem_reg->sge.lkey = sig_sge.lkey;
-		mem_reg->rkey = desc->pi_ctx->sig_mr->rkey;
-		mem_reg->sge.addr = sig_sge.addr;
-		mem_reg->sge.length = sig_sge.length;
-	} else {
-		if (desc)
-			mem_reg->rkey = desc->data_mr->rkey;
-		else
-			mem_reg->rkey = device->mr->rkey;
-
-		mem_reg->sge.lkey = data_sge.lkey;
-		mem_reg->sge.addr = data_sge.addr;
-		mem_reg->sge.length = data_sge.length;
 	}
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
