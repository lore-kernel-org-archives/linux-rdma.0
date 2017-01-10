From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until vmxnet3 link is up
Date: Tue, 10 Jan 2017 11:15:39 -0800
Message-ID: <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
References: <cover.1484075557.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1484075557.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Currently on bootup, ethernet drivers seem to load before RDMA ones
in Linux. So while the vmxnet3 module is loaded before vmw_pvrdma,
the vmxnet3 link state may not necessarily be enabled by the stack
before pvrdma is loaded. This is a problem because if the pvrdma
module is loaded on bootup (by installing it in /lib/modules/*),
the pvrdma device comes up in a port down state.

Since this is the most common use case scenario, defer the activation
of the device till the paired vmxnet3 link actually comes up. One
downside of doing this is, if a user doesn't have the vmxnet3 link
up when the pvrdma driver is loaded, they may not see any output
for ibv_devinfo until the paired vmxnet3 link is enabled too. The
users somehow need to be aware of this.

This only changes how the device is activated the first time. Once
enabled if the link goes down, a pvrdma driver reload is still required
after link up.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 99 +++++++++++++++++---------
 2 files changed, 65 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 71e1d55..540a54b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -221,6 +221,7 @@ struct pvrdma_dev {
 	u32 port_cap_mask;
 	struct mutex port_mutex; /* Port modification mutex. */
 	bool ib_active;
+	bool enabled;
 	atomic_t num_qps;
 	atomic_t num_cqs;
 	atomic_t num_pds;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 231a1ce..b57132f 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -74,6 +74,8 @@ static int pvrdma_del_gid(struct ib_device *ibdev,
 			  void **context);
 
 
+static int pvrdma_enable_dev(struct pvrdma_dev *dev);
+
 static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
@@ -755,6 +757,10 @@ static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
 		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
 		break;
 	case NETDEV_UP:
+		if (!dev->enabled && pvrdma_enable_dev(dev)) {
+			dev_err(&dev->pdev->dev, "failed to enable device\n");
+			break;
+		}
 		pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
 		break;
 	default:
@@ -801,6 +807,48 @@ static int pvrdma_netdevice_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
+static void pvrdma_disable_dev(struct pvrdma_dev *dev)
+{
+	if (dev->enabled) {
+		ib_unregister_device(&dev->ib_dev);
+		dev->enabled = false;
+	}
+}
+
+static int pvrdma_enable_dev(struct pvrdma_dev *dev)
+{
+	int ret;
+	pvrdma_enable_intrs(dev);
+
+	/* Activate pvrdma device */
+	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
+
+	/* Make sure the write is complete before reading status. */
+	mb();
+
+	/* Check if device was successfully activated */
+	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
+	if (ret) {
+		dev_err(&dev->pdev->dev, "failed to activate device\n");
+		ret = -EFAULT;
+		goto err_disable_intrs;
+	}
+
+	/* Register IB device */
+	ret = pvrdma_register_device(dev);
+	if (ret) {
+		dev_err(&dev->pdev->dev, "failed to register IB device\n");
+		goto err_disable_intrs;
+	}
+
+	dev->enabled = true;
+	return 0;
+
+err_disable_intrs:
+	pvrdma_disable_intrs(dev);
+	return ret;
+}
+
 static int pvrdma_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -867,14 +915,14 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	/* Enable 64-Bit DMA */
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_consistent_dma_mask failed\n");
 			goto err_free_resource;
 		}
 	} else {
 		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (ret != 0) {
+		if (ret) {
 			dev_err(&pdev->dev,
 				"pci_set_dma_mask failed\n");
 			goto err_free_resource;
@@ -1029,7 +1077,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "failed to allocate interrupts\n");
 		ret = -ENOMEM;
-		goto err_netdevice;
+		goto err_free_cq_ring;
 	}
 
 	/* Allocate UAR table. */
@@ -1049,51 +1097,35 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	}
 	dev_dbg(&pdev->dev, "gid table len %d\n", dev->dsr->caps.gid_tbl_len);
 
-	pvrdma_enable_intrs(dev);
-
-	/* Activate pvrdma device */
-	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
-
-	/* Make sure the write is complete before reading status. */
-	mb();
-
-	/* Check if device was successfully activated */
-	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "failed to activate device\n");
-		ret = -EFAULT;
-		goto err_disable_intr;
-	}
-
-	/* Register IB device */
-	ret = pvrdma_register_device(dev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register IB device\n");
-		goto err_disable_intr;
+	if (netif_running(dev->netdev) && netif_carrier_ok(dev->netdev)) {
+		ret = pvrdma_enable_dev(dev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to enable device\n");
+			goto err_free_sgid_tbl;
+		}
+	} else {
+		dev_info(&pdev->dev, "pvrdma netdev link is down\n");
 	}
 
 	dev->nb_netdev.notifier_call = pvrdma_netdevice_event;
 	ret = register_netdevice_notifier(&dev->nb_netdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register netdevice events\n");
-		goto err_unreg_ibdev;
+		goto err_disable_dev;
 	}
 
 	dev_info(&pdev->dev, "attached to device\n");
 	return 0;
 
-err_unreg_ibdev:
-	ib_unregister_device(&dev->ib_dev);
-err_disable_intr:
-	pvrdma_disable_intrs(dev);
+err_disable_dev:
+	pvrdma_disable_dev(dev);
+err_free_sgid_tbl:
 	kfree(dev->sgid_tbl);
 err_free_uar_table:
 	pvrdma_uar_table_cleanup(dev);
 err_free_intrs:
 	pvrdma_free_irq(dev);
 	pvrdma_disable_msi_all(dev);
-err_netdevice:
-	unregister_netdevice_notifier(&dev->nb_netdev);
 err_free_cq_ring:
 	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
 err_free_async_ring:
@@ -1132,10 +1164,7 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	unregister_netdevice_notifier(&dev->nb_netdev);
 	dev->nb_netdev.notifier_call = NULL;
 
-	flush_workqueue(event_wq);
-
-	/* Unregister ib device */
-	ib_unregister_device(&dev->ib_dev);
+	pvrdma_disable_dev(dev);
 
 	mutex_lock(&pvrdma_device_list_lock);
 	list_del(&dev->device_link);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
