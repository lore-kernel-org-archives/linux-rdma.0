From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/12] IB/rdmvat: Organize hot path calldowns into a single
 cacheline
Date: Mon, 17 Oct 2016 04:19:07 -0700
Message-ID: <20161017111906.7934.62114.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Save a cacheline by having hot path calldowns together.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |   46 ++++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index e315021..861e23e 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -185,6 +185,27 @@ struct rvt_driver_provided {
 	 * check_support() for details.
 	 */
 
+	/* hot path calldowns in a single cacheline */
+
+	/*
+	 * Give the driver a notice that there is send work to do. It is up to
+	 * the driver to generally push the packets out, this just queues the
+	 * work with the driver. There are two variants here. The no_lock
+	 * version requires the s_lock not to be held. The other assumes the
+	 * s_lock is held.
+	 */
+	void (*schedule_send)(struct rvt_qp *qp);
+	void (*schedule_send_no_lock)(struct rvt_qp *qp);
+
+	/* Driver specific work request checking */
+	int (*check_send_wqe)(struct rvt_qp *qp, struct rvt_swqe *wqe);
+
+	/*
+	 * Sometimes rdmavt needs to kick the driver's send progress. That is
+	 * done by this call back.
+	 */
+	void (*do_send)(struct rvt_qp *qp);
+
 	/* Passed to ib core registration. Callback to create syfs files */
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 
@@ -223,22 +244,6 @@ struct rvt_driver_provided {
 	void (*notify_qp_reset)(struct rvt_qp *qp);
 
 	/*
-	 * Give the driver a notice that there is send work to do. It is up to
-	 * the driver to generally push the packets out, this just queues the
-	 * work with the driver. There are two variants here. The no_lock
-	 * version requires the s_lock not to be held. The other assumes the
-	 * s_lock is held.
-	 */
-	void (*schedule_send)(struct rvt_qp *qp);
-	void (*schedule_send_no_lock)(struct rvt_qp *qp);
-
-	/*
-	 * Sometimes rdmavt needs to kick the driver's send progress. That is
-	 * done by this call back.
-	 */
-	void (*do_send)(struct rvt_qp *qp);
-
-	/*
 	 * Get a path mtu from the driver based on qp attributes.
 	 */
 	int (*get_pmtu_from_attr)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
@@ -324,9 +329,6 @@ struct rvt_driver_provided {
 	void (*modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask, struct ib_udata *udata);
 
-	/* Driver specific work request checking */
-	int (*check_send_wqe)(struct rvt_qp *qp, struct rvt_swqe *wqe);
-
 	/* Notify driver a mad agent has been created */
 	void (*notify_create_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
 
@@ -355,12 +357,12 @@ struct rvt_dev_info {
 	/* post send table */
 	const struct rvt_operation_params *post_parms;
 
-	struct rvt_mregion __rcu *dma_mr;
-	struct rvt_lkey_table lkey_table;
-
 	/* Driver specific helper functions */
 	struct rvt_driver_provided driver_f;
 
+	struct rvt_mregion __rcu *dma_mr;
+	struct rvt_lkey_table lkey_table;
+
 	/* Internal use */
 	int n_pds_allocated;
 	spinlock_t n_pds_lock; /* Protect pd allocated count */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
