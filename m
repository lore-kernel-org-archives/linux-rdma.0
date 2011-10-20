From: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Subject: [PATCH] IW_CXGB4: Fix iw_cxgb4 count_rcqes logic
Date: Thu, 20 Oct 2011 13:25:14 -0500
Message-ID: <20111020182514.2760.57368.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes another place in the code where logic dealing with the
t4_cqe was using the wrong QID. This change fixes the counting
logic so that it tests against the SQ QID instead of the RQ QID
when counting RCQES

Signed-off by: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Signed-off by: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 901c5fb..04ae97e 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -311,7 +311,7 @@ void c4iw_count_rcqes(struct t4_cq *cq, struct t4_wq *wq, int *count)
 	while (ptr != cq->sw_pidx) {
 		cqe = &cq->sw_queue[ptr];
 		if (RQ_TYPE(cqe) && (CQE_OPCODE(cqe) != FW_RI_READ_RESP) &&
-		    (CQE_QPID(cqe) == wq->rq.qid) && cqe_completes_wr(cqe, wq))
+		    (CQE_QPID(cqe) == wq->sq.qid) && cqe_completes_wr(cqe, wq))
 			(*count)++;
 		if (++ptr == cq->size)
 			ptr = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
