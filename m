From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 23/37] librdmacm: add rdma_destoy_ep
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <AC20F5E0CDA7424587AAB7BC21E34EFF@amr.corp.intel.com>
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

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |   11 +++++++++++
 src/cma.c               |    8 ++++++++
 src/librdmacm.map       |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 74762a2..289b728 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -258,6 +258,17 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr);
 
 /**
+ * rdma_destroy_ep - Deallocates a communication identifier and qp.
+ * @id: The communication identifer to destroy.
+ * Description:
+ *   Destroys the specified rdma_cm_id and any associated QP created
+ *   on that id.
+ * See also:
+ *   rdma_create_ep
+ */
+void rdma_destroy_ep(struct rdma_cm_id *id);
+
+/**
  * rdma_destroy_id - Release a communication identifier.
  * @id: The communication identifier to destroy.
  * Description:
diff --git a/src/cma.c b/src/cma.c
index b911b3f..3b80542 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1142,6 +1142,7 @@ void rdma_destroy_qp(struct rdma_cm_id *id)
 {
 	ibv_destroy_qp(id->qp);
 	ucma_destroy_cqs(id);
+	id->qp = NULL;
 }
 
 static int ucma_valid_param(struct cma_id_private *id_priv,
@@ -2033,3 +2034,10 @@ err:
 	rdma_destroy_id(cm_id);
 	return ret;
 }
+
+void rdma_destroy_ep(struct rdma_cm_id *id)
+{
+	if (id->qp)
+		rdma_destroy_qp(id);
+	rdma_destroy_id(id);
+}
diff --git a/src/librdmacm.map b/src/librdmacm.map
index 85d5b3c..19b193a 100644
--- a/src/librdmacm.map
+++ b/src/librdmacm.map
@@ -32,5 +32,6 @@ RDMACM_1.0 {
 		rdma_freeaddrinfo;
 		rdma_get_request;
 		rdma_create_ep;
+		rdma_destroy_ep;
 	local: *;
 };



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
