From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/vmw_pvrdma: Update the driver name to vmw_pvrdma
Date: Mon, 12 Dec 2016 11:52:42 -0800
Message-ID: <1481572362-19727-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch got left out of the pvrdma->vmw_pvrdma series I sent out
before. Sorry about that.

Thanks,
Adit
---

Show the right driver name with the renamed module.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 5510c86..231a1ce 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -55,7 +55,7 @@
 
 #include "pvrdma.h"
 
-#define DRV_NAME	"pvrdma"
+#define DRV_NAME	"vmw_pvrdma"
 #define DRV_VERSION	"1.0.0.0-k"
 
 static DEFINE_MUTEX(pvrdma_device_list_lock);
@@ -77,7 +77,7 @@ static int pvrdma_del_gid(struct ib_device *ibdev,
 static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
-	return sprintf(buf, "PVRDMA-%s\n", DRV_VERSION);
+	return sprintf(buf, "VMW_PVRDMA-%s\n", DRV_VERSION);
 }
 
 static ssize_t show_rev(struct device *device, struct device_attribute *attr,
@@ -166,7 +166,7 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
 	int ret = -1;
 	int i = 0;
 
-	strlcpy(dev->ib_dev.name, "pvrdma%d", IB_DEVICE_NAME_MAX);
+	strlcpy(dev->ib_dev.name, "vmw_pvrdma%d", IB_DEVICE_NAME_MAX);
 	dev->ib_dev.node_guid = dev->dsr->caps.node_guid;
 	dev->sys_image_guid = dev->dsr->caps.sys_image_guid;
 	dev->flags = 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
