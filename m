From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 42/54] staging/rdma/hfi1: Clean up init_cntrs()
Date: Wed, 03 Feb 2016 14:36:31 -0800
Message-ID: <20160203223627.5923.47449.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean up init_cntrs() by removing unnecessary memsets and debug
statements

Suggested-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 5b8fb02..8c06e3b 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -11813,17 +11813,14 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	sz = 0;
 
 	for (i = 0; i < DEV_CNTR_LAST; i++) {
-		hfi1_dbg_early("Init cntr %s\n", dev_cntrs[i].name);
 		if (dev_cntrs[i].flags & CNTR_DISABLED) {
 			hfi1_dbg_early("\tSkipping %s\n", dev_cntrs[i].name);
 			continue;
 		}
 
 		if (dev_cntrs[i].flags & CNTR_VL) {
-			hfi1_dbg_early("\tProcessing VL cntr\n");
 			dev_cntrs[i].offset = dd->ndevcntrs;
 			for (j = 0; j < C_VL_COUNT; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					dev_cntrs[i].name,
 					vl_from_idx(j));
@@ -11832,16 +11829,11 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				if (dev_cntrs[i].flags & CNTR_32BIT)
 					sz += bit_type_32_sz;
 				sz++;
-				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
 			}
 		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
-			hfi1_dbg_early(
-				       "\tProcessing per SDE counters chip enginers %u\n",
-				       dd->chip_sdma_engines);
 			dev_cntrs[i].offset = dd->ndevcntrs;
 			for (j = 0; j < dd->chip_sdma_engines; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					 dev_cntrs[i].name, j);
 				sz += strlen(name);
@@ -11849,7 +11841,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				if (dev_cntrs[i].flags & CNTR_32BIT)
 					sz += bit_type_32_sz;
 				sz++;
-				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
 			}
 		} else {
@@ -11860,7 +11851,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				sz += bit_type_32_sz;
 			dev_cntrs[i].offset = dd->ndevcntrs;
 			dd->ndevcntrs++;
-			hfi1_dbg_early("\tAdding %s\n", dev_cntrs[i].name);
 		}
 	}
 
@@ -11886,7 +11876,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 			/* Nothing */
 		} else if (dev_cntrs[i].flags & CNTR_VL) {
 			for (j = 0; j < C_VL_COUNT; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					 dev_cntrs[i].name,
 					 vl_from_idx(j));
@@ -11903,7 +11892,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 			}
 		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
 			for (j = 0; j < dd->chip_sdma_engines; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					 dev_cntrs[i].name, j);
 				memcpy(p, name, strlen(name));
@@ -11950,17 +11938,14 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	sz = 0;
 	dd->nportcntrs = 0;
 	for (i = 0; i < PORT_CNTR_LAST; i++) {
-		hfi1_dbg_early("Init pcntr %s\n", port_cntrs[i].name);
 		if (port_cntrs[i].flags & CNTR_DISABLED) {
 			hfi1_dbg_early("\tSkipping %s\n", port_cntrs[i].name);
 			continue;
 		}
 
 		if (port_cntrs[i].flags & CNTR_VL) {
-			hfi1_dbg_early("\tProcessing VL cntr\n");
 			port_cntrs[i].offset = dd->nportcntrs;
 			for (j = 0; j < C_VL_COUNT; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					port_cntrs[i].name,
 					vl_from_idx(j));
@@ -11969,7 +11954,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				if (port_cntrs[i].flags & CNTR_32BIT)
 					sz += bit_type_32_sz;
 				sz++;
-				hfi1_dbg_early("\t\t%s\n", name);
 				dd->nportcntrs++;
 			}
 		} else {
@@ -11980,7 +11964,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				sz += bit_type_32_sz;
 			port_cntrs[i].offset = dd->nportcntrs;
 			dd->nportcntrs++;
-			hfi1_dbg_early("\tAdding %s\n", port_cntrs[i].name);
 		}
 	}
 
@@ -11997,7 +11980,6 @@ static int init_cntrs(struct hfi1_devdata *dd)
 
 		if (port_cntrs[i].flags & CNTR_VL) {
 			for (j = 0; j < C_VL_COUNT; j++) {
-				memset(name, '\0', C_MAX_NAME);
 				snprintf(name, C_MAX_NAME, "%s%d",
 					port_cntrs[i].name,
 					vl_from_idx(j));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
