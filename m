From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] RDMA/cxgb4: EEH errors can hang the driver.
Date: Fri, 22 Apr 2011 12:56:13 -0500
Message-ID: <20110422175613.8004.71916.stgit@build.ogc.int>
References: <20110422175607.8004.14295.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422175607.8004.14295.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A few more EEH fixes:

c4iw_wait_for_reply(): detect fatal EEH condition on timeout and return
an error.

The iw_cxgb4 driver was only calling ib_deregister_device()
on an EEH event followed by a ib_register_device() when the
device was reinitialized.  However, the rdma core doesn't allow
multiple iterations of register/deregister by the provider. See
drivers/infiniband/core/sysfs.c: ib_device_unregister_sysfs()
where the kobject ref is held until the device is deallocated in
ib_deallocate_device(). Calling deregister adds this kobj reference,
and then a subsequet register call will generate a WARN_ON() from the
kobject subsystem  because the kobject is being initialized but is
already initialized with the ref held.

So the provider must deregister and dealloc when resetting for an EEH
event, then alloc/register to re-initialize.  To do this, we cannot
use the device ptr as our ULD handle since it will change with each
reallocation.  This commit adds a uld context struct which is used as the
ULD handle, and then contains the device pointer and other state needed.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c   |  111 ++++++++++++++++++--------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    6 +-
 drivers/infiniband/hw/cxgb4/provider.c |    2 -
 3 files changed, 66 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 8e70953..40a13cc 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -44,7 +44,7 @@ MODULE_DESCRIPTION("Chelsio T4 RDMA Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRV_VERSION);
 
-static LIST_HEAD(dev_list);
+static LIST_HEAD(uld_ctx_list);
 static DEFINE_MUTEX(dev_mutex);
 
 static struct dentry *c4iw_debugfs_root;
@@ -370,18 +370,23 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 	c4iw_destroy_resource(&rdev->resource);
 }
 
-static void c4iw_remove(struct c4iw_dev *dev)
+struct uld_ctx {
+	struct list_head entry;
+	struct cxgb4_lld_info lldi;
+	struct c4iw_dev *dev;
+};
+
+static void c4iw_remove(struct uld_ctx *ctx)
 {
-	PDBG("%s c4iw_dev %p\n", __func__,  dev);
-	list_del(&dev->entry);
-	if (dev->registered)
-		c4iw_unregister_device(dev);
-	c4iw_rdev_close(&dev->rdev);
-	idr_destroy(&dev->cqidr);
-	idr_destroy(&dev->qpidr);
-	idr_destroy(&dev->mmidr);
-	iounmap(dev->rdev.oc_mw_kva);
-	ib_dealloc_device(&dev->ibdev);
+	PDBG("%s c4iw_dev %p\n", __func__,  ctx->dev);
+	c4iw_unregister_device(ctx->dev);
+	c4iw_rdev_close(&ctx->dev->rdev);
+	idr_destroy(&ctx->dev->cqidr);
+	idr_destroy(&ctx->dev->qpidr);
+	idr_destroy(&ctx->dev->mmidr);
+	iounmap(ctx->dev->rdev.oc_mw_kva);
+	ib_dealloc_device(&ctx->dev->ibdev);
+	ctx->dev = NULL;
 }
 
 static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
@@ -402,13 +407,11 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	devp->rdev.oc_mw_kva = ioremap_wc(devp->rdev.oc_mw_pa,
 					       devp->rdev.lldi.vr->ocq.size);
 
-	printk(KERN_INFO MOD "ocq memory: "
+	PDBG(KERN_INFO MOD "ocq memory: "
 	       "hw_start 0x%x size %u mw_pa 0x%lx mw_kva %p\n",
 	       devp->rdev.lldi.vr->ocq.start, devp->rdev.lldi.vr->ocq.size,
 	       devp->rdev.oc_mw_pa, devp->rdev.oc_mw_kva);
 
-	mutex_lock(&dev_mutex);
-
 	ret = c4iw_rdev_open(&devp->rdev);
 	if (ret) {
 		mutex_unlock(&dev_mutex);
@@ -421,8 +424,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 	idr_init(&devp->qpidr);
 	idr_init(&devp->mmidr);
 	spin_lock_init(&devp->lock);
-	list_add_tail(&devp->entry, &dev_list);
-	mutex_unlock(&dev_mutex);
 
 	if (c4iw_debugfs_root) {
 		devp->debugfs_root = debugfs_create_dir(
@@ -435,7 +436,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 
 static void *c4iw_uld_add(const struct cxgb4_lld_info *infop)
 {
-	struct c4iw_dev *dev;
+	struct uld_ctx *ctx;
 	static int vers_printed;
 	int i;
 
@@ -443,25 +444,33 @@ static void *c4iw_uld_add(const struct cxgb4_lld_info *infop)
 		printk(KERN_INFO MOD "Chelsio T4 RDMA Driver - version %s\n",
 		       DRV_VERSION);
 
-	dev = c4iw_alloc(infop);
-	if (IS_ERR(dev))
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx) {
+		ctx = ERR_PTR(-ENOMEM);
 		goto out;
+	}
+	ctx->lldi = *infop;
 
 	PDBG("%s found device %s nchan %u nrxq %u ntxq %u nports %u\n",
-	     __func__, pci_name(dev->rdev.lldi.pdev),
-	     dev->rdev.lldi.nchan, dev->rdev.lldi.nrxq,
-	     dev->rdev.lldi.ntxq, dev->rdev.lldi.nports);
+	     __func__, pci_name(ctx->lldi.pdev),
+	     ctx->lldi.nchan, ctx->lldi.nrxq,
+	     ctx->lldi.ntxq, ctx->lldi.nports);
+
+	mutex_lock(&dev_mutex);
+	list_add_tail(&ctx->entry, &uld_ctx_list);
+	mutex_unlock(&dev_mutex);
 
-	for (i = 0; i < dev->rdev.lldi.nrxq; i++)
-		PDBG("rxqid[%u] %u\n", i, dev->rdev.lldi.rxq_ids[i]);
+	for (i = 0; i < ctx->lldi.nrxq; i++)
+		PDBG("rxqid[%u] %u\n", i, ctx->lldi.rxq_ids[i]);
 out:
-	return dev;
+	return ctx;
 }
 
 static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 			const struct pkt_gl *gl)
 {
-	struct c4iw_dev *dev = handle;
+	struct uld_ctx *ctx = handle;
+	struct c4iw_dev *dev = ctx->dev;
 	struct sk_buff *skb;
 	const struct cpl_act_establish *rpl;
 	unsigned int opcode;
@@ -503,47 +512,49 @@ nomem:
 
 static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
 {
-	struct c4iw_dev *dev = handle;
+	struct uld_ctx *ctx = handle;
 
 	PDBG("%s new_state %u\n", __func__, new_state);
 	switch (new_state) {
 	case CXGB4_STATE_UP:
-		printk(KERN_INFO MOD "%s: Up\n", pci_name(dev->rdev.lldi.pdev));
-		if (!dev->registered) {
-			int ret;
-			ret = c4iw_register_device(dev);
-			if (ret)
+		printk(KERN_INFO MOD "%s: Up\n", pci_name(ctx->lldi.pdev));
+		if (!ctx->dev) {
+			int ret = 0;
+
+			ctx->dev = c4iw_alloc(&ctx->lldi);
+			if (!IS_ERR(ctx->dev))
+				ret = c4iw_register_device(ctx->dev);
+			if (IS_ERR(ctx->dev) || ret)
 				printk(KERN_ERR MOD
 				       "%s: RDMA registration failed: %d\n",
-				       pci_name(dev->rdev.lldi.pdev), ret);
+				       pci_name(ctx->lldi.pdev), ret);
 		}
 		break;
 	case CXGB4_STATE_DOWN:
 		printk(KERN_INFO MOD "%s: Down\n",
-		       pci_name(dev->rdev.lldi.pdev));
-		if (dev->registered)
-			c4iw_unregister_device(dev);
+		       pci_name(ctx->lldi.pdev));
+		if (ctx->dev)
+			c4iw_remove(ctx);
 		break;
 	case CXGB4_STATE_START_RECOVERY:
 		printk(KERN_INFO MOD "%s: Fatal Error\n",
-		       pci_name(dev->rdev.lldi.pdev));
-		dev->rdev.flags |= T4_FATAL_ERROR;
-		if (dev->registered) {
+		       pci_name(ctx->lldi.pdev));
+		if (ctx->dev) {
 			struct ib_event event;
 
+			ctx->dev->rdev.flags |= T4_FATAL_ERROR;
 			memset(&event, 0, sizeof event);
 			event.event  = IB_EVENT_DEVICE_FATAL;
-			event.device = &dev->ibdev;
+			event.device = &ctx->dev->ibdev;
 			ib_dispatch_event(&event);
-			c4iw_unregister_device(dev);
+			c4iw_remove(ctx);
 		}
 		break;
 	case CXGB4_STATE_DETACH:
 		printk(KERN_INFO MOD "%s: Detach\n",
-		       pci_name(dev->rdev.lldi.pdev));
-		mutex_lock(&dev_mutex);
-		c4iw_remove(dev);
-		mutex_unlock(&dev_mutex);
+		       pci_name(ctx->lldi.pdev));
+		if (ctx->dev)
+			c4iw_remove(ctx);
 		break;
 	}
 	return 0;
@@ -576,11 +587,13 @@ static int __init c4iw_init_module(void)
 
 static void __exit c4iw_exit_module(void)
 {
-	struct c4iw_dev *dev, *tmp;
+	struct uld_ctx *ctx, *tmp;
 
 	mutex_lock(&dev_mutex);
-	list_for_each_entry_safe(dev, tmp, &dev_list, entry) {
-		c4iw_remove(dev);
+	list_for_each_entry_safe(ctx, tmp, &uld_ctx_list, entry) {
+		if (ctx->dev)
+			c4iw_remove(ctx);
+		kfree(ctx);
 	}
 	mutex_unlock(&dev_mutex);
 	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 3dcfe82..35d2a5d 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -170,6 +170,10 @@ static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 			printk(KERN_ERR MOD "%s - Device %s not responding - "
 			       "tid %u qpid %u\n", func,
 			       pci_name(rdev->lldi.pdev), hwtid, qpid);
+			if (c4iw_fatal_error(rdev)) {
+				wr_waitp->ret = -EIO;
+				break;
+			}
 			to = to << 2;
 		}
 	} while (!ret);
@@ -187,9 +191,7 @@ struct c4iw_dev {
 	struct idr qpidr;
 	struct idr mmidr;
 	spinlock_t lock;
-	struct list_head entry;
 	struct dentry *debugfs_root;
-	u8 registered;
 };
 
 static inline struct c4iw_dev *to_c4iw_dev(struct ib_device *ibdev)
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index f66dd8b..5b9e422 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -516,7 +516,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 		if (ret)
 			goto bail2;
 	}
-	dev->registered = 1;
 	return 0;
 bail2:
 	ib_unregister_device(&dev->ibdev);
@@ -535,6 +534,5 @@ void c4iw_unregister_device(struct c4iw_dev *dev)
 				   c4iw_class_attributes[i]);
 	ib_unregister_device(&dev->ibdev);
 	kfree(dev->ibdev.iwcm);
-	dev->registered = 0;
 	return;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
