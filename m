From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 03/10] IB/iser: Don't register memory for all immediatedata writes
Date: Mon, 16 Nov 2015 18:37:34 +0200
Message-ID: <1447691861-3796-4-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When all the task data is sent as immeidatedata, we are
allowed to use the local_dma_lkey as it is not sent to
the wire.

Signed-off-by: Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 3 ++-
 drivers/infiniband/ulp/iser/iser_initiator.c | 5 +++--
 drivers/infiniband/ulp/iser/iser_memory.c    | 9 +++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8a5998e6a407..fb7fa7aa113c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -651,7 +651,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     enum iser_data_dir cmd_dir);
 
 int iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		      enum iser_data_dir dir);
+		      enum iser_data_dir dir,
+		      bool all_imm);
 void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
 			 enum iser_data_dir dir);
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index ffd00c420729..07bf26427ee7 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -72,7 +72,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 			return err;
 	}
 
-	err = iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
+	err = iser_reg_rdma_mem(iser_task, ISER_DIR_IN, false);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
@@ -126,7 +126,8 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	err = iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
+	err = iser_reg_rdma_mem(iser_task, ISER_DIR_OUT,
+				buf_out->data_len == imm_sz);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 1103aa6e8d00..e500d0df7b85 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -250,7 +250,7 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	struct scatterlist *sg = mem->sg;
 
 	reg->sge.lkey = device->pd->local_dma_lkey;
-	reg->rkey = device->mr->rkey;
+	reg->rkey = device->mr ? device->mr->rkey : 0;
 	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
 	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
 
@@ -553,7 +553,8 @@ iser_reg_data_sg(struct iscsi_iser_task *task,
 }
 
 int iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		      enum iser_data_dir dir)
+		      enum iser_data_dir dir,
+		      bool all_imm)
 {
 	struct ib_conn *ib_conn = &task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -564,8 +565,8 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 	bool use_dma_key;
 	int err;
 
-	use_dma_key = (mem->dma_nents == 1 && !iser_always_reg &&
-		       scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL);
+	use_dma_key = mem->dma_nents == 1 && (all_imm || !iser_always_reg) &&
+		      scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL;
 
 	if (!use_dma_key) {
 		desc = device->reg_ops->reg_desc_get(ib_conn);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
