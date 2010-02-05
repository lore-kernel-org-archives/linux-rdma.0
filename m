From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: transition QP to RTS before sending reply
Date: Fri, 5 Feb 2010 14:27:07 -0800
Message-ID: <337F47898C204328B069AAD388B014DB@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to handle a race condition where the passive side of
a connection can receive data on a QP before the connection established
event has been received, transition the QP to RTS before sending the reply.
This allows a user to send a response to any received message immediately,
rather than waiting until the connection established event has been
processed.

A similar fix was applied to the kernel rdma_cm a while ago.
Simply duplicate the fix in the user space library.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index efad6ae..59e89dd 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -652,7 +652,8 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id,
 	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
 }
 
-static int ucma_modify_qp_rts(struct rdma_cm_id *id)
+static int ucma_modify_qp_rts(struct rdma_cm_id *id,
+			      struct rdma_conn_param *conn_param)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
@@ -662,6 +663,8 @@ static int ucma_modify_qp_rts(struct rdma_cm_id *id)
 	if (ret)
 		return ret;
 
+	if (conn_param)
+		qp_attr.max_rd_atomic = conn_param->initiator_depth;
 	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
 }
 
@@ -929,6 +932,10 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		ret = ucma_modify_qp_rtr(id, conn_param);
 		if (ret)
 			return ret;
+
+		ret = ucma_modify_qp_rts(id, conn_param);
+		if (ret)
+			return ret;
 	}
 
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_ACCEPT, size);
@@ -1212,7 +1219,7 @@ static int ucma_process_conn_resp(struct cma_id_private *id_priv)
 	if (ret)
 		goto err;
 
-	ret = ucma_modify_qp_rts(&id_priv->id);
+	ret = ucma_modify_qp_rts(&id_priv->id, NULL);
 	if (ret)
 		goto err;
 
@@ -1231,17 +1238,6 @@ err:
 	return ret;
 }
 
-static int ucma_process_establish(struct rdma_cm_id *id)
-{
-	int ret;
-
-	ret = ucma_modify_qp_rts(id);
-	if (ret)
-		ucma_modify_qp_err(id);
-
-	return ret;
-}
-
 static int ucma_process_join(struct cma_event *evt)
 {
 	evt->mc->mgid = evt->event.param.ud.ah_attr.grh.dgid;
@@ -1367,11 +1363,6 @@ retry:
 		}
 
 		ucma_copy_conn_event(evt, &resp->param.conn);
-		evt->event.status = ucma_process_establish(&evt->id_priv->id);
-		if (evt->event.status) {
-			evt->event.event = RDMA_CM_EVENT_CONNECT_ERROR;
-			evt->id_priv->connect_error = 1;
-		}
 		break;
 	case RDMA_CM_EVENT_REJECTED:
 		if (evt->id_priv->connect_error) {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
