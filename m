From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/cma: Make the code easier to verify
Date: Fri, 10 Jun 2016 11:08:25 -0700
Message-ID: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Static source code analysis tools like smatch cannot handle functions
that lock or not lock a mutex depending on the value of the arguments.
Hence inline the function cma_disable_callback(). Additionally, this
patch realizes a small performance optimization by reducing the number of
mutex_lock() and mutex_unlock() calls in the modified functions. With
this patch applied smatch no longer complains about source file cma.c.
Without this patch smatch reports the following for this source file:

drivers/infiniband/core/cma.c:1959: cma_req_handler() warn: inconsistent returns 'mutex:&listen_id->handler_mutex'.
  Locked on:   line 1880
               line 1959
  Unlocked on: line 1941
drivers/infiniband/core/cma.c:2112: iw_conn_req_handler() warn: inconsistent returns 'mutex:&listen_id->handler_mutex'.
  Locked on:   line 2048
  Unlocked on: line 2112

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 54 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f0c91ba..c58ee77 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -708,17 +708,6 @@ static void cma_deref_id(struct rdma_id_private *id_priv)
 		complete(&id_priv->comp);
 }
 
-static int cma_disable_callback(struct rdma_id_private *id_priv,
-				enum rdma_cm_state state)
-{
-	mutex_lock(&id_priv->handler_mutex);
-	if (id_priv->state != state) {
-		mutex_unlock(&id_priv->handler_mutex);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 struct rdma_cm_id *rdma_create_id(struct net *net,
 				  rdma_cm_event_handler event_handler,
 				  void *context, enum rdma_port_space ps,
@@ -1671,11 +1660,12 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	struct rdma_cm_event event;
 	int ret = 0;
 
+	mutex_lock(&id_priv->handler_mutex);
 	if ((ib_event->event != IB_CM_TIMEWAIT_EXIT &&
-		cma_disable_callback(id_priv, RDMA_CM_CONNECT)) ||
+	     id_priv->state != RDMA_CM_CONNECT) ||
 	    (ib_event->event == IB_CM_TIMEWAIT_EXIT &&
-		cma_disable_callback(id_priv, RDMA_CM_DISCONNECT)))
-		return 0;
+	     id_priv->state != RDMA_CM_DISCONNECT))
+		goto out;
 
 	memset(&event, 0, sizeof event);
 	switch (ib_event->event) {
@@ -1870,7 +1860,7 @@ static int cma_check_req_qp_type(struct rdma_cm_id *id, struct ib_cm_event *ib_e
 
 static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 {
-	struct rdma_id_private *listen_id, *conn_id;
+	struct rdma_id_private *listen_id, *conn_id = NULL;
 	struct rdma_cm_event event;
 	struct net_device *net_dev;
 	int offset, ret;
@@ -1884,9 +1874,10 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		goto net_dev_put;
 	}
 
-	if (cma_disable_callback(listen_id, RDMA_CM_LISTEN)) {
+	mutex_lock(&listen_id->handler_mutex);
+	if (listen_id->state != RDMA_CM_LISTEN) {
 		ret = -ECONNABORTED;
-		goto net_dev_put;
+		goto err1;
 	}
 
 	memset(&event, 0, sizeof event);
@@ -1976,8 +1967,9 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 	struct sockaddr *laddr = (struct sockaddr *)&iw_event->local_addr;
 	struct sockaddr *raddr = (struct sockaddr *)&iw_event->remote_addr;
 
-	if (cma_disable_callback(id_priv, RDMA_CM_CONNECT))
-		return 0;
+	mutex_lock(&id_priv->handler_mutex);
+	if (id_priv->state != RDMA_CM_CONNECT)
+		goto out;
 
 	memset(&event, 0, sizeof event);
 	switch (iw_event->event) {
@@ -2029,6 +2021,7 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 		return ret;
 	}
 
+out:
 	mutex_unlock(&id_priv->handler_mutex);
 	return ret;
 }
@@ -2039,13 +2032,15 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	struct rdma_cm_id *new_cm_id;
 	struct rdma_id_private *listen_id, *conn_id;
 	struct rdma_cm_event event;
-	int ret;
+	int ret = -ECONNABORTED;
 	struct sockaddr *laddr = (struct sockaddr *)&iw_event->local_addr;
 	struct sockaddr *raddr = (struct sockaddr *)&iw_event->remote_addr;
 
 	listen_id = cm_id->context;
-	if (cma_disable_callback(listen_id, RDMA_CM_LISTEN))
-		return -ECONNABORTED;
+
+	mutex_lock(&listen_id->handler_mutex);
+	if (listen_id->state != RDMA_CM_LISTEN)
+		goto out;
 
 	/* Create a new RDMA id for the new IW CM ID */
 	new_cm_id = rdma_create_id(listen_id->id.route.addr.dev_addr.net,
@@ -3216,8 +3211,9 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 	struct ib_cm_sidr_rep_event_param *rep = &ib_event->param.sidr_rep_rcvd;
 	int ret = 0;
 
-	if (cma_disable_callback(id_priv, RDMA_CM_CONNECT))
-		return 0;
+	mutex_lock(&id_priv->handler_mutex);
+	if (id_priv->state != RDMA_CM_CONNECT)
+		goto out;
 
 	memset(&event, 0, sizeof event);
 	switch (ib_event->event) {
@@ -3673,12 +3669,13 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	struct rdma_id_private *id_priv;
 	struct cma_multicast *mc = multicast->context;
 	struct rdma_cm_event event;
-	int ret;
+	int ret = 0;
 
 	id_priv = mc->id_priv;
-	if (cma_disable_callback(id_priv, RDMA_CM_ADDR_BOUND) &&
-	    cma_disable_callback(id_priv, RDMA_CM_ADDR_RESOLVED))
-		return 0;
+	mutex_lock(&id_priv->handler_mutex);
+	if (id_priv->state != RDMA_CM_ADDR_BOUND &&
+	    id_priv->state != RDMA_CM_ADDR_RESOLVED)
+		goto out;
 
 	if (!status)
 		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
@@ -3720,6 +3717,7 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 		return 0;
 	}
 
+out:
 	mutex_unlock(&id_priv->handler_mutex);
 	return 0;
 }
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
