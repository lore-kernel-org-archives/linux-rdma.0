From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/8] IB/hfi1: Check xchg returned value for queuing
 link down entry
Date: Sun, 13 Aug 2017 08:08:22 -0700
Message-ID: <20170813150820.23208.12643.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Check xchg returned value for queuing link down entry
to guarantee proper atomic value reads.

Fixes: 626c077c025f ("IB/hfi1: Prevent link down request double queuing")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 24fda52..a6c6534 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7810,16 +7810,22 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	if (queue_link_down) {
 		/*
 		 * if the link is already going down or disabled, do not
-		 * queue another
+		 * queue another. If there's a link down entry already
+		 * queued, don't queue another one.
 		 */
 		if ((ppd->host_link_state &
 		    (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN)) ||
-		    ppd->link_enabled == 0 || ppd->is_link_down_queued) {
-			dd_dev_info(dd, "%s: not queuing link down\n",
-				    __func__);
+		    ppd->link_enabled == 0) {
+			dd_dev_info(dd, "%s: not queuing link down. host_link_state %x, link_enabled %x\n",
+				    __func__, ppd->host_link_state,
+				    ppd->link_enabled);
 		} else {
-			xchg(&ppd->is_link_down_queued, 1);
-			queue_work(ppd->link_wq, &ppd->link_down_work);
+			if (xchg(&ppd->is_link_down_queued, 1) == 1)
+				dd_dev_info(dd,
+					    "%s: link down request already queued\n",
+					    __func__);
+			else
+				queue_work(ppd->link_wq, &ppd->link_down_work);
 		}
 	}
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
