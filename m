From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rdmavt: Correct qp_priv_alloc() return value test
Date: Wed, 22 Jun 2016 13:29:33 -0700
Message-ID: <20160622202933.16853.56199.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current drivers return errors from this calldown
wrapped in an ERR_PTR().

The rdmavt code incorrectly tests for NULL.

The code is fixed to use IS_ERR() and change ret according
to the driver return value.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.6+
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    4 +++-
 include/rdma/rdma_vt.h            |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index d04f4fe..41ba7e9 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -699,8 +699,10 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		 * initialization that is needed.
 		 */
 		priv = rdi->driver_f.qp_priv_alloc(rdi, qp, gfp);
-		if (!priv)
+		if (IS_ERR(priv)) {
+			ret = priv;
 			goto bail_qp;
+		}
 		qp->priv = priv;
 		qp->timeout_jiffies =
 			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 16274e2..9c9a27d 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -203,7 +203,9 @@ struct rvt_driver_provided {
 
 	/*
 	 * Allocate a private queue pair data structure for driver specific
-	 * information which is opaque to rdmavt.
+	 * information which is opaque to rdmavt.  Errors are returned via
+	 * ERR_PTR(err).  The driver is free to return NULL or a valid
+	 * pointer.
 	 */
 	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 				gfp_t gfp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
