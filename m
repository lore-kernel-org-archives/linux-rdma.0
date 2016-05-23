From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/1] Staging: rdma: hfi1: sdma.c: Fixed coding style issues
Date: Mon, 23 May 2016 12:06:02 +0530
Message-ID: <1463985362-8429-2-git-send-email-mayhs11saini@gmail.com>
References: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, infinipath@intel.com, dledford@redhat.com, Shyam Saini <mayhs11saini@gmail.com>, sean.hefty@intel.com
List-Id: linux-rdma@vger.kernel.org

Fixed following checkpatch.pl warnings:
    Prefer 'unsigned int' to bare use of 'unsigned'
    Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/staging/rdma/hfi1/sdma.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index abb8ebc..c2e2856 100644
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
@@ -1351,7 +1351,7 @@ retry:
 
 		swhead = sde->descq_head & sde->sdma_mask;
 		/* this code is really bad for cache line trading */
-		swtail = ACCESS_ONCE(sde->descq_tail) & sde->sdma_mask;
+		swtail = READ_ONCE(sde->descq_tail) & sde->sdma_mask;
 		cnt = sde->descq_cnt;
 
 		if (swhead < swtail)
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
@@ -1854,7 +1854,7 @@ void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *sde)
 	u16 len;
 
 	head = sde->descq_head & sde->sdma_mask;
-	tail = ACCESS_ONCE(sde->descq_tail) & sde->sdma_mask;
+	tail = READ_ONCE(sde->descq_tail) & sde->sdma_mask;
 	seq_printf(s, SDE_FMT, sde->this_idx,
 		   sde->cpu,
 		   sdma_state_name(sde->state.current_state),
@@ -1999,7 +1999,7 @@ static int sdma_check_progress(
 		return -EAGAIN;
 	/* pulse the head_lock */
 	if (wait && wait->sleep) {
-		unsigned seq;
+		unsigned int seq;
 
 		seq = raw_seqcount_begin(
 			(const seqcount_t *)&sde->head_lock.seqcount);
@@ -2926,7 +2926,7 @@ int sdma_ahg_alloc(struct sdma_engine *sde)
 		return -EINVAL;
 	}
 	while (1) {
-		nr = ffz(ACCESS_ONCE(sde->ahg_bits));
+		nr = ffz(READ_ONCE(sde->ahg_bits));
 		if (nr > 31) {
 			trace_hfi1_ahg_allocate(sde, -ENOSPC);
 			return -ENOSPC;
-- 
1.9.1
