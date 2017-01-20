From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 13/37] IB/core: Initialize ib_device.dev.parent earlier
Date: Fri, 20 Jan 2017 13:04:13 -0800
Message-ID: <20170120210437.26389-14-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the ib_device.dev.parent initialization code from
ib_device_register_sysfs() to ib_register_device(). Additionally,
allow HBA drivers to set ib_device.dev.parent without setting
ib_device.dma_device. This is the first step towards removing
ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/device.c | 8 ++++++++
 drivers/infiniband/core/sysfs.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 571974cd3919..d543c4390447 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -334,6 +334,14 @@ int ib_register_device(struct ib_device *device,
 	struct ib_client *client;
 	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
 
+	WARN_ON_ONCE(!device->dev.parent && !device->dma_device);
+	WARN_ON_ONCE(device->dev.parent && device->dma_device
+		     && device->dev.parent != device->dma_device);
+	if (!device->dev.parent)
+		device->dev.parent = device->dma_device;
+	if (!device->dma_device)
+		device->dma_device = device->dev.parent;
+
 	mutex_lock(&device_mutex);
 
 	if (strchr(device->name, '%')) {
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c1fb545e8d78..daadf3130c9f 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1258,7 +1258,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 	int ret;
 	int i;
 
-	device->dev.parent = device->dma_device;
+	WARN_ON_ONCE(!device->dev.parent);
 	ret = dev_set_name(class_dev, "%s", device->name);
 	if (ret)
 		return ret;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
