From: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH V5] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon,  5 Jun 2017 20:23:40 +0800
Message-ID: <1496665420-8100-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep under a spin lock, and the function call path is:
post_one_send (acquire the lock by spin_lock_irqsave)
  init_send_wqe
    copy_from_user --> may sleep

There is no flow that makes "qp->is_user" true, and copy_from_user may
cause bug when a non-user pointer is used. So the lines of copy_from_user
and check of "qp->is_user" are removed.

Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
---
V5:
* Remove useless check of "qp->is_user".
  Thank Leon for pointing it out.

V4:
* Remove the line of copy_from_user.
  Thank Moni for good advice.

V3:
* It corrects the mistakes of remaining legacy code in V2.
  Thank Ram for pointing it out.

V2:
* The parameter "flags" is added to restore and save the irq status.
  Thank Leon for good advice.
---
 drivers/infiniband/sw/rxe/rxe_verbs.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e..073e667 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -740,13 +740,8 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
 
 		sge = ibwr->sg_list;
 		for (i = 0; i < num_sge; i++, sge++) {
-			if (qp->is_user && copy_from_user(p, (__user void *)
-					    (uintptr_t)sge->addr, sge->length))
-				return -EFAULT;
-
-			else if (!qp->is_user)
-				memcpy(p, (void *)(uintptr_t)sge->addr,
-				       sge->length);
+			memcpy(p, (void *)(uintptr_t)sge->addr,
+					sge->length);
 
 			p += sge->length;
 		}
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
