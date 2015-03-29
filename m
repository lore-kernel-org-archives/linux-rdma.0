From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/18] iser-target: Fix possible deadlock in RDMA_CM connection error
Date: Sun, 29 Mar 2015 15:52:04 +0300
Message-ID: <1427633540-30352-3-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before we reach to connection established we may get an
error event. In this case the core won't teardown this
connection (never established it), so we take care of freeing
it ourselves.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4b8d518..147029a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -222,7 +222,7 @@ fail:
 static void
 isert_free_rx_descriptors(struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
+	struct ib_device *ib_dev = isert_conn->conn_device->ib_device;
 	struct iser_rx_desc *rx_desc;
 	int i;
 
@@ -719,8 +719,8 @@ out:
 static void
 isert_connect_release(struct isert_conn *isert_conn)
 {
-	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct isert_device *device = isert_conn->conn_device;
+	struct ib_device *ib_dev = device->ib_device;
 
 	isert_dbg("conn %p\n", isert_conn);
 
@@ -728,7 +728,8 @@ isert_connect_release(struct isert_conn *isert_conn)
 		isert_conn_free_fastreg_pool(isert_conn);
 
 	isert_free_rx_descriptors(isert_conn);
-	rdma_destroy_id(isert_conn->conn_cm_id);
+	if (isert_conn->conn_cm_id)
+		rdma_destroy_id(isert_conn->conn_cm_id);
 
 	if (isert_conn->conn_qp) {
 		struct isert_comp *comp = isert_conn->conn_qp->recv_cq->cq_context;
@@ -878,12 +879,15 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 	return 0;
 }
 
-static void
+static int
 isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
+	isert_conn->conn_cm_id = NULL;
 	isert_put_conn(isert_conn);
+
+	return -1;
 }
 
 static int
@@ -912,7 +916,7 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
 	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
 	case RDMA_CM_EVENT_CONNECT_ERROR:
-		isert_connect_error(cma_id);
+		ret = isert_connect_error(cma_id);
 		break;
 	default:
 		isert_err("Unhandled RDMA CMA event: %d\n", event->event);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
