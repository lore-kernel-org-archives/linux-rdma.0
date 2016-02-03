From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/54] staging/rdma/hfi1: Fix for 32-bit counter overflow in
 driver and hfi1stats
Date: Wed, 03 Feb 2016 14:32:40 -0800
Message-ID: <20160203223236.5923.58251.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When 32-bit hardware counters overflow, hfi1stats misinterprets
the counters as being 64 bits causing the deltas for the
counters to be a huge number. This patch makes hfi1stats
aware that a counter is 32 bits by making the driver write
<counter name>,32 to debugfs.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   98 ++++++++++++++++++++++++++++----------
 1 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index d45e271..a90e6e6 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -11766,6 +11766,8 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	char *p;
 	char name[C_MAX_NAME];
 	struct hfi1_pportdata *ppd;
+	const char *bit_type_32 = ",32";
+	const int bit_type_32_sz = strlen(bit_type_32);
 
 	/* set up the stats timer; the add_timer is done at the end */
 	setup_timer(&dd->synth_stats_timer, update_synth_timer,
@@ -11795,6 +11797,9 @@ static int init_cntrs(struct hfi1_devdata *dd)
 					dev_cntrs[i].name,
 					vl_from_idx(j));
 				sz += strlen(name);
+				/* Add ",32" for 32-bit counters */
+				if (dev_cntrs[i].flags & CNTR_32BIT)
+					sz += bit_type_32_sz;
 				sz++;
 				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
@@ -11809,13 +11814,19 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				snprintf(name, C_MAX_NAME, "%s%d",
 					 dev_cntrs[i].name, j);
 				sz += strlen(name);
+				/* Add ",32" for 32-bit counters */
+				if (dev_cntrs[i].flags & CNTR_32BIT)
+					sz += bit_type_32_sz;
 				sz++;
 				hfi1_dbg_early("\t\t%s\n", name);
 				dd->ndevcntrs++;
 			}
 		} else {
-			/* +1 for newline  */
+			/* +1 for newline. */
 			sz += strlen(dev_cntrs[i].name) + 1;
+			/* Add ",32" for 32-bit counters */
+			if (dev_cntrs[i].flags & CNTR_32BIT)
+				sz += bit_type_32_sz;
 			dev_cntrs[i].offset = dd->ndevcntrs;
 			dd->ndevcntrs++;
 			hfi1_dbg_early("\tAdding %s\n", dev_cntrs[i].name);
@@ -11842,33 +11853,50 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	for (p = dd->cntrnames, i = 0; i < DEV_CNTR_LAST; i++) {
 		if (dev_cntrs[i].flags & CNTR_DISABLED) {
 			/* Nothing */
-		} else {
-			if (dev_cntrs[i].flags & CNTR_VL) {
-				for (j = 0; j < C_VL_COUNT; j++) {
-					memset(name, '\0', C_MAX_NAME);
-					snprintf(name, C_MAX_NAME, "%s%d",
-						dev_cntrs[i].name,
-						vl_from_idx(j));
-					memcpy(p, name, strlen(name));
-					p += strlen(name);
-					*p++ = '\n';
+		} else if (dev_cntrs[i].flags & CNTR_VL) {
+			for (j = 0; j < C_VL_COUNT; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					 dev_cntrs[i].name,
+					 vl_from_idx(j));
+				memcpy(p, name, strlen(name));
+				p += strlen(name);
+
+				/* Counter is 32 bits */
+				if (dev_cntrs[i].flags & CNTR_32BIT) {
+					memcpy(p, bit_type_32, bit_type_32_sz);
+					p += bit_type_32_sz;
 				}
-			} else if (dev_cntrs[i].flags & CNTR_SDMA) {
-				for (j = 0; j < TXE_NUM_SDMA_ENGINES;
-				     j++) {
-					memset(name, '\0', C_MAX_NAME);
-					snprintf(name, C_MAX_NAME, "%s%d",
-						 dev_cntrs[i].name, j);
-					memcpy(p, name, strlen(name));
-					p += strlen(name);
-					*p++ = '\n';
+
+				*p++ = '\n';
+			}
+		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
+			for (j = 0; j < dd->chip_sdma_engines; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					 dev_cntrs[i].name, j);
+				memcpy(p, name, strlen(name));
+				p += strlen(name);
+
+				/* Counter is 32 bits */
+				if (dev_cntrs[i].flags & CNTR_32BIT) {
+					memcpy(p, bit_type_32, bit_type_32_sz);
+					p += bit_type_32_sz;
 				}
-			} else {
-				memcpy(p, dev_cntrs[i].name,
-				       strlen(dev_cntrs[i].name));
-				p += strlen(dev_cntrs[i].name);
+
 				*p++ = '\n';
 			}
+		} else {
+			memcpy(p, dev_cntrs[i].name, strlen(dev_cntrs[i].name));
+			p += strlen(dev_cntrs[i].name);
+
+			/* Counter is 32 bits */
+			if (dev_cntrs[i].flags & CNTR_32BIT) {
+				memcpy(p, bit_type_32, bit_type_32_sz);
+				p += bit_type_32_sz;
+			}
+
+			*p++ = '\n';
 		}
 	}
 
@@ -11906,13 +11934,19 @@ static int init_cntrs(struct hfi1_devdata *dd)
 					port_cntrs[i].name,
 					vl_from_idx(j));
 				sz += strlen(name);
+				/* Add ",32" for 32-bit counters */
+				if (port_cntrs[i].flags & CNTR_32BIT)
+					sz += bit_type_32_sz;
 				sz++;
 				hfi1_dbg_early("\t\t%s\n", name);
 				dd->nportcntrs++;
 			}
 		} else {
-			/* +1 for newline  */
+			/* +1 for newline */
 			sz += strlen(port_cntrs[i].name) + 1;
+			/* Add ",32" for 32-bit counters */
+			if (port_cntrs[i].flags & CNTR_32BIT)
+				sz += bit_type_32_sz;
 			port_cntrs[i].offset = dd->nportcntrs;
 			dd->nportcntrs++;
 			hfi1_dbg_early("\tAdding %s\n", port_cntrs[i].name);
@@ -11938,12 +11972,26 @@ static int init_cntrs(struct hfi1_devdata *dd)
 					vl_from_idx(j));
 				memcpy(p, name, strlen(name));
 				p += strlen(name);
+
+				/* Counter is 32 bits */
+				if (port_cntrs[i].flags & CNTR_32BIT) {
+					memcpy(p, bit_type_32, bit_type_32_sz);
+					p += bit_type_32_sz;
+				}
+
 				*p++ = '\n';
 			}
 		} else {
 			memcpy(p, port_cntrs[i].name,
 			       strlen(port_cntrs[i].name));
 			p += strlen(port_cntrs[i].name);
+
+			/* Counter is 32 bits */
+			if (port_cntrs[i].flags & CNTR_32BIT) {
+				memcpy(p, bit_type_32, bit_type_32_sz);
+				p += bit_type_32_sz;
+			}
+
 			*p++ = '\n';
 		}
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
