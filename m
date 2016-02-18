From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] staging/rdma/hfi1: Fix debugfs access race
Date: Thu, 18 Feb 2016 11:12:25 -0800
Message-ID: <20160218191221.20983.47974.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Debugfs access races with the driver being ready.  Make sure the
driver is ready before debugfs files appear and debufs files are
gone before the driver starts tearing down.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 2def538..371ed29 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -983,7 +983,6 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	list_del(&dd->list);
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
 	free_platform_config(dd);
-	hfi1_dbg_ibdev_exit(&dd->verbs_dev);
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
@@ -1088,7 +1087,6 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			&pdev->dev,
 			"Could not alloc cpulist info, cpu affinity might be wrong\n");
 	}
-	hfi1_dbg_ibdev_init(&dd->verbs_dev);
 	return dd;
 
 bail:
@@ -1445,8 +1443,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * we still create devices, so diags, etc. can be used
 	 * to determine cause of problem.
 	 */
-	if (!initfail && !ret)
+	if (!initfail && !ret) {
 		dd->flags |= HFI1_INITTED;
+		/* create debufs files after init and ib register */
+		hfi1_dbg_ibdev_init(&dd->verbs_dev);
+	}
 
 	j = hfi1_device_create(dd);
 	if (j)
@@ -1487,6 +1488,8 @@ static void remove_one(struct pci_dev *pdev)
 {
 	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
 
+	/* close debugfs files before ib unregister */
+	hfi1_dbg_ibdev_exit(&dd->verbs_dev);
 	/* unregister from IB core */
 	hfi1_unregister_ib_device(dd);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
