From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/11] IB/hfi1: Allow MgmtAllowed on B2B setups
Date: Mon, 06 Nov 2017 06:38:16 -0800
Message-ID: <20171106143812.27539.94427.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

HFI's are hard-wired to send Device Info frames with
MgmtAllowed bit set to 0. This means in B2B setups,
MgmtAllowed would never be allowed, which prevents
remote opa management tools from working properly.

Assume MgmtAllowed if a neighbor is also an HFI.

Fixes: 98b9ee2002a8 ("IB/hfi1: Cache neighbor secure data after link up")
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   39 +---------------------------------
 drivers/infiniband/hw/hfi1/hfi.h  |    3 +++
 drivers/infiniband/hw/hfi1/intr.c |   43 +++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 05e03a0..2523b62 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1036,7 +1036,6 @@ static void read_vc_local_link_width(struct hfi1_devdata *dd, u8 *misc_bits,
 				     u8 *flag_bits, u16 *link_widths);
 static void read_remote_device_id(struct hfi1_devdata *dd, u16 *device_id,
 				  u8 *device_rev);
-static void read_mgmt_allowed(struct hfi1_devdata *dd, u8 *mgmt_allowed);
 static void read_local_lni(struct hfi1_devdata *dd, u8 *enable_lane_rx);
 static int read_tx_settings(struct hfi1_devdata *dd, u8 *enable_lane_tx,
 			    u8 *tx_polarity_inversion,
@@ -7197,27 +7196,6 @@ static int lcb_to_port_ltp(int lcb_crc)
 	return port_ltp;
 }
 
-/*
- * Our neighbor has indicated that we are allowed to act as a fabric
- * manager, so place the full management partition key in the second
- * (0-based) pkey array position (see OPAv1, section 20.2.2.6.8). Note
- * that we should already have the limited management partition key in
- * array element 1, and also that the port is not yet up when
- * add_full_mgmt_pkey() is invoked.
- */
-static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
-{
-	struct hfi1_devdata *dd = ppd->dd;
-
-	/* Sanity check - ppd->pkeys[2] should be 0, or already initialized */
-	if (!((ppd->pkeys[2] == 0) || (ppd->pkeys[2] == FULL_MGMT_P_KEY)))
-		dd_dev_warn(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
-			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
-	ppd->pkeys[2] = FULL_MGMT_P_KEY;
-	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
-	hfi1_event_pkey_change(ppd->dd, ppd->port);
-}
-
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 {
 	if (ppd->pkeys[2] != 0) {
@@ -7414,11 +7392,7 @@ void handle_verify_cap(struct work_struct *work)
 			      &partner_supported_crc);
 	read_vc_remote_link_width(dd, &remote_tx_rate, &link_widths);
 	read_remote_device_id(dd, &device_id, &device_rev);
-	/*
-	 * And the 'MgmtAllowed' information, which is exchanged during
-	 * LNI, is also be available at this point.
-	 */
-	read_mgmt_allowed(dd, &ppd->mgmt_allowed);
+
 	/* print the active widths */
 	get_link_widths(dd, &active_tx, &active_rx);
 	dd_dev_info(dd,
@@ -7546,9 +7520,6 @@ void handle_verify_cap(struct work_struct *work)
 	write_csr(dd, DC_LCB_ERR_EN, 0); /* mask LCB errors */
 	set_8051_lcb_access(dd);
 
-	if (ppd->mgmt_allowed)
-		add_full_mgmt_pkey(ppd);
-
 	/* tell the 8051 to go to LinkUp */
 	set_link_state(ppd, HLS_GOING_UP);
 }
@@ -8960,14 +8931,6 @@ static void read_local_lni(struct hfi1_devdata *dd, u8 *enable_lane_rx)
 	*enable_lane_rx = (frame >> ENABLE_LANE_RX_SHIFT) & ENABLE_LANE_RX_MASK;
 }
 
-static void read_mgmt_allowed(struct hfi1_devdata *dd, u8 *mgmt_allowed)
-{
-	u32 frame;
-
-	read_8051_config(dd, REMOTE_LNI_INFO, GENERAL_CONFIG, &frame);
-	*mgmt_allowed = (frame >> MGMT_ALLOWED_SHIFT) & MGMT_ALLOWED_MASK;
-}
-
 static void read_last_local_state(struct hfi1_devdata *dd, u32 *lls)
 {
 	read_8051_config(dd, LAST_LOCAL_STATE_COMPLETE, GENERAL_CONFIG, lls);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 08d394f..4a9b4d7 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -95,6 +95,9 @@
 #define DROP_PACKET_OFF		0
 #define DROP_PACKET_ON		1
 
+#define NEIGHBOR_TYPE_HFI		0
+#define NEIGHBOR_TYPE_SWITCH	1
+
 extern unsigned long hfi1_cap_mask;
 #define HFI1_CAP_KGET_MASK(mask, cap) ((mask) & HFI1_CAP_##cap)
 #define HFI1_CAP_UGET_MASK(mask, cap) \
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 3e3184d..387305b 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -55,6 +55,40 @@
 
 #define LINK_UP_DELAY  500  /* in microseconds */
 
+static void set_mgmt_allowed(struct hfi1_pportdata *ppd)
+{
+	u32 frame;
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if (ppd->neighbor_type == NEIGHBOR_TYPE_HFI) {
+		ppd->mgmt_allowed = 1;
+	} else {
+		read_8051_config(dd, REMOTE_LNI_INFO, GENERAL_CONFIG, &frame);
+		ppd->mgmt_allowed = (frame >> MGMT_ALLOWED_SHIFT)
+		& MGMT_ALLOWED_MASK;
+	}
+}
+
+/*
+ * Our neighbor has indicated that we are allowed to act as a fabric
+ * manager, so place the full management partition key in the second
+ * (0-based) pkey array position. Note that we should already have
+ * the limited management partition key in array element 1, and also
+ * that the port is not yet up when add_full_mgmt_pkey() is invoked.
+ */
+static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	/* Sanity check - ppd->pkeys[2] should be 0, or already initialized */
+	if (!((ppd->pkeys[2] == 0) || (ppd->pkeys[2] == FULL_MGMT_P_KEY)))
+		dd_dev_warn(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
+			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
+	ppd->pkeys[2] = FULL_MGMT_P_KEY;
+	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+	hfi1_event_pkey_change(ppd->dd, ppd->port);
+}
+
 /**
  * format_hwmsg - format a single hwerror message
  * @msg message buffer
@@ -163,6 +197,15 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		/* HW needs LINK_UP_DELAY to settle, give it that chance */
 		udelay(LINK_UP_DELAY);
 
+		/*
+		 * 'MgmtAllowed' information, which is exchanged during
+		 * LNI, is available at this point.
+		 */
+		set_mgmt_allowed(ppd);
+
+		if (ppd->mgmt_allowed)
+			add_full_mgmt_pkey(ppd);
+
 		/* physical link went up */
 		ppd->linkup = 1;
 		ppd->offline_disabled_reason =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
