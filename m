From: <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Thu, 28 Apr 2016 12:22:34 +0300
Message-ID: <1461835354-3077-1-git-send-email-omer.dagan@tandemg.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>

Signed-off-by: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
---
 drivers/staging/rdma/hfi1/aspm.h         |  6 +++---
 drivers/staging/rdma/hfi1/chip.c         | 30 +++++++++++++++---------------
 drivers/staging/rdma/hfi1/chip.h         |  8 ++++----
 drivers/staging/rdma/hfi1/file_ops.c     | 32 ++++++++++++++++----------------
 drivers/staging/rdma/hfi1/hfi.h          | 14 +++++++-------
 drivers/staging/rdma/hfi1/init.c         | 16 ++++++++--------
 drivers/staging/rdma/hfi1/iowait.h       |  4 ++--
 drivers/staging/rdma/hfi1/mad.c          | 14 +++++++-------
 drivers/staging/rdma/hfi1/pio.c          |  4 ++--
 drivers/staging/rdma/hfi1/qp.c           | 12 ++++++------
 drivers/staging/rdma/hfi1/qp.h           |  2 +-
 drivers/staging/rdma/hfi1/qsfp.h         |  2 +-
 drivers/staging/rdma/hfi1/rc.c           |  8 ++++----
 drivers/staging/rdma/hfi1/ruc.c          |  4 ++--
 drivers/staging/rdma/hfi1/sdma.c         | 28 ++++++++++++++--------------
 drivers/staging/rdma/hfi1/sdma.h         | 10 +++++-----
 drivers/staging/rdma/hfi1/trace.h        | 24 ++++++++++++------------
 drivers/staging/rdma/hfi1/ud.c           |  6 +++---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 30 +++++++++++++++---------------
 drivers/staging/rdma/hfi1/user_pages.c   |  2 +-
 drivers/staging/rdma/hfi1/user_sdma.c    | 30 +++++++++++++++---------------
 drivers/staging/rdma/hfi1/user_sdma.h    |  6 +++---
 drivers/staging/rdma/hfi1/verbs.c        |  6 +++---
 drivers/staging/rdma/hfi1/verbs.h        |  2 +-
 24 files changed, 150 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/staging/rdma/hfi1/aspm.h
index 0d58fe3..384df0a 100644
--- a/drivers/staging/rdma/hfi1/aspm.h
+++ b/drivers/staging/rdma/hfi1/aspm.h
@@ -234,7 +234,7 @@ static inline void aspm_disable_all(struct hfi1_devdata *dd)
 {
 	struct hfi1_ctxtdata *rcd;
 	unsigned long flags;
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < dd->first_user_ctxt; i++) {
 		rcd = dd->rcd[i];
@@ -253,7 +253,7 @@ static inline void aspm_enable_all(struct hfi1_devdata *dd)
 {
 	struct hfi1_ctxtdata *rcd;
 	unsigned long flags;
-	unsigned i;
+	unsigned int i;
 
 	aspm_enable(dd);
 
@@ -281,7 +281,7 @@ static inline void aspm_ctx_init(struct hfi1_ctxtdata *rcd)
 
 static inline void aspm_init(struct hfi1_devdata *dd)
 {
-	unsigned i;
+	unsigned int i;
 
 	spin_lock_init(&dd->aspm_lock);
 	dd->aspm_supported = aspm_hw_l1_supported(dd);
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 16eb653..99a7037 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1252,9 +1252,9 @@ CNTR_ELEM(#name, \
 
 u64 read_csr(const struct hfi1_devdata *dd, u32 offset)
 {
-	if (dd->flags & HFI1_PRESENT) {
+	if (dd->flags & HFI1_PRESENT)
 		return readq((void __iomem *)dd->kregbase + offset);
-	}
+
 	return -1;
 }
 
@@ -12672,7 +12672,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int num_kernel_contexts;
 	int total_contexts;
 	int ret;
-	unsigned ngroups;
+	unsigned int ngroups;
 
 	/*
 	 * Kernel contexts: (to be fixed later):
@@ -13491,7 +13491,7 @@ static void init_qpmap_table(struct hfi1_devdata *dd,
 static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 {
 	u8 max_by_vl = 0;
-	unsigned qpns_per_vl, ctxt, i, qpn, n = 1, m;
+	unsigned int qpns_per_vl, ctxt, i, qpn, n = 1, m;
 	u64 *rsmmap;
 	u64 reg;
 	u8  rxcontext = is_ax(dd) ? 0 : 0xff;  /* 0 is default if a0 ver. */
@@ -13501,7 +13501,7 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	    num_vls == 1 ||
 	    krcvqsset <= 1)
 		goto bail;
-	for (i = 0; i < min_t(unsigned, num_vls, krcvqsset); i++)
+	for (i = 0; i < min_t(unsigned int, num_vls, krcvqsset); i++)
 		if (krcvqs[i] > max_by_vl)
 			max_by_vl = krcvqs[i];
 	if (max_by_vl > 32)
@@ -13521,11 +13521,11 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
 	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
 	/* init the local copy of the table */
 	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
-		unsigned tctxt;
+		unsigned int tctxt;
 
 		for (qpn = 0, tctxt = ctxt;
 		     krcvqs[i] && qpn < qpns_per_vl; qpn++) {
-			unsigned idx, regoff, regidx;
+			unsigned int idx, regoff, regidx;
 
 			/* generate index <= 128 */
 			idx = (qpn << n) ^ i;
@@ -13673,10 +13673,10 @@ static void init_txe(struct hfi1_devdata *dd)
 		write_csr(dd, SEND_CM_TIMER_CTRL, HFI1_CREDIT_RETURN_RATE);
 }
 
-int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
+int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned int ctxt, u16 jkey)
 {
 	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
-	unsigned sctxt;
+	unsigned int sctxt;
 	int ret = 0;
 	u64 reg;
 
@@ -13710,10 +13710,10 @@ done:
 	return ret;
 }
 
-int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt)
+int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned int ctxt)
 {
 	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
-	unsigned sctxt;
+	unsigned int sctxt;
 	int ret = 0;
 	u64 reg;
 
@@ -13739,10 +13739,10 @@ done:
 	return ret;
 }
 
-int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
+int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned int ctxt, u16 pkey)
 {
 	struct hfi1_ctxtdata *rcd;
-	unsigned sctxt;
+	unsigned int sctxt;
 	int ret = 0;
 	u64 reg;
 
@@ -13767,10 +13767,10 @@ done:
 	return ret;
 }
 
-int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt)
+int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned int ctxt)
 {
 	struct hfi1_ctxtdata *rcd;
-	unsigned sctxt;
+	unsigned int sctxt;
 	int ret = 0;
 	u64 reg;
 
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 4f3b878..0edac0d 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -1339,10 +1339,10 @@ u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp);
 u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd);
 int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which);
 int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val);
-int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey);
-int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt);
-int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey);
-int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt);
+int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned int ctxt, u16 jkey);
+int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned int ctxt);
+int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned int ctxt, u16 pkey);
+int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned int ctxt);
 void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality);
 
 /*
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 8396dc5..aff410e 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -85,15 +85,15 @@ static int get_base_info(struct file *, void __user *, __u32);
 static int setup_ctxt(struct file *);
 static int setup_subctxt(struct hfi1_ctxtdata *);
 static int get_user_context(struct file *, struct hfi1_user_info *,
-			    int, unsigned);
+			    int, unsigned int);
 static int find_shared_ctxt(struct file *, const struct hfi1_user_info *);
 static int allocate_ctxt(struct file *, struct hfi1_devdata *,
 			 struct hfi1_user_info *);
 static unsigned int poll_urgent(struct file *, struct poll_table_struct *);
 static unsigned int poll_next(struct file *, struct poll_table_struct *);
 static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
-static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
-static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
+static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned int, u16);
+static int manage_rcvq(struct hfi1_ctxtdata *, unsigned int, int);
 static int vma_fault(struct vm_area_struct *, struct vm_fault *);
 
 static const struct file_operations hfi1_file_ops = {
@@ -713,7 +713,7 @@ static int vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 static unsigned int hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;
-	unsigned pollflag;
+	unsigned int pollflag;
 
 	uctxt = ((struct hfi1_filedata *)fp->private_data)->uctxt;
 	if (!uctxt)
@@ -829,7 +829,7 @@ static u64 kvirt_to_phys(void *addr)
 static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 {
 	int i_minor, ret = 0;
-	unsigned swmajor, swminor, alg = HFI1_ALG_ACROSS;
+	unsigned int swmajor, swminor, alg = HFI1_ALG_ACROSS;
 
 	swmajor = uinfo->userversion >> 16;
 	if (swmajor != HFI1_USER_SWMAJOR) {
@@ -878,7 +878,7 @@ static int usable_device(struct hfi1_devdata *dd)
 }
 
 static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
-			    int devno, unsigned alg)
+			    int devno, unsigned int alg)
 {
 	struct hfi1_devdata *dd = NULL;
 	int ret = 0, devmax, npresent, nup, dev;
@@ -902,7 +902,7 @@ static int get_user_context(struct file *fp, struct hfi1_user_info *uinfo,
 		struct hfi1_devdata *pdd;
 
 		if (alg == HFI1_ALG_ACROSS) {
-			unsigned free = 0U;
+			unsigned iny free = 0U;
 
 			for (dev = 0; dev < devmax; dev++) {
 				pdd = hfi1_lookup(dev);
@@ -988,7 +988,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 {
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt;
-	unsigned ctxt;
+	unsigned int ctxt;
 	int ret, numa;
 
 	if (dd->flags & HFI1_FROZEN) {
@@ -1076,7 +1076,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo)
 {
-	unsigned num_subctxts;
+	unsigned int num_subctxts;
 
 	num_subctxts = uinfo->subctxt_cnt;
 	if (num_subctxts > HFI1_MAX_SHARED_CTXTS)
@@ -1094,7 +1094,7 @@ static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt)
 {
 	int ret = 0;
-	unsigned num_subctxts = uctxt->subctxt_cnt;
+	unsigned int num_subctxts = uctxt->subctxt_cnt;
 
 	uctxt->subctxt_uregbase = vmalloc_user(PAGE_SIZE);
 	if (!uctxt->subctxt_uregbase) {
@@ -1299,7 +1299,7 @@ static int get_base_info(struct file *fp, void __user *ubase, __u32 len)
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	ssize_t sz;
-	unsigned offset;
+	unsigned int offset;
 	int ret = 0;
 
 	trace_hfi1_uctxtdata(uctxt->dd, uctxt);
@@ -1375,7 +1375,7 @@ static unsigned int poll_urgent(struct file *fp,
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned pollflag;
+	unsigned int pollflag;
 
 	poll_wait(fp, &uctxt->wait, pt);
 
@@ -1398,7 +1398,7 @@ static unsigned int poll_next(struct file *fp,
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned pollflag;
+	unsigned int pollflag;
 
 	poll_wait(fp, &uctxt->wait, pt);
 
@@ -1424,7 +1424,7 @@ int hfi1_set_uevent_bits(struct hfi1_pportdata *ppd, const int evtbit)
 {
 	struct hfi1_ctxtdata *uctxt;
 	struct hfi1_devdata *dd = ppd->dd;
-	unsigned ctxt;
+	unsigned int ctxt;
 	int ret = 0;
 	unsigned long flags;
 
@@ -1466,7 +1466,7 @@ done:
  * overflow conditions.  start_stop==1 re-enables, to be used to
  * re-init the software copy of the head register
  */
-static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+static int manage_rcvq(struct hfi1_ctxtdata *uctxt, unsigned int subctxt,
 		       int start_stop)
 {
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -1522,7 +1522,7 @@ static int user_event_ack(struct hfi1_ctxtdata *uctxt, int subctxt,
 	return 0;
 }
 
-static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned subctxt,
+static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned int subctxt,
 			 u16 pkey)
 {
 	int ret = -ENOENT, i, intable = 0;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 16cbdc4..a04233d 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -223,7 +223,7 @@ struct hfi1_ctxtdata {
 	 * protocol use, on each TID
 	 */
 	/* instead of calculating it */
-	unsigned ctxt;
+	unsigned int ctxt;
 	/* non-zero if ctxt is being shared. */
 	u16 subctxt_cnt;
 	/* non-zero if ctxt is being shared. */
@@ -300,7 +300,7 @@ struct hfi1_ctxtdata {
 	/* interrupt handling */
 	u64 imask;	/* clear interrupt mask */
 	int ireg;	/* clear interrupt register */
-	unsigned numa_id; /* numa node of this context */
+	unsigned int numa_id; /* numa node of this context */
 	/* verbs stats per CTX */
 	struct hfi1_opcode_stats_perctx *opstats;
 	/*
@@ -1185,7 +1185,7 @@ struct mmu_rb_node;
 /* Private data for file operations */
 struct hfi1_filedata {
 	struct hfi1_ctxtdata *uctxt;
-	unsigned subctxt;
+	unsigned int subctxt;
 	struct hfi1_user_sdma_comp_q *cq;
 	struct hfi1_user_sdma_pkt_q *pq;
 	/* for cpu affinity; -1 if none */
@@ -1350,7 +1350,7 @@ static inline void pause_for_credit_return(struct hfi1_devdata *dd)
  */
 static inline u8 sc_to_vlt(struct hfi1_devdata *dd, u8 sc5)
 {
-	unsigned seq;
+	unsigned int seq;
 	u8 rval;
 
 	if (sc5 >= OPA_MAX_SCS)
@@ -1559,7 +1559,7 @@ static inline struct hfi1_ibdev *dev_from_rdi(struct rvt_dev_info *rdi)
 static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u8 port)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hdw from 0 */
+	unsigned int pidx = port - 1; /* IB number port from 1, hdw from 0 */
 
 	WARN_ON(pidx >= dd->num_pports);
 	return &dd->pport[pidx].ibport_data;
@@ -1568,7 +1568,7 @@ static inline struct hfi1_ibport *to_iport(struct ib_device *ibdev, u8 port)
 /*
  * Return the indexed PKEY from the port PKEY table.
  */
-static inline u16 hfi1_get_pkey(struct hfi1_ibport *ibp, unsigned index)
+static inline u16 hfi1_get_pkey(struct hfi1_ibport *ibp, unsigned int index)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	u16 ret;
@@ -1746,7 +1746,7 @@ extern unsigned int hfi1_max_mtu;
 extern unsigned int hfi1_cu;
 extern unsigned int user_credit_return_threshold;
 extern int num_user_contexts;
-extern unsigned n_krcvqs;
+extern unsigned int n_krcvqs;
 extern uint krcvqs[];
 extern int krcvqsset;
 extern uint kdeth_qp;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cfcdc16..e2d4071 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -93,9 +93,9 @@ module_param_array(krcvqs, uint, &krcvqsset, S_IRUGO);
 MODULE_PARM_DESC(krcvqs, "Array of the number of non-control kernel receive queues by VL");
 
 /* computed based on above array */
-unsigned n_krcvqs;
+unsigned int n_krcvqs;
 
-static unsigned hfi1_rcvarr_split = 25;
+static unsigned int hfi1_rcvarr_split = 25;
 module_param_named(rcvarr_split, hfi1_rcvarr_split, uint, S_IRUGO);
 MODULE_PARM_DESC(rcvarr_split, "Percent of context's RcvArray entries used for Eager buffers");
 
@@ -126,7 +126,7 @@ unsigned long *hfi1_cpulist;
  */
 int hfi1_create_ctxts(struct hfi1_devdata *dd)
 {
-	unsigned i;
+	unsigned int i;
 	int ret;
 
 	/* Control context has to be always 0 */
@@ -208,7 +208,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	struct hfi1_ctxtdata *rcd;
-	unsigned kctxt_ngroups = 0;
+	unsigned int kctxt_ngroups = 0;
 	u32 base;
 
 	if (dd->rcv_entries.nctxt_extra >
@@ -658,7 +658,7 @@ wq_error:
 int hfi1_init(struct hfi1_devdata *dd, int reinit)
 {
 	int ret = 0, pidx, lastfail = 0;
-	unsigned i, len;
+	unsigned int i, len;
 	struct hfi1_ctxtdata *rcd;
 	struct hfi1_pportdata *ppd;
 
@@ -859,7 +859,7 @@ static void stop_timers(struct hfi1_devdata *dd)
 static void shutdown_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_pportdata *ppd;
-	unsigned pidx;
+	unsigned int pidx;
 	int i;
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
@@ -935,7 +935,7 @@ static void shutdown_device(struct hfi1_devdata *dd)
  */
 void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 {
-	unsigned e;
+	unsigned int e;
 
 	if (!rcd)
 		return;
@@ -1546,7 +1546,7 @@ static void remove_one(struct pci_dev *pdev)
  */
 int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 {
-	unsigned amt;
+	unsigned int amt;
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index 2ec6ef3..f718bb4 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -100,7 +100,7 @@ struct iowait {
 		struct sdma_engine *sde,
 		struct iowait *wait,
 		struct sdma_txreq *tx,
-		unsigned seq);
+		unsigned int seq);
 	void (*wakeup)(struct iowait *wait, int reason);
 	void (*sdma_drained)(struct iowait *wait);
 	struct work_struct iowork;
@@ -136,7 +136,7 @@ static inline void iowait_init(
 		struct sdma_engine *sde,
 		struct iowait *wait,
 		struct sdma_txreq *tx,
-		unsigned seq),
+		unsigned int seq),
 	void (*wakeup)(struct iowait *wait, int reason),
 	void (*sdma_drained)(struct iowait *wait))
 {
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index d1e7f4d..b97d00a 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -78,7 +78,7 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
 	memset(data, 0, size);
 }
 
-static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
+static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned int len)
 {
 	struct ib_mad_send_buf *send_buf;
 	struct ib_mad_agent *agent;
@@ -321,7 +321,7 @@ static int __subn_get_opa_nodeinfo(struct opa_smp *smp, u32 am, u8 *data,
 {
 	struct opa_node_info *ni;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hw from 0 */
+	unsigned int pidx = port - 1; /* IB number port from 1, hw from 0 */
 
 	ni = (struct opa_node_info *)data;
 
@@ -359,7 +359,7 @@ static int subn_get_nodeinfo(struct ib_smp *smp, struct ib_device *ibdev,
 {
 	struct ib_node_info *nip = (struct ib_node_info *)&smp->data;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	unsigned pidx = port - 1; /* IB number port from 1, hw from 0 */
+	unsigned int pidx = port - 1; /* IB number port from 1, hw from 0 */
 
 	/* GUID 0 is illegal */
 	if (smp->attr_mod || pidx >= dd->num_pports ||
@@ -743,7 +743,7 @@ static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 	u16 *q;
 	int i;
 	u16 n_blocks_avail;
-	unsigned npkeys = hfi1_get_npkeys(dd);
+	unsigned int npkeys = hfi1_get_npkeys(dd);
 	size_t size;
 
 	if (n_blocks_req == 0) {
@@ -1421,7 +1421,7 @@ static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 	__be16 *q = (__be16 *)data;
 	int i;
 	u16 n_blocks_avail;
-	unsigned npkeys = hfi1_get_npkeys(dd);
+	unsigned int npkeys = hfi1_get_npkeys(dd);
 
 	if (n_blocks_sent == 0) {
 		pr_warn("OPA Get PKey AM Invalid : P = %d; B = 0x%x; N = 0x%x\n",
@@ -1506,7 +1506,7 @@ static int __subn_get_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	u8 *p = data;
 	size_t size = ARRAY_SIZE(ibp->sl_to_sc); /* == 32 */
-	unsigned i;
+	unsigned int i;
 
 	if (am) {
 		smp->status |= IB_SMP_INVALID_FIELD;
@@ -1556,7 +1556,7 @@ static int __subn_get_opa_sc_to_sl(struct opa_smp *smp, u32 am, u8 *data,
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	u8 *p = data;
 	size_t size = ARRAY_SIZE(ibp->sc_to_sl); /* == 32 */
-	unsigned i;
+	unsigned int i;
 
 	if (am) {
 		smp->status |= IB_SMP_INVALID_FIELD;
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index c6849ce..df54694 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -399,7 +399,7 @@ int init_sc_pools_and_sizes(struct hfi1_devdata *dd)
 	used_blocks = 0;
 	for (i = 0; i < SC_MAX; i++) {
 		if (dd->sc_sizes[i].size < 0) {
-			unsigned pool = wildcard_to_pool(dd->sc_sizes[i].size);
+			unsigned int pool = wildcard_to_pool(dd->sc_sizes[i].size);
 
 			WARN_ON_ONCE(pool >= NUM_SC_POOLS);
 			dd->sc_sizes[i].size = mem_pool_info[pool].size;
@@ -1529,7 +1529,7 @@ static void sc_piobufavail(struct send_context *sc)
 	struct rvt_qp *qp;
 	struct hfi1_qp_priv *priv;
 	unsigned long flags;
-	unsigned i, n = 0;
+	unsigned int i, n = 0;
 
 	if (dd->send_contexts[sc->sw_index].type != SC_KERNEL)
 		return;
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 29a5ad2..4dc2c6b 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -68,13 +68,13 @@ static int iowait_sleep(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *stx,
-	unsigned seq);
+	unsigned int seq);
 static void iowait_wakeup(struct iowait *wait, int reason);
 static void iowait_sdma_drained(struct iowait *wait);
 static void qp_pio_drain(struct rvt_qp *qp);
 
-static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
-			      struct rvt_qpn_map *map, unsigned off)
+static inline unsigned int mk_qpn(struct rvt_qpn_table *qpt,
+			      struct rvt_qpn_map *map, unsigned int off)
 {
 	return (map - qpt->map) * RVT_BITS_PER_PAGE + off;
 }
@@ -450,7 +450,7 @@ static int iowait_sleep(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *stx,
-	unsigned seq)
+	unsigned int seq)
 {
 	struct verbs_txreq *tx = container_of(stx, struct verbs_txreq, txreq);
 	struct rvt_qp *qp;
@@ -760,7 +760,7 @@ void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 	kfree(priv);
 }
 
-unsigned free_all_qps(struct rvt_dev_info *rdi)
+unsigned int free_all_qps(struct rvt_dev_info *rdi)
 {
 	struct hfi1_ibdev *verbs_dev = container_of(rdi,
 						    struct hfi1_ibdev,
@@ -769,7 +769,7 @@ unsigned free_all_qps(struct rvt_dev_info *rdi)
 					       struct hfi1_devdata,
 					       verbs_dev);
 	int n;
-	unsigned qp_inuse = 0;
+	unsigned int qp_inuse = 0;
 
 	for (n = 0; n < dd->num_pports; n++) {
 		struct hfi1_ibport *ibp = &dd->pport[n].ibport_data;
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index e7bc8d6..44f9c88 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -146,7 +146,7 @@ void hfi1_migrate_qp(struct rvt_qp *qp);
 void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		    gfp_t gfp);
 void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
-unsigned free_all_qps(struct rvt_dev_info *rdi);
+unsigned int free_all_qps(struct rvt_dev_info *rdi);
 void notify_qp_reset(struct rvt_qp *qp);
 int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		       struct ib_qp_attr *attr);
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index 831fe4c..44bdf6c 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -111,7 +111,7 @@ extern const char *const hfi1_qsfp_devtech[16];
 #define QSFP_IS_CU(tech) ((0xED00 >> ((tech) >> 4)) & 1)
 #define QSFP_TECH_1490 9
 
-#define QSFP_OUI(oui) (((unsigned)oui[0] << 16) | ((unsigned)oui[1] << 8) | \
+#define QSFP_OUI(oui) (((unsigned int)oui[0] << 16) | ((unsigned int)oui[1] << 8) | \
 			oui[2])
 #define QSFP_OUI_AMPHENOL 0x415048
 #define QSFP_OUI_FINISAR  0x009065
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 0d7e101..e146476 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1103,7 +1103,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	struct hfi1_other_headers *ohdr;
 	struct rvt_swqe *wqe;
 	struct ib_wc wc;
-	unsigned i;
+	unsigned int i;
 	u32 opcode;
 	u32 psn;
 
@@ -1196,7 +1196,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 					 struct hfi1_ibport *ibp)
 {
 	struct ib_wc wc;
-	unsigned i;
+	unsigned int i;
 
 	/*
 	 * Don't decrement refcount and don't generate a
@@ -1970,9 +1970,9 @@ void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
 	}
 }
 
-static inline void update_ack_queue(struct rvt_qp *qp, unsigned n)
+static inline void update_ack_queue(struct rvt_qp *qp, unsigned int n)
 {
-	unsigned next;
+	unsigned int next;
 
 	next = n + 1;
 	if (next > HFI1_MAX_RDMA_ATOMIC)
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 08813cd..3f33582 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -239,7 +239,7 @@ bail:
 	return ret;
 }
 
-static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned index)
+static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned int index)
 {
 	if (!index) {
 		struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
@@ -927,7 +927,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status)
 {
 	u32 old_last, last;
-	unsigned i;
+	unsigned int i;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index abb8ebc..a066735 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -234,7 +234,7 @@ static void sdma_put(struct sdma_state *);
 static void sdma_set_state(struct sdma_engine *, enum sdma_states);
 static void sdma_start_hw_clean_up(struct sdma_engine *);
 static void sdma_sw_clean_up_task(unsigned long);
-static void sdma_sendctrl(struct sdma_engine *, unsigned);
+static void sdma_sendctrl(struct sdma_engine *, unsigned int);
 static void init_sdma_regs(struct sdma_engine *, u32, uint);
 static void sdma_process_event(
 	struct sdma_engine *sde,
@@ -244,7 +244,7 @@ static void __sdma_process_event(
 	enum sdma_events event);
 static void dump_sdma_state(struct sdma_engine *sde);
 static void sdma_make_progress(struct sdma_engine *sde, u64 status);
-static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail);
+static void sdma_desc_avail(struct sdma_engine *sde, unsigned int avail);
 static void sdma_flush_descq(struct sdma_engine *sde);
 
 /**
@@ -346,7 +346,7 @@ void sdma_wait(struct hfi1_devdata *dd)
 	}
 }
 
-static inline void sdma_set_desc_cnt(struct sdma_engine *sde, unsigned cnt)
+static inline void sdma_set_desc_cnt(struct sdma_engine *sde, unsigned int cnt)
 {
 	u64 reg;
 
@@ -472,7 +472,7 @@ static void sdma_err_halt_wait(struct work_struct *work)
 static void sdma_err_progress_check_schedule(struct sdma_engine *sde)
 {
 	if (!is_bx(sde->dd) && HFI1_CAP_IS_KSET(SDMA_AHG)) {
-		unsigned index;
+		unsigned int index;
 		struct hfi1_devdata *dd = sde->dd;
 
 		for (index = 0; index < dd->num_sdma; index++) {
@@ -491,7 +491,7 @@ static void sdma_err_progress_check_schedule(struct sdma_engine *sde)
 
 static void sdma_err_progress_check(unsigned long data)
 {
-	unsigned index;
+	unsigned int index;
 	struct sdma_engine *sde = (struct sdma_engine *)data;
 
 	dd_dev_err(sde->dd, "SDE progress check event\n");
@@ -657,7 +657,7 @@ static void sdma_set_state(struct sdma_engine *sde,
 {
 	struct sdma_state *ss = &sde->state;
 	const struct sdma_set_state_action *action = sdma_action_table;
-	unsigned op = 0;
+	unsigned int op = 0;
 
 	trace_hfi1_sdma_state(
 		sde,
@@ -989,7 +989,7 @@ static void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
  */
 int sdma_init(struct hfi1_devdata *dd, u8 port)
 {
-	unsigned this_idx;
+	unsigned int this_idx;
 	struct sdma_engine *sde;
 	u16 descq_cnt;
 	void *curr_head;
@@ -1213,7 +1213,7 @@ void sdma_all_idle(struct hfi1_devdata *dd)
  */
 void sdma_start(struct hfi1_devdata *dd)
 {
-	unsigned i;
+	unsigned int i;
 	struct sdma_engine *sde;
 
 	/* kick off the engines state processing */
@@ -1229,7 +1229,7 @@ void sdma_start(struct hfi1_devdata *dd)
  */
 void sdma_exit(struct hfi1_devdata *dd)
 {
-	unsigned this_idx;
+	unsigned int this_idx;
 	struct sdma_engine *sde;
 
 	for (this_idx = 0; dd->per_sdma && this_idx < dd->num_sdma;
@@ -1388,11 +1388,11 @@ retry:
  *
  * This is called with head_lock held.
  */
-static void sdma_desc_avail(struct sdma_engine *sde, unsigned avail)
+static void sdma_desc_avail(struct sdma_engine *sde, unsigned int avail)
 {
 	struct iowait *wait, *nw;
 	struct iowait *waits[SDMA_WAIT_BATCH_SIZE];
-	unsigned i, n = 0, seq;
+	unsigned int i, n = 0, seq;
 	struct sdma_txreq *stx;
 	struct hfi1_ibdev *dev = &sde->dd->verbs_dev;
 
@@ -1557,7 +1557,7 @@ void sdma_engine_error(struct sdma_engine *sde, u64 status)
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
 }
 
-static void sdma_sendctrl(struct sdma_engine *sde, unsigned op)
+static void sdma_sendctrl(struct sdma_engine *sde, unsigned int op)
 {
 	u64 set_senddmactrl = 0;
 	u64 clr_senddmactrl = 0;
@@ -1736,7 +1736,7 @@ static void init_sdma_regs(
 void sdma_dumpstate(struct sdma_engine *sde)
 {
 	u64 csr;
-	unsigned i;
+	unsigned int i;
 
 	sdma_dumpstate_helper(SD(CTRL));
 	sdma_dumpstate_helper(SD(STATUS));
@@ -1999,7 +1999,7 @@ static int sdma_check_progress(
 		return -EAGAIN;
 	/* pulse the head_lock */
 	if (wait && wait->sleep) {
-		unsigned seq;
+		unsigned int seq;
 
 		seq = raw_seqcount_begin(
 			(const seqcount_t *)&sde->head_lock.seqcount);
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 8f50c99..2e47ad1 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -196,11 +196,11 @@ struct sdma_state {
 	struct kref          kref;
 	struct completion    comp;
 	enum sdma_states current_state;
-	unsigned             current_op;
-	unsigned             go_s99_running;
+	unsigned int		current_op;
+	unsigned int		go_s99_running;
 	/* debugging/development */
 	enum sdma_states previous_state;
-	unsigned             previous_op;
+	unsigned int		previous_op;
 	enum sdma_events last_event;
 };
 
@@ -335,7 +335,7 @@ struct sdma_engine {
 	/* private: */
 	struct hw_sdma_desc *descq;
 	/* private: */
-	unsigned descq_full_count;
+	unsigned int descq_full_count;
 	struct sdma_txreq **tx_ring;
 	/* private: */
 	dma_addr_t            descq_phys;
@@ -892,7 +892,7 @@ static inline u32 sdma_build_ahg_descriptor(
  * re-submission is detected by checking whether the descriptor
  * queue has enough descriptor for the txreq.
  */
-static inline unsigned sdma_progress(struct sdma_engine *sde, unsigned seq,
+static inline unsigned int sdma_progress(struct sdma_engine *sde, unsigned int seq,
 				     struct sdma_txreq *tx)
 {
 	if (read_seqretry(&sde->head_lock, seq)) {
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 963dc94..8c335f1 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -147,12 +147,12 @@ TRACE_EVENT(hfi1_receive_interrupt,
 );
 
 TRACE_EVENT(hfi1_exp_tid_reg,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr,
+	    TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr,
 		     u32 npages, unsigned long va, unsigned long pa,
 		     dma_addr_t dma),
 	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
 	    TP_STRUCT__entry(
-		    __field(unsigned, ctxt)
+		    __field(unsigned int, ctxt)
 		    __field(u16, subctxt)
 		    __field(u32, rarr)
 		    __field(u32, npages)
@@ -181,11 +181,11 @@ TRACE_EVENT(hfi1_exp_tid_reg,
 	);
 
 TRACE_EVENT(hfi1_exp_tid_unreg,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, u32 rarr, u32 npages,
+	    TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr, u32 npages,
 		     unsigned long va, unsigned long pa, dma_addr_t dma),
 	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
 	    TP_STRUCT__entry(
-		    __field(unsigned, ctxt)
+		    __field(unsigned int, ctxt)
 		    __field(u16, subctxt)
 		    __field(u32, rarr)
 		    __field(u32, npages)
@@ -214,11 +214,11 @@ TRACE_EVENT(hfi1_exp_tid_unreg,
 	);
 
 TRACE_EVENT(hfi1_exp_tid_inval,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, unsigned long va, u32 rarr,
+	    TP_PROTO(unsigned int ctxt, u16 subctxt, unsigned long va, u32 rarr,
 		     u32 npages, dma_addr_t dma),
 	    TP_ARGS(ctxt, subctxt, va, rarr, npages, dma),
 	    TP_STRUCT__entry(
-		    __field(unsigned, ctxt)
+		    __field(unsigned int, ctxt)
 		    __field(u16, subctxt)
 		    __field(unsigned long, va)
 		    __field(u32, rarr)
@@ -244,11 +244,11 @@ TRACE_EVENT(hfi1_exp_tid_inval,
 	);
 
 TRACE_EVENT(hfi1_mmu_invalidate,
-	    TP_PROTO(unsigned ctxt, u16 subctxt, const char *type,
+	    TP_PROTO(unsigned int ctxt, u16 subctxt, const char *type,
 		     unsigned long start, unsigned long end),
 	    TP_ARGS(ctxt, subctxt, type, start, end),
 	    TP_STRUCT__entry(
-		    __field(unsigned, ctxt)
+		    __field(unsigned int, ctxt)
 		    __field(u16, subctxt)
 		    __string(type, type)
 		    __field(unsigned long, start)
@@ -615,7 +615,7 @@ TRACE_EVENT(hfi1_uctxtdata,
 	    TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt),
 	    TP_ARGS(dd, uctxt),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
-			     __field(unsigned, ctxt)
+			     __field(unsigned int, ctxt)
 			     __field(u32, credits)
 			     __field(u64, hw_free)
 			     __field(u64, piobase)
@@ -651,12 +651,12 @@ TRACE_EVENT(hfi1_uctxtdata,
 #define CINFO_FMT \
 	"egrtids:%u, egr_size:%u, hdrq_cnt:%u, hdrq_size:%u, sdma_ring_size:%u"
 TRACE_EVENT(hfi1_ctxt_info,
-	    TP_PROTO(struct hfi1_devdata *dd, unsigned ctxt, unsigned subctxt,
+	    TP_PROTO(struct hfi1_devdata *dd, unsigned int ctxt, unsigned int subctxt,
 		     struct hfi1_ctxt_info cinfo),
 	    TP_ARGS(dd, ctxt, subctxt, cinfo),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
-			     __field(unsigned, ctxt)
-			     __field(unsigned, subctxt)
+			     __field(unsigned int, ctxt)
+			     __field(unsigned int, subctxt)
 			     __field(u16, egrtids)
 			     __field(u16, rcvhdrq_cnt)
 			     __field(u16, rcvhdrq_size)
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index ae8a70f..86dfa13 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -466,10 +466,10 @@ bail_no_tx:
 int hfi1_lookup_pkey_idx(struct hfi1_ibport *ibp, u16 pkey)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	unsigned i;
+	unsigned int i;
 
 	if (pkey == FULL_MGMT_P_KEY || pkey == LIM_MGMT_P_KEY) {
-		unsigned lim_idx = -1;
+		unsigned int lim_idx = -1;
 
 		for (i = 0; i < ARRAY_SIZE(ppd->pkeys); ++i) {
 			/* here we look for an exact match */
@@ -884,7 +884,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 				mgmt_pkey_idx = 0;
 			}
 		}
-		wc.pkey_index = (unsigned)mgmt_pkey_idx;
+		wc.pkey_index = (unsigned int)mgmt_pkey_idx;
 	} else {
 		wc.pkey_index = 0;
 	}
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 0861e09..bb23be3 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -52,7 +52,7 @@
 
 struct tid_group {
 	struct list_head list;
-	unsigned base;
+	unsigned int base;
 	u8 size;
 	u8 used;
 	u8 map;
@@ -65,7 +65,7 @@ struct tid_rb_node {
 	u32 rcventry;
 	dma_addr_t dma_addr;
 	bool freed;
-	unsigned npages;
+	unsigned int npages;
 	struct page *pages[0];
 };
 
@@ -83,15 +83,15 @@ struct tid_pageset {
 
 static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
 			    struct rb_root *);
-static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
+static u32 find_phys_blocks(struct page **, unsigned int, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
-			      struct tid_group *, struct page **, unsigned);
+			      struct tid_group *, struct page **, unsigned int);
 static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
 static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *, bool);
 static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
-			    struct tid_pageset *, unsigned, u16, struct page **,
-			    u32 *, unsigned *, unsigned *);
+			    struct tid_pageset *, unsigned int, u16, struct page **,
+			    u32 *, unsigned int *, unsigned int *);
 static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
 static void clear_tid_node(struct hfi1_filedata *, u16, struct tid_rb_node *);
 
@@ -156,7 +156,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned tidbase;
+	unsigned int tidbase;
 	int i, ret = 0;
 
 	spin_lock_init(&fd->tid_lock);
@@ -354,7 +354,7 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	unsigned npages, ngroups, pageidx = 0, pageset_count, npagesets,
+	unsigned int npages, ngroups, pageidx = 0, pageset_count, npagesets,
 		tididx = 0, mapped, mapped_pages = 0;
 	unsigned long vaddr = tinfo->vaddr;
 	struct page **pages = NULL;
@@ -488,7 +488,7 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 		 */
 		list_for_each_entry_safe(grp, ptr, &uctxt->tid_used_list.list,
 					 list) {
-			unsigned use = min_t(unsigned, pageset_count - pageidx,
+			unsigned int use = min_t(unsigned int, pageset_count - pageidx,
 					     grp->size - grp->used);
 
 			ret = program_rcvarray(fp, vaddr, grp, pagesets,
@@ -571,7 +571,7 @@ int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	u32 *tidinfo;
-	unsigned tididx;
+	unsigned int tididx;
 
 	tidinfo = kcalloc(tinfo->tidcnt, sizeof(*tidinfo), GFP_KERNEL);
 	if (!tidinfo)
@@ -654,10 +654,10 @@ int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
 	return ret;
 }
 
-static u32 find_phys_blocks(struct page **pages, unsigned npages,
+static u32 find_phys_blocks(struct page **pages, unsigned int npages,
 			    struct tid_pageset *list)
 {
-	unsigned pagecount, pageidx, setcount = 0, i;
+	unsigned int pagecount, pageidx, setcount = 0, i;
 	unsigned long pfn, this_pfn;
 
 	if (!npages)
@@ -748,8 +748,8 @@ static u32 find_phys_blocks(struct page **pages, unsigned npages,
 static int program_rcvarray(struct file *fp, unsigned long vaddr,
 			    struct tid_group *grp,
 			    struct tid_pageset *sets,
-			    unsigned start, u16 count, struct page **pages,
-			    u32 *tidlist, unsigned *tididx, unsigned *pmapped)
+			    unsigned int start, u16 count, struct page **pages,
+			    u32 *tidlist, unsigned int *tididx, unsigned int *pmapped)
 {
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
@@ -816,7 +816,7 @@ static int program_rcvarray(struct file *fp, unsigned long vaddr,
 
 static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 			      u32 rcventry, struct tid_group *grp,
-			      struct page **pages, unsigned npages)
+			      struct page **pages, unsigned int npages)
 {
 	int ret;
 	struct hfi1_filedata *fd = fp->private_data;
diff --git a/drivers/staging/rdma/hfi1/user_pages.c b/drivers/staging/rdma/hfi1/user_pages.c
index 88e10b5f..980e87c 100644
--- a/drivers/staging/rdma/hfi1/user_pages.c
+++ b/drivers/staging/rdma/hfi1/user_pages.c
@@ -72,7 +72,7 @@ bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages)
 {
 	unsigned long ulimit = rlimit(RLIMIT_MEMLOCK), pinned, cache_limit,
 		size = (cache_size * (1UL << 20)); /* convert to bytes */
-	unsigned usr_ctxts = dd->num_rcv_contexts - dd->first_user_ctxt;
+	unsigned int usr_ctxts = dd->num_rcv_contexts - dd->first_user_ctxt;
 	bool can_lock = capable(CAP_IPC_LOCK);
 
 	/*
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index ab6b6a4..c430494 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -162,7 +162,7 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
  */
 #define MAX_DEFER_RETRY_COUNT 1
 
-static unsigned initial_pkt_count = 8;
+static unsigned int initial_pkt_count = 8;
 
 #define SDMA_IOWAIT_TIMEOUT 1000 /* in milliseconds */
 
@@ -170,7 +170,7 @@ struct user_sdma_iovec {
 	struct list_head list;
 	struct iovec iov;
 	/* number of pages in this vector */
-	unsigned npages;
+	unsigned int npages;
 	/* array of pinned pages for this vector */
 	struct page **pages;
 	/*
@@ -186,7 +186,7 @@ struct sdma_mmu_node {
 	struct hfi1_user_sdma_pkt_q *pq;
 	atomic_t refcount;
 	struct page **pages;
-	unsigned npages;
+	unsigned int npages;
 };
 
 struct user_sdma_request {
@@ -225,11 +225,11 @@ struct user_sdma_request {
 	 * We copy the iovs for this request (based on
 	 * info.iovcnt). These are only the data vectors
 	 */
-	unsigned data_iovs;
+	unsigned int data_iovs;
 	/* total length of the data in the request */
 	u32 data_len;
 	/* progress index moving along the iovs array */
-	unsigned iov_idx;
+	unsigned int iov_idx;
 	struct user_sdma_iovec iovs[MAX_VECTORS_PER_REQ];
 	/* number of elements copied to the tids array */
 	u16 n_tids;
@@ -259,7 +259,7 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned busycount;
+	unsigned int busycount;
 	u64 seqnum;
 };
 
@@ -271,14 +271,14 @@ struct user_sdma_txreq {
 	hfi1_cdbg(SDMA, "[%u:%u:%u] " fmt, (pq)->dd->unit, (pq)->ctxt, \
 		 (pq)->subctxt, ##__VA_ARGS__)
 
-static int user_sdma_send_pkts(struct user_sdma_request *, unsigned);
+static int user_sdma_send_pkts(struct user_sdma_request *, unsigned int);
 static int num_user_pages(const struct iovec *);
 static void user_sdma_txreq_cb(struct sdma_txreq *, int);
 static inline void pq_update(struct hfi1_user_sdma_pkt_q *);
 static void user_sdma_free_request(struct user_sdma_request *, bool);
 static int pin_vector_pages(struct user_sdma_request *,
 			    struct user_sdma_iovec *);
-static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned);
+static void unpin_vector_pages(struct mm_struct *, struct page **, unsigned int);
 static int check_header_template(struct user_sdma_request *,
 				 struct hfi1_pkt_header *, u32, u32);
 static int set_txreq_header(struct user_sdma_request *,
@@ -295,7 +295,7 @@ static int defer_packet_queue(
 	struct sdma_engine *,
 	struct iowait *,
 	struct sdma_txreq *,
-	unsigned seq);
+	unsigned int seq);
 static void activate_packet_queue(struct iowait *, int);
 static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
 static int sdma_rb_insert(struct rb_root *, struct mmu_rb_node *);
@@ -313,7 +313,7 @@ static int defer_packet_queue(
 	struct sdma_engine *sde,
 	struct iowait *wait,
 	struct sdma_txreq *txreq,
-	unsigned seq)
+	unsigned int seq)
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait, struct hfi1_user_sdma_pkt_q, busy);
@@ -359,7 +359,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 {
 	struct hfi1_filedata *fd;
 	int ret = 0;
-	unsigned memsize;
+	unsigned int memsize;
 	char buf[64];
 	struct hfi1_devdata *dd;
 	struct hfi1_user_sdma_comp_q *cq;
@@ -791,10 +791,10 @@ static inline u32 get_lrh_len(struct hfi1_pkt_header hdr, u32 len)
 	return ((sizeof(hdr) - sizeof(hdr.pbc)) + 4 + len);
 }
 
-static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
+static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned int maxpkts)
 {
 	int ret = 0;
-	unsigned npkts = 0;
+	unsigned int npkts = 0;
 	struct user_sdma_txreq *tx = NULL;
 	struct hfi1_user_sdma_pkt_q *pq = NULL;
 	struct user_sdma_iovec *iovec = NULL;
@@ -939,7 +939,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		while (queued < datalen &&
 		       (req->sent + data_sent) < req->data_len) {
 			unsigned long base, offset;
-			unsigned pageidx, len;
+			unsigned int pageidx, len;
 
 			base = (unsigned long)iovec->iov.iov_base;
 			offset = offset_in_page(base + iovec->offset +
@@ -1147,7 +1147,7 @@ bail:
 }
 
 static void unpin_vector_pages(struct mm_struct *mm, struct page **pages,
-			       unsigned npages)
+			       unsigned int npages)
 {
 	hfi1_release_user_pages(mm, pages, npages, 0);
 	kfree(pages);
diff --git a/drivers/staging/rdma/hfi1/user_sdma.h b/drivers/staging/rdma/hfi1/user_sdma.h
index b9240e3..8f9be13 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.h
+++ b/drivers/staging/rdma/hfi1/user_sdma.h
@@ -55,8 +55,8 @@ extern uint extended_psn;
 
 struct hfi1_user_sdma_pkt_q {
 	struct list_head list;
-	unsigned ctxt;
-	unsigned subctxt;
+	unsigned int ctxt;
+	unsigned int subctxt;
 	u16 n_max_reqs;
 	atomic_t n_reqs;
 	u16 reqidx;
@@ -64,7 +64,7 @@ struct hfi1_user_sdma_pkt_q {
 	struct kmem_cache *txreq_cache;
 	struct user_sdma_request *reqs;
 	struct iowait busy;
-	unsigned state;
+	unsigned int state;
 	wait_queue_head_t wait;
 	unsigned long unpinned;
 	struct rb_root sdma_rb_root;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 89f2aad..ba5be47 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1376,7 +1376,7 @@ static int modify_device(struct ib_device *device,
 			 struct ib_device_modify *device_modify)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(device);
-	unsigned i;
+	unsigned int i;
 	int ret;
 
 	if (device_modify_mask & ~(IB_DEVICE_MODIFY_SYS_IMAGE_GUID |
@@ -1510,7 +1510,7 @@ struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
  * hfi1_get_npkeys - return the size of the PKEY table for context 0
  * @dd: the hfi1_ib device
  */
-unsigned hfi1_get_npkeys(struct hfi1_devdata *dd)
+unsigned int hfi1_get_npkeys(struct hfi1_devdata *dd)
 {
 	return ARRAY_SIZE(dd->pport[0].pkeys);
 }
@@ -1553,7 +1553,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
 	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct hfi1_pportdata *ppd = dd->pport;
-	unsigned i;
+	unsigned int i;
 	int ret;
 	size_t lcpysz = IB_DEVICE_NAME_MAX;
 
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 6c4670f..b07d5a3 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -467,7 +467,7 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *);
 
 void hfi1_ib_rcv(struct hfi1_packet *packet);
 
-unsigned hfi1_get_npkeys(struct hfi1_devdata *);
+unsigned int hfi1_get_npkeys(struct hfi1_devdata *);
 
 int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc);
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
