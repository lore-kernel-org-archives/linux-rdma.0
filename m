From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] RDMA/rxe: Set wqe->status correctly if an unexpected response is received
Date: Fri, 22 Jun 2018 08:19:15 -0700
Message-ID: <20180622151915.11502-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, Jianchao Wang <jianchao.w.wang@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Every function that returns COMPST_ERROR must set wqe->status to
another value than IB_WC_SUCCESS before returning COMPST_ERROR. Fix
the only code path for which this is not yet the case.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: Yuval Shaia <yuval.shaia@oracle.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 98d470d1f3fc..5bc62c0cc802 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -276,6 +276,9 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
 		if (wqe->wr.opcode != IB_WR_RDMA_READ &&
 		    wqe->wr.opcode != IB_WR_RDMA_READ_WITH_INV) {
+			pr_err("%s: opcode wr %d <> pkt %d\n", __func__,
+			       wqe->wr.opcode, pkt->opcode);
+			wqe->status = IB_WC_FATAL_ERR;
 			return COMPST_ERROR;
 		}
 		reset_retry_counters(qp);
-- 
2.17.1
