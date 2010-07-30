From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [PATCH] rdma cm + XRC
Date: Fri, 30 Jul 2010 15:11:08 -0500
Message-ID: <4C5331DC.9080109@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060303090503080503060608"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060303090503080503060608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

This allow rdma ucm to establish an XRC connection between two nodes. Most
of the changes are related to modify_qp since the API is different
whether the QP is on the send or receive side.
To create an XRC receive QP, the cap.max_send_wr must be set to 0.
Conversely, to create the send XRC QP, that attribute must be non-zero.

Regards,
  Frank




--------------060303090503080503060608
Content-Type: text/x-patch;
 name="rdmacm-xrc-v1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rdmacm-xrc-v1.diff"

diff -ru /usr/src/redhat/BUILD/librdmacm-1.0.11/include/rdma/rdma_cma.h librdmacm-1.0.11/include/rdma/rdma_cma.h
--- /usr/src/redhat/BUILD/librdmacm-1.0.11/include/rdma/rdma_cma.h	2008-07-31 18:01:42.000000000 -0500
+++ librdmacm-1.0.11/include/rdma/rdma_cma.h	2010-07-29 17:00:15.000000000 -0500
@@ -114,6 +114,8 @@
 	struct rdma_route	 route;
 	enum rdma_port_space	 ps;
 	uint8_t			 port_num;
+	struct ibv_xrc_domain *xrc_domain;
+	uint32_t xrc_rcv_qpn;
 };
 
 struct rdma_conn_param {
diff -ru /usr/src/redhat/BUILD/librdmacm-1.0.11/src/cma.c librdmacm-1.0.11/src/cma.c
--- /usr/src/redhat/BUILD/librdmacm-1.0.11/src/cma.c	2009-10-26 19:08:34.000000000 -0500
+++ librdmacm-1.0.11/src/cma.c	2010-07-30 13:45:51.000000000 -0500
@@ -623,33 +623,51 @@
 	return 0;
 }
 
+static int rdma_modify_qp(struct rdma_cm_id *id, 
+					  struct ibv_qp_attr *qp_attr,
+					  int qp_attr_mask)
+{
+	int ret;
+
+	if (id->qp)
+		ret = ibv_modify_qp(id->qp, qp_attr, qp_attr_mask);
+	else if (id->xrc_domain)
+		ret = ibv_modify_xrc_rcv_qp(id->xrc_domain, id->xrc_rcv_qpn,
+									qp_attr, qp_attr_mask);
+	else 
+		ret = ERR(EINVAL);
+
+	return ret;
+}
+
 static int ucma_modify_qp_rtr(struct rdma_cm_id *id,
 			      struct rdma_conn_param *conn_param)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
-	if (!id->qp)
-		return ERR(EINVAL);
-
-	/* Need to update QP attributes from default values. */
-	qp_attr.qp_state = IBV_QPS_INIT;
-	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
-	if (ret)
-		return ret;
+	if (id->qp || id->xrc_domain) {
+		/* Need to update QP attributes from default values. */
+		qp_attr.qp_state = IBV_QPS_INIT;
+		ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
+		if (ret)
+			return ret;
 
-	ret = ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
-	if (ret)
-		return ret;
+		ret = rdma_modify_qp(id, &qp_attr, qp_attr_mask);
+		if (ret)
+			return ret;
 
-	qp_attr.qp_state = IBV_QPS_RTR;
-	ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
-	if (ret)
-		return ret;
+		qp_attr.qp_state = IBV_QPS_RTR;
+		ret = rdma_init_qp_attr(id, &qp_attr, &qp_attr_mask);
+		if (ret)
+			return ret;
 
-	if (conn_param)
-		qp_attr.max_dest_rd_atomic = conn_param->responder_resources;
-	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+		if (conn_param)
+			qp_attr.max_dest_rd_atomic = conn_param->responder_resources;
+		return rdma_modify_qp(id, &qp_attr, qp_attr_mask);
+	}
+	else
+		return ERR(EINVAL);
 }
 
 static int ucma_modify_qp_rts(struct rdma_cm_id *id)
@@ -662,7 +680,7 @@
 	if (ret)
 		return ret;
 
-	return ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	return rdma_modify_qp(id, &qp_attr, qp_attr_mask);
 }
 
 static int ucma_modify_qp_sqd(struct rdma_cm_id *id)
@@ -673,18 +691,18 @@
 		return 0;
 
 	qp_attr.qp_state = IBV_QPS_SQD;
-	return ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE);
+	return rdma_modify_qp(id, &qp_attr, IBV_QP_STATE);
 }
 
 static int ucma_modify_qp_err(struct rdma_cm_id *id)
 {
 	struct ibv_qp_attr qp_attr;
 
-	if (!id->qp)
+	if (id->qp || id->xrc_domain) {
+		qp_attr.qp_state = IBV_QPS_ERR;
+		return rdma_modify_qp(id, &qp_attr, IBV_QP_STATE);
+	} else
 		return 0;
-
-	qp_attr.qp_state = IBV_QPS_ERR;
-	return ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE);
 }
 
 static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
@@ -703,7 +721,7 @@
 	return ERR(EINVAL);
 }
 
-static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_conn_qp3(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int ret;
@@ -718,27 +736,27 @@
 	qp_attr.qp_state = IBV_QPS_INIT;
 	qp_attr.qp_access_flags = 0;
 
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
+	return rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
 					   IBV_QP_PKEY_INDEX | IBV_QP_PORT);
 }
 
-static int ucma_init_conn_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_conn_qp(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
 	if (abi_ver == 3)
-		return ucma_init_conn_qp3(id_priv, qp);
+		return ucma_init_conn_qp3(id_priv);
 
 	qp_attr.qp_state = IBV_QPS_INIT;
 	ret = rdma_init_qp_attr(&id_priv->id, &qp_attr, &qp_attr_mask);
 	if (ret)
 		return ret;
 
-	return ibv_modify_qp(qp, &qp_attr, qp_attr_mask);
+	return rdma_modify_qp(&id_priv->id, &qp_attr, qp_attr_mask);
 }
 
-static int ucma_init_ud_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_ud_qp3(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int ret;
@@ -753,46 +771,46 @@
 	qp_attr.qp_state = IBV_QPS_INIT;
 	qp_attr.qkey = RDMA_UDP_QKEY;
 
-	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_QKEY |
+	ret = rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE | IBV_QP_QKEY |
 					  IBV_QP_PKEY_INDEX | IBV_QP_PORT);
 	if (ret)
 		return ret;
 
 	qp_attr.qp_state = IBV_QPS_RTR;
-	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE);
+	ret = rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE);
 	if (ret)
 		return ret;
 
 	qp_attr.qp_state = IBV_QPS_RTS;
 	qp_attr.sq_psn = 0;
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	return rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
 }
 
-static int ucma_init_ud_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_ud_qp(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
 	if (abi_ver == 3)
-		return ucma_init_ud_qp3(id_priv, qp);
+		return ucma_init_ud_qp3(id_priv);
 
 	qp_attr.qp_state = IBV_QPS_INIT;
 	ret = rdma_init_qp_attr(&id_priv->id, &qp_attr, &qp_attr_mask);
 	if (ret)
 		return ret;
 
-	ret = ibv_modify_qp(qp, &qp_attr, qp_attr_mask);
+	ret = rdma_modify_qp(&id_priv->id, &qp_attr, qp_attr_mask);
 	if (ret)
 		return ret;
 
 	qp_attr.qp_state = IBV_QPS_RTR;
-	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE);
+	ret = rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE);
 	if (ret)
 		return ret;
 
 	qp_attr.qp_state = IBV_QPS_RTS;
 	qp_attr.sq_psn = 0;
-	return ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
+	return rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE | IBV_QP_SQ_PSN);
 }
 
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
@@ -806,27 +824,43 @@
 	if (id->verbs != pd->context)
 		return ERR(EINVAL);
 
-	qp = ibv_create_qp(pd, qp_init_attr);
-	if (!qp)
-		return ERR(ENOMEM);
+	if (qp_init_attr->qp_type == IBV_QPT_XRC &&
+		qp_init_attr->cap.max_send_wr == 0) {
+		/* Special case: this is a receive XRC QP. */
+		ret = ibv_create_xrc_rcv_qp(qp_init_attr, &id->xrc_rcv_qpn);
+		if (ret)
+			return ERR(EINVAL);
+		id->xrc_domain = qp_init_attr->xrc_domain;
+		qp = NULL;
+	} else {
+		qp = ibv_create_qp(pd, qp_init_attr);
+		if (!qp)
+			return ERR(ENOMEM);
+	}
+
+	id->qp = qp;
 
 	if (ucma_is_ud_ps(id->ps))
-		ret = ucma_init_ud_qp(id_priv, qp);
+		ret = ucma_init_ud_qp(id_priv);
 	else
-		ret = ucma_init_conn_qp(id_priv, qp);
+		ret = ucma_init_conn_qp(id_priv);
 	if (ret)
 		goto err;
 
-	id->qp = qp;
 	return 0;
 err:
-	ibv_destroy_qp(qp);
+	id->qp = NULL;
+	if (qp)
+		ibv_destroy_qp(qp);
 	return ret;
 }
 
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
-	ibv_destroy_qp(id->qp);
+	if (id->xrc_domain)
+		ibv_unreg_xrc_rcv_qp(id->xrc_domain, id->xrc_rcv_qpn);
+	else
+		ibv_destroy_qp(id->qp);
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
@@ -938,10 +972,18 @@
 		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
 					     id->qp->qp_num,
 					     (id->qp->srq != NULL));
-	else
+	else {
+		uint32_t qp_num;
+
+		if (id->xrc_domain)
+			qp_num = id->xrc_rcv_qpn;
+		else
+			qp_num = conn_param->qp_num;
+
 		ucma_copy_conn_param_to_kern(&cmd->conn_param, conn_param,
-					     conn_param->qp_num,
-					     conn_param->srq);
+									 qp_num,
+									 conn_param->srq);
+	}
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {



--------------060303090503080503060608--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
