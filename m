From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH net-next 7/7] RDMA/iw_cxgb4: Low resource fixes for Completion queue
Date: Fri, 10 Jun 2016 01:05:17 +0530
Message-ID: <1465500917-18491-8-git-send-email-hariprasad@chelsio.com>
References: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465500917-18491-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pre-allocate buffers to deallocate completion queue, so that completion
queue is deallocated during RDMA termination when system is running
out of memory.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       | 42 ++++++++++++++++++++--------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 +
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b0b955724458..812ab7278b8e 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -33,19 +33,15 @@
 #include "iw_cxgb4.h"
 
 static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
-		      struct c4iw_dev_ucontext *uctx)
+		      struct c4iw_dev_ucontext *uctx, struct sk_buff *skb)
 {
 	struct fw_ri_res_wr *res_wr;
 	struct fw_ri_res *res;
 	int wr_len;
 	struct c4iw_wr_wait wr_wait;
-	struct sk_buff *skb;
 	int ret;
 
 	wr_len = sizeof *res_wr + sizeof *res;
-	skb = alloc_skb(wr_len, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
@@ -863,7 +859,9 @@ int c4iw_destroy_cq(struct ib_cq *ib_cq)
 	ucontext = ib_cq->uobject ? to_c4iw_ucontext(ib_cq->uobject->context)
 				  : NULL;
 	destroy_cq(&chp->rhp->rdev, &chp->cq,
-		   ucontext ? &ucontext->uctx : &chp->cq.rdev->uctx);
+		   ucontext ? &ucontext->uctx : &chp->cq.rdev->uctx,
+		   chp->destroy_skb);
+	chp->destroy_skb = NULL;
 	kfree(chp);
 	return 0;
 }
@@ -879,7 +877,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	struct c4iw_cq *chp;
 	struct c4iw_create_cq_resp uresp;
 	struct c4iw_ucontext *ucontext = NULL;
-	int ret;
+	int ret, wr_len;
 	size_t memsize, hwentries;
 	struct c4iw_mm_entry *mm, *mm2;
 
@@ -896,6 +894,13 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	if (!chp)
 		return ERR_PTR(-ENOMEM);
 
+	wr_len = sizeof(struct fw_ri_res_wr) + sizeof(struct fw_ri_res);
+	chp->destroy_skb = alloc_skb(wr_len, GFP_KERNEL);
+	if (!chp->destroy_skb) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
 	if (ib_context)
 		ucontext = to_c4iw_ucontext(ib_context);
 
@@ -936,7 +941,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	ret = create_cq(&rhp->rdev, &chp->cq,
 			ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
 	if (ret)
-		goto err1;
+		goto err2;
 
 	chp->rhp = rhp;
 	chp->cq.size--;				/* status page */
@@ -947,15 +952,15 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	init_waitqueue_head(&chp->wait);
 	ret = insert_handle(rhp, &rhp->cqidr, chp, chp->cq.cqid);
 	if (ret)
-		goto err2;
+		goto err3;
 
 	if (ucontext) {
 		mm = kmalloc(sizeof *mm, GFP_KERNEL);
 		if (!mm)
-			goto err3;
+			goto err4;
 		mm2 = kmalloc(sizeof *mm2, GFP_KERNEL);
 		if (!mm2)
-			goto err4;
+			goto err5;
 
 		uresp.qid_mask = rhp->rdev.cqmask;
 		uresp.cqid = chp->cq.cqid;
@@ -970,7 +975,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 		ret = ib_copy_to_udata(udata, &uresp,
 				       sizeof(uresp) - sizeof(uresp.reserved));
 		if (ret)
-			goto err5;
+			goto err6;
 
 		mm->key = uresp.key;
 		mm->addr = virt_to_phys(chp->cq.queue);
@@ -986,15 +991,18 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	     __func__, chp->cq.cqid, chp, chp->cq.size,
 	     chp->cq.memsize, (unsigned long long) chp->cq.dma_addr);
 	return &chp->ibcq;
-err5:
+err6:
 	kfree(mm2);
-err4:
+err5:
 	kfree(mm);
-err3:
+err4:
 	remove_handle(rhp, &rhp->cqidr, chp->cq.cqid);
-err2:
+err3:
 	destroy_cq(&chp->rhp->rdev, &chp->cq,
-		   ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
+		   ucontext ? &ucontext->uctx : &rhp->rdev.uctx,
+		   chp->destroy_skb);
+err2:
+	kfree_skb(chp->destroy_skb);
 err1:
 	kfree(chp);
 	return ERR_PTR(ret);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 8a01b1cb7e42..331c90a1a71d 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -414,6 +414,7 @@ static inline struct c4iw_mw *to_c4iw_mw(struct ib_mw *ibmw)
 struct c4iw_cq {
 	struct ib_cq ibcq;
 	struct c4iw_dev *rhp;
+	struct sk_buff *destroy_skb;
 	struct t4_cq cq;
 	spinlock_t lock;
 	spinlock_t comp_handler_lock;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
