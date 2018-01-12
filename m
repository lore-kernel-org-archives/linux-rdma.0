From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/2] RDMA/rxe: Fix a race condition in rxe_requester()
Date: Fri, 12 Jan 2018 15:11:58 -0800
Message-ID: <20180112231159.26569-2-bart.vanassche@wdc.com>
References: <20180112231159.26569-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180112231159.26569-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The rxe driver works as follows:
* The send queue, receive queue and completion queues are implemented as
  circular buffers.
* ib_post_send() and ib_post_recv() calls are serialized through a spinlock.
* Removing elements from various queues happens from tasklet
  context. Tasklets are guaranteed to run on at most one CPU. This serializes
  access to these queues. See also rxe_completer(), rxe_requester() and
  rxe_responder().
* rxe_completer() processes the skbs queued onto qp->resp_pkts.
* rxe_requester() handles the send queue (qp->sq.queue).
* rxe_responder() processes the skbs queued onto qp->req_pkts.

Since rxe_drain_req_pkts() processes qp->req_pkts, calling
rxe_drain_req_pkts() from rxe_requester() is racy. Hence this patch.

Reported-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: stable@vger.kernel.org
---
 drivers/infiniband/sw/rxe/rxe_loc.h  | 1 -
 drivers/infiniband/sw/rxe/rxe_req.c  | 9 +--------
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index d7472a442a2c..96c3a6c5c4b5 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -237,7 +237,6 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 
 void rxe_release(struct kref *kref);
 
-void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify);
 int rxe_completer(void *arg);
 int rxe_requester(void *arg);
 int rxe_responder(void *arg);
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 26a7f923045b..7bdaf71b8221 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -594,15 +594,8 @@ int rxe_requester(void *arg)
 	rxe_add_ref(qp);
 
 next_wqe:
-	if (unlikely(!qp->valid)) {
-		rxe_drain_req_pkts(qp, true);
+	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
 		goto exit;
-	}
-
-	if (unlikely(qp->req.state == QP_STATE_ERROR)) {
-		rxe_drain_req_pkts(qp, true);
-		goto exit;
-	}
 
 	if (unlikely(qp->req.state == QP_STATE_RESET)) {
 		qp->req.wqe_index = consumer_index(qp->sq.queue);
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 4240866a5331..01f926fd9029 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1210,7 +1210,7 @@ static enum resp_states do_class_d1e_error(struct rxe_qp *qp)
 	}
 }
 
-void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
+static void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
 {
 	struct sk_buff *skb;
 
-- 
2.15.1
