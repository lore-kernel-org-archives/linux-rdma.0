From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/13] IB/hfi1: Verify port data VLs credits on
 transition to Armed
Date: Mon, 24 Jul 2017 07:46:36 -0700
Message-ID: <20170724144635.10034.72572.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a window where the FM can read the buffer control table
and decide not to program buffers. When a port goes down, the code
clears the table and if it is not programmed, posted SDMA descriptors
will never complete due to no buffer credits.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   16 +++++++++++++++-
 drivers/infiniband/hw/hfi1/intr.c |    1 +
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 4a4405e..8f7ce74 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10490,6 +10490,14 @@ void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
 }
 
 /*
+ * Verify if BCT for data VLs is non-zero.
+ */
+static inline bool data_vls_operational(struct hfi1_pportdata *ppd)
+{
+	return !!ppd->actual_vls_operational;
+}
+
+/*
  * Change the physical and/or logical link state.
  *
  * Do not call this routine while inside an interrupt.  It contains
@@ -10587,6 +10595,13 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 		if (ppd->host_link_state != HLS_UP_INIT)
 			goto unexpected;
 
+		if (!data_vls_operational(ppd)) {
+			dd_dev_err(dd,
+				   "%s: data VLs not operational\n", __func__);
+			ret = -EINVAL;
+			break;
+		}
+
 		ppd->host_link_state = HLS_UP_ARMED;
 		set_logical_state(dd, LSTATE_ARMED);
 		ret = wait_logical_linkstate(ppd, IB_PORT_ARMED, 1000);
@@ -14832,7 +14847,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		}
 		ppd->vls_supported = num_vls;
 		ppd->vls_operational = ppd->vls_supported;
-		ppd->actual_vls_operational = ppd->vls_supported;
 		/* Set the default MTU. */
 		for (vl = 0; vl < num_vls; vl++)
 			dd->vld[vl].mtu = hfi1_max_mtu;
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 9469be9..96845df 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -164,6 +164,7 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		ppd->linkup = 0;
 
 		/* clear HW details of the previous connection */
+		ppd->actual_vls_operational = 0;
 		reset_link_credits(dd);
 
 		/* freeze after a link down to guarantee a clean egress */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
