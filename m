From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND for-3.10 1/3] IB/iser: Fix device removal flow
Date: Wed,  8 May 2013 15:21:17 +0300
Message-ID: <1368015679-15215-2-git-send-email-ogerlitz@mellanox.com>
References: <1368015679-15215-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368015679-15215-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change the code to destroy the "last opened" rdma_cm id after making sure
we released all other objects (QP,CQs,PD,etc) associated with the IB device.

Since iser accesses the IB device using the rdma_cm id, we need to free any
objects that are related to the device which is associated with the rdma_cm
id prior to destroying that id. When this isn't ensured, the low level driver
that created this device can be unloaded before iser has a chance to free
all the objects and a such a call may invoke code segment which isn't valid
any more and crash.

Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5278916..f13cc22 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -292,10 +292,10 @@ out_err:
 }
 
 /**
- * releases the FMR pool, QP and CMA ID objects, returns 0 on success,
+ * releases the FMR pool and QP objects, returns 0 on success,
  * -1 on failure
  */
-static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
+static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 {
 	int cq_index;
 	BUG_ON(ib_conn == NULL);
@@ -314,13 +314,9 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
 
 		rdma_destroy_qp(ib_conn->cma_id);
 	}
-	/* if cma handler context, the caller acts s.t the cma destroy the id */
-	if (ib_conn->cma_id != NULL && can_destroy_id)
-		rdma_destroy_id(ib_conn->cma_id);
 
 	ib_conn->fmr_pool = NULL;
 	ib_conn->qp	  = NULL;
-	ib_conn->cma_id   = NULL;
 	kfree(ib_conn->page_vec);
 
 	if (ib_conn->login_buf) {
@@ -415,11 +411,16 @@ static void iser_conn_release(struct iser_conn *ib_conn, int can_destroy_id)
 	list_del(&ib_conn->conn_list);
 	mutex_unlock(&ig.connlist_mutex);
 	iser_free_rx_descriptors(ib_conn);
-	iser_free_ib_conn_res(ib_conn, can_destroy_id);
+	iser_free_ib_conn_res(ib_conn);
 	ib_conn->device = NULL;
 	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
 	if (device != NULL)
 		iser_device_try_release(device);
+	/* if cma handler context, the caller actually destroy the id */
+	if (ib_conn->cma_id != NULL && can_destroy_id) {
+		rdma_destroy_id(ib_conn->cma_id);
+		ib_conn->cma_id = NULL;
+	}
 	iscsi_destroy_endpoint(ib_conn->ep);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
