From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 3/6] IB/iser: Align to generic logging helpers
Date: Mon, 18 May 2015 13:40:30 +0300
Message-ID: <1431945633-18401-4-git-send-email-sagig@mellanox.com>
References: <1431945633-18401-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431945633-18401-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index cc2dd35..d33c5c0 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -51,19 +51,22 @@ static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
-	iser_err("got cq event %d \n", cause->event);
+	iser_err("cq event %s (%d)\n",
+		 ib_event_msg(cause->event), cause->event);
 }
 
 static void iser_qp_event_callback(struct ib_event *cause, void *context)
 {
-	iser_err("got qp event %d\n",cause->event);
+	iser_err("qp event %s (%d)\n",
+		 ib_event_msg(cause->event), cause->event);
 }
 
 static void iser_event_handler(struct ib_event_handler *handler,
 				struct ib_event *event)
 {
-	iser_err("async event %d on device %s port %d\n", event->event,
-		event->device->name, event->element.port_num);
+	iser_err("async event %s (%d) on device %s port %d\n",
+		 ib_event_msg(event->event), event->event,
+		 event->device->name, event->element.port_num);
 }
 
 /**
@@ -873,8 +876,9 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 	int ret = 0;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
-	iser_info("event %d status %d conn %p id %p\n",
-		  event->event, event->status, cma_id->context, cma_id);
+	iser_info("%s (%d): status %d conn %p id %p\n",
+		  rdma_event_msg(event->event), event->event,
+		  event->status, cma_id->context, cma_id);
 
 	mutex_lock(&iser_conn->state_mutex);
 	switch (event->event) {
@@ -913,7 +917,8 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		}
 		break;
 	default:
-		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
+		iser_err("Unexpected RDMA CM event: %s (%d)\n",
+			 rdma_event_msg(event->event), event->event);
 		break;
 	}
 	mutex_unlock(&iser_conn->state_mutex);
@@ -1173,10 +1178,13 @@ static void iser_handle_wc(struct ib_wc *wc)
 		}
 	} else {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			iser_err("wr id %llx status %d vend_err %x\n",
-				 wc->wr_id, wc->status, wc->vendor_err);
+			iser_err("%s (%d): wr id %llx vend_err %x\n",
+				 ib_wc_status_msg(wc->status), wc->status,
+				 wc->wr_id, wc->vendor_err);
 		else
-			iser_dbg("flush error: wr id %llx\n", wc->wr_id);
+			iser_dbg("%s (%d): wr id %llx\n",
+				 ib_wc_status_msg(wc->status), wc->status,
+				 wc->wr_id);
 
 		if (wc->wr_id == ISER_BEACON_WRID)
 			/* all flush errors were consumed */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
