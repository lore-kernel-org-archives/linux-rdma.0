From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/9] IB/hfi1: Modify handling of physical link
 state by Host Driver
Date: Mon, 29 May 2017 17:21:32 -0700
Message-ID: <20170530002058.534.43492.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kotlowski <andrzej.kotlowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Byczkowski, Jakub <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Ensure states returned to the Fabric Manager are consistent with
the OPA specification by caching the physical state along with the
logical state.

Reviewed-by: Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Andrzej Kotlowski <andrzej.kotlowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c   |  102 ++++++++++++++++++++++++-----------
 drivers/infiniband/hw/hfi1/chip.h   |    2 -
 drivers/infiniband/hw/hfi1/driver.c |    8 ++-
 drivers/infiniband/hw/hfi1/hfi.h    |   18 ++++++
 drivers/infiniband/hw/hfi1/mad.c    |    6 +-
 drivers/infiniband/hw/hfi1/verbs.c  |    2 -
 6 files changed, 97 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 619ce0b..5dbf2ec 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1066,6 +1066,8 @@ static int do_8051_command(struct hfi1_devdata *dd, u32 type, u64 in_data,
 
 static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 				  int msecs);
+static int wait_physical_linkstate(struct hfi1_pportdata *ppd, u32 state,
+				   int msecs);
 static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc);
 static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
@@ -10028,28 +10030,6 @@ static void set_lidlmc(struct hfi1_pportdata *ppd)
 	sdma_update_lmc(dd, mask, ppd->lid);
 }
 
-static int wait_phy_linkstate(struct hfi1_devdata *dd, u32 state, u32 msecs)
-{
-	unsigned long timeout;
-	u32 curr_state;
-
-	timeout = jiffies + msecs_to_jiffies(msecs);
-	while (1) {
-		curr_state = read_physical_state(dd);
-		if (curr_state == state)
-			break;
-		if (time_after(jiffies, timeout)) {
-			dd_dev_err(dd,
-				   "timeout waiting for phy link state 0x%x, current state is 0x%x\n",
-				   state, curr_state);
-			return -ETIMEDOUT;
-		}
-		usleep_range(1950, 2050); /* sleep 2ms-ish */
-	}
-
-	return 0;
-}
-
 static const char *state_completed_string(u32 completed)
 {
 	static const char * const state_completed[] = {
@@ -10283,7 +10263,7 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 
 	if (do_wait) {
 		/* it can take a while for the link to go down */
-		ret = wait_phy_linkstate(dd, PLS_OFFLINE, 10000);
+		ret = wait_physical_linkstate(ppd, PLS_OFFLINE, 10000);
 		if (ret < 0)
 			return ret;
 	}
@@ -10536,6 +10516,19 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			goto unexpected;
 		}
 
+		/*
+		 * Wait for Link_Up physical state.
+		 * Physical and Logical states should already be
+		 * be transitioned to LinkUp and LinkInit respectively.
+		 */
+		ret = wait_physical_linkstate(ppd, PLS_LINKUP, 1000);
+		if (ret) {
+			dd_dev_err(dd,
+				   "%s: physical state did not change to LINK-UP\n",
+				   __func__);
+			break;
+		}
+
 		ret = wait_logical_linkstate(ppd, IB_PORT_INIT, 1000);
 		if (ret) {
 			dd_dev_err(dd,
@@ -10649,6 +10642,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		 */
 		if (ret)
 			goto_offline(ppd, 0);
+		else
+			cache_physical_state(ppd);
 		break;
 	case HLS_DN_DISABLE:
 		/* link is disabled */
@@ -10673,6 +10668,13 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 				ret = -EINVAL;
 				break;
 			}
+			ret = wait_physical_linkstate(ppd, PLS_DISABLED, 10000);
+			if (ret) {
+				dd_dev_err(dd,
+					   "%s: physical state did not change to DISABLED\n",
+					   __func__);
+				break;
+			}
 			dc_shutdown(dd);
 		}
 		ppd->host_link_state = HLS_DN_DISABLE;
@@ -10690,6 +10692,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		if (ppd->host_link_state != HLS_DN_POLL)
 			goto unexpected;
 		ppd->host_link_state = HLS_VERIFY_CAP;
+		cache_physical_state(ppd);
 		break;
 	case HLS_GOING_UP:
 		if (ppd->host_link_state != HLS_VERIFY_CAP)
@@ -12663,21 +12666,56 @@ static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 	return -ETIMEDOUT;
 }
 
-u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
+/*
+ * Read the physical hardware link state and set the driver's cached value
+ * of it.
+ */
+void cache_physical_state(struct hfi1_pportdata *ppd)
 {
-	u32 pstate;
+	u32 read_pstate;
 	u32 ib_pstate;
 
-	pstate = read_physical_state(ppd->dd);
-	ib_pstate = chip_to_opa_pstate(ppd->dd, pstate);
-	if (ppd->last_pstate != ib_pstate) {
+	read_pstate = read_physical_state(ppd->dd);
+	ib_pstate = chip_to_opa_pstate(ppd->dd, read_pstate);
+	/* check if OPA pstate changed */
+	if (chip_to_opa_pstate(ppd->dd, ppd->pstate) != ib_pstate) {
 		dd_dev_info(ppd->dd,
 			    "%s: physical state changed to %s (0x%x), phy 0x%x\n",
 			    __func__, opa_pstate_name(ib_pstate), ib_pstate,
-			    pstate);
-		ppd->last_pstate = ib_pstate;
+			    read_pstate);
+	}
+	ppd->pstate = read_pstate;
+}
+
+/*
+ * wait_physical_linkstate - wait for an physical link state change to occur
+ * @ppd: port device
+ * @state: the state to wait for
+ * @msecs: the number of milliseconds to wait
+ *
+ * Wait up to msecs milliseconds for physical link state change to occur.
+ * Returns 0 if state reached, otherwise -ETIMEDOUT.
+ */
+static int wait_physical_linkstate(struct hfi1_pportdata *ppd, u32 state,
+				   int msecs)
+{
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(msecs);
+	while (1) {
+		cache_physical_state(ppd);
+		if (ppd->pstate == state)
+			break;
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(ppd->dd,
+				   "timeout waiting for phy link state 0x%x, current state is 0x%x\n",
+				   state, ppd->pstate);
+			return -ETIMEDOUT;
+		}
+		usleep_range(1950, 2050); /* sleep 2ms-ish */
 	}
-	return ib_pstate;
+
+	return 0;
 }
 
 #define CLEAR_STATIC_RATE_CONTROL_SMASK(r) \
@@ -14781,7 +14819,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		/* start in offline */
 		ppd->host_link_state = HLS_DN_OFFLINE;
 		init_vl_arb_caches(ppd);
-		ppd->last_pstate = 0xff; /* invalid value */
+		ppd->pstate = PLS_OFFLINE;
 	}
 
 	dd->link_default = HLS_DN_POLL;
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 0b4f418..3dab315 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -744,6 +744,7 @@ void update_usrhead(struct hfi1_ctxtdata *rcd, u32 hd, u32 updegr, u32 egrhd,
 u32 read_physical_state(struct hfi1_devdata *dd);
 u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate);
 u32 get_logical_state(struct hfi1_pportdata *ppd);
+void cache_physical_state(struct hfi1_pportdata *ppd);
 const char *opa_lstate_name(u32 lstate);
 const char *opa_pstate_name(u32 pstate);
 u32 driver_physical_state(struct hfi1_pportdata *ppd);
@@ -1354,7 +1355,6 @@ void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 void hfi1_rcvctrl(struct hfi1_devdata *dd, unsigned int op, int ctxt);
 u32 hfi1_read_cntrs(struct hfi1_devdata *dd, char **namep, u64 **cntrp);
 u32 hfi1_read_portcntrs(struct hfi1_pportdata *ppd, char **namep, u64 **cntrp);
-u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd);
 int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which);
 int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val);
 int hfi1_set_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt, u16 jkey);
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 9e59430..e64e9e2 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -906,10 +906,12 @@ static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
 		sc = hfi1_9B_get_sc5(hdr, packet->rhf);
 	}
 	if (sc != SC15_PACKET) {
-		int hwstate = read_logical_state(dd);
+		int hwstate = driver_lstate(rcd->ppd);
 
-		if (hwstate != LSTATE_ACTIVE) {
-			dd_dev_info(dd, "Unexpected link state %d\n", hwstate);
+		if (hwstate != IB_PORT_ACTIVE) {
+			dd_dev_info(dd,
+				    "Unexpected link state %s\n",
+				    opa_lstate_name(hwstate));
 			return 0;
 		}
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index e1cd468..4242e45 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -663,7 +663,7 @@ struct hfi1_pportdata {
 	u8 link_enabled;	/* link enabled? */
 	u8 linkinit_reason;
 	u8 local_tx_rate;	/* rate given to 8051 firmware */
-	u8 last_pstate;		/* info only */
+	u8 pstate;		/* info only */
 	u8 qsfp_retry_count;
 
 	/* placeholders for IB MAD packet settings */
@@ -1330,6 +1330,22 @@ static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 		return ppd->lstate;
 }
 
+/* return the driver's idea of the physical OPA port state */
+static inline u32 driver_pstate(struct hfi1_pportdata *ppd)
+{
+	/*
+	 * The driver does some processing from the time the physical
+	 * link state is at LINKUP to the time the SM can be notified
+	 * as such. Return IB_PORTPHYSSTATE_TRAINING until the software
+	 * state is ready.
+	 */
+	if (ppd->pstate == PLS_LINKUP &&
+	    !(ppd->host_link_state & HLS_UP))
+		return IB_PORTPHYSSTATE_TRAINING;
+	else
+		return chip_to_opa_pstate(ppd->dd, ppd->pstate);
+}
+
 void receive_interrupt_work(struct work_struct *work);
 
 /* extract service channel from header and rhf */
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index b180dff..c8daf63 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -113,7 +113,7 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 		return;
 
 	/* o14-3.2.1 */
-	if (ppd_from_ibp(ibp)->lstate != IB_PORT_ACTIVE)
+	if (driver_lstate(ppd_from_ibp(ibp)) != IB_PORT_ACTIVE)
 		return;
 
 	/* o14-2 */
@@ -615,7 +615,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 		ppd->offline_disabled_reason;
 
 	pi->port_states.portphysstate_portstate =
-		(hfi1_ibphys_portstate(ppd) << 4) | state;
+		(driver_pstate(ppd) << 4) | state;
 
 	pi->mkeyprotect_lmc = (ibp->rvp.mkeyprot << 6) | ppd->lmc;
 
@@ -1791,7 +1791,7 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 		ppd->offline_disabled_reason;
 
 	psi->port_states.portphysstate_portstate =
-		(hfi1_ibphys_portstate(ppd) << 4) | (lstate & 0xf);
+		(driver_pstate(ppd) << 4) | (lstate & 0xf);
 	psi->link_width_downgrade_tx_active =
 		cpu_to_be16(ppd->link_width_downgrade_tx_active);
 	psi->link_width_downgrade_rx_active =
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 2881798..8a63a7e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1354,7 +1354,7 @@ static int query_port(struct rvt_dev_info *rdi, u8 port_num,
 	props->lmc = ppd->lmc;
 	/* OPA logical states match IB logical states */
 	props->state = driver_lstate(ppd);
-	props->phys_state = hfi1_ibphys_portstate(ppd);
+	props->phys_state = driver_pstate(ppd);
 	props->gid_tbl_len = HFI1_GUIDS_PER_PORT;
 	props->active_width = (u8)opa_width_to_ib(ppd->link_width_active);
 	/* see rate_show() in ib core/sysfs.c */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
