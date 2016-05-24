From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/10] IB/hfi1: Update pkey table properly after link down
 or FM start
Date: Tue, 24 May 2016 12:50:47 -0700
Message-ID: <20160524195045.19706.93754.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When FM is disabled, and the HFI port on the switch is
changed from MgmtAllowed=YES to MgmtAllowed=NO and the
link is bounced, FULL_MGMT_P_KEY doesn't get cleared
from the pkey table. This also occurs when the QSFP
cable is moved from a switch port with MgmtAllowed=YES
to a MgmtAllowed=NO port. Clear pkey entry properly.

Also, when the driver is loaded and the switch port is
set to MgmtAllowed=NO, FULL_MGMT_P_KEY shouldn't be added
to pkey table after FM is started. Only set FULL_MGMT_P_KEY
in the pkey table if switch port is configured to
MgmtAllowed=YES.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    9 +++++++++
 drivers/infiniband/hw/hfi1/mad.c  |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d8cc329..3b876da 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1037,6 +1037,7 @@ static void dc_shutdown(struct hfi1_devdata *);
 static void dc_start(struct hfi1_devdata *);
 static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
 			   unsigned int *np);
+static void remove_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 
 /*
  * Error interrupt table entry.  This is used as input to the interrupt
@@ -6961,6 +6962,8 @@ void handle_link_down(struct work_struct *work)
 	}
 
 	reset_neighbor_info(ppd);
+	if (ppd->mgmt_allowed)
+		remove_full_mgmt_pkey(ppd);
 
 	/* disable the port */
 	clear_rcvctrl(ppd->dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
@@ -7069,6 +7072,12 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
 }
 
+static void remove_full_mgmt_pkey(struct hfi1_pportdata *ppd)
+{
+	ppd->pkeys[2] = 0;
+	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+}
+
 /*
  * Convert the given link width to the OPA link width bitmask.
  */
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 17882dc..2190295 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1403,6 +1403,12 @@ static int set_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
 		if (key == okey)
 			continue;
 		/*
+		 * Don't update pkeys[2], if an HFI port without MgmtAllowed
+		 * by neighbor is a switch.
+		 */
+		if (i == 2 && !ppd->mgmt_allowed && ppd->neighbor_type == 1)
+			continue;
+		/*
 		 * The SM gives us the complete PKey table. We have
 		 * to ensure that we put the PKeys in the matching
 		 * slots.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
