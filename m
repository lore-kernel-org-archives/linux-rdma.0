From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/9] RDMA/nes: In nes_post_send() always set bad_wr on error
Date: Tue, 1 Dec 2009 16:19:44 -0600
Message-ID: <20091201221944.GA8060@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

On error set bad_wr in nes_post_send().  Stop processing ib_wr
queue when an error is detected.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index a680c42..25b52d2 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3386,8 +3386,10 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 	wqe_count = 0;
 	total_payload_length = 0;
 
-	if (nesqp->ibqp_state > IB_QPS_RTS)
-		return -EINVAL;
+	if (nesqp->ibqp_state > IB_QPS_RTS) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	spin_lock_irqsave(&nesqp->lock, flags);
 
@@ -3498,6 +3500,9 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					break;
 			}
 
+		if (err)
+			break;
+
 		if (ib_wr->send_flags & IB_SEND_SIGNALED) {
 			wqe_misc |= NES_IWARP_SQ_WQE_SIGNALED_COMPL;
 		}
@@ -3522,6 +3527,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 
 	spin_unlock_irqrestore(&nesqp->lock, flags);
 
+out:
 	if (err)
 		*bad_wr = ib_wr;
 	return err;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
