From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 4/6] iser-target: Align to generic logging helpers
Date: Mon, 18 May 2015 13:40:31 +0300
Message-ID: <1431945633-18401-5-git-send-email-sagig@mellanox.com>
References: <1431945633-18401-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431945633-18401-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 327529e..d99a0c8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -78,7 +78,9 @@ isert_qp_event_callback(struct ib_event *e, void *context)
 {
 	struct isert_conn *isert_conn = context;
 
-	isert_err("conn %p event: %d\n", isert_conn, e->event);
+	isert_err("%s (%d): conn %p\n",
+		  ib_event_msg(e->event), e->event, isert_conn);
+
 	switch (e->event) {
 	case IB_EVENT_COMM_EST:
 		rdma_notify(isert_conn->cm_id, IB_EVENT_COMM_EST);
@@ -897,7 +899,8 @@ static int
 isert_np_cma_handler(struct isert_np *isert_np,
 		     enum rdma_cm_event_type event)
 {
-	isert_dbg("isert np %p, handling event %d\n", isert_np, event);
+	isert_dbg("%s (%d): isert np %p\n",
+		  rdma_event_msg(event), event, isert_np);
 
 	switch (event) {
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -957,7 +960,8 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	int ret = 0;
 
-	isert_info("event %d status %d id %p np %p\n", event->event,
+	isert_info("%s (%d): status %d id %p np %p\n",
+		   rdma_event_msg(event->event), event->event,
 		   event->status, cma_id, cma_id->context);
 
 	switch (event->event) {
@@ -2091,10 +2095,13 @@ isert_handle_wc(struct ib_wc *wc)
 		}
 	} else {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			isert_err("wr id %llx status %d vend_err %x\n",
-				  wc->wr_id, wc->status, wc->vendor_err);
+			isert_err("%s (%d): wr id %llx vend_err %x\n",
+				  ib_wc_status_msg(wc->status), wc->status,
+				  wc->wr_id, wc->vendor_err);
 		else
-			isert_dbg("flush error: wr id %llx\n", wc->wr_id);
+			isert_dbg("%s (%d): wr id %llx\n",
+				  ib_wc_status_msg(wc->status), wc->status,
+				  wc->wr_id);
 
 		if (wc->wr_id != ISER_FASTREG_LI_WRID)
 			isert_cq_comp_err(isert_conn, wc);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
