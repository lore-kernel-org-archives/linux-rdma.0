From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/37] librdmacm: support synchronous rdma_cm_id's
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <9CC73004629C4816BDBF4D33FD8CE9B2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow the user to specify NULL as the rdma_event_channel in
order to indicate that the rdma_cm_id should process all requests
synchronously.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    1 +
 src/cma.c               |   93 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index a071a9b..83418c3 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -114,6 +114,7 @@ struct rdma_cm_id {
 	struct rdma_route	 route;
 	enum rdma_port_space	 ps;
 	uint8_t			 port_num;
+	struct rdma_cm_event	*event;
 };
 
 struct rdma_conn_param {
diff --git a/src/cma.c b/src/cma.c
index 4025aeb..c7a3a7b 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -106,6 +106,7 @@ struct cma_id_private {
 	struct cma_device *cma_dev;
 	int		  events_completed;
 	int		  connect_error;
+	int		  sync;
 	pthread_cond_t	  cond;
 	pthread_mutex_t	  mut;
 	uint32_t	  handle;
@@ -333,6 +334,9 @@ static void ucma_free_id(struct cma_id_private *id_priv)
 	pthread_mutex_destroy(&id_priv->mut);
 	if (id_priv->id.route.path_rec)
 		free(id_priv->id.route.path_rec);
+
+	if (id_priv->sync)
+		rdma_destroy_event_channel(id_priv->id.channel);
 	free(id_priv);
 }
 
@@ -348,7 +352,16 @@ static struct cma_id_private *ucma_alloc_id(struct rdma_event_channel *channel,
 
 	id_priv->id.context = context;
 	id_priv->id.ps = ps;
-	id_priv->id.channel = channel;
+
+	if (!channel) {
+		id_priv->id.channel = rdma_create_event_channel();
+		if (!id_priv->id.channel)
+			goto err;
+		id_priv->sync = 1;
+	} else {
+		id_priv->id.channel = channel;
+	}
+
 	pthread_mutex_init(&id_priv->mut, NULL);
 	if (pthread_cond_init(&id_priv->cond, NULL))
 		goto err;
@@ -381,7 +394,7 @@ int rdma_create_id(struct rdma_event_channel *channel,
 	cmd->uid = (uintptr_t) id_priv;
 	cmd->ps = ps;
 
-	ret = write(channel->fd, msg, size);
+	ret = write(id_priv->id.channel->fd, msg, size);
 	if (ret != size)
 		goto err;
 
@@ -424,6 +437,9 @@ int rdma_destroy_id(struct rdma_cm_id *id)
 	if (ret < 0)
 		return ret;
 
+	if (id_priv->id.event)
+		rdma_ack_cm_event(id_priv->id.event);
+
 	pthread_mutex_lock(&id_priv->mut);
 	while (id_priv->events_completed < ret)
 		pthread_cond_wait(&id_priv->cond, &id_priv->mut);
@@ -694,6 +710,25 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	return ucma_query_route(id);
 }
 
+static int ucma_complete(struct cma_id_private *id_priv)
+{
+	int ret;
+
+	if (!id_priv->sync)
+		return 0;
+
+	if (id_priv->id.event) {
+		rdma_ack_cm_event(id_priv->id.event);
+		id_priv->id.event = NULL;
+	}
+
+	ret = rdma_get_cm_event(id_priv->id.channel, &id_priv->id.event);
+	if (ret)
+		return ret;
+
+	return id_priv->id.event->status;
+}
+
 static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			      socklen_t src_len, struct sockaddr *dst_addr,
 			      socklen_t dst_len, int timeout_ms)
@@ -718,7 +753,7 @@ static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
@@ -751,7 +786,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
@@ -770,7 +805,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 static int ucma_is_ud_ps(enum rdma_port_space ps)
@@ -1074,7 +1109,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 int rdma_listen(struct rdma_cm_id *id, int backlog)
@@ -1139,7 +1174,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
 
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 int rdma_reject(struct rdma_cm_id *id, const void *private_data,
@@ -1214,7 +1249,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	return 0;
+	return ucma_complete(id_priv);
 }
 
 static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
@@ -1271,7 +1306,8 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
 	mc->handle = resp->id;
-	return 0;
+	return ucma_complete(id_priv);
+
 err2:
 	pthread_mutex_lock(&id_priv->mut);
 	for (pos = &id_priv->mc_list; *pos != mc; pos = &(*pos)->next)
@@ -1443,21 +1479,28 @@ static int ucma_process_conn_req(struct cma_event *evt,
 	if (!id_priv) {
 		ucma_destroy_kern_id(evt->id_priv->id.channel->fd, handle);
 		ret = ERR(ENOMEM);
-		goto err;
+		goto err1;
 	}
 
 	evt->event.listen_id = &evt->id_priv->id;
 	evt->event.id = &id_priv->id;
 	id_priv->handle = handle;
 
-	ret = ucma_query_req_info(&id_priv->id);
-	if (ret) {
-		rdma_destroy_id(&id_priv->id);
-		goto err;
+	if (evt->id_priv->sync) {
+		ret = rdma_migrate_id(&id_priv->id, NULL);
+		if (ret)
+			goto err2;
 	}
 
+	ret = ucma_query_req_info(&id_priv->id);
+	if (ret)
+		goto err2;
+
 	return 0;
-err:
+
+err2:
+	rdma_destroy_id(&id_priv->id);
+err1:
 	ucma_complete_event(evt->id_priv);
 	return ret;
 }
@@ -1728,9 +1771,18 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	struct ucma_abi_migrate_id *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
-	int ret, size;
+	int ret, size, sync;
 
 	id_priv = container_of(id, struct cma_id_private, id);
+	if (id_priv->sync && !channel)
+		return ERR(EINVAL);
+
+	if ((sync = (channel == NULL))) {
+		channel = rdma_create_event_channel();
+		if (!channel)
+			return ERR(ENOMEM);
+	}
+
 	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_MIGRATE_ID, size);
 	cmd->id = id_priv->handle;
 	cmd->fd = id->channel->fd;
@@ -1741,6 +1793,14 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
+	if (id_priv->sync) {
+		if (id->event) {
+			rdma_ack_cm_event(id->event);
+			id->event = NULL;
+		}
+		rdma_destroy_event_channel(id->channel);
+	}
+
 	/*
 	 * Eventually if we want to support migrating channels while events are
 	 * being processed on the current channel, we need to block here while
@@ -1749,6 +1809,7 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	 * channel after this call returns.
 	 */
 	pthread_mutex_lock(&id_priv->mut);
+	id_priv->sync = sync;
 	id->channel = channel;
 	while (id_priv->events_completed < resp->events_reported)
 		pthread_cond_wait(&id_priv->cond, &id_priv->mut);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
