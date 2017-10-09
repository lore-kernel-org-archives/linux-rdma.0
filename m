From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/7] IB/rdmavt: Don't wait for resources in QP reset
Date: Mon, 09 Oct 2017 12:38:33 -0700
Message-ID: <20171009193831.6965.48857.stgit@scvm10.sc.intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009161736.6965.75352.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Per the IBTA spec, QP destroy shall fail if the QP is attached
to multicast groups, although the spec is silent on modify_qp
to reset state. It implies that ULP must deregister QP from
all mcast groups for destroy to succeed.
The faulty patch "IB/ipoib: Update broadcast object if PKey value
was changed in index 0" exposed two issues in rdmavt:
1. Rvt QP reset waits for qp references to go to zero.
This will hang if QP is attached to multicast groups.
2. The mcast group detach will fail for a QP in reset state
therefore preventing ULP from correcting the issue.
This patch moves the reference count wait to the the destroy QP
path and allows a QP mcast detach to work in the reset state.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mcast.c |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index 1f12b69..b3a38c5 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -351,7 +351,7 @@ int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	int last = 0;
 	int ret = 0;
 
-	if (ibqp->qp_num <= 1 || qp->state == IB_QPS_RESET)
+	if (ibqp->qp_num <= 1)
 		return -EINVAL;
 
 	spin_lock_irq(&ibp->lock);
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 22df09a..367c786 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -717,7 +717,6 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 
 		/* take qp out the hash and wait for it to be unused */
 		rvt_remove_qp(rdi, qp);
-		wait_event(qp->wait, !atomic_read(&qp->refcount));
 
 		/* grab the lock b/c it was locked at call time */
 		spin_lock_irq(&qp->r_lock);
@@ -1443,6 +1442,7 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 	spin_unlock(&qp->s_hlock);
 	spin_unlock_irq(&qp->r_lock);
 
+	wait_event(qp->wait, !atomic_read(&qp->refcount));
 	/* qpn is now available for use again */
 	rvt_free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
