From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/8] i40iw: Remove unnecessary check for moving CQ head
Date: Tue, 12 Jul 2016 11:48:44 -0500
Message-ID: <1468342126-29168-7-git-send-email-shiraz.saleem@intel.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In i40iw_cq_poll_completion, we always move the tail. So there is
no reason to check for overflow everytime we move the head.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_d.h  | 3 +++
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 6 +-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index bd942da..2fac1db 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1557,6 +1557,9 @@ enum i40iw_alignment {
 #define I40IW_RING_MOVE_TAIL(_ring) \
 	(_ring).tail = ((_ring).tail + 1) % (_ring).size
 
+#define I40IW_RING_MOVE_HEAD_NOCHECK(_ring) \
+	(_ring).head = ((_ring).head + 1) % (_ring).size
+
 #define I40IW_RING_MOVE_TAIL_BY_COUNT(_ring, _count) \
 	(_ring).tail = ((_ring).tail + (_count)) % (_ring).size
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 6b217e6..4d28c3c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -761,7 +761,6 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 	struct i40iw_ring *pring = NULL;
 	u32 wqe_idx, q_type, array_idx = 0;
 	enum i40iw_status_code ret_code = 0;
-	enum i40iw_status_code ret_code2 = 0;
 	bool move_cq_head = true;
 	u8 polarity;
 	u8 addl_wqes = 0;
@@ -869,10 +868,7 @@ exit:
 			move_cq_head = false;
 
 	if (move_cq_head) {
-		I40IW_RING_MOVE_HEAD(cq->cq_ring, ret_code2);
-
-		if (ret_code2 && !ret_code)
-			ret_code = ret_code2;
+		I40IW_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
 
 		if (I40IW_RING_GETCURRENT_HEAD(cq->cq_ring) == 0)
 			cq->polarity ^= 1;
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
