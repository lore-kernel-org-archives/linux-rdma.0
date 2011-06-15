From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] librdmacm: Abstract ibverbs SRQ creation
Date: Wed, 15 Jun 2011 17:41:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730212DD@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support QPs with SRQs.  If a user allocates an SRQ on an
rdma_cm_id, we post receive messages directly to the SRQ.
This also allows us to handle XRC SRQs, which may be associated
with an rdma_cm_id, but without a corresponding QP.

To handle registering memory, we store the PD associated
with an rdma_cm_id directly with the id, rather than finding
the PD using a QP pointer.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_cma.h   |    2 +
 include/rdma/rdma_verbs.h |   26 +++++++++++---
 src/cma.c                 |   81 +++++++++++++++++++++++++++++++++++++--------
 src/librdmacm.map         |    2 +
 4 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index ab6016e..799a295 100755
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -125,6 +125,8 @@ struct rdma_cm_id {
 	struct ibv_cq		*send_cq;
 	struct ibv_comp_channel *recv_cq_channel;
 	struct ibv_cq		*recv_cq;
+	struct ibv_srq		*srq;
+	struct ibv_pd		*pd;
 };
 
 enum {
diff --git a/include/rdma/rdma_verbs.h b/include/rdma/rdma_verbs.h
index e6a6b42..eca2c7a 100644
--- a/include/rdma/rdma_verbs.h
+++ b/include/rdma/rdma_verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2010-2011 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -52,26 +52,35 @@ static inline int rdma_seterrno(int ret)
 }
 
 /*
+ * Shared receive queues.
+ */
+int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
+		    struct ibv_srq_init_attr *attr);
+
+void rdma_destroy_srq(struct rdma_cm_id *id);
+
+
+/*
  * Memory registration helpers.
  */
 static inline struct ibv_mr *
 rdma_reg_msgs(struct rdma_cm_id *id, void *addr, size_t length)
 {
-	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE);
+	return ibv_reg_mr(id->pd, addr, length, IBV_ACCESS_LOCAL_WRITE);
 }
 
 static inline struct ibv_mr *
 rdma_reg_read(struct rdma_cm_id *id, void *addr, size_t length)
 {
-	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
-						    IBV_ACCESS_REMOTE_READ);
+	return ibv_reg_mr(id->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
+						IBV_ACCESS_REMOTE_READ);
 }
 
 static inline struct ibv_mr *
 rdma_reg_write(struct rdma_cm_id *id, void *addr, size_t length)
 {
-	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
-						    IBV_ACCESS_REMOTE_WRITE);
+	return ibv_reg_mr(id->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
+						IBV_ACCESS_REMOTE_WRITE);
 }
 
 static inline int
@@ -96,7 +105,10 @@ rdma_post_recvv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
 	wr.sg_list = sgl;
 	wr.num_sge = nsge;
 
-	return rdma_seterrno(ibv_post_recv(id->qp, &wr, &bad));
+	if (id->srq)
+		return rdma_seterrno(ibv_post_srq_recv(id->srq, &wr, &bad));
+	else
+		return rdma_seterrno(ibv_post_recv(id->qp, &wr, &bad));
 }
 
 static inline int
diff --git a/src/cma.c b/src/cma.c
index d6cb626..e5ea7db 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -116,7 +116,6 @@ struct cma_id_private {
 	pthread_mutex_t		mut;
 	uint32_t		handle;
 	struct cma_multicast	*mc_list;
-	struct ibv_pd		*pd;
 	struct ibv_qp_init_attr	*qp_init_attr;
 	uint8_t			initiator_depth;
 	uint8_t			responder_resources;
@@ -387,6 +386,7 @@ static int ucma_get_device(struct cma_id_private *id_priv, uint64_t guid)
 		if (cma_dev->guid == guid) {
 			id_priv->cma_dev = cma_dev;
 			id_priv->id.verbs = cma_dev->verbs;
+			id_priv->id.pd = cma_dev->pd;
 			return 0;
 		}
 	}
@@ -1141,32 +1141,28 @@ static void ucma_destroy_cqs(struct rdma_cm_id *id)
 		ibv_destroy_comp_channel(id->send_cq_channel);
 }
 
-static int ucma_create_cqs(struct rdma_cm_id *id, struct ibv_qp_init_attr *attr)
+static int ucma_create_cqs(struct rdma_cm_id *id, uint32_t send_size, uint32_t recv_size)
 {
-	if (!attr->recv_cq) {
+	if (recv_size) {
 		id->recv_cq_channel = ibv_create_comp_channel(id->verbs);
 		if (!id->recv_cq_channel)
 			goto err;
 
-		id->recv_cq = ibv_create_cq(id->verbs, attr->cap.max_recv_wr,
+		id->recv_cq = ibv_create_cq(id->verbs, recv_size,
 					    id, id->recv_cq_channel, 0);
 		if (!id->recv_cq)
 			goto err;
-
-		attr->recv_cq = id->recv_cq;
 	}
 
-	if (!attr->send_cq) {
+	if (send_size) {
 		id->send_cq_channel = ibv_create_comp_channel(id->verbs);
 		if (!id->send_cq_channel)
 			goto err;
 
-		id->send_cq = ibv_create_cq(id->verbs, attr->cap.max_send_wr,
+		id->send_cq = ibv_create_cq(id->verbs, send_size,
 					    id, id->send_cq_channel, 0);
 		if (!id->send_cq)
 			goto err;
-
-		attr->send_cq = id->send_cq;
 	}
 
 	return 0;
@@ -1175,6 +1171,53 @@ err:
 	return ERR(ENOMEM);
 }
 
+int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
+		    struct ibv_srq_init_attr *attr)
+{
+	struct cma_id_private *id_priv;
+	struct ibv_srq *srq;
+	int ret;
+
+	id_priv = container_of(id, struct cma_id_private, id);
+	if (!pd)
+		pd = id->pd;
+
+#ifdef IBV_XRC_OPS
+	if (attr->srq_type == IBV_SRQT_XRC) {
+		if (!attr->ext.xrc.cq) {
+			ret = ucma_create_cqs(id, 0, attr->attr.max_wr);
+			if (ret)
+				return ret;
+
+			attr->ext.xrc.cq = id->recv_cq;
+		}
+	}
+
+	srq = ibv_create_xsrq(pd, attr);
+#else
+	srq = ibv_create_srq(pd, attr);
+#endif
+	if (!srq) {
+		ret = -1;
+		goto err;
+	}
+
+	id->pd = pd;
+	id->srq = srq;
+	return 0;
+err:
+	ucma_destroy_cqs(id);
+	return ret;
+}
+
+void rdma_destroy_srq(struct rdma_cm_id *id)
+{
+	ibv_destroy_srq(id->srq);
+	if (!id->qp)
+		ucma_destroy_cqs(id);
+	id->srq = NULL;
+}
+
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		   struct ibv_qp_init_attr *qp_init_attr)
 {
@@ -1187,14 +1230,19 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (!pd)
-		pd = id_priv->cma_dev->pd;
+		pd = id->pd;
 	else if (id->verbs != pd->context)
 		return ERR(EINVAL);
 
-	ret = ucma_create_cqs(id, qp_init_attr);
+	ret = ucma_create_cqs(id, qp_init_attr->send_cq ? 0 : qp_init_attr->cap.max_send_wr,
+			      qp_init_attr->recv_cq ? 0 : qp_init_attr->cap.max_recv_wr);
 	if (ret)
 		return ret;
 
+	if (!qp_init_attr->send_cq)
+		qp_init_attr->send_cq = id->send_cq;
+	if (!qp_init_attr->recv_cq)
+		qp_init_attr->recv_cq = id->recv_cq;
 	qp = ibv_create_qp(pd, qp_init_attr);
 	if (!qp) {
 		ret = ERR(ENOMEM);
@@ -1208,6 +1256,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	if (ret)
 		goto err2;
 
+	id->pd = pd;
 	id->qp = qp;
 	return 0;
 err2:
@@ -1380,7 +1429,7 @@ int rdma_get_request(struct rdma_cm_id *listen, struct rdma_cm_id **id)
 		struct ibv_qp_init_attr attr;
 
 		attr = *id_priv->qp_init_attr;
-		ret = rdma_create_qp(event->id, id_priv->pd, &attr);
+		ret = rdma_create_qp(event->id, listen->pd, &attr);
 		if (ret)
 			goto err;
 	}
@@ -2107,7 +2156,8 @@ static int ucma_passive_ep(struct rdma_cm_id *id, struct rdma_addrinfo *res,
 		return ret;
 
 	id_priv = container_of(id, struct cma_id_private, id);
-	id_priv->pd = pd;
+	if (pd)
+		id->pd = pd;
 
 	if (qp_init_attr) {
 		id_priv->qp_init_attr = malloc(sizeof *qp_init_attr);
@@ -2192,6 +2242,9 @@ void rdma_destroy_ep(struct rdma_cm_id *id)
 	if (id->qp)
 		rdma_destroy_qp(id);
 
+	if (id->srq)
+		rdma_destroy_srq(id);
+
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (id_priv->qp_init_attr)
 		free(id_priv->qp_init_attr);
diff --git a/src/librdmacm.map b/src/librdmacm.map
index 19b193a..b3235ff 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -33,5 +33,7 @@ RDMACM_1.0 {
 		rdma_get_request;
 		rdma_create_ep;
 		rdma_destroy_ep;
+		rdma_create_srq;
+		rdma_destroy_srq;
 	local: *;
 };


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
