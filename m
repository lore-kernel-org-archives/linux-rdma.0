From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 42/47] IB/qib: Remove set-but-not-used variables
Date: Fri,  6 Oct 2017 14:33:28 -0700
Message-ID: <20171006213333.6721-43-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_diag.c     |  6 ------
 drivers/infiniband/hw/qib/qib_file_ops.c |  9 ---------
 drivers/infiniband/hw/qib/qib_iba6120.c  |  2 --
 drivers/infiniband/hw/qib/qib_iba7220.c  |  3 ---
 drivers/infiniband/hw/qib/qib_iba7322.c  | 15 ++++-----------
 drivers/infiniband/hw/qib/qib_mad.c      |  3 +--
 drivers/infiniband/hw/qib/qib_pcie.c     |  3 +--
 drivers/infiniband/hw/qib/qib_sd7220.c   |  2 --
 drivers/infiniband/hw/qib/qib_tx.c       |  4 ----
 drivers/infiniband/hw/qib/qib_verbs.c    |  3 +--
 10 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 775018b32b0d..a9377eee8734 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -761,7 +761,6 @@ static ssize_t qib_diag_read(struct file *fp, char __user *data,
 {
 	struct qib_diag_client *dc = fp->private_data;
 	struct qib_devdata *dd = dc->dd;
-	void __iomem *kreg_base;
 	ssize_t ret;
 
 	if (dc->pid != current->pid) {
@@ -769,8 +768,6 @@ static ssize_t qib_diag_read(struct file *fp, char __user *data,
 		goto bail;
 	}
 
-	kreg_base = dd->kregbase;
-
 	if (count == 0)
 		ret = 0;
 	else if ((count % 4) || (*off % 4))
@@ -838,7 +835,6 @@ static ssize_t qib_diag_write(struct file *fp, const char __user *data,
 {
 	struct qib_diag_client *dc = fp->private_data;
 	struct qib_devdata *dd = dc->dd;
-	void __iomem *kreg_base;
 	ssize_t ret;
 
 	if (dc->pid != current->pid) {
@@ -846,8 +842,6 @@ static ssize_t qib_diag_write(struct file *fp, const char __user *data,
 		goto bail;
 	}
 
-	kreg_base = dd->kregbase;
-
 	if (count == 0)
 		ret = 0;
 	else if ((count % 4) || (*off % 4))
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 9396c1807cc3..2d6a191afec0 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -696,15 +696,8 @@ static void qib_clean_part_key(struct qib_ctxtdata *rcd,
 			       struct qib_devdata *dd)
 {
 	int i, j, pchanged = 0;
-	u64 oldpkey;
 	struct qib_pportdata *ppd = rcd->ppd;
 
-	/* for debugging only */
-	oldpkey = (u64) ppd->pkeys[0] |
-		((u64) ppd->pkeys[1] << 16) |
-		((u64) ppd->pkeys[2] << 32) |
-		((u64) ppd->pkeys[3] << 48);
-
 	for (i = 0; i < ARRAY_SIZE(rcd->pkeys); i++) {
 		if (!rcd->pkeys[i])
 			continue;
@@ -1817,7 +1810,6 @@ static int qib_close(struct inode *in, struct file *fp)
 	struct qib_devdata *dd;
 	unsigned long flags;
 	unsigned ctxt;
-	pid_t pid;
 
 	mutex_lock(&qib_mutex);
 
@@ -1859,7 +1851,6 @@ static int qib_close(struct inode *in, struct file *fp)
 	spin_lock_irqsave(&dd->uctxt_lock, flags);
 	ctxt = rcd->ctxt;
 	dd->rcd[ctxt] = NULL;
-	pid = rcd->pid;
 	rcd->pid = 0;
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index c4a4c57e0f0a..65d61274ab8f 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1914,7 +1914,6 @@ static void qib_6120_put_tid_2(struct qib_devdata *dd, u64 __iomem *tidptr,
 			       u32 type, unsigned long pa)
 {
 	u32 __iomem *tidp32 = (u32 __iomem *)tidptr;
-	u32 tidx;
 
 	if (!dd->kregbase)
 		return;
@@ -1938,7 +1937,6 @@ static void qib_6120_put_tid_2(struct qib_devdata *dd, u64 __iomem *tidptr,
 		else /* for now, always full 4KB page */
 			pa |= 2 << 29;
 	}
-	tidx = tidptr - dd->egrtidbase;
 	writel(pa, tidp32);
 	mmiowb();
 }
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 78ce79be4120..7df874e54827 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -3524,7 +3524,6 @@ static void autoneg_7220_work(struct work_struct *work)
 {
 	struct qib_pportdata *ppd;
 	struct qib_devdata *dd;
-	u64 startms;
 	u32 i;
 	unsigned long flags;
 
@@ -3532,8 +3531,6 @@ static void autoneg_7220_work(struct work_struct *work)
 			    autoneg_work.work)->pportdata;
 	dd = ppd->dd;
 
-	startms = jiffies_to_msecs(jiffies);
-
 	/*
 	 * Busy wait for this first part, it should be at most a
 	 * few hundred usec, since we scheduled ourselves for 2msec.
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 4d02cffe4e03..a28fc358aff4 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3435,7 +3435,6 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 	for (i = 0; msixnum < dd->cspec->num_msix_entries; i++) {
 		irq_handler_t handler;
 		void *arg;
-		u64 val;
 		int lsb, reg, sh;
 #ifdef CONFIG_INFINIBAND_QIB_DCA
 		int dca = 0;
@@ -3506,8 +3505,8 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 			mask &= ~(1ULL << lsb);
 			redirect[reg] |= ((u64) msixnum) << sh;
 		}
-		val = qib_read_kreg64(dd, 2 * msixnum + 1 +
-			(QIB_7322_MsixTable_OFFS / sizeof(u64)));
+		qib_read_kreg64(dd, 2 * msixnum + 1 +
+				(QIB_7322_MsixTable_OFFS / sizeof(u64)));
 		if (firstcpu < nr_cpu_ids &&
 			zalloc_cpumask_var(
 				&dd->cspec->msix_entries[msixnum].mask,
@@ -5362,16 +5361,11 @@ static void try_7322_autoneg(struct qib_pportdata *ppd)
 static void autoneg_7322_work(struct work_struct *work)
 {
 	struct qib_pportdata *ppd;
-	struct qib_devdata *dd;
-	u64 startms;
 	u32 i;
 	unsigned long flags;
 
 	ppd = container_of(work, struct qib_chippport_specific,
 			    autoneg_work.work)->ppd;
-	dd = ppd->dd;
-
-	startms = jiffies_to_msecs(jiffies);
 
 	/*
 	 * Busy wait for this first part, it should be at most a
@@ -7811,13 +7805,12 @@ static void ibsd_wr_allchans(struct qib_pportdata *ppd, int addr, unsigned data,
 {
 	struct qib_devdata *dd = ppd->dd;
 	int chan;
-	u32 rbc;
 
 	for (chan = 0; chan < SERDES_CHANS; ++chan) {
 		ahb_mod(dd, IBSD(ppd->hw_pidx), (chan + (chan >> 1)), addr,
 			data, mask);
-		rbc = ahb_mod(dd, IBSD(ppd->hw_pidx), (chan + (chan >> 1)),
-			      addr, 0, 0);
+		ahb_mod(dd, IBSD(ppd->hw_pidx), (chan + (chan >> 1)), addr,
+			0, 0);
 	}
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 04367e0f6f9b..841312f60dfd 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -280,7 +280,7 @@ static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
 {
 	struct ib_node_info *nip = (struct ib_node_info *)&smp->data;
 	struct qib_devdata *dd = dd_from_ibdev(ibdev);
-	u32 vendor, majrev, minrev;
+	u32 majrev, minrev;
 	unsigned pidx = port - 1; /* IB number port from 1, hdw from 0 */
 
 	/* GUID 0 is illegal */
@@ -303,7 +303,6 @@ static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	minrev = dd->minrev;
 	nip->revision = cpu_to_be32((majrev << 16) | minrev);
 	nip->local_port_num = port;
-	vendor = dd->vendorid;
 	nip->vendor_id[0] = QIB_SRC_OUI_1;
 	nip->vendor_id[1] = QIB_SRC_OUI_2;
 	nip->vendor_id[2] = QIB_SRC_OUI_3;
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 6f4cc268926c..5ac7b31c346b 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -397,7 +397,6 @@ MODULE_PARM_DESC(pcie_coalesce, "tune PCIe colescing on some Intel chipsets");
  */
 static void qib_tune_pcie_coalesce(struct qib_devdata *dd)
 {
-	int r;
 	struct pci_dev *parent;
 	u16 devid;
 	u32 mask, bits, val;
@@ -452,7 +451,7 @@ static void qib_tune_pcie_coalesce(struct qib_devdata *dd)
 	pci_read_config_dword(parent, 0x48, &val);
 	val &= ~mask;
 	val |= bits;
-	r = pci_write_config_dword(parent, 0x48, val);
+	pci_write_config_dword(parent, 0x48, val);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index c72775f27212..ad52f7ac620c 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -755,7 +755,6 @@ static int qib_sd7220_ram_xfer(struct qib_devdata *dd, int sdnum, u32 loc,
 	int addr;
 	int ret;
 	unsigned long flags;
-	const char *op;
 
 	/* Pick appropriate transaction reg and "Chip select" for this serdes */
 	switch (sdnum) {
@@ -775,7 +774,6 @@ static int qib_sd7220_ram_xfer(struct qib_devdata *dd, int sdnum, u32 loc,
 		return -1;
 	}
 
-	op = rd_notwr ? "Rd" : "Wr";
 	spin_lock_irqsave(&dd->cspec->sdepb_lock, flags);
 
 	owned = epb_access(dd, sdnum, 1);
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index eface3b3dacf..c9537cfc12ce 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -179,8 +179,6 @@ void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
 		pppd[i] = NULL;
 
 	for (i = 0; i < cnt; i++) {
-		int which;
-
 		if (!test_bit(i, mask))
 			continue;
 		/*
@@ -201,9 +199,7 @@ void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
 		    (!test_bit(i << 1, dd->pioavailkernel) &&
 		     find_ctxt(dd, i))) {
 			__set_bit(i, dd->pio_need_disarm);
-			which = 0;
 		} else {
-			which = 1;
 			dd->f_sendctrl(dd->pport, QIB_SENDCTRL_DISARM_BUF(i));
 		}
 		spin_unlock_irqrestore(&dd->pioavail_lock, flags);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9d92aeb8d9a1..46e2da09d05b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -701,7 +701,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
  */
 void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 {
-	struct rvt_qp *qp, *nqp;
+	struct rvt_qp *qp;
 	struct qib_qp_priv *qpp, *nqpp;
 	struct rvt_qp *qps[20];
 	struct qib_ibdev *dev;
@@ -714,7 +714,6 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 	/* Search wait list for first QP wanting DMA descriptors. */
 	list_for_each_entry_safe(qpp, nqpp, &dev->dmawait, iowait) {
 		qp = qpp->owner;
-		nqp = nqpp->owner;
 		if (qp->port_num != ppd->port)
 			continue;
 		if (n == ARRAY_SIZE(qps))
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
