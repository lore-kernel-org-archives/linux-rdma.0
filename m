From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libi40iw] fix remaining potential leaks of info arrays and iwuqp
Date: Thu, 28 Jul 2016 15:09:23 -0400
Message-ID: <1469732963-58257-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we get to err_destroy_qp, we still need to free info.rq_wrid_array and
info.sq_wrtrk_array, so just slide the return down after those respective
free() calls, and free iwuqp before gotos below err_destroy_qp, so we do
call free() iwuqp, but only once (i40iw_udestroy_qp() also free()'s it).

Fixes: 5f13b882d (libi40iw: Add return code check for pthread_spin calls)
CC: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/i40iw_uverbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/i40iw_uverbs.c b/src/i40iw_uverbs.c
index ec5f77e..e5753e0 100644
--- a/src/i40iw_uverbs.c
+++ b/src/i40iw_uverbs.c
@@ -698,6 +698,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 	info.rq_wrid_array = calloc(rqdepth, sizeof(*info.rq_wrid_array));
 	if (!info.rq_wrid_array) {
 		fprintf(stderr, PFX "%s: failed to allocate memory for RQ work array\n", __func__);
+		free(iwuqp);
 		goto err_free_sq_wrtrk;
 	}
 
@@ -707,6 +708,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 
 	if (!status) {
 		fprintf(stderr, PFX "%s: failed to map QP\n", __func__);
+		free(iwuqp);
 		goto err_free_rq_wrid;
 	}
 	info.qp_id = resp.qp_id;
@@ -728,12 +730,12 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 
 err_destroy_qp:
 	i40iw_udestroy_qp(&iwuqp->ibv_qp);
-	return NULL;
-
 err_free_rq_wrid:
 	free(info.rq_wrid_array);
 err_free_sq_wrtrk:
 	free(info.sq_wrtrk_array);
+	return NULL;
+
 err_destroy_lock:
 	if (pthread_spin_destroy(&iwuqp->lock))
 		return NULL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
