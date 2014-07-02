From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/8] rdmacm: Add support for allocating XRC SRQs
Date: Tue,  1 Jul 2014 23:11:16 -0700
Message-ID: <1404281479-6755-6-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add extended SRQ creation call, to support allocating
XRC SRQs.  Use the rdma_cm_id qp type field to
determine which type of SRQ should be allocated.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_verbs.h |    3 +-
 src/cma.c                 |   85 +++++++++++++++++++++++++++++++-------------
 src/librdmacm.map         |    1 +
 3 files changed, 63 insertions(+), 26 deletions(-)

diff --git a/include/rdma/rdma_verbs.h b/include/rdma/rdma_verbs.h
index 198c6a5..10049c3 100644
--- a/include/rdma/rdma_verbs.h
+++ b/include/rdma/rdma_verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010-2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2010-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -56,6 +56,7 @@ static inline int rdma_seterrno(int ret)
  */
 int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
 		    struct ibv_srq_init_attr *attr);
+int rdma_create_srq_ex(struct rdma_cm_id *id, struct ibv_srq_init_attr_ex *attr);
 
 void rdma_destroy_srq(struct rdma_cm_id *id);
 
diff --git a/src/cma.c b/src/cma.c
index 52d81ff..8c9ea95 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -1210,17 +1210,26 @@ static int ucma_init_ud_qp(struct cma_id_private *id_priv, struct ibv_qp *qp)
 
 static void ucma_destroy_cqs(struct rdma_cm_id *id)
 {
-	if (id->recv_cq)
+	if (id->qp_type == IBV_QPT_XRC_RECV && id->srq)
+		return;
+
+	if (id->recv_cq) {
 		ibv_destroy_cq(id->recv_cq);
+		if (id->send_cq && (id->send_cq != id->recv_cq)) {
+			ibv_destroy_cq(id->send_cq);
+			id->send_cq = NULL;
+		}
+		id->recv_cq = NULL;
+	}
 
-	if (id->recv_cq_channel)
+	if (id->recv_cq_channel) {
 		ibv_destroy_comp_channel(id->recv_cq_channel);
-
-	if (id->send_cq && (id->send_cq != id->recv_cq))
-		ibv_destroy_cq(id->send_cq);
-
-	if (id->send_cq_channel && (id->send_cq_channel != id->recv_cq_channel))
-		ibv_destroy_comp_channel(id->send_cq_channel);
+		if (id->send_cq_channel && (id->send_cq_channel != id->recv_cq_channel)) {
+			ibv_destroy_comp_channel(id->send_cq_channel);
+			id->send_cq_channel = NULL;
+		}
+		id->recv_cq_channel = NULL;
+	}
 }
 
 static int ucma_create_cqs(struct rdma_cm_id *id, uint32_t send_size, uint32_t recv_size)
@@ -1253,36 +1262,44 @@ err:
 	return ERR(ENOMEM);
 }
 
-int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
-		    struct ibv_srq_init_attr *attr)
+int rdma_create_srq_ex(struct rdma_cm_id *id, struct ibv_srq_init_attr_ex *attr)
 {
+	struct cma_id_private *id_priv;
 	struct ibv_srq *srq;
 	int ret;
 
-	if (!pd)
-		pd = id->pd;
+	id_priv = container_of(id, struct cma_id_private, id);
+	if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_TYPE))
+		return ERR(EINVAL);
+
+	if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_PD) || !attr->pd) {
+		attr->pd = id->pd;
+		attr->comp_mask |= IBV_SRQ_INIT_ATTR_PD;
+	}
 
-#ifdef IBV_XRC_OPS
 	if (attr->srq_type == IBV_SRQT_XRC) {
-		if (!attr->ext.xrc.cq) {
+		if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_XRCD) || !attr->xrcd) {
+			attr->xrcd = ucma_get_xrcd(id_priv->cma_dev);
+			if (!attr->xrcd)
+				return -1;
+		}
+		if (!(attr->comp_mask & IBV_SRQ_INIT_ATTR_CQ) || !attr->cq) {
 			ret = ucma_create_cqs(id, 0, attr->attr.max_wr);
 			if (ret)
 				return ret;
-
-			attr->ext.xrc.cq = id->recv_cq;
+			attr->cq = id->recv_cq;
 		}
+		attr->comp_mask |= IBV_SRQ_INIT_ATTR_XRCD | IBV_SRQ_INIT_ATTR_CQ;
 	}
 
-	srq = ibv_create_xsrq(pd, attr);
-#else
-	srq = ibv_create_srq(pd, attr);
-#endif
+	srq = ibv_create_srq_ex(id->verbs, attr);
 	if (!srq) {
 		ret = -1;
 		goto err;
 	}
 
-	id->pd = pd;
+	if (!id->pd)
+		id->pd = attr->pd;
 	id->srq = srq;
 	return 0;
 err:
@@ -1290,12 +1307,30 @@ err:
 	return ret;
 }
 
+int rdma_create_srq(struct rdma_cm_id *id, struct ibv_pd *pd,
+		    struct ibv_srq_init_attr *attr)
+{
+	struct ibv_srq_init_attr_ex attr_ex;
+	int ret;
+
+	memcpy(&attr_ex, attr, sizeof *attr);
+	attr_ex.comp_mask = IBV_SRQ_INIT_ATTR_TYPE | IBV_SRQ_INIT_ATTR_PD;
+	if (id->qp_type == IBV_QPT_XRC_RECV) {
+		attr_ex.srq_type = IBV_SRQT_XRC;
+	} else {
+		attr_ex.srq_type = IBV_SRQT_BASIC;
+	}
+	attr_ex.pd = pd;
+	ret = rdma_create_srq_ex(id, &attr_ex);
+	memcpy(attr, &attr_ex, sizeof *attr);
+	return ret;
+}
+
 void rdma_destroy_srq(struct rdma_cm_id *id)
 {
 	ibv_destroy_srq(id->srq);
-	if (!id->qp)
-		ucma_destroy_cqs(id);
 	id->srq = NULL;
+	ucma_destroy_cqs(id);
 }
 
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
@@ -1351,8 +1386,8 @@ err1:
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
 	ibv_destroy_qp(id->qp);
-	ucma_destroy_cqs(id);
 	id->qp = NULL;
+	ucma_destroy_cqs(id);
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
diff --git a/src/librdmacm.map b/src/librdmacm.map
index d5ef736..bf0b3e0 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -66,5 +66,6 @@ RDMACM_1.0 {
 		riomap;
 		riounmap;
 		riowrite;
+		rdma_create_srq_ex;
 	local: *;
 };
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
