From: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Subject: [PATCH] IW_CXGB4: Fix iw_cxgb4 recv cqe
Date: Thu, 13 Oct 2011 13:56:59 -0500
Message-ID: <20111013185658.29393.53157.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When creating flushed recv CQEs, set the QPID field in
the t4_cqe to the SQ QID and not the RQ QID.  Otherwise
the poll code will not find the correct qp context.

Signed-off by: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Signed-off by: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 1720dc7..901c5fb 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -185,7 +185,7 @@ static void insert_recv_cqe(struct t4_wq *wq, struct t4_cq *cq)
 				 V_CQE_OPCODE(FW_RI_SEND) |
 				 V_CQE_TYPE(0) |
 				 V_CQE_SWCQE(1) |
-				 V_CQE_QPID(wq->rq.qid));
+				 V_CQE_QPID(wq->sq.qid));
 	cqe.bits_type_ts = cpu_to_be64(V_CQE_GENBIT((u64)cq->gen));
 	cq->sw_queue[cq->sw_pidx] = cqe;
 	t4_swcq_produce(cq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
