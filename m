From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 2/3] adds rdma_query_qp() function.
Date: Sat, 17 Aug 2013 15:38:15 +0200
Message-ID: <a544af17726976cfb7377d7fc79d051cacd5d4d1.1376746185.git.ydroneaud@opteya.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a new function used to retrieve the QP initial parameters
and capabilities.

This function is especially useful to retrieve information on QP created by
rdma_get_request(): its parameters and capabilities might be slightly different
from those registered as part of rdma_create_ep().

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 include/rdma/rdma_cma.h | 16 ++++++++++++++++
 src/cma.c               | 24 ++++++++++++++++++++++++
 src/librdmacm.map       |  1 +
 3 files changed, 41 insertions(+)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 4c4a057..5b433ab 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -386,6 +386,22 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		   struct ibv_qp_init_attr *qp_init_attr);
 
 /**
+ * rdma_query_qp - Query a QP.
+ * @id: RDMA identifier.
+ * @qp_init_attr: initial QP attributes.
+ * Description:
+ *  Query QP init attributes.
+ * Notes:
+ *   The rdma_cm_id must be bound to QP before calling this function.
+ *   This function should be used to check QP capabilities.
+ * See also:
+ *   rdma_create_ep, rdma_get_request, rdma_create_qp, ibv_create_qp,
+ *   ibv_query_qp
+ */
+int rdma_query_qp(struct rdma_cm_id *id,
+		  struct ibv_qp_init_attr *qp_init_attr);
+
+/**
  * rdma_destroy_qp - Deallocate a QP.
  * @id: RDMA identifier.
  * Description:
diff --git a/src/cma.c b/src/cma.c
index 374844c..24fd86b 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1265,6 +1265,30 @@ err1:
 	return ret;
 }
 
+int rdma_query_qp(struct rdma_cm_id *id,
+		  struct ibv_qp_init_attr *qp_init_attr)
+{
+	struct ibv_qp_attr attr;
+	int ret;
+
+	memset(&attr, 0, sizeof attr);
+	memset(qp_init_attr, 0, sizeof *qp_init_attr);
+
+	ret = ibv_query_qp(id->qp, &attr, IBV_QP_CAP, qp_init_attr);
+	if (ret)
+		return ERR(ret);
+
+	assert(attr.cap.max_send_wr == qp_init_attr->cap.max_send_wr);
+	assert(attr.cap.max_recv_wr == qp_init_attr->cap.max_recv_wr);
+
+	assert(attr.cap.max_send_sge == qp_init_attr->cap.max_send_sge);
+	assert(attr.cap.max_recv_sge == qp_init_attr->cap.max_recv_sge);
+
+	assert(attr.cap.max_inline_data == qp_init_attr->cap.max_inline_data);
+
+	return 0;
+}
+
 void rdma_destroy_qp(struct rdma_cm_id *id)
 {
 	ibv_destroy_qp(id->qp);
diff --git a/src/librdmacm.map b/src/librdmacm.map
index d5ef736..fd2daef 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -8,6 +8,7 @@ RDMACM_1.0 {
 		rdma_resolve_addr;
 		rdma_resolve_route;
 		rdma_create_qp;
+		rdma_query_qp;
 		rdma_destroy_qp;
 		rdma_connect;
 		rdma_listen;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
