From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 05/10] i40iw: Remove unnecessary check for moving CQ head
Date: Thu,  8 Dec 2016 12:16:36 -0600
Message-ID: <1481221001-1044-6-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481221001-1044-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In i40iw_cq_poll_completion(), we always move the tail.
So there is no reason to check for overflow everytime
we move the head.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_d.h  | 3 +++
 providers/i40iw/i40iw_uk.c | 6 +-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/providers/i40iw/i40iw_d.h b/providers/i40iw/i40iw_d.h
index 7b58199..1906cbf 100644
--- a/providers/i40iw/i40iw_d.h
+++ b/providers/i40iw/i40iw_d.h
@@ -1586,6 +1586,9 @@ enum i40iw_alignment {
 #define I40IW_RING_MOVE_TAIL(_ring) \
 	(_ring).tail = ((_ring).tail + 1) % (_ring).size
 
+#define I40IW_RING_MOVE_HEAD_NOCHECK(_ring) \
+	(_ring).head = ((_ring).head + 1) % (_ring).size
+
 #define I40IW_RING_MOVE_TAIL_BY_COUNT(_ring, _count) \
 	(_ring).tail = ((_ring).tail + (_count)) % (_ring).size
 
diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index bf194f3..392e858 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -763,7 +763,6 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 	struct i40iw_ring *pring = NULL;
 	u32 wqe_idx, q_type, array_idx = 0;
 	enum i40iw_status_code ret_code = 0;
-	enum i40iw_status_code ret_code2 = 0;
 	bool move_cq_head = true;
 	u8 polarity;
 	u8 addl_wqes = 0;
@@ -871,10 +870,7 @@ exit:
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
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
