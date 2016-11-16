From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/5] IB/rxe: Clear queue buffer when modifying QP to reset
Date: Wed, 16 Nov 2016 10:39:17 +0200
Message-ID: <1479285558-19627-5-git-send-email-leon@kernel.org>
References: <1479285558-19627-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479285558-19627-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RXE resets the send-q only once in rxe_qp_init_req() when
QP is created, but when the QP is reused after QP reset, the send-q
holds previous garbage data.

This garbage data wrongly fails CQEs that otherwise
should have completed successfully.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 1 +
 drivers/infiniband/sw/rxe/rxe_queue.c | 9 +++++++++
 drivers/infiniband/sw/rxe/rxe_queue.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index b8036cf..95aaaa2 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -522,6 +522,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
 	if (qp->sq.queue) {
 		__rxe_do_task(&qp->comp.task);
 		__rxe_do_task(&qp->req.task);
+		rxe_queue_reset(qp->sq.queue);
 	}
 
 	/* cleanup attributes */
diff --git a/drivers/infiniband/sw/rxe/rxe_queue.c b/drivers/infiniband/sw/rxe/rxe_queue.c
index 0827425..d14bf49 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.c
+++ b/drivers/infiniband/sw/rxe/rxe_queue.c
@@ -84,6 +84,15 @@ int do_mmap_info(struct rxe_dev *rxe,
 	return -EINVAL;
 }
 
+inline void rxe_queue_reset(struct rxe_queue *q)
+{
+	/* queue is comprised from header and the memory
+	 * of the actual queue. See "struct rxe_queue_buf" in rxe_queue.h
+	 * reset only the queue itself and not the management header
+	 */
+	memset(q->buf->data, 0, q->buf_size - sizeof(struct rxe_queue_buf));
+}
+
 struct rxe_queue *rxe_queue_init(struct rxe_dev *rxe,
 				 int *num_elem,
 				 unsigned int elem_size)
diff --git a/drivers/infiniband/sw/rxe/rxe_queue.h b/drivers/infiniband/sw/rxe/rxe_queue.h
index 239fd60..8c8641c 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.h
+++ b/drivers/infiniband/sw/rxe/rxe_queue.h
@@ -84,6 +84,8 @@ int do_mmap_info(struct rxe_dev *rxe,
 		 size_t buf_size,
 		 struct rxe_mmap_info **ip_p);
 
+void rxe_queue_reset(struct rxe_queue *q);
+
 struct rxe_queue *rxe_queue_init(struct rxe_dev *rxe,
 				 int *num_elem,
 				 unsigned int elem_size);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
