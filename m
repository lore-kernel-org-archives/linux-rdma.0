From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 4/6] RDMA CM: Export State Enum
Date: Mon, 3 Jan 2011 17:33:52 +0200
Message-ID: <1294068834-17778-5-git-send-email-nirm@voltaire.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294068834-17778-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

exported enum cma_state into rdma_cm.h

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |  166 +++++++++++++++++++----------------------
 include/rdma/rdma_cm.h        |   14 ++++
 2 files changed, 92 insertions(+), 88 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6884da2..5821f93 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -89,20 +89,6 @@ struct cma_device {
 	struct list_head	id_list;
 };
 
-enum cma_state {
-	CMA_IDLE,
-	CMA_ADDR_QUERY,
-	CMA_ADDR_RESOLVED,
-	CMA_ROUTE_QUERY,
-	CMA_ROUTE_RESOLVED,
-	CMA_CONNECT,
-	CMA_DISCONNECT,
-	CMA_ADDR_BOUND,
-	CMA_LISTEN,
-	CMA_DEVICE_REMOVAL,
-	CMA_DESTROYING
-};
-
 struct rdma_bind_list {
 	struct idr		*ps;
 	struct hlist_head	owners;
@@ -126,7 +112,7 @@ struct rdma_id_private {
 	struct list_head	mc_list;
 
 	int			internal_id;
-	enum cma_state		state;
+	enum rdma_cm_state	state;
 	spinlock_t		lock;
 	struct mutex		qp_mutex;
 
@@ -164,8 +150,8 @@ struct cma_multicast {
 struct cma_work {
 	struct work_struct	work;
 	struct rdma_id_private	*id;
-	enum cma_state		old_state;
-	enum cma_state		new_state;
+	enum rdma_cm_state	old_state;
+	enum rdma_cm_state	new_state;
 	struct rdma_cm_event	event;
 };
 
@@ -216,7 +202,7 @@ struct sdp_hah {
 #define CMA_VERSION 0x00
 #define SDP_MAJ_VERSION 0x2
 
-static int cma_comp(struct rdma_id_private *id_priv, enum cma_state comp)
+static int cma_comp(struct rdma_id_private *id_priv, enum rdma_cm_state comp)
 {
 	unsigned long flags;
 	int ret;
@@ -228,7 +214,7 @@ static int cma_comp(struct rdma_id_private *id_priv, enum cma_state comp)
 }
 
 static int cma_comp_exch(struct rdma_id_private *id_priv,
-			 enum cma_state comp, enum cma_state exch)
+			 enum rdma_cm_state comp, enum rdma_cm_state exch)
 {
 	unsigned long flags;
 	int ret;
@@ -240,11 +226,11 @@ static int cma_comp_exch(struct rdma_id_private *id_priv,
 	return ret;
 }
 
-static enum cma_state cma_exch(struct rdma_id_private *id_priv,
-			       enum cma_state exch)
+static enum rdma_cm_state cma_exch(struct rdma_id_private *id_priv,
+				   enum rdma_cm_state exch)
 {
 	unsigned long flags;
-	enum cma_state old;
+	enum rdma_cm_state old;
 
 	spin_lock_irqsave(&id_priv->lock, flags);
 	old = id_priv->state;
@@ -408,7 +394,7 @@ static void cma_deref_id(struct rdma_id_private *id_priv)
 }
 
 static int cma_disable_callback(struct rdma_id_private *id_priv,
-			      enum cma_state state)
+				enum rdma_cm_state state)
 {
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state != state) {
@@ -432,7 +418,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
-	id_priv->state = CMA_IDLE;
+	id_priv->state = RDMA_CM_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
 	id_priv->id.ps = ps;
@@ -838,16 +824,16 @@ static void cma_cancel_listens(struct rdma_id_private *id_priv)
 }
 
 static void cma_cancel_operation(struct rdma_id_private *id_priv,
-				 enum cma_state state)
+				 enum rdma_cm_state state)
 {
 	switch (state) {
-	case CMA_ADDR_QUERY:
+	case RDMA_CM_ADDR_QUERY:
 		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
 		break;
-	case CMA_ROUTE_QUERY:
+	case RDMA_CM_ROUTE_QUERY:
 		cma_cancel_route(id_priv);
 		break;
-	case CMA_LISTEN:
+	case RDMA_CM_LISTEN:
 		if (cma_any_addr((struct sockaddr *) &id_priv->id.route.addr.src_addr)
 				&& !id_priv->cma_dev)
 			cma_cancel_listens(id_priv);
@@ -898,10 +884,10 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 void rdma_destroy_id(struct rdma_cm_id *id)
 {
 	struct rdma_id_private *id_priv;
-	enum cma_state state;
+	enum rdma_cm_state state;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	state = cma_exch(id_priv, CMA_DESTROYING);
+	state = cma_exch(id_priv, RDMA_CM_DESTROYING);
 	cma_cancel_operation(id_priv, state);
 
 	mutex_lock(&lock);
@@ -992,9 +978,9 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	int ret = 0;
 
 	if ((ib_event->event != IB_CM_TIMEWAIT_EXIT &&
-		cma_disable_callback(id_priv, CMA_CONNECT)) ||
+		cma_disable_callback(id_priv, RDMA_CM_CONNECT)) ||
 	    (ib_event->event == IB_CM_TIMEWAIT_EXIT &&
-		cma_disable_callback(id_priv, CMA_DISCONNECT)))
+		cma_disable_callback(id_priv, RDMA_CM_DISCONNECT)))
 		return 0;
 
 	memset(&event, 0, sizeof event);
@@ -1025,7 +1011,8 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		event.status = -ETIMEDOUT; /* fall through */
 	case IB_CM_DREQ_RECEIVED:
 	case IB_CM_DREP_RECEIVED:
-		if (!cma_comp_exch(id_priv, CMA_CONNECT, CMA_DISCONNECT))
+		if (!cma_comp_exch(id_priv, RDMA_CM_CONNECT,
+				   RDMA_CM_DISCONNECT))
 			goto out;
 		event.event = RDMA_CM_EVENT_DISCONNECTED;
 		break;
@@ -1052,7 +1039,7 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		mutex_unlock(&id_priv->handler_mutex);
 		rdma_destroy_id(&id_priv->id);
 		return ret;
@@ -1109,7 +1096,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	rdma_addr_set_dgid(&rt->addr.dev_addr, &rt->path_rec[0].dgid);
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	id_priv->state = CMA_CONNECT;
+	id_priv->state = RDMA_CM_CONNECT;
 	return id_priv;
 
 destroy_id:
@@ -1149,7 +1136,7 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 	}
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	id_priv->state = CMA_CONNECT;
+	id_priv->state = RDMA_CM_CONNECT;
 	return id_priv;
 err:
 	rdma_destroy_id(id);
@@ -1178,7 +1165,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	int offset, ret;
 
 	listen_id = cm_id->context;
-	if (cma_disable_callback(listen_id, CMA_LISTEN))
+	if (cma_disable_callback(listen_id, RDMA_CM_LISTEN))
 		return -ECONNABORTED;
 
 	memset(&event, 0, sizeof event);
@@ -1217,7 +1204,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		 * while we're accessing the cm_id.
 		 */
 		mutex_lock(&lock);
-		if (cma_comp(conn_id, CMA_CONNECT) &&
+		if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 		    !cma_is_ud_ps(conn_id->id.ps))
 			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		mutex_unlock(&lock);
@@ -1229,7 +1216,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	conn_id->cm_id.ib = NULL;
 
 release_conn_id:
-	cma_exch(conn_id, CMA_DESTROYING);
+	cma_exch(conn_id, RDMA_CM_DESTROYING);
 	mutex_unlock(&conn_id->handler_mutex);
 	rdma_destroy_id(&conn_id->id);
 
@@ -1300,7 +1287,7 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 	struct sockaddr_in *sin;
 	int ret = 0;
 
-	if (cma_disable_callback(id_priv, CMA_CONNECT))
+	if (cma_disable_callback(id_priv, RDMA_CM_CONNECT))
 		return 0;
 
 	memset(&event, 0, sizeof event);
@@ -1343,7 +1330,7 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.iw = NULL;
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		mutex_unlock(&id_priv->handler_mutex);
 		rdma_destroy_id(&id_priv->id);
 		return ret;
@@ -1365,7 +1352,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	struct ib_device_attr attr;
 
 	listen_id = cm_id->context;
-	if (cma_disable_callback(listen_id, CMA_LISTEN))
+	if (cma_disable_callback(listen_id, RDMA_CM_LISTEN))
 		return -ECONNABORTED;
 
 	/* Create a new RDMA id for the new IW CM ID */
@@ -1378,7 +1365,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	}
 	conn_id = container_of(new_cm_id, struct rdma_id_private, id);
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
-	conn_id->state = CMA_CONNECT;
+	conn_id->state = RDMA_CM_CONNECT;
 
 	dev = ip_dev_find(&init_net, iw_event->local_addr.sin_addr.s_addr);
 	if (!dev) {
@@ -1429,7 +1416,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
-		cma_exch(conn_id, CMA_DESTROYING);
+		cma_exch(conn_id, RDMA_CM_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
 		rdma_destroy_id(&conn_id->id);
 		goto out;
@@ -1520,7 +1507,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	dev_id_priv = container_of(id, struct rdma_id_private, id);
 
-	dev_id_priv->state = CMA_ADDR_BOUND;
+	dev_id_priv->state = RDMA_CM_ADDR_BOUND;
 	memcpy(&id->route.addr.src_addr, &id_priv->id.route.addr.src_addr,
 	       ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr));
 
@@ -1552,14 +1539,14 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (id_priv->state == CMA_IDLE) {
+	if (id_priv->state == RDMA_CM_IDLE) {
 		((struct sockaddr *) &id->route.addr.src_addr)->sa_family = AF_INET;
 		ret = rdma_bind_addr(id, (struct sockaddr *) &id->route.addr.src_addr);
 		if (ret)
 			return ret;
 	}
 
-	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_LISTEN))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN))
 		return -EINVAL;
 
 	id_priv->backlog = backlog;
@@ -1585,7 +1572,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 	return 0;
 err:
 	id_priv->backlog = 0;
-	cma_comp_exch(id_priv, CMA_LISTEN, CMA_ADDR_BOUND);
+	cma_comp_exch(id_priv, RDMA_CM_LISTEN, RDMA_CM_ADDR_BOUND);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_listen);
@@ -1611,8 +1598,8 @@ static void cma_query_handler(int status, struct ib_sa_path_rec *path_rec,
 		route->num_paths = 1;
 		*route->path_rec = *path_rec;
 	} else {
-		work->old_state = CMA_ROUTE_QUERY;
-		work->new_state = CMA_ADDR_RESOLVED;
+		work->old_state = RDMA_CM_ROUTE_QUERY;
+		work->new_state = RDMA_CM_ADDR_RESOLVED;
 		work->event.event = RDMA_CM_EVENT_ROUTE_ERROR;
 		work->event.status = status;
 	}
@@ -1670,7 +1657,7 @@ static void cma_work_handler(struct work_struct *_work)
 		goto out;
 
 	if (id_priv->id.event_handler(&id_priv->id, &work->event)) {
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		destroy = 1;
 	}
 out:
@@ -1688,12 +1675,12 @@ static void cma_ndev_work_handler(struct work_struct *_work)
 	int destroy = 0;
 
 	mutex_lock(&id_priv->handler_mutex);
-	if (id_priv->state == CMA_DESTROYING ||
-	    id_priv->state == CMA_DEVICE_REMOVAL)
+	if (id_priv->state == RDMA_CM_DESTROYING ||
+	    id_priv->state == RDMA_CM_DEVICE_REMOVAL)
 		goto out;
 
 	if (id_priv->id.event_handler(&id_priv->id, &work->event)) {
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		destroy = 1;
 	}
 
@@ -1717,8 +1704,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 
 	work->id = id_priv;
 	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = CMA_ROUTE_QUERY;
-	work->new_state = CMA_ROUTE_RESOLVED;
+	work->old_state = RDMA_CM_ROUTE_QUERY;
+	work->new_state = RDMA_CM_ROUTE_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
 
 	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
@@ -1747,7 +1734,8 @@ int rdma_set_ib_paths(struct rdma_cm_id *id,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ROUTE_RESOLVED))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
+			   RDMA_CM_ROUTE_RESOLVED))
 		return -EINVAL;
 
 	id->route.path_rec = kmemdup(path_rec, sizeof *path_rec * num_paths,
@@ -1760,7 +1748,7 @@ int rdma_set_ib_paths(struct rdma_cm_id *id,
 	id->route.num_paths = num_paths;
 	return 0;
 err:
-	cma_comp_exch(id_priv, CMA_ROUTE_RESOLVED, CMA_ADDR_RESOLVED);
+	cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_ADDR_RESOLVED);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_set_ib_paths);
@@ -1775,8 +1763,8 @@ static int cma_resolve_iw_route(struct rdma_id_private *id_priv, int timeout_ms)
 
 	work->id = id_priv;
 	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = CMA_ROUTE_QUERY;
-	work->new_state = CMA_ROUTE_RESOLVED;
+	work->old_state = RDMA_CM_ROUTE_QUERY;
+	work->new_state = RDMA_CM_ROUTE_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
 	queue_work(cma_wq, &work->work);
 	return 0;
@@ -1840,8 +1828,8 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
-	work->old_state = CMA_ROUTE_QUERY;
-	work->new_state = CMA_ROUTE_RESOLVED;
+	work->old_state = RDMA_CM_ROUTE_QUERY;
+	work->new_state = RDMA_CM_ROUTE_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
 	work->event.status = 0;
 
@@ -1863,7 +1851,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ROUTE_QUERY))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
 		return -EINVAL;
 
 	atomic_inc(&id_priv->refcount);
@@ -1892,7 +1880,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 
 	return 0;
 err:
-	cma_comp_exch(id_priv, CMA_ROUTE_QUERY, CMA_ADDR_RESOLVED);
+	cma_comp_exch(id_priv, RDMA_CM_ROUTE_QUERY, RDMA_CM_ADDR_RESOLVED);
 	cma_deref_id(id_priv);
 	return ret;
 }
@@ -1957,7 +1945,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 	 * we're trying to acquire it.
 	 */
 	mutex_lock(&lock);
-	if (!cma_comp_exch(id_priv, CMA_ADDR_QUERY, CMA_ADDR_RESOLVED)) {
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY,
+			   RDMA_CM_ADDR_RESOLVED)) {
 		mutex_unlock(&lock);
 		goto out;
 	}
@@ -1967,7 +1956,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 	mutex_unlock(&lock);
 
 	if (status) {
-		if (!cma_comp_exch(id_priv, CMA_ADDR_RESOLVED, CMA_ADDR_BOUND))
+		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
+				   RDMA_CM_ADDR_BOUND))
 			goto out;
 		event.event = RDMA_CM_EVENT_ADDR_ERROR;
 		event.status = status;
@@ -1978,7 +1968,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 	}
 
 	if (id_priv->id.event_handler(&id_priv->id, &event)) {
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		mutex_unlock(&id_priv->handler_mutex);
 		cma_deref_id(id_priv);
 		rdma_destroy_id(&id_priv->id);
@@ -2023,8 +2013,8 @@ static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 
 	work->id = id_priv;
 	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = CMA_ADDR_QUERY;
-	work->new_state = CMA_ADDR_RESOLVED;
+	work->old_state = RDMA_CM_ADDR_QUERY;
+	work->new_state = RDMA_CM_ADDR_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
 	queue_work(cma_wq, &work->work);
 	return 0;
@@ -2053,13 +2043,13 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (id_priv->state == CMA_IDLE) {
+	if (id_priv->state == RDMA_CM_IDLE) {
 		ret = cma_bind_addr(id, src_addr, dst_addr);
 		if (ret)
 			return ret;
 	}
 
-	if (!cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_ADDR_QUERY))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY))
 		return -EINVAL;
 
 	atomic_inc(&id_priv->refcount);
@@ -2075,7 +2065,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 
 	return 0;
 err:
-	cma_comp_exch(id_priv, CMA_ADDR_QUERY, CMA_ADDR_BOUND);
+	cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY, RDMA_CM_ADDR_BOUND);
 	cma_deref_id(id_priv);
 	return ret;
 }
@@ -2253,7 +2243,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 		return -EAFNOSUPPORT;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp_exch(id_priv, CMA_IDLE, CMA_ADDR_BOUND))
+	if (!cma_comp_exch(id_priv, RDMA_CM_IDLE, RDMA_CM_ADDR_BOUND))
 		return -EINVAL;
 
 	ret = cma_check_linklocal(&id->route.addr.dev_addr, addr);
@@ -2285,7 +2275,7 @@ err2:
 		mutex_unlock(&lock);
 	}
 err1:
-	cma_comp_exch(id_priv, CMA_ADDR_BOUND, CMA_IDLE);
+	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_bind_addr);
@@ -2358,7 +2348,7 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 	struct ib_cm_sidr_rep_event_param *rep = &ib_event->param.sidr_rep_rcvd;
 	int ret = 0;
 
-	if (cma_disable_callback(id_priv, CMA_CONNECT))
+	if (cma_disable_callback(id_priv, RDMA_CM_CONNECT))
 		return 0;
 
 	memset(&event, 0, sizeof event);
@@ -2404,7 +2394,7 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		mutex_unlock(&id_priv->handler_mutex);
 		rdma_destroy_id(&id_priv->id);
 		return ret;
@@ -2570,7 +2560,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp_exch(id_priv, CMA_ROUTE_RESOLVED, CMA_CONNECT))
+	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT))
 		return -EINVAL;
 
 	if (!id->qp) {
@@ -2597,7 +2587,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 	return 0;
 err:
-	cma_comp_exch(id_priv, CMA_CONNECT, CMA_ROUTE_RESOLVED);
+	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_connect);
@@ -2683,7 +2673,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp(id_priv, CMA_CONNECT))
+	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
 		return -EINVAL;
 
 	if (!id->qp && conn_param) {
@@ -2812,8 +2802,8 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	int ret;
 
 	id_priv = mc->id_priv;
-	if (cma_disable_callback(id_priv, CMA_ADDR_BOUND) &&
-	    cma_disable_callback(id_priv, CMA_ADDR_RESOLVED))
+	if (cma_disable_callback(id_priv, RDMA_CM_ADDR_BOUND) &&
+	    cma_disable_callback(id_priv, RDMA_CM_ADDR_RESOLVED))
 		return 0;
 
 	mutex_lock(&id_priv->qp_mutex);
@@ -2837,7 +2827,7 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 
 	ret = id_priv->id.event_handler(&id_priv->id, &event);
 	if (ret) {
-		cma_exch(id_priv, CMA_DESTROYING);
+		cma_exch(id_priv, RDMA_CM_DESTROYING);
 		mutex_unlock(&id_priv->handler_mutex);
 		rdma_destroy_id(&id_priv->id);
 		return 0;
@@ -3020,8 +3010,8 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_comp(id_priv, CMA_ADDR_BOUND) &&
-	    !cma_comp(id_priv, CMA_ADDR_RESOLVED))
+	if (!cma_comp(id_priv, RDMA_CM_ADDR_BOUND) &&
+	    !cma_comp(id_priv, RDMA_CM_ADDR_RESOLVED))
 		return -EINVAL;
 
 	mc = kmalloc(sizeof *mc, GFP_KERNEL);
@@ -3186,19 +3176,19 @@ static void cma_add_one(struct ib_device *device)
 static int cma_remove_id_dev(struct rdma_id_private *id_priv)
 {
 	struct rdma_cm_event event;
-	enum cma_state state;
+	enum rdma_cm_state state;
 	int ret = 0;
 
 	/* Record that we want to remove the device */
-	state = cma_exch(id_priv, CMA_DEVICE_REMOVAL);
-	if (state == CMA_DESTROYING)
+	state = cma_exch(id_priv, RDMA_CM_DEVICE_REMOVAL);
+	if (state == RDMA_CM_DESTROYING)
 		return 0;
 
 	cma_cancel_operation(id_priv, state);
 	mutex_lock(&id_priv->handler_mutex);
 
 	/* Check for destruction from another callback. */
-	if (!cma_comp(id_priv, CMA_DEVICE_REMOVAL))
+	if (!cma_comp(id_priv, RDMA_CM_DEVICE_REMOVAL))
 		goto out;
 
 	memset(&event, 0, sizeof event);
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 4fae903..c766da9 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -111,6 +111,20 @@ struct rdma_cm_event {
 	} param;
 };
 
+enum rdma_cm_state {
+	RDMA_CM_IDLE,
+	RDMA_CM_ADDR_QUERY,
+	RDMA_CM_ADDR_RESOLVED,
+	RDMA_CM_ROUTE_QUERY,
+	RDMA_CM_ROUTE_RESOLVED,
+	RDMA_CM_CONNECT,
+	RDMA_CM_DISCONNECT,
+	RDMA_CM_ADDR_BOUND,
+	RDMA_CM_LISTEN,
+	RDMA_CM_DEVICE_REMOVAL,
+	RDMA_CM_DESTROYING
+};
+
 struct rdma_cm_id;
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
