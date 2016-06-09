From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/10] IB/hfi1: Remove FULL_MGMT_P_KEY from pkey table at
 link up
Date: Thu, 09 Jun 2016 07:51:57 -0700
Message-ID: <20160609145156.12702.69401.stgit@scvm10.sc.intel.com>
References: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

FULL_MGMT_P_KEY doesn't get cleared from the pkey table at link bounce
because the link down and link bounce code paths are different when
moving a QSFP cable on a switch. This causes an HFI unit connected to a
switch to try to be initialized to an FM node when the QSFP cable is
moved from a MgmtAllowed=NO port to a MgmtAllowed=YES port and back to a
MgmtAllowed=NO port. Remove FULL_MGMT_P_KEY from pkey table at link up.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c533d44..3487fdf 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1037,7 +1037,7 @@ static void dc_shutdown(struct hfi1_devdata *);
 static void dc_start(struct hfi1_devdata *);
 static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
 			   unsigned int *np);
-static void remove_full_mgmt_pkey(struct hfi1_pportdata *ppd);
+static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 
 /*
  * Error interrupt table entry.  This is used as input to the interrupt
@@ -6962,8 +6962,6 @@ void handle_link_down(struct work_struct *work)
 	}
 
 	reset_neighbor_info(ppd);
-	if (ppd->mgmt_allowed)
-		remove_full_mgmt_pkey(ppd);
 
 	/* disable the port */
 	clear_rcvctrl(ppd->dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
@@ -7072,10 +7070,12 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
 }
 
-static void remove_full_mgmt_pkey(struct hfi1_pportdata *ppd)
+static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 {
-	ppd->pkeys[2] = 0;
-	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+	if (ppd->pkeys[2] != 0) {
+		ppd->pkeys[2] = 0;
+		(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+	}
 }
 
 /*
@@ -9168,6 +9168,13 @@ int start_link(struct hfi1_pportdata *ppd)
 		return 0;
 	}
 
+	/*
+	 * FULL_MGMT_P_KEY is cleared from the pkey table, so that the
+	 * pkey table can be configured properly if the HFI unit is connected
+	 * to switch port with MgmtAllowed=NO
+	 */
+	clear_full_mgmt_pkey(ppd);
+
 	return set_link_state(ppd, HLS_DN_POLL);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
