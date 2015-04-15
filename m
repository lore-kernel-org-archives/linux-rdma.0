From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/iser: Fix regression in DIX mode fast registration flow
Date: Wed, 15 Apr 2015 13:50:14 +0300
Message-ID: <1429095014-21789-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix a wrong setting for a single DMA entry. This
is menifested only in DIX mode where the protection
information buffer reg info overrides the data buffer
reg info.

Fixes: 6e19ed0dba03 ("IB/iser: Pass struct iser_mem_reg to [...]")
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Roland,

This patch is incremental to "iser patches for kernel 4.1 [v2]"
so just in case you have [v2] applied and it's easier for you
to apply this instead (although the fixed commit-id needs to
be altered).

 drivers/infiniband/ulp/iser/iser_memory.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f90d6de..f0cdc96 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -710,12 +710,11 @@ err:
 }
 
 static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
-			    struct iser_mem_reg *mem_reg,
 			    struct iser_data_buf *mem,
+			    struct fast_reg_descriptor *desc,
 			    enum iser_reg_indicator ind,
 			    struct iser_mem_reg *reg)
 {
-	struct fast_reg_descriptor *desc = mem_reg->mem_h;
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 	struct ib_mr *mr;
@@ -726,7 +725,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	/* if there a single dma entry, dma mr suffices */
 	if (mem->dma_nents == 1)
-		return iser_reg_dma(device, mem, mem_reg);
+		return iser_reg_dma(device, mem, reg);
 
 	if (ind == ISER_DATA_KEY_VALID) {
 		mr = desc->data_mr;
@@ -815,7 +814,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		mem_reg->mem_h = desc;
 	}
 
-	err = iser_fast_reg_mr(iser_task, mem_reg, mem,
+	err = iser_fast_reg_mr(iser_task, mem, desc,
 			       ISER_DATA_KEY_VALID, mem_reg);
 	if (err)
 		goto err_reg;
@@ -836,7 +835,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 				}
 			}
 
-			err = iser_fast_reg_mr(iser_task, mem_reg, mem,
+			err = iser_fast_reg_mr(iser_task, mem, desc,
 					       ISER_PROT_KEY_VALID, &prot_reg);
 			if (err)
 				goto err_reg;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
