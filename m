From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/8] i40iw: Remove unnecessary parameter to i40iw_cq_poll_completion
Date: Tue, 12 Jul 2016 11:48:42 -0500
Message-ID: <1468342126-29168-5-git-send-email-shiraz.saleem@intel.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Post_cq parameter passed to i40iw_cq_poll_completion is always
true; so remove.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 11 ++++-------
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index e35faea8..cea0b8a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -753,8 +753,7 @@ static enum i40iw_status_code i40iw_cq_post_entries(struct i40iw_cq_uk *cq,
  * @post_cq: update cq tail
  */
 static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
-						       struct i40iw_cq_poll_info *info,
-						       bool post_cq)
+						       struct i40iw_cq_poll_info *info)
 {
 	u64 comp_ctx, qword0, qword2, qword3, wqe_qword;
 	u64 *cqe, *sw_wqe;
@@ -878,11 +877,9 @@ exit:
 		if (I40IW_RING_GETCURRENT_HEAD(cq->cq_ring) == 0)
 			cq->polarity ^= 1;
 
-		if (post_cq) {
-			I40IW_RING_MOVE_TAIL(cq->cq_ring);
-			set_64bit_val(cq->shadow_area, 0,
-				      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
-		}
+		I40IW_RING_MOVE_TAIL(cq->cq_ring);
+		set_64bit_val(cq->shadow_area, 0,
+			      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
 	} else {
 		if (info->is_srq)
 			return ret_code;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 4627646..276bcef 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -327,7 +327,7 @@ struct i40iw_cq_ops {
 	void (*iw_cq_request_notification)(struct i40iw_cq_uk *,
 					   enum i40iw_completion_notify);
 	enum i40iw_status_code (*iw_cq_poll_completion)(struct i40iw_cq_uk *,
-							struct i40iw_cq_poll_info *, bool);
+							struct i40iw_cq_poll_info *);
 	enum i40iw_status_code (*iw_cq_post_entries)(struct i40iw_cq_uk *, u8 count);
 	void (*iw_cq_clean)(void *, struct i40iw_cq_uk *);
 };
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 73c441b..65ad249 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2259,7 +2259,7 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 
 	spin_lock_irqsave(&iwcq->lock, flags);
 	while (cqe_count < num_entries) {
-		ret = ukcq->ops.iw_cq_poll_completion(ukcq, &cq_poll_info, true);
+		ret = ukcq->ops.iw_cq_poll_completion(ukcq, &cq_poll_info);
 		if (ret == I40IW_ERR_QUEUE_EMPTY) {
 			break;
 		} else if (ret == I40IW_ERR_QUEUE_DESTROYED) {
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
