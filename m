From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Eliminate schedule_work
Date: Tue, 8 Nov 2011 13:27:31 -0500
Message-ID: <20111108182731.31923.40944.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It was mistakenly introduced by
dde05cbdf8b1c404344c370fe6e18ff160d6da6a.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 231383c..6ae6966 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5287,7 +5287,7 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 			   off */
 			if (ppd->dd->flags & QIB_HAS_QSFP) {
 				qd->t_insert = get_jiffies_64();
-				schedule_work(&qd->work);
+				queue_work(ib_wq, &qd->work);
 			}
 			spin_lock_irqsave(&ppd->sdma_lock, flags);
 			if (__qib_sdma_running(ppd))


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
