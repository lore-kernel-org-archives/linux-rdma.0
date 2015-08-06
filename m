From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 16/22] IB/iser: Rename iser_reg_page_vec to iser_fast_reg_fmr
Date: Thu,  6 Aug 2015 18:33:00 +0300
Message-ID: <1438875186-4310-17-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Also, change a name of a local variable.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index d0c01e1..11bba5a 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -476,10 +476,10 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
  * returns: 0 on success, errno code on failure
  */
 static
-int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
+int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 		      struct iser_data_buf *mem,
 		      struct iser_reg_resources *rsc,
-		      struct iser_mem_reg *mem_reg)
+		      struct iser_mem_reg *reg)
 {
 	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -510,11 +510,11 @@ int iser_reg_page_vec(struct iscsi_iser_task *iser_task,
 		return ret;
 	}
 
-	mem_reg->sge.lkey = fmr->fmr->lkey;
-	mem_reg->rkey = fmr->fmr->rkey;
-	mem_reg->sge.addr = page_vec->pages[0] + page_vec->offset;
-	mem_reg->sge.length = page_vec->data_size;
-	mem_reg->mem_h = fmr;
+	reg->sge.lkey = fmr->fmr->lkey;
+	reg->rkey = fmr->fmr->rkey;
+	reg->sge.addr = page_vec->pages[0] + page_vec->offset;
+	reg->sge.length = page_vec->data_size;
+	reg->mem_h = fmr;
 
 	return 0;
 }
@@ -592,7 +592,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 
 		desc = list_first_entry(&fr_pool->list,
 					struct iser_fr_desc, list);
-		err = iser_reg_page_vec(iser_task, mem, &desc->rsc, mem_reg);
+		err = iser_fast_reg_fmr(iser_task, mem, &desc->rsc, mem_reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
