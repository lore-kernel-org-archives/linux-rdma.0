From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 6/8] IB/srp: Remove second argument of srp_destroy_qp()
Date: Wed, 11 Oct 2017 10:27:27 -0700
Message-ID: <20171011172729.16984-7-bart.vanassche@wdc.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011172729.16984-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8ceb4bb011f1..96750ad253c4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -464,20 +464,20 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 
 /**
  * srp_destroy_qp() - destroy an RDMA queue pair
- * @qp: RDMA queue pair.
+ * @ch: SRP RDMA channel.
  *
  * Drain the qp before destroying it.  This avoids that the receive
  * completion handler can access the queue pair while it is
  * being destroyed.
  */
-static void srp_destroy_qp(struct srp_rdma_ch *ch, struct ib_qp *qp)
+static void srp_destroy_qp(struct srp_rdma_ch *ch)
 {
 	spin_lock_irq(&ch->lock);
 	ib_process_cq_direct(ch->send_cq, -1);
 	spin_unlock_irq(&ch->lock);
 
-	ib_drain_qp(qp);
-	ib_destroy_qp(qp);
+	ib_drain_qp(ch->qp);
+	ib_destroy_qp(ch->qp);
 }
 
 static int srp_create_ch_ib(struct srp_rdma_ch *ch)
@@ -550,7 +550,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	if (ch->qp)
-		srp_destroy_qp(ch, ch->qp);
+		srp_destroy_qp(ch);
 	if (ch->recv_cq)
 		ib_free_cq(ch->recv_cq);
 	if (ch->send_cq)
@@ -617,7 +617,7 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
 
-	srp_destroy_qp(ch, ch->qp);
+	srp_destroy_qp(ch);
 	ib_free_cq(ch->send_cq);
 	ib_free_cq(ch->recv_cq);
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
