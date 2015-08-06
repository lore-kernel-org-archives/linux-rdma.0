From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 06/22] IB/iser: Fix possible bogus DMA unmapping
Date: Thu,  6 Aug 2015 18:32:50 +0300
Message-ID: <1438875186-4310-7-git-send-email-sagig@mellanox.com>
References: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438875186-4310-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If iser_initialize_task_headers() routine failed before
dma mapping, we should not attempt to unmap in cleanup_task().

Fixes: 7414dde0a6c3a958e (IB/iser: Fix race between iser connection ...)
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 12 ++++++++----
 drivers/infiniband/ulp/iser/iscsi_iser.h |  2 ++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 92b1020..e3cea61 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -200,6 +200,7 @@ iser_initialize_task_headers(struct iscsi_task *task,
 		goto out;
 	}
 
+	tx_desc->mapped = true;
 	tx_desc->dma_addr = dma_addr;
 	tx_desc->tx_sg[0].addr   = tx_desc->dma_addr;
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
@@ -359,16 +360,19 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_tx_desc    *tx_desc   = &iser_task->desc;
-	struct iser_conn       *iser_conn	  = task->conn->dd_data;
+	struct iser_tx_desc *tx_desc = &iser_task->desc;
+	struct iser_conn *iser_conn = task->conn->dd_data;
 	struct iser_device *device = iser_conn->ib_conn.device;
 
 	/* DEVICE_REMOVAL event might have already released the device */
 	if (!device)
 		return;
 
-	ib_dma_unmap_single(device->ib_device,
-		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
+	if (likely(tx_desc->mapped)) {
+		ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
+				    ISER_HEADERS_LEN, DMA_TO_DEVICE);
+		tx_desc->mapped = false;
+	}
 
 	/* mgmt tasks do not need special cleanup */
 	if (!task->sc)
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 262ba1f..d2b6caf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -270,6 +270,7 @@ enum iser_desc_type {
  *                 sg[1] optionally points to either of immediate data
  *                 unsolicited data-out or control
  * @num_sge:       number sges used on this TX task
+ * @mapped:        Is the task header mapped
  */
 struct iser_tx_desc {
 	struct iser_hdr              iser_header;
@@ -278,6 +279,7 @@ struct iser_tx_desc {
 	u64		             dma_addr;
 	struct ib_sge		     tx_sg[2];
 	int                          num_sge;
+	bool			     mapped;
 };
 
 #define ISER_RX_PAD_SIZE	(256 - (ISER_RX_PAYLOAD_SIZE + \
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
