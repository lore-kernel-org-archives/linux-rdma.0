From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/13] IB/core: add a MR pool for signature MRs
Date: Sat, 27 Feb 2016 19:10:30 +0100
Message-ID: <1456596631-19418-13-git-send-email-hch@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456596631-19418-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/mr_pool.c |  4 +++-
 drivers/infiniband/core/rw.c      | 13 +++++++++++++
 drivers/infiniband/core/verbs.c   |  1 +
 include/rdma/ib_verbs.h           |  1 +
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
index b1eb27a..9751bb1 100644
--- a/drivers/infiniband/core/mr_pool.c
+++ b/drivers/infiniband/core/mr_pool.c
@@ -20,8 +20,10 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list)
 
 	spin_lock_irqsave(&qp->mr_lock, flags);
 	mr = list_first_entry_or_null(list, struct ib_mr, qp_entry);
-	if (mr)
+	if (mr) {
+		list_del(&mr->qp_entry);
 		qp->mrs_used++;
+	}
 	spin_unlock_irqrestore(&qp->mr_lock, flags);
 
 	return mr;
diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 69c3ca5..00af4ce 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -384,10 +384,23 @@ int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
 				dev->attrs.max_fast_reg_page_list_len);
 	}
 
+	if (attr->create_flags & IB_QP_CREATE_SIGNATURE_EN) {
+		ret = ib_mr_pool_init(qp, &qp->sig_mrs,
+				attr->cap.max_rdma_ctxs, IB_MR_TYPE_SIGNATURE,
+				2);
+		if (ret)
+			goto out_free_rdma_mrs;
+	}
+
+	return 0;
+
+out_free_rdma_mrs:
+	ib_mr_pool_destroy(qp, &qp->rdma_mrs);
 	return ret;
 }
 
 void rdma_rw_cleanup_mrs(struct ib_qp *qp)
 {
+	ib_mr_pool_destroy(qp, &qp->sig_mrs);
 	ib_mr_pool_destroy(qp, &qp->rdma_mrs);
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 1ef3a1a..c5034af 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -776,6 +776,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->mrs_used = 0;
 	spin_lock_init(&qp->mr_lock);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
+	INIT_LIST_HEAD(&qp->sig_mrs);
 
 	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
 		return ib_create_xrc_qp(qp, qp_init_attr);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 035585a..00af0a7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1422,6 +1422,7 @@ struct ib_qp {
 
 	spinlock_t		mr_lock;
 	struct list_head	rdma_mrs;
+	struct list_head	sig_mrs;
 	int			mrs_used;
 
 	/* count times opened, mcast attaches, flow attaches */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
