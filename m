From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 06/18] IB/iser: Don't pass ib_device to fall_to_bounce_buff routine
Date: Sun, 29 Mar 2015 15:45:20 +0300
Message-ID: <1427633132-23910-7-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to pass that, we can take it from the task.
In a later stage, this function will be invoked
according to a device capability.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index beeabd0..9c60ff1 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -334,19 +334,19 @@ void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
 }
 
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
-			      struct ib_device *ibdev,
 			      struct iser_data_buf *mem,
 			      enum iser_data_dir cmd_dir,
 			      int aligned_len)
 {
-	struct iscsi_conn    *iscsi_conn = iser_task->iser_conn->iscsi_conn;
+	struct iscsi_conn *iscsi_conn = iser_task->iser_conn->iscsi_conn;
+	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 
 	iscsi_conn->fmr_unalign_cnt++;
 	iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
 		  aligned_len, mem->size);
 
 	if (iser_debug_level > 0)
-		iser_data_buf_dump(mem, ibdev);
+		iser_data_buf_dump(mem, device->ib_device);
 
 	/* unmap the command data before accessing it */
 	iser_dma_unmap_task_data(iser_task, mem,
@@ -384,7 +384,7 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, ibdev, mem,
+		err = fall_to_bounce_buf(iser_task, mem,
 					 cmd_dir, aligned_len);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
@@ -669,7 +669,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
-		err = fall_to_bounce_buf(iser_task, ibdev, mem,
+		err = fall_to_bounce_buf(iser_task, mem,
 					 cmd_dir, aligned_len);
 		if (err) {
 			iser_err("failed to allocate bounce buffer\n");
@@ -700,7 +700,7 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 			mem = &iser_task->prot[cmd_dir];
 			aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 			if (aligned_len != mem->dma_nents) {
-				err = fall_to_bounce_buf(iser_task, ibdev, mem,
+				err = fall_to_bounce_buf(iser_task, mem,
 							 cmd_dir, aligned_len);
 				if (err) {
 					iser_err("failed to allocate bounce buffer\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
