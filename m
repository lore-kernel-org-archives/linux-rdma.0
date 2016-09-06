From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/13] IB/hfi1: Move iowait_init() to priv allocate
Date: Tue, 06 Sep 2016 04:36:53 -0700
Message-ID: <20160906113638.27413.27398.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The call is misplaced in the reset calldown function
and causes issues with lockdep assertions that are to
be added.

Fixes: Commit a2c2d608957c ("staging/rdma/hfi1: Remove create_qp functionality")
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 63f56a8..53ad10c 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -806,6 +806,13 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		kfree(priv);
 		return ERR_PTR(-ENOMEM);
 	}
+	iowait_init(
+		&priv->s_iowait,
+		1,
+		_hfi1_do_send,
+		iowait_sleep,
+		iowait_wakeup,
+		iowait_sdma_drained);
 	setup_timer(&priv->s_rnr_timer, hfi1_rc_rnr_retry, (unsigned long)qp);
 	qp->s_timer.function = hfi1_rc_timeout;
 	return priv;
@@ -871,13 +878,6 @@ void notify_qp_reset(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
-	iowait_init(
-		&priv->s_iowait,
-		1,
-		_hfi1_do_send,
-		iowait_sleep,
-		iowait_wakeup,
-		iowait_sdma_drained);
 	priv->r_adefered = 0;
 	clear_ahg(qp);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
