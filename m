From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] librdmacm: fix resource leaks when CMA_CREATE_MSG_CMD_RESP fails
Date: Mon, 15 Aug 2011 14:38:56 +0300
Message-ID: <201108151438.56670.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the macro CMA_CREATE_MSG_CMD_RESP is being called and there is a failure,
the macro should release the allocated resources before returning from the called
function

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

diff --git a/src/cma.c b/src/cma.c
index bad1ba3..0512187 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -59,14 +59,16 @@
 #include <rdma/rdma_verbs.h>
 #include <infiniband/ib.h>
 
-#define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
+#define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size, clean_cmd) \
 do {                                        \
-	struct ucma_abi_cmd_hdr *hdr;         \
+	struct ucma_abi_cmd_hdr *hdr;       \
                                             \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
-	if (!msg)                           \
+	if (!msg) {                         \
+		clean_cmd;                  \
 		return ERR(ENOMEM);         \
+	}                                   \
 	hdr = msg;                          \
 	cmd = msg + sizeof(*hdr);           \
 	hdr->cmd = type;                    \
@@ -74,8 +76,10 @@ do {                                        \
 	hdr->out = sizeof(*resp);           \
 	memset(cmd, 0, sizeof(*cmd));       \
 	resp = alloca(sizeof(*resp));       \
-	if (!resp)                          \
+	if (!resp) {                        \
+		clean_cmd;                  \
 		return ERR(ENOMEM);         \
+	}                                   \
 	cmd->response = (uintptr_t)resp;\
 } while (0)
 
@@ -460,7 +464,7 @@ static int rdma_create_id2(struct rdma_event_channel *channel,
 	if (!id_priv)
 		return ERR(ENOMEM);
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_CREATE_ID, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_CREATE_ID, size, ucma_free_id(id_priv));
 	cmd->uid = (uintptr_t) id_priv;
 	cmd->ps = ps;
 	cmd->qp_type = qp_type;
@@ -497,7 +501,7 @@ static int ucma_destroy_kern_id(int fd, uint32_t handle)
 	void *msg;
 	int ret, size;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_DESTROY_ID, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_DESTROY_ID, size, );
 	cmd->id = handle;
 
 	ret = write(fd, msg, size);
@@ -556,7 +560,7 @@ static int ucma_query_addr(struct rdma_cm_id *id)
 	void *msg;
 	int ret, size;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size, );
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	cmd->option = UCMA_QUERY_ADDR;
@@ -590,7 +594,7 @@ static int ucma_query_gid(struct rdma_cm_id *id)
 	void *msg;
 	int ret, size;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size, );
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	cmd->option = UCMA_QUERY_GID;
@@ -702,7 +706,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
 	void *msg;
 	int ret, size, i;
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY_ROUTE, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY_ROUTE, size, );
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 
@@ -936,7 +940,7 @@ static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 	void *msg;
 	int ret, size;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_INIT_QP_ATTR, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_INIT_QP_ATTR, size, );
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	cmd->qp_state = qp_attr->qp_state;
@@ -1613,7 +1617,7 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 	if (af_ib_support) {
 		struct ucma_abi_join_mcast *cmd;
 
-		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_MCAST, size);
+		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_MCAST, size, free(mc));
 		cmd->id = id_priv->handle;
 		memcpy(&cmd->addr, addr, addrlen);
 		cmd->addr_size = addrlen;
@@ -1622,7 +1626,7 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 	} else {
 		struct ucma_abi_join_ip_mcast *cmd;
 
-		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size);
+		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size, free(mc));
 		cmd->id = id_priv->handle;
 		memcpy(&cmd->addr, addr, addrlen);
 		cmd->uid = (uintptr_t) mc;
@@ -1691,7 +1695,7 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (id->qp)
 		ibv_detach_mcast(id->qp, &mc->mgid, mc->mlid);
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_LEAVE_MCAST, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_LEAVE_MCAST, size, );
 	cmd->id = mc->handle;
 
 	ret = write(id->channel->fd, msg, size);
@@ -1940,7 +1944,7 @@ int rdma_get_cm_event(struct rdma_event_channel *channel,
 
 retry:
 	memset(evt, 0, sizeof *evt);
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_GET_EVENT, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_GET_EVENT, size, free(evt));
 	ret = write(channel->fd, msg, size);
 	if (ret != size) {
 		free(evt);
@@ -2117,7 +2121,7 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 			return -1;
 	}
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_MIGRATE_ID, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_MIGRATE_ID, size, if (sync) rdma_destroy_event_channel(channel));
 	cmd->id = id_priv->handle;
 	cmd->fd = id->channel->fd;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
