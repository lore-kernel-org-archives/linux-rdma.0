From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 4/5] verbs: Enable private create_cq for providers
Date: Tue, 21 Mar 2017 19:42:09 +0200
Message-ID: <1490118130-1039-5-git-send-email-yishaih@mellanox.com>
References: <1490118130-1039-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490118130-1039-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch enables providers to register a private create_cq API with
some private data with libibverbs.

The idea is to force type checking of the private data in the provider
but to share the libibverbs code (e.g. locking, reference counting)
which is used by the public ibv_create_cq_ex API.

As the private API is not exposed to applications they will need to link
explicitly with the provider and use its direct API supplying the
explicit input structure.

The solution:
- Provider will expose some direct API with its explicit signature to
  force the type checking.
- Provider will register its private API with libibverbs using the priv
  pointer (i.e. struct verbs_ex_private). For that a new macro named
  verbs_set_ctx_private_op was added and the above structure was
  moved to drivers.h to be accessed by the providers.
- Upon an application call to the provider, it will call to a new API
  named ibv_vendor_create_cq_ex which is exported from libibverbs only
  to providers (i.e. using the private section in the map file) to a
  create vendor cq.
- libibverbs will use the registered private API to call back the
  provider.
- Libibverbs will share the code between the public and the private
  calls.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/device.c       | 22 +++++++++++++++++++---
 libibverbs/driver.h       | 11 +++++++++++
 libibverbs/ibverbs.h      |  7 +------
 libibverbs/libibverbs.map |  5 +++++
 libibverbs/verbs.h        |  4 ++++
 5 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/libibverbs/device.c b/libibverbs/device.c
index 0acc3dc..ca403b5 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -120,8 +120,9 @@ uint64_t __ibv_get_device_guid(struct ibv_device *device)
 }
 default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
-struct ibv_cq_ex *__lib_ibv_create_cq_ex(struct ibv_context *context,
-					 struct ibv_cq_init_attr_ex *cq_attr)
+struct ibv_cq_ex *ibv_vendor_create_cq_ex(struct ibv_context *context,
+					 struct ibv_cq_init_attr_ex *cq_attr,
+					 void *vendor_data)
 {
 	struct verbs_context *vctx = verbs_get_ctx(context);
 	struct ibv_cq_ex *cq;
@@ -133,7 +134,16 @@ struct ibv_cq_ex *__lib_ibv_create_cq_ex(struct ibv_context *context,
 
 	pthread_mutex_lock(&context->mutex);
 
-	cq = vctx->priv->create_cq_ex(context, cq_attr);
+	if (!vendor_data) {
+		cq = vctx->priv->create_cq_ex(context, cq_attr);
+	} else {
+		if (!vctx->priv->create_cq_ex_vendor) {
+			errno = ENOSYS;
+			return NULL;
+		}
+
+		cq = vctx->priv->create_cq_ex_vendor(context, cq_attr, vendor_data);
+	}
 
 	if (cq) {
 		cq->context		   = context;
@@ -152,6 +162,12 @@ struct ibv_cq_ex *__lib_ibv_create_cq_ex(struct ibv_context *context,
 	return cq;
 }
 
+struct ibv_cq_ex *__lib_ibv_create_cq_ex(struct ibv_context *context,
+					 struct ibv_cq_init_attr_ex *cq_attr)
+{
+	return ibv_vendor_create_cq_ex(context, cq_attr, NULL);
+}
+
 struct ibv_context *__ibv_open_device(struct ibv_device *device)
 {
 	struct verbs_device *verbs_device = verbs_get_device(device);
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index e3ac3f7..548e7a5 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -46,6 +46,14 @@
 #  define END_C_DECLS
 #endif /* __cplusplus */
 
+struct verbs_ex_private {
+	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
+					  struct ibv_cq_init_attr_ex *init_attr);
+	struct ibv_cq_ex *(*create_cq_ex_vendor)(struct ibv_context *context,
+					  struct ibv_cq_init_attr_ex *init_attr,
+					  void *vendor_data);
+};
+
 /*
  * Extension that low-level drivers should add to their .so filename
  * (probably via libtool "-release" option).  For example a low-level
@@ -319,4 +327,7 @@ static inline int verbs_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
 
 int ibv_query_gid_type(struct ibv_context *context, uint8_t port_num,
 		       unsigned int index, enum ibv_gid_type *type);
+struct ibv_cq_ex *ibv_vendor_create_cq_ex(struct ibv_context *context,
+					 struct ibv_cq_init_attr_ex *cq_attr,
+					 void *vendor_data);
 #endif /* INFINIBAND_DRIVER_H */
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 3b08476..5391a8f 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -48,7 +48,7 @@
 #define default_symver(name, api)                                              \
 	asm(".symver " #name "," #api "@@" DEFAULT_ABI)
 #define private_symver(name, api)                                              \
-	asm(".symver " #name "," #api "@@IBVERBS_PRIVATE_13")
+	asm(".symver " #name "," #api "@@IBVERBS_PRIVATE_14")
 
 #define PFX		"libibverbs: "
 
@@ -61,11 +61,6 @@ extern int abi_ver;
 
 int ibverbs_init(struct ibv_device ***list);
 
-struct verbs_ex_private {
-	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
-					  struct ibv_cq_init_attr_ex *init_attr);
-};
-
 #define IBV_INIT_CMD(cmd, size, opcode)					\
 	do {								\
 		if (abi_ver > 2)					\
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 656c21d..9d6cdec 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -139,3 +139,8 @@ IBVERBS_PRIVATE_13 {
 		ibv_register_driver;
 		verbs_register_driver;
 };
+
+IBVERBS_PRIVATE_14 {
+	global:
+		ibv_vendor_create_cq_ex;
+} IBVERBS_PRIVATE_13;
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 25f4ede..6bd23b7 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1505,6 +1505,10 @@ static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 	if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
 		vctx->op = ptr; })
 
+#define verbs_set_ctx_private_op(_vctx, op, ptr)({ \
+	struct verbs_context *vctx = _vctx; \
+	vctx->priv->op = ptr; })
+
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
