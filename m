From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 02/13] staging/rdma/hfi1: Fix downgrade race
Date: Mon, 16 Nov 2015 21:59:24 -0500
Message-ID: <1447729175-28745-3-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A link downgrade can race with link up. Avoid the race
in two ways. First, by having the downgrade application logic
take the link state mutex for all of its checking. Second, by
waiting for the link to move out of the going up state.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index d858f36..6c942f6 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -3907,18 +3907,32 @@ void handle_verify_cap(struct work_struct *work)
  */
 void apply_link_downgrade_policy(struct hfi1_pportdata *ppd, int refresh_widths)
 {
-	int skip = 1;
 	int do_bounce = 0;
-	u16 lwde = ppd->link_width_downgrade_enabled;
+	int tries;
+	u16 lwde;
 	u16 tx, rx;
 
+	/* use the hls lock to avoid a race with actual link up */
+	tries = 0;
+retry:
 	mutex_lock(&ppd->hls_lock);
 	/* only apply if the link is up */
-	if (ppd->host_link_state & HLS_UP)
-		skip = 0;
-	mutex_unlock(&ppd->hls_lock);
-	if (skip)
-		return;
+	if (!(ppd->host_link_state & HLS_UP)) {
+		/* still going up..wait and retry */
+		if (ppd->host_link_state & HLS_GOING_UP) {
+			if (++tries < 1000) {
+				mutex_unlock(&ppd->hls_lock);
+				usleep_range(100, 120); /* arbitrary */
+				goto retry;
+			}
+			dd_dev_err(ppd->dd,
+				   "%s: giving up waiting for link state change\n",
+				   __func__);
+		}
+		goto done;
+	}
+
+	lwde = ppd->link_width_downgrade_enabled;
 
 	if (refresh_widths) {
 		get_link_widths(ppd->dd, &tx, &rx);
@@ -3956,6 +3970,9 @@ void apply_link_downgrade_policy(struct hfi1_pportdata *ppd, int refresh_widths)
 		do_bounce = 1;
 	}
 
+done:
+	mutex_unlock(&ppd->hls_lock);
+
 	if (do_bounce) {
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_WIDTH_POLICY, 0,
 		  OPA_LINKDOWN_REASON_WIDTH_POLICY);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
