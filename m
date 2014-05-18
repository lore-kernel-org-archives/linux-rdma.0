From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/core: fix kobject leak on device register error flow
Date: Sun, 18 May 2014 11:12:26 +0300
Message-ID: <1400400746-9030-4-git-send-email-haggaie@mellanox.com>
References: <1400400746-9030-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400400746-9030-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ports kobject isn't being released when during error flow in device
registration. The patch refactors the ports kobject cleanup into a single
function called from both the error flow in device registration and from the
unregistration function.

A couple of attributes aren't being deleted (iw_stats_group, and
ib_class_attributes). While this may be handled implicitly by the destruction
of their kobjects, it seems better to handle all the attributes the same way.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 52 ++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 68fa798..d63b2c3 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -816,6 +816,22 @@ static struct attribute_group iw_stats_group = {
 	.attrs	= iw_proto_stats_attrs,
 };
 
+void free_port_list_attributes(struct ib_device *device)
+{
+	struct kobject *p, *t;
+
+	list_for_each_entry_safe(p, t, &device->port_list, entry) {
+		struct ib_port *port = container_of(p, struct ib_port, kobj);
+		list_del(&p->entry);
+		sysfs_remove_group(p, &pma_group);
+		sysfs_remove_group(p, &port->pkey_group);
+		sysfs_remove_group(p, &port->gid_group);
+		kobject_put(p);
+	}
+
+	kobject_put(device->ports_parent);
+}
+
 int ib_device_register_sysfs(struct ib_device *device,
 			     int (*port_callback)(struct ib_device *,
 						  u8, struct kobject *))
@@ -869,19 +885,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 	return 0;
 
 err_put:
-	{
-		struct kobject *p, *t;
-		struct ib_port *port;
-
-		list_for_each_entry_safe(p, t, &device->port_list, entry) {
-			list_del(&p->entry);
-			port = container_of(p, struct ib_port, kobj);
-			sysfs_remove_group(p, &pma_group);
-			sysfs_remove_group(p, &port->pkey_group);
-			sysfs_remove_group(p, &port->gid_group);
-			kobject_put(p);
-		}
-	}
+	free_port_list_attributes(device);
 
 err_unregister:
 	device_unregister(class_dev);
@@ -892,22 +896,18 @@ err:
 
 void ib_device_unregister_sysfs(struct ib_device *device)
 {
-	struct kobject *p, *t;
-	struct ib_port *port;
-
 	/* Hold kobject until ib_dealloc_device() */
-	kobject_get(&device->dev.kobj);
+	struct kobject *kobj_dev = kobject_get(&device->dev.kobj);
+	int i;
 
-	list_for_each_entry_safe(p, t, &device->port_list, entry) {
-		list_del(&p->entry);
-		port = container_of(p, struct ib_port, kobj);
-		sysfs_remove_group(p, &pma_group);
-		sysfs_remove_group(p, &port->pkey_group);
-		sysfs_remove_group(p, &port->gid_group);
-		kobject_put(p);
-	}
+	if (device->node_type == RDMA_NODE_RNIC && device->get_protocol_stats)
+		sysfs_remove_group(kobj_dev, &iw_stats_group);
+
+	free_port_list_attributes(device);
+
+	for (i = 0; i < ARRAY_SIZE(ib_class_attributes); ++i)
+		device_remove_file(&device->dev, ib_class_attributes[i]);
 
-	kobject_put(device->ports_parent);
 	device_unregister(&device->dev);
 }
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
