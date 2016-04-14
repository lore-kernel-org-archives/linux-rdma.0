From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] IB/hfi1: Use the neighbor link down reason only when
 valid
Date: Thu, 14 Apr 2016 08:31:36 -0700
Message-ID: <20160414153135.3322.57951.stgit@scvm10.sc.intel.com>
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

The 8051 uses a link down reason to inform the driver why the
link went down.  The neighbor planned link down reason code is
only valid when a link down idle message is received by the 8051.
Enhance the explanation on why the link went down.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |  133 +++++++++++++++++++++++++++++++++++---
 drivers/staging/rdma/hfi1/chip.h |    6 ++
 2 files changed, 130 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f50f1b1..45ff8ae 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1031,6 +1031,7 @@ static int thermal_init(struct hfi1_devdata *dd);
 static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 				  int msecs);
 static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc);
+static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *);
 static void dc_shutdown(struct hfi1_devdata *);
 static void dc_start(struct hfi1_devdata *);
@@ -6812,6 +6813,75 @@ static void reset_neighbor_info(struct hfi1_pportdata *ppd)
 	ppd->neighbor_fm_security = 0;
 }
 
+static const char * const link_down_reason_strs[] = {
+	[OPA_LINKDOWN_REASON_NONE] = "None",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_0] = "Recive error 0",
+	[OPA_LINKDOWN_REASON_BAD_PKT_LEN] = "Bad packet length",
+	[OPA_LINKDOWN_REASON_PKT_TOO_LONG] = "Packet too long",
+	[OPA_LINKDOWN_REASON_PKT_TOO_SHORT] = "Packet too short",
+	[OPA_LINKDOWN_REASON_BAD_SLID] = "Bad SLID",
+	[OPA_LINKDOWN_REASON_BAD_DLID] = "Bad DLID",
+	[OPA_LINKDOWN_REASON_BAD_L2] = "Bad L2",
+	[OPA_LINKDOWN_REASON_BAD_SC] = "Bad SC",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_8] = "Receive error 8",
+	[OPA_LINKDOWN_REASON_BAD_MID_TAIL] = "Bad mid tail",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_10] = "Receive error 10",
+	[OPA_LINKDOWN_REASON_PREEMPT_ERROR] = "Preempt error",
+	[OPA_LINKDOWN_REASON_PREEMPT_VL15] = "Preempt vl15",
+	[OPA_LINKDOWN_REASON_BAD_VL_MARKER] = "Bad VL marker",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_14] = "Receive error 14",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_15] = "Receive error 15",
+	[OPA_LINKDOWN_REASON_BAD_HEAD_DIST] = "Bad head distance",
+	[OPA_LINKDOWN_REASON_BAD_TAIL_DIST] = "Bad tail distance",
+	[OPA_LINKDOWN_REASON_BAD_CTRL_DIST] = "Bad control distance",
+	[OPA_LINKDOWN_REASON_BAD_CREDIT_ACK] = "Bad credit ack",
+	[OPA_LINKDOWN_REASON_UNSUPPORTED_VL_MARKER] = "Unsupported VL marker",
+	[OPA_LINKDOWN_REASON_BAD_PREEMPT] = "Bad preempt",
+	[OPA_LINKDOWN_REASON_BAD_CONTROL_FLIT] = "Bad control flit",
+	[OPA_LINKDOWN_REASON_EXCEED_MULTICAST_LIMIT] = "Exceed multicast limit",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_24] = "Receive error 24",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_25] = "Receive error 25",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_26] = "Receive error 26",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_27] = "Receive error 27",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_28] = "Receive error 28",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_29] = "Receive error 29",
+	[OPA_LINKDOWN_REASON_RCV_ERROR_30] = "Receive error 30",
+	[OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN] =
+					"Excessive buffer overrun",
+	[OPA_LINKDOWN_REASON_UNKNOWN] = "Unknown",
+	[OPA_LINKDOWN_REASON_REBOOT] = "Reboot",
+	[OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN] = "Neighbor unknown",
+	[OPA_LINKDOWN_REASON_FM_BOUNCE] = "FM bounce",
+	[OPA_LINKDOWN_REASON_SPEED_POLICY] = "Speed policy",
+	[OPA_LINKDOWN_REASON_WIDTH_POLICY] = "Width policy",
+	[OPA_LINKDOWN_REASON_DISCONNECTED] = "Disconnected",
+	[OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED] =
+					"Local media not installed",
+	[OPA_LINKDOWN_REASON_NOT_INSTALLED] = "Not installed",
+	[OPA_LINKDOWN_REASON_CHASSIS_CONFIG] = "Chassis config",
+	[OPA_LINKDOWN_REASON_END_TO_END_NOT_INSTALLED] =
+					"End to end not installed",
+	[OPA_LINKDOWN_REASON_POWER_POLICY] = "Power policy",
+	[OPA_LINKDOWN_REASON_LINKSPEED_POLICY] = "Link speed policy",
+	[OPA_LINKDOWN_REASON_LINKWIDTH_POLICY] = "Link width policy",
+	[OPA_LINKDOWN_REASON_SWITCH_MGMT] = "Switch management",
+	[OPA_LINKDOWN_REASON_SMA_DISABLED] = "SMA disabled",
+	[OPA_LINKDOWN_REASON_TRANSIENT] = "Transient"
+};
+
+/* return the neighbor link down reason string */
+static const char *link_down_reason_str(u8 reason)
+{
+	const char *str = NULL;
+
+	if (reason < ARRAY_SIZE(link_down_reason_strs))
+		str = link_down_reason_strs[reason];
+	if (!str)
+		str = "(invalid)";
+
+	return str;
+}
+
 /*
  * Handle a link down interrupt from the 8051.
  *
@@ -6820,8 +6890,11 @@ static void reset_neighbor_info(struct hfi1_pportdata *ppd)
 void handle_link_down(struct work_struct *work)
 {
 	u8 lcl_reason, neigh_reason = 0;
+	u8 link_down_reason;
 	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
-								link_down_work);
+						  link_down_work);
+	int was_up;
+	static const char ldr_str[] = "Link down reason: ";
 
 	if ((ppd->host_link_state &
 	     (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) &&
@@ -6830,17 +6903,51 @@ void handle_link_down(struct work_struct *work)
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NOT_INSTALLED);
 
 	/* Go offline first, then deal with reading/writing through 8051 */
+	was_up = !!(ppd->host_link_state & HLS_UP);
 	set_link_state(ppd, HLS_DN_OFFLINE);
 
-	lcl_reason = 0;
-	read_planned_down_reason_code(ppd->dd, &neigh_reason);
+	if (was_up) {
+		lcl_reason = 0;
+		/* link down reason is only valid if the link was up */
+		read_link_down_reason(ppd->dd, &link_down_reason);
+		switch (link_down_reason) {
+		case LDR_LINK_TRANSFER_ACTIVE_LOW:
+			/* the link went down, no idle message reason */
+			dd_dev_info(ppd->dd, "%sUnexpected link down\n",
+				    ldr_str);
+			break;
+		case LDR_RECEIVED_LINKDOWN_IDLE_MSG:
+			/*
+			 * The neighbor reason is only valid if an idle message
+			 * was received for it.
+			 */
+			read_planned_down_reason_code(ppd->dd, &neigh_reason);
+			dd_dev_info(ppd->dd,
+				    "%sNeighbor link down message %d, %s\n",
+				    ldr_str, neigh_reason,
+				    link_down_reason_str(neigh_reason));
+			break;
+		case LDR_RECEIVED_HOST_OFFLINE_REQ:
+			dd_dev_info(ppd->dd,
+				    "%sHost requested link to go offline\n",
+				    ldr_str);
+			break;
+		default:
+			dd_dev_info(ppd->dd, "%sUnknown reason 0x%x\n",
+				    ldr_str, link_down_reason);
+			break;
+		}
 
-	/*
-	 * If no reason, assume peer-initiated but missed
-	 * LinkGoingDown idle flits.
-	 */
-	if (neigh_reason == 0)
-		lcl_reason = OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN;
+		/*
+		 * If no reason, assume peer-initiated but missed
+		 * LinkGoingDown idle flits.
+		 */
+		if (neigh_reason == 0)
+			lcl_reason = OPA_LINKDOWN_REASON_NEIGHBOR_UNKNOWN;
+	} else {
+		/* went down while polling or going up */
+		lcl_reason = OPA_LINKDOWN_REASON_TRANSIENT;
+	}
 
 	set_link_down_reason(ppd, lcl_reason, neigh_reason, 0);
 
@@ -8627,6 +8734,14 @@ static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc)
 	*pdrrc = (frame >> DOWN_REMOTE_REASON_SHIFT) & DOWN_REMOTE_REASON_MASK;
 }
 
+static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr)
+{
+	u32 frame;
+
+	read_8051_config(dd, LINK_DOWN_REASON, GENERAL_CONFIG, &frame);
+	*ldr = (frame & 0xff);
+}
+
 static int read_tx_settings(struct hfi1_devdata *dd,
 			    u8 *enable_lane_tx,
 			    u8 *tx_polarity_inversion,
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index e02e006..1948706 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -389,6 +389,7 @@
 #define LAST_REMOTE_STATE_COMPLETE   0x13
 #define LINK_QUALITY_INFO            0x14
 #define REMOTE_DEVICE_ID	     0x15
+#define LINK_DOWN_REASON	     0x16
 
 /* 8051 lane specific register field IDs */
 #define TX_EQ_SETTINGS		0x00
@@ -497,6 +498,11 @@
 #define PWRM_BER_CONTROL	0x1
 #define PWRM_BANDWIDTH_CONTROL	0x2
 
+/* 8051 link down reasons */
+#define LDR_LINK_TRANSFER_ACTIVE_LOW   0xa
+#define LDR_RECEIVED_LINKDOWN_IDLE_MSG 0xb
+#define LDR_RECEIVED_HOST_OFFLINE_REQ  0xc
+
 /* verify capability fabric CRC size bits */
 enum {
 	CAP_CRC_14B = (1 << 0), /* 14b CRC */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
