From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] RDMA/rxe: Fix a race condition related to the QP error state
Date: Tue,  9 Jan 2018 11:23:40 -0800
Message-ID: <20180109192340.25702-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Moni Shoua <monis@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The following sequence:
* Change queue pair state into IB_QPS_ERR.
* Post a work request on the queue pair.
Triggers the following race condition in the rdma_rxe driver:
* rxe_qp_error() triggers an asynchronous call of rxe_completer(), the function
  that examines the QP send queue.
* rxe_post_send() posts a work request on the QP send queue.
Avoid that this race causes a work request to be ignored by scheduling
an rxe_completer() call from rxe_post_send() for queues that are in the
error state.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Moni Shoua <monis@mellanox.com>
Cc: <stable@vger.kernel.org> # v4.8
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index a6fbed48db8a..8f631d64c192 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -814,6 +814,8 @@ static int rxe_post_send_kernel(struct rxe_qp *qp, struct ib_send_wr *wr,
 			(queue_count(qp->sq.queue) > 1);
 
 	rxe_run_task(&qp->req.task, must_sched);
+	if (unlikely(qp->req.state == QP_STATE_ERROR))
+		rxe_run_task(&qp->comp.task, 1);
 
 	return err;
 }
-- 
2.15.1
