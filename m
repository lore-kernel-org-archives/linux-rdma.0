From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/21] IB/hfi1: Extract RSM map table init from QOS
Date: Tue, 12 Apr 2016 11:30:51 -0700
Message-ID: <20160412183043.27656.49185.stgit@scvm10.sc.intel.com>
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

Refactor the allocation, tracking, and writing of the RSM map table
into its own set of routines.  This will allow the map table to be
passed to multiple users to fill in as needed.  Start with the original
user, QOS.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c           |   91 ++++++++++++++++++++++------
 drivers/staging/rdma/hfi1/chip_registers.h |    1 
 2 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 96badb4..234c078 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -123,6 +123,8 @@ struct flag_table {
 
 #define MIN_KERNEL_KCTXTS         2
 #define FIRST_KERNEL_KCTXT        1
+/* sizes for both the QP and RSM map tables */
+#define NUM_MAP_ENTRIES		256
 #define NUM_MAP_REGS             32
 
 /* Bit offset into the GUID which carries HFI id information */
@@ -13422,9 +13424,52 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
 			| RCV_CTRL_RCV_BYPASS_ENABLE_SMASK);
 }
 
+struct rsm_map_table {
+	u64 map[NUM_MAP_REGS];
+	unsigned int used;
+};
+
+/*
+ * Return an initialized RMT map table for users to fill in.  OK if it
+ * returns NULL, indicating no table.
+ */
+static struct rsm_map_table *alloc_rsm_map_table(struct hfi1_devdata *dd)
+{
+	struct rsm_map_table *rmt;
+	u8 rxcontext = is_ax(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
+
+	rmt = kmalloc(sizeof(*rmt), GFP_KERNEL);
+	if (rmt) {
+		memset(rmt->map, rxcontext, sizeof(rmt->map));
+		rmt->used = 0;
+	}
+
+	return rmt;
+}
+
+/*
+ * Write the final RMT map table to the chip and free the table.  OK if
+ * table is NULL.
+ */
+static void complete_rsm_map_table(struct hfi1_devdata *dd,
+				   struct rsm_map_table *rmt)
+{
+	int i;
+
+	if (rmt) {
+		/* write table to chip */
+		for (i = 0; i < NUM_MAP_REGS; i++)
+			write_csr(dd, RCV_RSM_MAP_TABLE + (8 * i), rmt->map[i]);
+
+		/* enable RSM */
+		add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
+	}
+}
+
 /**
  * init_qos - init RX qos
  * @dd - device data
+ * @rmt - RSM map table
  *
  * This routine initializes Rule 0 and the RSM map table to implement
  * quality of service (qos).
@@ -13435,16 +13480,16 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
  * The number of vl bits (n) and the number of qpn bits (m) are computed to
  * feed both the RSM map table and the single rule.
  */
-static void init_qos(struct hfi1_devdata *dd)
+static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 {
 	u8 max_by_vl = 0;
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
-	u64 *rsmmap;
+	unsigned int rmt_entries;
 	u64 reg;
-	u8  rxcontext = is_ax(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
 
 	/* validate */
-	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	if (!rmt ||
+	    dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
 	    num_vls == 1 ||
 	    krcvqsset <= 1)
 		goto bail;
@@ -13460,11 +13505,11 @@ static void init_qos(struct hfi1_devdata *dd)
 	m = ilog2(qpns_per_vl);
 	if ((m + n) > 7)
 		goto bail;
-	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
-	if (!rsmmap)
+	/* enough room in the map table? */
+	rmt_entries = 1 << (m + n);
+	if (rmt->used + rmt_entries >= NUM_MAP_ENTRIES)
 		goto bail;
-	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
-	/* init the local copy of the table */
+	/* add qos entries to the the RSM map table */
 	for (i = 0, ctxt = FIRST_KERNEL_KCTXT; i < num_vls; i++) {
 		unsigned tctxt;
 
@@ -13472,26 +13517,24 @@ static void init_qos(struct hfi1_devdata *dd)
 		     krcvqs[i] && qpn < qpns_per_vl; qpn++) {
 			unsigned idx, regoff, regidx;
 
-			/* generate index <= 128 */
-			idx = (qpn << n) ^ i;
+			/* generate the index the hardware will produce */
+			idx = rmt->used + ((qpn << n) ^ i);
 			regoff = (idx % 8) * 8;
 			regidx = idx / 8;
-			reg = rsmmap[regidx];
-			/* replace 0xff with context number */
+			/* replace default with context number */
+			reg = rmt->map[regidx];
 			reg &= ~(RCV_RSM_MAP_TABLE_RCV_CONTEXT_A_MASK
 				<< regoff);
 			reg |= (u64)(tctxt++) << regoff;
-			rsmmap[regidx] = reg;
+			rmt->map[regidx] = reg;
 			if (tctxt == ctxt + krcvqs[i])
 				tctxt = ctxt;
 		}
 		ctxt += krcvqs[i];
 	}
-	/* flush cached copies to chip */
-	for (i = 0; i < NUM_MAP_REGS; i++)
-		write_csr(dd, RCV_RSM_MAP_TABLE + (8 * i), rsmmap[i]);
 	/* add rule0 */
 	write_csr(dd, RCV_RSM_CFG /* + (8 * 0) */,
+		  (u64)rmt->used << RCV_RSM_CFG_OFFSET_SHIFT |
 		  RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK <<
 			RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT |
 		  2ull << RCV_RSM_CFG_PACKET_TYPE_SHIFT);
@@ -13507,9 +13550,8 @@ static void init_qos(struct hfi1_devdata *dd)
 		  LRH_BTH_VALUE << RCV_RSM_MATCH_VALUE1_SHIFT |
 		  LRH_SC_MASK << RCV_RSM_MATCH_MASK2_SHIFT |
 		  LRH_SC_VALUE << RCV_RSM_MATCH_VALUE2_SHIFT);
-	/* Enable RSM */
-	add_rcvctrl(dd, RCV_CTRL_RCV_RSM_ENABLE_SMASK);
-	kfree(rsmmap);
+	/* mark RSM map entries as used */
+	rmt->used += rmt_entries;
 	/* map everything else to the mcast/err/vl15 context */
 	init_qpmap_table(dd, HFI1_CTRL_CTXT, HFI1_CTRL_CTXT);
 	dd->qos_shift = n + 1;
@@ -13521,10 +13563,17 @@ bail:
 
 static void init_rxe(struct hfi1_devdata *dd)
 {
+	struct rsm_map_table *rmt;
+
 	/* enable all receive errors */
 	write_csr(dd, RCV_ERR_MASK, ~0ull);
-	/* setup QPN map table - start where VL15 context leaves off */
-	init_qos(dd);
+
+	rmt = alloc_rsm_map_table(dd);
+	/* set up QOS, including the QPN map table */
+	init_qos(dd, rmt);
+	complete_rsm_map_table(dd, rmt);
+	kfree(rmt);
+
 	/*
 	 * make sure RcvCtrl.RcvWcb <= PCIe Device Control
 	 * Register Max_Payload_Size (PCI_EXP_DEVCTL in Linux PCIe config
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index 770f05c..8744de6 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -771,6 +771,7 @@
 #define RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_MASK 0x1ull
 #define RCV_RSM_CFG_ENABLE_OR_CHAIN_RSM0_SHIFT 0
 #define RCV_RSM_CFG_PACKET_TYPE_SHIFT 60
+#define RCV_RSM_CFG_OFFSET_SHIFT 32
 #define RCV_RSM_MAP_TABLE (RXE + 0x000000000900)
 #define RCV_RSM_MAP_TABLE_RCV_CONTEXT_A_MASK 0xFFull
 #define RCV_RSM_MATCH (RXE + 0x000000000800)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
