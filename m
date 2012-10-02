From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] RDMA/nes: Remove unnecessary if-else statement
Date: Tue, 2 Oct 2012 11:40:33 -0500
Message-ID: <20121002164033.GA2616@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove unnecessary if-else statement

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c4cfd85..c01194d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3069,18 +3069,9 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		}
 
 		nesqp->ibqp_state = attr->qp_state;
-		if (((nesqp->iwarp_state & NES_CQP_QP_IWARP_STATE_MASK) ==
-				(u32)NES_CQP_QP_IWARP_STATE_RTS) &&
-				((next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK) >
-				(u32)NES_CQP_QP_IWARP_STATE_RTS)) {
-			nesqp->iwarp_state = next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK;
-			nes_debug(NES_DBG_MOD_QP, "Change nesqp->iwarp_state=%08x\n",
-					nesqp->iwarp_state);
-		} else {
-			nesqp->iwarp_state = next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK;
-			nes_debug(NES_DBG_MOD_QP, "Change nesqp->iwarp_state=%08x\n",
-					nesqp->iwarp_state);
-		}
+		nesqp->iwarp_state = next_iwarp_state & NES_CQP_QP_IWARP_STATE_MASK;
+		nes_debug(NES_DBG_MOD_QP, "Change nesqp->iwarp_state=%08x\n",
+				nesqp->iwarp_state);
 	}
 
 	if (attr_mask & IB_QP_ACCESS_FLAGS) {
-- 
1.7.4.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
