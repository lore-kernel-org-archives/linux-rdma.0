From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/13] IB/hfi1: Size rcd array index correctly and
 consistently
Date: Mon, 24 Jul 2017 07:45:55 -0700
Message-ID: <20170724144554.10034.24031.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The array index for the rcd array is sized several different ways
throughout the code.

Use the user interface size (u16) as the standard size and update the
necessary code to reflect this.

u16 is large enough for the largest amount of supported contexts.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/aspm.h      |    6 +++---
 drivers/infiniband/hw/hfi1/chip.c      |   10 +++++-----
 drivers/infiniband/hw/hfi1/chip.h      |    8 ++++----
 drivers/infiniband/hw/hfi1/driver.c    |   15 ++++++++-------
 drivers/infiniband/hw/hfi1/file_ops.c  |    6 +++---
 drivers/infiniband/hw/hfi1/hfi.h       |    4 ++--
 drivers/infiniband/hw/hfi1/init.c      |    9 +++++----
 drivers/infiniband/hw/hfi1/trace_rx.h  |    2 +-
 drivers/infiniband/hw/hfi1/user_sdma.h |    2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c |    2 +-
 10 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/aspm.h b/drivers/infiniband/hw/hfi1/aspm.h
index 794e681..3f9a071 100644
--- a/drivers/infiniband/hw/hfi1/aspm.h
+++ b/drivers/infiniband/hw/hfi1/aspm.h
@@ -237,7 +237,7 @@ static inline void aspm_disable_all(struct hfi1_devdata *dd)
 {
 	struct hfi1_ctxtdata *rcd;
 	unsigned long flags;
-	unsigned i;
+	u16 i;
 
 	for (i = 0; i < dd->first_dyn_alloc_ctxt; i++) {
 		rcd = dd->rcd[i];
@@ -256,7 +256,7 @@ static inline void aspm_enable_all(struct hfi1_devdata *dd)
 {
 	struct hfi1_ctxtdata *rcd;
 	unsigned long flags;
-	unsigned i;
+	u16 i;
 
 	aspm_enable(dd);
 
@@ -284,7 +284,7 @@ static inline void aspm_ctx_init(struct hfi1_ctxtdata *rcd)
 
 static inline void aspm_init(struct hfi1_devdata *dd)
 {
-	unsigned i;
+	u16 i;
 
 	spin_lock_init(&dd->aspm_lock);
 	dd->aspm_supported = aspm_hw_l1_supported(dd);
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 4fce173..06a79a2 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6802,7 +6802,7 @@ static void rxe_freeze(struct hfi1_devdata *dd)
 static void rxe_kernel_unfreeze(struct hfi1_devdata *dd)
 {
 	u32 rcvmask;
-	int i;
+	u16 i;
 
 	/* enable all kernel contexts */
 	for (i = 0; i < dd->num_rcv_contexts; i++) {
@@ -11722,7 +11722,7 @@ static u32 encoded_size(u32 size)
 	return 0x1;	/* if invalid, go with the minimum size */
 }
 
-void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt)
+void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, u16 ctxt)
 {
 	struct hfi1_ctxtdata *rcd;
 	u64 rcvctrl, reg;
@@ -14542,7 +14542,7 @@ static void init_txe(struct hfi1_devdata *dd)
 		write_csr(dd, SEND_CM_TIMER_CTRL, HFI1_CREDIT_RETURN_RATE);
 }
 
-int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
+int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, u16 ctxt, u16 jkey)
 {
 	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
 	unsigned sctxt;
@@ -14579,7 +14579,7 @@ int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey)
 	return ret;
 }
 
-int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt)
+int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, u16 ctxt)
 {
 	struct hfi1_ctxtdata *rcd = dd->rcd[ctxt];
 	unsigned sctxt;
@@ -14608,7 +14608,7 @@ int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt)
 	return ret;
 }
 
-int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey)
+int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, u16 ctxt, u16 pkey)
 {
 	struct hfi1_ctxtdata *rcd;
 	unsigned sctxt;
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index d3622cb..008c970 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1352,14 +1352,14 @@ enum {
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
 void hfi1_quiet_serdes(struct hfi1_pportdata *ppd);
-void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt);
+void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, u16 ctxt);
 u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp);
 u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp);
 int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which);
 int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val);
-int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey);
-int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt);
-int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey);
+int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, u16 ctxt, u16 jkey);
+int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, u16 ctxt);
+int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, u16 ctxt, u16 pkey);
 int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, struct hfi1_ctxtdata *ctxt);
 void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality);
 void hfi1_init_vnic_rsm(struct hfi1_devdata *dd);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 2105f46..b48f13f 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -838,9 +838,9 @@ int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 	return last;
 }
 
-static inline void set_nodma_rtail(struct hfi1_devdata *dd, u8 ctxt)
+static inline void set_nodma_rtail(struct hfi1_devdata *dd, u16 ctxt)
 {
-	int i;
+	u16 i;
 
 	/*
 	 * For dynamically allocated kernel contexts (like vnic) switch
@@ -858,9 +858,9 @@ static inline void set_nodma_rtail(struct hfi1_devdata *dd, u8 ctxt)
 			&handle_receive_interrupt_nodma_rtail;
 }
 
-static inline void set_dma_rtail(struct hfi1_devdata *dd, u8 ctxt)
+static inline void set_dma_rtail(struct hfi1_devdata *dd, u16 ctxt)
 {
-	int i;
+	u16 i;
 
 	/*
 	 * For dynamically allocated kernel contexts (like vnic) switch
@@ -880,7 +880,7 @@ static inline void set_dma_rtail(struct hfi1_devdata *dd, u8 ctxt)
 
 void set_all_slowpath(struct hfi1_devdata *dd)
 {
-	int i;
+	u16 i;
 
 	/* HFI1_CTRL_CTXT must always use the slow path interrupt handler */
 	for (i = HFI1_CTRL_CTXT + 1; i < dd->num_rcv_contexts; i++) {
@@ -1069,7 +1069,7 @@ void receive_interrupt_work(struct work_struct *work)
 	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
 						  linkstate_active_work);
 	struct hfi1_devdata *dd = ppd->dd;
-	int i;
+	u16 i;
 
 	/* Received non-SC15 packet implies neighbor_normal */
 	ppd->neighbor_normal = 1;
@@ -1270,7 +1270,8 @@ void hfi1_start_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
  */
 int hfi1_reset_device(int unit)
 {
-	int ret, i;
+	int ret;
+	u16 i;
 	struct hfi1_devdata *dd = hfi1_lookup(unit);
 	struct hfi1_pportdata *ppd;
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index e10f526..c8f34bc 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -927,7 +927,7 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 static int find_sub_ctxt(struct hfi1_filedata *fd,
 			 const struct hfi1_user_info *uinfo)
 {
-	int i;
+	u16 i;
 	struct hfi1_devdata *dd = fd->dd;
 	u16 subctxt;
 
@@ -978,7 +978,7 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo)
 {
 	struct hfi1_ctxtdata *uctxt;
-	unsigned int ctxt;
+	u16 ctxt;
 	int ret, numa;
 
 	if (dd->flags & HFI1_FROZEN) {
@@ -1429,7 +1429,7 @@ int hfi1_set_uevent_bits(struct hfi1_pportdata *ppd, const int evtbit)
 {
 	struct hfi1_ctxtdata *uctxt;
 	struct hfi1_devdata *dd = ppd->dd;
-	unsigned ctxt;
+	u16 ctxt;
 	int ret = 0;
 	unsigned long flags;
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 7877ebc..2ce3fc5 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -217,7 +217,7 @@ struct hfi1_ctxtdata {
 	struct kref kref;
 
 	/* Device context index */
-	unsigned ctxt;
+	u16 ctxt;
 	/*
 	 * non-zero if ctxt can be shared, and defines the maximum number of
 	 * sub-contexts for this device context.
@@ -1264,7 +1264,7 @@ struct hfi1_filedata {
 int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd);
 int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd);
 int hfi1_create_ctxts(struct hfi1_devdata *dd);
-struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
+struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u16 ctxt,
 					   int numa);
 void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 			 struct hfi1_devdata *dd, u8 hw_pidx, u8 port);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index dfdb412..818a4b8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -131,7 +131,7 @@
  */
 int hfi1_create_ctxts(struct hfi1_devdata *dd)
 {
-	unsigned i;
+	u16 i;
 	int ret;
 
 	/* Control context has to be always 0 */
@@ -233,7 +233,7 @@ void hfi1_rcd_get(struct hfi1_ctxtdata *rcd)
 /*
  * Common code for user and kernel context setup.
  */
-struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
+struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u16 ctxt,
 					   int numa)
 {
 	struct hfi1_devdata *dd = ppd->dd;
@@ -615,7 +615,7 @@ static int init_after_reset(struct hfi1_devdata *dd)
 static void enable_chip(struct hfi1_devdata *dd)
 {
 	u32 rcvmask;
-	u32 i;
+	u16 i;
 
 	/* enable PIO send */
 	pio_send_control(dd, PSC_GLOBAL_ENABLE);
@@ -692,7 +692,8 @@ static int create_workqueues(struct hfi1_devdata *dd)
 int hfi1_init(struct hfi1_devdata *dd, int reinit)
 {
 	int ret = 0, pidx, lastfail = 0;
-	unsigned i, len;
+	unsigned long len;
+	u16 i;
 	struct hfi1_ctxtdata *rcd;
 	struct hfi1_pportdata *ppd;
 
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 8492957..bebf0a8 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -114,7 +114,7 @@
 );
 
 TRACE_EVENT(hfi1_receive_interrupt,
-	    TP_PROTO(struct hfi1_devdata *dd, u32 ctxt),
+	    TP_PROTO(struct hfi1_devdata *dd, u16 ctxt),
 	    TP_ARGS(dd, ctxt),
 	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
 			     __field(u32, ctxt)
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 161fdfd..73c2455 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -56,7 +56,7 @@
 extern uint extended_psn;
 
 struct hfi1_user_sdma_pkt_q {
-	unsigned ctxt;
+	u16 ctxt;
 	u16 subctxt;
 	u16 n_max_reqs;
 	atomic_t n_reqs;
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 5a3f80b..9bd2744 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -106,7 +106,7 @@ static int allocate_vnic_ctxt(struct hfi1_devdata *dd,
 			      struct hfi1_ctxtdata **vnic_ctxt)
 {
 	struct hfi1_ctxtdata *uctxt;
-	unsigned int ctxt;
+	u16 ctxt;
 	int ret;
 
 	if (dd->flags & HFI1_FROZEN)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
