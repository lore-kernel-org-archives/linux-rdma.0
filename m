From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER() in qib_qp.c
Date: Fri, 16 Jan 2015 10:19:53 -0500
Message-ID: <20150116151953.1431.97213.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

These cases fulfill the conditions above because between the
rcu_dereference_protected() call and the rcu_assign_pointer() call there is no
update of that value.
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (...,
(
 rtnl_dereference(...)
|
 rcu_dereference_protected(...)
) )

[consolidated from http://marc.info/?l=linux-rdma&m=140836578119485&w=2 and
 http://marc.info/?l=linux-rdma&m=140906361403047&w=2]

Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andreea-Cristina Bernat <bernat.ada-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6ddc026..4fa88ba 100644
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
@@ -269,7 +269,7 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 				lockdep_is_held(&dev->qpt_lock))) != NULL;
 				qpp = &q->next)
 			if (q == qp) {
-				rcu_assign_pointer(*qpp,
+				RCU_INIT_POINTER(*qpp,
 					rcu_dereference_protected(qp->next,
 					 lockdep_is_held(&dev->qpt_lock)));
 				removed = 1;
@@ -315,7 +315,7 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 	for (n = 0; n < dev->qp_table_size; n++) {
 		qp = rcu_dereference_protected(dev->qp_table[n],
 			lockdep_is_held(&dev->qpt_lock));
-		rcu_assign_pointer(dev->qp_table[n], NULL);
+		RCU_INIT_POINTER(dev->qp_table[n], NULL);
 
 		for (; qp; qp = rcu_dereference_protected(qp->next,
 					lockdep_is_held(&dev->qpt_lock)))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
