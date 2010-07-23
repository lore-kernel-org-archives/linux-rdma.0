From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] librdmacm: fix all calls to set errno
Date: Thu, 22 Jul 2010 21:16:01 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F9@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The librdmacm documentation (rdma_cm.7 man page) specifies that librdmacm
functions return 0 on success and -1 on error, with errno set correctly.
Update places in the code where errno is not set correctly and
cleanup setting the error code.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |   74 +++++++++++++++++++++++++++++++------------------------------
 1 files changed, 37 insertions(+), 37 deletions(-)
 mode change 100644 => 100755 src/cma.c

diff --git a/src/cma.c b/src/cma.c
old mode 100644
new mode 100755
index a20e2f5..a4fd574
--- a/src/cma.c
+++ b/src/cma.c
@@ -281,6 +281,7 @@ int ucma_init(void)
 		ret = ibv_query_device(cma_dev->verbs, &attr);
 		if (ret) {
 			printf("CMA: unable to query RDMA device\n");
+			ret = ERR(ret);
 			goto err3;
 		}
 
@@ -799,7 +800,9 @@ static int ucma_complete(struct cma_id_private *id_priv)
 	if (ret)
 		return ret;
 
-	return id_priv->id.event->status;
+	if (id_priv->id.event->status)
+		ret = ERR(id_priv->id.event->status);
+	return ret;
 }
 
 static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
@@ -961,7 +964,7 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 
 	ret = ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	qp_attr.qp_state = IBV_QPS_RTR;
 	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
@@ -970,7 +973,7 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 
 	if (resp_res != RDMA_MAX_RESP_RES)
 		qp_attr.max_dest_rd_atomic = resp_res;
-	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
@@ -985,7 +988,7 @@ static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
 
 	if (init_depth != RDMA_MAX_INIT_DEPTH)
 		qp_attr.max_rd_atomic = init_depth;
-	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_modify_qp_sqd(struct rdma_cm_id *id)
@@ -996,7 +999,7 @@ static int ucma_modify_qp_sqd(struct rdma_cm_id *id)
 		return 0;
 
 	qp_attr.qp_state = IBV_QPS_SQD;
-	return ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE);
+	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
 }
 
 static int ucma_modify_qp_err(struct rdma_cm_id *id)
@@ -1007,7 +1010,7 @@ static int ucma_modify_qp_err(struct rdma_cm_id *id)
 		return 0;
 
 	qp_attr.qp_state = IBV_QPS_ERR;
-	return ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE);
+	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
 }
 
 static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
@@ -1041,8 +1044,9 @@ static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
 	qp_attr.qp_state = IBV_QPS_INIT;
 	qp_attr.qp_access_flags = 0;
 
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
-					   IBV_QP_PKEY_INDEX | IBV_QP_PORT);
+	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
+					  IBV_QP_PKEY_INDEX | IBV_QP_PORT);
+	return rdma_seterrno(ret);
 }
 
 static int ucma_init_conn_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
@@ -1058,7 +1062,7 @@ static int ucma_init_conn_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
 	if (ret)
 		return ret;
 
-	return ibv_modify_qp(qp, &qp_attr, qp_attr_mask);
+	return rdma_seterrno(ibv_modify_qp(qp, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_init_ud_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
@@ -1079,16 +1083,17 @@ static int ucma_init_ud_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
 	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_QKEY |
 					  IBV_QP_PKEY_INDEX | IBV_QP_PORT);
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	qp_attr.qp_state = IBV_QPS_RTR;
 	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE);
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	qp_attr.qp_state = IBV_QPS_RTS;
 	qp_attr.sq_psn = 0;
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	return rdma_seterrno(ret);
 }
 
 static int ucma_init_ud_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
@@ -1106,16 +1111,17 @@ static int ucma_init_ud_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
 
 	ret = ibv_modify_qp(qp, &qp_attr, qp_attr_mask);
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	qp_attr.qp_state = IBV_QPS_RTR;
 	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE);
 	if (ret)
-		return ret;
+		return ERR(ret);
 
 	qp_attr.qp_state = IBV_QPS_RTS;
 	qp_attr.sq_psn = 0;
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	return rdma_seterrno(ret);
 }
 
 static void ucma_destroy_cqs(struct rdma_cm_id *id)
@@ -1135,44 +1141,36 @@ static void ucma_destroy_cqs(struct rdma_cm_id *id)
 
 static int ucma_create_cqs(struct rdma_cm_id *id, struct ibv_qp_init_attr *attr)
 {
-	int ret;
-
 	if (!attr->recv_cq) {
 		id->recv_cq_channel = ibv_create_comp_channel(id->verbs);
-		if (!id->recv_cq_channel) {
-			ret = ERR(ENOMEM);
+		if (!id->recv_cq_channel)
 			goto err;
-		}
 
 		id->recv_cq = ibv_create_cq(id->verbs, attr->cap.max_recv_wr,
 					    id, id->recv_cq_channel, 0);
-		if (!id->recv_cq) {
-			ret = ERR(ENOMEM);
+		if (!id->recv_cq)
 			goto err;
-		}
+
 		attr->recv_cq = id->recv_cq;
 	}
 
 	if (!attr->send_cq) {
 		id->send_cq_channel = ibv_create_comp_channel(id->verbs);
-		if (!id->send_cq_channel) {
-			ret = ERR(ENOMEM);
+		if (!id->send_cq_channel)
 			goto err;
-		}
 
 		id->send_cq = ibv_create_cq(id->verbs, attr->cap.max_send_wr,
 					    id, id->send_cq_channel, 0);
-		if (!id->send_cq) {
-			ret = ERR(ENOMEM);
+		if (!id->send_cq)
 			goto err;
-		}
+
 		attr->send_cq = id->send_cq;
 	}
 
 	return 0;
 err:
 	ucma_destroy_cqs(id);
-	return ret;
+	return ERR(ENOMEM);
 }
 
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
@@ -1228,20 +1226,22 @@ static int ucma_valid_param(struct cma_id_private *id_priv,
 		return 0;
 
 	if (!id_priv->id.qp && !param)
-		return ERR(EINVAL);
+		goto err;
 
 	if (!param)
 		return 0;
 
 	if ((param->responder_resources != RDMA_MAX_RESP_RES) &&
 	    (param->responder_resources > id_priv->cma_dev->max_responder_resources))
-		return ERR(EINVAL);
+		goto err;
 
 	if ((param->initiator_depth != RDMA_MAX_INIT_DEPTH) &&
 	    (param->initiator_depth > id_priv->cma_dev->max_initiator_depth))
-		return ERR(EINVAL);
+		goto err;
 
 	return 0;
+err:
+	return ERR(EINVAL);
 }
 
 static void ucma_copy_conn_param_to_kern(struct cma_id_private *id_priv,
@@ -1362,7 +1362,7 @@ int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id)
 		return ret;
 
 	if (event->status) {
-		ret = event->status;
+		ret = ERR(event->status);
 		goto err;
 	}
 	
@@ -1809,8 +1809,8 @@ static int ucma_process_join(struct cma_event *evt)
 	if (!evt->id_priv->id.qp)
 		return 0;
 
-	return ibv_attach_mcast(evt->id_priv->id.qp, &evt->mc->mgid,
-				evt->mc->mlid);
+	return rdma_seterrno(ibv_attach_mcast(evt->id_priv->id.qp,
+					      &evt->mc->mgid, evt->mc->mlid));
 }
 
 static void ucma_copy_conn_event(struct cma_event *event,
@@ -2047,7 +2047,7 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	if ((sync = (channel == NULL))) {
 		channel = rdma_create_event_channel();
 		if (!channel)
-			return ERR(ENOMEM);
+			return -1;
 	}
 
 	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_MIGRATE_ID, size);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
