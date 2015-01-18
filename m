From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for-3.19 1/2] IB/iser: Fix memory regions possible leak
Date: Sun, 18 Jan 2015 16:51:06 +0200
Message-ID: <1421592667-4099-2-git-send-email-sagig@mellanox.com>
References: <1421592667-4099-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421592667-4099-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When teardown process initiates during live IO, we need
to keep the memory regions pool (frmr/fmr) until all
inflight tasks are properly released, since each task
may return a memory region to the pool. In order to
do this, we pass a destroy flag to iser_free_ib_conn_res
to indicate we can destroy the device and the memory regions
pool. iser_conn_release will pass it as true and also
DEVICE_REMOVAL event (we need to let the device to properly
remove).

Also, Since we conditionally call iser_free_rx_descriptors,
remove the extra check on iser_conn->rx_descs.

Fixes: 5426b1 "IB/iser: Collapse cleanup and disconnect handlers"
Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |  4 ----
 drivers/infiniband/ulp/iser/iser_verbs.c     | 25 ++++++++++++++-----------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 3821633..de382af 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -320,9 +320,6 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 
-	if (!iser_conn->rx_descs)
-		goto free_login_buf;
-
 	if (device->iser_free_rdma_reg_res)
 		device->iser_free_rdma_reg_res(ib_conn);
 
@@ -334,7 +331,6 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 	/* make sure we never redo any unmapping */
 	iser_conn->rx_descs = NULL;
 
-free_login_buf:
 	iser_free_login_buf(iser_conn);
 }
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 695a270..f3e21ab 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -600,16 +600,16 @@ void iser_release_work(struct work_struct *work)
 /**
  * iser_free_ib_conn_res - release IB related resources
  * @iser_conn: iser connection struct
- * @destroy_device: indicator if we need to try to release
- *     the iser device (only iscsi shutdown and DEVICE_REMOVAL
- *     will use this.
+ * @destroy: indicator if we need to try to release the
+ *     iser device and memory regoins pool (only iscsi
+ *     shutdown and DEVICE_REMOVAL will use this).
  *
  * This routine is called with the iser state mutex held
  * so the cm_id removal is out of here. It is Safe to
  * be invoked multiple times.
  */
 static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
-				  bool destroy_device)
+				  bool destroy)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -617,17 +617,20 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
 	iser_info("freeing conn %p cma_id %p qp %p\n",
 		  iser_conn, ib_conn->cma_id, ib_conn->qp);
 
-	iser_free_rx_descriptors(iser_conn);
-
 	if (ib_conn->qp != NULL) {
 		ib_conn->comp->active_qps--;
 		rdma_destroy_qp(ib_conn->cma_id);
 		ib_conn->qp = NULL;
 	}
 
-	if (destroy_device && device != NULL) {
-		iser_device_try_release(device);
-		ib_conn->device = NULL;
+	if (destroy) {
+		if (iser_conn->rx_descs)
+			iser_free_rx_descriptors(iser_conn);
+
+		if (device != NULL) {
+			iser_device_try_release(device);
+			ib_conn->device = NULL;
+		}
 	}
 }
 
@@ -840,7 +843,7 @@ static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 }
 
 static void iser_cleanup_handler(struct rdma_cm_id *cma_id,
-				 bool destroy_device)
+				 bool destroy)
 {
 	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
 
@@ -850,7 +853,7 @@ static void iser_cleanup_handler(struct rdma_cm_id *cma_id,
 	 * and flush errors.
 	 */
 	iser_disconnected_handler(cma_id);
-	iser_free_ib_conn_res(iser_conn, destroy_device);
+	iser_free_ib_conn_res(iser_conn, destroy);
 	complete(&iser_conn->ib_completion);
 };
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
