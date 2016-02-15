From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/21] staging/rdma/hfi1: Remove blank line after an open
 brace
Date: Sun, 14 Feb 2016 20:19:58 -0800
Message-ID: <20160215041954.351.10805.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove blank line after an open brace to fix checkpatch check:
CHECK: Blank lines aren't necessary after an open brace '{'

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |    5 -----
 drivers/staging/rdma/hfi1/driver.c |    3 ---
 drivers/staging/rdma/hfi1/mad.c    |    2 --
 drivers/staging/rdma/hfi1/qp.c     |    1 -
 drivers/staging/rdma/hfi1/qsfp.c   |    2 --
 drivers/staging/rdma/hfi1/sdma.c   |    2 --
 6 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index ea0ffd4..05e4f07 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1538,7 +1538,6 @@ static u64 read_write_cpu(struct hfi1_devdata *dd, u64 *z_val,
 			  u64 __percpu *cntr,
 			  int vl, int mode, u64 data)
 {
-
 	u64 ret = 0;
 
 	if (vl != CNTR_INVALID_VL)
@@ -5931,7 +5930,6 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 	u64 qsfp_int_mgmt = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
 
 	if (reg & QSFP_HFI0_MODPRST_N) {
-
 		dd_dev_info(dd, "%s: ModPresent triggered QSFP interrupt\n",
 				__func__);
 
@@ -5995,7 +5993,6 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 	}
 
 	if (reg & QSFP_HFI0_INT_N) {
-
 		dd_dev_info(dd, "%s: IntN triggered QSFP interrupt\n",
 				__func__);
 		spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
@@ -9266,7 +9263,6 @@ void qsfp_event(struct work_struct *work)
 	dc_start(dd);
 
 	if (qd->cache_refresh_required) {
-
 		set_qsfp_int_n(ppd, 0);
 
 		wait_for_qsfp_init(ppd);
@@ -10122,7 +10118,6 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 				"%s: logical state did not change to ACTIVE\n",
 				__func__);
 		} else {
-
 			/* tell all engines to go running */
 			sdma_all_running(dd);
 
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 0c8bd91..b5dfdb6 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -440,7 +440,6 @@ drop:
 static inline void init_packet(struct hfi1_ctxtdata *rcd,
 			      struct hfi1_packet *packet)
 {
-
 	packet->rsize = rcd->rcvhdrqentsize; /* words */
 	packet->maxcnt = rcd->rcvhdrq_cnt * packet->rsize; /* words */
 	packet->rcd = rcd;
@@ -755,7 +754,6 @@ static inline void process_rcv_update(int last, struct hfi1_packet *packet)
 
 static inline void finish_packet(struct hfi1_packet *packet)
 {
-
 	/*
 	 * Nothing we need to free for the packet.
 	 *
@@ -769,7 +767,6 @@ static inline void finish_packet(struct hfi1_packet *packet)
 
 static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 {
-
 	struct hfi1_ctxtdata *rcd;
 	struct rvt_qp *qp, *nqp;
 
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 44e7fbd..a7e5f92 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2183,7 +2183,6 @@ struct opa_port_error_info_msg {
 	__be32 error_info_select_mask;
 	__be32 reserved1;
 	struct _port_ei {
-
 		u8 port_number;
 		u8 reserved2[7];
 
@@ -3140,7 +3139,6 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 
 	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
 			 8 * sizeof(vl_select_mask)) {
-
 		if (counter_select & CS_PORT_XMIT_DATA)
 			write_port_cntr(ppd, C_TX_FLIT_VL, idx_from_vl(vl), 0);
 
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index c78b7bd..50309f6 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -464,7 +464,6 @@ static int iowait_sleep(
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
-
 		/*
 		 * If we couldn't queue the DMA request, save the info
 		 * and try again later rather than destroying the
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index a6d55a6..aa9c62b 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -359,7 +359,6 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 
 	/* Is paging enabled? */
 	if (!(cache[2] & 4)) {
-
 		/* Paging enabled, page 03 required */
 		if ((cache[195] & 0xC0) == 0xC0) {
 			/* all */
@@ -520,7 +519,6 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 	lenstr[1] = '\0';
 
 	if (ppd->qsfp_info.cache_valid) {
-
 		if (QSFP_IS_CU(cache[QSFP_MOD_TECH_OFFS]))
 			sprintf(lenstr, "%dM ", cache[QSFP_MOD_LEN_OFFS]);
 
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 3312324..d8edf9b 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -475,7 +475,6 @@ static void sdma_err_halt_wait(struct work_struct *work)
 static void sdma_err_progress_check_schedule(struct sdma_engine *sde)
 {
 	if (!is_bx(sde->dd) && HFI1_CAP_IS_KSET(SDMA_AHG)) {
-
 		unsigned index;
 		struct hfi1_devdata *dd = sde->dd;
 
@@ -1239,7 +1238,6 @@ void sdma_exit(struct hfi1_devdata *dd)
 
 	for (this_idx = 0; dd->per_sdma && this_idx < dd->num_sdma;
 			++this_idx) {
-
 		sde = &dd->per_sdma[this_idx];
 		if (!list_empty(&sde->dmawait))
 			dd_dev_err(dd, "sde %u: dmawait list not empty!\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
