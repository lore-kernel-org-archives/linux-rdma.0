From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/20] IB/hfi1: Force logical link down
Date: Wed, 01 Mar 2017 10:21:20 -0800
Message-ID: <20170301182112.29989.63937.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the logical link state does not read as down when
the physical link state is offline, force it to down.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   86 +++++++++++++++++++++++++++++--------
 1 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 121a4c9..44322c6 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1045,6 +1045,7 @@ static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
+static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms);
 
 /*
  * Error interrupt table entry.  This is used as input to the interrupt
@@ -8891,8 +8892,6 @@ int send_idle_sma(struct hfi1_devdata *dd, u64 message)
  */
 static int do_quick_linkup(struct hfi1_devdata *dd)
 {
-	u64 reg;
-	unsigned long timeout;
 	int ret;
 
 	lcb_shutdown(dd, 0);
@@ -8915,19 +8914,9 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
 		write_csr(dd, DC_LCB_CFG_RUN,
 			  1ull << DC_LCB_CFG_RUN_EN_SHIFT);
 
-		/* watch LCB_STS_LINK_TRANSFER_ACTIVE */
-		timeout = jiffies + msecs_to_jiffies(10);
-		while (1) {
-			reg = read_csr(dd, DC_LCB_STS_LINK_TRANSFER_ACTIVE);
-			if (reg)
-				break;
-			if (time_after(jiffies, timeout)) {
-				dd_dev_err(dd,
-					   "timeout waiting for LINK_TRANSFER_ACTIVE\n");
-				return -ETIMEDOUT;
-			}
-			udelay(2);
-		}
+		ret = wait_link_transfer_active(dd, 10);
+		if (ret)
+			return ret;
 
 		write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP,
 			  1ull << DC_LCB_CFG_ALLOW_LINK_UP_VAL_SHIFT);
@@ -10082,6 +10071,64 @@ static void check_lni_states(struct hfi1_pportdata *ppd)
 	decode_state_complete(ppd, last_remote_state, "received");
 }
 
+/* wait for wait_ms for LINK_TRANSFER_ACTIVE to go to 1 */
+static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms)
+{
+	u64 reg;
+	unsigned long timeout;
+
+	/* watch LCB_STS_LINK_TRANSFER_ACTIVE */
+	timeout = jiffies + msecs_to_jiffies(wait_ms);
+	while (1) {
+		reg = read_csr(dd, DC_LCB_STS_LINK_TRANSFER_ACTIVE);
+		if (reg)
+			break;
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(dd,
+				   "timeout waiting for LINK_TRANSFER_ACTIVE\n");
+			return -ETIMEDOUT;
+		}
+		udelay(2);
+	}
+	return 0;
+}
+
+/* called when the logical link state is not down as it should be */
+static void force_logical_link_state_down(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	/*
+	 * Bring link up in LCB loopback
+	 */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 1);
+	write_csr(dd, DC_LCB_CFG_IGNORE_LOST_RCLK,
+		  DC_LCB_CFG_IGNORE_LOST_RCLK_EN_SMASK);
+
+	write_csr(dd, DC_LCB_CFG_LANE_WIDTH, 0);
+	write_csr(dd, DC_LCB_CFG_REINIT_AS_SLAVE, 0);
+	write_csr(dd, DC_LCB_CFG_CNT_FOR_SKIP_STALL, 0x110);
+	write_csr(dd, DC_LCB_CFG_LOOPBACK, 0x2);
+
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0);
+	(void)read_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET);
+	udelay(3);
+	write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP, 1);
+	write_csr(dd, DC_LCB_CFG_RUN, 1ull << DC_LCB_CFG_RUN_EN_SHIFT);
+
+	wait_link_transfer_active(dd, 100);
+
+	/*
+	 * Bring the link down again.
+	 */
+	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 1);
+	write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP, 0);
+	write_csr(dd, DC_LCB_CFG_IGNORE_LOST_RCLK, 0);
+
+	/* call again to adjust ppd->statusp, if needed */
+	get_logical_state(ppd);
+}
+
 /*
  * Helper for set_link_state().  Do not call except from that routine.
  * Expects ppd->hls_mutex to be held.
@@ -10135,15 +10182,18 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 			return ret;
 	}
 
-	/* make sure the logical state is also down */
-	wait_logical_linkstate(ppd, IB_PORT_DOWN, 1000);
-
 	/*
 	 * Now in charge of LCB - must be after the physical state is
 	 * offline.quiet and before host_link_state is changed.
 	 */
 	set_host_lcb_access(dd);
 	write_csr(dd, DC_LCB_ERR_EN, ~0ull); /* watch LCB errors */
+
+	/* make sure the logical state is also down */
+	ret = wait_logical_linkstate(ppd, IB_PORT_DOWN, 1000);
+	if (ret)
+		force_logical_link_state_down(ppd);
+
 	ppd->host_link_state = HLS_LINK_COOLDOWN; /* LCB access allowed */
 
 	if (ppd->port_type == PORT_TYPE_QSFP &&

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
