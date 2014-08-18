From: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] qib_qp: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Date: Mon, 18 Aug 2014 15:42:47 +0300
Message-ID: <20140818124246.GA18423@ada>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 7fcc150..17daf42 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -255,10 +255,10 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 
 	if (rcu_dereference_protected(ibp->qp0,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		rcu_assign_pointer(ibp->qp0, NULL);
+		RCU_INIT_POINTER(ibp->qp0, NULL);
 	} else if (rcu_dereference_protected(ibp->qp1,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		rcu_assign_pointer(ibp->qp1, NULL);
+		RCU_INIT_POINTER(ibp->qp1, NULL);
 	} else {
 		struct qib_qp *q;
 		struct qib_qp __rcu **qpp;
@@ -315,7 +315,7 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 	for (n = 0; n < dev->qp_table_size; n++) {
 		qp = rcu_dereference_protected(dev->qp_table[n],
 			lockdep_is_held(&dev->qpt_lock));
-		rcu_assign_pointer(dev->qp_table[n], NULL);
+		RCU_INIT_POINTER(dev->qp_table[n], NULL);
 
 		for (; qp; qp = rcu_dereference_protected(qp->next,
 					lockdep_is_held(&dev->qpt_lock)))
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
