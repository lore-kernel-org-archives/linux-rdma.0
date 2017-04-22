From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] IB/qib: use setup_timer
Date: Sat, 22 Apr 2017 09:34:51 +0800
Message-ID: <fab42a6b4d20313a8e91a9ce361ddce2ec3ec48d.1491892717.git.geliangtang@gmail.com>
References: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba6120.c | 10 ++++------
 drivers/infiniband/hw/qib/qib_iba7220.c |  5 ++---
 drivers/infiniband/hw/qib/qib_iba7322.c | 10 ++++------
 drivers/infiniband/hw/qib/qib_init.c    | 15 ++++++---------
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 06de1cb..e423b71 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -3295,13 +3295,11 @@ static int init_6120_variables(struct qib_devdata *dd)
 	dd->rhdrhead_intr_off = 1ULL << 32;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	init_timer(&dd->stats_timer);
-	dd->stats_timer.function = qib_get_6120_faststats;
-	dd->stats_timer.data = (unsigned long) dd;
+	setup_timer(&dd->stats_timer, qib_get_6120_faststats,
+		    (unsigned long)dd);
 
-	init_timer(&dd->cspec->pma_timer);
-	dd->cspec->pma_timer.function = pma_6120_timer;
-	dd->cspec->pma_timer.data = (unsigned long) ppd;
+	setup_timer(&dd->cspec->pma_timer, pma_6120_timer,
+		    (unsigned long)ppd);
 
 	dd->ureg_align = qib_read_kreg32(dd, kr_palign);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 55a1838..c3679c4 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -4074,9 +4074,8 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	if (!qib_mini_init)
 		qib_write_kreg(dd, kr_rcvbthqp, QIB_KD_QP);
 
-	init_timer(&ppd->cpspec->chase_timer);
-	ppd->cpspec->chase_timer.function = reenable_7220_chase;
-	ppd->cpspec->chase_timer.data = (unsigned long)ppd;
+	setup_timer(&ppd->cpspec->chase_timer, reenable_7220_chase,
+		    (unsigned long)ppd);
 
 	qib_num_cfg_vls = 1; /* if any 7220's, only one VL */
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index af9f596..bb2439f 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6611,9 +6611,8 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		if (!qib_mini_init)
 			write_7322_init_portregs(ppd);
 
-		init_timer(&cp->chase_timer);
-		cp->chase_timer.function = reenable_chase;
-		cp->chase_timer.data = (unsigned long)ppd;
+		setup_timer(&cp->chase_timer, reenable_chase,
+			    (unsigned long)ppd);
 
 		ppd++;
 	}
@@ -6639,9 +6638,8 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		(u64) rcv_int_count << IBA7322_HDRHEAD_PKTINT_SHIFT;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	init_timer(&dd->stats_timer);
-	dd->stats_timer.function = qib_get_7322_faststats;
-	dd->stats_timer.data = (unsigned long) dd;
+	setup_timer(&dd->stats_timer, qib_get_7322_faststats,
+		    (unsigned long)dd);
 
 	dd->ureg_align = 0x10000;  /* 64KB alignment */
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index b50240b..6c16ba1 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -233,9 +233,8 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 	spin_lock_init(&ppd->cc_shadow_lock);
 	init_waitqueue_head(&ppd->state_wait);
 
-	init_timer(&ppd->symerr_clear_timer);
-	ppd->symerr_clear_timer.function = qib_clear_symerror_on_linkup;
-	ppd->symerr_clear_timer.data = (unsigned long)ppd;
+	setup_timer(&ppd->symerr_clear_timer, qib_clear_symerror_on_linkup,
+		    (unsigned long)ppd);
 
 	ppd->qib_wq = NULL;
 	ppd->ibport_data.pmastats =
@@ -429,9 +428,8 @@ static int loadtime_init(struct qib_devdata *dd)
 	qib_get_eeprom_info(dd);
 
 	/* setup time (don't start yet) to verify we got interrupt */
-	init_timer(&dd->intrchk_timer);
-	dd->intrchk_timer.function = verify_interrupt;
-	dd->intrchk_timer.data = (unsigned long) dd;
+	setup_timer(&dd->intrchk_timer, verify_interrupt,
+		    (unsigned long)dd);
 done:
 	return ret;
 }
@@ -755,9 +753,8 @@ int qib_init(struct qib_devdata *dd, int reinit)
 				continue;
 			if (dd->flags & QIB_HAS_SEND_DMA)
 				ret = qib_setup_sdma(ppd);
-			init_timer(&ppd->hol_timer);
-			ppd->hol_timer.function = qib_hol_event;
-			ppd->hol_timer.data = (unsigned long)ppd;
+			setup_timer(&ppd->hol_timer, qib_hol_event,
+				    (unsigned long)ppd);
 			ppd->hol_state = QIB_HOL_UP;
 		}
 
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
