From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 14/37] IB/core: Use dev.parent instead of dma_device
Date: Fri, 20 Jan 2017 13:04:14 -0800
Message-ID: <20170120210437.26389-15-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/ucm.c         | 2 +-
 drivers/infiniband/core/user_mad.c    | 4 ++--
 drivers/infiniband/core/uverbs_main.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index e0a995b85a2d..cc0d51fb06e3 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1290,7 +1290,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 		goto err;
 
 	ucm_dev->dev.class = &cm_class;
-	ucm_dev->dev.parent = device->dma_device;
+	ucm_dev->dev.parent = device->dev.parent;
 	ucm_dev->dev.devt = ucm_dev->cdev.dev;
 	ucm_dev->dev.release = ib_ucm_release_dev;
 	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 249b403b43a4..aca7ff7abedc 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1188,7 +1188,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(&port->cdev, base, 1))
 		goto err_cdev;
 
-	port->dev = device_create(umad_class, device->dma_device,
+	port->dev = device_create(umad_class, device->dev.parent,
 				  port->cdev.dev, port,
 				  "umad%d", port->dev_num);
 	if (IS_ERR(port->dev))
@@ -1207,7 +1207,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	if (cdev_add(&port->sm_cdev, base, 1))
 		goto err_sm_cdev;
 
-	port->sm_dev = device_create(umad_class, device->dma_device,
+	port->sm_dev = device_create(umad_class, device->dev.parent,
 				     port->sm_cdev.dev, port,
 				     "issm%d", port->dev_num);
 	if (IS_ERR(port->sm_dev))
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b3f95d453fba..e3fb4b1af1ad 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1174,7 +1174,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (cdev_add(&uverbs_dev->cdev, base, 1))
 		goto err_cdev;
 
-	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
+	uverbs_dev->dev = device_create(uverbs_class, device->dev.parent,
 					uverbs_dev->cdev.dev, uverbs_dev,
 					"uverbs%d", uverbs_dev->devnum);
 	if (IS_ERR(uverbs_dev->dev))
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
