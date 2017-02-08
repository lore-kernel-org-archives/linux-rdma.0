From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/27] IB/hfi1: Correct error calldown locking
Date: Wed, 08 Feb 2017 05:26:20 -0800
Message-ID: <20170208132619.16442.54823.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The resource specific wait locking missed correcting the lock
for the notify_error_qp() calldown.

The code is fixed to correctly use the iowait lock field to protect
the head that is protected by that lock.

Fixes: Commit 4e045572e2c2 ("IB/hfi1: Add unique txwait_lock for txreq events")
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index d752d67..c2a166d 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -961,17 +961,20 @@ int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 
 void notify_error_qp(struct rvt_qp *qp)
 {
-	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	struct hfi1_qp_priv *priv = qp->priv;
+	seqlock_t *lock = priv->s_iowait.lock;
 
-	write_seqlock(&dev->iowait_lock);
-	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
-		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
-		list_del_init(&priv->s_iowait.list);
-		priv->s_iowait.lock = NULL;
-		rvt_put_qp(qp);
+	if (lock) {
+		write_seqlock(lock);
+		if (!list_empty(&priv->s_iowait.list) &&
+		    !(qp->s_flags & RVT_S_BUSY)) {
+			qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
+			list_del_init(&priv->s_iowait.list);
+			priv->s_iowait.lock = NULL;
+			rvt_put_qp(qp);
+		}
+		write_sequnlock(lock);
 	}
-	write_sequnlock(&dev->iowait_lock);
 
 	if (!(qp->s_flags & RVT_S_BUSY)) {
 		qp->s_hdrwords = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
