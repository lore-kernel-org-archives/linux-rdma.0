From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH 01/27] timecounter: Make cyclecounter struct
	part of timecounter struct
Date: Fri, 15 Dec 2017 13:08:16 +0530
Message-ID: <1513323522-15021-2-git-send-email-sagar.a.kamble@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>, Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <john.stultz@linaro.org>, intel-wired-lan@lists.osuosl.org, Thomas Gleixner <tglx@linutronix.de>, Sagar Arun Kamble <sagar.a.kamble@intel.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

There is no real need for the users of timecounters to define cyclecounter
and timecounter variables separately. Since timecounter will always be
based on cyclecounter, have cyclecounter struct as member of timecounter
struct.

v2: Rebase.

Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org
Cc: linux-rdma@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: kvmarm@lists.cs.columbia.edu
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com> (Intel drivers)
---
 arch/microblaze/kernel/timer.c                     | 20 ++++++------
 drivers/clocksource/arm_arch_timer.c               | 19 ++++++------
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c           |  9 +++---
 drivers/net/ethernet/amd/xgbe/xgbe.h               |  1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 20 ++++++------
 drivers/net/ethernet/freescale/fec.h               |  1 -
 drivers/net/ethernet/freescale/fec_ptp.c           | 30 +++++++++---------
 drivers/net/ethernet/intel/e1000e/e1000.h          |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         | 27 ++++++++--------
 drivers/net/ethernet/intel/e1000e/ptp.c            |  2 +-
 drivers/net/ethernet/intel/igb/igb.h               |  1 -
 drivers/net/ethernet/intel/igb/igb_ptp.c           | 25 ++++++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 17 +++++-----
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      | 28 ++++++++---------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  1 -
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 34 ++++++++++----------
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 20 ++++++------
 drivers/net/ethernet/ti/cpts.c                     | 36 ++++++++++++----------
 drivers/net/ethernet/ti/cpts.h                     |  1 -
 include/linux/mlx5/driver.h                        |  1 -
 include/linux/timecounter.h                        |  4 +--
 include/sound/hdaudio.h                            |  1 -
 kernel/time/timecounter.c                          | 28 ++++++++---------
 sound/hda/hdac_stream.c                            |  7 +++--
 virt/kvm/arm/arch_timer.c                          |  6 ++--
 28 files changed, 163 insertions(+), 182 deletions(-)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 7de941c..b7f89e9 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -199,27 +199,25 @@ static u64 xilinx_read(struct clocksource *cs)
 	return (u64)xilinx_clock_read();
 }
 
-static struct timecounter xilinx_tc = {
-	.cc = NULL,
-};
-
 static u64 xilinx_cc_read(const struct cyclecounter *cc)
 {
 	return xilinx_read(NULL);
 }
 
-static struct cyclecounter xilinx_cc = {
-	.read = xilinx_cc_read,
-	.mask = CLOCKSOURCE_MASK(32),
-	.shift = 8,
+static struct timecounter xilinx_tc = {
+	.cc.read = xilinx_cc_read,
+	.cc.mask = CLOCKSOURCE_MASK(32),
+	.cc.mult = 0,
+	.cc.shift = 8,
 };
 
 static int __init init_xilinx_timecounter(void)
 {
-	xilinx_cc.mult = div_sc(timer_clock_freq, NSEC_PER_SEC,
-				xilinx_cc.shift);
+	struct cyclecounter *cc = &xilinx_tc.cc;
+
+	cc->mult = div_sc(timer_clock_freq, NSEC_PER_SEC, cc->shift);
 
-	timecounter_init(&xilinx_tc, &xilinx_cc, sched_clock());
+	timecounter_init(&xilinx_tc, sched_clock());
 
 	return 0;
 }
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 57cb2f0..31543e5 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -179,11 +179,6 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-static struct cyclecounter cyclecounter __ro_after_init = {
-	.read	= arch_counter_read_cc,
-	.mask	= CLOCKSOURCE_MASK(56),
-};
-
 struct ate_acpi_oem_info {
 	char oem_id[ACPI_OEM_ID_SIZE + 1];
 	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
@@ -915,7 +910,10 @@ static u64 arch_counter_get_cntvct_mem(void)
 	return ((u64) vct_hi << 32) | vct_lo;
 }
 
-static struct arch_timer_kvm_info arch_timer_kvm_info;
+static struct arch_timer_kvm_info arch_timer_kvm_info = {
+	.timecounter.cc.read = arch_counter_read_cc,
+	.timecounter.cc.mask = CLOCKSOURCE_MASK(56),
+};
 
 struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
 {
@@ -925,6 +923,7 @@ struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
 static void __init arch_counter_register(unsigned type)
 {
 	u64 start_count;
+	struct cyclecounter *cc = &arch_timer_kvm_info.timecounter.cc;
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_TIMER_TYPE_CP15) {
@@ -943,10 +942,10 @@ static void __init arch_counter_register(unsigned type)
 		clocksource_counter.flags |= CLOCK_SOURCE_SUSPEND_NONSTOP;
 	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
-	cyclecounter.mult = clocksource_counter.mult;
-	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&arch_timer_kvm_info.timecounter,
-			 &cyclecounter, start_count);
+
+	cc->mult = clocksource_counter.mult;
+	cc->shift = clocksource_counter.shift;
+	timecounter_init(&arch_timer_kvm_info.timecounter, start_count);
 
 	/* 56 bits minimum, so we assume worst case rollover */
 	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index e107e18..5005c87 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -1622,8 +1622,7 @@ static int xgbe_config_tstamp(struct xgbe_prv_data *pdata,
 	xgbe_set_tstamp_time(pdata, 0, 0);
 
 	/* Initialize the timecounter */
-	timecounter_init(&pdata->tstamp_tc, &pdata->tstamp_cc,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&pdata->tstamp_tc, ktime_to_ns(ktime_get_real()));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
index d06d260..5ea4edf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
@@ -126,7 +126,7 @@ static u64 xgbe_cc_read(const struct cyclecounter *cc)
 {
 	struct xgbe_prv_data *pdata = container_of(cc,
 						   struct xgbe_prv_data,
-						   tstamp_cc);
+						   tstamp_tc.cc);
 	u64 nsec;
 
 	nsec = pdata->hw_if.get_tstamp_time(pdata);
@@ -211,7 +211,7 @@ static int xgbe_settime(struct ptp_clock_info *info,
 
 	spin_lock_irqsave(&pdata->tstamp_lock, flags);
 
-	timecounter_init(&pdata->tstamp_tc, &pdata->tstamp_cc, nsec);
+	timecounter_init(&pdata->tstamp_tc, nsec);
 
 	spin_unlock_irqrestore(&pdata->tstamp_lock, flags);
 
@@ -228,7 +228,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
 {
 	struct ptp_clock_info *info = &pdata->ptp_clock_info;
 	struct ptp_clock *clock;
-	struct cyclecounter *cc = &pdata->tstamp_cc;
+	struct cyclecounter *cc = &pdata->tstamp_tc.cc;
 	u64 dividend;
 
 	snprintf(info->name, sizeof(info->name), "%s",
@@ -263,8 +263,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
 	cc->mult = 1;
 	cc->shift = 0;
 
-	timecounter_init(&pdata->tstamp_tc, &pdata->tstamp_cc,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&pdata->tstamp_tc, ktime_to_ns(ktime_get_real()));
 
 	/* Disable all timestamping to start */
 	XGMAC_IOWRITE(pdata, MAC_TSCR, 0);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index ad102c8..2445103 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1168,7 +1168,6 @@ struct xgbe_prv_data {
 	struct ptp_clock_info ptp_clock_info;
 	struct ptp_clock *ptp_clock;
 	struct hwtstamp_config tstamp_config;
-	struct cyclecounter tstamp_cc;
 	struct timecounter tstamp_tc;
 	unsigned int tstamp_addend;
 	struct work_struct tx_tstamp_work;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 352beff..f164fe0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1827,7 +1827,6 @@ struct bnx2x {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_info;
 	struct work_struct ptp_task;
-	struct cyclecounter cyclecounter;
 	struct timecounter timecounter;
 	bool timecounter_init_done;
 	struct sk_buff *ptp_tx_skb;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 91e2a75..83624ad 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13850,7 +13850,7 @@ static int bnx2x_ptp_settime(struct ptp_clock_info *ptp,
 	DP(BNX2X_MSG_PTP, "PTP settime called, ns = %llu\n", ns);
 
 	/* Re-init the timecounter */
-	timecounter_init(&bp->timecounter, &bp->cyclecounter, ns);
+	timecounter_init(&bp->timecounter, ns);
 
 	return 0;
 }
@@ -15254,7 +15254,7 @@ void bnx2x_set_rx_ts(struct bnx2x *bp, struct sk_buff *skb)
 /* Read the PHC */
 static u64 bnx2x_cyclecounter_read(const struct cyclecounter *cc)
 {
-	struct bnx2x *bp = container_of(cc, struct bnx2x, cyclecounter);
+	struct bnx2x *bp = container_of(cc, struct bnx2x, timecounter.cc);
 	int port = BP_PORT(bp);
 	u32 wb_data[2];
 	u64 phc_cycles;
@@ -15269,13 +15269,13 @@ static u64 bnx2x_cyclecounter_read(const struct cyclecounter *cc)
 	return phc_cycles;
 }
 
-static void bnx2x_init_cyclecounter(struct bnx2x *bp)
+static void bnx2x_init_cyclecounter(struct cyclecounter *cc)
 {
-	memset(&bp->cyclecounter, 0, sizeof(bp->cyclecounter));
-	bp->cyclecounter.read = bnx2x_cyclecounter_read;
-	bp->cyclecounter.mask = CYCLECOUNTER_MASK(64);
-	bp->cyclecounter.shift = 0;
-	bp->cyclecounter.mult = 1;
+	memset(cc, 0, sizeof(*cc));
+	cc->read = bnx2x_cyclecounter_read;
+	cc->mask = CYCLECOUNTER_MASK(64);
+	cc->shift = 0;
+	cc->mult = 1;
 }
 
 static int bnx2x_send_reset_timesync_ramrod(struct bnx2x *bp)
@@ -15511,8 +15511,8 @@ void bnx2x_init_ptp(struct bnx2x *bp)
 	 * unload / load (e.g. MTU change) while it is running.
 	 */
 	if (!bp->timecounter_init_done) {
-		bnx2x_init_cyclecounter(bp);
-		timecounter_init(&bp->timecounter, &bp->cyclecounter,
+		bnx2x_init_cyclecounter(&bp->timecounter.cc);
+		timecounter_init(&bp->timecounter,
 				 ktime_to_ns(ktime_get_real()));
 		bp->timecounter_init_done = 1;
 	}
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 5385074..d54b501 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -549,7 +549,6 @@ struct fec_enet_private {
 	struct ptp_clock_info ptp_caps;
 	unsigned long last_overflow_check;
 	spinlock_t tmreg_lock;
-	struct cyclecounter cc;
 	struct timecounter tc;
 	int rx_hwtstamp_filter;
 	u32 base_incval;
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index f814397..b1261d1 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -186,13 +186,14 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 		 * ptp counter, which maybe cause 32-bit wrap. Since the
 		 * (NSEC_PER_SEC - (u32)ts.tv_nsec) is less than 2 second.
 		 * We can ensure the wrap will not cause issue. If the offset
-		 * is bigger than fep->cc.mask would be a error.
+		 * is bigger than fep->tc.cc.mask would be a error.
 		 */
-		val &= fep->cc.mask;
+		val &= fep->tc.cc.mask;
 		writel(val, fep->hwp + FEC_TCCR(fep->pps_channel));
 
 		/* Calculate the second the compare event timestamp */
-		fep->next_counter = (val + fep->reload_period) & fep->cc.mask;
+		fep->next_counter = (val + fep->reload_period) &
+				    fep->tc.cc.mask;
 
 		/* * Enable compare event when overflow */
 		val = readl(fep->hwp + FEC_ATIME_CTRL);
@@ -211,7 +212,8 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 		 * the third timestamp. Refer the TCCR register detail in the spec.
 		 */
 		writel(fep->next_counter, fep->hwp + FEC_TCCR(fep->pps_channel));
-		fep->next_counter = (fep->next_counter + fep->reload_period) & fep->cc.mask;
+		fep->next_counter = (fep->next_counter + fep->reload_period) &
+				    fep->tc.cc.mask;
 	} else {
 		writel(0, fep->hwp + FEC_TCSR(fep->pps_channel));
 	}
@@ -233,7 +235,7 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 static u64 fec_ptp_read(const struct cyclecounter *cc)
 {
 	struct fec_enet_private *fep =
-		container_of(cc, struct fec_enet_private, cc);
+		container_of(cc, struct fec_enet_private, tc.cc);
 	const struct platform_device_id *id_entry =
 		platform_get_device_id(fep->pdev);
 	u32 tempval;
@@ -276,14 +278,14 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 	writel(FEC_T_CTRL_ENABLE | FEC_T_CTRL_PERIOD_RST,
 		fep->hwp + FEC_ATIME_CTRL);
 
-	memset(&fep->cc, 0, sizeof(fep->cc));
-	fep->cc.read = fec_ptp_read;
-	fep->cc.mask = CLOCKSOURCE_MASK(31);
-	fep->cc.shift = 31;
-	fep->cc.mult = FEC_CC_MULT;
+	memset(&fep->tc.cc, 0, sizeof(fep->tc.cc));
+	fep->tc.cc.read = fec_ptp_read;
+	fep->tc.cc.mask = CLOCKSOURCE_MASK(31);
+	fep->tc.cc.shift = 31;
+	fep->tc.cc.mult = FEC_CC_MULT;
 
 	/* reset the ns time counter */
-	timecounter_init(&fep->tc, &fep->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&fep->tc, ktime_to_ns(ktime_get_real()));
 
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
@@ -434,11 +436,11 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	/* Get the timer value based on timestamp.
 	 * Update the counter with the masked value.
 	 */
-	counter = ns & fep->cc.mask;
+	counter = ns & fep->tc.cc.mask;
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(counter, fep->hwp + FEC_ATIME);
-	timecounter_init(&fep->tc, &fep->cc, ns);
+	timecounter_init(&fep->tc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	mutex_unlock(&fep->ptp_clk_mutex);
 	return 0;
@@ -570,7 +572,7 @@ static irqreturn_t fec_pps_interrupt(int irq, void *dev_id)
 
 		/* Update the counter; */
 		fep->next_counter = (fep->next_counter + fep->reload_period) &
-				fep->cc.mask;
+				    fep->tc.cc.mask;
 
 		event.type = PTP_CLOCK_PPS;
 		ptp_clock_event(fep->ptp_clock, &event);
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 2311b31..b59f82a 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -340,7 +340,6 @@ struct e1000_adapter {
 	unsigned long tx_hwtstamp_start;
 	struct work_struct tx_hwtstamp_work;
 	spinlock_t systim_lock;	/* protects SYSTIML/H regsters */
-	struct cyclecounter cc;
 	struct timecounter tc;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_info;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 9f18d39..c9f7ba3 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3536,7 +3536,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 		incperiod = INCPERIOD_96MHZ;
 		incvalue = INCVALUE_96MHZ;
 		shift = INCVALUE_SHIFT_96MHZ;
-		adapter->cc.shift = shift + INCPERIOD_SHIFT_96MHZ;
+		adapter->tc.cc.shift = shift + INCPERIOD_SHIFT_96MHZ;
 		break;
 	case e1000_pch_lpt:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
@@ -3544,13 +3544,13 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 			incperiod = INCPERIOD_96MHZ;
 			incvalue = INCVALUE_96MHZ;
 			shift = INCVALUE_SHIFT_96MHZ;
-			adapter->cc.shift = shift + INCPERIOD_SHIFT_96MHZ;
+			adapter->tc.cc.shift = shift + INCPERIOD_SHIFT_96MHZ;
 		} else {
 			/* Stable 25MHz frequency */
 			incperiod = INCPERIOD_25MHZ;
 			incvalue = INCVALUE_25MHZ;
 			shift = INCVALUE_SHIFT_25MHZ;
-			adapter->cc.shift = shift;
+			adapter->tc.cc.shift = shift;
 		}
 		break;
 	case e1000_pch_spt:
@@ -3559,7 +3559,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 			incperiod = INCPERIOD_24MHZ;
 			incvalue = INCVALUE_24MHZ;
 			shift = INCVALUE_SHIFT_24MHZ;
-			adapter->cc.shift = shift;
+			adapter->tc.cc.shift = shift;
 			break;
 		}
 		return -EINVAL;
@@ -3569,13 +3569,13 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 			incperiod = INCPERIOD_24MHZ;
 			incvalue = INCVALUE_24MHZ;
 			shift = INCVALUE_SHIFT_24MHZ;
-			adapter->cc.shift = shift;
+			adapter->tc.cc.shift = shift;
 		} else {
 			/* Stable 38400KHz frequency */
 			incperiod = INCPERIOD_38400KHZ;
 			incvalue = INCVALUE_38400KHZ;
 			shift = INCVALUE_SHIFT_38400KHZ;
-			adapter->cc.shift = shift;
+			adapter->tc.cc.shift = shift;
 		}
 		break;
 	case e1000_82574:
@@ -3584,7 +3584,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 		incperiod = INCPERIOD_25MHZ;
 		incvalue = INCVALUE_25MHZ;
 		shift = INCVALUE_SHIFT_25MHZ;
-		adapter->cc.shift = shift;
+		adapter->tc.cc.shift = shift;
 		break;
 	default:
 		return -EINVAL;
@@ -3955,8 +3955,7 @@ static void e1000e_systim_reset(struct e1000_adapter *adapter)
 
 	/* reset the systim ns time counter */
 	spin_lock_irqsave(&adapter->systim_lock, flags);
-	timecounter_init(&adapter->tc, &adapter->cc,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&adapter->tc, ktime_to_ns(ktime_get_real()));
 	spin_unlock_irqrestore(&adapter->systim_lock, flags);
 
 	/* restore the previous hwtstamp configuration settings */
@@ -4389,7 +4388,7 @@ static u64 e1000e_sanitize_systim(struct e1000_hw *hw, u64 systim)
 static u64 e1000e_cyclecounter_read(const struct cyclecounter *cc)
 {
 	struct e1000_adapter *adapter = container_of(cc, struct e1000_adapter,
-						     cc);
+						     tc.cc);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 systimel, systimeh;
 	u64 systim;
@@ -4449,10 +4448,10 @@ static int e1000_sw_init(struct e1000_adapter *adapter)
 
 	/* Setup hardware time stamping cyclecounter */
 	if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
-		adapter->cc.read = e1000e_cyclecounter_read;
-		adapter->cc.mask = CYCLECOUNTER_MASK(64);
-		adapter->cc.mult = 1;
-		/* cc.shift set in e1000e_get_base_tininca() */
+		adapter->tc.cc.read = e1000e_cyclecounter_read;
+		adapter->tc.cc.mask = CYCLECOUNTER_MASK(64);
+		adapter->tc.cc.mult = 1;
+		/* tc.cc.shift set in e1000e_get_base_tininca() */
 
 		spin_lock_init(&adapter->systim_lock);
 		INIT_WORK(&adapter->tx_hwtstamp_work, e1000e_tx_hwtstamp_work);
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index b366885..03d5f2a 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -222,7 +222,7 @@ static int e1000e_phc_settime(struct ptp_clock_info *ptp,
 
 	/* reset the timecounter */
 	spin_lock_irqsave(&adapter->systim_lock, flags);
-	timecounter_init(&adapter->tc, &adapter->cc, ns);
+	timecounter_init(&adapter->tc, ns);
 	spin_unlock_irqrestore(&adapter->systim_lock, flags);
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 9284569..4eac4f2 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -565,7 +565,6 @@ struct igb_adapter {
 	unsigned long last_rx_timestamp;
 	unsigned int ptp_flags;
 	spinlock_t tmreg_lock;
-	struct cyclecounter cc;
 	struct timecounter tc;
 	u32 tx_hwtstamp_timeouts;
 	u32 tx_hwtstamp_skipped;
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 841c2a0..0745eff 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -79,7 +79,7 @@
 /* SYSTIM read access for the 82576 */
 static u64 igb_ptp_read_82576(const struct cyclecounter *cc)
 {
-	struct igb_adapter *igb = container_of(cc, struct igb_adapter, cc);
+	struct igb_adapter *igb = container_of(cc, struct igb_adapter, tc.cc);
 	struct e1000_hw *hw = &igb->hw;
 	u64 val;
 	u32 lo, hi;
@@ -96,7 +96,7 @@ static u64 igb_ptp_read_82576(const struct cyclecounter *cc)
 /* SYSTIM read access for the 82580 */
 static u64 igb_ptp_read_82580(const struct cyclecounter *cc)
 {
-	struct igb_adapter *igb = container_of(cc, struct igb_adapter, cc);
+	struct igb_adapter *igb = container_of(cc, struct igb_adapter, tc.cc);
 	struct e1000_hw *hw = &igb->hw;
 	u32 lo, hi;
 	u64 val;
@@ -330,7 +330,7 @@ static int igb_ptp_settime_82576(struct ptp_clock_info *ptp,
 
 	spin_lock_irqsave(&igb->tmreg_lock, flags);
 
-	timecounter_init(&igb->tc, &igb->cc, ns);
+	timecounter_init(&igb->tc, ns);
 
 	spin_unlock_irqrestore(&igb->tmreg_lock, flags);
 
@@ -1126,10 +1126,10 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		adapter->ptp_caps.gettime64 = igb_ptp_gettime_82576;
 		adapter->ptp_caps.settime64 = igb_ptp_settime_82576;
 		adapter->ptp_caps.enable = igb_ptp_feature_enable;
-		adapter->cc.read = igb_ptp_read_82576;
-		adapter->cc.mask = CYCLECOUNTER_MASK(64);
-		adapter->cc.mult = 1;
-		adapter->cc.shift = IGB_82576_TSYNC_SHIFT;
+		adapter->tc.cc.read = igb_ptp_read_82576;
+		adapter->tc.cc.mask = CYCLECOUNTER_MASK(64);
+		adapter->tc.cc.mult = 1;
+		adapter->tc.cc.shift = IGB_82576_TSYNC_SHIFT;
 		adapter->ptp_flags |= IGB_PTP_OVERFLOW_CHECK;
 		break;
 	case e1000_82580:
@@ -1145,10 +1145,10 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		adapter->ptp_caps.gettime64 = igb_ptp_gettime_82576;
 		adapter->ptp_caps.settime64 = igb_ptp_settime_82576;
 		adapter->ptp_caps.enable = igb_ptp_feature_enable;
-		adapter->cc.read = igb_ptp_read_82580;
-		adapter->cc.mask = CYCLECOUNTER_MASK(IGB_NBITS_82580);
-		adapter->cc.mult = 1;
-		adapter->cc.shift = 0;
+		adapter->tc.cc.read = igb_ptp_read_82580;
+		adapter->tc.cc.mask = CYCLECOUNTER_MASK(IGB_NBITS_82580);
+		adapter->tc.cc.mult = 1;
+		adapter->tc.cc.shift = 0;
 		adapter->ptp_flags |= IGB_PTP_OVERFLOW_CHECK;
 		break;
 	case e1000_i210:
@@ -1289,8 +1289,7 @@ void igb_ptp_reset(struct igb_adapter *adapter)
 
 		igb_ptp_write_i210(adapter, &ts);
 	} else {
-		timecounter_init(&adapter->tc, &adapter->cc,
-				 ktime_to_ns(ktime_get_real()));
+		timecounter_init(&adapter->tc, ktime_to_ns(ktime_get_real()));
 	}
 out:
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 468c355..5c391a0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -738,7 +738,6 @@ struct ixgbe_adapter {
 	unsigned long last_rx_ptp_check;
 	unsigned long last_rx_timestamp;
 	spinlock_t tmreg_lock;
-	struct cyclecounter hw_cc;
 	struct timecounter hw_tc;
 	u32 base_incval;
 	u32 tx_hwtstamp_timeouts;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index ae312c4..6e9f2c0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -179,7 +179,7 @@
 static void ixgbe_ptp_setup_sdp_x540(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	int shift = adapter->hw_cc.shift;
+	int shift = adapter->hw_tc.cc.shift;
 	u32 esdp, tsauxc, clktiml, clktimh, trgttiml, trgttimh, rem;
 	u64 ns = 0, clock_edge = 0;
 
@@ -237,7 +237,7 @@ static void ixgbe_ptp_setup_sdp_x540(struct ixgbe_adapter *adapter)
 
 /**
  * ixgbe_ptp_read_X550 - read cycle counter value
- * @hw_cc: cyclecounter structure
+ * @cc: cyclecounter structure
  *
  * This function reads SYSTIME registers. It is called by the cyclecounter
  * structure to convert from internal representation into nanoseconds. We need
@@ -245,10 +245,10 @@ static void ixgbe_ptp_setup_sdp_x540(struct ixgbe_adapter *adapter)
  * result of SYSTIME is 32bits of "billions of cycles" and 32 bits of
  * "cycles", rather than seconds and nanoseconds.
  */
-static u64 ixgbe_ptp_read_X550(const struct cyclecounter *hw_cc)
+static u64 ixgbe_ptp_read_X550(const struct cyclecounter *cc)
 {
 	struct ixgbe_adapter *adapter =
-			container_of(hw_cc, struct ixgbe_adapter, hw_cc);
+			container_of(cc, struct ixgbe_adapter, hw_tc.cc);
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct timespec64 ts;
 
@@ -285,7 +285,7 @@ static u64 ixgbe_ptp_read_X550(const struct cyclecounter *hw_cc)
 static u64 ixgbe_ptp_read_82599(const struct cyclecounter *cc)
 {
 	struct ixgbe_adapter *adapter =
-		container_of(cc, struct ixgbe_adapter, hw_cc);
+		container_of(cc, struct ixgbe_adapter, hw_tc.cc);
 	struct ixgbe_hw *hw = &adapter->hw;
 	u64 stamp = 0;
 
@@ -508,7 +508,7 @@ static int ixgbe_ptp_settime(struct ptp_clock_info *ptp,
 
 	/* reset the timecounter */
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	timecounter_init(&adapter->hw_tc, &adapter->hw_cc, ns);
+	timecounter_init(&adapter->hw_tc, ns);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
 	if (adapter->ptp_setup_sdp)
@@ -1164,7 +1164,7 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 
 	/* need lock to prevent incorrect read while modifying cyclecounter */
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	memcpy(&adapter->hw_cc, &cc, sizeof(adapter->hw_cc));
+	memcpy(&adapter->hw_tc.cc, &cc, sizeof(adapter->hw_tc.cc));
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 }
 
@@ -1195,8 +1195,7 @@ void ixgbe_ptp_reset(struct ixgbe_adapter *adapter)
 	ixgbe_ptp_start_cyclecounter(adapter);
 
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	timecounter_init(&adapter->hw_tc, &adapter->hw_cc,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&adapter->hw_tc, ktime_to_ns(ktime_get_real()));
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
 	adapter->last_overflow_check = jiffies;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 0247885..35987b5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -38,13 +38,13 @@
 
 /* mlx4_en_read_clock - read raw cycle counter (to be used by time counter)
  */
-static u64 mlx4_en_read_clock(const struct cyclecounter *tc)
+static u64 mlx4_en_read_clock(const struct cyclecounter *cc)
 {
 	struct mlx4_en_dev *mdev =
-		container_of(tc, struct mlx4_en_dev, cycles);
+		container_of(cc, struct mlx4_en_dev, clock.cc);
 	struct mlx4_dev *dev = mdev->dev;
 
-	return mlx4_read_clock(dev) & tc->mask;
+	return mlx4_read_clock(dev) & cc->mask;
 }
 
 u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
@@ -138,7 +138,7 @@ static int mlx4_en_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
 	timecounter_read(&mdev->clock);
-	mdev->cycles.mult = neg_adj ? mult - diff : mult + diff;
+	mdev->clock.cc.mult = neg_adj ? mult - diff : mult + diff;
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	return 0;
@@ -207,7 +207,7 @@ static int mlx4_en_phc_settime(struct ptp_clock_info *ptp,
 
 	/* reset the timecounter */
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
-	timecounter_init(&mdev->clock, &mdev->cycles, ns);
+	timecounter_init(&mdev->clock, ns);
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	return 0;
@@ -274,17 +274,17 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
 
 	seqlock_init(&mdev->clock_lock);
 
-	memset(&mdev->cycles, 0, sizeof(mdev->cycles));
-	mdev->cycles.read = mlx4_en_read_clock;
-	mdev->cycles.mask = CLOCKSOURCE_MASK(48);
-	mdev->cycles.shift = freq_to_shift(dev->caps.hca_core_clock);
-	mdev->cycles.mult =
-		clocksource_khz2mult(1000 * dev->caps.hca_core_clock, mdev->cycles.shift);
-	mdev->nominal_c_mult = mdev->cycles.mult;
+	memset(&mdev->clock.cc, 0, sizeof(mdev->clock.cc));
+	mdev->clock.cc.read = mlx4_en_read_clock;
+	mdev->clock.cc.mask = CLOCKSOURCE_MASK(48);
+	mdev->clock.cc.shift = freq_to_shift(dev->caps.hca_core_clock);
+	mdev->clock.cc.mult =
+		clocksource_khz2mult(1000 * dev->caps.hca_core_clock,
+				     mdev->clock.cc.shift);
+	mdev->nominal_c_mult = mdev->clock.cc.mult;
 
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
-	timecounter_init(&mdev->clock, &mdev->cycles,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&mdev->clock, ktime_to_ns(ktime_get_real()));
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	/* Configure the PHC */
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 1856e27..e301dcf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -422,7 +422,6 @@ struct mlx4_en_dev {
 	spinlock_t              uar_lock;
 	u8			mac_removed[MLX4_MAX_PORTS + 1];
 	u32			nominal_c_mult;
-	struct cyclecounter	cycles;
 	seqlock_t		clock_lock;
 	struct timecounter	clock;
 	unsigned long		last_overflow_check;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index fa8aed6..8cb6838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -64,7 +64,7 @@ enum {
 
 static u64 read_internal_timer(const struct cyclecounter *cc)
 {
-	struct mlx5_clock *clock = container_of(cc, struct mlx5_clock, cycles);
+	struct mlx5_clock *clock = container_of(cc, struct mlx5_clock, tc.cc);
 	struct mlx5_core_dev *mdev = container_of(clock, struct mlx5_core_dev,
 						  clock);
 
@@ -122,7 +122,7 @@ static int mlx5_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 
 	write_lock_irqsave(&clock->lock, flags);
-	timecounter_init(&clock->tc, &clock->cycles, ns);
+	timecounter_init(&clock->tc, ns);
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -177,8 +177,8 @@ static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 
 	write_lock_irqsave(&clock->lock, flags);
 	timecounter_read(&clock->tc);
-	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
-				       clock->nominal_c_mult + diff;
+	clock->tc.cc.mult = neg_adj ? clock->nominal_c_mult - diff :
+				      clock->nominal_c_mult + diff;
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -281,8 +281,8 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		write_lock_irqsave(&clock->lock, flags);
 		nsec_now = timecounter_cyc2time(&clock->tc, cycles_now);
 		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << clock->cycles.shift,
-					 clock->cycles.mult);
+		cycles_delta = div64_u64(nsec_delta << clock->tc.cc.shift,
+					 clock->tc.cc.mult);
 		write_unlock_irqrestore(&clock->lock, flags);
 		time_stamp = cycles_now + cycles_delta;
 		field_select = MLX5_MTPPS_FS_PIN_MODE |
@@ -440,8 +440,8 @@ void mlx5_pps_event(struct mlx5_core_dev *mdev,
 		write_lock_irqsave(&clock->lock, flags);
 		nsec_now = timecounter_cyc2time(&clock->tc, cycles_now);
 		nsec_delta = ns - nsec_now;
-		cycles_delta = div64_u64(nsec_delta << clock->cycles.shift,
-					 clock->cycles.mult);
+		cycles_delta = div64_u64(nsec_delta << clock->tc.cc.shift,
+					 clock->tc.cc.mult);
 		clock->pps_info.start[pin] = cycles_now + cycles_delta;
 		schedule_work(&clock->pps_info.out_work);
 		write_unlock_irqrestore(&clock->lock, flags);
@@ -454,6 +454,7 @@ void mlx5_pps_event(struct mlx5_core_dev *mdev,
 void mlx5_init_clock(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_clock *clock = &mdev->clock;
+	struct cyclecounter *cc = &clock->tc.cc;
 	u64 ns;
 	u64 frac = 0;
 	u32 dev_freq;
@@ -464,21 +465,18 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 		return;
 	}
 	rwlock_init(&clock->lock);
-	clock->cycles.read = read_internal_timer;
-	clock->cycles.shift = MLX5_CYCLES_SHIFT;
-	clock->cycles.mult = clocksource_khz2mult(dev_freq,
-						  clock->cycles.shift);
-	clock->nominal_c_mult = clock->cycles.mult;
-	clock->cycles.mask = CLOCKSOURCE_MASK(41);
+	cc->read = read_internal_timer;
+	cc->shift = MLX5_CYCLES_SHIFT;
+	cc->mult = clocksource_khz2mult(dev_freq, cc->shift);
+	clock->nominal_c_mult = cc->mult;
+	cc->mask = CLOCKSOURCE_MASK(41);
 
-	timecounter_init(&clock->tc, &clock->cycles,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&clock->tc, ktime_to_ns(ktime_get_real()));
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least once every wrap around.
 	 */
-	ns = cyclecounter_cyc2ns(&clock->cycles, clock->cycles.mask,
-				 frac, &frac);
+	ns = cyclecounter_cyc2ns(cc, cc->mask, frac, &frac);
 	do_div(ns, NSEC_PER_SEC / 2 / HZ);
 	clock->overflow_period = ns;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 9b2280b..95bb8a8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -34,7 +34,6 @@
 struct qede_ptp {
 	const struct qed_eth_ptp_ops	*ops;
 	struct ptp_clock_info		clock_info;
-	struct cyclecounter		cc;
 	struct timecounter		tc;
 	struct ptp_clock		*clock;
 	struct work_struct		work;
@@ -132,7 +131,7 @@ static int qede_ptp_settime(struct ptp_clock_info *info,
 
 	/* Re-init the timecounter */
 	spin_lock_bh(&ptp->lock);
-	timecounter_init(&ptp->tc, &ptp->cc, ns);
+	timecounter_init(&ptp->tc, ns);
 	spin_unlock_bh(&ptp->lock);
 
 	return 0;
@@ -196,7 +195,7 @@ static u64 qede_ptp_read_cc(const struct cyclecounter *cc)
 	u64 phc_cycles;
 	int rc;
 
-	ptp = container_of(cc, struct qede_ptp, cc);
+	ptp = container_of(cc, struct qede_ptp, tc.cc);
 	edev = ptp->edev;
 	rc = ptp->ops->read_cc(edev->cdev, &phc_cycles);
 	if (rc)
@@ -428,14 +427,13 @@ static int qede_ptp_init(struct qede_dev *edev, bool init_tc)
 	 * unload / load (e.g. MTU change) while it is running.
 	 */
 	if (init_tc) {
-		memset(&ptp->cc, 0, sizeof(ptp->cc));
-		ptp->cc.read = qede_ptp_read_cc;
-		ptp->cc.mask = CYCLECOUNTER_MASK(64);
-		ptp->cc.shift = 0;
-		ptp->cc.mult = 1;
-
-		timecounter_init(&ptp->tc, &ptp->cc,
-				 ktime_to_ns(ktime_get_real()));
+		memset(&ptp->tc.cc, 0, sizeof(ptp->tc.cc));
+		ptp->tc.cc.read = qede_ptp_read_cc;
+		ptp->tc.cc.mask = CYCLECOUNTER_MASK(64);
+		ptp->tc.cc.shift = 0;
+		ptp->tc.cc.mult = 1;
+
+		timecounter_init(&ptp->tc, ktime_to_ns(ktime_get_real()));
 	}
 
 	return rc;
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index e7b76f6..b8fe843 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -182,7 +182,7 @@ static u64 cpts_systim_read(const struct cyclecounter *cc)
 	u64 val = 0;
 	struct cpts_event *event;
 	struct list_head *this, *next;
-	struct cpts *cpts = container_of(cc, struct cpts, cc);
+	struct cpts *cpts = container_of(cc, struct cpts, tc.cc);
 
 	cpts_write32(cpts, TS_PUSH, ts_push);
 	if (cpts_fifo_read(cpts, CPTS_EV_PUSH))
@@ -224,7 +224,7 @@ static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 
 	timecounter_read(&cpts->tc);
 
-	cpts->cc.mult = neg_adj ? mult - diff : mult + diff;
+	cpts->tc.cc.mult = neg_adj ? mult - diff : mult + diff;
 
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
@@ -268,7 +268,7 @@ static int cpts_ptp_settime(struct ptp_clock_info *ptp,
 	ns = timespec64_to_ns(ts);
 
 	spin_lock_irqsave(&cpts->lock, flags);
-	timecounter_init(&cpts->tc, &cpts->cc, ns);
+	timecounter_init(&cpts->tc, ns);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	return 0;
@@ -447,7 +447,7 @@ int cpts_register(struct cpts *cpts)
 	cpts_write32(cpts, CPTS_EN, control);
 	cpts_write32(cpts, TS_PEND_EN, int_enable);
 
-	timecounter_init(&cpts->tc, &cpts->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&cpts->tc, ktime_to_ns(ktime_get_real()));
 
 	cpts->clock = ptp_clock_register(&cpts->info, cpts->dev);
 	if (IS_ERR(cpts->clock)) {
@@ -486,6 +486,7 @@ void cpts_unregister(struct cpts *cpts)
 
 static void cpts_calc_mult_shift(struct cpts *cpts)
 {
+	struct cyclecounter *cc = &cpts->tc.cc;
 	u64 frac, maxsec, ns;
 	u32 freq;
 
@@ -494,7 +495,7 @@ static void cpts_calc_mult_shift(struct cpts *cpts)
 	/* Calc the maximum number of seconds which we can run before
 	 * wrapping around.
 	 */
-	maxsec = cpts->cc.mask;
+	maxsec = cc->mask;
 	do_div(maxsec, freq);
 	/* limit conversation rate to 10 sec as higher values will produce
 	 * too small mult factors and so reduce the conversion accuracy
@@ -507,18 +508,19 @@ static void cpts_calc_mult_shift(struct cpts *cpts)
 	dev_info(cpts->dev, "cpts: overflow check period %lu (jiffies)\n",
 		 cpts->ov_check_period);
 
-	if (cpts->cc.mult || cpts->cc.shift)
+	if (cc->mult || cc->shift)
 		return;
 
-	clocks_calc_mult_shift(&cpts->cc.mult, &cpts->cc.shift,
+	clocks_calc_mult_shift(&cc->mult, &cc->shift,
 			       freq, NSEC_PER_SEC, maxsec);
 
 	frac = 0;
-	ns = cyclecounter_cyc2ns(&cpts->cc, freq, cpts->cc.mask, &frac);
+	ns = cyclecounter_cyc2ns(cc, freq, cc->mask, &frac);
 
 	dev_info(cpts->dev,
 		 "CPTS: ref_clk_freq:%u calc_mult:%u calc_shift:%u error:%lld nsec/sec\n",
-		 freq, cpts->cc.mult, cpts->cc.shift, (ns - NSEC_PER_SEC));
+		 freq, cc->mult, cc->shift,
+		 (ns - NSEC_PER_SEC));
 }
 
 static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
@@ -527,13 +529,13 @@ static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 	u32 prop;
 
 	if (!of_property_read_u32(node, "cpts_clock_mult", &prop))
-		cpts->cc.mult = prop;
+		cpts->tc.cc.mult = prop;
 
 	if (!of_property_read_u32(node, "cpts_clock_shift", &prop))
-		cpts->cc.shift = prop;
+		cpts->tc.cc.shift = prop;
 
-	if ((cpts->cc.mult && !cpts->cc.shift) ||
-	    (!cpts->cc.mult && cpts->cc.shift))
+	if ((cpts->tc.cc.mult && !cpts->tc.cc.shift) ||
+	    (!cpts->tc.cc.mult && cpts->tc.cc.shift))
 		goto of_error;
 
 	return 0;
@@ -569,15 +571,15 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	clk_prepare(cpts->refclk);
 
-	cpts->cc.read = cpts_systim_read;
-	cpts->cc.mask = CLOCKSOURCE_MASK(32);
+	cpts->tc.cc.read = cpts_systim_read;
+	cpts->tc.cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
 
 	cpts_calc_mult_shift(cpts);
-	/* save cc.mult original value as it can be modified
+	/* save tc.cc.mult original value as it can be modified
 	 * by cpts_ptp_adjfreq().
 	 */
-	cpts->cc_mult = cpts->cc.mult;
+	cpts->cc_mult = cpts->tc.cc.mult;
 
 	return cpts;
 }
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 73d73fa..a7174eb 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -117,7 +117,6 @@ struct cpts {
 	struct ptp_clock *clock;
 	spinlock_t lock; /* protects time registers */
 	u32 cc_mult; /* for the nominal frequency */
-	struct cyclecounter cc;
 	struct timecounter tc;
 	int phc_index;
 	struct clk *refclk;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a886b51..c81c615 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -780,7 +780,6 @@ struct mlx5_pps {
 
 struct mlx5_clock {
 	rwlock_t                   lock;
-	struct cyclecounter        cycles;
 	struct timecounter         tc;
 	struct hwtstamp_config     hwtstamp_config;
 	u32                        nominal_c_mult;
diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
index 2496ad4..6daca06 100644
--- a/include/linux/timecounter.h
+++ b/include/linux/timecounter.h
@@ -62,7 +62,7 @@ struct cyclecounter {
  * @frac:		accumulated fractional nanoseconds
  */
 struct timecounter {
-	const struct cyclecounter *cc;
+	struct cyclecounter cc;
 	u64 cycle_last;
 	u64 nsec;
 	u64 mask;
@@ -98,7 +98,6 @@ static inline void timecounter_adjtime(struct timecounter *tc, s64 delta)
 /**
  * timecounter_init - initialize a time counter
  * @tc:			Pointer to time counter which is to be initialized/reset
- * @cc:			A cycle counter, ready to be used.
  * @start_tstamp:	Arbitrary initial time stamp.
  *
  * After this call the current cycle register (roughly) corresponds to
@@ -106,7 +105,6 @@ static inline void timecounter_adjtime(struct timecounter *tc, s64 delta)
  * the time stamp counter by the number of elapsed nanoseconds.
  */
 extern void timecounter_init(struct timecounter *tc,
-			     const struct cyclecounter *cc,
 			     u64 start_tstamp);
 
 /**
diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 68169e3..3061f44 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -445,7 +445,6 @@ struct hdac_stream {
 	unsigned long start_wallclk;	/* start + minimum wallclk */
 	unsigned long period_wallclk;	/* wallclk for period */
 	struct timecounter  tc;
-	struct cyclecounter cc;
 	int delay_negative_threshold;
 
 	struct list_head list;
diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
index 8afd789..7919acb 100644
--- a/kernel/time/timecounter.c
+++ b/kernel/time/timecounter.c
@@ -18,11 +18,10 @@
 #include <linux/export.h>
 #include <linux/timecounter.h>
 
-void timecounter_init(struct timecounter *tc,
-		      const struct cyclecounter *cc,
-		      u64 start_tstamp)
+void timecounter_init(struct timecounter *tc, u64 start_tstamp)
 {
-	tc->cc = cc;
+	struct cyclecounter *cc = &tc->cc;
+
 	tc->cycle_last = cc->read(cc);
 	tc->nsec = start_tstamp;
 	tc->mask = (1ULL << cc->shift) - 1;
@@ -43,17 +42,18 @@ void timecounter_init(struct timecounter *tc,
  */
 static u64 timecounter_read_delta(struct timecounter *tc)
 {
+	struct cyclecounter *cc = &tc->cc;
 	u64 cycle_now, cycle_delta;
 	u64 ns_offset;
 
 	/* read cycle counter: */
-	cycle_now = tc->cc->read(tc->cc);
+	cycle_now = cc->read(cc);
 
 	/* calculate the delta since the last timecounter_read_delta(): */
-	cycle_delta = (cycle_now - tc->cycle_last) & tc->cc->mask;
+	cycle_delta = (cycle_now - tc->cycle_last) & cc->mask;
 
 	/* convert to nanoseconds: */
-	ns_offset = cyclecounter_cyc2ns(tc->cc, cycle_delta,
+	ns_offset = cyclecounter_cyc2ns(cc, cycle_delta,
 					tc->mask, &tc->frac);
 
 	/* update time stamp of timecounter_read_delta() call: */
@@ -89,10 +89,10 @@ static u64 cc_cyc2ns_backwards(const struct cyclecounter *cc,
 	return ns;
 }
 
-u64 timecounter_cyc2time(struct timecounter *tc,
-			 u64 cycle_tstamp)
+u64 timecounter_cyc2time(struct timecounter *tc, u64 cycle_tstamp)
 {
-	u64 delta = (cycle_tstamp - tc->cycle_last) & tc->cc->mask;
+	struct cyclecounter *cc = &tc->cc;
+	u64 delta = (cycle_tstamp - tc->cycle_last) & cc->mask;
 	u64 nsec = tc->nsec, frac = tc->frac;
 
 	/*
@@ -100,11 +100,11 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 	 * than tc->cycle_last, detect when it is too far in the
 	 * future and treat it as old time stamp instead.
 	 */
-	if (delta > tc->cc->mask / 2) {
-		delta = (tc->cycle_last - cycle_tstamp) & tc->cc->mask;
-		nsec -= cc_cyc2ns_backwards(tc->cc, delta, tc->mask, frac);
+	if (delta > cc->mask / 2) {
+		delta = (tc->cycle_last - cycle_tstamp) & cc->mask;
+		nsec -= cc_cyc2ns_backwards(cc, delta, tc->mask, frac);
 	} else {
-		nsec += cyclecounter_cyc2ns(tc->cc, delta, tc->mask, &frac);
+		nsec += cyclecounter_cyc2ns(cc, delta, tc->mask, &frac);
 	}
 
 	return nsec;
diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index e1472c7..9426c1a 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -467,7 +467,8 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 
 static u64 azx_cc_read(const struct cyclecounter *cc)
 {
-	struct hdac_stream *azx_dev = container_of(cc, struct hdac_stream, cc);
+	struct hdac_stream *azx_dev = container_of(cc, struct hdac_stream,
+						   tc.cc);
 
 	return snd_hdac_chip_readl(azx_dev->bus, WALLCLK);
 }
@@ -476,7 +477,7 @@ static void azx_timecounter_init(struct hdac_stream *azx_dev,
 				 bool force, u64 last)
 {
 	struct timecounter *tc = &azx_dev->tc;
-	struct cyclecounter *cc = &azx_dev->cc;
+	struct cyclecounter *cc = &azx_dev->tc.cc;
 	u64 nsec;
 
 	cc->read = azx_cc_read;
@@ -496,7 +497,7 @@ static void azx_timecounter_init(struct hdac_stream *azx_dev,
 	cc->shift = 0;
 
 	nsec = 0; /* audio time is elapsed time since trigger */
-	timecounter_init(tc, cc, nsec);
+	timecounter_init(tc, nsec);
 	if (force) {
 		/*
 		 * force timecounter to use predefined value,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f9555b1..5683c0c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -53,7 +53,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 
 u64 kvm_phys_timer_read(void)
 {
-	return timecounter->cc->read(timecounter->cc);
+	return timecounter->cc.read(&timecounter->cc);
 }
 
 static void soft_timer_start(struct hrtimer *hrt, u64 ns)
@@ -138,7 +138,7 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 	if (now < cval) {
 		u64 ns;
 
-		ns = cyclecounter_cyc2ns(timecounter->cc,
+		ns = cyclecounter_cyc2ns(&timecounter->cc,
 					 cval - now,
 					 timecounter->mask,
 					 &timecounter->frac);
@@ -728,7 +728,7 @@ int kvm_timer_hyp_init(void)
 	info = arch_timer_get_kvm_info();
 	timecounter = &info->timecounter;
 
-	if (!timecounter->cc) {
+	if (!timecounter->cc.mask) {
 		kvm_err("kvm_arch_timer: uninitialized timecounter\n");
 		return -ENODEV;
 	}
-- 
1.9.1
