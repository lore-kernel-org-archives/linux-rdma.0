From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Fail RDMA initialization for unsupported cards.
Date: Mon, 01 Aug 2011 16:59:10 -0500
Message-ID: <20110801215910.9774.75120.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The iw_cxgb4 module crashes at init time if the T4 card does not
support RDMA.  So clean up the init logic to correctly deal with
non-RDMA cards.

- If any RDMA resources are not available, then fail the initializtion
logging an info message.

- Clean up properly on initialization failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   41 +++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 40a13cc..6d0df6e 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -376,10 +376,8 @@ struct uld_ctx {
 	struct c4iw_dev *dev;
 };
 
-static void c4iw_remove(struct uld_ctx *ctx)
+static void c4iw_dealloc(struct uld_ctx *ctx)
 {
-	PDBG("%s c4iw_dev %p\n", __func__,  ctx->dev);
-	c4iw_unregister_device(ctx->dev);
 	c4iw_rdev_close(&ctx->dev->rdev);
 	idr_destroy(&ctx->dev->cqidr);
 	idr_destroy(&ctx->dev->qpidr);
@@ -389,11 +387,30 @@ static void c4iw_remove(struct uld_ctx *ctx)
 	ctx->dev = NULL;
 }
 
+static void c4iw_remove(struct uld_ctx *ctx)
+{
+	PDBG("%s c4iw_dev %p\n", __func__,  ctx->dev);
+	c4iw_unregister_device(ctx->dev);
+	c4iw_dealloc(ctx);
+}
+
+static int rdma_supported(const struct cxgb4_lld_info *infop)
+{
+	return infop->vr->stag.size > 0 && infop->vr->pbl.size > 0 &&
+	       infop->vr->rq.size > 0 && infop->vr->qp.size > 0 &&
+	       infop->vr->cq.size > 0 && infop->vr->ocq.size > 0;
+}
+
 static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 {
 	struct c4iw_dev *devp;
 	int ret;
 
+	if (!rdma_supported(infop)) {
+		printk(KERN_INFO MOD "%s: RDMA not supported on this device.\n",
+		       pci_name(infop->pdev));
+		return ERR_PTR(-ENOSYS);
+	}
 	devp = (struct c4iw_dev *)ib_alloc_device(sizeof(*devp));
 	if (!devp) {
 		printk(KERN_ERR MOD "Cannot allocate ib device\n");
@@ -414,7 +431,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 
 	ret = c4iw_rdev_open(&devp->rdev);
 	if (ret) {
-		mutex_unlock(&dev_mutex);
 		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
 		ib_dealloc_device(&devp->ibdev);
 		return ERR_PTR(ret);
@@ -519,15 +535,24 @@ static int c4iw_uld_state_change(void *handle, enum cxgb4_state new_state)
 	case CXGB4_STATE_UP:
 		printk(KERN_INFO MOD "%s: Up\n", pci_name(ctx->lldi.pdev));
 		if (!ctx->dev) {
-			int ret = 0;
+			int ret;
 
 			ctx->dev = c4iw_alloc(&ctx->lldi);
-			if (!IS_ERR(ctx->dev))
-				ret = c4iw_register_device(ctx->dev);
-			if (IS_ERR(ctx->dev) || ret)
+			if (IS_ERR(ctx->dev)) {
+				printk(KERN_ERR MOD
+				       "%s: initialization failed: %ld\n",
+				       pci_name(ctx->lldi.pdev),
+				       PTR_ERR(ctx->dev));
+				ctx->dev = NULL;
+				break;
+			}
+			ret = c4iw_register_device(ctx->dev);
+			if (ret) {
 				printk(KERN_ERR MOD
 				       "%s: RDMA registration failed: %d\n",
 				       pci_name(ctx->lldi.pdev), ret);
+				c4iw_dealloc(ctx);
+			}
 		}
 		break;
 	case CXGB4_STATE_DOWN:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
