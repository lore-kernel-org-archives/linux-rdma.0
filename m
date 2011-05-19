From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] XRC upstream merge reboot
Date: Thu, 19 May 2011 05:29:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373FDDE@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
 <20110518170226.GA2595@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373FBC7@ORSMSX101.amr.corp.intel.com>
 <BANLkTi=cLjErM3pKzihyFtGWZ0kSu9BiPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=cLjErM3pKzihyFtGWZ0kSu9BiPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

What about something along the lines of the following?  This is 2 incomplete patches squashed together, lacking any serious documentation.  I believe this will support existing apps and driver libraries, as either binary or re-compiling unmodified source code.

A driver library calls ibv_register_driver_ext() if it implements the extended operations.  (Roland, you mentioned changing the ibv_register_driver init_func parameter, but I didn't follow your thought.)  Extended ops are defined at both the ibv_device and ibv_context levels.  An app may also query a device to see if it supports a specific extension.

There is an assumption that extension names reflect the availability of the extension.  For example, there may be "ibv_foo", "ofed_foo", or "mlx_foo" APIs.  The "ibv" extensions would be those defined by the libibverbs package.


---
 include/infiniband/verbs.h |   32 ++++++++++++++++++++++++++++++++
 src/device.c               |   18 ++++++++++++++++++
 src/init.c                 |   12 +++++++++++-
 src/libibverbs.map         |    5 +++++
 src/verbs.c                |    9 +++++++++
 5 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..fad875f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -617,12 +617,19 @@ struct ibv_device {
 	enum ibv_transport_type	transport_type;
 	/* Name of underlying kernel IB device, eg "mthca0" */
 	char			name[IBV_SYSFS_NAME_MAX];
+	/*
+	 * Support for extended operations is recorded at the end of
+	 * the name character array.
+	 */
+#define ext_ops_supported	name[IBV_SYSFS_NAME_MAX - 1]
 	/* Name of uverbs device, eg "uverbs0" */
 	char			dev_name[IBV_SYSFS_NAME_MAX];
 	/* Path to infiniband_verbs class device in sysfs */
 	char			dev_path[IBV_SYSFS_PATH_MAX];
 	/* Path to infiniband class device in sysfs */
 	char			ibdev_path[IBV_SYSFS_PATH_MAX];
+	int			(*have_ext_ops)(char *ext_name);
+	void *			(*get_ext_device_ops)(char *ext_name);
 };
 
 struct ibv_context_ops {
@@ -683,6 +690,14 @@ struct ibv_context_ops {
 	void			(*async_event)(struct ibv_async_event *event);
 };
 
+#define IBV_XRC_OPS "ibv_xrc"
+
+struct ibv_xrc_ops {
+	struct ibv_xrcd		(*open_xrcd)();
+	int			(*close_xrcd)();
+	struct ibv_src		(*create_srq)();
+};
+
 struct ibv_context {
 	struct ibv_device      *device;
 	struct ibv_context_ops	ops;
@@ -691,6 +706,7 @@ struct ibv_context {
 	int			num_comp_vectors;
 	pthread_mutex_t		mutex;
 	void		       *abi_compat;
+	void *			(*get_ext_ops)(char *ext_name);
 };
 
 /**
@@ -724,6 +740,17 @@ const char *ibv_get_device_name(struct ibv_device *device);
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
@@ -734,6 +761,11 @@ struct ibv_context *ibv_open_device(struct ibv_device *device);
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
index 185f4a6..da0eca4 100644
--- a/src/device.c
+++ b/src/device.c
@@ -181,6 +181,24 @@ int __ibv_close_device(struct ibv_context *context)
 }
 default_symver(__ibv_close_device, ibv_close_device);
 
+int __ibv_have_ext_ops(struct ibv_device *device, const char *name)
+{
+	if (!device->ext_ops_supported)
+		return ENOSYS;
+
+	return device->have_ext_ops(device, name);
+}
+default_symver(__ibv_have_ext_ops, ibv_have_ext_ops);
+
+void *__ibv_get_device_ext_ops(struct ibv_device *device, const char *name)
+{
+	if (!device->ext_ops_supported)
+		return NULL;
+
+	return device->get_device_ext_ops(device, name);
+}
+default_symver(__ibv_get_device_ext_ops, ibv_get_device_ext_ops);
+
 int __ibv_get_async_event(struct ibv_context *context,
 			  struct ibv_async_event *event)
 {
diff --git a/src/init.c b/src/init.c
index 4f0130e..0fdc89c 100644
--- a/src/init.c
+++ b/src/init.c
@@ -71,6 +71,7 @@ struct ibv_driver {
 	const char	       *name;
 	ibv_driver_init_func	init_func;
 	struct ibv_driver      *next;
+	int			ext_ops_supported;
 };
 
 static struct ibv_sysfs_dev *sysfs_dev_list;
@@ -153,7 +154,8 @@ static int find_sysfs_devs(void)
 	return ret;
 }
 
-void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+void ibv_register_driver_ext(const char *name, ibv_driver_init_func init_func,
+			     int ext_ops_supported)
 {
 	struct ibv_driver *driver;
 
@@ -174,6 +176,11 @@ void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
 	tail_driver = driver;
 }
 
+void ibv_register_driver(const char *name, ibv_driver_init_func init_func)
+{
+	ibv_register_driver_ext(name, init_func, 0);
+}
+
 static void load_driver(const char *name)
 {
 	char *so_name;
@@ -368,6 +375,9 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	strcpy(dev->name,       sysfs_dev->ibdev_name);
 	strcpy(dev->ibdev_path, sysfs_dev->ibdev_path);
 
+	if (strlen(dev->name) < sizeof(dev->name))
+		dev->ext_ops_supported = driver->ext_ops_supported;
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
index ba3c0a4..0be9ac2 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -76,6 +76,15 @@ enum ibv_rate mult_to_ibv_rate(int mult)
 	}
 }
 
+void *__ibv_get_ext_ops(struct ibv_context *context, const char *name)
+{
+	if (!context->device->ext_ops_supported)
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
