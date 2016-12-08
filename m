From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 02/10] i40iw: Remove unnecessary parameter
Date: Thu,  8 Dec 2016 12:16:33 -0600
Message-ID: <1481221001-1044-3-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481221001-1044-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove unnecessary parameter which is always true.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uk.c     | 11 ++++-------
 providers/i40iw/i40iw_user.h   |  2 +-
 providers/i40iw/i40iw_uverbs.c |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index 4d353b5..341772e 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -760,8 +760,7 @@ static enum i40iw_status_code i40iw_cq_post_entries(struct i40iw_cq_uk *cq,
  * @post_cq: update cq tail
  */
 static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
-						       struct i40iw_cq_poll_info *info,
-						       bool post_cq)
+						       struct i40iw_cq_poll_info *info)
 {
 	u64 comp_ctx, qword0, qword2, qword3, wqe_qword;
 	u64 *cqe, *sw_wqe;
@@ -885,11 +884,9 @@ exit:
 		if (I40IW_RING_GETCURRENT_HEAD(cq->cq_ring) == 0)
 			cq->polarity ^= 1;
 
-		if (post_cq) {
-			I40IW_RING_MOVE_TAIL(cq->cq_ring);
-			set_64bit_val(cq->shadow_area, I40IW_BYTE_0,
-				      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
-		}
+		I40IW_RING_MOVE_TAIL(cq->cq_ring);
+		set_64bit_val(cq->shadow_area, I40IW_BYTE_0,
+			      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
 	} else {
 		if (info->is_srq)
 			return ret_code;
diff --git a/providers/i40iw/i40iw_user.h b/providers/i40iw/i40iw_user.h
index ab96ed3..8d345b3 100644
--- a/providers/i40iw/i40iw_user.h
+++ b/providers/i40iw/i40iw_user.h
@@ -327,7 +327,7 @@ struct i40iw_cq_ops {
 	void (*iw_cq_request_notification)(struct i40iw_cq_uk *,
 					   enum i40iw_completion_notify);
 	enum i40iw_status_code (*iw_cq_poll_completion)(struct i40iw_cq_uk *,
-							struct i40iw_cq_poll_info *, bool);
+							struct i40iw_cq_poll_info *);
 	enum i40iw_status_code (*iw_cq_post_entries)(struct i40iw_cq_uk *, u8 count);
 	void (*iw_cq_clean)(void *, struct i40iw_cq_uk *);
 };
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index a117b53..651a91d 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -337,7 +337,7 @@ int i40iw_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	if (ret)
 		return ret;
 	while (cqe_count < num_entries) {
-		ret = iwucq->cq.ops.iw_cq_poll_completion(&iwucq->cq, &cq_poll_info, true);
+		ret = iwucq->cq.ops.iw_cq_poll_completion(&iwucq->cq, &cq_poll_info);
 		if (ret == I40IW_ERR_QUEUE_EMPTY) {
 			break;
 		} else if (ret) {
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
