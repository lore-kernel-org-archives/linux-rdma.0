From: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Thu,  1 Jun 2017 09:48:34 +0800
Message-ID: <1496281714-3035-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep under a spin lock, and the function call path is:
post_one_send (acquire the lock by spin_lock_irqsave)
  init_send_wqe
    copy_from_user --> may sleep

To fix it, the lock is released before copy_from_user, and the lock is
acquired again after this function.

Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e..6fb7e1a 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -725,7 +725,7 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
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
+			spin_unlock_irq(&qp->sq.sq_lock);
+			err = copy_from_user(p, (__user void *)
+					    (uintptr_t)sge->addr, sge->length);
+			spin_lock_irq(&qp->sq.sq_lock);
+			if (qp->is_user && err)
 				return -EFAULT;
 
 			else if (!qp->is_user)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
