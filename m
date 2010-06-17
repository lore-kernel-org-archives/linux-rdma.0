From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/7] IB/qib: allow PSM to select from multiple port assignment
	algorithms
Date: Thu, 17 Jun 2010 16:13:49 -0700
Message-ID: <20100617231349.8006.24712.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

We formerly allowed only full specification, or using all contexts
within an HCA before moving to the next HCA.  We now allow an additional
method, of round-robining through HCAs, and make that the default.

Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_common.h   |   16 ++
 drivers/infiniband/hw/qib/qib_file_ops.c |  203 +++++++++++++++---------------
 2 files changed, 118 insertions(+), 101 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_common.h b/drivers/infiniband/hw/qib/qib_common.h
index b3955ed..145da40 100644
--- a/drivers/infiniband/hw/qib/qib_common.h
+++ b/drivers/infiniband/hw/qib/qib_common.h
@@ -279,7 +279,7 @@ struct qib_base_info {
  * may not be implemented; the user code must deal with this if it
  * cares, or it must abort after initialization reports the difference.
  */
-#define QIB_USER_SWMINOR 10
+#define QIB_USER_SWMINOR 11
 
 #define QIB_USER_SWVERSION ((QIB_USER_SWMAJOR << 16) | QIB_USER_SWMINOR)
 
@@ -302,6 +302,18 @@ struct qib_base_info {
 #define QIB_KERN_SWVERSION ((QIB_KERN_TYPE << 31) | QIB_USER_SWVERSION)
 
 /*
+ * If the unit is specified via open, HCA choice is fixed.  If port is
+ * specified, it's also fixed.  Otherwise we try to spread contexts
+ * across ports and HCAs, using different algorithims.  WITHIN is
+ * the old default, prior to this mechanism.
+ */
+#define QIB_PORT_ALG_ACROSS 0 /* round robin contexts across HCAs, then
+			       * ports; this is the default */
+#define QIB_PORT_ALG_WITHIN 1 /* use all contexts on an HCA (round robin
+			       * active ports within), then next HCA */
+#define QIB_PORT_ALG_COUNT 2 /* number of algorithm choices */
+
+/*
  * This structure is passed to qib_userinit() to tell the driver where
  * user code buffers are, sizes, etc.   The offsets and sizes of the
  * fields must remain unchanged, for binary compatibility.  It can
@@ -319,7 +331,7 @@ struct qib_user_info {
 	/* size of struct base_info to write to */
 	__u32 spu_base_info_size;
 
-	__u32 _spu_unused3;
+	__u32 spu_port_alg; /* which QIB_PORT_ALG_*; unused user minor < 11 */
 
 	/*
 	 * If two or more processes wish to share a context, each process
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index a142a9e..6b11645 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1294,128 +1294,130 @@ bail:
 	return ret;
 }
 
-static inline int usable(struct qib_pportdata *ppd, int active_only)
+static inline int usable(struct qib_pportdata *ppd)
 {
 	struct qib_devdata *dd = ppd->dd;
-	u32 linkok = active_only ? QIBL_LINKACTIVE :
-		 (QIBL_LINKINIT | QIBL_LINKARMED | QIBL_LINKACTIVE);
 
 	return dd && (dd->flags & QIB_PRESENT) && dd->kregbase && ppd->lid &&
-		(ppd->lflags & linkok);
+		(ppd->lflags & QIBL_LINKACTIVE);
 }
 
-static int find_free_ctxt(int unit, struct file *fp,
-			  const struct qib_user_info *uinfo)
+/*
+ * Select a context on the given device, either using a requested port
+ * or the port based on the context number.
+ */
+static int choose_port_ctxt(struct file *fp, struct qib_devdata *dd, u32 port,
+			    const struct qib_user_info *uinfo)
 {
-	struct qib_devdata *dd = qib_lookup(unit);
 	struct qib_pportdata *ppd = NULL;
-	int ret;
-	u32 ctxt;
+	int ret, ctxt;
 
-	if (!dd || (uinfo->spu_port && uinfo->spu_port > dd->num_pports)) {
-		ret = -ENODEV;
-		goto bail;
-	}
-
-	/*
-	 * If users requests specific port, only try that one port, else
-	 * select "best" port below, based on context.
-	 */
-	if (uinfo->spu_port) {
-		ppd = dd->pport + uinfo->spu_port - 1;
-		if (!usable(ppd, 0)) {
+	if (port) {
+		if (!usable(dd->pport + port - 1)) {
 			ret = -ENETDOWN;
-			goto bail;
-		}
+			goto done;
+		} else
+			ppd = dd->pport + port - 1;
 	}
-
-	for (ctxt = dd->first_user_ctxt; ctxt < dd->cfgctxts; ctxt++) {
-		if (dd->rcd[ctxt])
-			continue;
-		/*
-		 * The setting and clearing of user context rcd[x] protected
-		 * by the qib_mutex
-		 */
-		if (!ppd) {
-			/* choose port based on ctxt, if up, else 1st up */
-			ppd = dd->pport + (ctxt % dd->num_pports);
-			if (!usable(ppd, 0)) {
-				int i;
-				for (i = 0; i < dd->num_pports; i++) {
-					ppd = dd->pport + i;
-					if (usable(ppd, 0))
-						break;
-				}
-				if (i == dd->num_pports) {
-					ret = -ENETDOWN;
-					goto bail;
-				}
-			}
+	for (ctxt = dd->first_user_ctxt; ctxt < dd->cfgctxts && dd->rcd[ctxt];
+	     ctxt++)
+		;
+	if (ctxt == dd->cfgctxts) {
+		ret = -EBUSY;
+		goto done;
+	}
+	if (!ppd) {
+		u32 pidx = ctxt % dd->num_pports;
+		if (usable(dd->pport + pidx))
+			ppd = dd->pport + pidx;
+		else {
+			for (pidx = 0; pidx < dd->num_pports && !ppd;
+			     pidx++)
+				if (usable(dd->pport + pidx))
+					ppd = dd->pport + pidx;
 		}
-		ret = setup_ctxt(ppd, ctxt, fp, uinfo);
-		goto bail;
 	}
-	ret = -EBUSY;
+	ret = ppd ? setup_ctxt(ppd, ctxt, fp, uinfo) : -ENETDOWN;
+done:
+	return ret;
+}
+
+static int find_free_ctxt(int unit, struct file *fp,
+			  const struct qib_user_info *uinfo)
+{
+	struct qib_devdata *dd = qib_lookup(unit);
+	int ret;
+
+	if (!dd || (uinfo->spu_port && uinfo->spu_port > dd->num_pports))
+		ret = -ENODEV;
+	else
+		ret = choose_port_ctxt(fp, dd, uinfo->spu_port, uinfo);
 
-bail:
 	return ret;
 }
 
-static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo)
+static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo,
+		      unsigned alg)
 {
-	struct qib_pportdata *ppd;
-	int ret = 0, devmax;
-	int npresent, nup;
-	int ndev;
+	struct qib_devdata *udd = NULL;
+	int ret = 0, devmax, npresent, nup, ndev, dusable = 0, i;
 	u32 port = uinfo->spu_port, ctxt;
 
 	devmax = qib_count_units(&npresent, &nup);
+	if (!npresent) {
+		ret = -ENXIO;
+		goto done;
+	}
+	if (nup == 0) {
+		ret = -ENETDOWN;
+		goto done;
+	}
 
-	for (ndev = 0; ndev < devmax; ndev++) {
-		struct qib_devdata *dd = qib_lookup(ndev);
-
-		/* device portion of usable() */
-		if (!(dd && (dd->flags & QIB_PRESENT) && dd->kregbase))
-			continue;
-		for (ctxt = dd->first_user_ctxt; ctxt < dd->cfgctxts; ctxt++) {
-			if (dd->rcd[ctxt])
+	if (alg == QIB_PORT_ALG_ACROSS) {
+		unsigned inuse = ~0U;
+		/* find device (with ACTIVE ports) with fewest ctxts in use */
+		for (ndev = 0; ndev < devmax; ndev++) {
+			struct qib_devdata *dd = qib_lookup(ndev);
+			unsigned cused = 0, cfree = 0;
+			if (!dd)
 				continue;
-			if (port) {
-				if (port > dd->num_pports)
-					continue;
-				ppd = dd->pport + port - 1;
-				if (!usable(ppd, 0))
-					continue;
-			} else {
-				/*
-				 * choose port based on ctxt, if up, else
-				 * first port that's up for multi-port HCA
-				 */
-				ppd = dd->pport + (ctxt % dd->num_pports);
-				if (!usable(ppd, 0)) {
-					int j;
-
-					ppd = NULL;
-					for (j = 0; j < dd->num_pports &&
-						!ppd; j++)
-						if (usable(dd->pport + j, 0))
-							ppd = dd->pport + j;
-					if (!ppd)
-						continue; /* to next unit */
-				}
+			if (port && port <= dd->num_pports &&
+			    usable(dd->pport + port - 1))
+				dusable = 1;
+			else
+				for (i = 0; i < dd->num_pports; i++)
+					if (usable(dd->pport + i))
+						dusable++;
+			if (!dusable)
+				continue;
+			for (ctxt = dd->first_user_ctxt; ctxt < dd->cfgctxts;
+			     ctxt++)
+				if (dd->rcd[ctxt])
+					cused++;
+				else
+					cfree++;
+			if (cfree && cused < inuse) {
+				udd = dd;
+				inuse = cused;
 			}
-			ret = setup_ctxt(ppd, ctxt, fp, uinfo);
+		}
+		if (udd) {
+			ret = choose_port_ctxt(fp, udd, port, uinfo);
 			goto done;
 		}
+	} else {
+		for (ndev = 0; ndev < devmax; ndev++) {
+			struct qib_devdata *dd = qib_lookup(ndev);
+			if (dd) {
+				ret = choose_port_ctxt(fp, dd, port, uinfo);
+				if (!ret)
+					goto done;
+				if (ret == -EBUSY)
+					dusable++;
+			}
+		}
 	}
-
-	if (npresent) {
-		if (nup == 0)
-			ret = -ENETDOWN;
-		else
-			ret = -EBUSY;
-	} else
-		ret = -ENXIO;
+	ret = dusable ? -EBUSY : -ENETDOWN;
 
 done:
 	return ret;
@@ -1481,7 +1483,7 @@ static int qib_assign_ctxt(struct file *fp, const struct qib_user_info *uinfo)
 {
 	int ret;
 	int i_minor;
-	unsigned swmajor, swminor;
+	unsigned swmajor, swminor, alg = QIB_PORT_ALG_ACROSS;
 
 	/* Check to be sure we haven't already initialized this file */
 	if (ctxt_fp(fp)) {
@@ -1498,6 +1500,9 @@ static int qib_assign_ctxt(struct file *fp, const struct qib_user_info *uinfo)
 
 	swminor = uinfo->spu_userversion & 0xffff;
 
+	if (swminor >= 11 && uinfo->spu_port_alg < QIB_PORT_ALG_COUNT)
+		alg = uinfo->spu_port_alg;
+
 	mutex_lock(&qib_mutex);
 
 	if (qib_compatible_subctxts(swmajor, swminor) &&
@@ -1514,7 +1519,7 @@ static int qib_assign_ctxt(struct file *fp, const struct qib_user_info *uinfo)
 	if (i_minor)
 		ret = find_free_ctxt(i_minor - 1, fp, uinfo);
 	else
-		ret = get_a_ctxt(fp, uinfo);
+		ret = get_a_ctxt(fp, uinfo, alg);
 
 done_chk_sdma:
 	if (!ret) {
@@ -1862,7 +1867,7 @@ static int disarm_req_delay(struct qib_ctxtdata *rcd)
 {
 	int ret = 0;
 
-	if (!usable(rcd->ppd, 1)) {
+	if (!usable(rcd->ppd)) {
 		int i;
 		/*
 		 * if link is down, or otherwise not usable, delay
@@ -1881,7 +1886,7 @@ static int disarm_req_delay(struct qib_ctxtdata *rcd)
 				set_bit(_QIB_EVENT_DISARM_BUFS_BIT,
 					&rcd->user_event_mask[i]);
 		}
-		for (i = 0; !usable(rcd->ppd, 1) && i < 300; i++)
+		for (i = 0; !usable(rcd->ppd) && i < 300; i++)
 			msleep(100);
 		ret = -ENETDOWN;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
