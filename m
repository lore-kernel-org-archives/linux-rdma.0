From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 04/21] IB/iser: Extend iser_free_ib_conn_res
Date: Wed,  1 Oct 2014 14:02:00 +0300
Message-ID: <1412161337-25285-5-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Put all connection IB related resources release in this
routine. One exception is the cm_id which cannot be destroyed
as the routine is protected by the state mutex. Also move
its position to avoid forward declaration. While at nit fix qp
NULL assignment.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   58 +++++++++++++++--------------
 1 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index e69aba8..e429974 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -496,27 +496,6 @@ out_err:
 }
 
 /**
- * releases the QP object
- */
-static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
-{
-	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-
-	iser_info("freeing conn %p cma_id %p qp %p\n",
-		  ib_conn, ib_conn->cma_id,
-		  ib_conn->qp);
-
-	/* qp is created only once both addr & route are resolved */
-
-	if (ib_conn->qp != NULL) {
-		ib_conn->device->cq_active_qps[ib_conn->cq_index]--;
-		rdma_destroy_qp(ib_conn->cma_id);
-	}
-
-	ib_conn->qp	  = NULL;
-}
-
-/**
  * based on the resolved device node GUID see if there already allocated
  * device for this device. If there's no such, create one.
  */
@@ -608,12 +587,41 @@ void iser_release_work(struct work_struct *work)
 }
 
 /**
+ * iser_free_ib_conn_res - release IB related resources
+ * @iser_conn: iser connection struct
+ *
+ * This routine is called with the iser state mutex held
+ * so the cm_id removal is out of here. It is Safe to
+ * be invoked multiple times.
+ */
+static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
+{
+	struct ib_conn *ib_conn = &iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+
+	iser_info("freeing conn %p cma_id %p qp %p\n",
+		  iser_conn, ib_conn->cma_id, ib_conn->qp);
+
+	iser_free_rx_descriptors(iser_conn);
+
+	if (ib_conn->qp != NULL) {
+		ib_conn->device->cq_active_qps[ib_conn->cq_index]--;
+		rdma_destroy_qp(ib_conn->cma_id);
+		ib_conn->qp = NULL;
+	}
+
+	if (device != NULL) {
+		iser_device_try_release(device);
+		ib_conn->device = NULL;
+	}
+}
+
+/**
  * Frees all conn objects and deallocs conn descriptor
  */
 void iser_conn_release(struct iser_conn *iser_conn)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct iser_device  *device = ib_conn->device;
 
 	mutex_lock(&ig.connlist_mutex);
 	list_del(&iser_conn->conn_list);
@@ -621,13 +629,7 @@ void iser_conn_release(struct iser_conn *iser_conn)
 
 	mutex_lock(&iser_conn->state_mutex);
 	BUG_ON(iser_conn->state != ISER_CONN_DOWN);
-
-	iser_free_rx_descriptors(iser_conn);
 	iser_free_ib_conn_res(iser_conn);
-	ib_conn->device = NULL;
-	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
-	if (device != NULL)
-		iser_device_try_release(device);
 	mutex_unlock(&iser_conn->state_mutex);
 
 	if (ib_conn->cma_id != NULL) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
