From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 09/17] rxe: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:08 +0200
Message-ID: <1476388576-22863-10-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/rxe/rxe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 8f8cc91..5aa77ea 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -305,7 +305,7 @@ static struct ibv_srq *rxe_create_srq(struct ibv_pd *pd,
 	return &srq->ibv_srq;
 }
 
-int rxe_modify_srq(struct ibv_srq *ibsrq,
+static int rxe_modify_srq(struct ibv_srq *ibsrq,
 		   struct ibv_srq_attr *attr, int attr_mask)
 {
 	struct rxe_srq *srq = to_rsrq(ibsrq);
@@ -553,7 +553,7 @@ static int validate_send_wr(struct rxe_wq *sq, struct ibv_send_wr *ibwr,
 	return 0;
 }
 
-void convert_send_wr(struct rxe_send_wr *kwr, struct ibv_send_wr *uwr)
+static void convert_send_wr(struct rxe_send_wr *kwr, struct ibv_send_wr *uwr)
 {
 	memset(kwr, 0, sizeof(*kwr));
 
@@ -593,7 +593,7 @@ void convert_send_wr(struct rxe_send_wr *kwr, struct ibv_send_wr *uwr)
 	}
 }
 
-int init_send_wqe(struct rxe_qp *qp, struct rxe_wq *sq,
+static int init_send_wqe(struct rxe_qp *qp, struct rxe_wq *sq,
 		  struct ibv_send_wr *ibwr, unsigned int length,
 		  struct rxe_send_wqe *wqe)
 {
@@ -668,7 +668,7 @@ static int post_one_send(struct rxe_qp *qp, struct rxe_wq *sq,
 }
 
 /* send a null post send as a doorbell */
-int post_send_db(struct ibv_qp *ibqp)
+static int post_send_db(struct ibv_qp *ibqp)
 {
 	struct ibv_post_send cmd;
 	struct ibv_post_send_resp resp;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
