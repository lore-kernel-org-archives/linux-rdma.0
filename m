From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 06/10] i40iw: Return correct error codes for destroy QP and CQ
Date: Fri,  9 Dec 2016 11:55:00 -0600
Message-ID: <1481306104-19352-7-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return correct error codes to application if destroy QP or
CQ fails. Make sure to deregister memory only if the
destroy is successful.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uverbs.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 651a91d..ef381ed 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -305,9 +305,11 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
 	struct i40iw_ucq *iwucq = to_i40iw_ucq(cq);
 	int ret;
 
+	ret = ibv_cmd_destroy_cq(cq);
+	if (ret)
+		return ret;
+
 	ibv_cmd_dereg_mr(&iwucq->mr);
-	if (ibv_cmd_destroy_cq(cq))
-		fprintf(stderr, PFX "%s: failed to destroy CQ\n", __func__);
 
 	free(iwucq->cq.cq_base);
 	ret = pthread_spin_destroy(&iwucq->lock);
@@ -460,16 +462,24 @@ void i40iw_cq_event(struct ibv_cq *cq)
 	pthread_spin_unlock(&iwucq->lock);
 }
 
-static void i40iw_destroy_vmapped_qp(struct i40iw_uqp *iwuqp,
+static int i40iw_destroy_vmapped_qp(struct i40iw_uqp *iwuqp,
 					struct i40iw_qp_quanta *sq_base)
 {
+	int ret;
+
+	ret = ibv_cmd_destroy_qp(&iwuqp->ibv_qp);
+	if (ret)
+		return ret;
+
 	if (iwuqp->push_db)
 		munmap(iwuqp->push_db, I40IW_HW_PAGE_SIZE);
 	if (iwuqp->push_wqe)
 		munmap(iwuqp->push_wqe, I40IW_HW_PAGE_SIZE);
-	ibv_cmd_destroy_qp(&iwuqp->ibv_qp);
+
 	ibv_cmd_dereg_mr(&iwuqp->mr);
 	free((void *)sq_base);
+
+	return 0;
 }
 
 /**
@@ -759,7 +769,9 @@ int i40iw_udestroy_qp(struct ibv_qp *qp)
 	struct i40iw_uqp *iwuqp = to_i40iw_uqp(qp);
 	int ret;
 
-	i40iw_destroy_vmapped_qp(iwuqp, iwuqp->qp.sq_base);
+	ret = i40iw_destroy_vmapped_qp(iwuqp, iwuqp->qp.sq_base);
+	if (ret)
+		return ret;
 
 	if (iwuqp->qp.sq_wrtrk_array)
 		free(iwuqp->qp.sq_wrtrk_array);
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
