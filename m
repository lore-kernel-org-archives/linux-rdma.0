From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 4/4] RDMA/be2net: Remove open and close entry points
Date: Thu, 24 Dec 2015 13:14:08 -0500
Message-ID: <1450980848-18945-5-git-send-email-devesh.sharma@avagotech.com>
References: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450980848-18945-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sathya Perla <sathya.perla-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Recently Dough Ledford reported a deadlock happening
between ocrdma-load sequence and NetworkManager service
issueing "open" on be2net interface.

The deadlock happens when any be2net hook (e.g. open/close) is called
in parallel to insmod ocrdma.ko.

A. be2net is sending administrative open/close event to ocrdma holding
   device_list_mutex. It does this from ndo_open/ndo_stop hooks of be2net.
   So sequence of locks is rtnl_lock---> device_list lock

B.  When new ocrdma roce device gets registered, infiniband stack now
    takes rtnl_lock in ib_register_device() in GID initialization routines.
    So sequence of locks in this path is device_list lock ---> rtnl_lock.

This improper locking sequence causes deadlock.

In order to resolve the above deadlock condition, ocrdma intorduced a
patch to stop listening to administrative open/close events generated from
be2net driver. It now depends on link-state-change async-event generated from
CNA. This change leaves behind dead code which used to generate administrative
open/close events. This patch cleans-up all that dead code from be2net.

Reported-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Sathya Perla <sathya.perla-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/net/ethernet/emulex/benet/be.h      |  2 --
 drivers/net/ethernet/emulex/benet/be_main.c |  4 ----
 drivers/net/ethernet/emulex/benet/be_roce.c | 36 -----------------------------
 drivers/net/ethernet/emulex/benet/be_roce.h |  4 +---
 4 files changed, 1 insertion(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index d463563..6ee78c2 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -848,8 +848,6 @@ void be_roce_dev_remove(struct be_adapter *);
 /*
  * internal function to open-close roce device during ifup-ifdown.
  */
-void be_roce_dev_open(struct be_adapter *);
-void be_roce_dev_close(struct be_adapter *);
 void be_roce_dev_shutdown(struct be_adapter *);
 
 #endif				/* BE_H */
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b6ad029..ff2ff89 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3432,8 +3432,6 @@ static int be_close(struct net_device *netdev)
 
 	be_disable_if_filters(adapter);
 
-	be_roce_dev_close(adapter);
-
 	if (adapter->flags & BE_FLAGS_NAPI_ENABLED) {
 		for_all_evt_queues(adapter, eqo, i) {
 			napi_disable(&eqo->napi);
@@ -3601,8 +3599,6 @@ static int be_open(struct net_device *netdev)
 		be_link_status_update(adapter, link_status);
 
 	netif_tx_start_all_queues(netdev);
-	be_roce_dev_open(adapter);
-
 #ifdef CONFIG_BE2NET_VXLAN
 	if (skyhawk_chip(adapter))
 		vxlan_get_rx_port(netdev);
diff --git a/drivers/net/ethernet/emulex/benet/be_roce.c b/drivers/net/ethernet/emulex/benet/be_roce.c
index 6036820..4089156 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.c
+++ b/drivers/net/ethernet/emulex/benet/be_roce.c
@@ -116,40 +116,6 @@ void be_roce_dev_remove(struct be_adapter *adapter)
 	}
 }
 
-static void _be_roce_dev_open(struct be_adapter *adapter)
-{
-	if (ocrdma_drv && adapter->ocrdma_dev &&
-	    ocrdma_drv->state_change_handler)
-		ocrdma_drv->state_change_handler(adapter->ocrdma_dev,
-						 BE_DEV_UP);
-}
-
-void be_roce_dev_open(struct be_adapter *adapter)
-{
-	if (be_roce_supported(adapter)) {
-		mutex_lock(&be_adapter_list_lock);
-		_be_roce_dev_open(adapter);
-		mutex_unlock(&be_adapter_list_lock);
-	}
-}
-
-static void _be_roce_dev_close(struct be_adapter *adapter)
-{
-	if (ocrdma_drv && adapter->ocrdma_dev &&
-	    ocrdma_drv->state_change_handler)
-		ocrdma_drv->state_change_handler(adapter->ocrdma_dev,
-						 BE_DEV_DOWN);
-}
-
-void be_roce_dev_close(struct be_adapter *adapter)
-{
-	if (be_roce_supported(adapter)) {
-		mutex_lock(&be_adapter_list_lock);
-		_be_roce_dev_close(adapter);
-		mutex_unlock(&be_adapter_list_lock);
-	}
-}
-
 void be_roce_dev_shutdown(struct be_adapter *adapter)
 {
 	if (be_roce_supported(adapter)) {
@@ -177,8 +143,6 @@ int be_roce_register_driver(struct ocrdma_driver *drv)
 
 		_be_roce_dev_add(dev);
 		netdev = dev->netdev;
-		if (netif_running(netdev) && netif_oper_up(netdev))
-			_be_roce_dev_open(dev);
 	}
 	mutex_unlock(&be_adapter_list_lock);
 	return 0;
diff --git a/drivers/net/ethernet/emulex/benet/be_roce.h b/drivers/net/ethernet/emulex/benet/be_roce.h
index cde6ef9..fde6097 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.h
+++ b/drivers/net/ethernet/emulex/benet/be_roce.h
@@ -60,9 +60,7 @@ struct ocrdma_driver {
 	void (*state_change_handler) (struct ocrdma_dev *, u32 new_state);
 };
 
-enum {
-	BE_DEV_UP	= 0,
-	BE_DEV_DOWN	= 1,
+enum be_roce_event {
 	BE_DEV_SHUTDOWN = 2
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
