From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 6/6] staging/rdma/hfi1: Remove unneeded variable index
Date: Mon, 21 Dec 2015 21:56:19 -0500
Message-ID: <1450752979-29650-7-git-send-email-jubin.john@intel.com>
References: <1450752979-29650-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450752979-29650-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The variable "index" increments the same as dd->ndevcntrs.
Just use the later.  Remove uneeded usage of "index" in the
fill loop - it is not used there or later in the function.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- None

Changes in v3:
	- Refreshed patch against latest staging-testing

 drivers/staging/rdma/hfi1/chip.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f4f720d..1109049 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -11592,7 +11592,7 @@ mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
 #define C_MAX_NAME 13 /* 12 chars + one for /0 */
 static int init_cntrs(struct hfi1_devdata *dd)
 {
-	int i, rcv_ctxts, index, j;
+	int i, rcv_ctxts, j;
 	size_t sz;
 	char *p;
 	char name[C_MAX_NAME];
@@ -11609,7 +11609,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	/* size names and determine how many we have*/
 	dd->ndevcntrs = 0;
 	sz = 0;
-	index = 0;
 
 	for (i = 0; i < DEV_CNTR_LAST; i++) {
 		hfi1_dbg_early("Init cntr %s\n", dev_cntrs[i].name);
@@ -11620,7 +11619,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 
 		if (dev_cntrs[i].flags & CNTR_VL) {
 			hfi1_dbg_early("\tProcessing VL cntr\n");
-			dev_cntrs[i].offset = index;
+			dev_cntrs[i].offset = dd->ndevcntrs;
 			for (j = 0; j < C_VL_COUNT; j++) {
 				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
@@ -11630,13 +11629,12 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				sz++;
 				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
-				index++;
 			}
 		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
 			hfi1_dbg_early(
 				       "\tProcessing per SDE counters chip enginers %u\n",
 				       dd->chip_sdma_engines);
-			dev_cntrs[i].offset = index;
+			dev_cntrs[i].offset = dd->ndevcntrs;
 			for (j = 0; j < dd->chip_sdma_engines; j++) {
 				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
@@ -11645,24 +11643,22 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				sz++;
 				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
-				index++;
 			}
 		} else {
 			/* +1 for newline  */
 			sz += strlen(dev_cntrs[i].name) + 1;
+			dev_cntrs[i].offset = dd->ndevcntrs;
 			dd->ndevcntrs++;
-			dev_cntrs[i].offset = index;
-			index++;
 			hfi1_dbg_early("\tAdding %s\n", dev_cntrs[i].name);
 		}
 	}
 
 	/* allocate space for the counter values */
-	dd->cntrs = kcalloc(index, sizeof(u64), GFP_KERNEL);
+	dd->cntrs = kcalloc(dd->ndevcntrs, sizeof(u64), GFP_KERNEL);
 	if (!dd->cntrs)
 		goto bail;
 
-	dd->scntrs = kcalloc(index, sizeof(u64), GFP_KERNEL);
+	dd->scntrs = kcalloc(dd->ndevcntrs, sizeof(u64), GFP_KERNEL);
 	if (!dd->scntrs)
 		goto bail;
 
@@ -11674,7 +11670,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 		goto bail;
 
 	/* fill in the names */
-	for (p = dd->cntrnames, i = 0, index = 0; i < DEV_CNTR_LAST; i++) {
+	for (p = dd->cntrnames, i = 0; i < DEV_CNTR_LAST; i++) {
 		if (dev_cntrs[i].flags & CNTR_DISABLED) {
 			/* Nothing */
 		} else {
@@ -11704,7 +11700,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				p += strlen(dev_cntrs[i].name);
 				*p++ = '\n';
 			}
-			index++;
 		}
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
