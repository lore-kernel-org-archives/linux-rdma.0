From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] ib/iser: issue dma unmapping on the tx bufs used for
 the iscsi/iser headers
Date: Fri, 4 Nov 2011 00:21:27 +0200
Message-ID: <alpine.LRH.2.00.1111040020530.9030@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1111040013260.9030@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1111040013260.9030-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current driver never does DMA unmapping on these buffers. Fix that
by adding dma unmapping to the task cleanup callback, and dma mapping to
the task init function (drop the headers_initialized micro-optimization).

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   11 ++++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    1 -
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 84e8c29..c42b8f3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -151,7 +151,6 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
 	tx_desc->tx_sg[0].lkey   = device->mr->lkey;

-	iser_task->headers_initialized	= 1;
 	iser_task->iser_conn		= iser_conn;
 	return 0;
 }
@@ -166,8 +165,7 @@ iscsi_iser_task_init(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;

-	if (!iser_task->headers_initialized)
-		if (iser_initialize_task_headers(task, &iser_task->desc))
+	if (iser_initialize_task_headers(task, &iser_task->desc))
 			return -ENOMEM;

 	/* mgmt task */
@@ -278,6 +276,13 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
+	struct iser_tx_desc	*tx_desc = &iser_task->desc;
+
+	struct iscsi_iser_conn *iser_conn = task->conn->dd_data;
+	struct iser_device     *device    = iser_conn->ib_conn->device;
+
+	ib_dma_unmap_single(device->ib_device,
+		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);

 	/* mgmt tasks do not need special cleanup */
 	if (!task->sc)
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 2982a14..db7ea37 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -278,7 +278,6 @@ struct iscsi_iser_task {
 	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];/* regd rdma buf */
 	struct iser_data_buf         data[ISER_DIRS_NUM];     /* orig. data des*/
 	struct iser_data_buf         data_copy[ISER_DIRS_NUM];/* contig. copy  */
-	int                          headers_initialized;
 };

 struct iser_page_vec {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
