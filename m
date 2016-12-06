From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] i40iw: Fix race condition in terminate timer's handler
Date: Tue,  6 Dec 2016 15:49:33 -0600
Message-ID: <20161206214935.41584-5-henry.orosco@intel.com>
References: <20161206214935.41584-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a QP reference when terminate timer is started to ensure
the destroy QP doesn't race ahead to free the QP while it is being
referenced in the terminate timer's handler.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 5 ++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index ff95fea..a217d2f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3471,7 +3471,7 @@ static void i40iw_cm_disconn_true(struct i40iw_qp *iwqp)
 		 *terminate-handler to issue cm_disconn which can re-free
 		 *a QP even after its refcnt=0.
 		 */
-		del_timer(&iwqp->terminate_timer);
+		i40iw_terminate_del_timer(qp);
 		if (!iwqp->flush_issued) {
 			iwqp->flush_issued = 1;
 			issue_flush = 1;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 4a08ffb..7d4af77 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -823,6 +823,7 @@ static void i40iw_terminate_timeout(unsigned long context)
 	struct i40iw_sc_qp *qp = (struct i40iw_sc_qp *)&iwqp->sc_qp;
 
 	i40iw_terminate_done(qp, 1);
+	i40iw_rem_ref(&iwqp->ibqp);
 }
 
 /**
@@ -834,6 +835,7 @@ void i40iw_terminate_start_timer(struct i40iw_sc_qp *qp)
 	struct i40iw_qp *iwqp;
 
 	iwqp = (struct i40iw_qp *)qp->back_qp;
+	i40iw_add_ref(&iwqp->ibqp);
 	init_timer(&iwqp->terminate_timer);
 	iwqp->terminate_timer.function = i40iw_terminate_timeout;
 	iwqp->terminate_timer.expires = jiffies + HZ;
@@ -850,7 +852,8 @@ void i40iw_terminate_del_timer(struct i40iw_sc_qp *qp)
 	struct i40iw_qp *iwqp;
 
 	iwqp = (struct i40iw_qp *)qp->back_qp;
-	del_timer(&iwqp->terminate_timer);
+	if (del_timer(&iwqp->terminate_timer))
+		i40iw_rem_ref(&iwqp->ibqp);
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 206d72b..18526e6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -959,7 +959,7 @@ int i40iw_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				goto exit;
 			}
 			if (iwqp->sc_qp.term_flags)
-				del_timer(&iwqp->terminate_timer);
+				i40iw_terminate_del_timer(&iwqp->sc_qp);
 			info.next_iwarp_state = I40IW_QP_STATE_ERROR;
 			if ((iwqp->hw_tcp_state > I40IW_TCP_STATE_CLOSED) &&
 			    iwdev->iw_status &&
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
