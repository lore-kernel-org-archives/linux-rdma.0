From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] RDMA/vmw_pvrdma: Activate device on ethernet link up
Date: Wed, 22 Feb 2017 17:22:58 -0800
Message-ID: <c5994bdac8a3c2757269e49f17c70628f2d96c44.1487812849.git.aditr@vmware.com>
References: <cover.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Restore device state when ethernet link changes to active.

Acked-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Acked-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Acked-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
index e69d6f3..09078cc 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
@@ -132,7 +132,7 @@ enum pvrdma_pci_resource {
 
 enum pvrdma_device_ctl {
 	PVRDMA_DEVICE_CTL_ACTIVATE,	/* Activate device. */
-	PVRDMA_DEVICE_CTL_QUIESCE,	/* Quiesce device. */
+	PVRDMA_DEVICE_CTL_UNQUIESCE,	/* Unquiesce device. */
 	PVRDMA_DEVICE_CTL_RESET,	/* Reset device. */
 };
 
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 4380d3d..bc4ec3a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -56,7 +56,7 @@
 #include "pvrdma.h"
 
 #define DRV_NAME	"vmw_pvrdma"
-#define DRV_VERSION	"1.0.0.0-k"
+#define DRV_VERSION	"1.0.1.0-k"
 
 static DEFINE_MUTEX(pvrdma_device_list_lock);
 static LIST_HEAD(pvrdma_device_list);
@@ -659,7 +659,16 @@ static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
 		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
 		break;
 	case NETDEV_UP:
-		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
+		pvrdma_write_reg(dev, PVRDMA_REG_CTL,
+				 PVRDMA_DEVICE_CTL_UNQUIESCE);
+
+		mb();
+
+		if (pvrdma_read_reg(dev, PVRDMA_REG_ERR))
+			dev_err(&dev->pdev->dev,
+				"failed to activate device during link up\n");
+		else
+			pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
 		break;
 	default:
 		dev_dbg(&dev->pdev->dev, "ignore netdevice event %ld on %s\n",
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
