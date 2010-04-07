From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/37] librdmacm: allow conn_param to be optional
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <BE0D268F98C047A0A23DF4ED551B2B45@amr.corp.intel.com>
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

If conn_param is not provided to rdma_connect or rdma_accept,
then default values are used to establish the connection.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    8 ++++++--
 src/cma.c               |   34 +++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index f50b4dd..88b3796 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -325,7 +325,7 @@ void rdma_destroy_qp(struct rdma_cm_id *id);
 /**
  * rdma_connect - Initiate an active connection request.
  * @id: RDMA identifier.
- * @conn_param: connection parameters.
+ * @conn_param: optional connection parameters.
  * Description:
  *   For a connected rdma_cm_id, this call initiates a connection request
  *   to a remote destination.  For an unconnected rdma_cm_id, it initiates
@@ -333,6 +333,8 @@ void rdma_destroy_qp(struct rdma_cm_id *id);
  * Notes:
  *   Users must have resolved a route to the destination address
  *   by having called rdma_resolve_route before calling this routine.
+ *   A user may override the default connection parameters and exchange
+ *   private data as part of the connection by using the conn_param parameter.
  * See also:
  *   rdma_resolve_route, rdma_disconnect, rdma_listen, rdma_get_cm_event
  */
@@ -361,7 +363,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog);
 /**
  * rdma_accept - Called to accept a connection request.
  * @id: Connection identifier associated with the request.
- * @conn_param: Information needed to establish the connection.
+ * @conn_param: Optional information needed to establish the connection.
  * Description:
  *   Called from the listening side to accept a connection or datagram
  *   service lookup request.
@@ -372,6 +374,8 @@ int rdma_listen(struct rdma_cm_id *id, int backlog);
  *   events give the user a newly created rdma_cm_id, similar to a new
  *   socket, but the rdma_cm_id is bound to a specific RDMA device.
  *   rdma_accept is called on the new rdma_cm_id.
+ *   A user may override the default connection parameters and exchange
+ *   private data as part of the connection by using the conn_param parameter.
  * See also:
  *   rdma_listen, rdma_reject, rdma_get_cm_event
  */
diff --git a/src/cma.c b/src/cma.c
index b8d57a5..6ef4b96 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1133,6 +1133,12 @@ static int ucma_valid_param(struct cma_id_private *id_priv,
 	if (id_priv->id.ps != RDMA_PS_TCP)
 		return 0;
 
+	if (!id_priv->id.qp && !param)
+		return ERR(EINVAL);
+
+	if (!param)
+		return 0;
+
 	if ((param->responder_resources != RDMA_MAX_RESP_RES) &&
 	    (param->responder_resources > id_priv->cma_dev->max_responder_resources))
 		return ERR(EINVAL);
@@ -1153,15 +1159,21 @@ static void ucma_copy_conn_param_to_kern(struct cma_id_private *id_priv,
 	dst->srq = srq;
 	dst->responder_resources = id_priv->responder_resources;
 	dst->initiator_depth = id_priv->initiator_depth;
-	dst->flow_control = src->flow_control;
-	dst->retry_count = src->retry_count;
-	dst->rnr_retry_count = src->rnr_retry_count;
 	dst->valid = 1;
 
-	if (src->private_data && src->private_data_len) {
-		memcpy(dst->private_data, src->private_data,
-		       src->private_data_len);
-		dst->private_data_len = src->private_data_len;
+	if (src) {
+		dst->flow_control = src->flow_control;
+		dst->retry_count = src->retry_count;
+		dst->rnr_retry_count = src->rnr_retry_count;
+
+		if (src->private_data && src->private_data_len) {
+			memcpy(dst->private_data, src->private_data,
+			       src->private_data_len);
+			dst->private_data_len = src->private_data_len;
+		}
+	} else {
+		dst->retry_count = 7;
+		dst->rnr_retry_count = 7;
 	}
 }
 
@@ -1177,11 +1189,11 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret)
 		return ret;
 
-	if (conn_param->initiator_depth != RDMA_MAX_INIT_DEPTH)
+	if (conn_param && conn_param->initiator_depth != RDMA_MAX_INIT_DEPTH)
 		id_priv->initiator_depth = conn_param->initiator_depth;
 	else
 		id_priv->initiator_depth = id_priv->cma_dev->max_initiator_depth;
-	if (conn_param->responder_resources != RDMA_MAX_RESP_RES)
+	if (conn_param && conn_param->responder_resources != RDMA_MAX_RESP_RES)
 		id_priv->responder_resources = conn_param->responder_resources;
 	else
 		id_priv->responder_resources = id_priv->cma_dev->max_responder_resources;
@@ -1238,13 +1250,13 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret)
 		return ret;
 
-	if (conn_param->initiator_depth == RDMA_MAX_INIT_DEPTH) {
+	if (!conn_param || conn_param->initiator_depth == RDMA_MAX_INIT_DEPTH) {
 		id_priv->initiator_depth = min(id_priv->initiator_depth,
 					       id_priv->cma_dev->max_initiator_depth);
 	} else {
 		id_priv->initiator_depth = conn_param->initiator_depth;
 	}
-	if (conn_param->responder_resources == RDMA_MAX_RESP_RES) {
+	if (!conn_param || conn_param->responder_resources == RDMA_MAX_RESP_RES) {
 		id_priv->responder_resources = min(id_priv->responder_resources,
 						   id_priv->cma_dev->max_responder_resources);
 	} else {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
