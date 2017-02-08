From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 13/14] RDMA/cxgb4: Rename jump labels in c4iw_create_qp()
Date: Wed, 8 Feb 2017 22:23:22 +0100
Message-ID: <8f233488-a0fd-7f64-012d-d0281f02624a@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Wed, 8 Feb 2017 21:12:26 +0100

Adjust jump labels according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index ac63b1f70731..c278b1d968b0 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1817,7 +1817,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	ret = create_qp(&rhp->rdev, &qhp->wq, &schp->cq, &rchp->cq,
 			ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
 	if (ret)
-		goto err1;
+		goto free_qhp;
 
 	attrs->cap.max_recv_wr = rqsize - 1;
 	attrs->cap.max_send_wr = sqsize - 1;
@@ -1848,35 +1848,35 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 
 	ret = insert_handle(rhp, &rhp->qpidr, qhp, qhp->wq.sq.qid);
 	if (ret)
-		goto err2;
+		goto destroy_qp;
 
 	if (udata) {
 		sq_key_mm = kmalloc(sizeof(*sq_key_mm), GFP_KERNEL);
 		if (!sq_key_mm) {
 			ret = -ENOMEM;
-			goto err3;
+			goto remove_handle;
 		}
 		rq_key_mm = kmalloc(sizeof(*rq_key_mm), GFP_KERNEL);
 		if (!rq_key_mm) {
 			ret = -ENOMEM;
-			goto err4;
+			goto free_sq_key;
 		}
 		sq_db_key_mm = kmalloc(sizeof(*sq_db_key_mm), GFP_KERNEL);
 		if (!sq_db_key_mm) {
 			ret = -ENOMEM;
-			goto err5;
+			goto free_rq_key;
 		}
 		rq_db_key_mm = kmalloc(sizeof(*rq_db_key_mm), GFP_KERNEL);
 		if (!rq_db_key_mm) {
 			ret = -ENOMEM;
-			goto err6;
+			goto free_sq_db_key;
 		}
 		if (t4_sq_onchip(&qhp->wq.sq)) {
 			ma_sync_key_mm = kmalloc(sizeof(*ma_sync_key_mm),
 						 GFP_KERNEL);
 			if (!ma_sync_key_mm) {
 				ret = -ENOMEM;
-				goto err7;
+				goto free_rq_db_key;
 			}
 			uresp.flags = C4IW_QPF_ONCHIP;
 		} else
@@ -1906,7 +1906,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		spin_unlock(&ucontext->mmap_lock);
 		ret = ib_copy_to_udata(udata, &uresp, sizeof uresp);
 		if (ret)
-			goto err8;
+			goto free_ma_sync_key;
 		sq_key_mm->key = uresp.sq_key;
 		sq_key_mm->addr = qhp->wq.sq.phys_addr;
 		sq_key_mm->len = PAGE_ALIGN(qhp->wq.sq.memsize);
@@ -1944,22 +1944,22 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	     attrs->cap.max_send_wr, qhp->wq.rq.qid, qhp->wq.rq.size,
 	     qhp->wq.rq.memsize, attrs->cap.max_recv_wr);
 	return &qhp->ibqp;
-err8:
+free_ma_sync_key:
 	kfree(ma_sync_key_mm);
-err7:
+free_rq_db_key:
 	kfree(rq_db_key_mm);
-err6:
+free_sq_db_key:
 	kfree(sq_db_key_mm);
-err5:
+free_rq_key:
 	kfree(rq_key_mm);
-err4:
+free_sq_key:
 	kfree(sq_key_mm);
-err3:
+remove_handle:
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.sq.qid);
-err2:
+destroy_qp:
 	destroy_qp(&rhp->rdev, &qhp->wq,
 		   ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
-err1:
+free_qhp:
 	kfree(qhp);
 	return ERR_PTR(ret);
 }
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
