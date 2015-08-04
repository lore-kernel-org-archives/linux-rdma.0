From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Tue, 4 Aug 2015 15:23:34 -0600
Message-ID: <20150804212334.GB10934@obsidianresearch.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-3-git-send-email-matanb@mellanox.com>
 <20150804031038.GA27627@obsidianresearch.com>
 <CAAKD3BBESq61-UJJvqm=ni5vrtu8yuNJvC57mWwCpehQSd1k4A@mail.gmail.com>
 <20150804164650.GA3858@obsidianresearch.com>
 <CAAKD3BDDKcyA0xitGpuMkKsr6=9onxFgdVXHE3n-zb=xjX4Uhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDDKcyA0xitGpuMkKsr6=9onxFgdVXHE3n-zb=xjX4Uhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 09:55:03PM +0300, Matan Barak wrote:

> If it fails in ib_device_register_sysfs, the device release function
> isn't called and the device pointer isn't freed.

Ugh, yes, the abuse in ib_dealloc_device needs to go too.

Attached is a compile tested patch that fixes that up. Feel free to
fix it up as necessary. It should be sequenced before your 'Add RoCE
GID table management'.. It would probably be helpful for doug to
resend that one patch adjusted.

> If ib_cache_setup_one fails, we call ib_device_unregister_sysfs and
> the memory will be freed.

?? ib_device_unregister_sysfs doesn't free memory..

At the driver the sequence should be:
 ib_alloc_device
 ib_register_device
 ib_unregister_device
 ib_dealloc_device

The issue I'm looking (which I suspected before, but just went and
confirmed) at is that sysfs's show_port_gid calls ib_query_gid which
your series now makes use the cache, so sysfs should ideally be shut
off before the cache stuff.

.. and we must setup the cache before setting up sysfs, otherwise
there is a race where userspace can trigger a cache call before
setup.. (null deref?)

> ib_device_unregister_sysfs (otherwise I'll have use-after-free).
> What do you think?

I'm still not sure what you are seeing..

You might also want the cache code to have an entry from
ib_alloc_device to setup locks and other no-fail initalization
things. AFIAK there isn't a strong reason to do this other than to
keep with the basic idiom.

Jason

>From 32bafdef61a9e571ef1457f7f1966a7372d1b8d7 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 4 Aug 2015 15:11:41 -0600
Subject: [PATCH] IB/core: Make ib_alloc_device initialize the kobject

This gets rid of the weird in-between state where struct ib_device
was allocated but the kobject didn't work.

Consequently ib_device_release is now guaranteed to be called in
all situations and we can't duplicate its kfrees on error paths.
Choose to just drop kfree(port_immutable)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  3 --
 drivers/infiniband/core/device.c    | 92 ++++++++++++++++++++++++-------------
 drivers/infiniband/core/sysfs.c     | 51 ++------------------
 3 files changed, 65 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 87d1936f5c1c..950583a62e3b 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -43,9 +43,6 @@ int  ib_device_register_sysfs(struct ib_device *device,
 						   u8, struct kobject *));
 void ib_device_unregister_sysfs(struct ib_device *device);
 
-int  ib_sysfs_setup(void);
-void ib_sysfs_cleanup(void);
-
 int  ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 9567756ca4f9..0a2c28610026 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -152,6 +152,35 @@ static int alloc_name(char *name)
 	return 0;
 }
 
+static void ib_device_release(struct device *device)
+{
+	struct ib_device *dev = container_of(device, struct ib_device, dev);
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
@@ -164,9 +193,27 @@ static int alloc_name(char *name)
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
+
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
 
-	return kzalloc(size, GFP_KERNEL);
+	return device;
 }
 EXPORT_SYMBOL(ib_alloc_device);
 
@@ -178,13 +225,8 @@ EXPORT_SYMBOL(ib_alloc_device);
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
@@ -219,7 +261,7 @@ static int verify_immutable(const struct ib_device *dev, u8 port)
 
 static int read_port_immutable(struct ib_device *device)
 {
-	int ret = -ENOMEM;
+	int ret;
 	u8 start_port = rdma_start_port(device);
 	u8 end_port = rdma_end_port(device);
 	u8 port;
@@ -235,26 +277,18 @@ static int read_port_immutable(struct ib_device *device)
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
@@ -285,11 +319,6 @@ int ib_register_device(struct ib_device *device,
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
@@ -301,7 +330,6 @@ int ib_register_device(struct ib_device *device,
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
-		kfree(device->port_immutable);
 		goto out;
 	}
 
@@ -737,7 +765,7 @@ static int __init ib_core_init(void)
 	if (!ib_wq)
 		return -ENOMEM;
 
-	ret = ib_sysfs_setup();
+	ret = class_register(&ib_class);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create InfiniBand device class\n");
 		goto err;
@@ -761,7 +789,7 @@ err_nl:
 	ibnl_cleanup();
 
 err_sysfs:
-	ib_sysfs_cleanup();
+	class_unregister(&ib_class);
 
 err:
 	destroy_workqueue(ib_wq);
@@ -772,7 +800,7 @@ static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
 	ibnl_cleanup();
-	ib_sysfs_cleanup();
+	class_unregister(&ib_class);
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 }
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 0b84a9cdfe5b..34cdd74b0a17 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -457,29 +457,6 @@ static struct kobj_type port_type = {
 	.default_attrs = port_default_attrs
 };
 
-static void ib_device_release(struct device *device)
-{
-	struct ib_device *dev = container_of(device, struct ib_device, dev);
-
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
@@ -702,12 +679,6 @@ static struct device_attribute *ib_class_attributes[] = {
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
@@ -846,14 +817,12 @@ int ib_device_register_sysfs(struct ib_device *device,
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
 
@@ -916,13 +885,3 @@ void ib_device_unregister_sysfs(struct ib_device *device)
 
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
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
