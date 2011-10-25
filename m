From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Fix kernel panic on QME7342 boards
Date: Tue, 25 Oct 2011 12:42:07 -0400
Message-ID: <20111025164207.31124.13380.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Fix a kernel panic on QME7342 (and any Mezz boards without
QSFP connectors) caused by scheduling work on uninitialized
workqueue introduced by 62066fc8df4632c772d723813ce7af456d62ddf7.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 62005c7..3e40cff 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5285,8 +5285,10 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 			qib_7322_mini_pcs_reset(ppd);
 			/* schedule the qsfp refresh which should turn the link
 			   off */
-			qd->t_insert = get_jiffies_64();
-			schedule_work(&qd->work);
+			if (ppd->dd->flags & QIB_HAS_QSFP) {
+				qd->t_insert = get_jiffies_64();
+				schedule_work(&qd->work);
+			}
 			spin_lock_irqsave(&ppd->sdma_lock, flags);
 			if (__qib_sdma_running(ppd))
 				__qib_sdma_process_event(ppd,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
