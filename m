From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 09/13] IB/hfi1: Fix code consistency for if/else
 blocks in chip.c
Date: Mon, 24 Jul 2017 07:46:18 -0700
Message-ID: <20170724144617.10034.64897.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Code structure is not consistent for if/else blocks and break
instructions in set_link_state for case HLS_UP_INIT. Physical
state uses break in case of an error and if/else blocks for
logical use cases. These blocks should be implemented consistently.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a62ef4a..789dbc4 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10569,18 +10569,19 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			dd_dev_err(dd,
 				   "%s: logical state did not change to INIT\n",
 				   __func__);
-		} else {
-			/* clear old transient LINKINIT_REASON code */
-			if (ppd->linkinit_reason >= OPA_LINKINIT_REASON_CLEAR)
-				ppd->linkinit_reason =
-					OPA_LINKINIT_REASON_LINKUP;
+			break;
+		}
 
-			/* enable the port */
-			add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+		/* clear old transient LINKINIT_REASON code */
+		if (ppd->linkinit_reason >= OPA_LINKINIT_REASON_CLEAR)
+			ppd->linkinit_reason =
+				OPA_LINKINIT_REASON_LINKUP;
 
-			handle_linkup_change(dd, 1);
-			ppd->host_link_state = HLS_UP_INIT;
-		}
+		/* enable the port */
+		add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+
+		handle_linkup_change(dd, 1);
+		ppd->host_link_state = HLS_UP_INIT;
 		break;
 	case HLS_UP_ARMED:
 		if (ppd->host_link_state != HLS_UP_INIT)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
