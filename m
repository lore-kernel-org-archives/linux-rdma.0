From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Ensure that LOS and DFE are being turned off
Date: Thu, 09 Jun 2011 16:27:26 -0400
Message-ID: <20110609202726.11464.58179.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Due to timing, it is possible for the LOS and DFE to remain
on. This is due to the link progressing to LinkUP prior to
the driver getting the first Status Changed interrupt.
By expanding the conditions under which LOS is turned off
and DFE timeout is being set, timing is no longer an issue.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   25 ++++++++++++++++++-------
 drivers/infiniband/hw/qib/qib_intr.c    |    6 +++++-
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 8f0e506..4df08b8 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -469,6 +469,8 @@ static u8 ib_rate_to_delay[IB_RATE_120_GBPS + 1] = {
 #define IB_7322_LT_STATE_RECOVERIDLE     0x0f
 #define IB_7322_LT_STATE_CFGENH          0x10
 #define IB_7322_LT_STATE_CFGTEST         0x11
+#define IB_7322_LT_STATE_CFGWAITRMTTEST  0x12
+#define IB_7322_LT_STATE_CFGWAITENH      0x13
 
 /* link state machine states from IBC */
 #define IB_7322_L_STATE_DOWN             0x0
@@ -498,8 +500,10 @@ static const u8 qib_7322_physportstate[0x20] = {
 		IB_PHYSPORTSTATE_LINK_ERR_RECOVER,
 	[IB_7322_LT_STATE_CFGENH] = IB_PHYSPORTSTATE_CFG_ENH,
 	[IB_7322_LT_STATE_CFGTEST] = IB_PHYSPORTSTATE_CFG_TRAIN,
-	[0x12] = IB_PHYSPORTSTATE_CFG_TRAIN,
-	[0x13] = IB_PHYSPORTSTATE_CFG_WAIT_ENH,
+	[IB_7322_LT_STATE_CFGWAITRMTTEST] =
+		IB_PHYSPORTSTATE_CFG_TRAIN,
+	[IB_7322_LT_STATE_CFGWAITENH] =
+		IB_PHYSPORTSTATE_CFG_WAIT_ENH,
 	[0x14] = IB_PHYSPORTSTATE_CFG_TRAIN,
 	[0x15] = IB_PHYSPORTSTATE_CFG_TRAIN,
 	[0x16] = IB_PHYSPORTSTATE_CFG_TRAIN,
@@ -1692,7 +1696,9 @@ static void handle_serdes_issues(struct qib_pportdata *ppd, u64 ibcst)
 		break;
 	}
 
-	if (ibclt == IB_7322_LT_STATE_CFGTEST &&
+	if (((ibclt >= IB_7322_LT_STATE_CFGTEST &&
+	      ibclt <= IB_7322_LT_STATE_CFGWAITENH) ||
+	     ibclt == IB_7322_LT_STATE_LINKUP) &&
 	    (ibcst & SYM_MASK(IBCStatusA_0, LinkSpeedQDR))) {
 		force_h1(ppd);
 		ppd->cpspec->qdr_reforce = 1;
@@ -7301,12 +7307,17 @@ static void ibsd_wr_allchans(struct qib_pportdata *ppd, int addr, unsigned data,
 static void serdes_7322_los_enable(struct qib_pportdata *ppd, int enable)
 {
 	u64 data = qib_read_kreg_port(ppd, krp_serdesctrl);
-	printk(KERN_INFO QIB_DRV_NAME " IB%u:%u Turning LOS %s\n",
-		ppd->dd->unit, ppd->port, (enable ? "on" : "off"));
-	if (enable)
+	u8 state = SYM_FIELD(data, IBSerdesCtrl_0, RXLOSEN);
+
+	if (enable && !state) {
+		printk(KERN_INFO QIB_DRV_NAME " IB%u:%u Turning LOS on\n",
+			ppd->dd->unit, ppd->port);
 		data |= SYM_MASK(IBSerdesCtrl_0, RXLOSEN);
-	else
+	} else if (!enable && state) {
+		printk(KERN_INFO QIB_DRV_NAME " IB%u:%u Turning LOS off\n",
+			ppd->dd->unit, ppd->port);
 		data &= ~SYM_MASK(IBSerdesCtrl_0, RXLOSEN);
+	}
 	qib_write_kreg_port(ppd, krp_serdesctrl, data);
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_intr.c b/drivers/infiniband/hw/qib/qib_intr.c
index a693c56..6ae57d2 100644
--- a/drivers/infiniband/hw/qib/qib_intr.c
+++ b/drivers/infiniband/hw/qib/qib_intr.c
@@ -96,8 +96,12 @@ void qib_handle_e_ibstatuschanged(struct qib_pportdata *ppd, u64 ibcs)
 	 * states, or if it transitions from any of the up (INIT or better)
 	 * states into any of the down states (except link recovery), then
 	 * call the chip-specific code to take appropriate actions.
+	 *
+	 * ppd->lflags could be 0 if this is the first time the interrupt
+	 * handlers has been called but the link is already up.
 	 */
-	if (lstate >= IB_PORT_INIT && (ppd->lflags & QIBL_LINKDOWN) &&
+	if (lstate >= IB_PORT_INIT &&
+	    (!ppd->lflags || (ppd->lflags & QIBL_LINKDOWN)) &&
 	    ltstate == IB_PHYSPORTSTATE_LINKUP) {
 		/* transitioned to UP */
 		if (dd->f_ib_updown(ppd, 1, ibcs))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
