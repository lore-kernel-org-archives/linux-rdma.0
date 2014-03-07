From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix debugfs ordering issue with multiple HCAs
Date: Fri, 07 Mar 2014 08:32:31 -0500
Message-ID: <20140307133231.8636.20429.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The debugfs init code was incorrectly called before
the idr mechanism is used to get the unit number so
the dd->unit hadn't been initialized. This caused
the unit relative directory creation to fail after
the first.

This patch moves the init for the debugfs stuff
until after all of the failures and after the
unit number has been determined.

A bug unwind code in qib_alloc_devdata() is also fixed.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 24e802f..76c3e17 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1097,14 +1097,10 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	int ret;
 
 	dd = (struct qib_devdata *) ib_alloc_device(sizeof(*dd) + extra);
-	if (!dd) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
+	if (!dd)
+		return ERR_PTR(-ENOMEM);
 
-#ifdef CONFIG_DEBUG_FS
-	qib_dbg_ibdev_init(&dd->verbs_dev);
-#endif
+	INIT_LIST_HEAD(&dd->list);
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&qib_devs_lock, flags);
@@ -1121,11 +1117,6 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	if (ret < 0) {
 		qib_early_err(&pdev->dev,
 			      "Could not allocate unit ID: error %d\n", -ret);
-#ifdef CONFIG_DEBUG_FS
-		qib_dbg_ibdev_exit(&dd->verbs_dev);
-#endif
-		ib_dealloc_device(&dd->verbs_dev.ibdev);
-		dd = ERR_PTR(ret);
 		goto bail;
 	}
 
@@ -1139,9 +1130,15 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			qib_early_err(&pdev->dev,
 				"Could not alloc cpulist info, cpu affinity might be wrong\n");
 	}
-
-bail:
+#ifdef CONFIG_DEBUG_FS
+	qib_dbg_ibdev_init(&dd->verbs_dev);
+#endif
 	return dd;
+bail:
+	if (!list_empty(&dd->list))
+		list_del_init(&dd->list);
+	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	return ERR_PTR(ret);;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
