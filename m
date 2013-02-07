From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix qp locate remove race
Date: Thu, 07 Feb 2013 15:47:51 -0500
Message-ID: <20130207204751.12914.84132.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

remove_qp() can execute concurrently with a qib_lookup_qpn() on another CPU,
which in of itself, is ok, given the RCU locking.

The issue is that remove_qp() NULLs out the qp->next field so that a
qib_lookup_qpn() might fail to find a qp if it occurs after the one that is
being deleted.   This is a momentary issue and subsequent qib_lookup_qpn()
calls would find the qp's since the search restarts from the bucket head.
At scale, the issue might causes dropped packets and unnecessary
retransmissions.

The fix just deletes the qp->next NULL assignment to prevent the
remove_qp() from hiding qp's from qib_lookup_qpn().

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 3527509..a6a2cc2 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -268,8 +268,9 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 				qpp = &q->next)
 			if (q == qp) {
 				atomic_dec(&qp->refcount);
-				*qpp = qp->next;
-				rcu_assign_pointer(qp->next, NULL);
+				rcu_assign_pointer(*qpp,
+					rcu_dereference_protected(qp->next,
+					 lockdep_is_held(&dev->qpt_lock)));
 				break;
 			}
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
