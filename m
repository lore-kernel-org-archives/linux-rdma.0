From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 3/3] libibverbs: Add reg/unreg I/O memory verbs
Date: Thu, 29 Jul 2010 11:32:02 -0500
Message-ID: <20100729163202.14901.44211.stgit@build.ogc.int>
References: <20100729163030.14901.87547.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729163030.14901.87547.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add the ibv_reg_io_mr and ibv_dereg_io_mr verbs.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 include/infiniband/driver.h |    6 ++++++
 include/infiniband/verbs.h  |   14 ++++++++++++++
 src/verbs.c                 |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..37c0ed1 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -82,6 +82,12 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   size_t cmd_size,
 		   struct ibv_reg_mr_resp *resp, size_t resp_size);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
+int ibv_cmd_reg_io_mr(struct ibv_pd *pd, void *addr, size_t length,
+		      uint64_t hca_va, int access,
+		      struct ibv_mr *mr, struct ibv_reg_io_mr *cmd,
+		      size_t cmd_size,
+		      struct ibv_reg_io_mr_resp *resp, size_t resp_size);
+int ibv_cmd_dereg_io_mr(struct ibv_mr *mr);
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..a0d969a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -640,6 +640,9 @@ struct ibv_context_ops {
 					    size_t length,
 					    int access);
 	int			(*dereg_mr)(struct ibv_mr *mr);
+        struct ibv_mr *         (*reg_io_mr)(struct ibv_pd *pd, void *addr, size_t length,
+					     int access);
+        int                     (*dereg_io_mr)(struct ibv_mr *mr);
 	struct ibv_mw *		(*alloc_mw)(struct ibv_pd *pd, enum ibv_mw_type type);
 	int			(*bind_mw)(struct ibv_qp *qp, struct ibv_mw *mw,
 					   struct ibv_mw_bind *mw_bind);
@@ -801,6 +804,17 @@ struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, void *addr,
 int ibv_dereg_mr(struct ibv_mr *mr);
 
 /**
+ * ibv_reg_io_mr - Register a physical memory region
+ */
+struct ibv_mr *ibv_reg_io_mr(struct ibv_pd *pd, void *addr,
+                             size_t length, int access);
+
+/**
+ * ibv_dereg_io_mr - Deregister a physical memory region
+ */
+int ibv_dereg_io_mr(struct ibv_mr *mr);
+
+/**
  * ibv_create_comp_channel - Create a completion event channel
  */
 struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context);
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..7d215c1 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -189,6 +189,41 @@ int __ibv_dereg_mr(struct ibv_mr *mr)
 }
 default_symver(__ibv_dereg_mr, ibv_dereg_mr);
 
+struct ibv_mr *__ibv_reg_io_mr(struct ibv_pd *pd, void *addr,
+                               size_t length, int access)
+{
+        struct ibv_mr *mr;
+
+        if (ibv_dontfork_range(addr, length))
+                return NULL;
+
+        mr = pd->context->ops.reg_io_mr(pd, addr, length, access);
+        if (mr) {
+                mr->context = pd->context;
+                mr->pd      = pd;
+                mr->addr    = addr;
+                mr->length  = length;
+        } else
+                ibv_dofork_range(addr, length);
+
+        return mr;
+}
+default_symver(__ibv_reg_io_mr, ibv_reg_io_mr);
+
+int __ibv_dereg_io_mr(struct ibv_mr *mr)
+{
+        int ret;
+        void *addr      = mr->addr;
+        size_t length   = mr->length;
+
+        ret = mr->context->ops.dereg_io_mr(mr);
+        if (!ret)
+                ibv_dofork_range(addr, length);
+
+        return ret;
+}
+default_symver(__ibv_dereg_io_mr, ibv_dereg_io_mr);
+
 static struct ibv_comp_channel *ibv_create_comp_channel_v2(struct ibv_context *context)
 {
 	struct ibv_abi_compat_v2 *t = context->abi_compat;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
