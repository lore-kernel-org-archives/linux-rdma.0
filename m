From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] IB/core: Fix missed clean call in registration path
Date: Sun, 21 Feb 2016 18:12:26 +0200
Message-ID: <1456071146-28101-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In case of failure returned from query function in
IB device registration, we need to clean IB cache which
was missed.

This change fixes it.

Fixes: 3e153a93a1c1 ('IB/core: Save the device attributes on the device
structure')
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 00da80e..94b80a5 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -358,6 +358,7 @@ int ib_register_device(struct ib_device *device,
 	ret = device->query_device(device, &device->attrs, &uhw);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't query the device attributes\n");
+		ib_cache_cleanup_one(device);
 		goto out;
 	}
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
