From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: call iwpm_init() only once
Date: Fri, 20 Jun 2014 14:26:25 -0500
Message-ID: <20140620192624.13854.84058.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We need to only register with the iwpm core once.  Currently it is being
done for every adapter, which causes a failure for each adapter but the
first, making multiple adapters unusable.

This was introduced by

9eccfe1 RDMA/cxgb4: Add support for iWARP Port Mapper user space service

which hit 3.16-rc1.  So we need the fix included in 3.16.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |    2 +-
 drivers/infiniband/hw/cxgb4/device.c   |   17 ++++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    2 +-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..dc5bdd9 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3917,7 +3917,7 @@ int __init c4iw_cm_init(void)
 	return 0;
 }
 
-void __exit c4iw_cm_term(void)
+void c4iw_cm_term(void)
 {
 	WARN_ON(!list_empty(&timeout_list));
 	flush_workqueue(workq);
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index dd93aad..cbcb72d 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -729,7 +729,6 @@ static void c4iw_dealloc(struct uld_ctx *ctx)
 	if (ctx->dev->rdev.oc_mw_kva)
 		iounmap(ctx->dev->rdev.oc_mw_kva);
 	ib_dealloc_device(&ctx->dev->ibdev);
-	iwpm_exit(RDMA_NL_C4IW);
 	ctx->dev = NULL;
 }
 
@@ -826,12 +825,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 		setup_debugfs(devp);
 	}
 
-	ret = iwpm_init(RDMA_NL_C4IW);
-	if (ret) {
-		pr_err("port mapper initialization failed with %d\n", ret);
-		ib_dealloc_device(&devp->ibdev);
-		return ERR_PTR(ret);
-	}
 
 	return devp;
 }
@@ -1332,6 +1325,15 @@ static int __init c4iw_init_module(void)
 		pr_err("%s[%u]: Failed to add netlink callback\n"
 		       , __func__, __LINE__);
 
+	err = iwpm_init(RDMA_NL_C4IW);
+	if (err) {
+		pr_err("port mapper initialization failed with %d\n", err);
+		ibnl_remove_client(RDMA_NL_C4IW);
+		c4iw_cm_term();
+		debugfs_remove_recursive(c4iw_debugfs_root);
+		return err;
+	}
+
 	cxgb4_register_uld(CXGB4_ULD_RDMA, &c4iw_uld_info);
 
 	return 0;
@@ -1349,6 +1351,7 @@ static void __exit c4iw_exit_module(void)
 	}
 	mutex_unlock(&dev_mutex);
 	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
+	iwpm_exit(RDMA_NL_C4IW);
 	ibnl_remove_client(RDMA_NL_C4IW);
 	c4iw_cm_term();
 	debugfs_remove_recursive(c4iw_debugfs_root);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 125bc5d..361fff7 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -908,7 +908,7 @@ int c4iw_destroy_ctrl_qp(struct c4iw_rdev *rdev);
 int c4iw_register_device(struct c4iw_dev *dev);
 void c4iw_unregister_device(struct c4iw_dev *dev);
 int __init c4iw_cm_init(void);
-void __exit c4iw_cm_term(void);
+void c4iw_cm_term(void);
 void c4iw_release_dev_ucontext(struct c4iw_rdev *rdev,
 			       struct c4iw_dev_ucontext *uctx);
 void c4iw_init_dev_ucontext(struct c4iw_rdev *rdev,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
