From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/core: Save the device attributes on the device structure
Date: Thu, 17 Dec 2015 15:18:55 +0200
Message-ID: <1450358340-19361-2-git-send-email-ogerlitz@mellanox.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450358340-19361-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This way both the IB core and upper level drivers can access these cached
device attributes rather than querying or caching them on their own.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 6 ++++++
 include/rdma/ib_verbs.h          | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 179e813..398353b 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -352,6 +352,12 @@ int ib_register_device(struct ib_device *device,
 		goto out;
 	}
 
+	ret = ib_query_device(device, &device->attrs);
+	if (ret) {
+		printk(KERN_WARNING "Couldn't query the device attributes\n");
+		goto out;
+	}
+
 	ret = ib_device_register_sysfs(device, port_callback);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't register device %s with driver model\n",
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d56b39a..75a22533 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1828,6 +1828,7 @@ struct ib_device {
 	u16                          is_switch:1;
 	u8                           node_type;
 	u8                           phys_port_cnt;
+	struct ib_device_attr        attrs;
 
 	/**
 	 * The following mandatory functions are used only at device
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
