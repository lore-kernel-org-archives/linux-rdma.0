From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/10] IB/hfi1: Fix PIO wakeup timing hole
Date: Mon, 07 Mar 2016 11:35:30 -0800
Message-ID: <20160307193529.4913.89600.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a timing hole if there had been greater than
PIO_WAIT_BATCH_SIZE waiters.  This code will dispatch the first
batch but leave the others in the queue.   If the restarted waiters
don't in turn wait on a buffer, there is a hang.

Fix by forcing a return when the QP queue is non-empty.

Reviewed-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index e888e21..c6849ce 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1545,7 +1545,7 @@ static void sc_piobufavail(struct send_context *sc)
 		struct iowait *wait;
 
 		if (n == ARRAY_SIZE(qps))
-			goto full;
+			break;
 		wait = list_first_entry(list, struct iowait, list);
 		qp = iowait_to_qp(wait);
 		priv = qp->priv;
@@ -1554,12 +1554,14 @@ static void sc_piobufavail(struct send_context *sc)
 		qps[n++] = qp;
 	}
 	/*
-	 * Counting: only call wantpiobuf_intr() if there were waiters and they
-	 * are now all gone.
+	 * If there had been waiters and there are more
+	 * insure that we redo the force to avoid a potential hang.
 	 */
-	if (n)
+	if (n) {
 		hfi1_sc_wantpiobuf_intr(sc, 0);
-full:
+		if (!list_empty(list))
+			hfi1_sc_wantpiobuf_intr(sc, 1);
+	}
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 
 	for (i = 0; i < n; i++)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
