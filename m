From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/17] IB/qib: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:26 +0200
Message-ID: <1478149353-12125-11-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_diag.c    |  6 +----
 drivers/infiniband/hw/qib/qib_eeprom.c  |  6 +----
 drivers/infiniband/hw/qib/qib_iba6120.c |  8 +-----
 drivers/infiniband/hw/qib/qib_iba7220.c |  8 +-----
 drivers/infiniband/hw/qib/qib_iba7322.c | 22 ++++-----------
 drivers/infiniband/hw/qib/qib_init.c    | 47 ++++++---------------------------
 6 files changed, 17 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 8c34b23..775018b 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -609,8 +609,6 @@ static ssize_t qib_diagpkt_write(struct file *fp,
 
 	tmpbuf = vmalloc(plen);
 	if (!tmpbuf) {
-		qib_devinfo(dd->pcidev,
-			"Unable to allocate tmp buffer, failing\n");
 		ret = -ENOMEM;
 		goto bail;
 	}
@@ -702,10 +700,8 @@ int qib_register_observer(struct qib_devdata *dd,
 	if (!dd || !op)
 		return -EINVAL;
 	olp = vmalloc(sizeof(*olp));
-	if (!olp) {
-		pr_err("vmalloc for observer failed\n");
+	if (!olp)
 		return -ENOMEM;
-	}
 
 	spin_lock_irqsave(&dd->qib_diag_trans_lock, flags);
 	olp->op = op;
diff --git a/drivers/infiniband/hw/qib/qib_eeprom.c b/drivers/infiniband/hw/qib/qib_eeprom.c
index 311ee6c..33a2e74 100644
--- a/drivers/infiniband/hw/qib/qib_eeprom.c
+++ b/drivers/infiniband/hw/qib/qib_eeprom.c
@@ -182,12 +182,8 @@ void qib_get_eeprom_info(struct qib_devdata *dd)
 	 * */
 	len = sizeof(struct qib_flash);
 	buf = vmalloc(len);
-	if (!buf) {
-		qib_dev_err(dd,
-			"Couldn't allocate memory to read %u bytes from eeprom for GUID\n",
-			len);
+	if (!buf)
 		goto bail;
-	}
 
 	/*
 	 * Use "public" eeprom read function, which does locking and
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index a3733f2..92399d3 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1759,9 +1759,7 @@ static void pe_boardname(struct qib_devdata *dd)
 	}
 	namelen = strlen(n) + 1;
 	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (!dd->boardname)
-		qib_dev_err(dd, "Failed allocation for board name: %s\n", n);
-	else
+	if (dd->boardname)
 		snprintf(dd->boardname, namelen, "%s", n);
 
 	if (dd->majrev != 4 || !dd->minrev || dd->minrev > 2)
@@ -2533,8 +2531,6 @@ static void init_6120_cntrnames(struct qib_devdata *dd)
 		dd->cspec->cntrnamelen = 1 + s - cntr6120names;
 	dd->cspec->cntrs = kmalloc(dd->cspec->ncntrs
 		* sizeof(u64), GFP_KERNEL);
-	if (!dd->cspec->cntrs)
-		qib_dev_err(dd, "Failed allocation for counters\n");
 
 	for (i = 0, s = (char *)portcntr6120names; s; i++)
 		s = strchr(s + 1, '\n');
@@ -2542,8 +2538,6 @@ static void init_6120_cntrnames(struct qib_devdata *dd)
 	dd->cspec->portcntrnamelen = sizeof(portcntr6120names) - 1;
 	dd->cspec->portcntrs = kmalloc(dd->cspec->nportcntrs
 		* sizeof(u64), GFP_KERNEL);
-	if (!dd->cspec->portcntrs)
-		qib_dev_err(dd, "Failed allocation for portcounters\n");
 }
 
 static u32 qib_read_6120cntrs(struct qib_devdata *dd, loff_t pos, char **namep,
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 00b2af2..e55e31a 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2070,9 +2070,7 @@ static void qib_7220_boardname(struct qib_devdata *dd)
 
 	namelen = strlen(n) + 1;
 	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (!dd->boardname)
-		qib_dev_err(dd, "Failed allocation for board name: %s\n", n);
-	else
+	if (dd->boardname)
 		snprintf(dd->boardname, namelen, "%s", n);
 
 	if (dd->majrev != 5 || !dd->minrev || dd->minrev > 2)
@@ -3179,8 +3177,6 @@ static void init_7220_cntrnames(struct qib_devdata *dd)
 		dd->cspec->cntrnamelen = 1 + s - cntr7220names;
 	dd->cspec->cntrs = kmalloc(dd->cspec->ncntrs
 		* sizeof(u64), GFP_KERNEL);
-	if (!dd->cspec->cntrs)
-		qib_dev_err(dd, "Failed allocation for counters\n");
 
 	for (i = 0, s = (char *)portcntr7220names; s; i++)
 		s = strchr(s + 1, '\n');
@@ -3188,8 +3184,6 @@ static void init_7220_cntrnames(struct qib_devdata *dd)
 	dd->cspec->portcntrnamelen = sizeof(portcntr7220names) - 1;
 	dd->cspec->portcntrs = kmalloc(dd->cspec->nportcntrs
 		* sizeof(u64), GFP_KERNEL);
-	if (!dd->cspec->portcntrs)
-		qib_dev_err(dd, "Failed allocation for portcounters\n");
 }
 
 static u32 qib_read_7220cntrs(struct qib_devdata *dd, loff_t pos, char **namep,
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index ded2717..c4a36160 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3627,9 +3627,7 @@ static unsigned qib_7322_boardname(struct qib_devdata *dd)
 
 	namelen = strlen(n) + 1;
 	dd->boardname = kmalloc(namelen, GFP_KERNEL);
-	if (!dd->boardname)
-		qib_dev_err(dd, "Failed allocation for board name: %s\n", n);
-	else
+	if (dd->boardname)
 		snprintf(dd->boardname, namelen, "%s", n);
 
 	snprintf(dd->boardversion, sizeof(dd->boardversion),
@@ -3656,7 +3654,7 @@ static unsigned qib_7322_boardname(struct qib_devdata *dd)
 static int qib_do_7322_reset(struct qib_devdata *dd)
 {
 	u64 val;
-	u64 *msix_vecsave;
+	u64 *msix_vecsave = NULL;
 	int i, msix_entries, ret = 1;
 	u16 cmdval;
 	u8 int_line, clinesz;
@@ -3677,10 +3675,7 @@ static int qib_do_7322_reset(struct qib_devdata *dd)
 		/* can be up to 512 bytes, too big for stack */
 		msix_vecsave = kmalloc(2 * dd->cspec->num_msix_entries *
 			sizeof(u64), GFP_KERNEL);
-		if (!msix_vecsave)
-			qib_dev_err(dd, "No mem to save MSIx data\n");
-	} else
-		msix_vecsave = NULL;
+	}
 
 	/*
 	 * Core PCI (as of 2.6.18) doesn't save or rewrite the full vector
@@ -5043,8 +5038,6 @@ static void init_7322_cntrnames(struct qib_devdata *dd)
 		dd->cspec->cntrnamelen = 1 + s - cntr7322names;
 	dd->cspec->cntrs = kmalloc(dd->cspec->ncntrs
 		* sizeof(u64), GFP_KERNEL);
-	if (!dd->cspec->cntrs)
-		qib_dev_err(dd, "Failed allocation for counters\n");
 
 	for (i = 0, s = (char *)portcntr7322names; s; i++)
 		s = strchr(s + 1, '\n');
@@ -5053,9 +5046,6 @@ static void init_7322_cntrnames(struct qib_devdata *dd)
 	for (i = 0; i < dd->num_pports; ++i) {
 		dd->pport[i].cpspec->portcntrs = kmalloc(dd->cspec->nportcntrs
 			* sizeof(u64), GFP_KERNEL);
-		if (!dd->pport[i].cpspec->portcntrs)
-			qib_dev_err(dd,
-				"Failed allocation for portcounters\n");
 	}
 }
 
@@ -6461,7 +6451,6 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		sizeof(*dd->cspec->sendibchk), GFP_KERNEL);
 	if (!dd->cspec->sendchkenable || !dd->cspec->sendgrhchk ||
 		!dd->cspec->sendibchk) {
-		qib_dev_err(dd, "Failed allocation for hdrchk bitmaps\n");
 		ret = -ENOMEM;
 		goto bail;
 	}
@@ -7338,10 +7327,9 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 	tabsize = actual_cnt;
 	dd->cspec->msix_entries = kzalloc(tabsize *
 			sizeof(struct qib_msix_entry), GFP_KERNEL);
-	if (!dd->cspec->msix_entries) {
-		qib_dev_err(dd, "No memory for MSIx table\n");
+	if (!dd->cspec->msix_entries)
 		tabsize = 0;
-	}
+
 	for (i = 0; i < tabsize; i++)
 		dd->cspec->msix_entries[i].msix.entry = i;
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 1730aa8..b50240b 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -133,11 +133,8 @@ int qib_create_ctxts(struct qib_devdata *dd)
 	 * cleanup iterates across all possible ctxts.
 	 */
 	dd->rcd = kcalloc(dd->ctxtcnt, sizeof(*dd->rcd), GFP_KERNEL);
-	if (!dd->rcd) {
-		qib_dev_err(dd,
-			"Unable to allocate ctxtdata array, failing\n");
+	if (!dd->rcd)
 		return -ENOMEM;
-	}
 
 	/* create (one or more) kctxt */
 	for (i = 0; i < dd->first_user_ctxt; ++i) {
@@ -265,39 +262,23 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 	size = IB_CC_TABLE_CAP_DEFAULT * sizeof(struct ib_cc_table_entry)
 		* IB_CCT_ENTRIES;
 	ppd->ccti_entries = kzalloc(size, GFP_KERNEL);
-	if (!ppd->ccti_entries) {
-		qib_dev_err(dd,
-		  "failed to allocate congestion control table for port %d!\n",
-		  port);
+	if (!ppd->ccti_entries)
 		goto bail;
-	}
 
 	size = IB_CC_CCS_ENTRIES * sizeof(struct ib_cc_congestion_entry);
 	ppd->congestion_entries = kzalloc(size, GFP_KERNEL);
-	if (!ppd->congestion_entries) {
-		qib_dev_err(dd,
-		 "failed to allocate congestion setting list for port %d!\n",
-		 port);
+	if (!ppd->congestion_entries)
 		goto bail_1;
-	}
 
 	size = sizeof(struct cc_table_shadow);
 	ppd->ccti_entries_shadow = kzalloc(size, GFP_KERNEL);
-	if (!ppd->ccti_entries_shadow) {
-		qib_dev_err(dd,
-		 "failed to allocate shadow ccti list for port %d!\n",
-		 port);
+	if (!ppd->ccti_entries_shadow)
 		goto bail_2;
-	}
 
 	size = sizeof(struct ib_cc_congestion_setting_attr);
 	ppd->congestion_entries_shadow = kzalloc(size, GFP_KERNEL);
-	if (!ppd->congestion_entries_shadow) {
-		qib_dev_err(dd,
-		 "failed to allocate shadow congestion setting list for port %d!\n",
-		 port);
+	if (!ppd->congestion_entries_shadow)
 		goto bail_3;
-	}
 
 	return 0;
 
@@ -391,18 +372,12 @@ static void init_shadow_tids(struct qib_devdata *dd)
 	dma_addr_t *addrs;
 
 	pages = vzalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
-	if (!pages) {
-		qib_dev_err(dd,
-			"failed to allocate shadow page * array, no expected sends!\n");
+	if (!pages)
 		goto bail;
-	}
 
 	addrs = vzalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
-	if (!addrs) {
-		qib_dev_err(dd,
-			"failed to allocate shadow dma handle array, no expected sends!\n");
+	if (!addrs)
 		goto bail_free;
-	}
 
 	dd->pageshadow = pages;
 	dd->physshadow = addrs;
@@ -1026,11 +1001,8 @@ static void qib_verify_pioperf(struct qib_devdata *dd)
 	cnt = 1024;
 
 	addr = vmalloc(cnt);
-	if (!addr) {
-		qib_devinfo(dd->pcidev,
-			 "Couldn't get memory for checking PIO perf, skipping\n");
+	if (!addr)
 		goto done;
-	}
 
 	preempt_disable();  /* we want reasonably accurate elapsed time */
 	msecs = 1 + jiffies_to_msecs(jiffies);
@@ -1172,9 +1144,6 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 				      sizeof(long), GFP_KERNEL);
 		if (qib_cpulist)
 			qib_cpulist_count = count;
-		else
-			qib_early_err(&pdev->dev,
-				"Could not alloc cpulist info, cpu affinity might be wrong\n");
 	}
 #ifdef CONFIG_DEBUG_FS
 	qib_dbg_ibdev_init(&dd->verbs_dev);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
