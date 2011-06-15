From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Wed, 15 Jun 2011 16:54:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support OFED or vendor specific calls, define a
generic extension mechanism.  This allows OFED, an RDMA vendor,
or another registered 3rd party (for example, the librdmacm)
to define RDMA extensions.

Users which make use extensions are aware that they are not
only using an extended call, but are given information regarding
how widely the extension by be supported.  Support for extended
functions, data structures, and enums are defined.

Extensions are referenced by name.  There is an assumption that
extension names are prefixed relative to the supporting party.
Until an extension has been incorporated into libibverbs, it
should be defined in an appropriate external header file.

For example, OFA could provide a header file with their definition
for XRC extensions.  A partial view of such a header file might
look something similar to:

#ifndef OFA_XRC_H
#define OFA_XRC_H
#include <infiniband/verbs.h>

#define OFA_XRC_OPS "ofa-xrc"

/* Extend IBV_QP_TYPE for XRC */
#define OFA_QPT_XRC ((enum ibv_qp_type) \
	(IBV_EXTENSION_OFA << IBV_EXTENSION_BASE_SHIFT) + 6)

struct ofa_xrcd {
	struct ibv_context *context;
};

struct ofa_xrc_ops {
	struct ofa_xrcd * (*open_xrcd)(struct ibv_context *context,
					inf fd, int oflags);
	int		* (*close_xrcd)(struct ofa_xrcd *xrcd);
	/* other functions left as exercise to the reader */
};

#endif /* OFA_XRC_H */

Driver libraries that support extensions are given a new
registration call, ibv_register_device_ext().  Use of this call
indicates to libibverbs that the library allocates extended
versions of struct ibv_device and struct ibv_context.

The following new APIs are added to libibverbs to applications
to use to determine if an extension is supported and to obtain the
extended function calls.

ibv_have_ext_ops - returns true if an extension is supported
ibv_get_device_ext_ops - return extended operations for a device
ibv_get_ext_ops - return extended operations for an open context

To maintain backwards compatibility with existing applications,
internally, the library uses the last byte of the device name
to record if the device was registered with extension support.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/driver.h |    1 +
 include/infiniband/verbs.h  |   40 +++++++++++++++++++++++++++++++++++++++-
 src/device.c                |   18 ++++++++++++++++++
 src/ibverbs.h               |   18 ++++++++++++++++++
 src/init.c                  |   17 ++++++++++++++++-
 src/libibverbs.map          |    5 +++++
 src/verbs.c                 |    9 +++++++++
 7 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 9a81416..e48abfd 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -57,6 +57,7 @@ typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
 						   int abi_version);
 
 void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
+void ibv_register_driver_ext(const char *name, ibv_driver_init_func init_func);
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
 			size_t resp_size);
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..b82cd3a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -55,6 +55,15 @@
 
 BEGIN_C_DECLS
 
+enum ibv_extension_type {
+	IBV_EXTENSION_COMMON,
+	IBV_EXTENSION_VENDOR,
+	IBV_EXTENSION_OFA,
+	IBV_EXTENSION_RDMA_CM
+};
+#define IBV_EXTENSION_BASE_SHIFT 24
+#define IBV_EXTENSION_MASK 0xFF000000
+
 union ibv_gid {
 	uint8_t			raw[16];
 	struct {
@@ -92,7 +101,8 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_SYS_IMAGE_GUID	= 1 << 11,
 	IBV_DEVICE_RC_RNR_NAK_GEN	= 1 << 12,
 	IBV_DEVICE_SRQ_RESIZE		= 1 << 13,
-	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14
+	IBV_DEVICE_N_NOTIFY_CQ		= 1 << 14,
+	IBV_DEVICE_EXTENSIONS		= 1 << (IBV_EXTENSION_BASE_SHIFT - 1)
 };
 
 enum ibv_atomic_cap {
@@ -623,6 +633,13 @@ struct ibv_device {
 	char			dev_path[IBV_SYSFS_PATH_MAX];
 	/* Path to infiniband class device in sysfs */
 	char			ibdev_path[IBV_SYSFS_PATH_MAX];
+
+	/* Following fields only available if device supports extensions */
+	void		       *private;
+	int			(*have_ext_ops)(struct ibv_device *device,
+						const char *ext_name);
+	void *			(*get_device_ext_ops)(struct ibv_device *device,
+						      const char *ext_name);
 };
 
 struct ibv_context_ops {
@@ -691,6 +708,11 @@ struct ibv_context {
 	int			num_comp_vectors;
 	pthread_mutex_t		mutex;
 	void		       *abi_compat;
+
+	/* Following fields only available if device supports extensions */
+	void		       *private;
+	void *			(*get_ext_ops)(struct ibv_context *context,
+					       const char *ext_name);
 };
 
 /**
@@ -724,6 +746,17 @@ const char *ibv_get_device_name(struct ibv_device *device);
 uint64_t ibv_get_device_guid(struct ibv_device *device);
 
 /**
+ * ibv_have_ext_ops - Return true if device supports the requested
+ * extended operations.
+ */
+int ibv_have_ext_ops(struct ibv_device *device, const char *name);
+
+/**
+ * ibv_get_device_ext_ops - Return extended operations.
+ */
+void *ibv_get_device_ext_ops(struct ibv_device *device, const char *name);
+
+/**
  * ibv_open_device - Initialize device for use
  */
 struct ibv_context *ibv_open_device(struct ibv_device *device);
@@ -734,6 +767,11 @@ struct ibv_context *ibv_open_device(struct ibv_device *device);
 int ibv_close_device(struct ibv_context *context);
 
 /**
+ * ibv_get_ext_ops - Return extended operations.
+ */
+void *ibv_get_ext_ops(struct ibv_context *context, const char *name);
+
+/**
  * ibv_get_async_event - Get next async event
  * @event: Pointer to use to return async event
  *
diff --git a/src/device.c b/src/device.c
index 185f4a6..78d9d35 100644
--- a/src/device.c
+++ b/src/device.c
@@ -181,6 +181,24 @@ int __ibv_close_device(struct ibv_context *context)
 }
 default_symver(__ibv_close_device, ibv_close_device);
 
+int __ibv_have_ext_ops(struct ibv_device *device, const char *name)
+{
+	if (!ibv_get_ext_support(device))
+		return ENOSYS;
+
+	return device->have_ext_ops(device, name);
+}
+default_symver(__ibv_have_ext_ops, ibv_have_ext_ops);
+
+void *__ibv_get_device_ext_ops(struct ibv_device *device, const char *name)
+{
+	if (!ibv_get_ext_support(device) || !device->get_device_ext_ops)
+		return NULL;
+
+	return device->get_device_ext_ops(device, name);
+}
+default_symver(__ibv_get_device_ext_ops, ibv_get_device_ext_ops);
+
 int __ibv_get_async_event(struct ibv_context *context,
 			  struct ibv_async_event *event)
 {
diff --git a/src/ibverbs.h b/src/ibverbs.h
index 6a6e3c8..33bdee2 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -35,6 +35,7 @@
 #define IB_VERBS_H
 
 #include <pthread.h>
+#include <string.h>
 
 #include <infiniband/driver.h>
 
@@ -102,4 +103,21 @@ HIDDEN int ibverbs_init(struct ibv_device ***list);
 		(cmd)->response  = (uintptr_t) (out);			\
 	} while (0)
 
+/*
+ * Support for extended operations is recorded at the end of
+ * the name character array.  This way we don't need to query
+ * for the device capabilities with every call.
+ */
+static inline int ibv_get_ext_support(struct ibv_device *device)
+{
+	return device->name[IBV_SYSFS_NAME_MAX - 1];
+}
+
+static inline void ibv_set_ext_support(struct ibv_device *device,
+				       int ext_supported)
+{
+	if (strlen(device->name) < IBV_SYSFS_NAME_MAX - 1)
+		device->name[IBV_SYSFS_NAME_MAX - 1] = (char) ext_supported;
+}
+
 #endif /* IB_VERBS_H */
diff --git a/src/init.c b/src/init.c
index 4f0130e..419ab31 100644
--- a/src/init.c
+++ b/src/init.c
@@ -71,6 +71,7 @@ struct ibv_driver {
 	const char	       *name;
 	ibv_driver_init_func	init_func;
 	struct ibv_driver      *next;
+	int			ext_support;
 };
 
 static struct ibv_sysfs_dev *sysfs_dev_list;
@@ -153,7 +154,8 @@ static int find_sysfs_devs(void)
 	return ret;
 }
 
-void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+static void __ibv_register_driver(const char *name, ibv_driver_init_func init_func,
+				  int ext_support)
 {
 	struct ibv_driver *driver;
 
@@ -166,6 +168,7 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 	driver->name      = name;
 	driver->init_func = init_func;
 	driver->next      = NULL;
+	driver->ext_support = ext_support;
 
 	if (tail_driver)
 		tail_driver->next = driver;
@@ -174,6 +177,16 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 	tail_driver = driver;
 }
 
+void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+{
+	__ibv_register_driver(name, init_func, 0);
+}
+
+void ibv_register_driver_ext(const char *name, ibv_driver_init_func init_func)
+{
+	__ibv_register_driver(name, init_func, 1);
+}
+
 static void load_driver(const char *name)
 {
 	char *so_name;
@@ -368,6 +381,8 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	strcpy(dev->name,       sysfs_dev->ibdev_name);
 	strcpy(dev->ibdev_path, sysfs_dev->ibdev_path);
 
+	ibv_set_ext_support(dev, driver->ext_support);
+
 	return dev;
 }
 
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..422e07f 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -96,4 +96,9 @@ IBVERBS_1.1 {
 		ibv_port_state_str;
 		ibv_event_type_str;
 		ibv_wc_status_str;
+
+		ibv_register_driver_ext;
+		ibv_have_ext_ops;
+		ibv_get_device_ext_ops;
+		ibv_get_ext_ops;
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..a34a784 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -76,6 +76,15 @@ enum ibv_rate mult_to_ibv_rate(int mult)
 	}
 }
 
+void *__ibv_get_ext_ops(struct ibv_context *context, const char *name)
+{
+	if (!ibv_get_ext_support(context->device) || !context->get_ext_ops)
+		return NULL;
+
+	return context->get_ext_ops(context, name);
+}
+default_symver(__ibv_get_ext_ops, ibv_get_ext_ops);
+
 int __ibv_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *device_attr)
 {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
