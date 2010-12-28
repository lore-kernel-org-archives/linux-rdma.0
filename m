From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 24/24] IB/qib: Improve SERDES tunning on QMH boards
Date: Tue, 28 Dec 2010 10:28:55 -0500
Message-ID: <20101228152855.19960.96651.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Improve the QMH SERDES tunning on initial driver load by
removing the delay after SERDES init and having the driver
go through a link state change.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 0ab4b72..dbbb0e8 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -623,6 +623,7 @@ struct qib_chippport_specific {
 	u8 ibmalfusesnap;
 	struct qib_qsfp_data qsfp_data;
 	char epmsgbuf[192]; /* for port error interrupt msg buffer */
+	u8 bounced;
 };
 
 static struct {
@@ -1742,6 +1743,8 @@ static void handle_serdes_issues(struct qib_pportdata *ppd, u64 ibcst)
 	}
 }
 
+static int qib_7322_set_ib_cfg(struct qib_pportdata *, int, u32);
+
 /*
  * This is per-pport error handling.
  * will likely get it's own MSIx interrupt (one for each port,
@@ -1878,7 +1881,23 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 		    IB_PHYSPORTSTATE_DISABLED)
 			qib_set_ib_7322_lstate(ppd, 0,
 			       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
-		else
+		else {
+			u32 lstate;
+			/*
+			 * We need the current logical link state before
+			 * lflags are set in handle_e_ibstatuschanged.
+			 */
+			lstate = qib_7322_iblink_state(ibcs);
+
+			if (IS_QMH(dd) && !ppd->cpspec->bounced &&
+			    ltstate == IB_PHYSPORTSTATE_LINKUP &&
+			    (lstate >= IB_PORT_INIT &&
+				lstate <= IB_PORT_ACTIVE)) {
+				ppd->cpspec->bounced = 1;
+				qib_7322_set_ib_cfg(ppd, QIB_IB_CFG_LSTATE,
+					IB_LINKCMD_DOWN | IB_LINKINITCMD_POLL);
+			}
+
 			/*
 			 * Since going into a recovery state causes the link
 			 * state to go down and since recovery is transitory,
@@ -1892,6 +1911,7 @@ static noinline void handle_7322_p_errors(struct qib_pportdata *ppd)
 			    ltstate != IB_PHYSPORTSTATE_RECOVERY_WAITRMT &&
 			    ltstate != IB_PHYSPORTSTATE_RECOVERY_IDLE)
 				qib_handle_e_ibstatuschanged(ppd, ibcs);
+		}
 	}
 	if (*msg && iserr)
 		qib_dev_porterr(dd, ppd->port, "%s error\n", msg);
@@ -7282,8 +7302,8 @@ static void ibsd_wr_allchans(struct qib_pportdata *ppd, int addr, unsigned data,
 static void serdes_7322_los_enable(struct qib_pportdata *ppd, int enable)
 {
 	u64 data = qib_read_kreg_port(ppd, krp_serdesctrl);
-	printk(KERN_INFO QIB_DRV_NAME " Turning LOS %s for port %d\n",
-		 (enable ? "on" : "off"), ppd->port);
+	printk(KERN_INFO QIB_DRV_NAME " IB%u:%u Turning LOS %s\n",
+		ppd->dd->unit, ppd->port, (enable ? "on" : "off"));
 	if (enable)
 		data |= SYM_MASK(IBSerdesCtrl_0, RXLOSEN);
 	else
@@ -7596,8 +7616,6 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	/* VGA output common mode */
 	ibsd_wr_allchans(ppd, 12, (3 << 2), BMASK(3, 2));
 
-	/* Add a delay to allow the SERDES to init */
-	msleep(3000);
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
