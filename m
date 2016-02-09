From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] staging/rdma/hfi1: actually use new RNR timer API in
 loopback path
Date: Tue, 09 Feb 2016 14:29:31 -0800
Message-ID: <20160209222927.7444.81023.stgit@scvm10.sc.intel.com>
References: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209222705.7444.85189.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The patch series which added a new API for the RNR timer did not include an
updated call in the loopback path. RC/UC RNR loopback would be broken
without this.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c    |    2 +-
 drivers/staging/rdma/hfi1/ruc.c   |    8 +++-----
 drivers/staging/rdma/hfi1/verbs.h |    1 +
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index e54e0b4..ba2a2cc 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -81,7 +81,7 @@ static inline void hfi1_add_retry_timer(struct rvt_qp *qp)
  *
  * add an rnr timer on the QP
  */
-static inline void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
+void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 66449ac..a7add3c 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -371,6 +371,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	int release;
 	int ret;
 	int copy_last = 0;
+	u32 to;
 
 	rcu_read_lock();
 
@@ -600,11 +601,8 @@ rnr_nak:
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
-	sqp->s_flags |= RVT_S_WAIT_RNR;
-	sqp->s_timer.function = hfi1_rc_rnr_retry;
-	sqp->s_timer.expires = jiffies +
-		usecs_to_jiffies(ib_hfi1_rnr_table[qp->r_min_rnr_timer]);
-	add_timer(&sqp->s_timer);
+	to = ib_hfi1_rnr_table[qp->r_min_rnr_timer];
+	hfi1_add_rnr_timer(sqp, to);
 	goto clr_busy;
 
 op_err:
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 26eda8a..adb63bb 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -404,6 +404,7 @@ u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
 void hfi1_rc_rnr_retry(unsigned long arg);
+void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to);
 void hfi1_rc_timeout(unsigned long arg);
 void hfi1_del_timers_sync(struct rvt_qp *qp);
 void hfi1_stop_rc_timers(struct rvt_qp *qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
