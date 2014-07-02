From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/8] rdmacm: Add support for XRC QPs
Date: Tue,  1 Jul 2014 23:11:17 -0700
Message-ID: <1404281479-6755-7-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Export a new extended create QP call.  Add support for XRC
QPs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_cma.h |    4 ++-
 src/cma.c               |   58 ++++++++++++++++++++++++++++++++++------------
 src/librdmacm.map       |    1 +
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 4c4a057..4826c03 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2005 Voltaire Inc.  All rights reserved.
- * Copyright (c) 2005-2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -384,6 +384,8 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms);
  */
 int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		   struct ibv_qp_init_attr *qp_init_attr);
+int rdma_create_qp_ex(struct rdma_cm_id *id,
+		      struct ibv_qp_init_attr_ex *qp_init_attr);
 
 /**
  * rdma_destroy_qp - Deallocate a QP.
diff --git a/src/cma.c b/src/cma.c
index 8c9ea95..749140e 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1333,8 +1333,8 @@ void rdma_destroy_srq(struct rdma_cm_id *id)
 	ucma_destroy_cqs(id);
 }
 
-int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
-		   struct ibv_qp_init_attr *qp_init_attr)
+int rdma_create_qp_ex(struct rdma_cm_id *id,
+		      struct ibv_qp_init_attr_ex *attr)
 {
 	struct cma_id_private *id_priv;
 	struct ibv_qp *qp;
@@ -1344,23 +1344,37 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		return ERR(EINVAL);
 
 	id_priv = container_of(id, struct cma_id_private, id);
-	if (!pd)
-		pd = id->pd;
-	else if (id->verbs != pd->context)
+	if (!(attr->comp_mask & IBV_QP_INIT_ATTR_PD) || !attr->pd) {
+		attr->comp_mask |= IBV_QP_INIT_ATTR_PD;
+		attr->pd = id->pd;
+	} else if (id->verbs != attr->pd->context)
+		return ERR(EINVAL);
+
+	if ((id->recv_cq && attr->recv_cq && id->recv_cq != attr->recv_cq) ||
+	    (id->send_cq && attr->send_cq && id->send_cq != attr->send_cq))
 		return ERR(EINVAL);
 
-	ret = ucma_create_cqs(id, qp_init_attr->send_cq ? 0 : qp_init_attr->cap.max_send_wr,
-			      qp_init_attr->recv_cq ? 0 : qp_init_attr->cap.max_recv_wr);
+	if (id->qp_type == IBV_QPT_XRC_RECV) {
+		if (!(attr->comp_mask & IBV_QP_INIT_ATTR_XRCD) || !attr->xrcd) {
+			attr->xrcd = ucma_get_xrcd(id_priv->cma_dev);
+			if (!attr->xrcd)
+				return -1;
+			attr->comp_mask |= IBV_QP_INIT_ATTR_XRCD;
+		}
+	}
+
+	ret = ucma_create_cqs(id, attr->send_cq || id->send_cq ? 0 : attr->cap.max_send_wr,
+				  attr->recv_cq || id->recv_cq ? 0 : attr->cap.max_recv_wr);
 	if (ret)
 		return ret;
 
-	if (!qp_init_attr->send_cq)
-		qp_init_attr->send_cq = id->send_cq;
-	if (!qp_init_attr->recv_cq)
-		qp_init_attr->recv_cq = id->recv_cq;
-	if (id->srq && !qp_init_attr->srq)
-		qp_init_attr->srq = id->srq;
-	qp = ibv_create_qp(pd, qp_init_attr);
+	if (!attr->send_cq)
+		attr->send_cq = id->send_cq;
+	if (!attr->recv_cq)
+		attr->recv_cq = id->recv_cq;
+	if (id->srq && !attr->srq)
+		attr->srq = id->srq;
+	qp = ibv_create_qp_ex(id->verbs, attr);
 	if (!qp) {
 		ret = ERR(ENOMEM);
 		goto err1;
@@ -1373,7 +1387,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	if (ret)
 		goto err2;
 
-	id->pd = pd;
+	id->pd = qp->pd;
 	id->qp = qp;
 	return 0;
 err2:
@@ -1383,6 +1397,20 @@ err1:
 	return ret;
 }
 
+int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
+		   struct ibv_qp_init_attr *qp_init_attr)
+{
+	struct ibv_qp_init_attr_ex attr_ex;
+	int ret;
+
+	memcpy(&attr_ex, qp_init_attr, sizeof *qp_init_attr);
+	attr_ex.comp_mask = IBV_QP_INIT_ATTR_PD;
+	attr_ex.pd = pd ? pd : id->pd;
+	ret = rdma_create_qp_ex(id, &attr_ex);
+	memcpy(qp_init_attr, &attr_ex, sizeof *qp_init_attr);
+	return ret;
+}
+
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
 	ibv_destroy_qp(id->qp);
diff --git a/src/librdmacm.map b/src/librdmacm.map
index bf0b3e0..ffbd199 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -67,5 +67,6 @@ RDMACM_1.0 {
 		riounmap;
 		riowrite;
 		rdma_create_srq_ex;
+		rdma_create_qp_ex;
 	local: *;
 };
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
