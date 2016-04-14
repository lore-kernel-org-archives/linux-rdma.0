From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] IB/hfi1: Serialize hrtimer function calls
Date: Thu, 14 Apr 2016 08:31:53 -0700
Message-ID: <20160414153153.3322.83164.stgit@scvm10.sc.intel.com>
References: <20160414152929.3322.38247.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414152929.3322.38247.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hrtimer functions do not guarantee serialization, so we extend the
cca_timer_lock to cover the hrtimer_forward_now() in the hrtimer
callback handler and the hrtimer_start() in process_becn(). This
prevents races between these 2 functions to update the hrtimer state
leading to problems such as:
kernel BUG at kernel/hrtimer.c:1282!
encountered during validation of the CCA feature.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |   20 +++++++++-----------
 drivers/staging/rdma/hfi1/rc.c   |    7 +++----
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 991a49d..7be814f 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -422,9 +422,10 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 	struct cca_timer *cca_timer;
 	struct hfi1_pportdata *ppd;
 	int sl;
-	u16 ccti, ccti_timer, ccti_min;
+	u16 ccti_timer, ccti_min;
 	struct cc_state *cc_state;
 	unsigned long flags;
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
 	cca_timer = container_of(t, struct cca_timer, hrtimer);
 	ppd = cca_timer->ppd;
@@ -450,24 +451,21 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 
 	spin_lock_irqsave(&ppd->cca_timer_lock, flags);
 
-	ccti = cca_timer->ccti;
-
-	if (ccti > ccti_min) {
+	if (cca_timer->ccti > ccti_min) {
 		cca_timer->ccti--;
 		set_link_ipg(ppd);
 	}
 
-	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
-
-	rcu_read_unlock();
-
-	if (ccti > ccti_min) {
+	if (cca_timer->ccti > ccti_min) {
 		unsigned long nsec = 1024 * ccti_timer;
 		/* ccti_timer is in units of 1.024 usec */
 		hrtimer_forward_now(t, ns_to_ktime(nsec));
-		return HRTIMER_RESTART;
+		ret = HRTIMER_RESTART;
 	}
-	return HRTIMER_NORESTART;
+
+	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index c614779..792f15e 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -2021,8 +2021,6 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 	if (sl >= OPA_MAX_SLS)
 		return;
 
-	cca_timer = &ppd->cca_timer[sl];
-
 	cc_state = get_cc_state(ppd);
 
 	if (!cc_state)
@@ -2041,6 +2039,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 
 	spin_lock_irqsave(&ppd->cca_timer_lock, flags);
 
+	cca_timer = &ppd->cca_timer[sl];
 	if (cca_timer->ccti < ccti_limit) {
 		if (cca_timer->ccti + ccti_incr <= ccti_limit)
 			cca_timer->ccti += ccti_incr;
@@ -2049,8 +2048,6 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 		set_link_ipg(ppd);
 	}
 
-	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
-
 	ccti = cca_timer->ccti;
 
 	if (!hrtimer_active(&cca_timer->hrtimer)) {
@@ -2061,6 +2058,8 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 			      HRTIMER_MODE_REL);
 	}
 
+	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
+
 	if ((trigger_threshold != 0) && (ccti >= trigger_threshold))
 		log_cca_event(ppd, sl, rlid, lqpn, rqpn, svc_type);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
