From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-next 3/5] iw_cxgb4: allocate wait object for each qp
 object
Date: Tue, 26 Sep 2017 13:11:36 -0700
Message-ID: <ca413122b8f817ad21a3b905b32f894caec35812.1506545745.git.swise@opengridcomputing.com>
References: <cover.1506545745.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1506545745.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the local stack allocated c4iw_wr_wait object in preparation for
correctly handling timeouts.

Also cleaned up some error path unwind logic to make it more readable.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 +
 drivers/infiniband/hw/cxgb4/qp.c       | 55 ++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 3e0ac56..f143c00 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -487,6 +487,7 @@ struct c4iw_qp {
 	int sq_sig_all;
 	struct work_struct free_work;
 	struct c4iw_ucontext *ucontext;
+	struct c4iw_wr_wait *wr_waitp;
 };
 
 static inline struct c4iw_qp *to_c4iw_qp(struct ib_qp *ibqp)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 88e045b..a354001 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -194,13 +194,13 @@ void __iomem *c4iw_bar2_addrs(struct c4iw_rdev *rdev, unsigned int qid,
 
 static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		     struct t4_cq *rcq, struct t4_cq *scq,
-		     struct c4iw_dev_ucontext *uctx)
+		     struct c4iw_dev_ucontext *uctx,
+		     struct c4iw_wr_wait *wr_waitp)
 {
 	int user = (uctx != &rdev->uctx);
 	struct fw_ri_res_wr *res_wr;
 	struct fw_ri_res *res;
 	int wr_len;
-	struct c4iw_wr_wait wr_wait;
 	struct sk_buff *skb;
 	int ret = 0;
 	int eqsize;
@@ -299,7 +299,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 			FW_RI_RES_WR_NRES_V(2) |
 			FW_WR_COMPL_F);
 	res_wr->len16_pkd = cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
-	res_wr->cookie = (uintptr_t)&wr_wait;
+	res_wr->cookie = (uintptr_t)wr_waitp;
 	res = res_wr->res;
 	res->u.sqrq.restype = FW_RI_RES_TYPE_SQ;
 	res->u.sqrq.op = FW_RI_RES_OP_WRITE;
@@ -352,12 +352,12 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	res->u.sqrq.eqid = cpu_to_be32(wq->rq.qid);
 	res->u.sqrq.eqaddr = cpu_to_be64(wq->rq.dma_addr);
 
-	c4iw_init_wr_wait(&wr_wait);
+	c4iw_init_wr_wait(wr_waitp);
 
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
 		goto free_dma;
-	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, wq->sq.qid, __func__);
+	ret = c4iw_wait_for_reply(rdev, wr_waitp, 0, wq->sq.qid, __func__);
 	if (ret)
 		goto free_dma;
 
@@ -730,6 +730,7 @@ static void free_qp_work(struct work_struct *work)
 
 	if (ucontext)
 		c4iw_put_ucontext(ucontext);
+	kfree(qhp->wr_waitp);
 	kfree(qhp);
 }
 
@@ -1794,6 +1795,13 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	qhp = kzalloc(sizeof(*qhp), GFP_KERNEL);
 	if (!qhp)
 		return ERR_PTR(-ENOMEM);
+
+	qhp->wr_waitp = kzalloc(sizeof(*qhp), GFP_KERNEL);
+	if (!qhp->wr_waitp) {
+		ret = -ENOMEM;
+		goto err_free_qhp;
+	}
+
 	qhp->wq.sq.size = sqsize;
 	qhp->wq.sq.memsize =
 		(sqsize + rhp->rdev.hw_queue.t4_eq_status_entries) *
@@ -1810,9 +1818,10 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	}
 
 	ret = create_qp(&rhp->rdev, &qhp->wq, &schp->cq, &rchp->cq,
-			ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
+			ucontext ? &ucontext->uctx : &rhp->rdev.uctx,
+			qhp->wr_waitp);
 	if (ret)
-		goto err1;
+		goto err_free_wr_wait;
 
 	attrs->cap.max_recv_wr = rqsize - 1;
 	attrs->cap.max_send_wr = sqsize - 1;
@@ -1843,35 +1852,35 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 
 	ret = insert_handle(rhp, &rhp->qpidr, qhp, qhp->wq.sq.qid);
 	if (ret)
-		goto err2;
+		goto err_destroy_qp;
 
 	if (udata) {
 		sq_key_mm = kmalloc(sizeof(*sq_key_mm), GFP_KERNEL);
 		if (!sq_key_mm) {
 			ret = -ENOMEM;
-			goto err3;
+			goto err_remove_handle;
 		}
 		rq_key_mm = kmalloc(sizeof(*rq_key_mm), GFP_KERNEL);
 		if (!rq_key_mm) {
 			ret = -ENOMEM;
-			goto err4;
+			goto err_free_sq_key;
 		}
 		sq_db_key_mm = kmalloc(sizeof(*sq_db_key_mm), GFP_KERNEL);
 		if (!sq_db_key_mm) {
 			ret = -ENOMEM;
-			goto err5;
+			goto err_free_rq_key;
 		}
 		rq_db_key_mm = kmalloc(sizeof(*rq_db_key_mm), GFP_KERNEL);
 		if (!rq_db_key_mm) {
 			ret = -ENOMEM;
-			goto err6;
+			goto err_free_sq_db_key;
 		}
 		if (t4_sq_onchip(&qhp->wq.sq)) {
 			ma_sync_key_mm = kmalloc(sizeof(*ma_sync_key_mm),
 						 GFP_KERNEL);
 			if (!ma_sync_key_mm) {
 				ret = -ENOMEM;
-				goto err7;
+				goto err_free_rq_db_key;
 			}
 			uresp.flags = C4IW_QPF_ONCHIP;
 		} else
@@ -1901,7 +1910,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		spin_unlock(&ucontext->mmap_lock);
 		ret = ib_copy_to_udata(udata, &uresp, sizeof uresp);
 		if (ret)
-			goto err8;
+			goto err_free_ma_sync_key;
 		sq_key_mm->key = uresp.sq_key;
 		sq_key_mm->addr = qhp->wq.sq.phys_addr;
 		sq_key_mm->len = PAGE_ALIGN(qhp->wq.sq.memsize);
@@ -1938,22 +1947,24 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		 attrs->cap.max_send_wr, qhp->wq.rq.qid, qhp->wq.rq.size,
 		 qhp->wq.rq.memsize, attrs->cap.max_recv_wr);
 	return &qhp->ibqp;
-err8:
+err_free_ma_sync_key:
 	kfree(ma_sync_key_mm);
-err7:
+err_free_rq_db_key:
 	kfree(rq_db_key_mm);
-err6:
+err_free_sq_db_key:
 	kfree(sq_db_key_mm);
-err5:
+err_free_rq_key:
 	kfree(rq_key_mm);
-err4:
+err_free_sq_key:
 	kfree(sq_key_mm);
-err3:
+err_remove_handle:
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.sq.qid);
-err2:
+err_destroy_qp:
 	destroy_qp(&rhp->rdev, &qhp->wq,
 		   ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
-err1:
+err_free_wr_wait:
+	kfree(qhp->wr_waitp);
+err_free_qhp:
 	kfree(qhp);
 	return ERR_PTR(ret);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
