From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 11:49:56 -0500
Message-ID: <4C618334.7010106@systemfabricworks.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090505000603030801080002"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090505000603030801080002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Sean,

On 08/09/2010 03:53 PM, Hefty, Sean wrote:
>> This allow rdma ucm to establish an XRC connection between two nodes. Most
>> of the changes are related to modify_qp since the API is different
>> whether the QP is on the send or receive side.
>> To create an XRC receive QP, the cap.max_send_wr must be set to 0.
>> Conversely, to create the send XRC QP, that attribute must be non-zero.
> 
> I need to give XRC support to the librdmacm more thought, but here are at least the initial concerns:
> 
> - XRC support upstream (kernel and user space) is still pending.
>   (I can start a librdmacm branch for XRC support.)
> - Changes are needed to the kernel rdma_cm.
>   We could start submitting patches against Roland's xrc branch for these.
> - Please update to the latest librdmacm tree.
>   More specifically, rdma_getaddrinfo should support XRC as well.

The general parameters would be the same as for RC. Should we create a new ai_flag ? or a new port space ?
Is it really necessary to support rdma_getaddrinfo, rdma_create_ep and the new APIs ?

> In general, I'd like to find a way to add XRC support to the librdmacm that makes things as simple for the user as possible.

Besides the need to correctly set cap.max_send_wr, the user API is unchanged.

New patch attached.

--------------090505000603030801080002
Content-Type: text/x-patch;
 name="rdmacm-xrc-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rdmacm-xrc-v2.diff"

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index d17ef88..d18685b 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -125,6 +125,8 @@ struct rdma_cm_id {
 	struct ibv_cq		*send_cq;
 	struct ibv_comp_channel *recv_cq_channel;
 	struct ibv_cq		*recv_cq;
+ 	struct ibv_xrc_domain *xrc_domain;
+ 	uint32_t xrc_rcv_qpn;
 };
 
 enum {
diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
index 9d2de76..659e033 100644
--- a/man/rdma_create_qp.3
+++ b/man/rdma_create_qp.3
@@ -39,6 +39,10 @@ a send or receive completion queue is not specified, then a CQ will be
 allocated by the rdma_cm for the QP, along with corresponding completion
 channels.  Completion channels and CQ data created by the rdma_cm are
 exposed to the user through the rdma_cm_id structure.
+.P
+To create an XRC receive QP, and in addition to the XRC QP type,
+ibv_qp_init_attr.cap.max_send_wr must be set to 0. Conversely, to
+create the XRC send QP, that attribute must be non-zero.
 .SH "SEE ALSO"
 rdma_bind_addr(3), rdma_resolve_addr(3), rdma_destroy_qp(3), ibv_create_qp(3),
 ibv_modify_qp(3)
diff --git a/src/cma.c b/src/cma.c
index a4fd574..b4eec77 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -948,12 +948,29 @@ static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 	return 0;
 }
 
+static int rdma_modify_qp(struct rdma_cm_id *id, 
+						  struct ibv_qp_attr *qp_attr,
+						  int qp_attr_mask)
+{
+	int ret;
+
+	if (id->qp)
+		ret = ibv_modify_qp(id->qp, qp_attr, qp_attr_mask);
+	else if (id->xrc_domain)
+		ret = ibv_modify_xrc_rcv_qp(id->xrc_domain, id->xrc_rcv_qpn,
+									qp_attr, qp_attr_mask);
+	else 
+		ret = EINVAL;
+
+	return ret;
+}
+
 static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 {
 	struct ibv_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
-	if (!id->qp)
+	if (!id->qp && !id->xrc_domain)
 		return ERR(EINVAL);
 
 	/* Need to update QP attributes from default values. */
@@ -962,7 +979,7 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 	if (ret)
 		return ret;
 
-	ret = ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	ret = rdma_modify_qp(id, &qp_attr, qp_attr_mask);
 	if (ret)
 		return ERR(ret);
 
@@ -973,7 +990,7 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id, uint8_t resp_res)
 
 	if (resp_res != RDMA_MAX_RESP_RES)
 		qp_attr.max_dest_rd_atomic = resp_res;
-	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask));
+	return rdma_seterrno(rdma_modify_qp(id, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
@@ -988,29 +1005,29 @@ static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
 
 	if (init_depth != RDMA_MAX_INIT_DEPTH)
 		qp_attr.max_rd_atomic = init_depth;
-	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask));
+	return rdma_seterrno(rdma_modify_qp(id, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_modify_qp_sqd(struct rdma_cm_id *id)
 {
 	struct ibv_qp_attr qp_attr;
 
-	if (!id->qp)
+	if (!id->qp && !id->xrc_domain)
 		return 0;
 
 	qp_attr.qp_state = IBV_QPS_SQD;
-	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
+	return rdma_seterrno(rdma_modify_qp(id, &qp_attr, IBV_QP_STATE));
 }
 
 static int ucma_modify_qp_err(struct rdma_cm_id *id)
 {
 	struct ibv_qp_attr qp_attr;
 
-	if (!id->qp)
+	if (!id->qp && !id->xrc_domain)
 		return 0;
 
 	qp_attr.qp_state = IBV_QPS_ERR;
-	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
+	return rdma_seterrno(rdma_modify_qp(id, &qp_attr, IBV_QP_STATE));
 }
 
 static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
@@ -1029,7 +1046,7 @@ static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
 	return ERR(EINVAL);
 }
 
-static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_conn_qp3(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int ret;
@@ -1044,25 +1061,25 @@ static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
 	qp_attr.qp_state = IBV_QPS_INIT;
 	qp_attr.qp_access_flags = 0;
 
-	ret = ibv_modify_qp(qp, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
+	ret = rdma_modify_qp(&id_priv->id, &qp_attr, IBV_QP_STATE | IBV_QP_ACCESS_FLAGS |
 					  IBV_QP_PKEY_INDEX | IBV_QP_PORT);
 	return rdma_seterrno(ret);
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
 
-	return rdma_seterrno(ibv_modify_qp(qp, &qp_attr, qp_attr_mask));
+	return rdma_seterrno(rdma_modify_qp(&id_priv->id, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_init_ud_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
@@ -1190,33 +1207,54 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	if (ret)
 		return ret;
 
-	qp = ibv_create_qp(pd, qp_init_attr);
-	if (!qp) {
-		ret = ERR(ENOMEM);
-		goto err1;
+	if (qp_init_attr->qp_type == IBV_QPT_XRC &&
+		qp_init_attr->cap.max_send_wr == 0) {
+		/* Special case: this is a receive XRC QP. */
+		ret = ibv_create_xrc_rcv_qp(qp_init_attr, &id->xrc_rcv_qpn);
+		if (ret) {
+			ret = ERR(ret);
+			goto err1;
+		}
+		id->xrc_domain = qp_init_attr->xrc_domain;
+		qp = NULL;
+	} else {
+		qp = ibv_create_qp(pd, qp_init_attr);
+		if (!qp) {
+			ret = ERR(ENOMEM);
+			goto err1;
+		}
 	}
 
+	id->qp = qp;
+
 	if (ucma_is_ud_ps(id->ps))
 		ret = ucma_init_ud_qp(id_priv, qp);
 	else
-		ret = ucma_init_conn_qp(id_priv, qp);
+		ret = ucma_init_conn_qp(id_priv);
 	if (ret)
 		goto err2;
 
-	id->qp = qp;
 	return 0;
 err2:
-	ibv_destroy_qp(qp);
+	if (qp)
+		ibv_destroy_qp(qp);
 err1:
+	id->qp = NULL;
+	id->xrc_domain = NULL;
 	ucma_destroy_cqs(id);
 	return ret;
 }
 
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
-	ibv_destroy_qp(id->qp);
+	if (id->xrc_domain) {
+		ibv_unreg_xrc_rcv_qp(id->xrc_domain, id->xrc_rcv_qpn);
+		id->xrc_domain = NULL;
+	} else {
+		ibv_destroy_qp(id->qp);
+		id->qp = NULL;
+	}
 	ucma_destroy_cqs(id);
-	id->qp = NULL;
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
@@ -1428,10 +1466,18 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
 					     conn_param, id->qp->qp_num,
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
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
-					     conn_param, conn_param->qp_num,
+					     conn_param, qp_num,
 					     conn_param->srq);
+	}
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {

--------------090505000603030801080002--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
