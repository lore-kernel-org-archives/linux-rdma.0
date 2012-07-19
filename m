From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] IB/qib: Convert krvqs module parameter to per-port
Date: Thu, 19 Jul 2012 09:04:18 -0400
Message-ID: <20120719130418.4706.84425.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120719130356.4706.63775.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert the krcvqs module paratemter from a per-unit
parameter to a per-port one. This allows the user to
specify kernel receive contexts allocation on each
individual port.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h         |    2 +
 drivers/infiniband/hw/qib/qib_iba6120.c |    2 +
 drivers/infiniband/hw/qib/qib_iba7220.c |    2 +
 drivers/infiniband/hw/qib/qib_iba7322.c |   58 +++++++++++++++++--------------
 drivers/infiniband/hw/qib/qib_init.c    |   20 +++++++++--
 drivers/infiniband/hw/qib/qib_qp.c      |    6 ++-
 6 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index f4feb71..070e83c 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -622,6 +622,7 @@ struct qib_pportdata {
 	u8 link_speed_active;
 	u8 vls_supported;
 	u8 vls_operational;
+	u8 n_krcv_queues;
 	/* Rx Polarity inversion (compensate for ~tx on partner) */
 	u8 rx_pol_inv;
 
@@ -1036,7 +1037,6 @@ struct qib_devdata {
 	u8 num_pports;
 	/* Lowest context number which can be used by user processes */
 	u8 first_user_ctxt;
-	u8 n_krcv_queues;
 	u8 qpn_mask;
 	u8 skip_kctxt_mask;
 
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 8af5bd3..a2ba6d6 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2071,7 +2071,7 @@ static void qib_6120_config_ctxts(struct qib_devdata *dd)
 		dd->qpn_mask = dd->first_user_ctxt <= 2 ? 2 : 6;
 	} else
 		dd->first_user_ctxt = dd->num_pports;
-	dd->n_krcv_queues = dd->first_user_ctxt;
+	dd->pport[0].n_krcv_queues = dd->first_user_ctxt;
 }
 
 static void qib_update_6120_usrhead(struct qib_ctxtdata *rcd, u64 hd,
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index f809281..eef047f 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2305,7 +2305,7 @@ static void qib_7220_config_ctxts(struct qib_devdata *dd)
 			dd->first_user_ctxt = nchipctxts;
 	} else
 		dd->first_user_ctxt = dd->num_pports;
-	dd->n_krcv_queues = dd->first_user_ctxt;
+	dd->pport[0].n_krcv_queues = dd->first_user_ctxt;
 
 	if (!cfgctxts) {
 		int nctxts = dd->first_user_ctxt + num_online_cpus();
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index e04e0b6..7a7b337 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3174,7 +3174,8 @@ try_intx:
 			snprintf(dd->cspec->msix_entries[msixnum].name,
 				sizeof(dd->cspec->msix_entries[msixnum].name)
 				 - 1,
-				QIB_DRV_NAME "%d (kctx)", dd->unit);
+				 QIB_DRV_NAME "%d:%d (kctx)", dd->unit,
+				 ((struct qib_ctxtdata *)arg)->ppd->port);
 		}
 		ret = request_irq(
 			dd->cspec->msix_entries[msixnum].msix.vector,
@@ -3593,21 +3594,27 @@ qib_7322_get_msgheader(struct qib_devdata *dd, __le32 *rhf_addr)
 static void qib_7322_config_ctxts(struct qib_devdata *dd)
 {
 	unsigned long flags;
-	u32 nchipctxts;
+	u32 nchipctxts, nkrcvqs;
 	u32 cfgctxts = QIB_MODPARAM_GET(cfgctxts, dd->unit, 0);
-	u32 nkrcvqs = QIB_MODPARAM_GET(krcvqs, dd->unit, 0);
+	u8 pidx;
 
 	nchipctxts = qib_read_kreg32(dd, kr_contextcnt);
 	dd->cspec->numctxts = nchipctxts;
-	if (nkrcvqs > 1 && dd->num_pports) {
-		dd->first_user_ctxt = NUM_IB_PORTS +
-			(nkrcvqs - 1) * dd->num_pports;
-		if (dd->first_user_ctxt > nchipctxts)
-			dd->first_user_ctxt = nchipctxts;
-		dd->n_krcv_queues = dd->first_user_ctxt / dd->num_pports;
-	} else {
-		dd->first_user_ctxt = NUM_IB_PORTS;
-		dd->n_krcv_queues = 1;
+	dd->first_user_ctxt = NUM_IB_PORTS;
+
+	for (pidx = 0; pidx < dd->num_pports; pidx++) {
+		nkrcvqs = QIB_MODPARAM_GET(krcvqs, dd->unit, pidx+1);
+		if (nkrcvqs > 1) {
+			if (nkrcvqs - 1 > nchipctxts - dd->first_user_ctxt)
+				dd->pport[pidx].n_krcv_queues =
+					(nchipctxts - dd->first_user_ctxt) + 1;
+			else
+				dd->pport[pidx].n_krcv_queues = nkrcvqs;
+			dd->first_user_ctxt +=
+				dd->pport[pidx].n_krcv_queues - 1;
+		} else
+			/* Account for the HW ctxt */
+			dd->pport[pidx].n_krcv_queues = 1;
 	}
 
 	if (!cfgctxts) {
@@ -5995,11 +6002,11 @@ static void write_7322_initregs(struct qib_devdata *dd)
 	qib_write_kreg(dd, KREG_IDX(RcvQPMulticastContext_1), 1);
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-		unsigned n, regno;
+		unsigned i, n, regno, ctxts[18];
 		unsigned long flags;
 
-		if (dd->n_krcv_queues < 2 ||
-			!dd->pport[pidx].link_speed_supported)
+		if (dd->pport[pidx].n_krcv_queues == 1 ||
+		    !dd->pport[pidx].link_speed_supported)
 			continue;
 
 		ppd = &dd->pport[pidx];
@@ -6012,19 +6019,18 @@ static void write_7322_initregs(struct qib_devdata *dd)
 		/* Initialize QP to context mapping */
 		regno = krp_rcvqpmaptable;
 		val = 0;
-		if (dd->num_pports > 1)
-			n = dd->first_user_ctxt / dd->num_pports;
-		else
-			n = dd->first_user_ctxt - 1;
+		for (i = 0, n = 0; n < dd->first_user_ctxt; n++) {
+			if (dd->skip_kctxt_mask & (1 << n))
+				continue;
+			if (dd->rcd[n]->ppd->port == pidx+1)
+				ctxts[i++] = n;
+			if (i == ppd->n_krcv_queues)
+				break;
+		}
 		for (i = 0; i < 32; ) {
 			unsigned ctxt;
 
-			if (dd->num_pports > 1)
-				ctxt = (i % n) * dd->num_pports + pidx;
-			else if (i % n)
-				ctxt = (i % n) + 1;
-			else
-				ctxt = ppd->hw_pidx;
+			ctxt = ctxts[i % ppd->n_krcv_queues];
 			val |= ctxt << (5 * (i % 6));
 			i++;
 			if (i % 6 == 0) {
@@ -6348,8 +6354,8 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		goto bail; /* no error, so can still figure out why err */
 	}
 
-	write_7322_initregs(dd);
 	ret = qib_create_ctxts(dd);
+	write_7322_initregs(dd);
 	init_7322_cntrnames(dd);
 
 	updthresh = 8U; /* update threshold */
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index ea569a7..a560555 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -114,7 +114,8 @@ void qib_set_ctxtcnt(struct qib_devdata *dd)
  */
 int qib_create_ctxts(struct qib_devdata *dd)
 {
-	unsigned i;
+	unsigned i, c, p;
+	unsigned port;
 	int ret;
 
 	/*
@@ -129,15 +130,28 @@ int qib_create_ctxts(struct qib_devdata *dd)
 		goto done;
 	}
 
+	c = dd->num_pports ? min(
+		(unsigned)dd->pport[0].n_krcv_queues,
+		(dd->num_pports > 1 ?
+		 (unsigned)dd->pport[1].n_krcv_queues : (unsigned)-1))
+		: 0;
+	p = dd->num_pports > 1 ?
+		(dd->pport[0].n_krcv_queues > dd->pport[1].n_krcv_queues ?
+		 0 : 1) : 0;
+
 	/* create (one or more) kctxt */
-	for (i = 0; i < dd->first_user_ctxt; ++i) {
+	for (port = 0, i = 0; i < dd->first_user_ctxt; ++i) {
 		struct qib_pportdata *ppd;
 		struct qib_ctxtdata *rcd;
 
 		if (dd->skip_kctxt_mask & (1 << i))
 			continue;
 
-		ppd = dd->pport + (i % dd->num_pports);
+		if (i < (c * dd->num_pports))
+			ppd = dd->pport + (i % dd->num_pports);
+		else
+			ppd = dd->pport + p;
+
 		rcd = qib_create_ctxtdata(ppd, i);
 		if (!rcd) {
 			qib_dev_err(dd, "Unable to allocate ctxtdata"
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 4850d03..500c8fe 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -121,6 +121,7 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 		     enum ib_qp_type type, u8 port)
 {
 	u32 i, offset, max_scan, qpn;
+	unsigned krcvqs;
 	struct qpn_map *map;
 	u32 ret;
 
@@ -138,10 +139,11 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 		goto bail;
 	}
 
+	krcvqs = dd->pport[port-1].n_krcv_queues;
 	qpn = qpt->last + 2;
 	if (qpn >= QPN_MAX)
 		qpn = 2;
-	if (qpt->mask && ((qpn & qpt->mask) >> 1) >= dd->n_krcv_queues)
+	if (qpt->mask && ((qpn & qpt->mask) >> 1) >= krcvqs)
 		qpn = (qpn | qpt->mask) + 2;
 	offset = qpn & BITS_PER_PAGE_MASK;
 	map = &qpt->map[qpn / BITS_PER_PAGE];
@@ -159,7 +161,7 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 				goto bail;
 			}
 			offset = find_next_offset(qpt, map, offset,
-				dd->n_krcv_queues);
+				krcvqs);
 			qpn = mk_qpn(qpt, map, offset);
 			/*
 			 * This test differs from alloc_pidmap().


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
