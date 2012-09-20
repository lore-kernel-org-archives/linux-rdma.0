From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] libibverbs: Infra-structure changes to support verbs
 extension
Date: Thu, 20 Sep 2012 21:43:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E7ED@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Infrastructure to support extended verbs capabilities in a forward/backward
manner.

The general operation as shown in the following pseudo-code:

ibv_open_device()
{
	context = device->ops.alloc_context();
	if (context == -1) {
		context_ex = malloc(verbs_context + verbs_device->context_size);
		verbs_device->init_context(context_ex);
		context_ex->context.abi_compat = -1;
	}
}

If the underlying provider supports extensions, it returns -1 from its
alloc_context() call.  Ibverbs then allocates the ibv_context structure and
calls into the provider to finish initializing it.

When extensions are supported, the ibv_device structure is embedded in a
larger verbs_device structure.  Similarly, ibv_context is embedded inside
a larger verbs_context structure.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h |    1 +
 include/infiniband/verbs.h  |   52 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                   |   41 +---------------------------------
 src/device.c                |   52 ++++++++++++++++++++++++++++++++++++-------
 src/init.c                  |    8 +++++++
 src/libibverbs.map          |    1 +
 6 files changed, 107 insertions(+), 48 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..5af0d7f 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -57,6 +57,7 @@ typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 
 void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
+void verbs_register_driver(const char *name, ibv_driver_init_func init_func);
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
 			size_t resp_size);
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6acfc81..a2577d8 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -38,6 +38,7 @@
 
 #include <stdint.h>
 #include <pthread.h>
+#include <stddef.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -63,6 +64,19 @@ union ibv_gid {
 	} global;
 };
 
+#ifndef container_of
+/**
+  * container_of - cast a member of a structure out to the containing structure
+  * @ptr:        the pointer to the member.
+  * @type:       the type of the container struct this is embedded in.
+  * @member:     the name of the member within the struct.
+  *
+ */
+#define container_of(ptr, type, member) ({\
+	const typeof(((type *)0)->member) * __mptr = (ptr);\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
 enum ibv_node_type {
 	IBV_NODE_UNKNOWN	= -1,
 	IBV_NODE_CA 		= 1,
@@ -634,6 +648,17 @@ struct ibv_device {
 	char			ibdev_path[IBV_SYSFS_PATH_MAX];
 };
 
+struct verbs_device {
+	struct ibv_device device; /* Must be first */
+	size_t	sz;
+	size_t	size_of_context;
+	int	(*init_context)(struct verbs_device *device,
+				struct ibv_context *ctx, int cmd_fd);
+	void	(*uninit_context)(struct verbs_device *device,
+				struct ibv_context *ctx);
+	/* future fields added here */
+};
+
 struct ibv_context_ops {
 	int			(*query_device)(struct ibv_context *context,
 					      struct ibv_device_attr *device_attr);
@@ -702,6 +727,33 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+struct verbs_context {
+
+	/*  "grows up" - new fields go here
+	int (*drv_new_func1) ();	new corresponding provider call of func1
+	int (*lib_new_func1) ();	New library call func1
+	*/
+	size_t sz;	/* Set by library on struct allocation,must be
+			* located right before struct ibv_context
+			*/
+	struct ibv_context context;/* Must be last field in the struct */
+};
+
+static inline struct verbs_context *verbs_get_ctx(
+					const struct ibv_context *ctx)
+{
+	if (ctx->abi_compat != ((uint8_t *)NULL)-1)
+		return NULL;
+
+	return container_of(ctx, struct verbs_context, context);
+}
+
+static inline struct verbs_device *verbs_get_device(
+					const struct ibv_device *dev)
+{
+	return container_of(dev, struct verbs_device, device);
+}
+
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
diff --git a/src/cmd.c b/src/cmd.c
index 9789092..dab8930 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -45,52 +45,13 @@
 
 #include "ibverbs.h"
 
-static int ibv_cmd_get_context_v2(struct ibv_context *context,
-				  struct ibv_get_context *new_cmd,
-				  size_t new_cmd_size,
-				  struct ibv_get_context_resp *resp,
-				  size_t resp_size)
-{
-	struct ibv_abi_compat_v2 *t;
-	struct ibv_get_context_v2 *cmd;
-	size_t cmd_size;
-	uint32_t cq_fd;
-
-	t = malloc(sizeof *t);
-	if (!t)
-		return ENOMEM;
-	pthread_mutex_init(&t->in_use, NULL);
-
-	cmd_size = sizeof *cmd + new_cmd_size - sizeof *new_cmd;
-	cmd      = alloca(cmd_size);
-	memcpy(cmd->driver_data, new_cmd->driver_data, new_cmd_size - sizeof *new_cmd);
-
-	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
-	cmd->cq_fd_tab = (uintptr_t) &cq_fd;
-
-	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size) {
-		free(t);
-		return errno;
-	}
-
-	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
-
-	context->async_fd         = resp->async_fd;
-	context->num_comp_vectors = 1;
-	t->channel.context        = context;
-	t->channel.fd		  = cq_fd;
-	t->channel.refcnt	  = 0;
-	context->abi_compat       = t;
-
-	return 0;
-}
 
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
 			size_t resp_size)
 {
 	if (abi_ver <= 2)
-		return ibv_cmd_get_context_v2(context, cmd, cmd_size, resp, resp_size);
+		return ENOSYS;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
 
diff --git a/src/device.c b/src/device.c
index 5798895..9e43138 100644
--- a/src/device.c
+++ b/src/device.c
@@ -127,6 +127,7 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	char *devpath;
 	int cmd_fd;
 	struct ibv_context *context;
+	struct verbs_context *context_ex;
 
 	if (asprintf(&devpath, "/dev/infiniband/%s", device->dev_name) < 0)
 		return NULL;
@@ -144,6 +145,36 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	context = device->ops.alloc_context(device, cmd_fd);
 	if (!context)
 		goto err;
+	if (context == (struct ibv_context *)(((uint8_t *)NULL)-1)) {
+		/* New provider that supports verbs extension was detected */
+		struct verbs_device *verbs_device =
+					verbs_get_device(device);
+		int ret;
+
+		/* Library now allocates the context */
+		context_ex = calloc(1, sizeof(*context_ex) +
+			verbs_device->size_of_context);
+
+		if (!context_ex) {
+			errno = ENOMEM;
+			goto err;
+		}
+		context = &context_ex->context;
+		/* Init new verbs_context */
+		context_ex->context.abi_compat  = ((uint8_t *)NULL)-1;
+		context_ex->sz = sizeof(*context_ex);
+
+		/* Call provider to initialize its calls first */
+		ret = verbs_device->init_context(verbs_device,
+					&context_ex->context, cmd_fd);
+		if (ret)
+			goto verbs_err;
+		/* initialize *all* library ops to either lib calls or
+		  * directly to provider calls.
+		context_ex-> lib_new_func1= __verbs_new_func1;
+		context_ex-> lib_new_func2= __verbs_new_func2;
+		*/
+	}
 
 	context->device = device;
 	context->cmd_fd = cmd_fd;
@@ -151,6 +182,8 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 
 	return context;
 
+verbs_err:
+	free(context_ex);
 err:
 	close(cmd_fd);
 
@@ -163,14 +196,17 @@ int __ibv_close_device(struct ibv_context *context)
 	int async_fd = context->async_fd;
 	int cmd_fd   = context->cmd_fd;
 	int cq_fd    = -1;
-
-	if (abi_ver <= 2) {
-		struct ibv_abi_compat_v2 *t = context->abi_compat;
-		cq_fd = t->channel.fd;
-		free(context->abi_compat);
-	}
-
-	context->device->ops.free_context(context);
+	struct verbs_context *context_ex;
+
+	context_ex = verbs_get_ctx(context);
+	if (context_ex) {
+		struct verbs_device *verbs_device =
+					verbs_get_device(context->device);
+		/* Provider supports verbs extension */
+		verbs_device->uninit_context(verbs_device, context);
+		free(context_ex);
+	} else
+		context->device->ops.free_context(context);
 
 	close(async_fd);
 	close(cmd_fd);
diff --git a/src/init.c b/src/init.c
index 8d6786e..a1b0905 100644
--- a/src/init.c
+++ b/src/init.c
@@ -174,6 +174,14 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 	tail_driver = driver;
 }
 
+/* New registration symbol with same functionality - used by providers to
+  * validate that library supports verbs extension.
+  */
+void verbs_register_driver(const char *name, ibv_driver_init_func init_func)
+{
+	ibv_register_driver(name, init_func);
+}
+
 static void load_driver(const char *name)
 {
 	char *so_name;
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..ee9adea 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -91,6 +91,7 @@ IBVERBS_1.1 {
 		ibv_dontfork_range;
 		ibv_dofork_range;
 		ibv_register_driver;
+		verbs_register_driver;
 
 		ibv_node_type_str;
 		ibv_port_state_str;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
