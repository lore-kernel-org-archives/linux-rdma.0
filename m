From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 08/22] IB/iser: Remove an unneeded print for unaligned memory
Date: Thu,  6 Aug 2015 18:32:52 +0300
Message-ID: <1438875186-4310-9-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We can do it in iser_aligned_data_len instead and
it will save us an argument that is passed to
fall_to_counce_buf just for the print.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 3129a42..56dd53b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -330,8 +330,11 @@ static int iser_data_buf_aligned_len(struct iser_data_buf *data,
 			break;
 	}
 	ret_len = (next_sg) ? i : i+1;
-	iser_dbg("Found %d aligned entries out of %d in sg:0x%p\n",
-		 ret_len, data->dma_nents, data);
+
+	if (unlikely(ret_len != data->dma_nents))
+		iser_warn("rdma alignment violation (%d/%d aligned)\n",
+			  ret_len, data->dma_nents);
+
 	return ret_len;
 }
 
@@ -407,15 +410,12 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 			      struct iser_data_buf *mem,
-			      enum iser_data_dir cmd_dir,
-			      int aligned_len)
+			      enum iser_data_dir cmd_dir)
 {
 	struct iscsi_conn *iscsi_conn = iser_task->iser_conn->iscsi_conn;
 	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 
 	iscsi_conn->fmr_unalign_cnt++;
-	iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
-		  aligned_len, mem->size);
 
 	if (iser_debug_level > 0)
 		iser_data_buf_dump(mem, device->ib_device);
@@ -537,8 +537,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, mem,
-					 cmd_dir, aligned_len);
+		err = fall_to_bounce_buf(iser_task, mem, cmd_dir);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
 			return err;
@@ -800,8 +799,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, mem,
-					 cmd_dir, aligned_len);
+		err = fall_to_bounce_buf(iser_task, mem, cmd_dir);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
 			return err;
@@ -828,7 +826,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 			aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 			if (aligned_len != mem->dma_nents) {
 				err = fall_to_bounce_buf(iser_task, mem,
-							 cmd_dir, aligned_len);
+							 cmd_dir);
 				if (err) {
 					iser_err("failed to allocate bounce buffer\n");
 					return err;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
