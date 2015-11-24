From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 03/10] IB/iser: Don't register memory for all immediatedata writes
Date: Tue, 24 Nov 2015 18:23:47 +0200
Message-ID: <1448382234-24806-4-git-send-email-sagig@mellanox.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

When all the task data is sent as immeidatedata, we are
allowed to use the local_dma_lkey as it is not sent to
the wire. In the long run we'd really need to rework
the memory registration flow only when we need rkeys.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  3 ++-
 drivers/infiniband/ulp/iser/iser_initiator.c |  5 +++--
 drivers/infiniband/ulp/iser/iser_memory.c    | 13 +++++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 233ec0c2ae3d..7b5cf1332ddb 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -650,7 +650,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
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
index b7a2b88f48ce..62d0578388d3 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -190,7 +190,11 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	struct scatterlist *sg = mem->sg;
 
 	reg->sge.lkey = device->pd->local_dma_lkey;
-	reg->rkey = device->mr->rkey;
+	/*
+	 * FIXME: rework the registration code path to differentiate
+	 * rkey/lkey use cases
+	 */
+	reg->rkey = device->mr ? device->mr->rkey : 0;
 	reg->sge.addr = ib_sg_dma_address(device->ib_device, &sg[0]);
 	reg->sge.length = ib_sg_dma_len(device->ib_device, &sg[0]);
 
@@ -495,7 +499,8 @@ iser_reg_data_sg(struct iscsi_iser_task *task,
 }
 
 int iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		      enum iser_data_dir dir)
+		      enum iser_data_dir dir,
+		      bool all_imm)
 {
 	struct ib_conn *ib_conn = &task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -506,8 +511,8 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
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
