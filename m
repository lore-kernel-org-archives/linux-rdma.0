From: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH V3] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Thu,  1 Jun 2017 16:28:55 +0800
Message-ID: <1496305735-21741-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep under a spin lock, and the function call path is:
post_one_send (acquire the lock by spin_lock_irqsave)
  init_send_wqe
    copy_from_user --> may sleep

To fix it, the lock is released before copy_from_user, and the lock is
acquired again after this function. The parameter "flags" is used to
restore and save the irq status.
Thank Leon for good advice.

This patch corrects the mistakes in V2. (Thank Ram for pointing it out)

Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e..5293d15 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -721,11 +721,11 @@ static void init_send_wr(struct rxe_qp *qp, struct rxe_send_wr *wr,
 
 static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 			 unsigned int mask, unsigned int length,
-			 struct rxe_send_wqe *wqe)
+			 struct rxe_send_wqe *wqe, unsigned long *flags)
 {
 	int num_sge = ibwr->num_sge;
 	struct ib_sge *sge;
-	int i;
+	int i, err;
 	u8 *p;
 
 	init_send_wr(qp, &wqe->wr, ibwr);
@@ -740,8 +740,11 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 
 		sge = ibwr->sg_list;
 		for (i = 0; i < num_sge; i++, sge++) {
-			if (qp->is_user && copy_from_user(p, (__user void *)
-					    (uintptr_t)sge->addr, sge->length))
+			spin_unlock_irqrestore(&qp->sq.sq_lock, *flags);
+			err = copy_from_user(p, (__user void *)
+					(uintptr_t)sge->addr, sge->length);
+			spin_lock_irqsave(&qp->sq.sq_lock, *flags);
+			if (qp->is_user && err)
 				return -EFAULT;
 
 			else if (!qp->is_user)
@@ -794,7 +797,7 @@ static int post_one_send(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 
 	send_wqe = producer_addr(sq->queue);
 
-	err = init_send_wqe(qp, ibwr, mask, length, send_wqe);
+	err = init_send_wqe(qp, ibwr, mask, length, send_wqe, &flags);
 	if (unlikely(err))
 		goto err1;
 
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
