From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Fix potential deadlock with link down interrupt
Date: Fri, 27 May 2011 09:41:55 -0400
Message-ID: <20110527134155.6579.93811.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

There is a possibility of a deadlock due to the way locks are acquired and
released in qib_set_uevent_bits(). The function qib_set_uevent_bits() is called
in process context calling spin_lock() and spin_unlock() while this same lock
is acquired/released in interrupt context which can lead to a deadlock when
running on the same cpu.

The fix is to replace spin_lock() and spin_unlock() with spin_lock_irqsave()
and spin_unlock_irqrestore() respectively in qib_set_uevent_bits().

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 75bfad1..21be114 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1904,8 +1904,9 @@ int qib_set_uevent_bits(struct qib_pportdata *ppd, const int evtbit)
 	struct qib_ctxtdata *rcd;
 	unsigned ctxt;
 	int ret = 0;
+	unsigned long flags;
 
-	spin_lock(&ppd->dd->uctxt_lock);
+	spin_lock_irqsave(&ppd->dd->uctxt_lock, flags);
 	for (ctxt = ppd->dd->first_user_ctxt; ctxt < ppd->dd->cfgctxts;
 	     ctxt++) {
 		rcd = ppd->dd->rcd[ctxt];
@@ -1924,7 +1925,7 @@ int qib_set_uevent_bits(struct qib_pportdata *ppd, const int evtbit)
 		ret = 1;
 		break;
 	}
-	spin_unlock(&ppd->dd->uctxt_lock);
+	spin_unlock_irqrestore(&ppd->dd->uctxt_lock, flags);
 
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
