From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/21] IB/hfi1: Create a routine to set a receive side
 mapping rule
Date: Tue, 12 Apr 2016 11:31:33 -0700
Message-ID: <20160412183124.27994.62413.stgit@scvm10.sc.intel.com>
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

Move the rule setting code into its own routine for improved
searchability and reuse.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   75 +++++++++++++++++++++++++++++---------
 1 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b2c037c..b5edc3a 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13429,6 +13429,21 @@ struct rsm_map_table {
 	unsigned int used;
 };
 
+struct rsm_rule_data {
+	u8 offset;
+	u8 pkt_type;
+	u32 field1_off;
+	u32 field2_off;
+	u32 index1_off;
+	u32 index1_width;
+	u32 index2_off;
+	u32 index2_width;
+	u32 mask1;
+	u32 value1;
+	u32 mask2;
+	u32 value2;
+};
+
 /*
  * Return an initialized RMT map table for users to fill in.  OK if it
  * returns NULL, indicating no table.
@@ -13466,6 +13481,30 @@ static void complete_rsm_map_table(struct hfi1_devdata *dd,
 	}
 }
 
+/*
+ * Add a receive side mapping rule.
+ */
+static void add_rsm_rule(struct hfi1_devdata *dd, u8 rule_index,
+			 struct rsm_rule_data *rrd)
+{
+	write_csr(dd, RCV_RSM_CFG + (8 * rule_index),
+		  (u64)rrd->offset << RCV_RSM_CFG_OFFSET_SHIFT |
+		  1ull << rule_index | /* enable bit */
+		  (u64)rrd->pkt_type << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
+	write_csr(dd, RCV_RSM_SELECT + (8 * rule_index),
+		  (u64)rrd->field1_off << RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
+		  (u64)rrd->field2_off << RCV_RSM_SELECT_FIELD2_OFFSET_SHIFT |
+		  (u64)rrd->index1_off << RCV_RSM_SELECT_INDEX1_OFFSET_SHIFT |
+		  (u64)rrd->index1_width << RCV_RSM_SELECT_INDEX1_WIDTH_SHIFT |
+		  (u64)rrd->index2_off << RCV_RSM_SELECT_INDEX2_OFFSET_SHIFT |
+		  (u64)rrd->index2_width << RCV_RSM_SELECT_INDEX2_WIDTH_SHIFT);
+	write_csr(dd, RCV_RSM_MATCH + (8 * rule_index),
+		  (u64)rrd->mask1 << RCV_RSM_MATCH_MASK1_SHIFT |
+		  (u64)rrd->value1 << RCV_RSM_MATCH_VALUE1_SHIFT |
+		  (u64)rrd->mask2 << RCV_RSM_MATCH_MASK2_SHIFT |
+		  (u64)rrd->value2 << RCV_RSM_MATCH_VALUE2_SHIFT);
+}
+
 /* return the number of RSM map table entries that will be used for QOS */
 static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
 			   unsigned int *np)
@@ -13526,6 +13565,7 @@ no_qos:
  */
 static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 {
+	struct rsm_rule_data rrd;
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
 	unsigned int rmt_entries;
 	u64 reg;
@@ -13565,24 +13605,23 @@ static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 		}
 		ctxt += krcvqs[i];
 	}
-	/* add rule0 */
-	write_csr(dd, RCV_RSM_CFG /* + (8 * 0) */,
-		  (u64)rmt->used << RCV_RSM_CFG_OFFSET_SHIFT |
-		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK <<
-			RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
-		  2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
-	write_csr(dd, RCV_RSM_SELECT /* + (8 * 0) */,
-		  LRH_BTH_MATCH_OFFSET << RCV_RSM_SELECT_FIELD1_OFFSET_SHIFT |
-		  LRH_SC_MATCH_OFFSET << RCV_RSM_SELECT_FIELD2_OFFSET_SHIFT |
-		  LRH_SC_SELECT_OFFSET << RCV_RSM_SELECT_INDEX1_OFFSET_SHIFT |
-		  ((u64)n) << RCV_RSM_SELECT_INDEX1_WIDTH_SHIFT |
-		  QPN_SELECT_OFFSET << RCV_RSM_SELECT_INDEX2_OFFSET_SHIFT |
-		  ((u64)m + (u64)n) << RCV_RSM_SELECT_INDEX2_WIDTH_SHIFT);
-	write_csr(dd, RCV_RSM_MATCH /* + (8 * 0) */,
-		  LRH_BTH_MASK << RCV_RSM_MATCH_MASK1_SHIFT |
-		  LRH_BTH_VALUE << RCV_RSM_MATCH_VALUE1_SHIFT |
-		  LRH_SC_MASK << RCV_RSM_MATCH_MASK2_SHIFT |
-		  LRH_SC_VALUE << RCV_RSM_MATCH_VALUE2_SHIFT);
+
+	rrd.offset = rmt->used;
+	rrd.pkt_type = 2;
+	rrd.field1_off = LRH_BTH_MATCH_OFFSET;
+	rrd.field2_off = LRH_SC_MATCH_OFFSET;
+	rrd.index1_off = LRH_SC_SELECT_OFFSET;
+	rrd.index1_width = n;
+	rrd.index2_off = QPN_SELECT_OFFSET;
+	rrd.index2_width = m + n;
+	rrd.mask1 = LRH_BTH_MASK;
+	rrd.value1 = LRH_BTH_VALUE;
+	rrd.mask2 = LRH_SC_MASK;
+	rrd.value2 = LRH_SC_VALUE;
+
+	/* add rule 0 */
+	add_rsm_rule(dd, 0, &rrd);
+
 	/* mark RSM map entries as used */
 	rmt->used += rmt_entries;
 	/* map everything else to the mcast/err/vl15 context */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
