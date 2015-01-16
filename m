From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] IB/qib: add blank line after declaration
Date: Fri, 16 Jan 2015 11:23:31 -0500
Message-ID: <20150116162331.28295.99044.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upstream checkpatch now requires this.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_diag.c      |    5 +++++
 drivers/infiniband/hw/qib/qib_driver.c    |    3 +++
 drivers/infiniband/hw/qib/qib_eeprom.c    |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c  |    6 ++++++
 drivers/infiniband/hw/qib/qib_fs.c        |    1 +
 drivers/infiniband/hw/qib/qib_iba6120.c   |    5 +++++
 drivers/infiniband/hw/qib/qib_iba7220.c   |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c   |   22 ++++++++++++++++++++--
 drivers/infiniband/hw/qib/qib_init.c      |    4 ++++
 drivers/infiniband/hw/qib/qib_pcie.c      |    2 ++
 drivers/infiniband/hw/qib/qib_qsfp.c      |    4 ++++
 drivers/infiniband/hw/qib/qib_sd7220.c    |    5 +++++
 drivers/infiniband/hw/qib/qib_twsi.c      |    5 +++--
 drivers/infiniband/hw/qib/qib_tx.c        |    1 +
 drivers/infiniband/hw/qib/qib_user_sdma.c |    2 ++
 drivers/infiniband/hw/qib/qib_verbs.c     |    1 +
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |    5 +++--
 17 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index f2d354c..8c34b23 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -257,6 +257,7 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 	if (dd->userbase) {
 		/* If user regs mapped, they are after send, so set limit. */
 		u32 ulim = (dd->cfgctxts * dd->ureg_align) + dd->uregbase;
+
 		if (!dd->piovl15base)
 			snd_lim = dd->uregbase;
 		krb32 = (u32 __iomem *)dd->userbase;
@@ -280,6 +281,7 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 	snd_bottom = dd->pio2k_bufbase;
 	if (snd_lim == 0) {
 		u32 tot2k = dd->piobcnt2k * ALIGN(dd->piosize2k, dd->palign);
+
 		snd_lim = snd_bottom + tot2k;
 	}
 	/* If 4k buffers exist, account for them by bumping
@@ -398,6 +400,7 @@ static int qib_write_umem64(struct qib_devdata *dd, u32 regoffs,
 	/* not very efficient, but it works for now */
 	while (reg_addr < reg_end) {
 		u64 data;
+
 		if (copy_from_user(&data, uaddr, sizeof(data))) {
 			ret = -EFAULT;
 			goto bail;
@@ -796,6 +799,7 @@ static ssize_t qib_diag_read(struct file *fp, char __user *data,
 		op = diag_get_observer(dd, *off);
 		if (op) {
 			u32 offset = *off;
+
 			ret = op->hook(dd, op, offset, &data64, 0, use_32);
 		}
 		/*
@@ -873,6 +877,7 @@ static ssize_t qib_diag_write(struct file *fp, const char __user *data,
 		if (count == 4 || count == 8) {
 			u64 data64;
 			u32 offset = *off;
+
 			ret = copy_from_user(&data64, data, count);
 			if (ret) {
 				ret = -EFAULT;
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index d10b60e..f58fdc3 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -349,6 +349,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		qp_num = be32_to_cpu(ohdr->bth[1]) & QIB_QPN_MASK;
 		if (qp_num != QIB_MULTICAST_QPN) {
 			int ruc_res;
+
 			qp = qib_lookup_qpn(ibp, qp_num);
 			if (!qp)
 				goto drop;
@@ -461,6 +462,7 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 	rhf_addr = (__le32 *) rcd->rcvhdrq + l + dd->rhf_offset;
 	if (dd->flags & QIB_NODMA_RTAIL) {
 		u32 seq = qib_hdrget_seq(rhf_addr);
+
 		if (seq != rcd->seq_cnt)
 			goto bail;
 		hdrqtail = 0;
@@ -651,6 +653,7 @@ bail:
 int qib_set_lid(struct qib_pportdata *ppd, u32 lid, u8 lmc)
 {
 	struct qib_devdata *dd = ppd->dd;
+
 	ppd->lid = lid;
 	ppd->lmc = lmc;
 
diff --git a/drivers/infiniband/hw/qib/qib_eeprom.c b/drivers/infiniband/hw/qib/qib_eeprom.c
index c1a8f44..d35805e 100644
--- a/drivers/infiniband/hw/qib/qib_eeprom.c
+++ b/drivers/infiniband/hw/qib/qib_eeprom.c
@@ -153,6 +153,7 @@ void qib_get_eeprom_info(struct qib_devdata *dd)
 
 	if (t && dd0->nguid > 1 && t <= dd0->nguid) {
 		u8 oguid;
+
 		dd->base_guid = dd0->base_guid;
 		bguid = (u8 *) &dd->base_guid;
 
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index b16ceb2..9860001 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1185,6 +1185,7 @@ static void assign_ctxt_affinity(struct file *fp, struct qib_devdata *dd)
 	 */
 	if (weight >= qib_cpulist_count) {
 		int cpu;
+
 		cpu = find_first_zero_bit(qib_cpulist,
 					  qib_cpulist_count);
 		if (cpu == qib_cpulist_count)
@@ -1391,6 +1392,7 @@ static int choose_port_ctxt(struct file *fp, struct qib_devdata *dd, u32 port,
 	}
 	if (!ppd) {
 		u32 pidx = ctxt % dd->num_pports;
+
 		if (usable(dd->pport + pidx))
 			ppd = dd->pport + pidx;
 		else {
@@ -1438,10 +1440,12 @@ static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo,
 
 	if (alg == QIB_PORT_ALG_ACROSS) {
 		unsigned inuse = ~0U;
+
 		/* find device (with ACTIVE ports) with fewest ctxts in use */
 		for (ndev = 0; ndev < devmax; ndev++) {
 			struct qib_devdata *dd = qib_lookup(ndev);
 			unsigned cused = 0, cfree = 0, pusable = 0;
+
 			if (!dd)
 				continue;
 			if (port && port <= dd->num_pports &&
@@ -1471,6 +1475,7 @@ static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo,
 	} else {
 		for (ndev = 0; ndev < devmax; ndev++) {
 			struct qib_devdata *dd = qib_lookup(ndev);
+
 			if (dd) {
 				ret = choose_port_ctxt(fp, dd, port, uinfo);
 				if (!ret)
@@ -1556,6 +1561,7 @@ static int find_hca(unsigned int cpu, int *unit)
 	}
 	for (ndev = 0; ndev < devmax; ndev++) {
 		struct qib_devdata *dd = qib_lookup(ndev);
+
 		if (dd) {
 			if (pcibus_to_node(dd->pcidev->bus) < 0) {
 				ret = -EINVAL;
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 9019f56..097d630 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -561,6 +561,7 @@ static struct dentry *qibfs_mount(struct file_system_type *fs_type, int flags,
 			const char *dev_name, void *data)
 {
 	struct dentry *ret;
+
 	ret = mount_single(fs_type, flags, data, qibfs_fill_super);
 	if (!IS_ERR(ret))
 		qib_super = ret->d_sb;
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index a8d0619..0d2ba59 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -333,6 +333,7 @@ static inline void qib_write_ureg(const struct qib_devdata *dd,
 				  enum qib_ureg regno, u64 value, int ctxt)
 {
 	u64 __iomem *ubase;
+
 	if (dd->userbase)
 		ubase = (u64 __iomem *)
 			((char __iomem *) dd->userbase +
@@ -1670,6 +1671,7 @@ static irqreturn_t qib_6120intr(int irq, void *data)
 		}
 		if (crcs) {
 			u32 cntr = dd->cspec->lli_counter;
+
 			cntr += crcs;
 			if (cntr) {
 				if (cntr > dd->cspec->lli_thresh) {
@@ -1722,6 +1724,7 @@ static void qib_setup_6120_interrupt(struct qib_devdata *dd)
 			"irq is 0, BIOS error?  Interrupts won't work\n");
 	else {
 		int ret;
+
 		ret = request_irq(dd->cspec->irq, qib_6120intr, 0,
 				  QIB_DRV_NAME, dd);
 		if (ret)
@@ -2927,6 +2930,7 @@ bail:
 static int qib_6120_set_loopback(struct qib_pportdata *ppd, const char *what)
 {
 	int ret = 0;
+
 	if (!strncmp(what, "ibc", 3)) {
 		ppd->dd->cspec->ibcctrl |= SYM_MASK(IBCCtrl, Loopback);
 		qib_devinfo(ppd->dd->pcidev, "Enabling IB%u:%u IBC loopback\n",
@@ -3168,6 +3172,7 @@ static void get_6120_chip_params(struct qib_devdata *dd)
 static void set_6120_baseaddrs(struct qib_devdata *dd)
 {
 	u32 cregbase;
+
 	cregbase = qib_read_kreg32(dd, kr_counterregbase);
 	dd->cspec->cregbase = (u64 __iomem *)
 		((char __iomem *) dd->kregbase + cregbase);
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index ece2993..22affda 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1044,6 +1044,7 @@ done:
 static void reenable_7220_chase(unsigned long opaque)
 {
 	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+
 	ppd->cpspec->chase_timer.expires = 0;
 	qib_set_ib_7220_lstate(ppd, QLOGIC_IB_IBCC_LINKCMD_DOWN,
 		QLOGIC_IB_IBCC_LINKINITCMD_POLL);
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index e33c719..f17e703 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -796,6 +796,7 @@ static inline void qib_write_ureg(const struct qib_devdata *dd,
 				  enum qib_ureg regno, u64 value, int ctxt)
 {
 	u64 __iomem *ubase;
+
 	if (dd->userbase)
 		ubase = (u64 __iomem *)
 			((char __iomem *) dd->userbase +
@@ -2010,6 +2011,7 @@ static void qib_7322_set_intr_state(struct qib_devdata *dd, u32 enable)
 		if (dd->cspec->num_msix_entries) {
 			/* and same for MSIx */
 			u64 val = qib_read_kreg64(dd, kr_intgranted);
+
 			if (val)
 				qib_write_kreg(dd, kr_intgranted, val);
 		}
@@ -2155,6 +2157,7 @@ static void qib_7322_handle_hwerrors(struct qib_devdata *dd, char *msg,
 		int err;
 		unsigned long flags;
 		struct qib_pportdata *ppd = dd->pport;
+
 		for (; pidx < dd->num_pports; ++pidx, ppd++) {
 			err = 0;
 			if (pidx == 0 && (hwerrs &
@@ -2780,9 +2783,11 @@ static void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
 
 	if (n->rcv) {
 		struct qib_ctxtdata *rcd = (struct qib_ctxtdata *)n->arg;
+
 		qib_update_rhdrq_dca(rcd, cpu);
 	} else {
 		struct qib_pportdata *ppd = (struct qib_pportdata *)n->arg;
+
 		qib_update_sdma_dca(ppd, cpu);
 	}
 }
@@ -2795,9 +2800,11 @@ static void qib_irq_notifier_release(struct kref *ref)
 
 	if (n->rcv) {
 		struct qib_ctxtdata *rcd = (struct qib_ctxtdata *)n->arg;
+
 		dd = rcd->dd;
 	} else {
 		struct qib_pportdata *ppd = (struct qib_pportdata *)n->arg;
+
 		dd = ppd->dd;
 	}
 	qib_devinfo(dd->pcidev,
@@ -2973,6 +2980,7 @@ static noinline void unknown_7322_gpio_intr(struct qib_devdata *dd)
 		struct qib_pportdata *ppd;
 		struct qib_qsfp_data *qd;
 		u32 mask;
+
 		if (!dd->pport[pidx].link_speed_supported)
 			continue;
 		mask = QSFP_GPIO_MOD_PRS_N;
@@ -2980,6 +2988,7 @@ static noinline void unknown_7322_gpio_intr(struct qib_devdata *dd)
 		mask <<= (QSFP_GPIO_PORT2_SHIFT * ppd->hw_pidx);
 		if (gpiostatus & dd->cspec->gpio_mask & mask) {
 			u64 pins;
+
 			qd = &ppd->cpspec->qsfp_data;
 			gpiostatus &= ~mask;
 			pins = qib_read_kreg64(dd, kr_extstatus);
@@ -3677,6 +3686,7 @@ static int qib_do_7322_reset(struct qib_devdata *dd)
 	 */
 	for (i = 0; i < msix_entries; i++) {
 		u64 vecaddr, vecdata;
+
 		vecaddr = qib_read_kreg64(dd, 2 * i +
 				  (QIB_7322_MsixTable_OFFS / sizeof(u64)));
 		vecdata = qib_read_kreg64(dd, 1 + 2 * i +
@@ -5338,6 +5348,7 @@ static void qib_autoneg_7322_send(struct qib_pportdata *ppd, int which)
 static void set_7322_ibspeed_fast(struct qib_pportdata *ppd, u32 speed)
 {
 	u64 newctrlb;
+
 	newctrlb = ppd->cpspec->ibcctrl_b & ~(IBA7322_IBC_SPEED_MASK |
 				    IBA7322_IBC_IBTA_1_2_MASK |
 				    IBA7322_IBC_MAX_SPEED_MASK);
@@ -5824,6 +5835,7 @@ static void get_7322_chip_params(struct qib_devdata *dd)
 static void qib_7322_set_baseaddrs(struct qib_devdata *dd)
 {
 	u32 cregbase;
+
 	cregbase = qib_read_kreg32(dd, kr_counterregbase);
 
 	dd->cspec->cregbase = (u64 __iomem *)(cregbase +
@@ -6164,6 +6176,7 @@ static int setup_txselect(const char *str, struct kernel_param *kp)
 	struct qib_devdata *dd;
 	unsigned long val;
 	char *n;
+
 	if (strlen(str) >= MAX_ATTEN_LEN) {
 		pr_info("txselect_values string too long\n");
 		return -ENOSPC;
@@ -6374,6 +6387,7 @@ static void write_7322_initregs(struct qib_devdata *dd)
 	val = TIDFLOW_ERRBITS; /* these are W1C */
 	for (i = 0; i < dd->cfgctxts; i++) {
 		int flow;
+
 		for (flow = 0; flow < NUM_TIDFLOWS_CTXT; flow++)
 			qib_write_ureg(dd, ur_rcvflowtable+flow, val, i);
 	}
@@ -6484,6 +6498,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 
 	for (pidx = 0; pidx < NUM_IB_PORTS; ++pidx) {
 		struct qib_chippport_specific *cp = ppd->cpspec;
+
 		ppd->link_speed_supported = features & PORT_SPD_CAP;
 		features >>=  PORT_SPD_CAP_SHIFT;
 		if (!ppd->link_speed_supported) {
@@ -7871,6 +7886,7 @@ static void serdes_7322_los_enable(struct qib_pportdata *ppd, int enable)
 static int serdes_7322_init(struct qib_pportdata *ppd)
 {
 	int ret = 0;
+
 	if (ppd->dd->cspec->r1)
 		ret = serdes_7322_init_old(ppd);
 	else
@@ -8286,8 +8302,8 @@ static void force_h1(struct qib_pportdata *ppd)
 
 static int qib_r_grab(struct qib_devdata *dd)
 {
-	u64 val;
-	val = SJA_EN;
+	u64 val = SJA_EN;
+
 	qib_write_kreg(dd, kr_r_access, val);
 	qib_read_kreg32(dd, kr_scratch);
 	return 0;
@@ -8300,6 +8316,7 @@ static int qib_r_wait_for_rdy(struct qib_devdata *dd)
 {
 	u64 val;
 	int timeout;
+
 	for (timeout = 0; timeout < 100 ; ++timeout) {
 		val = qib_read_kreg32(dd, kr_r_access);
 		if (val & R_RDY)
@@ -8327,6 +8344,7 @@ static int qib_r_shift(struct qib_devdata *dd, int bisten,
 		}
 		if (inp) {
 			int tdi = inp[pos >> 3] >> (pos & 7);
+
 			val |= ((tdi & 1) << R_TDI_LSB);
 		}
 		qib_write_kreg(dd, kr_r_access, val);
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 738269b..ae979a1 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -234,6 +234,7 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 			u8 hw_pidx, u8 port)
 {
 	int size;
+
 	ppd->dd = dd;
 	ppd->hw_pidx = hw_pidx;
 	ppd->port = port; /* IB port number, not index */
@@ -613,6 +614,7 @@ static int qib_create_workqueues(struct qib_devdata *dd)
 		ppd = dd->pport + pidx;
 		if (!ppd->qib_wq) {
 			char wq_name[8]; /* 3 + 2 + 1 + 1 + 1 */
+
 			snprintf(wq_name, sizeof(wq_name), "qib%d_%d",
 				dd->unit, pidx);
 			ppd->qib_wq =
@@ -714,6 +716,7 @@ int qib_init(struct qib_devdata *dd, int reinit)
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		int mtu;
+
 		if (lastfail)
 			ret = lastfail;
 		ppd = dd->pport + pidx;
@@ -1162,6 +1165,7 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 
 	if (!qib_cpulist_count) {
 		u32 count = num_online_cpus();
+
 		qib_cpulist = kzalloc(BITS_TO_LONGS(count) *
 				      sizeof(long), GFP_KERNEL);
 		if (qib_cpulist)
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 61a0046..130ec33 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -459,6 +459,7 @@ void qib_pcie_getcmd(struct qib_devdata *dd, u16 *cmd, u8 *iline, u8 *cline)
 void qib_pcie_reenable(struct qib_devdata *dd, u16 cmd, u8 iline, u8 cline)
 {
 	int r;
+
 	r = pci_write_config_dword(dd->pcidev, PCI_BASE_ADDRESS_0,
 				   dd->pcibar0);
 	if (r)
@@ -696,6 +697,7 @@ static void
 qib_pci_resume(struct pci_dev *pdev)
 {
 	struct qib_devdata *dd = pci_get_drvdata(pdev);
+
 	qib_devinfo(pdev, "QIB resume function called\n");
 	pci_cleanup_aer_uncorrect_error_status(pdev);
 	/*
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index fa71b1e..7d36d96 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -99,6 +99,7 @@ static int qsfp_read(struct qib_pportdata *ppd, int addr, void *bp, int len)
 	while (cnt < len) {
 		unsigned in_page;
 		int wlen = len - cnt;
+
 		in_page = addr % QSFP_PAGESIZE;
 		if ((in_page + wlen) > QSFP_PAGESIZE)
 			wlen = QSFP_PAGESIZE - in_page;
@@ -206,6 +207,7 @@ static int qib_qsfp_write(struct qib_pportdata *ppd, int addr, void *bp,
 	while (cnt < len) {
 		unsigned in_page;
 		int wlen = len - cnt;
+
 		in_page = addr % QSFP_PAGESIZE;
 		if ((in_page + wlen) > QSFP_PAGESIZE)
 			wlen = QSFP_PAGESIZE - in_page;
@@ -296,6 +298,7 @@ int qib_refresh_qsfp_cache(struct qib_pportdata *ppd, struct qib_qsfp_cache *cp)
 		 * set the page to zero, Even if it already appears to be zero.
 		 */
 		u8 poke = 0;
+
 		ret = qib_qsfp_write(ppd, 127, &poke, 1);
 		udelay(50);
 		if (ret != 1) {
@@ -540,6 +543,7 @@ int qib_qsfp_dump(struct qib_pportdata *ppd, char *buf, int len)
 
 	while (bidx < QSFP_DEFAULT_HDR_CNT) {
 		int iidx;
+
 		ret = qsfp_read(ppd, bidx, bin_buff, QSFP_DUMP_CHUNK);
 		if (ret < 0)
 			goto bail;
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index 911205d..2a3ff40 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -259,6 +259,7 @@ static int qib_ibsd_reset(struct qib_devdata *dd, int assert_rst)
 		 * it again during startup.
 		 */
 		u64 val;
+
 		rst_val &= ~(1ULL);
 		qib_write_kreg(dd, kr_hwerrmask,
 			       dd->cspec->hwerrmask &
@@ -590,6 +591,7 @@ static int epb_access(struct qib_devdata *dd, int sdnum, int claim)
 		 * Both should be clear
 		 */
 		u64 newval = 0;
+
 		qib_write_kreg(dd, acc, newval);
 		/* First read after write is not trustworthy */
 		pollval = qib_read_kreg32(dd, acc);
@@ -601,6 +603,7 @@ static int epb_access(struct qib_devdata *dd, int sdnum, int claim)
 		/* Need to claim */
 		u64 pollval;
 		u64 newval = EPB_ACC_REQ | oct_sel;
+
 		qib_write_kreg(dd, acc, newval);
 		/* First read after write is not trustworthy */
 		pollval = qib_read_kreg32(dd, acc);
@@ -812,6 +815,7 @@ static int qib_sd7220_ram_xfer(struct qib_devdata *dd, int sdnum, u32 loc,
 			if (!sofar) {
 				/* Only set address at start of chunk */
 				int addrbyte = (addr + sofar) >> 8;
+
 				transval = csbit | EPB_MADDRH | addrbyte;
 				tries = epb_trans(dd, trans, transval,
 						  &transval);
@@ -1071,6 +1075,7 @@ static int qib_sd_setvals(struct qib_devdata *dd)
 		dds_reg_map >>= 4;
 		for (midx = 0; midx < DDS_ROWS; ++midx) {
 			u64 __iomem *daddr = taddr + ((midx << 4) + idx);
+
 			data = dds_init_vals[midx].reg_vals[idx];
 			writeq(data, daddr);
 			mmiowb();
diff --git a/drivers/infiniband/hw/qib/qib_twsi.c b/drivers/infiniband/hw/qib/qib_twsi.c
index 647f7be..f569866 100644
--- a/drivers/infiniband/hw/qib/qib_twsi.c
+++ b/drivers/infiniband/hw/qib/qib_twsi.c
@@ -105,6 +105,7 @@ static void scl_out(struct qib_devdata *dd, u8 bit)
 		udelay(2);
 	else {
 		int rise_usec;
+
 		for (rise_usec = SCL_WAIT_USEC; rise_usec > 0; rise_usec -= 2) {
 			if (mask & dd->f_gpio_mod(dd, 0, 0, 0))
 				break;
@@ -326,6 +327,7 @@ int qib_twsi_reset(struct qib_devdata *dd)
 static int qib_twsi_wr(struct qib_devdata *dd, int data, int flags)
 {
 	int ret = 1;
+
 	if (flags & QIB_TWSI_START)
 		start_seq(dd);
 
@@ -435,8 +437,7 @@ int qib_twsi_blk_wr(struct qib_devdata *dd, int dev, int addr,
 	int sub_len;
 	const u8 *bp = buffer;
 	int max_wait_time, i;
-	int ret;
-	ret = 1;
+	int ret = 1;
 
 	while (len > 0) {
 		if (dev == QIB_TWSI_NO_DEV) {
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index 31d3561..eface3b 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -180,6 +180,7 @@ void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
 
 	for (i = 0; i < cnt; i++) {
 		int which;
+
 		if (!test_bit(i, mask))
 			continue;
 		/*
diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index d2806ca..8ad1414 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -226,6 +226,7 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
 		sdma_rb_node->refcount++;
 	} else {
 		int ret;
+
 		sdma_rb_node = kmalloc(sizeof(
 			struct qib_user_sdma_rb_node), GFP_KERNEL);
 		if (!sdma_rb_node)
@@ -936,6 +937,7 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 
 			if (tiddma) {
 				char *tidsm = (char *)pkt + pktsize;
+
 				cfur = copy_from_user(tidsm,
 					iov[idx].iov_base, tidsmsize);
 				if (cfur) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 10233e4..f279f9c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1342,6 +1342,7 @@ static int qib_verbs_send_pio(struct qib_qp *qp, struct qib_ib_header *ibhdr,
 done:
 	if (dd->flags & QIB_USE_SPCL_TRIG) {
 		u32 spcl_off = (pbufn >= dd->piobcnt2k) ? 2047 : 1023;
+
 		qib_flush_wc();
 		__raw_writel(0xaebecede, piobuf_orig + spcl_off);
 	}
diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
index 1d7281c..4a3d730 100644
--- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
+++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
@@ -72,6 +72,7 @@ int qib_enable_wc(struct qib_devdata *dd)
 	if (dd->piobcnt2k && dd->piobcnt4k) {
 		/* 2 sizes for chip */
 		unsigned long pio2kbase, pio4kbase;
+
 		pio2kbase = dd->piobufbase & 0xffffffffUL;
 		pio4kbase = (dd->piobufbase >> 32) & 0xffffffffUL;
 		if (pio2kbase < pio4kbase) {
@@ -100,8 +101,8 @@ int qib_enable_wc(struct qib_devdata *dd)
 		piolen = 1ULL << (bits + 1);
 	}
 	if (pioaddr & (piolen - 1)) {
-		u64 atmp;
-		atmp = pioaddr & ~(piolen - 1);
+		u64 atmp = pioaddr & ~(piolen - 1);
+
 		if (atmp < addr || (atmp + piolen) > (addr + len)) {
 			qib_dev_err(dd,
 				"No way to align address/size (%llx/%llx), no WC mtrr\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
