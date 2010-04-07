From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/37] librdmacm: allow user to specify max RDMA resources
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <DE4BAC3B17A6491CBCF01E5C33ED1DE0@amr.corp.intel.com>
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

Allow the user to indicate that the library should select the
maximum RDMA read values available that should be used when
establishing a connection.  The library selects the maximum
based on local hardware limitations and connection request
data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    5 +++
 src/cma.c               |   83 +++++++++++++++++++++++++++++++----------------
 src/cma.h               |    2 +
 3 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index d8cbb91..f50b4dd 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -121,6 +121,11 @@ struct rdma_cm_id {
 	struct ibv_cq		*recv_cq;
 };
 
+enum {
+	RDMA_MAX_RESP_RES = 0xFF,
+	RDMA_MAX_INIT_DEPTH = 0xFF
+};
+
 struct rdma_conn_param {
 	const void *private_data;
 	uint8_t private_data_len;
diff --git a/src/cma.c b/src/cma.c
index 805aca3..b8d57a5 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -112,6 +112,8 @@ struct cma_id_private {
 	pthread_mutex_t	  mut;
 	uint32_t	  handle;
 	struct cma_multicast *mc_list;
+	uint8_t		  initiator_depth;
+	uint8_t		  responder_resources;
 };
 
 struct cma_multicast {
@@ -850,8 +852,7 @@ static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 	return 0;
 }
 
-static int ucma_modify_qp_rtr(struct rdma_cm_id *id,
-			      struct rdma_conn_param *conn_param)
+static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
@@ -874,13 +875,12 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id,
 	if (ret)
 		return ret;
 
-	if (conn_param)
-		qp_attr.max_dest_rd_atomic = conn_param->responder_resources;
+	if (resp_res != RDMA_MAX_RESP_RES)
+		qp_attr.max_dest_rd_atomic = resp_res;
 	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
 }
 
-static int ucma_modify_qp_rts(struct rdma_cm_id *id,
-			      struct rdma_conn_param *conn_param)
+static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
@@ -890,8 +890,8 @@ static int ucma_modify_qp_rts(struct rdma_cm_id *id,
 	if (ret)
 		return ret;
 
-	if (conn_param)
-		qp_attr.max_rd_atomic = conn_param->initiator_depth;
+	if (init_depth != RDMA_MAX_INIT_DEPTH)
+		qp_attr.max_rd_atomic = init_depth;
 	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
 }
 
@@ -1128,28 +1128,31 @@ void rdma_destroy_qp(struct rdma_cm_id *id)
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
-			    struct rdma_conn_param *conn_param)
+			    struct rdma_conn_param *param)
 {
 	if (id_priv->id.ps != RDMA_PS_TCP)
 		return 0;
 
-	if ((conn_param->responder_resources >
-	     id_priv->cma_dev->max_responder_resources) ||
-	    (conn_param->initiator_depth >
-	     id_priv->cma_dev->max_initiator_depth))
+	if ((param->responder_resources != RDMA_MAX_RESP_RES) &&
+	    (param->responder_resources > id_priv->cma_dev->max_responder_resources))
+		return ERR(EINVAL);
+
+	if ((param->initiator_depth != RDMA_MAX_INIT_DEPTH) &&
+	    (param->initiator_depth > id_priv->cma_dev->max_initiator_depth))
 		return ERR(EINVAL);
 
 	return 0;
 }
 
-static void ucma_copy_conn_param_to_kern(struct ucma_abi_conn_param *dst,
+static void ucma_copy_conn_param_to_kern(struct cma_id_private *id_priv,
+					 struct ucma_abi_conn_param *dst,
 					 struct rdma_conn_param *src,
 					 uint32_t qp_num, uint8_t srq)
 {
 	dst->qp_num = qp_num;
 	dst->srq = srq;
-	dst->responder_resources = src->responder_resources;
-	dst->initiator_depth = src->initiator_depth;
+	dst->responder_resources = id_priv->responder_resources;
+	dst->initiator_depth = id_priv->initiator_depth;
 	dst->flow_control = src->flow_control;
 	dst->retry_count = src->retry_count;
 	dst->rnr_retry_count = src->rnr_retry_count;
@@ -1174,15 +1177,24 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret)
 		return ret;
 
+	if (conn_param->initiator_depth != RDMA_MAX_INIT_DEPTH)
+		id_priv->initiator_depth = conn_param->initiator_depth;
+	else
+		id_priv->initiator_depth = id_priv->cma_dev->max_initiator_depth;
+	if (conn_param->responder_resources != RDMA_MAX_RESP_RES)
+		id_priv->responder_resources = conn_param->responder_resources;
+	else
+		id_priv->responder_resources = id_priv->cma_dev->max_responder_resources;
+
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_CONNECT, size);
 	cmd->id = id_priv->handle;
 	if (id->qp)
-		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
-					     id->qp->qp_num,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
 	else
-		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
-					     conn_param->qp_num,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+					     conn_param, conn_param->qp_num,
 					     conn_param->srq);
 
 	ret = write(id->channel->fd, msg, size);
@@ -1226,12 +1238,25 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret)
 		return ret;
 
+	if (conn_param->initiator_depth == RDMA_MAX_INIT_DEPTH) {
+		id_priv->initiator_depth = min(id_priv->initiator_depth,
+					       id_priv->cma_dev->max_initiator_depth);
+	} else {
+		id_priv->initiator_depth = conn_param->initiator_depth;
+	}
+	if (conn_param->responder_resources == RDMA_MAX_RESP_RES) {
+		id_priv->responder_resources = min(id_priv->responder_resources,
+						   id_priv->cma_dev->max_responder_resources);
+	} else {
+		id_priv->responder_resources = conn_param->responder_resources;
+	}
+
 	if (!ucma_is_ud_ps(id->ps)) {
-		ret = ucma_modify_qp_rtr(id, conn_param);
+		ret = ucma_modify_qp_rtr(id, id_priv->responder_resources);
 		if (ret)
 			return ret;
 
-		ret = ucma_modify_qp_rts(id, conn_param);
+		ret = ucma_modify_qp_rts(id, id_priv->initiator_depth);
 		if (ret)
 			return ret;
 	}
@@ -1240,12 +1265,12 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	cmd->id = id_priv->handle;
 	cmd->uid = (uintptr_t) id_priv;
 	if (id->qp)
-		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
-					     id->qp->qp_num,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
 	else
-		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
-					     conn_param->qp_num,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+					     conn_param, conn_param->qp_num,
 					     conn_param->srq);
 
 	ret = write(id->channel->fd, msg, size);
@@ -1565,6 +1590,8 @@ static int ucma_process_conn_req(struct cma_event *evt,
 	evt->event.listen_id = &evt->id_priv->id;
 	evt->event.id = &id_priv->id;
 	id_priv->handle = handle;
+	id_priv->initiator_depth = evt->event.param.conn.initiator_depth;
+	id_priv->responder_resources = evt->event.param.conn.responder_resources;
 
 	if (evt->id_priv->sync) {
 		ret = rdma_migrate_id(&id_priv->id, NULL);
@@ -1591,11 +1618,11 @@ static int ucma_process_conn_resp(struct cma_id_private *id_priv)
 	void *msg;
 	int ret, size;
 
-	ret = ucma_modify_qp_rtr(&id_priv->id, NULL);
+	ret = ucma_modify_qp_rtr(&id_priv->id, RDMA_MAX_RESP_RES);
 	if (ret)
 		goto err;
 
-	ret = ucma_modify_qp_rts(&id_priv->id, NULL);
+	ret = ucma_modify_qp_rts(&id_priv->id, RDMA_MAX_INIT_DEPTH);
 	if (ret)
 		goto err;
 
diff --git a/src/cma.h b/src/cma.h
index fcfb1f7..92e771e 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -65,6 +65,8 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
+#define min(a, b) (a < b ? a : b)
+
 static inline int ERR(int err)
 {
 	errno = err;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
