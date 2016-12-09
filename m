From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 07/10] i40iw: Do not destroy QP/CQ if lock is held
Date: Fri,  9 Dec 2016 11:55:01 -0600
Message-ID: <1481306104-19352-8-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Destroy the QP/CQ if their lock can be destroyed first.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uverbs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index ef381ed..f6d9196 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -305,6 +305,10 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
 	struct i40iw_ucq *iwucq = to_i40iw_ucq(cq);
 	int ret;
 
+	ret = pthread_spin_destroy(&iwucq->lock);
+	if (ret)
+		return ret;
+
 	ret = ibv_cmd_destroy_cq(cq);
 	if (ret)
 		return ret;
@@ -312,9 +316,6 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
 	ibv_cmd_dereg_mr(&iwucq->mr);
 
 	free(iwucq->cq.cq_base);
-	ret = pthread_spin_destroy(&iwucq->lock);
-	if (ret)
-		return ret;
 	free(iwucq);
 
 	return 0;
@@ -769,6 +770,10 @@ int i40iw_udestroy_qp(struct ibv_qp *qp)
 	struct i40iw_uqp *iwuqp = to_i40iw_uqp(qp);
 	int ret;
 
+	ret = pthread_spin_destroy(&iwuqp->lock);
+	if (ret)
+		return ret;
+
 	ret = i40iw_destroy_vmapped_qp(iwuqp, iwuqp->qp.sq_base);
 	if (ret)
 		return ret;
@@ -784,10 +789,9 @@ int i40iw_udestroy_qp(struct ibv_qp *qp)
 	if ((iwuqp->recv_cq) && (iwuqp->recv_cq != iwuqp->send_cq))
 		i40iw_clean_cq((void *)&iwuqp->qp, &iwuqp->recv_cq->cq);
 
-	ret = pthread_spin_destroy(&iwuqp->lock);
 	free(iwuqp);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
