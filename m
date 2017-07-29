From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/8] IB/hfi1: Prevent link down request double
 queuing
Date: Sat, 29 Jul 2017 08:43:55 -0700
Message-ID: <20170729154354.21487.40796.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When link interrupts occur, multiple link down requests
could be queued up when only one is needed. This could get
the hfi1 out of sync with its link partner during LNI.

Only allow one link down request to be queued at any one time.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 +++-
 drivers/infiniband/hw/hfi1/hfi.h  |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 8443d41..a3af46c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7045,6 +7045,7 @@ void handle_link_down(struct work_struct *work)
 	/* Go offline first, then deal with reading/writing through 8051 */
 	was_up = !!(ppd->host_link_state & HLS_UP);
 	set_link_state(ppd, HLS_DN_OFFLINE);
+	xchg(&ppd->is_link_down_queued, 0);
 
 	if (was_up) {
 		lcl_reason = 0;
@@ -7805,10 +7806,11 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		 */
 		if ((ppd->host_link_state &
 		    (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN)) ||
-		    ppd->link_enabled == 0) {
+		    ppd->link_enabled == 0 || ppd->is_link_down_queued) {
 			dd_dev_info(dd, "%s: not queuing link down\n",
 				    __func__);
 		} else {
+			xchg(&ppd->is_link_down_queued, 1);
 			queue_work(ppd->link_wq, &ppd->link_down_work);
 		}
 	}
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index ee6c389..fb5f839 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -644,6 +644,7 @@ struct hfi1_pportdata {
 	/* placeholders for IB MAD packet settings */
 	u8 overrun_threshold;
 	u8 phy_error_threshold;
+	unsigned int is_link_down_queued;
 
 	/* Used to override LED behavior for things like maintenance beaconing*/
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
