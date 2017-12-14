From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 2/5] verbs: Remove container_of from the public verbs.h
Date: Thu, 14 Dec 2017 15:35:40 -0700
Message-ID: <20171214223544.30117-3-jgg@ziepe.ca>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is only used in one place in the header, go ahead and open code it.
Not only does the definition pollute the global namespace, but our
inferior implementation does not do the same type checking as the
ccan version that we really want to be using, so this was causing bugs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h  | 21 +++++++--------------
 librdmacm/rsocket.c |  1 +
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 7fec7218182259..775bad52601781 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -67,18 +67,6 @@ union ibv_gid {
 	} global;
 };
 
-#ifndef container_of
-/**
-  * container_of - cast a member of a structure out to the containing structure
-  * @ptr:        the pointer to the member.
-  * @type:       the type of the container struct this is embedded in.
-  * @member:     the name of the member within the struct.
-  *
- */
-#define container_of(ptr, type, member) \
-	((type *) ((uint8_t *)(ptr) - offsetof(type, member)))
-#endif
-
 #define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))
 
 #ifdef __cplusplus
@@ -1690,8 +1678,13 @@ struct verbs_context {
 
 static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 {
-	return (ctx->abi_compat != __VERBS_ABI_IS_EXTENDED) ?
-		NULL : container_of(ctx, struct verbs_context, context);
+	if (ctx->abi_compat != __VERBS_ABI_IS_EXTENDED)
+		return NULL;
+
+	/* open code container_of to not pollute the global namespace */
+	return (struct verbs_context *)(((uint8_t *)ctx) -
+					offsetof(struct verbs_context,
+						 context));
 }
 
 #define verbs_get_ctx_op(ctx, op) ({ \
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 2ce716272d6a6b..48f30717e02d53 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -50,6 +50,7 @@
 #include <byteswap.h>
 #include <util/compiler.h>
 #include <util/util.h>
+#include <ccan/container_of.h>
 
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
