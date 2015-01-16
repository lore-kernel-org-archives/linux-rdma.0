From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix sizeof checkpatch warnings
Date: Fri, 16 Jan 2015 10:50:32 -0500
Message-ID: <20150116155032.14751.57211.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_diag.c        |    4 ++--
 drivers/infiniband/hw/qib/qib_driver.c      |    2 +-
 drivers/infiniband/hw/qib/qib_eeprom.c      |   12 ++++++------
 drivers/infiniband/hw/qib/qib_file_ops.c    |    4 ++--
 drivers/infiniband/hw/qib/qib_fs.c          |    8 ++++----
 drivers/infiniband/hw/qib/qib_iba6120.c     |    8 ++++----
 drivers/infiniband/hw/qib/qib_iba7220.c     |   11 ++++++-----
 drivers/infiniband/hw/qib/qib_iba7322.c     |   16 ++++++++--------
 drivers/infiniband/hw/qib/qib_mad.c         |   20 ++++++++++----------
 drivers/infiniband/hw/qib/qib_mmap.c        |    2 +-
 drivers/infiniband/hw/qib/qib_mr.c          |   10 +++++-----
 drivers/infiniband/hw/qib/qib_rc.c          |    4 ++--
 drivers/infiniband/hw/qib/qib_ruc.c         |    4 ++--
 drivers/infiniband/hw/qib/qib_sysfs.c       |    4 ++--
 drivers/infiniband/hw/qib/qib_ud.c          |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c       |   12 ++++++------
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |    4 ++--
 17 files changed, 64 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 5dfda4c..f2d354c 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -85,7 +85,7 @@ static struct qib_diag_client *get_client(struct qib_devdata *dd)
 		client_pool = dc->next;
 	else
 		/* None in pool, alloc and init */
-		dc = kmalloc(sizeof *dc, GFP_KERNEL);
+		dc = kmalloc(sizeof(*dc), GFP_KERNEL);
 
 	if (dc) {
 		dc->next = NULL;
@@ -698,7 +698,7 @@ int qib_register_observer(struct qib_devdata *dd,
 
 	if (!dd || !op)
 		return -EINVAL;
-	olp = vmalloc(sizeof *olp);
+	olp = vmalloc(sizeof(*olp));
 	if (!olp) {
 		pr_err("vmalloc for observer failed\n");
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 5bee08f..d10b60e 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -86,7 +86,7 @@ const char *qib_get_unit_name(int unit)
 {
 	static char iname[16];
 
-	snprintf(iname, sizeof iname, "infinipath%u", unit);
+	snprintf(iname, sizeof(iname), "infinipath%u", unit);
 	return iname;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_eeprom.c b/drivers/infiniband/hw/qib/qib_eeprom.c
index e2280b0..c1a8f44 100644
--- a/drivers/infiniband/hw/qib/qib_eeprom.c
+++ b/drivers/infiniband/hw/qib/qib_eeprom.c
@@ -251,17 +251,17 @@ void qib_get_eeprom_info(struct qib_devdata *dd)
 		 * This board has a Serial-prefix, which is stored
 		 * elsewhere for backward-compatibility.
 		 */
-		memcpy(snp, ifp->if_sprefix, sizeof ifp->if_sprefix);
-		snp[sizeof ifp->if_sprefix] = '\0';
+		memcpy(snp, ifp->if_sprefix, sizeof(ifp->if_sprefix));
+		snp[sizeof(ifp->if_sprefix)] = '\0';
 		len = strlen(snp);
 		snp += len;
-		len = (sizeof dd->serial) - len;
-		if (len > sizeof ifp->if_serial)
-			len = sizeof ifp->if_serial;
+		len = sizeof(dd->serial) - len;
+		if (len > sizeof(ifp->if_serial))
+			len = sizeof(ifp->if_serial);
 		memcpy(snp, ifp->if_serial, len);
 	} else
 		memcpy(dd->serial, ifp->if_serial,
-		       sizeof ifp->if_serial);
+		       sizeof(ifp->if_serial));
 	if (!strstr(ifp->if_comment, "Tested successfully"))
 		qib_dev_err(dd,
 			"Board SN %s did not pass functional test: %s\n",
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index b15e34e..b16ceb2 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -437,7 +437,7 @@ cleanup:
 			goto cleanup;
 		}
 		if (copy_to_user((void __user *) (unsigned long) ti->tidmap,
-				 tidmap, sizeof tidmap)) {
+				 tidmap, sizeof(tidmap))) {
 			ret = -EFAULT;
 			goto cleanup;
 		}
@@ -484,7 +484,7 @@ static int qib_tid_free(struct qib_ctxtdata *rcd, unsigned subctxt,
 	}
 
 	if (copy_from_user(tidmap, (void __user *)(unsigned long)ti->tidmap,
-			   sizeof tidmap)) {
+			   sizeof(tidmap))) {
 		ret = -EFAULT;
 		goto done;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index cab610c..9019f56 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -107,7 +107,7 @@ static ssize_t driver_stats_read(struct file *file, char __user *buf,
 {
 	qib_stats.sps_ints = qib_sps_ints();
 	return simple_read_from_buffer(buf, count, ppos, &qib_stats,
-				       sizeof qib_stats);
+				       sizeof(qib_stats));
 }
 
 /*
@@ -134,7 +134,7 @@ static ssize_t driver_names_read(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	return simple_read_from_buffer(buf, count, ppos, qib_statnames,
-		sizeof qib_statnames - 1); /* no null */
+		sizeof(qib_statnames) - 1); /* no null */
 }
 
 static const struct file_operations driver_ops[] = {
@@ -380,7 +380,7 @@ static int add_cntr_files(struct super_block *sb, struct qib_devdata *dd)
 	int ret, i;
 
 	/* create the per-unit directory */
-	snprintf(unit, sizeof unit, "%u", dd->unit);
+	snprintf(unit, sizeof(unit), "%u", dd->unit);
 	ret = create_file(unit, S_IFDIR|S_IRUGO|S_IXUGO, sb->s_root, &dir,
 			  &simple_dir_operations, dd);
 	if (ret) {
@@ -483,7 +483,7 @@ static int remove_device_files(struct super_block *sb,
 
 	root = dget(sb->s_root);
 	mutex_lock(&root->d_inode->i_mutex);
-	snprintf(unit, sizeof unit, "%u", dd->unit);
+	snprintf(unit, sizeof(unit), "%u", dd->unit);
 	dir = lookup_one_len(unit, root, strlen(unit));
 
 	if (IS_ERR(dir)) {
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index f7f49a6..a8d0619 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -834,14 +834,14 @@ static void qib_handle_6120_hwerrors(struct qib_devdata *dd, char *msg,
 		bits = (u32) ((hwerrs >>
 			       QLOGIC_IB_HWE_PCIEMEMPARITYERR_SHIFT) &
 			      QLOGIC_IB_HWE_PCIEMEMPARITYERR_MASK);
-		snprintf(bitsmsg, sizeof dd->cspec->bitsmsgbuf,
+		snprintf(bitsmsg, sizeof(dd->cspec->bitsmsgbuf),
 			 "[PCIe Mem Parity Errs %x] ", bits);
 		strlcat(msg, bitsmsg, msgl);
 	}
 
 	if (hwerrs & _QIB_PLL_FAIL) {
 		isfatal = 1;
-		snprintf(bitsmsg, sizeof dd->cspec->bitsmsgbuf,
+		snprintf(bitsmsg, sizeof(dd->cspec->bitsmsgbuf),
 			 "[PLL failed (%llx), InfiniPath hardware unusable]",
 			 (unsigned long long) hwerrs & _QIB_PLL_FAIL);
 		strlcat(msg, bitsmsg, msgl);
@@ -1014,7 +1014,7 @@ static void handle_6120_errors(struct qib_devdata *dd, u64 errs)
 
 	/* do these first, they are most important */
 	if (errs & ERR_MASK(HardwareErr))
-		qib_handle_6120_hwerrors(dd, msg, sizeof dd->cspec->emsgbuf);
+		qib_handle_6120_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
 	else
 		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
 			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
@@ -1062,7 +1062,7 @@ static void handle_6120_errors(struct qib_devdata *dd, u64 errs)
 	 */
 	mask = ERR_MASK(IBStatusChanged) | ERR_MASK(RcvEgrFullErr) |
 		ERR_MASK(RcvHdrFullErr) | ERR_MASK(HardwareErr);
-	qib_decode_6120_err(dd, msg, sizeof dd->cspec->emsgbuf, errs & ~mask);
+	qib_decode_6120_err(dd, msg, sizeof(dd->cspec->emsgbuf), errs & ~mask);
 
 	if (errs & E_SUM_PKTERRS)
 		qib_stats.sps_rcverrs++;
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index f5fa106..ece2993 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -902,7 +902,8 @@ static void sdma_7220_errors(struct qib_pportdata *ppd, u64 errs)
 	errs &= QLOGIC_IB_E_SDMAERRS;
 
 	msg = dd->cspec->sdmamsgbuf;
-	qib_decode_7220_sdma_errs(ppd, errs, msg, sizeof dd->cspec->sdmamsgbuf);
+	qib_decode_7220_sdma_errs(ppd, errs, msg,
+		sizeof(dd->cspec->sdmamsgbuf));
 	spin_lock_irqsave(&ppd->sdma_lock, flags);
 
 	if (errs & ERR_MASK(SendBufMisuseErr)) {
@@ -1101,7 +1102,7 @@ static void handle_7220_errors(struct qib_devdata *dd, u64 errs)
 
 	/* do these first, they are most important */
 	if (errs & ERR_MASK(HardwareErr))
-		qib_7220_handle_hwerrors(dd, msg, sizeof dd->cspec->emsgbuf);
+		qib_7220_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
 	else
 		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
 			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
@@ -1155,7 +1156,7 @@ static void handle_7220_errors(struct qib_devdata *dd, u64 errs)
 		ERR_MASK(RcvEgrFullErr) | ERR_MASK(RcvHdrFullErr) |
 		ERR_MASK(HardwareErr) | ERR_MASK(SDmaDisabledErr);
 
-	qib_decode_7220_err(dd, msg, sizeof dd->cspec->emsgbuf, errs & ~mask);
+	qib_decode_7220_err(dd, msg, sizeof(dd->cspec->emsgbuf), errs & ~mask);
 
 	if (errs & E_SUM_PKTERRS)
 		qib_stats.sps_rcverrs++;
@@ -1380,7 +1381,7 @@ static void qib_7220_handle_hwerrors(struct qib_devdata *dd, char *msg,
 		bits = (u32) ((hwerrs >>
 			       QLOGIC_IB_HWE_PCIEMEMPARITYERR_SHIFT) &
 			      QLOGIC_IB_HWE_PCIEMEMPARITYERR_MASK);
-		snprintf(bitsmsg, sizeof dd->cspec->bitsmsgbuf,
+		snprintf(bitsmsg, sizeof(dd->cspec->bitsmsgbuf),
 			 "[PCIe Mem Parity Errs %x] ", bits);
 		strlcat(msg, bitsmsg, msgl);
 	}
@@ -1390,7 +1391,7 @@ static void qib_7220_handle_hwerrors(struct qib_devdata *dd, char *msg,
 
 	if (hwerrs & _QIB_PLL_FAIL) {
 		isfatal = 1;
-		snprintf(bitsmsg, sizeof dd->cspec->bitsmsgbuf,
+		snprintf(bitsmsg, sizeof(dd->cspec->bitsmsgbuf),
 			 "[PLL failed (%llx), InfiniPath hardware unusable]",
 			 (unsigned long long) hwerrs & _QIB_PLL_FAIL);
 		strlcat(msg, bitsmsg, msgl);
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5d2b1a1..e33c719 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1656,7 +1656,7 @@ static noinline void handle_7322_errors(struct qib_devdata *dd)
 	/* do these first, they are most important */
 	if (errs & QIB_E_HARDWARE) {
 		*msg = '\0';
-		qib_7322_handle_hwerrors(dd, msg, sizeof dd->cspec->emsgbuf);
+		qib_7322_handle_hwerrors(dd, msg, sizeof(dd->cspec->emsgbuf));
 	} else
 		for (log_idx = 0; log_idx < QIB_EEP_LOG_CNT; ++log_idx)
 			if (errs & dd->eep_st_masks[log_idx].errs_to_log)
@@ -1681,7 +1681,7 @@ static noinline void handle_7322_errors(struct qib_devdata *dd)
 	mask = QIB_E_HARDWARE;
 	*msg = '\0';
 
-	err_decode(msg, sizeof dd->cspec->emsgbuf, errs & ~mask,
+	err_decode(msg, sizeof(dd->cspec->emsgbuf), errs & ~mask,
 		   qib_7322error_msgs);
 
 	/*
@@ -1868,10 +1868,10 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 	*msg = '\0';
 
 	if (errs & ~QIB_E_P_BITSEXTANT) {
-		err_decode(msg, sizeof ppd->cpspec->epmsgbuf,
+		err_decode(msg, sizeof(ppd->cpspec->epmsgbuf),
 			   errs & ~QIB_E_P_BITSEXTANT, qib_7322p_error_msgs);
 		if (!*msg)
-			snprintf(msg, sizeof ppd->cpspec->epmsgbuf,
+			snprintf(msg, sizeof(ppd->cpspec->epmsgbuf),
 				 "no others");
 		qib_dev_porterr(dd, ppd->port,
 			"error interrupt with unknown errors 0x%016Lx set (and %s)\n",
@@ -1885,7 +1885,7 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 		/* determine cause, then write to clear */
 		symptom = qib_read_kreg_port(ppd, krp_sendhdrsymptom);
 		qib_write_kreg_port(ppd, krp_sendhdrsymptom, 0);
-		err_decode(msg, sizeof ppd->cpspec->epmsgbuf, symptom,
+		err_decode(msg, sizeof(ppd->cpspec->epmsgbuf), symptom,
 			   hdrchk_msgs);
 		*msg = '\0';
 		/* senderrbuf cleared in SPKTERRS below */
@@ -1901,7 +1901,7 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 			 * isn't valid.  We don't want to confuse people, so
 			 * we just don't print them, except at debug
 			 */
-			err_decode(msg, sizeof ppd->cpspec->epmsgbuf,
+			err_decode(msg, sizeof(ppd->cpspec->epmsgbuf),
 				   (errs & QIB_E_P_LINK_PKTERRS),
 				   qib_7322p_error_msgs);
 			*msg = '\0';
@@ -1917,7 +1917,7 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 		 * valid.  We don't want to confuse people, so we just
 		 * don't print them, except at debug
 		 */
-		err_decode(msg, sizeof ppd->cpspec->epmsgbuf, errs,
+		err_decode(msg, sizeof(ppd->cpspec->epmsgbuf), errs,
 			   qib_7322p_error_msgs);
 		ignore_this_time = errs & QIB_E_P_LINK_PKTERRS;
 		*msg = '\0';
@@ -3421,7 +3421,7 @@ try_intx:
 	}
 
 	/* Try to get MSIx interrupts */
-	memset(redirect, 0, sizeof redirect);
+	memset(redirect, 0, sizeof(redirect));
 	mask = ~0ULL;
 	msixnum = 0;
 	local_mask = cpumask_of_pcibus(dd->pcidev->bus);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 636be11..395f404 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -152,14 +152,14 @@ void qib_bad_pqkey(struct qib_ibport *ibp, __be16 trap_num, u32 key, u32 sl,
 	data.trap_num = trap_num;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof data.details);
+	memset(&data.details, 0, sizeof(data.details));
 	data.details.ntc_257_258.lid1 = lid1;
 	data.details.ntc_257_258.lid2 = lid2;
 	data.details.ntc_257_258.key = cpu_to_be32(key);
 	data.details.ntc_257_258.sl_qp1 = cpu_to_be32((sl << 28) | qp1);
 	data.details.ntc_257_258.qp2 = cpu_to_be32(qp2);
 
-	qib_send_trap(ibp, &data, sizeof data);
+	qib_send_trap(ibp, &data, sizeof(data));
 }
 
 /*
@@ -176,7 +176,7 @@ static void qib_bad_mkey(struct qib_ibport *ibp, struct ib_smp *smp)
 	data.trap_num = IB_NOTICE_TRAP_BAD_MKEY;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof data.details);
+	memset(&data.details, 0, sizeof(data.details));
 	data.details.ntc_256.lid = data.issuer_lid;
 	data.details.ntc_256.method = smp->method;
 	data.details.ntc_256.attr_id = smp->attr_id;
@@ -198,7 +198,7 @@ static void qib_bad_mkey(struct qib_ibport *ibp, struct ib_smp *smp)
 		       hop_cnt);
 	}
 
-	qib_send_trap(ibp, &data, sizeof data);
+	qib_send_trap(ibp, &data, sizeof(data));
 }
 
 /*
@@ -214,11 +214,11 @@ void qib_cap_mask_chg(struct qib_ibport *ibp)
 	data.trap_num = IB_NOTICE_TRAP_CAP_MASK_CHG;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof data.details);
+	memset(&data.details, 0, sizeof(data.details));
 	data.details.ntc_144.lid = data.issuer_lid;
 	data.details.ntc_144.new_cap_mask = cpu_to_be32(ibp->port_cap_flags);
 
-	qib_send_trap(ibp, &data, sizeof data);
+	qib_send_trap(ibp, &data, sizeof(data));
 }
 
 /*
@@ -234,11 +234,11 @@ void qib_sys_guid_chg(struct qib_ibport *ibp)
 	data.trap_num = IB_NOTICE_TRAP_SYS_GUID_CHG;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof data.details);
+	memset(&data.details, 0, sizeof(data.details));
 	data.details.ntc_145.lid = data.issuer_lid;
 	data.details.ntc_145.new_sys_guid = ib_qib_sys_image_guid;
 
-	qib_send_trap(ibp, &data, sizeof data);
+	qib_send_trap(ibp, &data, sizeof(data));
 }
 
 /*
@@ -254,12 +254,12 @@ void qib_node_desc_chg(struct qib_ibport *ibp)
 	data.trap_num = IB_NOTICE_TRAP_CAP_MASK_CHG;
 	data.issuer_lid = cpu_to_be16(ppd_from_ibp(ibp)->lid);
 	data.toggle_count = 0;
-	memset(&data.details, 0, sizeof data.details);
+	memset(&data.details, 0, sizeof(data.details));
 	data.details.ntc_144.lid = data.issuer_lid;
 	data.details.ntc_144.local_changes = 1;
 	data.details.ntc_144.change_flags = IB_NOTICE_TRAP_NODE_DESC_CHG;
 
-	qib_send_trap(ibp, &data, sizeof data);
+	qib_send_trap(ibp, &data, sizeof(data));
 }
 
 static int subn_get_nodedescription(struct ib_smp *smp,
diff --git a/drivers/infiniband/hw/qib/qib_mmap.c b/drivers/infiniband/hw/qib/qib_mmap.c
index 8b73a11..146cf29 100644
--- a/drivers/infiniband/hw/qib/qib_mmap.c
+++ b/drivers/infiniband/hw/qib/qib_mmap.c
@@ -134,7 +134,7 @@ struct qib_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev,
 					   void *obj) {
 	struct qib_mmap_info *ip;
 
-	ip = kmalloc(sizeof *ip, GFP_KERNEL);
+	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
 	if (!ip)
 		goto bail;
 
diff --git a/drivers/infiniband/hw/qib/qib_mr.c b/drivers/infiniband/hw/qib/qib_mr.c
index 9bbb553..912b364 100644
--- a/drivers/infiniband/hw/qib/qib_mr.c
+++ b/drivers/infiniband/hw/qib/qib_mr.c
@@ -55,7 +55,7 @@ static int init_qib_mregion(struct qib_mregion *mr, struct ib_pd *pd,
 
 	m = (count + QIB_SEGSZ - 1) / QIB_SEGSZ;
 	for (; i < m; i++) {
-		mr->map[i] = kzalloc(sizeof *mr->map[0], GFP_KERNEL);
+		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
 		if (!mr->map[i])
 			goto bail;
 	}
@@ -104,7 +104,7 @@ struct ib_mr *qib_get_dma_mr(struct ib_pd *pd, int acc)
 		goto bail;
 	}
 
-	mr = kzalloc(sizeof *mr, GFP_KERNEL);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail;
@@ -143,7 +143,7 @@ static struct qib_mr *alloc_mr(int count, struct ib_pd *pd)
 
 	/* Allocate struct plus pointers to first level page tables. */
 	m = (count + QIB_SEGSZ - 1) / QIB_SEGSZ;
-	mr = kzalloc(sizeof *mr + m * sizeof mr->mr.map[0], GFP_KERNEL);
+	mr = kzalloc(sizeof(*mr) + m * sizeof(mr->mr.map[0]), GFP_KERNEL);
 	if (!mr)
 		goto bail;
 
@@ -347,7 +347,7 @@ qib_alloc_fast_reg_page_list(struct ib_device *ibdev, int page_list_len)
 	if (size > PAGE_SIZE)
 		return ERR_PTR(-EINVAL);
 
-	pl = kzalloc(sizeof *pl, GFP_KERNEL);
+	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
 	if (!pl)
 		return ERR_PTR(-ENOMEM);
 
@@ -386,7 +386,7 @@ struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 
 	/* Allocate struct plus pointers to first level page tables. */
 	m = (fmr_attr->max_pages + QIB_SEGSZ - 1) / QIB_SEGSZ;
-	fmr = kzalloc(sizeof *fmr + m * sizeof fmr->mr.map[0], GFP_KERNEL);
+	fmr = kzalloc(sizeof(*fmr) + m * sizeof(fmr->mr.map[0]), GFP_KERNEL);
 	if (!fmr)
 		goto bail;
 
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 2f25018..4544d6f 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1017,7 +1017,7 @@ void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr)
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof wc);
+			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
 			wc.status = IB_WC_SUCCESS;
 			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
@@ -1073,7 +1073,7 @@ static struct qib_swqe *do_rc_completion(struct qib_qp *qp,
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
-			memset(&wc, 0, sizeof wc);
+			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
 			wc.status = IB_WC_SUCCESS;
 			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 4c07a8b..45353a4 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -420,7 +420,7 @@ again:
 		goto serr;
 	}
 
-	memset(&wc, 0, sizeof wc);
+	memset(&wc, 0, sizeof(wc));
 	send_status = IB_WC_SUCCESS;
 
 	release = 1;
@@ -792,7 +792,7 @@ void qib_send_complete(struct qib_qp *qp, struct qib_swqe *wqe,
 	    status != IB_WC_SUCCESS) {
 		struct ib_wc wc;
 
-		memset(&wc, 0, sizeof wc);
+		memset(&wc, 0, sizeof(wc));
 		wc.wr_id = wqe->wr.wr_id;
 		wc.status = status;
 		wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index b9ccbda..81f56cd 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -586,8 +586,8 @@ static ssize_t show_serial(struct device *device,
 		container_of(device, struct qib_ibdev, ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
-	buf[sizeof dd->serial] = '\0';
-	memcpy(buf, dd->serial, sizeof dd->serial);
+	buf[sizeof(dd->serial)] = '\0';
+	memcpy(buf, dd->serial, sizeof(dd->serial));
 	strcat(buf, "\n");
 	return strlen(buf);
 }
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index aaf7039..26243b7 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -127,7 +127,7 @@ static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
 	 * present on the wire.
 	 */
 	length = swqe->length;
-	memset(&wc, 0, sizeof wc);
+	memset(&wc, 0, sizeof(wc));
 	wc.byte_len = length + sizeof(struct ib_grh);
 
 	if (swqe->wr.opcode == IB_WR_SEND_WITH_IMM) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9bcfbd8..10233e4 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1744,7 +1744,7 @@ static struct ib_pd *qib_alloc_pd(struct ib_device *ibdev,
 	 * we allow allocations of more than we report for this value.
 	 */
 
-	pd = kmalloc(sizeof *pd, GFP_KERNEL);
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail;
@@ -1829,7 +1829,7 @@ static struct ib_ah *qib_create_ah(struct ib_pd *pd,
 		goto bail;
 	}
 
-	ah = kmalloc(sizeof *ah, GFP_ATOMIC);
+	ah = kmalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail;
@@ -1862,7 +1862,7 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 	struct ib_ah *ah = ERR_PTR(-EINVAL);
 	struct qib_qp *qp0;
 
-	memset(&attr, 0, sizeof attr);
+	memset(&attr, 0, sizeof(attr));
 	attr.dlid = dlid;
 	attr.port_num = ppd_from_ibp(ibp)->port;
 	rcu_read_lock();
@@ -1977,7 +1977,7 @@ static struct ib_ucontext *qib_alloc_ucontext(struct ib_device *ibdev,
 	struct qib_ucontext *context;
 	struct ib_ucontext *ret;
 
-	context = kmalloc(sizeof *context, GFP_KERNEL);
+	context = kmalloc(sizeof(*context), GFP_KERNEL);
 	if (!context) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail;
@@ -2054,7 +2054,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	dev->qp_table_size = ib_qib_qp_table_size;
 	get_random_bytes(&dev->qp_rnd, sizeof(dev->qp_rnd));
-	dev->qp_table = kmalloc(dev->qp_table_size * sizeof *dev->qp_table,
+	dev->qp_table = kmalloc(dev->qp_table_size * sizeof(*dev->qp_table),
 				GFP_KERNEL);
 	if (!dev->qp_table) {
 		ret = -ENOMEM;
@@ -2122,7 +2122,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	for (i = 0; i < ppd->sdma_descq_cnt; i++) {
 		struct qib_verbs_txreq *tx;
 
-		tx = kzalloc(sizeof *tx, GFP_KERNEL);
+		tx = kzalloc(sizeof(*tx), GFP_KERNEL);
 		if (!tx) {
 			ret = -ENOMEM;
 			goto err_tx;
diff --git a/drivers/infiniband/hw/qib/qib_verbs_mcast.c b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
index dabb697..f8ea069 100644
--- a/drivers/infiniband/hw/qib/qib_verbs_mcast.c
+++ b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
@@ -43,7 +43,7 @@ static struct qib_mcast_qp *qib_mcast_qp_alloc(struct qib_qp *qp)
 {
 	struct qib_mcast_qp *mqp;
 
-	mqp = kmalloc(sizeof *mqp, GFP_KERNEL);
+	mqp = kmalloc(sizeof(*mqp), GFP_KERNEL);
 	if (!mqp)
 		goto bail;
 
@@ -75,7 +75,7 @@ static struct qib_mcast *qib_mcast_alloc(union ib_gid *mgid)
 {
 	struct qib_mcast *mcast;
 
-	mcast = kmalloc(sizeof *mcast, GFP_KERNEL);
+	mcast = kmalloc(sizeof(*mcast), GFP_KERNEL);
 	if (!mcast)
 		goto bail;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
