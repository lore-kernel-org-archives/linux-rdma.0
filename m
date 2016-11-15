From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] qedr: Unlock on error in qedr_post_send()
Date: Tue, 15 Nov 2016 12:51:00 +0300
Message-ID: <20161115095059.GB15424@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Ram Amrani <Ram.Amrani@cavium.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Rajesh Borundia <rajesh.borundia@cavium.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If "wr" is NULL then we return without unlocking.  I added an unlock
label and changed the direct returns to gotos.

Fixes: afa0e13be754 ("qedr: Add support for data path")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a615142..01d05b0 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2973,17 +2973,18 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	if ((qp->state == QED_ROCE_QP_STATE_RESET) ||
 	    (qp->state == QED_ROCE_QP_STATE_ERR)) {
-		spin_unlock_irqrestore(&qp->q_lock, flags);
 		*bad_wr = wr;
 		DP_DEBUG(dev, QEDR_MSG_CQ,
 			 "QP in wrong state! QP icid=0x%x state %d\n",
 			 qp->icid, qp->state);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 
 	if (!wr) {
 		DP_ERR(dev, "Got an empty post send.\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 
 	while (wr) {
@@ -3012,6 +3013,7 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	/* Make sure write sticks */
 	mmiowb();
 
+unlock:
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
 	return rc;
