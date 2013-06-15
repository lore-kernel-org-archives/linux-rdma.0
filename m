From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] IB/qib: remove atomic_inc_not_zero from QP RCU
Date: Sat, 15 Jun 2013 17:06:58 -0400
Message-ID: <20130615210658.6069.20770.stgit@phlsvslse11.ph.intel.com>
References: <20130615210633.6069.14865.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130615210633.6069.14865.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Follow Documentation/RCU/rcuref.txt guidance in
removing atomic_inc_not_zero() from QP RCU
implementation.

This patch also removes an unneeded synchronize_rcu()
in the add path.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index a6a2cc2..c1f573a 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation.  * All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -222,8 +222,8 @@ static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 	unsigned long flags;
 	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
 
-	spin_lock_irqsave(&dev->qpt_lock, flags);
 	atomic_inc(&qp->refcount);
+	spin_lock_irqsave(&dev->qpt_lock, flags);
 
 	if (qp->ibqp.qp_num == 0)
 		rcu_assign_pointer(ibp->qp0, qp);
@@ -235,7 +235,6 @@ static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
-	synchronize_rcu();
 }
 
 /*
@@ -247,36 +246,39 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
 	unsigned long flags;
+	int removed = 1;
 
 	spin_lock_irqsave(&dev->qpt_lock, flags);
 
 	if (rcu_dereference_protected(ibp->qp0,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		atomic_dec(&qp->refcount);
 		rcu_assign_pointer(ibp->qp0, NULL);
 	} else if (rcu_dereference_protected(ibp->qp1,
 			lockdep_is_held(&dev->qpt_lock)) == qp) {
-		atomic_dec(&qp->refcount);
 		rcu_assign_pointer(ibp->qp1, NULL);
 	} else {
 		struct qib_qp *q;
 		struct qib_qp __rcu **qpp;
 
+		removed = 0;
 		qpp = &dev->qp_table[n];
 		for (; (q = rcu_dereference_protected(*qpp,
 				lockdep_is_held(&dev->qpt_lock))) != NULL;
 				qpp = &q->next)
 			if (q == qp) {
-				atomic_dec(&qp->refcount);
 				rcu_assign_pointer(*qpp,
 					rcu_dereference_protected(qp->next,
 					 lockdep_is_held(&dev->qpt_lock)));
+				removed = 1;
 				break;
 			}
 	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
-	synchronize_rcu();
+	if (removed) {
+		synchronize_rcu();
+		atomic_dec(&qp->refcount);
+	}
 }
 
 /**
@@ -334,26 +336,25 @@ struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
 {
 	struct qib_qp *qp = NULL;
 
+	rcu_read_lock();
 	if (unlikely(qpn <= 1)) {
-		rcu_read_lock();
 		if (qpn == 0)
 			qp = rcu_dereference(ibp->qp0);
 		else
 			qp = rcu_dereference(ibp->qp1);
+		if (qp)
+			atomic_inc(&qp->refcount);
 	} else {
 		struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
 		unsigned n = qpn_hash(dev, qpn);
 
-		rcu_read_lock();
 		for (qp = rcu_dereference(dev->qp_table[n]); qp;
 			qp = rcu_dereference(qp->next))
-			if (qp->ibqp.qp_num == qpn)
+			if (qp->ibqp.qp_num == qpn) {
+				atomic_inc(&qp->refcount);
 				break;
+			}
 	}
-	if (qp)
-		if (unlikely(!atomic_inc_not_zero(&qp->refcount)))
-			qp = NULL;
-
 	rcu_read_unlock();
 	return qp;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
