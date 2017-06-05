From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH V3] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon,  5 Jun 2017 15:55:31 +0800
Message-ID: <1496649331-1405-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: yuval.shaia@oracle.com, monis@mellanox.com, sean.hefty@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep under a spin lock, and the function call path is:
post_one_send (acquire the lock by spin_lock_irqsave)
  init_send_wqe
    copy_from_user --> may sleep

To fix it, the lock is released before copy_from_user, and the lock is
acquired again after this function. The parameter "flags" is used to
restore and save the irq status.


Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
V3:
* It corrects the mistakes of remaining legacy code in V2. 
  (Thank Ram for pointing it out)

V2:
* The parameter "flags" is added to restore and save the irq status.
  Thank Leon for good advice.
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
