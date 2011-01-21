From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Hold link for Tx SERDES settings
Date: Fri, 21 Jan 2011 08:45:17 -0500
Message-ID: <20110121134516.10415.50779.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Hold the IB link at DISABLED until we get the correct TX
settings on mezz boards.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index dbbb0e8..d51124a 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -623,7 +623,6 @@ struct qib_chippport_specific {
 	u8 ibmalfusesnap;
 	struct qib_qsfp_data qsfp_data;
 	char epmsgbuf[192]; /* for port error interrupt msg buffer */
-	u8 bounced;
 };
 
 static struct {
@@ -1881,23 +1880,7 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 		    IB_PHYSPORTSTATE_DISABLED)
 			qib_set_ib_7322_lstate(ppd, 0,
 			       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
-		else {
-			u32 lstate;
-			/*
-			 * We need the current logical link state before
-			 * lflags are set in handle_e_ibstatuschanged.
-			 */
-			lstate = qib_7322_iblink_state(ibcs);
-
-			if (IS_QMH(dd) && !ppd->cpspec->bounced &&
-			    ltstate == IB_PHYSPORTSTATE_LINKUP &&
-			    (lstate >= IB_PORT_INIT &&
-				lstate <= IB_PORT_ACTIVE)) {
-				ppd->cpspec->bounced = 1;
-				qib_7322_set_ib_cfg(ppd, QIB_IB_CFG_LSTATE,
-					IB_LINKCMD_DOWN | IB_LINKINITCMD_POLL);
-			}
-
+		else
 			/*
 			 * Since going into a recovery state causes the link
 			 * state to go down and since recovery is transitory,
@@ -1911,7 +1894,6 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 			    ltstate != IB_PHYSPORTSTATE_RECOVERY_WAITRMT &&
 			    ltstate != IB_PHYSPORTSTATE_RECOVERY_IDLE)
 				qib_handle_e_ibstatuschanged(ppd, ibcs);
-		}
 	}
 	if (*msg && iserr)
 		qib_dev_porterr(dd, ppd->port, "%s error\n", msg);
@@ -2381,6 +2363,11 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_rcvctrl, ppd->p_rcvctrl);
 	spin_unlock_irqrestore(&dd->cspec->rcvmod_lock, flags);
 
+	/* Hold the link state machine for mezz boards */
+	if (IS_QMH(dd) || IS_QME(dd))
+		qib_set_ib_7322_lstate(ppd, 0,
+				       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
+
 	/* Also enable IBSTATUSCHG interrupt.  */
 	val = qib_read_kreg_port(ppd, krp_errmask);
 	qib_write_kreg_port(ppd, krp_errmask,
@@ -5702,6 +5689,11 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 				ppd->cpspec->h1_val = h1;
 			/* now change the IBC and serdes, overriding generic */
 			init_txdds_table(ppd, 1);
+			/* Re-enable the physical state machine on mezz boards
+			 * now that the correct settings have been set. */
+			if (IS_QMH(dd) || IS_QME(dd))
+				qib_set_ib_7322_lstate(ppd, 0,
+					    QLOGIC_IB_IBCC_LINKINITCMD_SLEEP);
 			any++;
 		}
 		if (*nxt == '\n')

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
