From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: use a single txselect module parameter for serdes
	tuning
Date: Wed, 26 May 2010 16:08:44 -0700
Message-ID: <20100526230844.16584.31444.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As part of the earlier patches submitted and reviewed, it was agreed
to change the way serdes tuning parameters were specified to the
driver. The updated patch got dropped by the linux-rdma email list
so the earlier version of qib_iba7322.c was integrated.
This patch updates qib_iab7322.c with the simpler, single parameter
method of setting the serdes parameters.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba7322.c |  582 ++++++++++---------------------
 1 files changed, 179 insertions(+), 403 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 2c24eab..23fb9ef 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -114,40 +114,18 @@ static ushort qib_singleport;
 module_param_named(singleport, qib_singleport, ushort, S_IRUGO);
 MODULE_PARM_DESC(singleport, "Use only IB port 1; more per-port buffer space");
 
-
-/*
- * Setup QMH7342 receive and transmit parameters, necessary because
- * each bay, Mez connector, and IB port need different tuning, beyond
- * what the switch and HCA can do automatically.
- * It's expected to be done by cat'ing files to the modules file,
- * rather than setting up as a module parameter.
- * It's a "write-only" file, returns 0 when read back.
- * The unit, port, bay (if given), and values MUST be done as a single write.
- * The unit, port, and bay must precede the values to be effective.
- */
-static int setup_qmh_params(const char *, struct kernel_param *);
-static unsigned dummy_qmh_params;
-module_param_call(qmh_serdes_setup, setup_qmh_params, param_get_uint,
-		  &dummy_qmh_params, S_IWUSR | S_IRUGO);
-
-/* similarly for QME7342, but it's simpler */
-static int setup_qme_params(const char *, struct kernel_param *);
-static unsigned dummy_qme_params;
-module_param_call(qme_serdes_setup, setup_qme_params, param_get_uint,
-		  &dummy_qme_params, S_IWUSR | S_IRUGO);
-
 #define MAX_ATTEN_LEN 64 /* plenty for any real system */
 /* for read back, default index is ~5m copper cable */
-static char cable_atten_list[MAX_ATTEN_LEN] = "10";
-static struct kparam_string kp_cable_atten = {
-	.string = cable_atten_list,
+static char txselect_list[MAX_ATTEN_LEN] = "10";
+static struct kparam_string kp_txselect = {
+	.string = txselect_list,
 	.maxlen = MAX_ATTEN_LEN
 };
-static int  setup_cable_atten(const char *, struct kernel_param *);
-module_param_call(cable_atten, setup_cable_atten, param_get_string,
-		  &kp_cable_atten, S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(cable_atten, \
-		 "cable attenuation indices for cables with invalid EEPROM");
+static int  setup_txselect(const char *, struct kernel_param *);
+module_param_call(txselect, setup_txselect, param_get_string,
+		  &kp_txselect, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(txselect, \
+		 "Tx serdes indices (for no QSFP or invalid QSFP data)");
 
 #define BOARD_QME7342 5
 #define BOARD_QMH7342 6
@@ -574,11 +552,12 @@ struct vendor_txdds_ent {
 static void write_tx_serdes_param(struct qib_pportdata *, struct txdds_ent *);
 
 #define TXDDS_TABLE_SZ 16 /* number of entries per speed in onchip table */
+#define TXDDS_EXTRA_SZ 11 /* number of extra tx settings entries */
 #define SERDES_CHANS 4 /* yes, it's obvious, but one less magic number */
 
 #define H1_FORCE_VAL 8
-#define H1_FORCE_QME 1 /*  may be overridden via setup_qme_params() */
-#define H1_FORCE_QMH 7 /*  may be overridden via setup_qmh_params() */
+#define H1_FORCE_QME 1 /*  may be overridden via setup_txselect() */
+#define H1_FORCE_QMH 7 /*  may be overridden via setup_txselect() */
 
 /* The static and dynamic registers are paired, and the pairs indexed by spd */
 #define krp_static_adapt_dis(spd) (KREG_IBPORT_IDX(ADAPT_DISABLE_STATIC_SDR) \
@@ -590,15 +569,6 @@ static void write_tx_serdes_param(struct qib_pportdata *, struct txdds_ent *);
 #define QDR_STATIC_ADAPT_INIT 0xffffffffffULL /* up, disable H0,H1-8, LE */
 #define QDR_STATIC_ADAPT_INIT_R1 0xf0ffffffffULL /* r1 up, disable H0,H1-8 */
 
-static const struct txdds_ent qmh_sdr_txdds =  { 11, 0,  5,  6 };
-static const struct txdds_ent qmh_ddr_txdds =  {  7, 0,  2,  8 };
-static const struct txdds_ent qmh_qdr_txdds =  {  0, 1,  3, 10 };
-
-/* this is used for unknown mez cards also */
-static const struct txdds_ent qme_sdr_txdds =  { 11, 0,  4,  4 };
-static const struct txdds_ent qme_ddr_txdds =  {  7, 0,  2,  7 };
-static const struct txdds_ent qme_qdr_txdds =  {  0, 1, 12, 11 };
-
 struct qib_chippport_specific {
 	u64 __iomem *kpregbase;
 	u64 __iomem *cpregbase;
@@ -637,12 +607,8 @@ struct qib_chippport_specific {
 	 * Per-bay per-channel rcv QMH H1 values and Tx values for QDR.
 	 * entry zero is unused, to simplify indexing
 	 */
-	u16 h1_val;
-	u8 amp[SERDES_CHANS];
-	u8 pre[SERDES_CHANS];
-	u8 mainv[SERDES_CHANS];
-	u8 post[SERDES_CHANS];
-	u8 no_eep;  /* attenuation index to use if no qsfp info */
+	u8 h1_val;
+	u8 no_eep;  /* txselect table index to use if no qsfp info */
 	u8 ipg_tries;
 	u8 ibmalfusesnap;
 	struct qib_qsfp_data qsfp_data;
@@ -5360,7 +5326,13 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 				     QIBL_IB_AUTONEG_INPROG)))
 			set_7322_ibspeed_fast(ppd, ppd->link_speed_enabled);
 		if (!(ppd->lflags & QIBL_IB_AUTONEG_INPROG)) {
+			/* unlock the Tx settings, speed may change */
+			qib_write_kreg_port(ppd, krp_tx_deemph_override,
+				SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+				reset_tx_deemphasis_override));
 			qib_cancel_sends(ppd);
+			/* on link down, ensure sane pcs state */
+			qib_7322_mini_pcs_reset(ppd);
 			spin_lock_irqsave(&ppd->sdma_lock, flags);
 			if (__qib_sdma_running(ppd))
 				__qib_sdma_process_event(ppd,
@@ -5766,26 +5738,28 @@ static void qib_init_7322_qsfp(struct qib_pportdata *ppd)
 }
 
 /*
- * called at device initialization time, and also if the cable_atten
+ * called at device initialization time, and also if the txselect
  * module parameter is changed.  This is used for cables that don't
  * have valid QSFP EEPROMs (not present, or attenuation is zero).
  * We initialize to the default, then if there is a specific
- * unit,port match, we use that.
+ * unit,port match, we use that (and set it immediately, for the
+ * current speed, if the link is at INIT or better).
  * String format is "default# unit#,port#=# ... u,p=#", separators must
- * be a SPACE character.  A newline terminates.
+ * be a SPACE character.  A newline terminates.  The u,p=# tuples may
+ * optionally have "u,p=#,#", where the final # is the H1 value
  * The last specific match is used (actually, all are used, but last
  * one is the one that winds up set); if none at all, fall back on default.
  */
 static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 {
 	char *nxt, *str;
-	int pidx, unit, port, deflt;
+	u32 pidx, unit, port, deflt, h1;
 	unsigned long val;
-	int any = 0;
+	int any = 0, seth1;
 
-	str = cable_atten_list;
+	str = txselect_list;
 
-	/* default number is validated in setup_cable_atten() */
+	/* default number is validated in setup_txselect() */
 	deflt = simple_strtoul(str, &nxt, 0);
 	for (pidx = 0; pidx < dd->num_pports; ++pidx)
 		dd->pport[pidx].cpspec->no_eep = deflt;
@@ -5812,16 +5786,28 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 				;
 			continue;
 		}
-		if (val >= TXDDS_TABLE_SZ)
+		if (val >= TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ)
 			continue;
+		seth1 = 0;
+		h1 = 0; /* gcc thinks it might be used uninitted */
+		if (*nxt == ',' && nxt[1]) {
+			str = ++nxt;
+			h1 = (u32)simple_strtoul(str, &nxt, 0);
+			if (nxt == str)
+				while (*nxt && *nxt++ != ' ') /* skip */
+					;
+			else
+				seth1 = 1;
+		}
 		for (pidx = 0; dd->unit == unit && pidx < dd->num_pports;
 		     ++pidx) {
-			if (dd->pport[pidx].port != port ||
-				!dd->pport[pidx].link_speed_supported)
+			struct qib_pportdata *ppd = &dd->pport[pidx];
+
+			if (ppd->port != port || !ppd->link_speed_supported)
 				continue;
-			dd->pport[pidx].cpspec->no_eep = val;
+			ppd->cpspec->no_eep = val;
 			/* now change the IBC and serdes, overriding generic */
-			init_txdds_table(&dd->pport[pidx], 1);
+			init_txdds_table(ppd, 1);
 			any++;
 		}
 		if (*nxt == '\n')
@@ -5832,35 +5818,35 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 		 * Change the IBC and serdes, but since it's
 		 * general, don't override specific settings.
 		 */
-		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-			if (!dd->pport[pidx].link_speed_supported)
-				continue;
-			init_txdds_table(&dd->pport[pidx], 0);
-		}
+		for (pidx = 0; pidx < dd->num_pports; ++pidx)
+			if (dd->pport[pidx].link_speed_supported)
+				init_txdds_table(&dd->pport[pidx], 0);
 	}
 }
 
-/* handle the cable_atten parameter changing */
-static int setup_cable_atten(const char *str, struct kernel_param *kp)
+/* handle the txselect parameter changing */
+static int setup_txselect(const char *str, struct kernel_param *kp)
 {
 	struct qib_devdata *dd;
 	unsigned long val;
 	char *n;
 	if (strlen(str) >= MAX_ATTEN_LEN) {
-		printk(KERN_INFO QIB_DRV_NAME " cable_atten_values string "
+		printk(KERN_INFO QIB_DRV_NAME " txselect_values string "
 		       "too long\n");
 		return -ENOSPC;
 	}
 	val = simple_strtoul(str, &n, 0);
-	if (n == str || val >= TXDDS_TABLE_SZ) {
+	if (n == str || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ)) {
 		printk(KERN_INFO QIB_DRV_NAME
-		       "cable_atten_values must start with a number\n");
+		       "txselect_values must start with a number < %d\n",
+			TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ);
 		return -EINVAL;
 	}
-	strcpy(cable_atten_list, str);
+	strcpy(txselect_list, str);
 
 	list_for_each_entry(dd, &qib_dev_list, list)
-		set_no_qsfp_atten(dd, 1);
+		if (dd->deviceid == PCI_DEVICE_ID_QLOGIC_IB_7322)
+			set_no_qsfp_atten(dd, 1);
 	return 0;
 }
 
@@ -6261,28 +6247,17 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		 * in adapter-specific routines.
 		 */
 		if (!(ppd->dd->flags & QIB_HAS_QSFP)) {
-			int i;
-			const struct txdds_ent *txdds;
-
 			if (!IS_QMH(ppd->dd) && !IS_QME(ppd->dd))
 				qib_devinfo(ppd->dd->pcidev, "IB%u:%u: "
 					    "Unknown mezzanine card type\n",
-					    ppd->dd->unit, ppd->port);
-			txdds = IS_QMH(ppd->dd) ? &qmh_qdr_txdds :
-				&qme_qdr_txdds;
-
+					    dd->unit, ppd->port);
+			cp->h1_val = IS_QMH(dd) ? H1_FORCE_QMH : H1_FORCE_QME;
 			/*
-			 * set values in case link comes up
-			 * before table is written to driver.
+			 * Choose center value as default tx serdes setting
+			 * until changed through module parameter.
 			 */
-			cp->h1_val = IS_QMH(ppd->dd) ? H1_FORCE_QMH :
-				H1_FORCE_QME;
-			for (i = 0; i < SERDES_CHANS; i++) {
-				cp->amp[i] = txdds->amp;
-				cp->pre[i] = txdds->pre;
-				cp->mainv[i] = txdds->main;
-				cp->post[i] = txdds->post;
-			}
+			ppd->cpspec->no_eep = IS_QMH(dd) ?
+				TXDDS_TABLE_SZ + 2 : TXDDS_TABLE_SZ + 4;
 		} else
 			cp->h1_val = H1_FORCE_VAL;
 
@@ -6299,8 +6274,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 
 	dd->rcvhdrentsize = QIB_RCVHDR_ENTSIZE;
 	dd->rcvhdrsize = QIB_DFLT_RCVHDRSIZE;
-	dd->rhf_offset =
-		dd->rcvhdrentsize - sizeof(u64) / sizeof(u32);
+	dd->rhf_offset = dd->rcvhdrentsize - sizeof(u64) / sizeof(u32);
 
 	/* we always allocate at least 2048 bytes for eager buffers */
 	dd->rcvegrbufsize = max(mtu, 2048);
@@ -7111,8 +7085,8 @@ static const struct txdds_ent txdds_ddr[TXDDS_TABLE_SZ] = {
 static const struct txdds_ent txdds_qdr[TXDDS_TABLE_SZ] = {
 	/* amp, pre, main, post */
 	{  2, 2, 15,  6 },	/* Loopback */
-	{  0, 1,  0,  7 },	/*  2 dB */
-	{  0, 1,  0,  9 },	/*  3 dB */
+	{  0, 1,  0,  7 },	/*  2 dB (also QMH7342) */
+	{  0, 1,  0,  9 },	/*  3 dB (also QMH7342) */
 	{  0, 1,  0, 11 },	/*  4 dB */
 	{  0, 1,  0, 13 },	/*  5 dB */
 	{  0, 1,  0, 15 },	/*  6 dB */
@@ -7128,6 +7102,57 @@ static const struct txdds_ent txdds_qdr[TXDDS_TABLE_SZ] = {
 	{  0, 2,  9, 15 },	/* 16 dB */
 };
 
+/*
+ * extra entries for use with txselect, for indices >= TXDDS_TABLE_SZ.
+ * These are mostly used for mez cards going through connectors
+ * and backplane traces, but can be used to add other "unusual"
+ * table values as well.
+ */
+static const struct txdds_ent txdds_extra_sdr[TXDDS_EXTRA_SZ] = {
+	/* amp, pre, main, post */
+	{  0, 0, 0,  1 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  1 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  2 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  2 },	/* QMH7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+};
+
+static const struct txdds_ent txdds_extra_ddr[TXDDS_EXTRA_SZ] = {
+	/* amp, pre, main, post */
+	{  0, 0, 0,  7 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  7 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  8 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  8 },	/* QMH7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+};
+
+static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
+	/* amp, pre, main, post */
+	{  0, 1,  0,  4 },	/* QMH7342 backplane settings */
+	{  0, 1,  0,  5 },	/* QMH7342 backplane settings */
+	{  0, 1,  0,  6 },	/* QMH7342 backplane settings */
+	{  0, 1,  0,  8 },	/* QMH7342 backplane settings */
+	{  0, 1, 12, 10 },	/* QME7342 backplane setting */
+	{  0, 1, 12, 11 },	/* QME7342 backplane setting */
+	{  0, 1, 12, 12 },	/* QME7342 backplane setting */
+	{  0, 1, 12, 14 },	/* QME7342 backplane setting */
+	{  0, 1, 12,  6 },	/* QME7342 backplane setting */
+	{  0, 1, 12,  7 },	/* QME7342 backplane setting */
+	{  0, 1, 12,  8 },	/* QME7342 backplane setting */
+};
+
 static const struct txdds_ent *get_atten_table(const struct txdds_ent *txdds,
 					       unsigned atten)
 {
@@ -7145,7 +7170,7 @@ static const struct txdds_ent *get_atten_table(const struct txdds_ent *txdds,
 }
 
 /*
- * if override is set, the module parameter cable_atten has a value
+ * if override is set, the module parameter txselect has a value
  * for this specific port, so use it, rather than our normal mechanism.
  */
 static void find_best_ent(struct qib_pportdata *ppd,
@@ -7184,15 +7209,28 @@ static void find_best_ent(struct qib_pportdata *ppd,
 		*ddr_dds = get_atten_table(txdds_ddr, qd->atten[0]);
 		*qdr_dds = get_atten_table(txdds_qdr, qd->atten[1]);
 		return;
-	} else {
+	} else if (ppd->cpspec->no_eep < TXDDS_TABLE_SZ) {
 		/*
 		 * If we have no (or incomplete) data from the cable
-		 * EEPROM, or no QSFP, use the module parameter value
-		 * to index into the attentuation table.
+		 * EEPROM, or no QSFP, or override is set, use the
+		 * module parameter value to index into the attentuation
+		 * table.
 		 */
-		*sdr_dds = &txdds_sdr[ppd->cpspec->no_eep];
-		*ddr_dds = &txdds_ddr[ppd->cpspec->no_eep];
-		*qdr_dds = &txdds_qdr[ppd->cpspec->no_eep];
+		idx = ppd->cpspec->no_eep;
+		*sdr_dds = &txdds_sdr[idx];
+		*ddr_dds = &txdds_ddr[idx];
+		*qdr_dds = &txdds_qdr[idx];
+	} else if (ppd->cpspec->no_eep < (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ)) {
+		/* similar to above, but index into the "extra" table. */
+		idx = ppd->cpspec->no_eep - TXDDS_TABLE_SZ;
+		*sdr_dds = &txdds_extra_sdr[idx];
+		*ddr_dds = &txdds_extra_ddr[idx];
+		*qdr_dds = &txdds_extra_qdr[idx];
+	} else {
+		/* this shouldn't happen, it's range checked */
+		*sdr_dds = txdds_sdr + qib_long_atten;
+		*ddr_dds = txdds_ddr + qib_long_atten;
+		*qdr_dds = txdds_qdr + qib_long_atten;
 	}
 }
 
@@ -7203,33 +7241,24 @@ static void init_txdds_table(struct qib_pportdata *ppd, int override)
 	int idx;
 	int single_ent = 0;
 
-	if (IS_QMH(ppd->dd)) {
-		/* normally will be overridden, via setup_qmh() */
-		sdr_dds = &qmh_sdr_txdds;
-		ddr_dds = &qmh_ddr_txdds;
-		qdr_dds = &qmh_qdr_txdds;
-		single_ent = 1;
-	} else if (IS_QME(ppd->dd)) {
-		sdr_dds = &qme_sdr_txdds;
-		ddr_dds = &qme_ddr_txdds;
-		qdr_dds = &qme_qdr_txdds;
+	find_best_ent(ppd, &sdr_dds, &ddr_dds, &qdr_dds, override);
+
+	/* for mez cards or override, use the selected value for all entries */
+	if (!(ppd->dd->flags & QIB_HAS_QSFP) || override)
 		single_ent = 1;
-	} else
-		find_best_ent(ppd, &sdr_dds, &ddr_dds, &qdr_dds, override);
 
 	/* Fill in the first entry with the best entry found. */
 	set_txdds(ppd, 0, sdr_dds);
 	set_txdds(ppd, TXDDS_TABLE_SZ, ddr_dds);
 	set_txdds(ppd, 2 * TXDDS_TABLE_SZ, qdr_dds);
-
-	/*
-	 * for our current speed, also write that value into the
-	 * tx serdes registers.
-	 */
-	dds = (struct txdds_ent *)(ppd->link_speed_active == QIB_IB_QDR ?
-				   qdr_dds : (ppd->link_speed_active ==
-					      QIB_IB_DDR ? ddr_dds : sdr_dds));
-	write_tx_serdes_param(ppd, dds);
+	if (ppd->lflags & (QIBL_LINKINIT | QIBL_LINKARMED |
+		QIBL_LINKACTIVE)) {
+		dds = (struct txdds_ent *)(ppd->link_speed_active ==
+					   QIB_IB_QDR ?  qdr_dds :
+					   (ppd->link_speed_active ==
+					    QIB_IB_DDR ? ddr_dds : sdr_dds));
+		write_tx_serdes_param(ppd, dds);
+	}
 
 	/* Fill in the remaining entries with the default table values. */
 	for (idx = 1; idx < ARRAY_SIZE(txdds_sdr); ++idx) {
@@ -7352,6 +7381,11 @@ static int serdes_7322_init(struct qib_pportdata *ppd)
 	 */
 	init_txdds_table(ppd, 0);
 
+	/* ensure no tx overrides from earlier driver loads */
+	qib_write_kreg_port(ppd, krp_tx_deemph_override,
+		SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		reset_tx_deemphasis_override));
+
 	/* Patch some SerDes defaults to "Better for IB" */
 	/* Timing Loop Bandwidth: cdr_timing[11:9] = 0 */
 	ibsd_wr_allchans(ppd, 2, 0, BMASK(11, 9));
@@ -7421,7 +7455,7 @@ static int serdes_7322_init(struct qib_pportdata *ppd)
 			    QDR_STATIC_ADAPT_DOWN_R1 : QDR_STATIC_ADAPT_DOWN);
 	ppd->cpspec->qdr_dfe_on = 1;
 
-	/* (FLoop LOS gate: PPM filter  enabled */
+	/* FLoop LOS gate: PPM filter  enabled */
 	ibsd_wr_allchans(ppd, 38, 0 << 10, 1 << 10);
 
 	/* rx offset center enabled */
@@ -7486,68 +7520,39 @@ static void write_tx_serdes_param(struct qib_pportdata *ppd,
 		    SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0, txc0_ena) |
 		    SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0, txcp1_ena) |
 		    SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0, txcn1_ena));
-	deemph |= 1ULL << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-				  tx_override_deemphasis_select);
-	deemph |= txdds->amp << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-				    txampcntl_d2a);
-	deemph |= txdds->main << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-				      txc0_ena);
-	deemph |= txdds->post << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-				     txcp1_ena);
-	deemph |= txdds->pre << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+
+	deemph |= SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+			   tx_override_deemphasis_select);
+	deemph |= (txdds->amp & SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		    txampcntl_d2a)) << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+				       txampcntl_d2a);
+	deemph |= (txdds->main & SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		     txc0_ena)) << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+				   txc0_ena);
+	deemph |= (txdds->post & SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		     txcp1_ena)) << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+				    txcp1_ena);
+	deemph |= (txdds->pre & SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		     txcn1_ena)) << SYM_LSB(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
 				    txcn1_ena);
 	qib_write_kreg_port(ppd, krp_tx_deemph_override, deemph);
 }
 
 /*
- * set per-bay, per channel parameters.  For now, we ignore
- * do_tx, and always set tx parameters, and set them with the same value
- * for all channels, using the channel 0 value.   We may switch to
- * per-channel settings in the future, and that method only needs
- * to be done once.
- * Because this also writes the IBC txdds table with a single set
- * of values, it should be called only for cases where we want to completely
- * force a specific setting, typically only for mez cards.
+ * Set the parameters for mez cards on link bounce, so they are
+ * always exactly what was requested.  Similar logic to init_txdds
+ * but does just the serdes.
  */
 static void adj_tx_serdes(struct qib_pportdata *ppd)
 {
-	struct txdds_ent txdds;
-	int i;
-	u8 *amp, *pre, *mainv, *post;
-
-	/*
-	 * Because we use TX_DEEMPHASIS_OVERRIDE, we need to
-	 * always do tx side, just like H1, since it is cleared
-	 * by link down
-	 */
-	amp = ppd->cpspec->amp;
-	pre = ppd->cpspec->pre;
-	mainv = ppd->cpspec->mainv;
-	post = ppd->cpspec->post;
-
-	amp[0] &= SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-			    txampcntl_d2a);
-	mainv[0] &= SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-			      txc0_ena);
-	post[0] &= SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-			     txcp1_ena);
-	pre[0] &= SYM_RMASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
-			    txcn1_ena);
-
-	/*
-	 * Use the channel zero values, only, for now, for
-	 * all channels
-	*/
-	txdds.amp = amp[0];
-	txdds.pre = pre[0];
-	txdds.main = mainv[0];
-	txdds.post = post[0];
-
-	/* write the QDR table for IBC use, as backup for link down */
-	for (i = 0; i < ARRAY_SIZE(txdds_qdr); ++i)
-		set_txdds(ppd, i + 32, &txdds);
+	const struct txdds_ent *sdr_dds, *ddr_dds, *qdr_dds;
+	struct txdds_ent *dds;
 
-	write_tx_serdes_param(ppd, &txdds);
+	find_best_ent(ppd, &sdr_dds, &ddr_dds, &qdr_dds, 1);
+	dds = (struct txdds_ent *)(ppd->link_speed_active == QIB_IB_QDR ?
+		qdr_dds : (ppd->link_speed_active == QIB_IB_DDR ?
+				ddr_dds : sdr_dds));
+	write_tx_serdes_param(ppd, dds);
 }
 
 /* set QDR forced value for H1, if needed */
@@ -7567,235 +7572,6 @@ static void force_h1(struct qib_pportdata *ppd)
 	}
 }
 
-/*
- * Parse the parameters for the QMH7342, to get rx and tx serdes
- * settings for that Bay, for both possible mez connectors (PCIe bus)
- * and IB link (one link on mez1, two possible on mez2).
- *
- * Data is comma or white space separated.
- *
- * A set of data has 7 groups, rx and tx groups have SERDES_CHANS values,
- * one per IB lane (serdes channel).
- * The groups are Bay, bus# H1 rcv, and amp, pre, post, main Tx values (QDR).
- * The Bay # is used only for debugging currently.
- * H1 values are set whenever the link goes down, or is at cfg_test or
- * cfg_wait_enh.  Tx values are programmed once, when this routine is called
- * (and with default values at chip initialization).  Values are any base, in
- * strtoul style, and values are seperated by comma, or any white space
- * (space, tab, newline).
- *
- * An example set might look like this (white space vs
- * comma used for human ease of reading)
- * The ordering is a set of Bay# Bus# H1, amp, pre, post, and main for mez1 IB1,
- * repeat for mez2 IB1, then mez2 IB2.
- *
- * B B H1:0       amp:0       pre:0        post: 0        main:0
- * a u H1:  1     amp:  1     pre:  1      post:   1      main:  1
- * y s H1:    2   amp:    2   pre:    2    post:      2   main:    2
- *     H1:      4 amp:      3 pre:      3  post:        3 main:      3
- * 1 3    8,6,5,6     0,0,0,0     1,1,1,1       10,10,10,10    3,3,3,3
- * 1 6    7,6,6,7     0,0,0,0     1,1,1,1       10,10,10,10    3,3,3,3
- * 1 6    9,7,7,8     0,0,0,0     1,1,1,1       10,10,10,10    3,3,3,3
- */
-#define N_QMH_FIELDS 22
-static int setup_qmh_params(const char *str, struct kernel_param *kp)
-{
-	char *abuf, *v, *nv, *nvp;
-	struct qib_devdata *dd;
-	struct qib_pportdata *ppd;
-	u32 mez, vlen, nf, port, bay;
-	int ret = 0, found = 0;
-
-	vlen = strlen(str) + 1;
-	abuf = kmalloc(vlen, GFP_KERNEL);
-	if (!abuf) {
-		printk(KERN_INFO QIB_DRV_NAME
-		       " Unable to allocate QMH param buffer; ignoring\n");
-		return 0;
-	}
-	memcpy(abuf, str, vlen);
-	v = abuf;
-
-	/* these 3 are because gcc can't know they are set before used */
-	port = 1;
-	mez = 1; /* used only for debugging */
-	bay = 0; /* used only for debugging */
-	ppd = NULL;
-	for (nf = 0; (nv = strsep(&v, ", \t\n\r")) &&
-	     nf < (N_QMH_FIELDS * 3);) {
-		u32 val;
-
-		if (!*nv)
-			/* allow for multiple separators */
-			continue;
-
-		val = simple_strtoul(nv, &nvp, 0);
-		if (nv == nvp) {
-			printk(KERN_INFO QIB_DRV_NAME
-			       " Bay%u, mez%u IB%u non-numeric value (%s) "
-			       "field #%u, ignoring rest\n", bay, mez,
-			       port, nv, nf % (N_QMH_FIELDS * 3));
-			ret = -EINVAL;
-			goto bail;
-		}
-		if (!(nf % N_QMH_FIELDS)) {
-			ppd = NULL;
-			bay = val;
-			if (!bay || bay > 16) {
-				printk(KERN_INFO QIB_DRV_NAME
-				       " Invalid bay # %u, field %u, "
-				       "ignoring rest\n", bay, nf);
-				ret = -EINVAL;
-				goto bail;
-			}
-		} else if ((nf % N_QMH_FIELDS) == 1) {
-			u32 bus = val;
-			if (nf == 1) {
-				mez = 1;
-				port = 1;
-			} else if (nf == (N_QMH_FIELDS + 1)) {
-				mez = 2;
-				port = 1;
-			} else {
-				mez = 2;
-				port = 2;
-			}
-			list_for_each_entry(dd, &qib_dev_list, list) {
-				if (dd->deviceid != PCI_DEVICE_ID_QLOGIC_IB_7322
-				    || !IS_QMH(dd))
-					continue; /* only for QMH cards */
-				if (dd->pcidev->bus->number == bus) {
-					found++;
-					ppd = &dd->pport[port - 1];
-				}
-			}
-		} else if (ppd) {
-			u32 parm = (nf % N_QMH_FIELDS) - 2;
-			if (parm < SERDES_CHANS && !(parm % SERDES_CHANS))
-				ppd->cpspec->h1_val = val;
-			else if (parm < (2 * SERDES_CHANS))
-				ppd->cpspec->amp[parm % SERDES_CHANS] = val;
-			else if (parm < (3 * SERDES_CHANS))
-				ppd->cpspec->pre[parm % SERDES_CHANS] = val;
-			else if (parm < (4 * SERDES_CHANS))
-				ppd->cpspec->post[parm % SERDES_CHANS] = val;
-			else {
-				ppd->cpspec->mainv[parm % SERDES_CHANS] = val;
-				/* At the end of a port, set params */
-				if (parm == ((5 * SERDES_CHANS) - 1))
-					adj_tx_serdes(ppd);
-			}
-		}
-		nf++;
-	}
-	if (!found) {
-		printk(KERN_ERR QIB_DRV_NAME
-		       ": No match found for qmh_serdes_setup parameter\n");
-		ret = -EINVAL;
-	}
-bail:
-	kfree(abuf);
-	return ret;
-}
-
-/*
- * Similarly for QME7342, but the format is simpler, values are the
- * same for all mez card positions in a blade (2 or 4 per blade), but
- * are different for some blades vs others, and we don't need to
- * specify different parameters for different serdes channels or different
- * IB ports.
- * Format is: h1 amp,pre,post,main
- * Alternate format (so ports can be different): Pport# h1 amp,pre,post,main
- */
-#define N_QME_FIELDS 5
-static int setup_qme_params(const char *str, struct kernel_param *kp)
-{
-	char *abuf, *v, *nv, *nvp;
-	struct qib_devdata *dd;
-	u32 vlen, nf, port = 0;
-	u8 h1, tx[4]; /* amp, pre, post, main */
-	int ret =  -EINVAL;
-	char *seplist;
-
-	vlen = strlen(str) + 1;
-	abuf = kmalloc(vlen, GFP_KERNEL);
-	if (!abuf) {
-		printk(KERN_INFO QIB_DRV_NAME
-		       " Unable to allocate QME param buffer; ignoring\n");
-		return 0;
-	}
-	strncpy(abuf, str, vlen);
-
-	v = abuf;
-	seplist = " \t";
-	h1 = H1_FORCE_QME; /* gcc can't figure out always set before used */
-
-	for (nf = 0; (nv = strsep(&v, seplist)); ) {
-		u32 val;
-
-		if (!*nv)
-			/* allow for multiple separators */
-			continue;
-
-		if (!nf && *nv == 'P') {
-			/* alternate format with port */
-			val = simple_strtoul(++nv, &nvp, 0);
-			if (nv == nvp || port >= NUM_IB_PORTS) {
-				printk(KERN_INFO QIB_DRV_NAME
-				       " %s: non-numeric port value (%s) "
-				       "ignoring rest\n", __func__, nv);
-				goto done;
-			}
-			port = val;
-			continue; /* without incrementing nf */
-		}
-		val = simple_strtoul(nv, &nvp, 0);
-		if (nv == nvp) {
-			printk(KERN_INFO QIB_DRV_NAME
-			       " %s: non-numeric value (%s) "
-			       "field #%u, ignoring rest\n", __func__,
-			       nv, nf);
-			goto done;
-		}
-		if (!nf) {
-			h1 = val;
-			seplist = ",";
-		} else
-			tx[nf - 1] = val;
-		if (++nf == N_QME_FIELDS) {
-			list_for_each_entry(dd, &qib_dev_list, list) {
-				int pidx, i;
-				if (dd->deviceid != PCI_DEVICE_ID_QLOGIC_IB_7322
-				    || !IS_QME(dd))
-					continue; /* only for QME cards */
-				for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-					struct qib_pportdata *ppd;
-					ppd = &dd->pport[pidx];
-					if ((port && ppd->port != port) ||
-						!ppd->link_speed_supported)
-						continue;
-					ppd->cpspec->h1_val = h1;
-					for (i = 0; i < SERDES_CHANS; i++) {
-						ppd->cpspec->amp[i] = tx[0];
-						ppd->cpspec->pre[i] = tx[1];
-						ppd->cpspec->post[i] = tx[2];
-						ppd->cpspec->mainv[i] = tx[3];
-					}
-					adj_tx_serdes(ppd);
-				}
-			}
-			ret = 0;
-			goto done;
-		}
-	}
-	printk(KERN_INFO QIB_DRV_NAME
-	       " %s: Only %u of %u fields provided, skipping\n",
-	       __func__, nf, N_QME_FIELDS);
-done:
-	kfree(abuf);
-	return ret;
-}
-
 #define SJA_EN SYM_MASK(SPC_JTAG_ACCESS_REG, SPC_JTAG_ACCESS_EN)
 #define BISTEN_LSB SYM_LSB(SPC_JTAG_ACCESS_REG, bist_en)
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
