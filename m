From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: correction for faulty sparse warning correction
Date: Thu, 24 Jan 2013 13:59:34 -0500
Message-ID: <20130124185934.19853.61429.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 1fb9fed ("IB/qib: Fix QP RCU sparse warning")
broke qp hash list deletion in qp_remove() badly.

This patch restores the former for loop behavior, while
still fixing the sparse warnings.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Gary Leshner <gary.s.leshner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 4850d03..3527509 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -263,20 +263,15 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 		struct qib_qp __rcu **qpp;
 
 		qpp = &dev->qp_table[n];
-		q = rcu_dereference_protected(*qpp,
-			lockdep_is_held(&dev->qpt_lock));
-		for (; q; qpp = &q->next) {
+		for (; (q = rcu_dereference_protected(*qpp,
+				lockdep_is_held(&dev->qpt_lock))) != NULL;
+				qpp = &q->next)
 			if (q == qp) {
 				atomic_dec(&qp->refcount);
 				*qpp = qp->next;
 				rcu_assign_pointer(qp->next, NULL);
-				q = rcu_dereference_protected(*qpp,
-					lockdep_is_held(&dev->qpt_lock));
 				break;
 			}
-			q = rcu_dereference_protected(*qpp,
-				lockdep_is_held(&dev->qpt_lock));
-		}
 	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
