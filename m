From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] IB/rdmavt,
 staging/rdma/hfi1: use qps to dynamically scale timeout value
Date: Tue, 09 Feb 2016 14:29:49 -0800
Message-ID: <20160209222945.7444.97602.stgit@scvm10.sc.intel.com>
References: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209222705.7444.85189.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A busy_jiffies variable is maintained and updated when rc qps are
created and deleted. busy_jiffies is a scaled value of the number
of rc qps in the device. busy_jiffies is incremented every rc qp
scaling interval. busy_jiffies is added to the rc timeout
in add_retry_timer and mod_retry_timer. The rc qp scaling interval
is selected based on extensive performance evaluation of targeted
workloads.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   17 +++++++++++++++++
 drivers/staging/rdma/hfi1/rc.c    |   12 ++++++++++--
 include/rdma/rdma_vt.h            |    4 +++-
 include/rdma/rdmavt_qp.h          |    2 ++
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 439213c..7dc837c 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -685,6 +685,19 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	}
 
 	rdi->n_qps_allocated++;
+	/*
+	 * Maintain a busy_jiffies variable that will be added to the timeout
+	 * period in mod_retry_timer and add_retry_timer. This busy jiffies
+	 * is scaled by the number of rc qps created for the device to reduce
+	 * the number of timeouts occurring when there is a large number of
+	 * qps. busy_jiffies is incremented every rc qp scaling interval.
+	 * The scaling interval is selected based on extensive performance
+	 * evaluation of targeted workloads.
+	 */
+	if (init_attr->qp_type == IB_QPT_RC) {
+		rdi->n_rc_qps++;
+		rdi->busy_jiffies = rdi->n_rc_qps / RC_QP_SCALING_INTERVAL;
+	}
 	spin_unlock(&rdi->n_qps_lock);
 
 	if (qp->ip) {
@@ -1223,6 +1236,10 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 
 	spin_lock(&rdi->n_qps_lock);
 	rdi->n_qps_allocated--;
+	if (qp->ibqp.qp_type == IB_QPT_RC) {
+		rdi->n_rc_qps--;
+		rdi->busy_jiffies = rdi->n_rc_qps / RC_QP_SCALING_INTERVAL;
+	}
 	spin_unlock(&rdi->n_qps_lock);
 
 	if (qp->ip)
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index ba2a2cc..a4a44d3 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -68,9 +68,13 @@
  */
 static inline void hfi1_add_retry_timer(struct rvt_qp *qp)
 {
+	struct ib_qp *ibqp = &qp->ibqp;
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+
 	qp->s_flags |= RVT_S_TIMER;
 	/* 4.096 usec. * (1 << qp->timeout) */
-	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
+	qp->s_timer.expires = jiffies + qp->timeout_jiffies +
+			      rdi->busy_jiffies;
 	add_timer(&qp->s_timer);
 }
 
@@ -99,9 +103,13 @@ void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
  */
 static inline void hfi1_mod_retry_timer(struct rvt_qp *qp)
 {
+	struct ib_qp *ibqp = &qp->ibqp;
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+
 	qp->s_flags |= RVT_S_TIMER;
 	/* 4.096 usec. * (1 << qp->timeout) */
-	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
+	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies +
+		  rdi->busy_jiffies);
 }
 
 /**
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 4242fea..5ccf683 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -318,7 +318,9 @@ struct rvt_dev_info {
 	/* QP */
 	struct rvt_qp_ibdev *qp_dev;
 	u32 n_qps_allocated;    /* number of QPs allocated for device */
-	spinlock_t n_qps_lock; /* keep track of number of qps */
+	u32 n_rc_qps;		/* number of RC QPs allocated for device */
+	u32 busy_jiffies;	/* timeout scaling based on RC QP count */
+	spinlock_t n_qps_lock;	/* protect qps, rc qps and busy jiffy counts */
 
 	/* memory maps */
 	struct list_head pending_mmaps;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index aed13e1..b3ea745 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -225,6 +225,8 @@ struct rvt_ack_entry {
 	};
 };
 
+#define	RC_QP_SCALING_INTERVAL	5
+
 /*
  * Variables prefixed with s_ are for the requester (sender).
  * Variables prefixed with r_ are for the responder (receiver).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
