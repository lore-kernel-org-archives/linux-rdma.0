From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/8] IB/hfi1: Harden state transition to Armed and
 Active
Date: Sat, 29 Jul 2017 08:43:20 -0700
Message-ID: <20170729154319.21487.5818.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a window that allows other threads to read state of
'host_link_state' as a new, before the hardware actual state is set.
This patch closes the window by indicating a new state only after
hardware transition is complete.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 8f7ce74..eca31dd 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10602,16 +10602,15 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			break;
 		}
 
-		ppd->host_link_state = HLS_UP_ARMED;
 		set_logical_state(dd, LSTATE_ARMED);
 		ret = wait_logical_linkstate(ppd, IB_PORT_ARMED, 1000);
 		if (ret) {
-			/* logical state didn't change, stay at init */
-			ppd->host_link_state = HLS_UP_INIT;
 			dd_dev_err(dd,
 				   "%s: logical state did not change to ARMED\n",
 				   __func__);
+			break;
 		}
+		ppd->host_link_state = HLS_UP_ARMED;
 		/*
 		 * The simulator does not currently implement SMA messages,
 		 * so neighbor_normal is not set.  Set it here when we first
@@ -10624,18 +10623,16 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		if (ppd->host_link_state != HLS_UP_ARMED)
 			goto unexpected;
 
-		ppd->host_link_state = HLS_UP_ACTIVE;
 		set_logical_state(dd, LSTATE_ACTIVE);
 		ret = wait_logical_linkstate(ppd, IB_PORT_ACTIVE, 1000);
 		if (ret) {
-			/* logical state didn't change, stay at armed */
-			ppd->host_link_state = HLS_UP_ARMED;
 			dd_dev_err(dd,
 				   "%s: logical state did not change to ACTIVE\n",
 				   __func__);
 		} else {
 			/* tell all engines to go running */
 			sdma_all_running(dd);
+			ppd->host_link_state = HLS_UP_ACTIVE;
 
 			/* Signal the IB layer that the port has went active */
 			event.device = &dd->verbs_dev.rdi.ibdev;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
