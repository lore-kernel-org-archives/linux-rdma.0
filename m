From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/24] IB/qib: Add a few new SERDES tunings
Date: Tue, 28 Dec 2010 10:28:03 -0500
Message-ID: <20101228152803.19960.60746.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add new SERDES tuning to aid manufacturing.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index d23297a..a9c8c72 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -562,6 +562,7 @@ static void write_tx_serdes_param(struct qib_pportdata *, struct txdds_ent *);
 
 #define TXDDS_TABLE_SZ 16 /* number of entries per speed in onchip table */
 #define TXDDS_EXTRA_SZ 13 /* number of extra tx settings entries */
+#define TXDDS_MFG_SZ 2    /* number of mfg tx settings entries */
 #define SERDES_CHANS 4 /* yes, it's obvious, but one less magic number */
 
 #define H1_FORCE_VAL 8
@@ -5623,6 +5624,7 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 	u32 pidx, unit, port, deflt, h1;
 	unsigned long val;
 	int any = 0, seth1;
+	int txdds_size;
 
 	str = txselect_list;
 
@@ -5631,6 +5633,10 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 	for (pidx = 0; pidx < dd->num_pports; ++pidx)
 		dd->pport[pidx].cpspec->no_eep = deflt;
 
+	txdds_size = TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ;
+	if (IS_QME(dd) || IS_QMH(dd))
+		txdds_size += TXDDS_MFG_SZ;
+
 	while (*nxt && nxt[1]) {
 		str = ++nxt;
 		unit = simple_strtoul(str, &nxt, 0);
@@ -5653,7 +5659,7 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 				;
 			continue;
 		}
-		if (val >= TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ)
+		if (val >= txdds_size)
 			continue;
 		seth1 = 0;
 		h1 = 0; /* gcc thinks it might be used uninitted */
@@ -5705,10 +5711,11 @@ static int setup_txselect(const char *str, struct kernel_param *kp)
 		return -ENOSPC;
 	}
 	val = simple_strtoul(str, &n, 0);
-	if (n == str || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ)) {
+	if (n == str || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
+				TXDDS_MFG_SZ)) {
 		printk(KERN_INFO QIB_DRV_NAME
 		       "txselect_values must start with a number < %d\n",
-			TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ);
+			TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ + TXDDS_MFG_SZ);
 		return -EINVAL;
 	}
 	strcpy(txselect_list, str);
@@ -7039,6 +7046,12 @@ static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
 	{  0, 1,  0, 12 },	/* QMH7342 backplane settings */
 };
 
+static const struct txdds_ent txdds_extra_mfg[TXDDS_MFG_SZ] = {
+	/* amp, pre, main, post */
+	{ 0, 0, 0, 0 },         /* QME7342 mfg settings */
+	{ 0, 0, 0, 6 },         /* QME7342 P2 mfg settings */
+};
+
 static const struct txdds_ent *get_atten_table(const struct txdds_ent *txdds,
 					       unsigned atten)
 {
@@ -7112,6 +7125,16 @@ static void find_best_ent(struct qib_pportdata *ppd,
 		*sdr_dds = &txdds_extra_sdr[idx];
 		*ddr_dds = &txdds_extra_ddr[idx];
 		*qdr_dds = &txdds_extra_qdr[idx];
+	} else if ((IS_QME(ppd->dd) || IS_QMH(ppd->dd)) &&
+		   ppd->cpspec->no_eep < (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
+					  TXDDS_MFG_SZ)) {
+		idx = ppd->cpspec->no_eep - (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ);
+		printk(KERN_INFO QIB_DRV_NAME
+			" IB%u:%u use idx %u into txdds_mfg\n",
+			ppd->dd->unit, ppd->port, idx);
+		*sdr_dds = &txdds_extra_mfg[idx];
+		*ddr_dds = &txdds_extra_mfg[idx];
+		*qdr_dds = &txdds_extra_mfg[idx];
 	} else {
 		/* this shouldn't happen, it's range checked */
 		*sdr_dds = txdds_sdr + qib_long_atten;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
