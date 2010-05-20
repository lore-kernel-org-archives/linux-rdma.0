From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 02/11] RDMA/cxgb4: register rdma provider based on LLD
	state_change events.
Date: Thu, 20 May 2010 16:57:32 -0500
Message-ID: <20100520215732.32394.7290.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The LLD now supports proper UP state change events, so move the rdma
provider registration to UP path.

NOTE: This fixes a crash when loading iw_cxgb4 _after_ the NFSRDMA
transport is up and running.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c   |   46 +++++++++++++++++++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 drivers/infiniband/hw/cxgb4/provider.c |    2 +
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index c7e2484..d870f9c 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -306,7 +306,8 @@ static void c4iw_remove(struct c4iw_dev *dev)
 	PDBG("%s c4iw_dev %p\n", __func__,  dev);
 	cancel_delayed_work_sync(&dev->db_drop_task);
 	list_del(&dev->entry);
-	c4iw_unregister_device(dev);
+	if (dev->registered)
+		c4iw_unregister_device(dev);
 	c4iw_rdev_close(&dev->rdev);
 	idr_destroy(&dev->cqidr);
 	idr_destroy(&dev->qpidr);
@@ -343,12 +344,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	list_add_tail(&devp->entry, &dev_list);
 	mutex_unlock(&dev_mutex);
 
-	if (c4iw_register_device(devp)) {
-		printk(KERN_ERR MOD "Unable to register device\n");
-		mutex_lock(&dev_mutex);
-		c4iw_remove(devp);
-		mutex_unlock(&dev_mutex);
-	}
 	if (c4iw_debugfs_root) {
 		devp->debugfs_root = debugfs_create_dir(
 					pci_name(devp->rdev.lldi.pdev),
@@ -379,9 +374,6 @@ static void *c4iw_uld_add(const struct cxgb4_lld_info *infop)
 
 	for (i = 0; i < dev->rdev.lldi.nrxq; i++)
 		PDBG("rxqid[%u] %u\n", i, dev->rdev.lldi.rxq_ids[i]);
-
-	printk(KERN_INFO MOD "Initialized device %s\n",
-	       pci_name(dev->rdev.lldi.pdev));
 out:
 	return dev;
 }
@@ -471,7 +463,41 @@ nomem:
 
 static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
 {
+	struct c4iw_dev *dev = handle;
+
 	PDBG("%s new_state %u\n", __func__, new_state);
+	switch (new_state) {
+	case CXGB4_STATE_UP:
+		printk(KERN_INFO MOD "%s: Up\n", pci_name(dev->rdev.lldi.pdev));
+		if (!dev->registered) {
+			int ret;
+			ret = c4iw_register_device(dev);
+			if (ret)
+				printk(KERN_ERR MOD
+				       "%s: RDMA registration failed: %d\n",
+				       pci_name(dev->rdev.lldi.pdev), ret);
+		}
+		break;
+	case CXGB4_STATE_DOWN:
+		printk(KERN_INFO MOD "%s: Down\n",
+		       pci_name(dev->rdev.lldi.pdev));
+		if (dev->registered)
+			c4iw_unregister_device(dev);
+		break;
+	case CXGB4_STATE_START_RECOVERY:
+		printk(KERN_INFO MOD "%s: Fatal Error\n",
+		       pci_name(dev->rdev.lldi.pdev));
+		if (dev->registered)
+			c4iw_unregister_device(dev);
+		break;
+	case CXGB4_STATE_DETACH:
+		printk(KERN_INFO MOD "%s: Detach\n",
+		       pci_name(dev->rdev.lldi.pdev));
+		mutex_lock(&dev_mutex);
+		c4iw_remove(dev);
+		mutex_unlock(&dev_mutex);
+		break;
+	}
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index a626998..277ab58 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -152,6 +152,7 @@ struct c4iw_dev {
 	struct list_head entry;
 	struct delayed_work db_drop_task;
 	struct dentry *debugfs_root;
+	u8 registered;
 };
 
 static inline struct c4iw_dev *to_c4iw_dev(struct ib_device *ibdev)
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index dfc4902..322134b 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -496,6 +496,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 		if (ret)
 			goto bail2;
 	}
+	dev->registered = 1;
 	return 0;
 bail2:
 	ib_unregister_device(&dev->ibdev);
@@ -514,5 +515,6 @@ void c4iw_unregister_device(struct c4iw_dev *dev)
 				   c4iw_class_attributes[i]);
 	ib_unregister_device(&dev->ibdev);
 	kfree(dev->ibdev.iwcm);
+	dev->registered = 0;
 	return;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
