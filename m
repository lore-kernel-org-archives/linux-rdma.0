From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/7] IB/hfi1: Race condition between user
 notification and driver state
Date: Mon, 23 Oct 2017 06:05:45 -0700
Message-ID: <20171023130539.21191.79990.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The handler for link init state (HLS_UP_INIT) notifies userspace
(update_statusp()) before enabling the device
(RCV_CTRL_RCV_PORT_ENABLE_SMASK) or setting the device state
(ppd->host_link_state).  This causes a race condition where the
userspace thinks the interface is in the INIT state before the driver
has set that state.

Rework the code path to eliminate the race.

Delay setting the init state until after a HW settling period.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   27 ++++++++++++++++++---------
 drivers/infiniband/hw/hfi1/intr.c |   14 +++++++++++++-
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a6d61c4..3a642ea 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10317,9 +10317,6 @@ static void force_logical_link_state_down(struct hfi1_pportdata *ppd)
 	write_csr(dd, DC_LCB_CFG_ALLOW_LINK_UP, 0);
 	write_csr(dd, DC_LCB_CFG_IGNORE_LOST_RCLK, 0);
 
-	/* adjust ppd->statusp, if needed */
-	update_statusp(ppd, IB_PORT_DOWN);
-
 	dd_dev_info(ppd->dd, "logical state forced to LINK_DOWN\n");
 }
 
@@ -10401,6 +10398,7 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 		force_logical_link_state_down(ppd);
 
 	ppd->host_link_state = HLS_LINK_COOLDOWN; /* LCB access allowed */
+	update_statusp(ppd, IB_PORT_DOWN);
 
 	/*
 	 * The LNI has a mandatory wait time after the physical state
@@ -10662,6 +10660,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
 		handle_linkup_change(dd, 1);
 		ppd->host_link_state = HLS_UP_INIT;
+		update_statusp(ppd, IB_PORT_INIT);
 		break;
 	case HLS_UP_ARMED:
 		if (ppd->host_link_state != HLS_UP_INIT)
@@ -10683,6 +10682,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			break;
 		}
 		ppd->host_link_state = HLS_UP_ARMED;
+		update_statusp(ppd, IB_PORT_ARMED);
 		/*
 		 * The simulator does not currently implement SMA messages,
 		 * so neighbor_normal is not set.  Set it here when we first
@@ -10705,6 +10705,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			/* tell all engines to go running */
 			sdma_all_running(dd);
 			ppd->host_link_state = HLS_UP_ACTIVE;
+			update_statusp(ppd, IB_PORT_ACTIVE);
 
 			/* Signal the IB layer that the port has went active */
 			event.device = &dd->verbs_dev.rdi.ibdev;
@@ -12720,6 +12721,17 @@ u32 chip_to_opa_pstate(struct hfi1_devdata *dd, u32 chip_pstate)
 	return "unknown";
 }
 
+/**
+ * update_statusp - Update userspace status flag
+ * @ppd: Port data structure
+ * @state: port state information
+ *
+ * Actual port status is determined by the host_link_state value
+ * in the ppd.
+ *
+ * host_link_state MUST be updated before updating the user space
+ * statusp.
+ */
 static void update_statusp(struct hfi1_pportdata *ppd, u32 state)
 {
 	/*
@@ -12745,9 +12757,11 @@ static void update_statusp(struct hfi1_pportdata *ppd, u32 state)
 			break;
 		}
 	}
+	dd_dev_info(ppd->dd, "logical state changed to %s (0x%x)\n",
+		    opa_lstate_name(state), state);
 }
 
-/*
+/**
  * wait_logical_linkstate - wait for an IB link state change to occur
  * @ppd: port device
  * @state: the state to wait for
@@ -12778,11 +12792,6 @@ static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 		msleep(20);
 	}
 
-	update_statusp(ppd, state);
-	dd_dev_info(ppd->dd,
-		    "logical state changed to %s (0x%x)\n",
-		    opa_lstate_name(state),
-		    state);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 96845df..3e3184d 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -53,6 +53,8 @@
 #include "common.h"
 #include "sdma.h"
 
+#define LINK_UP_DELAY  500  /* in microseconds */
+
 /**
  * format_hwmsg - format a single hwerror message
  * @msg message buffer
@@ -102,9 +104,16 @@ static void signal_ib_event(struct hfi1_pportdata *ppd, enum ib_event_type ev)
 	ib_dispatch_event(&event);
 }
 
-/*
+/**
+ * handle_linkup_change - finish linkup/down state changes
+ * @dd: valid device
+ * @linkup: link state information
+ *
  * Handle a linkup or link down notification.
+ * The HW needs time to finish its link up state change. Give it that chance.
+ *
  * This is called outside an interrupt.
+ *
  */
 void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 {
@@ -151,6 +160,9 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 			    ppd->neighbor_guid, ppd->neighbor_type,
 			    ppd->neighbor_port_number);
 
+		/* HW needs LINK_UP_DELAY to settle, give it that chance */
+		udelay(LINK_UP_DELAY);
+
 		/* physical link went up */
 		ppd->linkup = 1;
 		ppd->offline_disabled_reason =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
