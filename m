From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 08/16] IB/iser: Fix race between iser connection teardown and scsi TMFs
Date: Sun,  7 Dec 2014 16:09:59 +0200
Message-ID: <1417961407-10139-9-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In certain scenarios (target kill with live IO) scsi TMFs may race
with iser RDMA teardown, which might cause NULL dereference on iser
IB device handle (which might have been freed). In this case we take
a conditional lock for TMFs and check the connection state (avoid
introducing lock contention in the IO path). This is indeed best effort
approach, but sufficient to survive multi targets sudden death while heavy
IO is inflight.

While we are on it, add a nice kernel-doc style documentation.

Reported-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   49 +++++++++++++++++++++++++-----
 1 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0b453e5..0c46f4a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -164,18 +164,42 @@ iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 	return 0;
 }
 
-int iser_initialize_task_headers(struct iscsi_task *task,
-						struct iser_tx_desc *tx_desc)
+/**
+ * iser_initialize_task_headers() - Initialize task headers
+ * @task:       iscsi task
+ * @tx_desc:    iser tx descriptor
+ *
+ * Notes:
+ * This routine may race with iser teardown flow for scsi
+ * error handling TMFs. So for TMF we should acquire the
+ * state mutex to avoid dereferencing the IB device which
+ * may have already been terminated.
+ */
+int
+iser_initialize_task_headers(struct iscsi_task *task,
+			     struct iser_tx_desc *tx_desc)
 {
-	struct iser_conn       *iser_conn   = task->conn->dd_data;
+	struct iser_conn *iser_conn = task->conn->dd_data;
 	struct iser_device *device = iser_conn->ib_conn.device;
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	u64 dma_addr;
+	const bool mgmt_task = !task->sc && !in_interrupt();
+	int ret = 0;
+
+	if (unlikely(mgmt_task))
+		mutex_lock(&iser_conn->state_mutex);
+
+	if (unlikely(iser_conn->state != ISER_CONN_UP)) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	dma_addr = ib_dma_map_single(device->ib_device, (void *)tx_desc,
 				ISER_HEADERS_LEN, DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(device->ib_device, dma_addr))
-		return -ENOMEM;
+	if (ib_dma_mapping_error(device->ib_device, dma_addr)) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
@@ -183,7 +207,11 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->tx_sg[0].lkey   = device->mr->lkey;
 
 	iser_task->iser_conn = iser_conn;
-	return 0;
+out:
+	if (unlikely(mgmt_task))
+		mutex_unlock(&iser_conn->state_mutex);
+
+	return ret;
 }
 
 /**
@@ -199,9 +227,14 @@ static int
 iscsi_iser_task_init(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
+	int ret;
 
-	if (iser_initialize_task_headers(task, &iser_task->desc))
-			return -ENOMEM;
+	ret = iser_initialize_task_headers(task, &iser_task->desc);
+	if (ret) {
+		iser_err("Failed to init task %p, err = %d\n",
+			 iser_task, ret);
+		return ret;
+	}
 
 	/* mgmt task */
 	if (!task->sc)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
