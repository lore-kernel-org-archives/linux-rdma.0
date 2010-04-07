From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/37] librdmacm: allow pd parameter to be optional
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <6A3ABFAC1B8342F3AE84304B7646ED77@amr.corp.intel.com>
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

Allow the user to create a QP using rdma_create_qp without
specifying a PD.  If a PD is not given, a default PD will be
used instead.  This simplifies the user interface.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    4 +++-
 src/cma.c               |   24 +++++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 83418c3..ccf6cd4 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -279,7 +279,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms);
 /**
  * rdma_create_qp - Allocate a QP.
  * @id: RDMA identifier.
- * @pd: protection domain for the QP.
+ * @pd: Optional protection domain for the QP.
  * @qp_init_attr: initial QP attributes.
  * Description:
  *  Allocate a QP associated with the specified rdma_cm_id and transition it
@@ -291,6 +291,8 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms);
  *   librdmacm through their states.  After being allocated, the QP will be
  *   ready to handle posting of receives.  If the QP is unconnected, it will
  *   be ready to post sends.
+ *   If pd is NULL, then the QP will be allocated using a default protection
+ *   domain associated with the underlying RDMA device.
  * See also:
  *   rdma_bind_addr, rdma_resolve_addr, rdma_destroy_qp, ibv_create_qp,
  *   ibv_modify_qp
diff --git a/src/cma.c b/src/cma.c
index c7a3a7b..0587ab3 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -95,6 +95,7 @@ do {                                        \
 
 struct cma_device {
 	struct ibv_context *verbs;
+	struct ibv_pd	   *pd;
 	uint64_t	    guid;
 	int		    port_cnt;
 	uint8_t		    max_initiator_depth;
@@ -144,9 +145,11 @@ int af_ib_support;
 static void ucma_cleanup(void)
 {
 	if (cma_dev_cnt) {
-		while (cma_dev_cnt)
-			ibv_close_device(cma_dev_array[--cma_dev_cnt].verbs);
-	
+		while (cma_dev_cnt--) {
+			ibv_dealloc_pd(cma_dev_array[cma_dev_cnt].pd);
+			ibv_close_device(cma_dev_array[cma_dev_cnt].verbs);
+		}
+
 		free(cma_dev_array);
 		cma_dev_cnt = 0;
 	}
@@ -224,6 +227,13 @@ static int ucma_init(void)
 			goto err3;
 		}
 
+		cma_dev->pd = ibv_alloc_pd(cma_dev->verbs);
+		if (!cma_dev->pd) {
+			ibv_close_device(cma_dev->verbs);
+			ret = ERR(ENOMEM);
+			goto err3;
+		}
+
 		i++;
 		ret = ibv_query_device(cma_dev->verbs, &attr);
 		if (ret) {
@@ -242,8 +252,10 @@ static int ucma_init(void)
 	return 0;
 
 err3:
-	while (i--)
+	while (i--) {
+		ibv_dealloc_pd(cma_dev_array[i].pd);
 		ibv_close_device(cma_dev_array[i].verbs);
+	}
 	free(cma_dev_array);
 err2:
 	ibv_free_device_list(dev_list);
@@ -1021,7 +1033,9 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 	int ret;
 
 	id_priv = container_of(id, struct cma_id_private, id);
-	if (id->verbs != pd->context)
+	if (!pd)
+		pd = id_priv->cma_dev->pd;
+	else if (id->verbs != pd->context)
 		return ERR(EINVAL);
 
 	qp = ibv_create_qp(pd, qp_init_attr);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
