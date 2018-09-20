From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] RDMA/cxgb4: remove redundant null pointer check before kfree_skb
Date: Thu, 20 Sep 2018 17:52:42 +0800
Message-ID: <1537437162-42846-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: swise@chelsio.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

kfree_skb has taken the null pointer into account. hence it is safe
to remove the redundant null pointer check before kfree_skb.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 +--
 drivers/infiniband/hw/cxgb4/qp.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0f83cbe..615413b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -403,8 +403,7 @@ void _c4iw_free_ep(struct kref *kref)
 				 ep->com.local_addr.ss_family);
 		dst_release(ep->dst);
 		cxgb4_l2t_release(ep->l2t);
-		if (ep->mpa_skb)
-			kfree_skb(ep->mpa_skb);
+		kfree_skb(ep->mpa_skb);
 	}
 	if (!skb_queue_empty(&ep->com.ep_skb_list))
 		skb_queue_purge(&ep->com.ep_skb_list);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 347fe18..e78dd9a 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2813,8 +2813,7 @@ struct ib_srq *c4iw_create_srq(struct ib_pd *pd, struct ib_srq_init_attr *attrs,
 	free_srq_queue(srq, ucontext ? &ucontext->uctx : &rhp->rdev.uctx,
 		       srq->wr_waitp);
 err_free_skb:
-	if (srq->destroy_skb)
-		kfree_skb(srq->destroy_skb);
+	kfree_skb(srq->destroy_skb);
 err_free_srq_idx:
 	c4iw_free_srq_idx(&rhp->rdev, srq->idx);
 err_free_wr_wait:
-- 
1.7.12.4
