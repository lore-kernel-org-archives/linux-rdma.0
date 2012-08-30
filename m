From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver CQ completion handler
Date: Thu, 30 Aug 2012 13:38:05 +0300
Message-ID: <1346323085-2665-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 CQ completion handler, mlx4_cq_completion doesn't bother to lock 
the radix tree which is used to manage the table of CQs, nor to increase
the reference count of the CQ before invoking the user provided callback.

This is racy and can cause use after free, null pointer dereference, etc various 
crashes. Fix that by wrapping the radix tree lookup with taking the table lock, 
and increase the ref count for the time of the callback.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---

Hi Roland,

Doing some code review on the related parts, I didn't see any way
the handler can be protected for the tree lockup and the user callback
invokation other then using these methods, e.g as done by the "event"
callback. Looking on mthca, I see the same behaviour -- mthca_cq_completion
takes no locks and doesn't increase the refcount while mthca_cq_event does
go by the book and do what ever needed, anything we miss here? its there
from day one... 

Or.

 drivers/net/ethernet/mellanox/mlx4/cq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 7e64033..05d9529 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -56,9 +56,14 @@
 void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 {
 	struct mlx4_cq *cq;
+	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 
+	spin_lock(&cq_table->lock);
 	cq = radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
 			       cqn & (dev->caps.num_cqs - 1));
+	if (cq)
+		atomic_inc(&cq->refcount);
+	spin_unlock(&cq_table->lock);
 	if (!cq) {
 		mlx4_dbg(dev, "Completion event for bogus CQ %08x\n", cqn);
 		return;
@@ -67,6 +72,8 @@ void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 	++cq->arm_sn;
 
 	cq->comp(cq);
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
 }
 
 void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
