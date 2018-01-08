From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 1/8] verbs: Always allocate a verbs_context
Date: Mon,  8 Jan 2018 14:26:25 -0700
Message-ID: <20180108212632.5183-2-jgg@ziepe.ca>
References: <20180108212632.5183-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>, Alex
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that everything is in one tree we can revise the legacy init_context
path to always allocate a verbs_context by swapping the ibv_context
for a verbs_context in all of the provider's wrapper struct.

To keep the provider diffs minimal this single patch does several things
at once:

- Introduce the verbs_init_and_alloc_context() macro.
  This allocates, zeros and initializes the verbs_context for each driver.
  Notably this new macro correctly sets errno as required upon failure.

- Remove boilerplate from all drivers, calloc, malloc, memset, cmd_fd and
  device assignment

- Along with the verbs_init scheme necessarily comes the verbs_uninit
  scheme which lowers the uninit call into the provder not the common
  code. This allows us to properly uninit on the init error path.

Together this follows the fairly successful pattern we see in the kernel
for driver init to a subsystem.

Also this changes ibv_cmd_get_context to accept a verbs_context since
the majority of callers are now providing that, this keeps the diff
smaller.

This makes the entire flow more consistent and will let us eliminate the
init_context flow.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 CMakeLists.txt                     |   2 +-
 debian/libibverbs1.symbols         |   2 +-
 libibverbs/cmd.c                   |  12 +--
 libibverbs/device.c                | 206 +++++++++++++++++++++++--------------
 libibverbs/driver.h                |  23 ++++-
 libibverbs/libibverbs.map.in       |   2 +
 providers/bnxt_re/main.c           |   5 +-
 providers/cxgb3/iwch.c             |  30 +++---
 providers/cxgb3/iwch.h             |   4 +-
 providers/cxgb4/dev.c              |  29 +++---
 providers/cxgb4/libcxgb4.h         |   4 +-
 providers/hfi1verbs/hfiverbs.c     |  36 ++++---
 providers/hfi1verbs/hfiverbs.h     |   4 +-
 providers/hns/hns_roce_u.c         |  53 +++++-----
 providers/hns/hns_roce_u.h         |   4 +-
 providers/hns/hns_roce_u_verbs.c   |   6 +-
 providers/i40iw/i40iw_umain.c      |  16 +--
 providers/i40iw/i40iw_umain.h      |   4 +-
 providers/ipathverbs/ipathverbs.c  |  36 ++++---
 providers/ipathverbs/ipathverbs.h  |   4 +-
 providers/mlx4/mlx4.c              |   8 +-
 providers/mlx5/mlx5.c              |   8 +-
 providers/mthca/mthca.c            |  48 +++++----
 providers/mthca/mthca.h            |   4 +-
 providers/nes/nes_umain.c          |  19 ++--
 providers/nes/nes_umain.h          |   4 +-
 providers/ocrdma/ocrdma_main.c     |  14 ++-
 providers/ocrdma/ocrdma_main.h     |   4 +-
 providers/qedr/qelr.h              |   4 +-
 providers/qedr/qelr_main.c         |  14 +--
 providers/qedr/qelr_verbs.c        |   2 +-
 providers/rxe/rxe.c                |  13 ++-
 providers/rxe/rxe.h                |   4 +-
 providers/vmw_pvrdma/pvrdma.h      |   4 +-
 providers/vmw_pvrdma/pvrdma_main.c |  14 +--
 35 files changed, 359 insertions(+), 287 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index b1467317b68561..e8f4a948ad9610 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -52,7 +52,7 @@ set(PACKAGE_VERSION "17.0")
 # When this is changed the values in these files need changing too:
 #   debian/libibverbs1.symbols
 #   libibverbs/libibverbs.map
-set(IBVERBS_PABI_VERSION "16")
+set(IBVERBS_PABI_VERSION "17")
 set(IBVERBS_PROVIDER_SUFFIX "-rdmav${IBVERBS_PABI_VERSION}.so")
 
 #-------------------------
diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
index 2678fa6e98acf7..7c7659e434bc63 100644
--- a/debian/libibverbs1.symbols
+++ b/debian/libibverbs1.symbols
@@ -1,7 +1,7 @@
 libibverbs.so.1 libibverbs1 #MINVER#
  IBVERBS_1.0@IBVERBS_1.0 1.1.6
  IBVERBS_1.1@IBVERBS_1.1 1.1.6
- (symver)IBVERBS_PRIVATE_16 16
+ (symver)IBVERBS_PRIVATE_17 17
  ibv_ack_async_event@IBVERBS_1.0 1.1.6
  ibv_ack_async_event@IBVERBS_1.1 1.1.6
  ibv_ack_cq_events@IBVERBS_1.0 1.1.6
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index b957550ed6fbdb..bcec94f5b0ce72 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -44,22 +44,22 @@
 #include "ibverbs.h"
 #include <ccan/minmax.h>
 
-int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
-			size_t cmd_size, struct ibv_get_context_resp *resp,
-			size_t resp_size)
+int ibv_cmd_get_context(struct verbs_context *context_ex,
+			struct ibv_get_context *cmd, size_t cmd_size,
+			struct ibv_get_context_resp *resp, size_t resp_size)
 {
 	if (abi_ver < IB_USER_VERBS_MIN_ABI_VERSION)
 		return ENOSYS;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
 
-	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
+	if (write(context_ex->context.cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
 	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
-	context->async_fd         = resp->async_fd;
-	context->num_comp_vectors = resp->num_comp_vectors;
+	context_ex->context.async_fd = resp->async_fd;
+	context_ex->context.num_comp_vectors = resp->num_comp_vectors;
 
 	return 0;
 }
diff --git a/libibverbs/device.c b/libibverbs/device.c
index 4fb759c6474ad7..e42e37bd0a1f8d 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -162,7 +162,8 @@ static struct ibv_cq_ex *
 __lib_ibv_create_cq_ex(struct ibv_context *context,
 		       struct ibv_cq_init_attr_ex *cq_attr)
 {
-	struct verbs_context *vctx = verbs_get_ctx(context);
+	struct verbs_context *vctx =
+		container_of(context, struct verbs_context, context);
 	struct ibv_cq_ex *cq;
 
 	if (cq_attr->wc_flags & ~IBV_CREATE_CQ_SUP_WC_FLAGS) {
@@ -179,14 +180,115 @@ __lib_ibv_create_cq_ex(struct ibv_context *context,
 	return cq;
 }
 
+/*
+ * Ownership of cmd_fd is transferred into this function, and it will either
+ * be released during the matching call to verbs_uninit_contxt or during the
+ * failure path of this function.
+ */
+int verbs_init_context(struct verbs_context *context_ex,
+		       struct ibv_device *device, int cmd_fd)
+{
+	struct ibv_context *context = &context_ex->context;
+
+	ibverbs_device_hold(device);
+
+	context->device = device;
+	context->cmd_fd = cmd_fd;
+	context->async_fd = -1;
+	pthread_mutex_init(&context->mutex, NULL);
+
+	context_ex->context.abi_compat = __VERBS_ABI_IS_EXTENDED;
+	context_ex->sz = sizeof(*context_ex);
+
+	/*
+	 * In order to maintain backward/forward binary compatibility
+	 * with apps compiled against libibverbs-1.1.8 that use the
+	 * flow steering addition, we need to set the two
+	 * ABI_placeholder entries to match the driver set flow
+	 * entries.  This is because apps compiled against
+	 * libibverbs-1.1.8 use an inline ibv_create_flow and
+	 * ibv_destroy_flow function that looks in the placeholder
+	 * spots for the proper entry points.  For apps compiled
+	 * against libibverbs-1.1.9 and later, the inline functions
+	 * will be looking in the right place.
+	 */
+	context_ex->ABI_placeholder1 =
+		(void (*)(void))context_ex->ibv_create_flow;
+	context_ex->ABI_placeholder2 =
+		(void (*)(void))context_ex->ibv_destroy_flow;
+
+	context_ex->priv = calloc(1, sizeof(context_ex->priv));
+	if (!context_ex->priv) {
+		errno = ENOMEM;
+		close(cmd_fd);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Allocate and initialize a context structure. This is called to create the
+ * driver wrapper, and context_offset is the number of bytes into the wrapper
+ * structure where the verbs_context starts.
+ */
+void *_verbs_init_and_alloc_context(struct ibv_device *device, int cmd_fd,
+				    size_t alloc_size,
+				    struct verbs_context *context_offset)
+{
+	void *drv_context;
+	struct verbs_context *context;
+
+	drv_context = calloc(1, alloc_size);
+	if (!drv_context) {
+		errno = ENOMEM;
+		close(cmd_fd);
+		return NULL;
+	}
+
+	context = (struct verbs_context *)((uint8_t *)drv_context +
+					   (uintptr_t)context_offset);
+
+	if (verbs_init_context(context, device, cmd_fd))
+		goto err_free;
+
+	return drv_context;
+
+err_free:
+	free(drv_context);
+	return NULL;
+}
+
+/* Use the init_context flow to create a verbs_context */
+static struct verbs_context *alloc_context(struct verbs_device *device,
+					   int cmd_fd)
+{
+	struct verbs_context *context;
+
+	context = _verbs_init_and_alloc_context(
+		&device->device, cmd_fd,
+		sizeof(*context) + device->size_of_context, NULL);
+	if (!context)
+		return NULL;
+
+	if (device->ops->init_context(device, &context->context, cmd_fd))
+		goto err_uninit;
+
+	return context;
+
+err_uninit:
+	verbs_uninit_context(context);
+	free(context);
+	return NULL;
+}
+
 LATEST_SYMVER_FUNC(ibv_open_device, 1_1, "IBVERBS_1.1",
 		   struct ibv_context *,
 		   struct ibv_device *device)
 {
 	struct verbs_device *verbs_device = verbs_get_device(device);
 	char *devpath;
-	int cmd_fd, ret;
-	struct ibv_context *context;
+	int cmd_fd;
 	struct verbs_context *context_ex;
 
 	if (asprintf(&devpath, "/dev/infiniband/%s", device->dev_name) < 0)
@@ -202,96 +304,50 @@ LATEST_SYMVER_FUNC(ibv_open_device, 1_1, "IBVERBS_1.1",
 	if (cmd_fd < 0)
 		return NULL;
 
-	if (!verbs_device->ops->init_context) {
-		context = verbs_device->ops->alloc_context(device, cmd_fd);
-		if (!context)
-			goto err;
-	} else {
-		struct verbs_ex_private *priv;
-
-		/* Library now allocates the context */
-		context_ex = calloc(1, sizeof(*context_ex) +
-				       verbs_device->size_of_context);
-		if (!context_ex) {
-			errno = ENOMEM;
-			goto err;
-		}
-
-		priv = calloc(1, sizeof(*priv));
-		if (!priv) {
-			errno = ENOMEM;
-			free(context_ex);
-			goto err;
-		}
-
-		context_ex->priv = priv;
-		context_ex->context.abi_compat  = __VERBS_ABI_IS_EXTENDED;
-		context_ex->sz = sizeof(*context_ex);
-
-		context = &context_ex->context;
-		ret = verbs_device->ops->init_context(verbs_device, context, cmd_fd);
-		if (ret)
-			goto verbs_err;
-		/*
-		 * In order to maintain backward/forward binary compatibility
-		 * with apps compiled against libibverbs-1.1.8 that use the
-		 * flow steering addition, we need to set the two
-		 * ABI_placeholder entries to match the driver set flow
-		 * entries.  This is because apps compiled against
-		 * libibverbs-1.1.8 use an inline ibv_create_flow and
-		 * ibv_destroy_flow function that looks in the placeholder
-		 * spots for the proper entry points.  For apps compiled
-		 * against libibverbs-1.1.9 and later, the inline functions
-		 * will be looking in the right place.
-		 */
-		context_ex->ABI_placeholder1 = (void (*)(void)) context_ex->ibv_create_flow;
-		context_ex->ABI_placeholder2 = (void (*)(void)) context_ex->ibv_destroy_flow;
-
-		if (context_ex->create_cq_ex) {
-			priv->create_cq_ex = context_ex->create_cq_ex;
-			context_ex->create_cq_ex = __lib_ibv_create_cq_ex;
-		}
-	}
+	if (!verbs_device->ops->init_context)
+		context_ex = verbs_device->ops->alloc_context(device, cmd_fd);
+	else
+		context_ex = alloc_context(verbs_device, cmd_fd);
 
-	context->device = device;
-	context->cmd_fd = cmd_fd;
-	pthread_mutex_init(&context->mutex, NULL);
+	/*
+	 * cmd_fd ownership is transferred into alloc_context, if it fails
+	 * then it closes cmd_fd and returns NULL
+	 */
+	if (context_ex == NULL)
+		return NULL;
 
-	ibverbs_device_hold(device);
+	if (context_ex->create_cq_ex) {
+		context_ex->priv->create_cq_ex = context_ex->create_cq_ex;
+		context_ex->create_cq_ex = __lib_ibv_create_cq_ex;
+	}
 
-	return context;
+	return &context_ex->context;
+}
 
-verbs_err:
+void verbs_uninit_context(struct verbs_context *context_ex)
+{
 	free(context_ex->priv);
-	free(context_ex);
-err:
-	close(cmd_fd);
-	return NULL;
+	close(context_ex->context.cmd_fd);
+	close(context_ex->context.async_fd);
+	ibverbs_device_put(context_ex->context.device);
 }
 
 LATEST_SYMVER_FUNC(ibv_close_device, 1_1, "IBVERBS_1.1",
 		   int,
 		   struct ibv_context *context)
 {
-	int async_fd = context->async_fd;
-	int cmd_fd   = context->cmd_fd;
-	struct verbs_context *context_ex;
 	struct verbs_device *verbs_device = verbs_get_device(context->device);
-	struct ibv_device *device = context->device;
 
-	context_ex = verbs_get_ctx(context);
-	if (context_ex) {
+	if (verbs_device->ops->uninit_context) {
+		struct verbs_context *context_ex =
+			container_of(context, struct verbs_context, context);
+
 		verbs_device->ops->uninit_context(verbs_device, context);
-		free(context_ex->priv);
-		free(context_ex);
+		verbs_uninit_context(context_ex);
 	} else {
 		verbs_device->ops->free_context(context);
 	}
 
-	close(async_fd);
-	close(cmd_fd);
-	ibverbs_device_put(device);
-
 	return 0;
 }
 
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 4698ba4e609f34..809c4f5c8cdf39 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -153,8 +153,8 @@ struct verbs_device_ops {
 	bool (*match_device)(struct verbs_sysfs_dev *sysfs_dev);
 
 	/* Old interface, do not use in new code. */
-	struct ibv_context *(*alloc_context)(struct ibv_device *device,
-					     int cmd_fd);
+	struct verbs_context *(*alloc_context)(struct ibv_device *device,
+					       int cmd_fd);
 	void (*free_context)(struct ibv_context *context);
 
 	/* New interface */
@@ -205,13 +205,26 @@ void verbs_register_driver(const struct verbs_device_ops *ops);
 		verbs_register_driver(&drv);                                   \
 	}
 
+void *_verbs_init_and_alloc_context(struct ibv_device *device, int cmd_fd,
+				    size_t alloc_size,
+				    struct verbs_context *context_offset);
+
+#define verbs_init_and_alloc_context(ibdev, cmd_fd, drv_ctx_ptr, ctx_memb)     \
+	((typeof(drv_ctx_ptr))_verbs_init_and_alloc_context(                   \
+		ibdev, cmd_fd, sizeof(*drv_ctx_ptr),                           \
+		&((typeof(drv_ctx_ptr))NULL)->ctx_memb))
+
+int verbs_init_context(struct verbs_context *context_ex,
+		       struct ibv_device *device, int cmd_fd);
+void verbs_uninit_context(struct verbs_context *context);
+
 void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
 		       struct ibv_comp_channel *channel,
 		       void *cq_context);
 
-int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
-			size_t cmd_size, struct ibv_get_context_resp *resp,
-			size_t resp_size);
+int ibv_cmd_get_context(struct verbs_context *context,
+			struct ibv_get_context *cmd, size_t cmd_size,
+			struct ibv_get_context_resp *resp, size_t resp_size);
 int ibv_cmd_query_device(struct ibv_context *context,
 			 struct ibv_device_attr *device_attr,
 			 uint64_t *raw_fw_ver,
diff --git a/libibverbs/libibverbs.map.in b/libibverbs/libibverbs.map.in
index 3f635a94b82d58..b787b051b4c381 100644
--- a/libibverbs/libibverbs.map.in
+++ b/libibverbs/libibverbs.map.in
@@ -113,6 +113,7 @@ IBVERBS_1.1 {
 IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 	global:
 		/* These historical symbols are now private to libibverbs */
+		_verbs_init_and_alloc_context;
 		ibv_cmd_alloc_mw;
 		ibv_cmd_alloc_pd;
 		ibv_cmd_attach_mcast;
@@ -162,6 +163,7 @@ IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 		ibv_query_gid_type;
 		ibv_register_driver;
 		verbs_register_driver_@IBVERBS_PABI_VERSION@;
+		verbs_uninit_context;
 		verbs_init_cq;
 		ibv_cmd_modify_cq;
 };
diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index 998c9fe3313389..5e83f9d1c12f35 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -111,14 +111,15 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
 	struct bnxt_re_cntx_resp resp;
 	struct bnxt_re_dev *dev;
 	struct bnxt_re_context *cntx;
+	struct verbs_context *verbs_ctx = verbs_get_ctx(ibvctx);
 
 	dev = to_bnxt_re_dev(&vdev->device);
 	cntx = to_bnxt_re_context(ibvctx);
 
 	memset(&resp, 0, sizeof(resp));
 	ibvctx->cmd_fd = cmd_fd;
-	if (ibv_cmd_get_context(ibvctx, &cmd, sizeof(cmd),
-				&resp.resp, sizeof(resp)))
+	if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd), &resp.resp,
+				sizeof(resp)))
 		return errno;
 
 	cntx->dev_id = resp.dev_id;
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index da9179fbbe2a8d..d4d5a96ffd524e 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -104,42 +104,38 @@ unsigned long iwch_page_size;
 unsigned long iwch_page_shift;
 unsigned long iwch_page_mask;
 
-static struct ibv_context *iwch_alloc_context(struct ibv_device *ibdev,
-					      int cmd_fd)
+static struct verbs_context *iwch_alloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct iwch_context *context;
 	struct ibv_get_context cmd;
 	struct iwch_alloc_ucontext_resp resp;
 	struct iwch_device *rhp = to_iwch_dev(ibdev);
 
-	context = malloc(sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	memset(context, 0, sizeof *context);
-	context->ibv_ctx.cmd_fd = cmd_fd;
-
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.device = ibdev;
-	context->ibv_ctx.ops = iwch_ctx_ops;
+	context->ibv_ctx.context.ops = iwch_ctx_ops;
 
 	switch (rhp->hca_type) {
 	case CHELSIO_T3B:
 		PDBG("%s T3B device\n", __FUNCTION__);
-		context->ibv_ctx.ops.async_event = t3b_async_event;
-		context->ibv_ctx.ops.post_send = t3b_post_send;
-		context->ibv_ctx.ops.post_recv = t3b_post_recv;
-		context->ibv_ctx.ops.poll_cq = t3b_poll_cq;
+		context->ibv_ctx.context.ops.async_event = t3b_async_event;
+		context->ibv_ctx.context.ops.post_send = t3b_post_send;
+		context->ibv_ctx.context.ops.post_recv = t3b_post_recv;
+		context->ibv_ctx.context.ops.poll_cq = t3b_poll_cq;
 		break;
 	case CHELSIO_T3A:
 		PDBG("%s T3A device\n", __FUNCTION__);
-		context->ibv_ctx.ops.async_event = NULL;
-		context->ibv_ctx.ops.post_send = t3a_post_send;
-		context->ibv_ctx.ops.post_recv = t3a_post_recv;
-		context->ibv_ctx.ops.poll_cq = t3a_poll_cq;
+		context->ibv_ctx.context.ops.async_event = NULL;
+		context->ibv_ctx.context.ops.post_send = t3a_post_send;
+		context->ibv_ctx.context.ops.post_recv = t3a_post_recv;
+		context->ibv_ctx.context.ops.poll_cq = t3a_poll_cq;
 		break;
 	default:
 		PDBG("%s unknown hca type %d\n", __FUNCTION__, rhp->hca_type);
@@ -150,6 +146,7 @@ static struct ibv_context *iwch_alloc_context(struct ibv_device *ibdev,
 	return &context->ibv_ctx;
 
 err_free:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -158,6 +155,7 @@ static void iwch_free_context(struct ibv_context *ibctx)
 {
 	struct iwch_context *context = to_iwch_ctx(ibctx);
 
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/cxgb3/iwch.h b/providers/cxgb3/iwch.h
index 1b95fec664ef11..0b8060cf7cfa8f 100644
--- a/providers/cxgb3/iwch.h
+++ b/providers/cxgb3/iwch.h
@@ -71,7 +71,7 @@ static inline int t3a_device(struct iwch_device *dev)
 }
 
 struct iwch_context {
-	struct ibv_context ibv_ctx;
+	struct verbs_context ibv_ctx;
 };
 
 struct iwch_pd {
@@ -111,7 +111,7 @@ static inline struct iwch_device *to_iwch_dev(struct ibv_device *ibdev)
 
 static inline struct iwch_context *to_iwch_ctx(struct ibv_context *ibctx)
 {
-	return to_iwch_xxx(ctx, context);
+	return container_of(ibctx, struct iwch_context, ibv_ctx.context);
 }
 
 static inline struct iwch_pd *to_iwch_pd(struct ibv_pd *ibpd)
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index b6775da8afeef7..3c309d9f5defb5 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -96,8 +96,8 @@ static struct ibv_context_ops c4iw_ctx_ops = {
 	.req_notify_cq = c4iw_arm_cq,
 };
 
-static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
-					      int cmd_fd)
+static struct verbs_context *c4iw_alloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct c4iw_context *context;
 	struct ibv_get_context cmd;
@@ -107,13 +107,10 @@ static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
 	uint64_t raw_fw_ver;
 	struct ibv_device_attr attr;
 
-	context = malloc(sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	memset(context, 0, sizeof *context);
-	context->ibv_ctx.cmd_fd = cmd_fd;
-
 	resp.status_page_size = 0;
 	resp.reserved = 0;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
@@ -133,8 +130,7 @@ static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
 			goto err_free;
 	} 
 
-	context->ibv_ctx.device = ibdev;
-	context->ibv_ctx.ops = c4iw_ctx_ops;
+	context->ibv_ctx.context.ops = c4iw_ctx_ops;
 
 	switch (rhp->chip_version) {
 	case CHELSIO_T6:
@@ -143,11 +139,11 @@ static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
 		PDBG("%s T5/T4 device\n", __FUNCTION__);
 	case CHELSIO_T4:
 		PDBG("%s T4 device\n", __FUNCTION__);
-		context->ibv_ctx.ops.async_event = c4iw_async_event;
-		context->ibv_ctx.ops.post_send = c4iw_post_send;
-		context->ibv_ctx.ops.post_recv = c4iw_post_receive;
-		context->ibv_ctx.ops.poll_cq = c4iw_poll_cq;
-		context->ibv_ctx.ops.req_notify_cq = c4iw_arm_cq;
+		context->ibv_ctx.context.ops.async_event = c4iw_async_event;
+		context->ibv_ctx.context.ops.post_send = c4iw_post_send;
+		context->ibv_ctx.context.ops.post_recv = c4iw_post_receive;
+		context->ibv_ctx.context.ops.poll_cq = c4iw_poll_cq;
+		context->ibv_ctx.context.ops.req_notify_cq = c4iw_arm_cq;
 		break;
 	default:
 		PDBG("%s unknown hca type %d\n", __FUNCTION__,
@@ -159,8 +155,8 @@ static struct ibv_context *c4iw_alloc_context(struct ibv_device *ibdev,
 	if (!rhp->mmid2ptr) {
 		int ret;
 
-		ret = ibv_cmd_query_device(&context->ibv_ctx, &attr, &raw_fw_ver, &qcmd,
-					   sizeof qcmd);
+		ret = ibv_cmd_query_device(&context->ibv_ctx.context, &attr,
+					   &raw_fw_ver, &qcmd, sizeof(qcmd));
 		if (ret)
 			goto err_unmap;
 		rhp->max_mr = attr.max_mr;
@@ -201,6 +197,7 @@ err_free:
 		free(rhp->cqid2ptr);
 	if (rhp->mmid2ptr)
 		free(rhp->cqid2ptr);
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -211,6 +208,8 @@ static void c4iw_free_context(struct ibv_context *ibctx)
 
 	if (context->status_page_size)
 		munmap(context->status_page, context->status_page_size);
+
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
index a5256f7e081770..893bd85d5f34b2 100644
--- a/providers/cxgb4/libcxgb4.h
+++ b/providers/cxgb4/libcxgb4.h
@@ -80,7 +80,7 @@ static inline int dev_is_t4(struct c4iw_dev *dev)
 }
 
 struct c4iw_context {
-	struct ibv_context ibv_ctx;
+	struct verbs_context ibv_ctx;
 	struct t4_dev_status_page *status_page;
 	int status_page_size;
 };
@@ -129,7 +129,7 @@ static inline struct c4iw_dev *to_c4iw_dev(struct ibv_device *ibdev)
 
 static inline struct c4iw_context *to_c4iw_context(struct ibv_context *ibctx)
 {
-	return to_c4iw_xxx(ctx, context);
+	return container_of(ibctx, struct c4iw_context, ibv_ctx.context);
 }
 
 static inline struct c4iw_pd *to_c4iw_pd(struct ibv_pd *ibpd)
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index 7f8f5714db1630..6117f99fbc27a2 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -123,41 +123,42 @@ static struct ibv_context_ops hfi1_ctx_ops = {
 	.detach_mcast	= ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *hfi1_alloc_context(struct ibv_device *ibdev,
-					       int cmd_fd)
+static struct verbs_context *hfi1_alloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct hfi1_context	    *context;
 	struct ibv_get_context       cmd;
 	struct ibv_get_context_resp  resp;
 	struct hfi1_device         *dev;
 
-	context = malloc(sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
-	memset(context, 0, sizeof *context);
-	context->ibv_ctx.cmd_fd = cmd_fd;
+
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd,
 				sizeof cmd, &resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.ops = hfi1_ctx_ops;
+	context->ibv_ctx.context.ops = hfi1_ctx_ops;
 	dev = to_idev(ibdev);
 	if (dev->abi_version == 1) {
-		context->ibv_ctx.ops.create_cq     = hfi1_create_cq_v1;
-		context->ibv_ctx.ops.poll_cq       = ibv_cmd_poll_cq;
-		context->ibv_ctx.ops.resize_cq     = hfi1_resize_cq_v1;
-		context->ibv_ctx.ops.destroy_cq    = hfi1_destroy_cq_v1;
-		context->ibv_ctx.ops.create_srq    = hfi1_create_srq_v1;
-		context->ibv_ctx.ops.destroy_srq   = hfi1_destroy_srq_v1;
-		context->ibv_ctx.ops.modify_srq    = hfi1_modify_srq_v1;
-		context->ibv_ctx.ops.post_srq_recv = ibv_cmd_post_srq_recv;
-		context->ibv_ctx.ops.create_qp     = hfi1_create_qp_v1;
-		context->ibv_ctx.ops.destroy_qp    = hfi1_destroy_qp_v1;
-		context->ibv_ctx.ops.post_recv     = ibv_cmd_post_recv;
+		context->ibv_ctx.context.ops.create_cq = hfi1_create_cq_v1;
+		context->ibv_ctx.context.ops.poll_cq = ibv_cmd_poll_cq;
+		context->ibv_ctx.context.ops.resize_cq = hfi1_resize_cq_v1;
+		context->ibv_ctx.context.ops.destroy_cq = hfi1_destroy_cq_v1;
+		context->ibv_ctx.context.ops.create_srq = hfi1_create_srq_v1;
+		context->ibv_ctx.context.ops.destroy_srq = hfi1_destroy_srq_v1;
+		context->ibv_ctx.context.ops.modify_srq = hfi1_modify_srq_v1;
+		context->ibv_ctx.context.ops.post_srq_recv =
+			ibv_cmd_post_srq_recv;
+		context->ibv_ctx.context.ops.create_qp = hfi1_create_qp_v1;
+		context->ibv_ctx.context.ops.destroy_qp = hfi1_destroy_qp_v1;
+		context->ibv_ctx.context.ops.post_recv = ibv_cmd_post_recv;
 	}
 	return &context->ibv_ctx;
 
 err_free:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -166,6 +167,7 @@ static void hfi1_free_context(struct ibv_context *ibctx)
 {
 	struct hfi1_context *context = to_ictx(ibctx);
 
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/hfi1verbs/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
index e672dda4982527..e7a05a0c0a83db 100644
--- a/providers/hfi1verbs/hfiverbs.h
+++ b/providers/hfi1verbs/hfiverbs.h
@@ -74,7 +74,7 @@ struct hfi1_device {
 };
 
 struct hfi1_context {
-	struct ibv_context	ibv_ctx;
+	struct verbs_context	ibv_ctx;
 };
 
 /*
@@ -158,7 +158,7 @@ struct hfi1_srq {
 
 static inline struct hfi1_context *to_ictx(struct ibv_context *ibctx)
 {
-	return to_ixxx(ctx, context);
+	return container_of(ibctx, struct hfi1_context, ibv_ctx.context);
 }
 
 static inline struct hfi1_device *to_idev(struct ibv_device *ibdev)
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 489b71614614fe..781825b3782044 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -61,8 +61,8 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
-						  int cmd_fd)
+static struct verbs_context *hns_roce_alloc_context(struct ibv_device *ibdev,
+						    int cmd_fd)
 {
 	int i;
 	struct ibv_get_context cmd;
@@ -71,11 +71,10 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	struct hns_roce_alloc_ucontext_resp resp;
 	struct hns_roce_device *hr_dev = to_hr_dev(ibdev);
 
-	context = calloc(1, sizeof(*context));
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	context->ibv_ctx.cmd_fd = cmd_fd;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof(resp)))
 		goto err_free;
@@ -113,28 +112,28 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
-	context->ibv_ctx.ops.query_device  = hns_roce_u_query_device;
-	context->ibv_ctx.ops.query_port    = hns_roce_u_query_port;
-	context->ibv_ctx.ops.alloc_pd	   = hns_roce_u_alloc_pd;
-	context->ibv_ctx.ops.dealloc_pd    = hns_roce_u_free_pd;
-	context->ibv_ctx.ops.reg_mr	   = hns_roce_u_reg_mr;
-	context->ibv_ctx.ops.rereg_mr	   = hns_roce_u_rereg_mr;
-	context->ibv_ctx.ops.dereg_mr	   = hns_roce_u_dereg_mr;
-
-	context->ibv_ctx.ops.create_cq     = hns_roce_u_create_cq;
-	context->ibv_ctx.ops.poll_cq	   = hr_dev->u_hw->poll_cq;
-	context->ibv_ctx.ops.req_notify_cq = hr_dev->u_hw->arm_cq;
-	context->ibv_ctx.ops.cq_event	   = hns_roce_u_cq_event;
-	context->ibv_ctx.ops.destroy_cq    = hns_roce_u_destroy_cq;
-
-	context->ibv_ctx.ops.create_qp     = hns_roce_u_create_qp;
-	context->ibv_ctx.ops.query_qp	   = hns_roce_u_query_qp;
-	context->ibv_ctx.ops.modify_qp     = hr_dev->u_hw->modify_qp;
-	context->ibv_ctx.ops.destroy_qp    = hr_dev->u_hw->destroy_qp;
-	context->ibv_ctx.ops.post_send     = hr_dev->u_hw->post_send;
-	context->ibv_ctx.ops.post_recv     = hr_dev->u_hw->post_recv;
-
-	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
+	context->ibv_ctx.context.ops.query_device  = hns_roce_u_query_device;
+	context->ibv_ctx.context.ops.query_port    = hns_roce_u_query_port;
+	context->ibv_ctx.context.ops.alloc_pd	   = hns_roce_u_alloc_pd;
+	context->ibv_ctx.context.ops.dealloc_pd    = hns_roce_u_free_pd;
+	context->ibv_ctx.context.ops.reg_mr	   = hns_roce_u_reg_mr;
+	context->ibv_ctx.context.ops.rereg_mr	   = hns_roce_u_rereg_mr;
+	context->ibv_ctx.context.ops.dereg_mr	   = hns_roce_u_dereg_mr;
+
+	context->ibv_ctx.context.ops.create_cq     = hns_roce_u_create_cq;
+	context->ibv_ctx.context.ops.poll_cq	   = hr_dev->u_hw->poll_cq;
+	context->ibv_ctx.context.ops.req_notify_cq = hr_dev->u_hw->arm_cq;
+	context->ibv_ctx.context.ops.cq_event	   = hns_roce_u_cq_event;
+	context->ibv_ctx.context.ops.destroy_cq    = hns_roce_u_destroy_cq;
+
+	context->ibv_ctx.context.ops.create_qp     = hns_roce_u_create_qp;
+	context->ibv_ctx.context.ops.query_qp	   = hns_roce_u_query_qp;
+	context->ibv_ctx.context.ops.modify_qp     = hr_dev->u_hw->modify_qp;
+	context->ibv_ctx.context.ops.destroy_qp    = hr_dev->u_hw->destroy_qp;
+	context->ibv_ctx.context.ops.post_send     = hr_dev->u_hw->post_send;
+	context->ibv_ctx.context.ops.post_recv     = hr_dev->u_hw->post_recv;
+
+	if (hns_roce_u_query_device(&context->ibv_ctx.context, &dev_attrs))
 		goto tptr_free;
 
 	context->max_qp_wr = dev_attrs.max_qp_wr;
@@ -155,6 +154,7 @@ db_free:
 	context->uar = NULL;
 
 err_free:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -167,6 +167,7 @@ static void hns_roce_free_context(struct ibv_context *ibctx)
 	if (to_hr_dev(ibctx->device)->hw_version == HNS_ROCE_HW_VER1)
 		munmap(context->cq_tptr_base, HNS_ROCE_CQ_DB_BUF_SIZE);
 
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 101320b1f8f3ad..02912468e68a65 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -94,7 +94,7 @@ struct hns_roce_buf {
 };
 
 struct hns_roce_context {
-	struct ibv_context		ibv_ctx;
+	struct verbs_context		ibv_ctx;
 	void				*uar;
 	pthread_spinlock_t		uar_lock;
 
@@ -221,7 +221,7 @@ static inline struct hns_roce_device *to_hr_dev(struct ibv_device *ibv_dev)
 
 static inline struct hns_roce_context *to_hr_ctx(struct ibv_context *ibv_ctx)
 {
-	return container_of(ibv_ctx, struct hns_roce_context, ibv_ctx);
+	return container_of(ibv_ctx, struct hns_roce_context, ibv_ctx.context);
 }
 
 static inline struct hns_roce_pd *to_hr_pd(struct ibv_pd *ibv_pd)
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 046f0a4b849712..3def78d25a9a71 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -208,7 +208,8 @@ static void hns_roce_set_sq_sizes(struct hns_roce_qp *qp,
 
 static int hns_roce_verify_cq(int *cqe, struct hns_roce_context *context)
 {
-	struct hns_roce_device *hr_dev = to_hr_dev(context->ibv_ctx.device);
+	struct hns_roce_device *hr_dev =
+		to_hr_dev(context->ibv_ctx.context.device);
 
 	if (hr_dev->hw_version == HNS_ROCE_HW_VER1)
 		if (*cqe < HNS_ROCE_MIN_CQE_NUM) {
@@ -328,7 +329,8 @@ int hns_roce_u_destroy_cq(struct ibv_cq *cq)
 static int hns_roce_verify_qp(struct ibv_qp_init_attr *attr,
 			      struct hns_roce_context *context)
 {
-	struct hns_roce_device *hr_dev = to_hr_dev(context->ibv_ctx.device);
+	struct hns_roce_device *hr_dev =
+		to_hr_dev(context->ibv_ctx.context.device);
 
 	if (hr_dev->hw_version == HNS_ROCE_HW_VER1) {
 		if (attr->cap.max_send_wr < HNS_ROCE_MIN_WQE_NUM) {
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 77c1ced812499b..6ec40895efcfe0 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -131,19 +131,18 @@ static struct ibv_context_ops i40iw_uctx_ops = {
  * context and getting back resource information to return as ibv_context.
  */
 
-static struct ibv_context *i40iw_ualloc_context(struct ibv_device *ibdev, int cmd_fd)
+static struct verbs_context *i40iw_ualloc_context(struct ibv_device *ibdev,
+						  int cmd_fd)
 {
 	struct ibv_pd *ibv_pd;
 	struct i40iw_uvcontext *iwvctx;
 	struct i40iw_get_context cmd;
 	struct i40iw_ualloc_ucontext_resp resp;
 
-	iwvctx = malloc(sizeof(*iwvctx));
+	iwvctx = verbs_init_and_alloc_context(ibdev, cmd_fd, iwvctx, ibv_ctx);
 	if (!iwvctx)
 		return NULL;
 
-	memset(iwvctx, 0, sizeof(*iwvctx));
-	iwvctx->ibv_ctx.cmd_fd = cmd_fd;
 	cmd.userspace_ver = I40IW_ABI_VER;
 	memset(&resp, 0, sizeof(resp));
 	if (ibv_cmd_get_context(&iwvctx->ibv_ctx, (struct ibv_get_context *)&cmd,
@@ -162,24 +161,24 @@ static struct ibv_context *i40iw_ualloc_context(struct ibv_device *ibdev, int cm
 		goto err_free;
 	}
 
-	iwvctx->ibv_ctx.device = ibdev;
-	iwvctx->ibv_ctx.ops = i40iw_uctx_ops;
+	iwvctx->ibv_ctx.context.ops = i40iw_uctx_ops;
 	iwvctx->max_pds = resp.max_pds;
 	iwvctx->max_qps = resp.max_qps;
 	iwvctx->wq_size = resp.wq_size;
 	iwvctx->abi_ver = resp.kernel_ver;
 
 	i40iw_device_init_uk(&iwvctx->dev);
-	ibv_pd = i40iw_ualloc_pd(&iwvctx->ibv_ctx);
+	ibv_pd = i40iw_ualloc_pd(&iwvctx->ibv_ctx.context);
 	if (!ibv_pd)
 		goto err_free;
-	ibv_pd->context = &iwvctx->ibv_ctx;
+	ibv_pd->context = &iwvctx->ibv_ctx.context;
 	iwvctx->iwupd = to_i40iw_upd(ibv_pd);
 
 	return &iwvctx->ibv_ctx;
 
 err_free:
 	fprintf(stderr, PFX "%s: failed to allocate context for device.\n", __func__);
+	verbs_uninit_context(&iwvctx->ibv_ctx);
 	free(iwvctx);
 
 	return NULL;
@@ -195,6 +194,7 @@ static void i40iw_ufree_context(struct ibv_context *ibctx)
 
 	i40iw_ufree_pd(&iwvctx->iwupd->ibv_pd);
 
+	verbs_uninit_context(&iwvctx->ibv_ctx);
 	free(iwvctx);
 }
 
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 109aba6bd92ef4..a2f4fa8f6b6bd9 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -83,7 +83,7 @@ struct i40iw_upd {
 };
 
 struct i40iw_uvcontext {
-	struct ibv_context ibv_ctx;
+	struct verbs_context ibv_ctx;
 	struct i40iw_upd *iwupd;
 	uint32_t max_pds;	/* maximum pds allowed for this user process */
 	uint32_t max_qps;	/* maximum qps allowed for this user process */
@@ -137,7 +137,7 @@ static inline struct i40iw_udevice *to_i40iw_udev(struct ibv_device *ibdev)
 
 static inline struct i40iw_uvcontext *to_i40iw_uctx(struct ibv_context *ibctx)
 {
-	return to_i40iw_uxxx(ctx, vcontext);
+	return container_of(ibctx, struct i40iw_uvcontext, ibv_ctx.context);
 }
 
 static inline struct i40iw_upd *to_i40iw_upd(struct ibv_pd *ibpd)
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 449abb0489955a..3f7f170ed6b986 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -122,41 +122,42 @@ static struct ibv_context_ops ipath_ctx_ops = {
 	.detach_mcast	= ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *ipath_alloc_context(struct ibv_device *ibdev,
-					       int cmd_fd)
+static struct verbs_context *ipath_alloc_context(struct ibv_device *ibdev,
+						 int cmd_fd)
 {
 	struct ipath_context	    *context;
 	struct ibv_get_context       cmd;
 	struct ibv_get_context_resp  resp;
 	struct ipath_device         *dev;
 
-	context = malloc(sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
-	memset(context, 0, sizeof *context);
-	context->ibv_ctx.cmd_fd = cmd_fd;
+
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd,
 				sizeof cmd, &resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.ops = ipath_ctx_ops;
+	context->ibv_ctx.context.ops = ipath_ctx_ops;
 	dev = to_idev(ibdev);
 	if (dev->abi_version == 1) {
-		context->ibv_ctx.ops.create_cq     = ipath_create_cq_v1;
-		context->ibv_ctx.ops.poll_cq       = ibv_cmd_poll_cq;
-		context->ibv_ctx.ops.resize_cq     = ipath_resize_cq_v1;
-		context->ibv_ctx.ops.destroy_cq    = ipath_destroy_cq_v1;
-		context->ibv_ctx.ops.create_srq    = ipath_create_srq_v1;
-		context->ibv_ctx.ops.destroy_srq   = ipath_destroy_srq_v1;
-		context->ibv_ctx.ops.modify_srq    = ipath_modify_srq_v1;
-		context->ibv_ctx.ops.post_srq_recv = ibv_cmd_post_srq_recv;
-		context->ibv_ctx.ops.create_qp     = ipath_create_qp_v1;
-		context->ibv_ctx.ops.destroy_qp    = ipath_destroy_qp_v1;
-		context->ibv_ctx.ops.post_recv     = ibv_cmd_post_recv;
+		context->ibv_ctx.context.ops.create_cq = ipath_create_cq_v1;
+		context->ibv_ctx.context.ops.poll_cq = ibv_cmd_poll_cq;
+		context->ibv_ctx.context.ops.resize_cq = ipath_resize_cq_v1;
+		context->ibv_ctx.context.ops.destroy_cq = ipath_destroy_cq_v1;
+		context->ibv_ctx.context.ops.create_srq = ipath_create_srq_v1;
+		context->ibv_ctx.context.ops.destroy_srq = ipath_destroy_srq_v1;
+		context->ibv_ctx.context.ops.modify_srq = ipath_modify_srq_v1;
+		context->ibv_ctx.context.ops.post_srq_recv =
+			ibv_cmd_post_srq_recv;
+		context->ibv_ctx.context.ops.create_qp = ipath_create_qp_v1;
+		context->ibv_ctx.context.ops.destroy_qp = ipath_destroy_qp_v1;
+		context->ibv_ctx.context.ops.post_recv = ibv_cmd_post_recv;
 	}
 	return &context->ibv_ctx;
 
 err_free:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -165,6 +166,7 @@ static void ipath_free_context(struct ibv_context *ibctx)
 {
 	struct ipath_context *context = to_ictx(ibctx);
 
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/ipathverbs/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
index 5f2658e7942c8b..d26a2a1b29009e 100644
--- a/providers/ipathverbs/ipathverbs.h
+++ b/providers/ipathverbs/ipathverbs.h
@@ -54,7 +54,7 @@ struct ipath_device {
 };
 
 struct ipath_context {
-	struct ibv_context	ibv_ctx;
+	struct verbs_context	ibv_ctx;
 };
 
 /*
@@ -137,7 +137,7 @@ struct ipath_srq {
 
 static inline struct ipath_context *to_ictx(struct ibv_context *ibctx)
 {
-	return to_ixxx(ctx, context);
+	return container_of(ibctx, struct ipath_context, ibv_ctx.context);
 }
 
 static inline struct ipath_device *to_idev(struct ibv_device *ibdev)
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index d2ccd328625c80..56bf1298b48734 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -167,16 +167,16 @@ static int mlx4_init_context(struct verbs_device *v_device,
 
 	mlx4_read_env();
 	if (dev->abi_version <= MLX4_UVERBS_NO_DEV_CAPS_ABI_VERSION) {
-		if (ibv_cmd_get_context(ibv_ctx, &cmd, sizeof cmd,
-					&resp_v3.ibv_resp, sizeof resp_v3))
+		if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd),
+					&resp_v3.ibv_resp, sizeof(resp_v3)))
 			return errno;
 
 		context->num_qps  = resp_v3.qp_tab_size;
 		bf_reg_size	  = resp_v3.bf_reg_size;
 		context->cqe_size = sizeof (struct mlx4_cqe);
 	} else  {
-		if (ibv_cmd_get_context(ibv_ctx, &cmd, sizeof cmd,
-					&resp.ibv_resp, sizeof resp))
+		if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd),
+					&resp.ibv_resp, sizeof(resp)))
 			return errno;
 
 		context->num_qps  = resp.qp_tab_size;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 36486218e31d81..a829cd5eb26473 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -549,7 +549,9 @@ static int mlx5_cmd_get_context(struct mlx5_context *context,
 				struct mlx5_alloc_ucontext_resp *resp,
 				size_t resp_len)
 {
-	if (!ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+	struct verbs_context *verbs_ctx = verbs_get_ctx(&context->ibv_ctx);
+
+	if (!ibv_cmd_get_context(verbs_ctx, &req->ibv_req,
 				 req_len, &resp->ibv_resp, resp_len))
 		return 0;
 
@@ -572,12 +574,12 @@ static int mlx5_cmd_get_context(struct mlx5_context *context,
 	 * to do so. If zero is a valid response, we will add a new
 	 * field that indicates whether the request was handled.
 	 */
-	if (!ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+	if (!ibv_cmd_get_context(verbs_ctx, &req->ibv_req,
 				 offsetof(struct mlx5_alloc_ucontext, lib_caps),
 				 &resp->ibv_resp, resp_len))
 		return 0;
 
-	return ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+	return ibv_cmd_get_context(verbs_ctx, &req->ibv_req,
 				   offsetof(struct mlx5_alloc_ucontext,
 					    cqe_version),
 				   &resp->ibv_resp, resp_len);
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 511b8d5139af9c..15827391986d3a 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -114,19 +114,18 @@ static struct ibv_context_ops mthca_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *mthca_alloc_context(struct ibv_device *ibdev, int cmd_fd)
+static struct verbs_context *mthca_alloc_context(struct ibv_device *ibdev,
+						 int cmd_fd)
 {
 	struct mthca_context            *context;
 	struct ibv_get_context           cmd;
 	struct mthca_alloc_ucontext_resp resp;
 	int                              i;
 
-	context = calloc(1, sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	context->ibv_ctx.cmd_fd = cmd_fd;
-
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof resp))
 		goto err_free;
@@ -135,13 +134,7 @@ static struct ibv_context *mthca_alloc_context(struct ibv_device *ibdev, int cmd
 	context->qp_table_shift = ffs(context->num_qps) - 1 - MTHCA_QP_TABLE_BITS;
 	context->qp_table_mask  = (1 << context->qp_table_shift) - 1;
 
-	/*
-	 * Need to set ibv_ctx.device because mthca_is_memfree() will
-	 * look at it to figure out the HCA type.
-	 */
-	context->ibv_ctx.device = ibdev;
-
-	if (mthca_is_memfree(&context->ibv_ctx)) {
+	if (mthca_is_memfree(&context->ibv_ctx.context)) {
 		context->db_tab = mthca_alloc_db_tab(resp.uarc_size);
 		if (!context->db_tab)
 			goto err_free;
@@ -159,26 +152,28 @@ static struct ibv_context *mthca_alloc_context(struct ibv_device *ibdev, int cmd
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
-	context->pd = mthca_alloc_pd(&context->ibv_ctx);
+	context->pd = mthca_alloc_pd(&context->ibv_ctx.context);
 	if (!context->pd)
 		goto err_unmap;
 
-	context->pd->context = &context->ibv_ctx;
+	context->pd->context = &context->ibv_ctx.context;
 
-	context->ibv_ctx.ops = mthca_ctx_ops;
+	context->ibv_ctx.context.ops = mthca_ctx_ops;
 
-	if (mthca_is_memfree(&context->ibv_ctx)) {
-		context->ibv_ctx.ops.req_notify_cq = mthca_arbel_arm_cq;
-		context->ibv_ctx.ops.cq_event      = mthca_arbel_cq_event;
-		context->ibv_ctx.ops.post_send     = mthca_arbel_post_send;
-		context->ibv_ctx.ops.post_recv     = mthca_arbel_post_recv;
-		context->ibv_ctx.ops.post_srq_recv = mthca_arbel_post_srq_recv;
+	if (mthca_is_memfree(&context->ibv_ctx.context)) {
+		context->ibv_ctx.context.ops.req_notify_cq = mthca_arbel_arm_cq;
+		context->ibv_ctx.context.ops.cq_event = mthca_arbel_cq_event;
+		context->ibv_ctx.context.ops.post_send = mthca_arbel_post_send;
+		context->ibv_ctx.context.ops.post_recv = mthca_arbel_post_recv;
+		context->ibv_ctx.context.ops.post_srq_recv =
+			mthca_arbel_post_srq_recv;
 	} else {
-		context->ibv_ctx.ops.req_notify_cq = mthca_tavor_arm_cq;
-		context->ibv_ctx.ops.cq_event      = NULL;
-		context->ibv_ctx.ops.post_send     = mthca_tavor_post_send;
-		context->ibv_ctx.ops.post_recv     = mthca_tavor_post_recv;
-		context->ibv_ctx.ops.post_srq_recv = mthca_tavor_post_srq_recv;
+		context->ibv_ctx.context.ops.req_notify_cq = mthca_tavor_arm_cq;
+		context->ibv_ctx.context.ops.cq_event = NULL;
+		context->ibv_ctx.context.ops.post_send = mthca_tavor_post_send;
+		context->ibv_ctx.context.ops.post_recv = mthca_tavor_post_recv;
+		context->ibv_ctx.context.ops.post_srq_recv =
+			mthca_tavor_post_srq_recv;
 	}
 
 	return &context->ibv_ctx;
@@ -190,6 +185,7 @@ err_db_tab:
 	mthca_free_db_tab(context->db_tab);
 
 err_free:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -201,6 +197,8 @@ static void mthca_free_context(struct ibv_context *ibctx)
 	mthca_free_pd(context->pd);
 	munmap(context->uar, to_mdev(ibctx->device)->page_size);
 	mthca_free_db_tab(context->db_tab);
+
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/mthca/mthca.h b/providers/mthca/mthca.h
index a67acf46c7c56d..d788f7613b439c 100644
--- a/providers/mthca/mthca.h
+++ b/providers/mthca/mthca.h
@@ -97,7 +97,7 @@ struct mthca_device {
 struct mthca_db_table;
 
 struct mthca_context {
-	struct ibv_context     ibv_ctx;
+	struct verbs_context     ibv_ctx;
 	void                  *uar;
 	pthread_spinlock_t     uar_lock;
 	struct mthca_db_table *db_tab;
@@ -229,7 +229,7 @@ static inline struct mthca_device *to_mdev(struct ibv_device *ibdev)
 
 static inline struct mthca_context *to_mctx(struct ibv_context *ibctx)
 {
-	return to_mxxx(ctx, context);
+	return container_of(ibctx, struct mthca_context, ibv_ctx.context);
 }
 
 static inline struct mthca_pd *to_mpd(struct ibv_pd *ibpd)
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index bd0b6ac68cec40..a5ae678ecfe11c 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -98,7 +98,8 @@ static struct ibv_context_ops nes_uctx_ops = {
 /**
  * nes_ualloc_context
  */
-static struct ibv_context *nes_ualloc_context(struct ibv_device *ibdev, int cmd_fd)
+static struct verbs_context *nes_ualloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct ibv_pd *ibv_pd;
 	struct nes_uvcontext *nesvctx;
@@ -109,16 +110,14 @@ static struct ibv_context *nes_ualloc_context(struct ibv_device *ibdev, int cmd_
 
 	page_size = sysconf(_SC_PAGESIZE);
 
-	nesvctx = malloc(sizeof *nesvctx);
+	nesvctx = verbs_init_and_alloc_context(ibdev, cmd_fd, nesvctx, ibv_ctx);
 	if (!nesvctx)
 		return NULL;
 
-	memset(nesvctx, 0, sizeof *nesvctx);
-	nesvctx->ibv_ctx.cmd_fd = cmd_fd;
 	cmd.userspace_ver = NES_ABI_USERSPACE_VER;
 
 	if (ibv_cmd_get_context(&nesvctx->ibv_ctx, (struct ibv_get_context *)&cmd, sizeof cmd,
-			&resp.ibv_resp, sizeof(resp)))
+				&resp.ibv_resp, sizeof(resp)))
 		goto err_free;
 
 	if (resp.kernel_ver != NES_ABI_KERNEL_VER) {
@@ -135,12 +134,10 @@ static struct ibv_context *nes_ualloc_context(struct ibv_device *ibdev, int cmd_
 			sscanf(value, "%d", &nes_drv_opt);
 	}
 
-	nesvctx->ibv_ctx.device = ibdev;
-
 	if (nes_drv_opt & NES_DRV_OPT_NO_DB_READ)
 		nes_uctx_ops.poll_cq = nes_upoll_cq_no_db_read;
 
-	nesvctx->ibv_ctx.ops = nes_uctx_ops;
+	nesvctx->ibv_ctx.context.ops = nes_uctx_ops;
 	nesvctx->max_pds = resp.max_pds;
 	nesvctx->max_qps = resp.max_qps;
 	nesvctx->wq_size = resp.wq_size;
@@ -148,16 +145,17 @@ static struct ibv_context *nes_ualloc_context(struct ibv_device *ibdev, int cmd_
 	nesvctx->mcrqf = 0;
 
 	/* Get a doorbell region for the CQs */
-	ibv_pd = nes_ualloc_pd(&nesvctx->ibv_ctx);
+	ibv_pd = nes_ualloc_pd(&nesvctx->ibv_ctx.context);
 	if (!ibv_pd)
 		goto err_free;
-	ibv_pd->context = &nesvctx->ibv_ctx;
+	ibv_pd->context = &nesvctx->ibv_ctx.context;
 	nesvctx->nesupd = to_nes_upd(ibv_pd);
 
 	return &nesvctx->ibv_ctx;
 
 err_free:
  	fprintf(stderr, PFX "%s: Failed to allocate context for device.\n", __FUNCTION__);
+	verbs_uninit_context(&nesvctx->ibv_ctx);
 	free(nesvctx);
 
 	return NULL;
@@ -172,6 +170,7 @@ static void nes_ufree_context(struct ibv_context *ibctx)
 	struct nes_uvcontext *nesvctx = to_nes_uctx(ibctx);
 	nes_ufree_pd(&nesvctx->nesupd->ibv_pd);
 
+	verbs_uninit_context(&nesvctx->ibv_ctx);
 	free(nesvctx);
 }
 
diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index 0a832e7517bea6..2750c128d76ce7 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -261,7 +261,7 @@ struct nes_upd {
 };
 
 struct nes_uvcontext {
-	struct ibv_context ibv_ctx;
+	struct verbs_context ibv_ctx;
 	struct nes_upd *nesupd;
 	uint32_t max_pds; /* maximum pds allowed for this user process */
 	uint32_t max_qps; /* maximum qps allowed for this user process */
@@ -331,7 +331,7 @@ static inline struct nes_udevice *to_nes_udev(struct ibv_device *ibdev)
 
 static inline struct nes_uvcontext *to_nes_uctx(struct ibv_context *ibctx)
 {
-	return to_nes_uxxx(ctx, vcontext);
+	return container_of(ibctx, struct nes_uvcontext, ibv_ctx.context);
 }
 
 static inline struct nes_upd *to_nes_upd(struct ibv_pd *ibpd)
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index afd5d79c1884c0..5bb17eb8665bfc 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -105,27 +105,23 @@ static void ocrdma_uninit_device(struct verbs_device *verbs_device)
 /*
  * ocrdma_alloc_context
  */
-static struct ibv_context *ocrdma_alloc_context(struct ibv_device *ibdev,
-						int cmd_fd)
+static struct verbs_context *ocrdma_alloc_context(struct ibv_device *ibdev,
+						  int cmd_fd)
 {
 	struct ocrdma_devctx *ctx;
 	struct ocrdma_get_context cmd;
 	struct ocrdma_alloc_ucontext_resp resp;
 
-	ctx = calloc(1, sizeof(struct ocrdma_devctx));
+	ctx = verbs_init_and_alloc_context(ibdev, cmd_fd, ctx, ibv_ctx);
 	if (!ctx)
 		return NULL;
-	memset(&resp, 0, sizeof(resp));
-
-	ctx->ibv_ctx.cmd_fd = cmd_fd;
 
 	if (ibv_cmd_get_context(&ctx->ibv_ctx,
 				(struct ibv_get_context *)&cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof(resp)))
 		goto cmd_err;
 
-	ctx->ibv_ctx.device = ibdev;
-	ctx->ibv_ctx.ops = ocrdma_ctx_ops;
+	ctx->ibv_ctx.context.ops = ocrdma_ctx_ops;
 	get_ocrdma_dev(ibdev)->id = resp.dev_id;
 	get_ocrdma_dev(ibdev)->max_inline_data = resp.max_inline_data;
 	get_ocrdma_dev(ibdev)->wqe_size = resp.wqe_size;
@@ -146,6 +142,7 @@ static struct ibv_context *ocrdma_alloc_context(struct ibv_device *ibdev,
 
 cmd_err:
 	ocrdma_err("%s: Failed to allocate context for device.\n", __func__);
+	verbs_uninit_context(&ctx->ibv_ctx);
 	free(ctx);
 	return NULL;
 }
@@ -160,6 +157,7 @@ static void ocrdma_free_context(struct ibv_context *ibctx)
 	if (ctx->ah_tbl)
 		munmap((void *)ctx->ah_tbl, ctx->ah_tbl_len);
 
+	verbs_uninit_context(&ctx->ibv_ctx);
 	free(ctx);
 }
 
diff --git a/providers/ocrdma/ocrdma_main.h b/providers/ocrdma/ocrdma_main.h
index e5b2860f9dc45c..e414223d07cd83 100644
--- a/providers/ocrdma/ocrdma_main.h
+++ b/providers/ocrdma/ocrdma_main.h
@@ -68,7 +68,7 @@ struct ocrdma_device {
 };
 
 struct ocrdma_devctx {
-	struct ibv_context ibv_ctx;
+	struct verbs_context ibv_ctx;
 	uint32_t *ah_tbl;
 	uint32_t ah_tbl_len;
 	pthread_mutex_t tbl_lock;
@@ -231,7 +231,7 @@ struct ocrdma_ah {
 
 static inline struct ocrdma_devctx *get_ocrdma_ctx(struct ibv_context *ibctx)
 {
-	return get_ocrdma_xxx(ctx, devctx);
+	return container_of(ibctx, struct ocrdma_devctx, ibv_ctx.context);
 }
 
 static inline struct ocrdma_device *get_ocrdma_dev(struct ibv_device *ibdev)
diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index b3faa0044137d8..faa8e99cfa0798 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -118,7 +118,7 @@ struct qelr_device {
 };
 
 struct qelr_devctx {
-	struct ibv_context	ibv_ctx;
+	struct verbs_context	ibv_ctx;
 	FILE			*dbg_fp;
 	void			*db_addr;
 	uint64_t		db_pa;
@@ -251,7 +251,7 @@ struct qelr_qp {
 
 static inline struct qelr_devctx *get_qelr_ctx(struct ibv_context *ibctx)
 {
-	return container_of(ibctx, struct qelr_devctx, ibv_ctx);
+	return container_of(ibctx, struct qelr_devctx, ibv_ctx.context);
 }
 
 static inline struct qelr_device *get_qelr_dev(struct ibv_device *ibdev)
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 4d62442a58dcb7..92a635cdcfca94 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -155,19 +155,18 @@ static void qelr_set_debug_mask(void)
 		qelr_dp_module = atoi(env);
 }
 
-static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
-					      int cmd_fd)
+static struct verbs_context *qelr_alloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct qelr_devctx *ctx;
 	struct qelr_get_context cmd;
 	struct qelr_alloc_ucontext_resp resp;
 
-	ctx = calloc(1, sizeof(struct qelr_devctx));
+	ctx = verbs_init_and_alloc_context(ibdev, cmd_fd, ctx, ibv_ctx);
 	if (!ctx)
 		return NULL;
-	memset(&resp, 0, sizeof(resp));
 
-	ctx->ibv_ctx.cmd_fd = cmd_fd;
+	memset(&resp, 0, sizeof(resp));
 
 	qelr_open_debug_file(ctx);
 	qelr_set_debug_mask();
@@ -178,8 +177,7 @@ static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
 		goto cmd_err;
 
 	ctx->kernel_page_size = sysconf(_SC_PAGESIZE);
-	ctx->ibv_ctx.device = ibdev;
-	ctx->ibv_ctx.ops = qelr_ctx_ops;
+	ctx->ibv_ctx.context.ops = qelr_ctx_ops;
 	ctx->db_pa = resp.db_pa;
 	ctx->db_size = resp.db_size;
 	ctx->max_send_wr = resp.max_send_wr;
@@ -205,6 +203,7 @@ static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
 cmd_err:
 	qelr_err("%s: Failed to allocate context for device.\n", __func__);
 	qelr_close_debug_file(ctx);
+	verbs_uninit_context(&ctx->ibv_ctx);
 	free(ctx);
 	return NULL;
 }
@@ -217,6 +216,7 @@ static void qelr_free_context(struct ibv_context *ibctx)
 		munmap(ctx->db_addr, ctx->db_size);
 
 	qelr_close_debug_file(ctx);
+	verbs_uninit_context(&ctx->ibv_ctx);
 	free(ctx);
 }
 
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 7db0fb3216dde9..5d7aeb37453c44 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -887,7 +887,7 @@ static inline void qelr_init_dpm_info(struct qelr_devctx *cxt,
 	dpm->is_edpm = 0;
 
 	/* Currently dpm is not supported for iWARP */
-	if (IS_IWARP(cxt->ibv_ctx.device))
+	if (IS_IWARP(cxt->ibv_ctx.context.device))
 		return;
 
 	if (qelr_chain_is_full(&qp->sq.chain) &&
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 683ffaa2a8af9c..5cfdf1aac08a86 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -858,29 +858,27 @@ static struct ibv_context_ops rxe_ctx_ops = {
 	.detach_mcast = ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *rxe_alloc_context(struct ibv_device *ibdev,
-					     int cmd_fd)
+static struct verbs_context *rxe_alloc_context(struct ibv_device *ibdev,
+					       int cmd_fd)
 {
 	struct rxe_context *context;
 	struct ibv_get_context cmd;
 	struct ibv_get_context_resp resp;
 
-	context = malloc(sizeof *context);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	memset(context, 0, sizeof *context);
-	context->ibv_ctx.cmd_fd = cmd_fd;
-
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd,
 				sizeof cmd, &resp, sizeof resp))
 		goto out;
 
-	context->ibv_ctx.ops = rxe_ctx_ops;
+	context->ibv_ctx.context.ops = rxe_ctx_ops;
 
 	return &context->ibv_ctx;
 
 out:
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 	return NULL;
 }
@@ -889,6 +887,7 @@ static void rxe_free_context(struct ibv_context *ibctx)
 {
 	struct rxe_context *context = to_rctx(ibctx);
 
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
diff --git a/providers/rxe/rxe.h b/providers/rxe/rxe.h
index 1f331662b2ba2d..3fc0436127e432 100644
--- a/providers/rxe/rxe.h
+++ b/providers/rxe/rxe.h
@@ -54,7 +54,7 @@ struct rxe_device {
 };
 
 struct rxe_context {
-	struct ibv_context	ibv_ctx;
+	struct verbs_context	ibv_ctx;
 };
 
 struct rxe_cq {
@@ -98,7 +98,7 @@ struct rxe_srq {
 
 static inline struct rxe_context *to_rctx(struct ibv_context *ibctx)
 {
-	return to_rxxx(ctx, context);
+	return container_of(ibctx, struct rxe_context, ibv_ctx.context);
 }
 
 static inline struct rxe_device *to_rdev(struct ibv_device *ibdev)
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index 3bcec1cb71d14d..58165cf434b721 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -105,7 +105,7 @@ struct pvrdma_device {
 };
 
 struct pvrdma_context {
-	struct ibv_context		ibv_ctx;
+	struct verbs_context		ibv_ctx;
 	void				*uar;
 	pthread_spinlock_t		uar_lock;
 	int				max_qp_wr;
@@ -201,7 +201,7 @@ static inline struct pvrdma_device *to_vdev(struct ibv_device *ibdev)
 
 static inline struct pvrdma_context *to_vctx(struct ibv_context *ibctx)
 {
-	return container_of(ibctx, struct pvrdma_context, ibv_ctx);
+	return container_of(ibctx, struct pvrdma_context, ibv_ctx.context);
 }
 
 static inline struct pvrdma_pd *to_vpd(struct ibv_pd *ibpd)
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 17736cd0079036..08b1d4e6d34f07 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -111,7 +111,7 @@ static int pvrdma_init_context_shared(struct pvrdma_context *context,
 	struct ibv_get_context cmd;
 	struct user_pvrdma_alloc_ucontext_resp resp;
 
-	context->ibv_ctx.cmd_fd = cmd_fd;
+	context->ibv_ctx.context.cmd_fd = cmd_fd;
 	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof(resp)))
 		return errno;
@@ -129,7 +129,7 @@ static int pvrdma_init_context_shared(struct pvrdma_context *context,
 	}
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
-	context->ibv_ctx.ops = pvrdma_ctx_ops;
+	context->ibv_ctx.context.ops = pvrdma_ctx_ops;
 
 	return 0;
 }
@@ -141,18 +141,17 @@ static void pvrdma_free_context_shared(struct pvrdma_context *context,
 	free(context->qp_tbl);
 }
 
-static struct ibv_context *pvrdma_alloc_context(struct ibv_device *ibdev,
-						int cmd_fd)
+static struct verbs_context *pvrdma_alloc_context(struct ibv_device *ibdev,
+						  int cmd_fd)
 {
 	struct pvrdma_context *context;
 
-	context = malloc(sizeof(*context));
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
 		return NULL;
 
-	memset(context, 0, sizeof(*context));
-
 	if (pvrdma_init_context_shared(context, ibdev, cmd_fd)) {
+		verbs_uninit_context(&context->ibv_ctx);
 		free(context);
 		return NULL;
 	}
@@ -165,6 +164,7 @@ static void pvrdma_free_context(struct ibv_context *ibctx)
 	struct pvrdma_context *context = to_vctx(ibctx);
 
 	pvrdma_free_context_shared(context, to_vdev(ibctx->device));
+	verbs_uninit_context(&context->ibv_ctx);
 	free(context);
 }
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
