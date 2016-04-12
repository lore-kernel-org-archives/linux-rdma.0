From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/21] IB/hfi1: Move QOS decision logic into its own function
Date: Tue, 12 Apr 2016 11:31:11 -0700
Message-ID: <20160412183103.27773.81216.stgit@scvm10.sc.intel.com>
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

The decision to use QOS affects other resource allocation.
Move the QOS decision logic into its own function so it can
be called by other interested parties.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   67 ++++++++++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 234c078..b2c037c 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13466,6 +13466,50 @@ static void complete_rsm_map_table(struct hfi1_devdata *dd,
 	}
 }
 
+/* return the number of RSM map table entries that will be used for QOS */
+static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+			   unsigned int *np)
+{
+	int i;
+	unsigned int m, n;
+	u8 max_by_vl = 0;
+
+	/* is QOS active at all? */
+	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	    num_vls == 1 ||
+	    krcvqsset <= 1)
+		goto no_qos;
+
+	/* determine bits for qpn */
+	for (i = 0; i < min_t(unsigned int, num_vls, krcvqsset); i++)
+		if (krcvqs[i] > max_by_vl)
+			max_by_vl = krcvqs[i];
+	if (max_by_vl > 32)
+		goto no_qos;
+	m = ilog2(__roundup_pow_of_two(max_by_vl));
+
+	/* determine bits for vl */
+	n = ilog2(__roundup_pow_of_two(num_vls));
+
+	/* reject if too much is used */
+	if ((m + n) > 7)
+		goto no_qos;
+
+	if (mp)
+		*mp = m;
+	if (np)
+		*np = n;
+
+	return 1 << (m + n);
+
+no_qos:
+	if (mp)
+		*mp = 0;
+	if (np)
+		*np = 0;
+	return 0;
+}
+
 /**
  * init_qos - init RX qos
  * @dd - device data
@@ -13482,33 +13526,22 @@ static void complete_rsm_map_table(struct hfi1_devdata *dd,
  */
 static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 {
-	u8 max_by_vl = 0;
 	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
 	unsigned int rmt_entries;
 	u64 reg;
 
-	/* validate */
-	if (!rmt ||
-	    dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
-	    num_vls == 1 ||
-	    krcvqsset <= 1)
-		goto bail;
-	for (i = 0; i < min_t(unsigned, num_vls, krcvqsset); i++)
-		if (krcvqs[i] > max_by_vl)
-			max_by_vl = krcvqs[i];
-	if (max_by_vl > 32)
+	if (!rmt)
 		goto bail;
-	qpns_per_vl = __roundup_pow_of_two(max_by_vl);
-	/* determine bits vl */
-	n = ilog2(__roundup_pow_of_two(num_vls));
-	/* determine bits for qpn */
-	m = ilog2(qpns_per_vl);
-	if ((m + n) > 7)
+	rmt_entries = qos_rmt_entries(dd, &m, &n);
+	if (rmt_entries == 0)
 		goto bail;
+	qpns_per_vl = 1 << m;
+
 	/* enough room in the map table? */
 	rmt_entries = 1 << (m + n);
 	if (rmt->used + rmt_entries >= NUM_MAP_ENTRIES)
 		goto bail;
+
 	/* add qos entries to the the RSM map table */
 	for (i = 0, ctxt = FIRST_KERNEL_KCTXT; i < num_vls; i++) {
 		unsigned tctxt;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
