From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: Replace global lock in rdma_destroy_id with id
 specific one
Date: Wed, 23 Feb 2011 09:05:39 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C54BC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_destroy_id currently uses the global rdma cm 'lock' to test if
an rdma_cm_id has been bound to a device.  This prevents an active
address resolution callback handler from assigning a device to the
rdma_cm_id after rdma_destroy_id checks for one.

Instead, we can replace the use of the global lock around the check
to the rdma_cm_id device pointer by setting the id state to destroying,
then flushing all active callbacks.  The latter is accomplished by
acquiring and releasing the handler_mutex.  Any active handler will
complete first, and any newly scheduled handlers will find the
rdma_cm_id in an invalid state.

In addition to optimizing the current locking scheme, the use of
the rdma_cm_id mutex is a more intuitive synchronization mechanism
than that of the global lock.  These changes are based on feedback
from Doug Ledford while he was trying to debug a crash in the rdma
cm destroy path.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This is targeted at 2.6.39

 drivers/infiniband/core/cma.c |   43 +++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e450c5a..5ed9d25 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -308,11 +308,13 @@ static inline void release_mc(struct kref *kref)
 	kfree(mc);
 }
 
-static void cma_detach_from_dev(struct rdma_id_private *id_priv)
+static void cma_release_dev(struct rdma_id_private *id_priv)
 {
+	mutex_lock(&lock);
 	list_del(&id_priv->list);
 	cma_deref_dev(id_priv->cma_dev);
 	id_priv->cma_dev = NULL;
+	mutex_unlock(&lock);
 }
 
 static int cma_set_qkey(struct rdma_id_private *id_priv)
@@ -373,6 +375,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
 		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
 
+	mutex_lock(&lock);
 	iboe_addr_get_sgid(dev_addr, &iboe_gid);
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
@@ -398,6 +401,7 @@ out:
 	if (!ret)
 		cma_attach_to_dev(id_priv, cma_dev);
 
+	mutex_unlock(&lock);
 	return ret;
 }
 
@@ -904,9 +908,14 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	state = cma_exch(id_priv, CMA_DESTROYING);
 	cma_cancel_operation(id_priv, state);
 
-	mutex_lock(&lock);
+	/*
+	 * Wait for any active callback to finish.  New callbacks will find
+	 * the id_priv state set to destroying and abort.
+	 */
+	mutex_lock(&id_priv->handler_mutex);
+	mutex_unlock(&id_priv->handler_mutex);
+
 	if (id_priv->cma_dev) {
-		mutex_unlock(&lock);
 		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
 		case RDMA_TRANSPORT_IB:
 			if (id_priv->cm_id.ib && !IS_ERR(id_priv->cm_id.ib))
@@ -920,10 +929,8 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 			break;
 		}
 		cma_leave_mc_groups(id_priv);
-		mutex_lock(&lock);
-		cma_detach_from_dev(id_priv);
+		cma_release_dev(id_priv);
 	}
-	mutex_unlock(&lock);
 
 	cma_release_port(id_priv);
 	cma_deref_id(id_priv);
@@ -1200,9 +1207,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	}
 
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
-	mutex_lock(&lock);
 	ret = cma_acquire_dev(conn_id);
-	mutex_unlock(&lock);
 	if (ret)
 		goto release_conn_id;
 
@@ -1401,9 +1406,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		goto out;
 	}
 
-	mutex_lock(&lock);
 	ret = cma_acquire_dev(conn_id);
-	mutex_unlock(&lock);
 	if (ret) {
 		mutex_unlock(&conn_id->handler_mutex);
 		rdma_destroy_id(new_cm_id);
@@ -1966,20 +1969,11 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 
 	memset(&event, 0, sizeof event);
 	mutex_lock(&id_priv->handler_mutex);
-
-	/*
-	 * Grab mutex to block rdma_destroy_id() from removing the device while
-	 * we're trying to acquire it.
-	 */
-	mutex_lock(&lock);
-	if (!cma_comp_exch(id_priv, CMA_ADDR_QUERY, CMA_ADDR_RESOLVED)) {
-		mutex_unlock(&lock);
+	if (!cma_comp_exch(id_priv, CMA_ADDR_QUERY, CMA_ADDR_RESOLVED))
 		goto out;
-	}
 
 	if (!status && !id_priv->cma_dev)
 		status = cma_acquire_dev(id_priv);
-	mutex_unlock(&lock);
 
 	if (status) {
 		if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ADDR_BOUND))
@@ -2280,9 +2274,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 		if (ret)
 			goto err1;
 
-		mutex_lock(&lock);
 		ret = cma_acquire_dev(id_priv);
-		mutex_unlock(&lock);
 		if (ret)
 			goto err1;
 	}
@@ -2294,11 +2286,8 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 
 	return 0;
 err2:
-	if (id_priv->cma_dev) {
-		mutex_lock(&lock);
-		cma_detach_from_dev(id_priv);
-		mutex_unlock(&lock);
-	}
+	if (id_priv->cma_dev)
+		cma_release_dev(id_priv);
 err1:
 	cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_IDLE);
 	return ret;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
