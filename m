From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: allow HCAs to create IB port sysfs files
Date: Thu, 8 Apr 2010 16:36:26 -0700
Message-ID: <1270769786.2278.38.camel@chromite.mv.qlogic.com>
References: <1258486848.992.407.camel@chromite.mv.qlogic.com>
	 <adamxxdwtys.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxxdwtys.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-04-08 at 13:49 -0700, Roland Dreier wrote:
> Rather than have the device driver call a new function that then calls
> it back, how about if we just add a parameter to the
> ib_register_device() call that is the callback to add the sysfs stuff?
> This would let us avoid the race where the device is registered but not
> all the sysfs stuff is created yet.
> 
>  - R.

I'm not sure this is any less of a race than what I proposed
or the calls to device_create_file() that most IB device drivers
make after calling ib_register_device().

Is the following what you would like to see?
Note that all the hw/*/ drivers have to be changed to call
ib_register_device() with the new parameter.


diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 05ac36e..e70c809 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,7 +38,7 @@
 
 #include <rdma/ib_verbs.h>
 
-int  ib_device_register_sysfs(struct ib_device *device);
+int  ib_device_register_sysfs(struct ib_device *device, sysfs_cb cb);
 void ib_device_unregister_sysfs(struct ib_device *device);
 
 int  ib_sysfs_setup(void);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d1fba41..9ef8093 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -267,7 +267,7 @@ out:
  * callback for each device that is added. @device must be allocated
  * with ib_alloc_device().
  */
-int ib_register_device(struct ib_device *device)
+int ib_register_device(struct ib_device *device, sysfs_cb cb)
 {
 	int ret;
 
@@ -296,7 +296,7 @@ int ib_register_device(struct ib_device *device)
 		goto out;
 	}
 
-	ret = ib_device_register_sysfs(device);
+	ret = ib_device_register_sysfs(device, cb);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
 		       device->name);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index f901957..a47bac8 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -754,7 +754,23 @@ static struct attribute_group iw_stats_group = {
 	.attrs	= iw_proto_stats_attrs,
 };
 
-int ib_device_register_sysfs(struct ib_device *device)
+static int sysfs_create_port_files(struct ib_device *device, sysfs_cb cb)
+{
+	struct kobject *p;
+	struct ib_port *port;
+	int ret = 0;
+
+	list_for_each_entry(p, &device->port_list, entry) {
+		port = container_of(p, struct ib_port, kobj);
+		ret = cb(device, port->port_num, &port->kobj);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+int ib_device_register_sysfs(struct ib_device *device, sysfs_cb cb)
 {
 	struct device *class_dev = &device->dev;
 	int ret;
@@ -802,6 +818,12 @@ int ib_device_register_sysfs(struct ib_device *device)
 			goto err_put;
 	}
 
+	if (cb) {
+		ret = sysfs_create_port_files(device, cb);
+		if (ret)
+			goto err_put;
+	}
+
 	return 0;
 
 err_put:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6ecd85c..4e446e4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1189,7 +1189,10 @@ struct ib_client {
 struct ib_device *ib_alloc_device(size_t size);
 void ib_dealloc_device(struct ib_device *device);
 
-int ib_register_device   (struct ib_device *device);
+typedef int (*sysfs_cb)(struct ib_device *dev, u8 port_num,
+			struct kobject *kobj);
+
+int ib_register_device   (struct ib_device *device, sysfs_cb cb);
 void ib_unregister_device(struct ib_device *device);
 
 int ib_register_client   (struct ib_client *client);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
