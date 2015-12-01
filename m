From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 11/17] staging/rdma/hfi1: Destroy workqueues if hfi1_register_ib_device() call returns error
Date: Tue,  1 Dec 2015 15:38:20 -0500
Message-ID: <1449002306-15180-12-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, if hfi1_register_ib_device() call is unsuccessful, workqueues
are not being destroyed before bailing out. This patch fixes this issue.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- No changes

 drivers/staging/rdma/hfi1/init.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 1c8286f..f9d9dc1 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1336,6 +1336,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = 0, j, pidx, initfail;
 	struct hfi1_devdata *dd = NULL;
+	struct hfi1_pportdata *ppd;
 
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
@@ -1431,8 +1432,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		stop_timers(dd);
 		flush_workqueue(ib_wq);
-		for (pidx = 0; pidx < dd->num_pports; ++pidx)
+		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
+			ppd = dd->pport + pidx;
+			if (ppd->hfi1_wq) {
+				destroy_workqueue(ppd->hfi1_wq);
+				ppd->hfi1_wq = NULL;
+			}
+		}
 		if (!j)
 			hfi1_device_remove(dd);
 		if (!ret)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
