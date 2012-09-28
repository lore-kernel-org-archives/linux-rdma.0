From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/7] libibverbs: Infrastructure to support verbs
 extensions
Date: Fri, 28 Sep 2012 00:02:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A97DDE@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Patch adapted from Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Infrastructure to support extended verbs capabilities in a forward/backward
manner.

Support for extensions is determined by the provider calling
verbs_register_driver in place of ibv_register_driver.  When extensions
are enabled, ibverbs sets the current alloc_context / free_context
device operations to NULL.  These are used to indicate that the
struct ibv_device may be cast to struct verbs_device.

With extension support, ibverbs allocates the ibv_context structure
and calls into the provider to finish initializing it.  The
initialization calls are part of the new struct verbs_device.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
change from v1:
Use provider registration call to determine if extensions are
supported, rather than return value from alloc_context.


 include/infiniband/driver.h |    3 ++
 include/infiniband/verbs.h  |   51 +++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                   |   41 +--------------------------------
 src/device.c                |   54 +++++++++++++++++++++++++++++++++----------
 src/init.c                  |   41 +++++++++++++++++++++++++++------
 src/libibverbs.map          |    1 +
 6 files changed, 131 insertions(+), 60 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..f22f287 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -55,8 +55,11 @@
 
 typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
+typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
+						       int abi_version);
 
 void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
+void verbs_register_driver(const char *name, verbs_driver_init_func init_func);
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
 			size_t resp_size);
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6acfc81..cd7f916 100644
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
@@ -702,6 +727,32 @@ struct ibv_context {
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
+	return (ctx->abi_compat != ((uint8_t *) NULL) - 1) ?
+		NULL : container_of(ctx, struct verbs_context, context);
+}
+
+static inline struct verbs_device *verbs_get_device(
+					const struct ibv_device *dev)
+{
+	return (dev->ops.alloc_context) ?
+		NULL : container_of(dev, struct verbs_device, device);
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
index 5798895..448a243 100644
--- a/src/device.c
+++ b/src/device.c
@@ -124,9 +124,11 @@ default_symver(__ibv_get_device_guid, ibv_get_device_guid);
 
 struct ibv_context *__ibv_open_device(struct ibv_device *device)
 {
+	struct verbs_device *verbs_device = verbs_get_device(device);
 	char *devpath;
-	int cmd_fd;
+	int cmd_fd, ret;
 	struct ibv_context *context;
+	struct verbs_context *context_ex;
 
 	if (asprintf(&devpath, "/dev/infiniband/%s", device->dev_name) < 0)
 		return NULL;
@@ -141,9 +143,33 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	if (cmd_fd < 0)
 		return NULL;
 
-	context = device->ops.alloc_context(device, cmd_fd);
-	if (!context)
-		goto err;
+	if (!verbs_device) {
+		context = device->ops.alloc_context(device, cmd_fd);
+		if (!context)
+			goto err;
+	} else {
+		/* Library now allocates the context */
+		context_ex = calloc(1, sizeof(*context_ex) +
+				       verbs_device->size_of_context);
+		if (!context_ex) {
+			errno = ENOMEM;
+			goto err;
+		}
+
+		context_ex->context.abi_compat  = ((uint8_t *) NULL) - 1;
+		context_ex->sz = sizeof(*context_ex);
+
+		context = &context_ex->context;
+		ret = verbs_device->init_context(verbs_device, context, cmd_fd);
+		if (ret)
+			goto verbs_err;
+
+		/* initialize *all* library ops to either lib calls or
+		 * directly to provider calls.
+		 * context_ex->lib_new_func1 = __verbs_new_func1;
+		 * context_ex->lib_new_func2 = __verbs_new_func2;
+		 */
+	}
 
 	context->device = device;
 	context->cmd_fd = cmd_fd;
@@ -151,9 +177,10 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 
 	return context;
 
+verbs_err:
+	free(context_ex);
 err:
 	close(cmd_fd);
-
 	return NULL;
 }
 default_symver(__ibv_open_device, ibv_open_device);
@@ -163,14 +190,15 @@ int __ibv_close_device(struct ibv_context *context)
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
+		struct verbs_device *verbs_device = verbs_get_device(context->device);
+		verbs_device->uninit_context(verbs_device, context);
+		free(context_ex);
+	} else
+		context->device->ops.free_context(context);
 
 	close(async_fd);
 	close(cmd_fd);
diff --git a/src/init.c b/src/init.c
index 8d6786e..d6cd84a 100644
--- a/src/init.c
+++ b/src/init.c
@@ -70,6 +70,7 @@ struct ibv_driver_name {
 struct ibv_driver {
 	const char	       *name;
 	ibv_driver_init_func	init_func;
+	verbs_driver_init_func	verbs_init_func;
 	struct ibv_driver      *next;
 };
 
@@ -153,7 +154,8 @@ static int find_sysfs_devs(void)
 	return ret;
 }
 
-void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+static void register_driver(const char *name, ibv_driver_init_func init_func,
+			    verbs_driver_init_func verbs_init_func)
 {
 	struct ibv_driver *driver;
 
@@ -163,9 +165,10 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 		return;
 	}
 
-	driver->name      = name;
-	driver->init_func = init_func;
-	driver->next      = NULL;
+	driver->name      	= name;
+	driver->init_func	= init_func;
+	driver->verbs_init_func = verbs_init_func;
+	driver->next      	= NULL;
 
 	if (tail_driver)
 		tail_driver->next = driver;
@@ -174,6 +177,19 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 	tail_driver = driver;
 }
 
+void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+{
+	register_driver(name, init_func, NULL);
+}
+
+/* New registration symbol with same functionality - used by providers to
+  * validate that library supports verbs extension.
+  */
+void verbs_register_driver(const char *name, verbs_driver_init_func init_func)
+{
+	register_driver(name, NULL, init_func);
+}
+
 static void load_driver(const char *name)
 {
 	char *so_name;
@@ -333,12 +349,23 @@ out:
 static struct ibv_device *try_driver(struct ibv_driver *driver,
 				     struct ibv_sysfs_dev *sysfs_dev)
 {
+	struct verbs_device *vdev;
 	struct ibv_device *dev;
 	char value[8];
 
-	dev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-	if (!dev)
-		return NULL;
+	if (driver->init_func) {
+		dev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+		if (!dev)
+			return NULL;
+	} else {
+		vdev = driver->verbs_init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+		if (!vdev)
+			return NULL;
+
+		dev = &vdev->device;
+		dev->ops.alloc_context = NULL;
+		dev->ops.free_context = NULL;
+	}
 
 	if (ibv_read_sysfs_file(sysfs_dev->ibdev_path, "node_type", value, sizeof value) < 0) {
 		fprintf(stderr, PFX "Warning: no node_type attr under %s.\n",
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
