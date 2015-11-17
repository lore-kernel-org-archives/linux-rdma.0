From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/13] staging/rdma/hfi1: Add space between concatenated string elements
Date: Mon, 16 Nov 2015 21:59:27 -0500
Message-ID: <1447729175-28745-6-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Space between concantenated string elements is more human
readable and fixes the checkpatch issue:
CHECK: Concatenated strings should use spaces between elements

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |   10 +++++-----
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 41d8864..7c58c7b 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -8891,8 +8891,8 @@ static int request_intx_irq(struct hfi1_devdata *dd)
 {
 	int ret;
 
-	snprintf(dd->intx_name, sizeof(dd->intx_name), DRIVER_NAME"_%d",
-		dd->unit);
+	snprintf(dd->intx_name, sizeof(dd->intx_name), DRIVER_NAME "_%d",
+		 dd->unit);
 	ret = request_irq(dd->pcidev->irq, general_interrupt,
 				  IRQF_SHARED, dd->intx_name, dd);
 	if (ret)
@@ -8994,7 +8994,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			handler = general_interrupt;
 			arg = dd;
 			snprintf(me->name, sizeof(me->name),
-				DRIVER_NAME"_%d", dd->unit);
+				 DRIVER_NAME "_%d", dd->unit);
 			err_info = "general";
 		} else if (first_sdma <= i && i < last_sdma) {
 			idx = i - first_sdma;
@@ -9002,7 +9002,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			handler = sdma_interrupt;
 			arg = sde;
 			snprintf(me->name, sizeof(me->name),
-				DRIVER_NAME"_%d sdma%d", dd->unit, idx);
+				 DRIVER_NAME "_%d sdma%d", dd->unit, idx);
 			err_info = "sdma";
 			remap_sdma_interrupts(dd, idx, i);
 		} else if (first_rx <= i && i < last_rx) {
@@ -9022,7 +9022,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			thread = receive_context_thread;
 			arg = rcd;
 			snprintf(me->name, sizeof(me->name),
-				DRIVER_NAME"_%d kctxt%d", dd->unit, idx);
+				 DRIVER_NAME "_%d kctxt%d", dd->unit, idx);
 			err_info = "receive context";
 			remap_intr(dd, IS_RCVAVAIL_START + idx, i);
 		} else {
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 72ab5e1..3938840 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -158,7 +158,7 @@ const char *get_unit_name(int unit)
 {
 	static char iname[16];
 
-	snprintf(iname, sizeof(iname), DRIVER_NAME"_%u", unit);
+	snprintf(iname, sizeof(iname), DRIVER_NAME "_%u", unit);
 	return iname;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
