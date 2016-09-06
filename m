From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/13] IB/hfi1: Move serdes tune inside link start
 function
Date: Tue, 06 Sep 2016 04:35:20 -0700
Message-ID: <20160906113511.27413.86328.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All calls to tune_serdes and start_link are paired.  Move
tune_serdes inside start_link.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   22 ++++++++--------------
 drivers/infiniband/hw/hfi1/mad.c  |    1 -
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 8e657db..cdc388c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6825,7 +6825,6 @@ void handle_link_up(struct work_struct *work)
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SPEED_POLICY, 0,
 				     OPA_LINKDOWN_REASON_SPEED_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
-		tune_serdes(ppd);
 		start_link(ppd);
 	}
 }
@@ -6998,12 +6997,10 @@ void handle_link_down(struct work_struct *work)
 	 * If there is no cable attached, turn the DC off. Otherwise,
 	 * start the link bring up.
 	 */
-	if (ppd->port_type == PORT_TYPE_QSFP && !qsfp_mod_present(ppd)) {
+	if (ppd->port_type == PORT_TYPE_QSFP && !qsfp_mod_present(ppd))
 		dc_shutdown(ppd->dd);
-	} else {
-		tune_serdes(ppd);
+	else
 		start_link(ppd);
-	}
 }
 
 void handle_link_bounce(struct work_struct *work)
@@ -7016,7 +7013,6 @@ void handle_link_bounce(struct work_struct *work)
 	 */
 	if (ppd->host_link_state & HLS_UP) {
 		set_link_state(ppd, HLS_DN_OFFLINE);
-		tune_serdes(ppd);
 		start_link(ppd);
 	} else {
 		dd_dev_info(ppd->dd, "%s: link not up (%s), nothing to do\n",
@@ -7531,7 +7527,6 @@ done:
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_WIDTH_POLICY, 0,
 				     OPA_LINKDOWN_REASON_WIDTH_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
-		tune_serdes(ppd);
 		start_link(ppd);
 	}
 }
@@ -9161,6 +9156,12 @@ set_local_link_attributes_fail:
  */
 int start_link(struct hfi1_pportdata *ppd)
 {
+	/*
+	 * Tune the SerDes to a ballpark setting for optimal signal and bit
+	 * error rate.  Needs to be done before starting the link.
+	 */
+	tune_serdes(ppd);
+
 	if (!ppd->link_enabled) {
 		dd_dev_info(ppd->dd,
 			    "%s: stopping link start because link is disabled\n",
@@ -9401,8 +9402,6 @@ void qsfp_event(struct work_struct *work)
 		 */
 		set_qsfp_int_n(ppd, 1);
 
-		tune_serdes(ppd);
-
 		start_link(ppd);
 	}
 
@@ -9544,11 +9543,6 @@ static void try_start_link(struct hfi1_pportdata *ppd)
 	}
 	ppd->qsfp_retry_count = 0;
 
-	/*
-	 * Tune the SerDes to a ballpark setting for optimal signal and bit
-	 * error rate.  Needs to be done before starting the link.
-	 */
-	tune_serdes(ppd);
 	start_link(ppd);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 39e42c3..46767e0 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1013,7 +1013,6 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 			 * offline.
 			 */
 			set_link_state(ppd, HLS_DN_OFFLINE);
-			tune_serdes(ppd);
 			start_link(ppd);
 		} else {
 			set_link_state(ppd, link_state);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
