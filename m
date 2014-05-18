From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/core: remove unneeded kobject_get/put calls
Date: Sun, 18 May 2014 11:12:24 +0300
Message-ID: <1400400746-9030-2-git-send-email-haggaie@mellanox.com>
References: <1400400746-9030-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400400746-9030-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ib_core module will call kobject_get on the parent object of each kobject
it creates. This is redundant since kobject_add does that anyway.

As a side effect, this patch should fix leaking the ports kobject and the
device kobject during unregister flow, since the previous code didn't seem to
take into account the kobject_get calls on behalf of the children kobjects.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 7d3292c..1f77072 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -534,7 +534,7 @@ static int add_port(struct ib_device *device, int port_num,
 	p->port_num   = port_num;
 
 	ret = kobject_init_and_add(&p->kobj, &port_type,
-				   kobject_get(device->ports_parent),
+				   device->ports_parent,
 				   "%d", port_num);
 	if (ret)
 		goto err_put;
@@ -599,7 +599,6 @@ err_remove_pma:
 	sysfs_remove_group(&p->kobj, &pma_group);
 
 err_put:
-	kobject_put(device->ports_parent);
 	kfree(p);
 	return ret;
 }
@@ -835,7 +834,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 	}
 
 	device->ports_parent = kobject_create_and_add("ports",
-					kobject_get(&class_dev->kobj));
+						      &class_dev->kobj);
 	if (!device->ports_parent) {
 		ret = -ENOMEM;
 		goto err_put;
@@ -876,8 +875,6 @@ err_put:
 		}
 	}
 
-	kobject_put(&class_dev->kobj);
-
 err_unregister:
 	device_unregister(class_dev);
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
