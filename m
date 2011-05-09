From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [RFC] RDMA CM + XRC, take two
Date: Mon, 09 May 2011 17:33:22 -0500
Message-ID: <4DC86BB2.1020002@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070104050205000905070100"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070104050205000905070100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

This is an improved version of my previous patch to add XRC support to RDMA CM.

This version now support the newer rdma CM interface. It needs some polishing but it works.

It modifies the rdma_client/server examples to use xrc instead of rc.

The big hack is that the SRQ number needs to be transmitted to the remote side. This patch hijacks the private data, so it's not acceptable. Ideally the SRQ number should be transmitted either in the REQ or REP packet (depending on which side the sender or the receiver) alongside the QP number. But that would need a change in the specs. Any suggestions ?

Also a good chunk of the patch is to deal with the XRC verbs API. I wonder whether XRC could/should be more integrated into the existing verbs:
- sender should not need a domain,
- there should be 2 types of xrc QPs (send and receive) instead of one,
- *_xrc_rcv_qp verbs should be abstracted under the cover in libibverbs,

Regards,
  frank.

--------------070104050205000905070100
Content-Type: text/x-diff;
 name="rdmacm-xrc-v4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rdmacm-xrc-v4.diff"

diff -rubw librdmacm-1.0.14.1.org/examples/rdma_client.c librdmacm-1.0.14.1/examples/rdma_client.c
--- librdmacm-1.0.14.1.org/examples/rdma_client.c	2010-10-04 19:00:18.000000000 -0500
+++ librdmacm-1.0.14.1/examples/rdma_client.c	2011-05-09 16:40:05.000000000 -0500
@@ -52,6 +52,7 @@
 
 	memset(&hints, 0, sizeof hints);
 	hints.ai_port_space = RDMA_PS_TCP;
+	hints.ai_qp_type = IBV_QPT_XRC;
 	ret = rdma_getaddrinfo(server, port, &hints, &res);
 	if (ret) {
 		printf("rdma_getaddrinfo %d\n", errno);
@@ -77,12 +78,6 @@
 		return ret;
 	}
 
-	ret = rdma_post_recv(id, NULL, recv_msg, 16, mr);
-	if (ret) {
-		printf("rdma_post_recv %d\n", errno);
-		return ret;
-	}
-
 	ret = rdma_connect(id, NULL);
 	if (ret) {
 		printf("rdma_connect %d\n", errno);
@@ -95,7 +90,7 @@
 		return ret;
 	}
 
-	ret = rdma_get_recv_comp(id, &wc);
+	ret = rdma_get_send_comp(id, &wc);
 	if (ret <= 0) {
 		printf("rdma_get_recv_comp %d\n", ret);
 		return ret;
diff -rubw librdmacm-1.0.14.1.org/examples/rdma_server.c librdmacm-1.0.14.1/examples/rdma_server.c
--- librdmacm-1.0.14.1.org/examples/rdma_server.c	2010-10-04 19:00:18.000000000 -0500
+++ librdmacm-1.0.14.1/examples/rdma_server.c	2011-05-06 16:01:51.000000000 -0500
@@ -53,6 +53,7 @@
 	memset(&hints, 0, sizeof hints);
 	hints.ai_flags = RAI_PASSIVE;
 	hints.ai_port_space = RDMA_PS_TCP;
+	hints.ai_qp_type = IBV_QPT_XRC;
 	ret = rdma_getaddrinfo(NULL, port, &hints, &res);
 	if (ret) {
 		printf("rdma_getaddrinfo %d\n", errno);
@@ -60,7 +61,8 @@
 	}
 
 	memset(&attr, 0, sizeof attr);
-	attr.cap.max_send_wr = attr.cap.max_recv_wr = 1;
+	attr.cap.max_send_wr = 0;	/* means XRC receive */
+	attr.cap.max_recv_wr = 1;
 	attr.cap.max_send_sge = attr.cap.max_recv_sge = 1;
 	attr.cap.max_inline_data = 16;
 	attr.sq_sig_all = 1;
@@ -97,7 +99,7 @@
 
 	ret = rdma_accept(id, NULL);
 	if (ret) {
-		printf("rdma_connect %d\n", errno);
+		printf("rdma_accept %d\n", errno);
 		return ret;
 	}
 
@@ -107,18 +109,6 @@
 		return ret;
 	}
 
-	ret = rdma_post_send(id, NULL, send_msg, 16, NULL, IBV_SEND_INLINE);
-	if (ret) {
-		printf("rdma_post_send %d\n", errno);
-		return ret;
-	}
-
-	ret = rdma_get_send_comp(id, &wc);
-	if (ret <= 0) {
-		printf("rdma_get_send_comp %d\n", ret);
-		return ret;
-	}
-
 	rdma_disconnect(id);
 	rdma_dereg_mr(mr);
 	rdma_destroy_ep(id);
diff -rubw librdmacm-1.0.14.1.org/include/rdma/rdma_cma.h librdmacm-1.0.14.1/include/rdma/rdma_cma.h
--- librdmacm-1.0.14.1.org/include/rdma/rdma_cma.h	2010-12-10 14:05:34.000000000 -0600
+++ librdmacm-1.0.14.1/include/rdma/rdma_cma.h	2011-05-06 10:22:36.000000000 -0500
@@ -125,6 +125,14 @@
 	struct ibv_cq		*send_cq;
 	struct ibv_comp_channel *recv_cq_channel;
 	struct ibv_cq		*recv_cq;
+
+	/* XRC support */
+ 	struct ibv_xrc_domain *xrc_domain;
+	struct ibv_srq *xrc_srq;	/* if receive side */
+ 	union {
+		uint32_t xrc_rcv_qpn;	/* if receive side */
+		uint32_t xrc_srq_num;	/* if send side */
+	};
 };
 
 enum {
diff -rubw librdmacm-1.0.14.1.org/include/rdma/rdma_verbs.h librdmacm-1.0.14.1/include/rdma/rdma_verbs.h
--- librdmacm-1.0.14.1.org/include/rdma/rdma_verbs.h	2010-12-10 14:05:34.000000000 -0600
+++ librdmacm-1.0.14.1/include/rdma/rdma_verbs.h	2011-05-06 15:26:47.000000000 -0500
@@ -57,7 +57,10 @@
 static inline struct ibv_mr *
 rdma_reg_msgs(struct rdma_cm_id *id, void *addr, size_t length)
 {
+	if (id->qp)
 	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE);
+	else
+		return ibv_reg_mr(id->xrc_srq->pd, addr, length, IBV_ACCESS_LOCAL_WRITE);
 }
 
 static inline struct ibv_mr *
@@ -96,7 +99,10 @@
 	wr.sg_list = sgl;
 	wr.num_sge = nsge;
 
+	if (id->qp)
 	return rdma_seterrno(ibv_post_recv(id->qp, &wr, &bad));
+	else
+		return rdma_seterrno(ibv_post_srq_recv(id->xrc_srq, &wr, &bad));
 }
 
 static inline int
@@ -111,6 +117,7 @@
 	wr.num_sge = nsge;
 	wr.opcode = IBV_WR_SEND;
 	wr.send_flags = flags;
+	wr.xrc_remote_srq_num = id->xrc_srq_num;
 
 	return rdma_seterrno(ibv_post_send(id->qp, &wr, &bad));
 }
diff -rubw librdmacm-1.0.14.1.org/man/rdma_create_qp.3 librdmacm-1.0.14.1/man/rdma_create_qp.3
--- librdmacm-1.0.14.1.org/man/rdma_create_qp.3	2010-12-10 14:05:34.000000000 -0600
+++ librdmacm-1.0.14.1/man/rdma_create_qp.3	2011-05-05 11:53:53.000000000 -0500
@@ -40,6 +40,10 @@
 channels.  Completion channels and CQ data created by the rdma_cm are
 exposed to the user through the rdma_cm_id structure.
 .P
+To create an XRC receive QP, and in addition to the XRC QP type,
+ibv_qp_init_attr.cap.max_send_wr must be set to 0. Conversely, to
+create the XRC send QP, that attribute must be non-zero.
+.P
 The actual capabilities and properties of the created QP will be
 returned to the user through the qp_init_attr parameter.
 .SH "SEE ALSO"
diff -rubw librdmacm-1.0.14.1.org/src/addrinfo.c librdmacm-1.0.14.1/src/addrinfo.c
--- librdmacm-1.0.14.1.org/src/addrinfo.c	2010-12-10 14:05:34.000000000 -0600
+++ librdmacm-1.0.14.1/src/addrinfo.c	2011-05-06 16:20:52.000000000 -0500
@@ -82,7 +82,8 @@
 	ai->ai_next = NULL;
 }
 
-static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
+static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai,
+							   struct rdma_addrinfo *hints)
 {
 	struct sockaddr *addr;
 	char *canonname;
@@ -91,6 +92,9 @@
 
 	switch (ai->ai_socktype) {
 	case SOCK_STREAM:
+		if (hints && hints->ai_qp_type == IBV_QPT_XRC)
+			rai->ai_qp_type = IBV_QPT_XRC;
+		else
 		rai->ai_qp_type = IBV_QPT_RC;
 		break;
 	case SOCK_DGRAM:
@@ -149,7 +153,7 @@
 	if (ret)
 		return ret;
 
-	ret = ucma_convert_to_rai(rai, ai);
+	ret = ucma_convert_to_rai(rai, ai, hints);
 	freeaddrinfo(ai);
 	return ret;
 }
diff -rubw librdmacm-1.0.14.1.org/src/cma.c librdmacm-1.0.14.1/src/cma.c
--- librdmacm-1.0.14.1.org/src/cma.c	2010-12-10 14:05:34.000000000 -0600
+++ librdmacm-1.0.14.1/src/cma.c	2011-05-09 17:15:53.000000000 -0500
@@ -944,12 +944,29 @@
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
@@ -958,7 +975,7 @@
 	if (ret)
 		return ret;
 
-	ret = ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask);
+	ret = rdma_modify_qp(id, &qp_attr, qp_attr_mask);
 	if (ret)
 		return ERR(ret);
 
@@ -969,7 +986,7 @@
 
 	if (resp_res != RDMA_MAX_RESP_RES)
 		qp_attr.max_dest_rd_atomic = resp_res;
-	return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, qp_attr_mask));
+	return rdma_seterrno(rdma_modify_qp(id, &qp_attr, qp_attr_mask));
 }
 
 static int ucma_modify_qp_rts(struct rdma_cm_id *id, uint8_t init_depth)
@@ -984,29 +1001,29 @@
 
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
@@ -1025,7 +1042,7 @@
 	return ERR(EINVAL);
 }
 
-static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
+static int ucma_init_conn_qp3(struct cma_id_private *id_priv)
 {
 	struct ibv_qp_attr qp_attr;
 	int ret;
@@ -1040,25 +1057,25 @@
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
@@ -1137,7 +1154,7 @@
 
 static int ucma_create_cqs(struct rdma_cm_id *id, struct ibv_qp_init_attr *attr)
 {
-	if (!attr->recv_cq) {
+	if (!attr->recv_cq /*&& !(attr->qp_type == IBV_QPT_XRC && attr->cap.max_send_wr != 0)*/) {
 		id->recv_cq_channel = ibv_create_comp_channel(id->verbs);
 		if (!id->recv_cq_channel)
 			goto err;
@@ -1150,7 +1167,7 @@
 		attr->recv_cq = id->recv_cq;
 	}
 
-	if (!attr->send_cq) {
+	if (!attr->send_cq && !(attr->qp_type == IBV_QPT_XRC && attr->cap.max_send_wr == 0)) {
 		id->send_cq_channel = ibv_create_comp_channel(id->verbs);
 		if (!id->send_cq_channel)
 			goto err;
@@ -1175,45 +1192,141 @@
 	struct cma_id_private *id_priv;
 	struct ibv_qp *qp;
 	int ret;
+	struct ibv_xrc_domain *xrc_domain = NULL;
+	struct ibv_srq *xrc_srq = NULL;
 
 	id_priv = container_of(id, struct cma_id_private, id);
+
 	if (!pd)
 		pd = id_priv->cma_dev->pd;
 	else if (id->verbs != pd->context)
 		return ERR(EINVAL);
 
+	/* TODO: if xrc domain, create either the send or recv CQ. Should
+	 * split ucma_create_cqs(). */
 	ret = ucma_create_cqs(id, qp_init_attr);
 	if (ret)
 		return ret;
 
+	/* If no XRC domain/SRQ was passed, create one. */
+	if (qp_init_attr->qp_type == IBV_QPT_XRC 
+		/* Note: for some reason, a send QP must also have a domain.
+		   && qp_init_attr->cap.max_send_wr == 0*/) {
+		/* a receive side must only have a domain with an srq, or just
+		 * a domain, or nothing at all. */
+		if (qp_init_attr->cap.max_send_wr == 0 && 
+			!qp_init_attr->xrc_domain &&
+			qp_init_attr->srq) {
+			ret = ERR(EINVAL);
+			goto err1;
+		}
+
+		if (!qp_init_attr->xrc_domain) {
+			xrc_domain = ibv_open_xrc_domain(pd->context, -1, O_CREAT);
+			if (!xrc_domain) {
+				ret = ERR(EINVAL);
+				goto err1;
+			}
+			qp_init_attr->xrc_domain = xrc_domain;
+		}
+	}
+
+	if (qp_init_attr->qp_type == IBV_QPT_XRC &&
+		qp_init_attr->cap.max_send_wr == 0) {
+		/* Special case: this is a receive XRC QP. */
+
+		if (!qp_init_attr->srq) {
+			struct ibv_srq_init_attr srq_init_attr;
+
+			memset(&srq_init_attr, 0, sizeof(struct ibv_srq_init_attr));
+
+			srq_init_attr.srq_context = pd->context;
+			srq_init_attr.attr.max_wr = qp_init_attr->cap.max_recv_wr;
+			srq_init_attr.attr.max_sge = qp_init_attr->cap.max_recv_sge;
+			srq_init_attr.attr.srq_limit = 0; /* should be ignored */
+			
+			xrc_srq = ibv_create_xrc_srq(pd,
+										 qp_init_attr->xrc_domain,
+										 id->recv_cq,
+										 &srq_init_attr);
+			if (!xrc_srq) {
+				ret = ERR(EINVAL);
+				goto err1;
+			}
+
+			qp_init_attr->srq = xrc_srq;
+		}
+
+		id->xrc_srq = qp_init_attr->srq;
+
+		ret = ibv_create_xrc_rcv_qp(qp_init_attr, &id->xrc_rcv_qpn);
+		if (ret) {
+			ret = ERR(ret);
+			goto err1;
+		}
+		id->xrc_domain = qp_init_attr->xrc_domain;
+		qp = NULL;
+
+	} else {
 	qp = ibv_create_qp(pd, qp_init_attr);
 	if (!qp) {
 		ret = ERR(ENOMEM);
 		goto err1;
 	}
+	}
+
+	id->qp = qp;
 
 	if (ucma_is_ud_ps(id->ps))
 		ret = ucma_init_ud_qp(id_priv, qp);
 	else
-		ret = ucma_init_conn_qp(id_priv, qp);
+		ret = ucma_init_conn_qp(id_priv);
 	if (ret)
 		goto err2;
 
-	id->qp = qp;
 	return 0;
+
 err2:
+	if (qp)
 	ibv_destroy_qp(qp);
+	else if (xrc_domain && id->xrc_rcv_qpn)
+		ibv_unreg_xrc_rcv_qp(xrc_domain, id->xrc_rcv_qpn);
+
 err1:
+	if (xrc_srq) {
+		qp_init_attr->srq = NULL;
+		ibv_destroy_srq(xrc_srq);
+	}
+
+	if (xrc_domain) {
+		qp_init_attr->xrc_domain = NULL;
+		ibv_close_xrc_domain(xrc_domain);
+	}
+
+	id->qp = NULL;
+	id->xrc_domain = NULL;
 	ucma_destroy_cqs(id);
 	return ret;
 }
 
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
+	if (id->qp) {
 	ibv_destroy_qp(id->qp);
-	ucma_destroy_cqs(id);
 	id->qp = NULL;
 }
+	else if (id->xrc_domain) {
+		ibv_unreg_xrc_rcv_qp(id->xrc_domain, id->xrc_rcv_qpn);
+		/* TODO: we must only destroy domain/SRQ if we created them. */
+		if (id->xrc_srq) {
+			ibv_destroy_srq(id->xrc_srq);
+			id->xrc_srq = NULL;
+		}
+		ibv_close_xrc_domain(id->xrc_domain);
+		id->xrc_domain = NULL;
+	}
+	ucma_destroy_cqs(id);
+}
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
 			    struct rdma_conn_param *param)
@@ -1221,7 +1334,7 @@
 	if (id_priv->id.ps != RDMA_PS_TCP)
 		return 0;
 
-	if (!id_priv->id.qp && !param)
+	if (!id_priv->id.qp && !id_priv->id.xrc_srq && !param)
 		goto err;
 
 	if (!param)
@@ -1313,7 +1426,16 @@
 		id_priv->connect_len = 0;
 	}
 
-	return ucma_complete(id_priv);
+	ret = ucma_complete(id_priv);
+	if (ret)
+		return ret;
+
+	{
+		// HACK: retrieve the SRQ number
+		id->xrc_srq_num = *(uint32_t *)id->event->param.conn.private_data;
+	}
+
+	return ret;
 }
 
 int rdma_listen(struct rdma_cm_id *id, int backlog)
@@ -1391,12 +1513,33 @@
 	struct cma_id_private *id_priv;
 	void *msg;
 	int ret, size;
+	struct rdma_conn_param my_conn_param;
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	ret = ucma_valid_param(id_priv, conn_param);
 	if (ret)
 		return ret;
 
+	{
+		// HACK: add srq number; hijack the private data
+		if (conn_param) {
+			printf("too bad\n");
+			return ERR(EINVAL);
+		}
+
+		memset(&my_conn_param, 0, sizeof(struct rdma_conn_param));
+		my_conn_param.private_data = &id->xrc_srq->xrc_srq_num;
+		my_conn_param.private_data_len = sizeof(id->xrc_rcv_qpn);
+
+		my_conn_param.initiator_depth = min(id_priv->initiator_depth,
+											id_priv->cma_dev->max_initiator_depth);
+		my_conn_param.responder_resources = min(id_priv->responder_resources,
+												id_priv->cma_dev->max_responder_resources);
+
+		conn_param = &my_conn_param;
+	}
+
+
 	if (!conn_param || conn_param->initiator_depth == RDMA_MAX_INIT_DEPTH) {
 		id_priv->initiator_depth = min(id_priv->initiator_depth,
 					       id_priv->cma_dev->max_initiator_depth);
@@ -1427,10 +1570,19 @@
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
 					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
-	else
+	else {
+		uint32_t qp_num;
+
+		if (id->xrc_domain) {
+			qp_num = id->xrc_rcv_qpn;
+		} else {
+			qp_num = conn_param->qp_num;
+		}
+
 		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
-					     conn_param, conn_param->qp_num,
-					     conn_param->srq);
+									 conn_param, qp_num,
+									 !!id->xrc_domain);
+	}
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {
@@ -2180,7 +2332,7 @@
 {
 	struct cma_id_private *id_priv;
 
-	if (id->qp)
+	if (id->qp || id->xrc_domain)
 		rdma_destroy_qp(id);
 
 	id_priv = container_of(id, struct cma_id_private, id);

--------------070104050205000905070100--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
