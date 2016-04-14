From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] IB/hfi1: Correctly report neighbor link down reason
Date: Thu, 14 Apr 2016 08:31:42 -0700
Message-ID: <20160414153141.3322.62687.stgit@scvm10.sc.intel.com>
References: <20160414152929.3322.38247.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414152929.3322.38247.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The code to save the link down reason for reporting to the SMA
was in a location before the actual reason was read.  Move the
SMA link down reason assignment to a better location.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 45ff8ae..dcae8e7 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6951,6 +6951,15 @@ void handle_link_down(struct work_struct *work)
 
 	set_link_down_reason(ppd, lcl_reason, neigh_reason, 0);
 
+	/* inform the SMA when the link transitions from up to down */
+	if (was_up && ppd->local_link_down_reason.sma == 0 &&
+	    ppd->neigh_link_down_reason.sma == 0) {
+		ppd->local_link_down_reason.sma =
+					ppd->local_link_down_reason.latest;
+		ppd->neigh_link_down_reason.sma =
+					ppd->neigh_link_down_reason.latest;
+	}
+
 	reset_neighbor_info(ppd);
 
 	/* disable the port */
@@ -10106,7 +10115,6 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 	struct hfi1_devdata *dd = ppd->dd;
 	struct ib_event event = {.device = NULL};
 	int ret1, ret = 0;
-	int was_up, is_down;
 	int orig_new_state, poll_bounce;
 
 	mutex_lock(&ppd->hls_lock);
@@ -10125,8 +10133,6 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		    poll_bounce ? "(bounce) " : "",
 		    link_state_reason_name(ppd, state));
 
-	was_up = !!(ppd->host_link_state & HLS_UP);
-
 	/*
 	 * If we're going to a (HLS_*) link state that implies the logical
 	 * link state is neither of (IB_PORT_ARMED, IB_PORT_ACTIVE), then
@@ -10337,17 +10343,6 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		break;
 	}
 
-	is_down = !!(ppd->host_link_state & (HLS_DN_POLL |
-			HLS_DN_DISABLE | HLS_DN_OFFLINE));
-
-	if (was_up && is_down && ppd->local_link_down_reason.sma == 0 &&
-	    ppd->neigh_link_down_reason.sma == 0) {
-		ppd->local_link_down_reason.sma =
-		  ppd->local_link_down_reason.latest;
-		ppd->neigh_link_down_reason.sma =
-		  ppd->neigh_link_down_reason.latest;
-	}
-
 	goto done;
 
 unexpected:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
