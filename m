From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 04/15] be2net: issue shutdown event to ocrdma driver
Date: Wed, 4 Jun 2014 14:22:35 +0530
Message-ID: <f5c84523-13e0-48c9-b2ac-bdeff2c7a638@CMEXHTCAS1.ad.emulex.com>
References: <1401871966-20408-1-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-2-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-3-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-4-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401871966-20408-4-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

In the shutdown path, when be2net calls pci_disable_msix(),
it complains (BUG_ON) that irqs requested by ocrdma driver are
still in use. This patch fixes this problem by issuing shutdown
event to ocrdma from be2net shutdown path. As part of shutdown event
processing, ocrdma driver will free-up all the resources and free irqs.
Once this completes be2net completes pci_disable_msix successfully.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/emulex/benet/be.h      |  1 +
 drivers/net/ethernet/emulex/benet/be_main.c |  1 +
 drivers/net/ethernet/emulex/benet/be_roce.c | 18 ++++++++++++++++--
 drivers/net/ethernet/emulex/benet/be_roce.h |  3 ++-
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index 97db5a7..5f610bd 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -881,5 +881,6 @@ void be_roce_dev_remove(struct be_adapter *);
  */
 void be_roce_dev_open(struct be_adapter *);
 void be_roce_dev_close(struct be_adapter *);
+void be_roce_dev_shutdown(struct be_adapter *);
 
 #endif				/* BE_H */
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a186454..cce9628 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4859,6 +4859,7 @@ static void be_shutdown(struct pci_dev *pdev)
 	if (!adapter)
 		return;
 
+	be_roce_dev_shutdown(adapter);
 	cancel_delayed_work_sync(&adapter->work);
 	cancel_delayed_work_sync(&adapter->func_recovery_work);
 
diff --git a/drivers/net/ethernet/emulex/benet/be_roce.c b/drivers/net/ethernet/emulex/benet/be_roce.c
index 5bf1660..ef4672d 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.c
+++ b/drivers/net/ethernet/emulex/benet/be_roce.c
@@ -120,7 +120,8 @@ static void _be_roce_dev_open(struct be_adapter *adapter)
 {
 	if (ocrdma_drv && adapter->ocrdma_dev &&
 	    ocrdma_drv->state_change_handler)
-		ocrdma_drv->state_change_handler(adapter->ocrdma_dev, 0);
+		ocrdma_drv->state_change_handler(adapter->ocrdma_dev,
+						 BE_DEV_UP);
 }
 
 void be_roce_dev_open(struct be_adapter *adapter)
@@ -136,7 +137,8 @@ static void _be_roce_dev_close(struct be_adapter *adapter)
 {
 	if (ocrdma_drv && adapter->ocrdma_dev &&
 	    ocrdma_drv->state_change_handler)
-		ocrdma_drv->state_change_handler(adapter->ocrdma_dev, 1);
+		ocrdma_drv->state_change_handler(adapter->ocrdma_dev,
+						 BE_DEV_DOWN);
 }
 
 void be_roce_dev_close(struct be_adapter *adapter)
@@ -148,6 +150,18 @@ void be_roce_dev_close(struct be_adapter *adapter)
 	}
 }
 
+void be_roce_dev_shutdown(struct be_adapter *adapter)
+{
+	if (be_roce_supported(adapter)) {
+		mutex_lock(&be_adapter_list_lock);
+		if (ocrdma_drv && adapter->ocrdma_dev &&
+		    ocrdma_drv->state_change_handler)
+			ocrdma_drv->state_change_handler(adapter->ocrdma_dev,
+							 BE_DEV_SHUTDOWN);
+		mutex_unlock(&be_adapter_list_lock);
+	}
+}
+
 int be_roce_register_driver(struct ocrdma_driver *drv)
 {
 	struct be_adapter *dev;
diff --git a/drivers/net/ethernet/emulex/benet/be_roce.h b/drivers/net/ethernet/emulex/benet/be_roce.h
index a3d9e96..e6f7eb1 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.h
+++ b/drivers/net/ethernet/emulex/benet/be_roce.h
@@ -62,7 +62,8 @@ struct ocrdma_driver {
 
 enum {
 	BE_DEV_UP	= 0,
-	BE_DEV_DOWN	= 1
+	BE_DEV_DOWN	= 1,
+	BE_DEV_SHUTDOWN = 2
 };
 
 /* APIs for RoCE driver to register callback handlers,
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
