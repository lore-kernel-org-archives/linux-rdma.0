From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 3/4] IB/core: Make ib_alloc_device initialize the kobject
Date: Thu,  6 Aug 2015 20:13:59 +0300
Message-ID: <1438881240-22790-4-git-send-email-matanb@mellanox.com>
References: <1438881240-22790-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438881240-22790-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

This gets rid of the weird in-between state where struct ib_device
was allocated but the kobject didn't work.

Consequently ib_device_release is now guaranteed to be called in
all situations and we can't duplicate its kfrees on error paths.
Choose to just drop kfree(port_immutable)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  3 --
 drivers/infiniband/core/device.c    | 92 ++++++++++++++++++++++++-------------
 drivers/infiniband/core/sysfs.c     | 52 ++-------------------
 3 files changed, 65 insertions(+), 82 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 210ddd2..6c4880e 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -43,9 +43,6 @@ int  ib_device_register_sysfs(struct ib_device *device,
 						   u8, struct kobject *));
 void ib_device_unregister_sysfs(struct ib_device *device);
 
-int  ib_sysfs_setup(void);
-void ib_sysfs_cleanup(void);
-
 void  ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 14ea709..25c9301 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -161,6 +161,35 @@ static int alloc_name(char *name)
 	return 0;
 }
 
+static void ib_device_release(struct device *device)
+{
+	struct ib_device *dev = dev_get_drvdata(device);
+
+	kfree(dev->port_immutable);
+	kfree(dev);
+}
+
+static int ib_device_uevent(struct device *device,
+			    struct kobj_uevent_env *env)
+{
+	struct ib_device *dev = container_of(device, struct ib_device, dev);
+
+	if (add_uevent_var(env, "NAME=%s", dev->name))
+		return -ENOMEM;
+
+	/*
+	 * It would be nice to pass the node GUID with the event...
+	 */
+
+	return 0;
+}
+
+static struct class ib_class = {
+	.name    = "infiniband",
+	.dev_release = ib_device_release,
+	.dev_uevent = ib_device_uevent,
+};
+
 /**
  * ib_alloc_device - allocate an IB device struct
  * @size:size of structure to allocate
@@ -173,9 +202,27 @@ static int alloc_name(char *name)
  */
 struct ib_device *ib_alloc_device(size_t size)
 {
-	BUG_ON(size < sizeof (struct ib_device));
+	struct ib_device *device;
+
+	if (WARN_ON(size < sizeof(struct ib_device)))
+		return NULL;
+
+	device = kzalloc(size, GFP_KERNEL);
+	if (!device)
+		return NULL;
 
-	return kzalloc(size, GFP_KERNEL);
+	device->dev.class = &ib_class;
+	device_initialize(&device->dev);
+
+	dev_set_drvdata(&device->dev, device);
+
+	INIT_LIST_HEAD(&device->event_handler_list);
+	spin_lock_init(&device->event_handler_lock);
+	spin_lock_init(&device->client_data_lock);
+	INIT_LIST_HEAD(&device->client_data_list);
+	INIT_LIST_HEAD(&device->port_list);
+
+	return device;
 }
 EXPORT_SYMBOL(ib_alloc_device);
 
@@ -187,13 +234,8 @@ EXPORT_SYMBOL(ib_alloc_device);
  */
 void ib_dealloc_device(struct ib_device *device)
 {
-	if (device->reg_state == IB_DEV_UNINITIALIZED) {
-		kfree(device);
-		return;
-	}
-
-	BUG_ON(device->reg_state != IB_DEV_UNREGISTERED);
-
+	WARN_ON(device->reg_state != IB_DEV_UNREGISTERED &&
+		device->reg_state != IB_DEV_UNINITIALIZED);
 	kobject_put(&device->dev.kobj);
 }
 EXPORT_SYMBOL(ib_dealloc_device);
@@ -228,7 +270,7 @@ static int verify_immutable(const struct ib_device *dev, u8 port)
 
 static int read_port_immutable(struct ib_device *device)
 {
-	int ret = -ENOMEM;
+	int ret;
 	u8 start_port = rdma_start_port(device);
 	u8 end_port = rdma_end_port(device);
 	u8 port;
@@ -244,26 +286,18 @@ static int read_port_immutable(struct ib_device *device)
 					 * (end_port + 1),
 					 GFP_KERNEL);
 	if (!device->port_immutable)
-		goto err;
+		return -ENOMEM;
 
 	for (port = start_port; port <= end_port; ++port) {
 		ret = device->get_port_immutable(device, port,
 						 &device->port_immutable[port]);
 		if (ret)
-			goto err;
+			return ret;
 
-		if (verify_immutable(device, port)) {
-			ret = -EINVAL;
-			goto err;
-		}
+		if (verify_immutable(device, port))
+			return -EINVAL;
 	}
-
-	ret = 0;
-	goto out;
-err:
-	kfree(device->port_immutable);
-out:
-	return ret;
+	return 0;
 }
 
 /**
@@ -294,11 +328,6 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
-	INIT_LIST_HEAD(&device->event_handler_list);
-	INIT_LIST_HEAD(&device->client_data_list);
-	spin_lock_init(&device->event_handler_lock);
-	spin_lock_init(&device->client_data_lock);
-
 	ret = read_port_immutable(device);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create per port immutable data %s\n",
@@ -310,7 +339,6 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
-		kfree(device->port_immutable);
 		goto out;
 	}
 
@@ -840,7 +868,7 @@ static int __init ib_core_init(void)
 	if (!ib_wq)
 		return -ENOMEM;
 
-	ret = ib_sysfs_setup();
+	ret = class_register(&ib_class);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create InfiniBand device class\n");
 		goto err;
@@ -857,7 +885,7 @@ static int __init ib_core_init(void)
 	return 0;
 
 err_sysfs:
-	ib_sysfs_cleanup();
+	class_unregister(&ib_class);
 
 err:
 	destroy_workqueue(ib_wq);
@@ -868,7 +896,7 @@ static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
 	ibnl_cleanup();
-	ib_sysfs_cleanup();
+	class_unregister(&ib_class);
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 }
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c10c6d3..34cdd74 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -457,30 +457,6 @@ static struct kobj_type port_type = {
 	.default_attrs = port_default_attrs
 };
 
-static void ib_device_release(struct device *device)
-{
-	struct ib_device *dev = container_of(device, struct ib_device, dev);
-
-	ib_cache_cleanup_one(dev);
-	kfree(dev->port_immutable);
-	kfree(dev);
-}
-
-static int ib_device_uevent(struct device *device,
-			    struct kobj_uevent_env *env)
-{
-	struct ib_device *dev = container_of(device, struct ib_device, dev);
-
-	if (add_uevent_var(env, "NAME=%s", dev->name))
-		return -ENOMEM;
-
-	/*
-	 * It would be nice to pass the node GUID with the event...
-	 */
-
-	return 0;
-}
-
 static struct attribute **
 alloc_group_attrs(ssize_t (*show)(struct ib_port *,
 				  struct port_attribute *, char *buf),
@@ -703,12 +679,6 @@ static struct device_attribute *ib_class_attributes[] = {
 	&dev_attr_node_desc
 };
 
-static struct class ib_class = {
-	.name    = "infiniband",
-	.dev_release = ib_device_release,
-	.dev_uevent = ib_device_uevent,
-};
-
 /* Show a given an attribute in the statistics group */
 static ssize_t show_protocol_stat(const struct device *device,
 			    struct device_attribute *attr, char *buf,
@@ -847,14 +817,12 @@ int ib_device_register_sysfs(struct ib_device *device,
 	int ret;
 	int i;
 
-	class_dev->class      = &ib_class;
-	class_dev->parent     = device->dma_device;
-	dev_set_name(class_dev, "%s", device->name);
-	dev_set_drvdata(class_dev, device);
-
-	INIT_LIST_HEAD(&device->port_list);
+	device->dev.parent = device->dma_device;
+	ret = dev_set_name(class_dev, "%s", device->name);
+	if (ret)
+		return ret;
 
-	ret = device_register(class_dev);
+	ret = device_add(class_dev);
 	if (ret)
 		goto err;
 
@@ -917,13 +885,3 @@ void ib_device_unregister_sysfs(struct ib_device *device)
 
 	device_unregister(&device->dev);
 }
-
-int ib_sysfs_setup(void)
-{
-	return class_register(&ib_class);
-}
-
-void ib_sysfs_cleanup(void)
-{
-	class_unregister(&ib_class);
-}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
