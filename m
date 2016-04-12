From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/21] IB/hfi1: Add RSM rule for user FECN handling
Date: Tue, 12 Apr 2016 11:32:06 -0700
Message-ID: <20160412183153.28152.53298.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a receive side mapping rule to extract expected user packets with
the FECN bit set and place them in an eager buffer.  This will allow
user libraries to recognize that a FECN was sent when using header
suppression and respond appropriately.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   84 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b5edc3a..386309c 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1034,6 +1034,8 @@ static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc);
 static void handle_temp_err(struct hfi1_devdata *);
 static void dc_shutdown(struct hfi1_devdata *);
 static void dc_start(struct hfi1_devdata *);
+static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+			   unsigned int *np);
 
 /*
  * Error interrupt table entry.  This is used as input to the interrupt
@@ -12628,6 +12630,8 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int total_contexts;
 	int ret;
 	unsigned ngroups;
+	int qos_rmt_count;
+	int user_rmt_reduced;
 
 	/*
 	 * Kernel receive contexts:
@@ -12683,6 +12687,19 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		total_contexts = num_kernel_contexts + num_user_contexts;
 	}
 
+	/* each user context requires an entry in the RMT */
+	qos_rmt_count = qos_rmt_entries(dd, NULL, NULL);
+	if (qos_rmt_count + num_user_contexts > NUM_MAP_ENTRIES) {
+		user_rmt_reduced = NUM_MAP_ENTRIES - qos_rmt_count;
+		dd_dev_err(dd,
+			   "RMT size is reducing the number of user receive contexts from %d to %d\n",
+			   (int)num_user_contexts,
+			   user_rmt_reduced);
+		/* recalculate */
+		num_user_contexts = user_rmt_reduced;
+		total_contexts = num_kernel_contexts + num_user_contexts;
+	}
+
 	/* the first N are kernel contexts, the rest are user contexts */
 	dd->num_rcv_contexts = total_contexts;
 	dd->n_krcv_queues = num_kernel_contexts;
@@ -13633,6 +13650,72 @@ bail:
 	init_qpmap_table(dd, FIRST_KERNEL_KCTXT, dd->n_krcv_queues - 1);
 }
 
+static void init_user_fecn_handling(struct hfi1_devdata *dd,
+				    struct rsm_map_table *rmt)
+{
+	struct rsm_rule_data rrd;
+	u64 reg;
+	int i, idx, regoff, regidx;
+	u8 offset;
+
+	/* there needs to be enough room in the map table */
+	if (rmt->used + dd->num_user_contexts >= NUM_MAP_ENTRIES) {
+		dd_dev_err(dd, "User FECN handling disabled - too many user contexts allocated\n");
+		return;
+	}
+
+	/*
+	 * RSM will extract the destination context as an index into the
+	 * map table.  The destination contexts are a sequential block
+	 * in the range first_user_ctxt...num_rcv_contexts-1 (inclusive).
+	 * Map entries are accessed as offset + extracted value.  Adjust
+	 * the added offset so this sequence can be placed anywhere in
+	 * the table - as long as the entries themselves do not wrap.
+	 * There are only enough bits in offset for the table size, so
+	 * start with that to allow for a "negative" offset.
+	 */
+	offset = (u8)(NUM_MAP_ENTRIES + (int)rmt->used -
+						(int)dd->first_user_ctxt);
+
+	for (i = dd->first_user_ctxt, idx = rmt->used;
+				i < dd->num_rcv_contexts; i++, idx++) {
+		/* replace with identity mapping */
+		regoff = (idx % 8) * 8;
+		regidx = idx / 8;
+		reg = rmt->map[regidx];
+		reg &= ~(RCV_RSM_MAP_TABLE_RCV_CONTEXT_A_MASK << regoff);
+		reg |= (u64)i << regoff;
+		rmt->map[regidx] = reg;
+	}
+
+	/*
+	 * For RSM intercept of Expected FECN packets:
+	 * o packet type 0 - expected
+	 * o match on F (bit 95), using select/match 1, and
+	 * o match on SH (bit 133), using select/match 2.
+	 *
+	 * Use index 1 to extract the 8-bit receive context from DestQP
+	 * (start at bit 64).  Use that as the RSM map table index.
+	 */
+	rrd.offset = offset;
+	rrd.pkt_type = 0;
+	rrd.field1_off = 95;
+	rrd.field2_off = 133;
+	rrd.index1_off = 64;
+	rrd.index1_width = 8;
+	rrd.index2_off = 0;
+	rrd.index2_width = 0;
+	rrd.mask1 = 1;
+	rrd.value1 = 1;
+	rrd.mask2 = 1;
+	rrd.value2 = 1;
+
+	/* add rule 1 */
+	add_rsm_rule(dd, 1, &rrd);
+
+	rmt->used += dd->num_user_contexts;
+}
+
 static void init_rxe(struct hfi1_devdata *dd)
 {
 	struct rsm_map_table *rmt;
@@ -13643,6 +13726,7 @@ static void init_rxe(struct hfi1_devdata *dd)
 	rmt = alloc_rsm_map_table(dd);
 	/* set up QOS, including the QPN map table */
 	init_qos(dd, rmt);
+	init_user_fecn_handling(dd, rmt);
 	complete_rsm_map_table(dd, rmt);
 	kfree(rmt);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
