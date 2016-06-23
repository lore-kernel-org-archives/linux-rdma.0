From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH] nvmet-rdma: Invoke fatal error on error completion
Date: Thu, 23 Jun 2016 20:01:30 +0300
Message-ID: <1466701290-10356-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In case we got an error completion the rdma queue pair
is in error state, teardown the entire controller. Note
that in recv or read error completion we might not have
a controller yet, so check for the controller exsistence.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b1c6e5bb0b70..f5986a7b776e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -134,6 +134,7 @@ static void nvmet_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc);
 static void nvmet_rdma_qp_event(struct ib_event *event, void *priv);
+static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue);
 
 static struct nvmet_fabrics_ops nvmet_rdma_ops;
 
@@ -486,12 +487,32 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	nvmet_rdma_put_rsp(rsp);
 }
 
+static void nvmet_rdma_error_comp(struct nvmet_rdma_queue *queue)
+{
+	if (queue->nvme_sq.ctrl)
+		nvmet_ctrl_fatal_error(queue->nvme_sq.ctrl);
+	else
+		/*
+		 * we didn't setup the controller yet in case
+		 * of admin connect error, just disconnect and
+		 * cleanup the queue
+		 */
+		nvmet_rdma_queue_disconnect(queue);
+}
+
 static void nvmet_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct nvmet_rdma_rsp *rsp =
 		container_of(wc->wr_cqe, struct nvmet_rdma_rsp, send_cqe);
 
 	nvmet_rdma_release_rsp(rsp);
+
+	if (unlikely(wc->status != IB_WC_SUCCESS &&
+		wc->status != IB_WC_WR_FLUSH_ERR)) {
+		pr_err("SEND for CQE 0x%p failed with status %s (%d).\n",
+			wc->wr_cqe, ib_wc_status_msg(wc->status), wc->status);
+		nvmet_rdma_error_comp(rsp->queue);
+	}
 }
 
 static void nvmet_rdma_queue_response(struct nvmet_req *req)
@@ -534,11 +555,13 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 			rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
 	rsp->n_rdma = 0;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS &&
-		wc->status != IB_WC_WR_FLUSH_ERR)) {
-		pr_info("RDMA READ for CQE 0x%p failed with status %s (%d).\n",
-			wc->wr_cqe, ib_wc_status_msg(wc->status), wc->status);
-		nvmet_req_complete(&rsp->req, NVME_SC_DATA_XFER_ERROR);
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		nvmet_rdma_release_rsp(rsp);
+		if (wc->status != IB_WC_WR_FLUSH_ERR) {
+			pr_info("RDMA READ for CQE 0x%p failed with status %s (%d).\n",
+				wc->wr_cqe, ib_wc_status_msg(wc->status), wc->status);
+			nvmet_rdma_error_comp(queue);
+		}
 		return;
 	}
 
@@ -705,13 +728,19 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct nvmet_rdma_queue *queue = cq->cq_context;
 	struct nvmet_rdma_rsp *rsp;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS))
+	if (unlikely(wc->status != IB_WC_SUCCESS)) {
+		if (wc->status != IB_WC_WR_FLUSH_ERR) {
+			pr_err("RECV for CQE 0x%p failed with status %s (%d)\n",
+				wc->wr_cqe, ib_wc_status_msg(wc->status),
+				wc->status);
+			nvmet_rdma_error_comp(queue);
+		}
 		return;
+	}
 
 	if (unlikely(wc->byte_len < sizeof(struct nvme_command))) {
 		pr_err("Ctrl Fatal Error: capsule size less than 64 bytes\n");
-		if (queue->nvme_sq.ctrl)
-			nvmet_ctrl_fatal_error(queue->nvme_sq.ctrl);
+		nvmet_rdma_error_comp(queue);
 		return;
 	}
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
