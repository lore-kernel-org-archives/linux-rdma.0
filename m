From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 11/11] RDMA/cxgb4: Only insert sq qid in lookup table.
Date: Thu, 20 May 2010 16:58:21 -0500
Message-ID: <20100520215821.32394.23393.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index a41881b..0c28ed1 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1345,7 +1345,6 @@ int c4iw_destroy_qp(struct ib_qp *ib_qp)
 	wait_event(qhp->wait, !qhp->ep);
 
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.sq.qid);
-	remove_handle(rhp, &rhp->qpidr, qhp->wq.rq.qid);
 	atomic_dec(&qhp->refcnt);
 	wait_event(qhp->wait, !atomic_read(&qhp->refcnt));
 
@@ -1448,30 +1447,26 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	if (ret)
 		goto err2;
 
-	ret = insert_handle(rhp, &rhp->qpidr, qhp, qhp->wq.rq.qid);
-	if (ret)
-		goto err3;
-
 	if (udata) {
 		mm1 = kmalloc(sizeof *mm1, GFP_KERNEL);
 		if (!mm1) {
 			ret = -ENOMEM;
-			goto err4;
+			goto err3;
 		}
 		mm2 = kmalloc(sizeof *mm2, GFP_KERNEL);
 		if (!mm2) {
 			ret = -ENOMEM;
-			goto err5;
+			goto err4;
 		}
 		mm3 = kmalloc(sizeof *mm3, GFP_KERNEL);
 		if (!mm3) {
 			ret = -ENOMEM;
-			goto err6;
+			goto err5;
 		}
 		mm4 = kmalloc(sizeof *mm4, GFP_KERNEL);
 		if (!mm4) {
 			ret = -ENOMEM;
-			goto err7;
+			goto err6;
 		}
 
 		uresp.qid_mask = rhp->rdev.qpmask;
@@ -1493,7 +1488,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		spin_unlock(&ucontext->mmap_lock);
 		ret = ib_copy_to_udata(udata, &uresp, sizeof uresp);
 		if (ret)
-			goto err8;
+			goto err7;
 		mm1->key = uresp.sq_key;
 		mm1->addr = virt_to_phys(qhp->wq.sq.queue);
 		mm1->len = PAGE_ALIGN(qhp->wq.sq.memsize);
@@ -1517,16 +1512,14 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	     __func__, qhp, qhp->attr.sq_num_entries, qhp->attr.rq_num_entries,
 	     qhp->wq.sq.qid);
 	return &qhp->ibqp;
-err8:
-	kfree(mm4);
 err7:
-	kfree(mm3);
+	kfree(mm4);
 err6:
-	kfree(mm2);
+	kfree(mm3);
 err5:
-	kfree(mm1);
+	kfree(mm2);
 err4:
-	remove_handle(rhp, &rhp->qpidr, qhp->wq.rq.qid);
+	kfree(mm1);
 err3:
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.sq.qid);
 err2:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
