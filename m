From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/13] IB/rdmavt: Add qp init function
Date: Tue, 06 Sep 2016 04:37:26 -0700
Message-ID: <20160906113712.27413.71087.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add an rvt_qp_init() to initialize specific
common fields as the qp is created or reset.

The routine is shared by the rvt_reset_qp() and
the rvt_create_qp().

The intent is that lock dep assertions will only
appear in the rvt_reset_qp().

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |  100 +++++++++++++++++++++----------------
 1 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 0a29815..673e2f6 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -493,50 +493,18 @@ static void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 }
 
 /**
- * reset_qp - initialize the QP state to the reset state
- * @qp: the QP to reset
+ * rvt_init_qp - initialize the QP state to the reset state
+ * @qp: the QP to init or reinit
  * @type: the QP type
- * r and s lock are required to be held by the caller
+ *
+ * This function is called from both rvt_create_qp() and
+ * rvt_reset_qp().   The difference is that the reset
+ * patch the necessary locks to protect against concurent
+ * access.
  */
-static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-		  enum ib_qp_type type)
-	__must_hold(&qp->r_lock)
-	__must_hold(&qp->s_hlock)
-	__must_hold(&qp->s_lock)
+static void rvt_init_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			enum ib_qp_type type)
 {
-	if (qp->state != IB_QPS_RESET) {
-		qp->state = IB_QPS_RESET;
-
-		/* Let drivers flush their waitlist */
-		rdi->driver_f.flush_qp_waiters(qp);
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
-		spin_unlock(&qp->s_lock);
-		spin_unlock(&qp->s_hlock);
-		spin_unlock_irq(&qp->r_lock);
-
-		/* Stop the send queue and the retry timer */
-		rdi->driver_f.stop_send_queue(qp);
-
-		/* Wait for things to stop */
-		rdi->driver_f.quiesce_qp(qp);
-
-		/* take qp out the hash and wait for it to be unused */
-		rvt_remove_qp(rdi, qp);
-		wait_event(qp->wait, !atomic_read(&qp->refcount));
-
-		/* grab the lock b/c it was locked at call time */
-		spin_lock_irq(&qp->r_lock);
-		spin_lock(&qp->s_hlock);
-		spin_lock(&qp->s_lock);
-
-		rvt_clear_mr_refs(qp, 1);
-		/*
-		 * Let the driver do any tear down it needs to for a qp
-		 * that has been reset
-		 */
-		rdi->driver_f.notify_qp_reset(qp);
-	}
-
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;
@@ -582,6 +550,54 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 }
 
 /**
+ * rvt_reset_qp - initialize the QP state to the reset state
+ * @qp: the QP to reset
+ * @type: the QP type
+ *
+ * r_lock, s_hlock, and s_lock are required to be held by the caller
+ */
+static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			 enum ib_qp_type type)
+	__must_hold(&qp->s_lock)
+	__must_hold(&qp->s_hlock)
+	__must_hold(&qp->r_lock)
+{
+	if (qp->state != IB_QPS_RESET) {
+		qp->state = IB_QPS_RESET;
+
+		/* Let drivers flush their waitlist */
+		rdi->driver_f.flush_qp_waiters(qp);
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
+		spin_unlock(&qp->s_lock);
+		spin_unlock(&qp->s_hlock);
+		spin_unlock_irq(&qp->r_lock);
+
+		/* Stop the send queue and the retry timer */
+		rdi->driver_f.stop_send_queue(qp);
+
+		/* Wait for things to stop */
+		rdi->driver_f.quiesce_qp(qp);
+
+		/* take qp out the hash and wait for it to be unused */
+		rvt_remove_qp(rdi, qp);
+		wait_event(qp->wait, !atomic_read(&qp->refcount));
+
+		/* grab the lock b/c it was locked at call time */
+		spin_lock_irq(&qp->r_lock);
+		spin_lock(&qp->s_hlock);
+		spin_lock(&qp->s_lock);
+
+		rvt_clear_mr_refs(qp, 1);
+		/*
+		 * Let the driver do any tear down or re-init it needs to for
+		 * a qp that has been reset
+		 */
+		rdi->driver_f.notify_qp_reset(qp);
+	}
+	rvt_init_qp(rdi, qp, type);
+}
+
+/**
  * rvt_create_qp - create a queue pair for a device
  * @ibpd: the protection domain who's device we create the queue pair for
  * @init_attr: the attributes of the queue pair
@@ -761,7 +777,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		}
 		qp->ibqp.qp_num = err;
 		qp->port_num = init_attr->port_num;
-		rvt_reset_qp(rdi, qp, init_attr->qp_type);
+		rvt_init_qp(rdi, qp, init_attr->qp_type);
 		break;
 
 	default:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
