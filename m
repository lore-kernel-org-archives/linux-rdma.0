From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/16] IB/hfi1: Prevent LNI hang when LCB can't
 obtain lanes
Date: Fri, 26 Jan 2018 06:32:22 -0800
Message-ID: <20180126143219.6868.50396.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the LCB isn't able to get any lanes operational on the
first transition into mission mode, the link transfer active
never happens and the LNI stays in the polling state indefinitely.

Reset LCB upon receiving an 8051 interrupt for LCB to try to obtain
lanes with firmware version 1.25.0 or later. Also, update the LCB
reset value in other parts of the code with a macro defined to make
the code more maintainable and rename functions with the link_width
label to link_mode to reflect the fact that those functions set and
read link related data not just the link width.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c           |   51 +++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/chip.h           |   15 +++++++-
 drivers/infiniband/hw/hfi1/chip_registers.h |    7 +++-
 3 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a986afe..793e8b7 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1032,8 +1032,8 @@ static void read_vc_remote_fabric(struct hfi1_devdata *dd, u8 *vau, u8 *z,
 				  u8 *vcu, u16 *vl15buf, u8 *crc_sizes);
 static void read_vc_remote_link_width(struct hfi1_devdata *dd,
 				      u8 *remote_tx_rate, u16 *link_widths);
-static void read_vc_local_link_width(struct hfi1_devdata *dd, u8 *misc_bits,
-				     u8 *flag_bits, u16 *link_widths);
+static void read_vc_local_link_mode(struct hfi1_devdata *dd, u8 *misc_bits,
+				    u8 *flag_bits, u16 *link_widths);
 static void read_remote_device_id(struct hfi1_devdata *dd, u16 *device_id,
 				  u8 *device_rev);
 static void read_local_lni(struct hfi1_devdata *dd, u8 *enable_lane_rx);
@@ -6351,6 +6351,18 @@ static void handle_8051_request(struct hfi1_pportdata *ppd)
 			    type);
 		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
 		break;
+	case HREQ_LCB_RESET:
+		/* Put the LCB, RX FPE and TX FPE into reset */
+		write_csr(dd, DCC_CFG_RESET, LCB_RX_FPE_TX_FPE_INTO_RESET);
+		/* Make sure the write completed */
+		(void)read_csr(dd, DCC_CFG_RESET);
+		/* Hold the reset long enough to take effect */
+		udelay(1);
+		/* Take the LCB, RX FPE and TX FPE out of reset */
+		write_csr(dd, DCC_CFG_RESET, LCB_RX_FPE_TX_FPE_OUT_OF_RESET);
+		hreq_response(dd, HREQ_SUCCESS, 0);
+
+		break;
 	case HREQ_CONFIG_DONE:
 		hreq_response(dd, HREQ_SUCCESS, 0);
 		break;
@@ -6461,8 +6473,7 @@ static void lcb_shutdown(struct hfi1_devdata *dd, int abort)
 	dd->lcb_err_en = read_csr(dd, DC_LCB_ERR_EN);
 	reg = read_csr(dd, DCC_CFG_RESET);
 	write_csr(dd, DCC_CFG_RESET, reg |
-		  (1ull << DCC_CFG_RESET_RESET_LCB_SHIFT) |
-		  (1ull << DCC_CFG_RESET_RESET_RX_FPE_SHIFT));
+		  DCC_CFG_RESET_RESET_LCB | DCC_CFG_RESET_RESET_RX_FPE);
 	(void)read_csr(dd, DCC_CFG_RESET); /* make sure the write completed */
 	if (!abort) {
 		udelay(1);    /* must hold for the longer of 16cclks or 20ns */
@@ -6527,7 +6538,7 @@ static void _dc_start(struct hfi1_devdata *dd)
 			   __func__);
 
 	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
-	write_csr(dd, DCC_CFG_RESET, 0x10);
+	write_csr(dd, DCC_CFG_RESET, LCB_RX_FPE_TX_FPE_OUT_OF_RESET);
 	/* lcb_shutdown() with abort=1 does not restore these */
 	write_csr(dd, DC_LCB_ERR_EN, dd->lcb_err_en);
 	dd->dc_shutdown = 0;
@@ -7348,7 +7359,7 @@ static void get_linkup_widths(struct hfi1_devdata *dd, u16 *tx_width,
 	u8 misc_bits, local_flags;
 	u16 active_tx, active_rx;
 
-	read_vc_local_link_width(dd, &misc_bits, &local_flags, &widths);
+	read_vc_local_link_mode(dd, &misc_bits, &local_flags, &widths);
 	tx = widths >> 12;
 	rx = (widths >> 8) & 0xf;
 
@@ -8820,29 +8831,29 @@ static int write_vc_local_fabric(struct hfi1_devdata *dd, u8 vau, u8 z, u8 vcu,
 				GENERAL_CONFIG, frame);
 }
 
-static void read_vc_local_link_width(struct hfi1_devdata *dd, u8 *misc_bits,
-				     u8 *flag_bits, u16 *link_widths)
+static void read_vc_local_link_mode(struct hfi1_devdata *dd, u8 *misc_bits,
+				    u8 *flag_bits, u16 *link_widths)
 {
 	u32 frame;
 
-	read_8051_config(dd, VERIFY_CAP_LOCAL_LINK_WIDTH, GENERAL_CONFIG,
+	read_8051_config(dd, VERIFY_CAP_LOCAL_LINK_MODE, GENERAL_CONFIG,
 			 &frame);
 	*misc_bits = (frame >> MISC_CONFIG_BITS_SHIFT) & MISC_CONFIG_BITS_MASK;
 	*flag_bits = (frame >> LOCAL_FLAG_BITS_SHIFT) & LOCAL_FLAG_BITS_MASK;
 	*link_widths = (frame >> LINK_WIDTH_SHIFT) & LINK_WIDTH_MASK;
 }
 
-static int write_vc_local_link_width(struct hfi1_devdata *dd,
-				     u8 misc_bits,
-				     u8 flag_bits,
-				     u16 link_widths)
+static int write_vc_local_link_mode(struct hfi1_devdata *dd,
+				    u8 misc_bits,
+				    u8 flag_bits,
+				    u16 link_widths)
 {
 	u32 frame;
 
 	frame = (u32)misc_bits << MISC_CONFIG_BITS_SHIFT
 		| (u32)flag_bits << LOCAL_FLAG_BITS_SHIFT
 		| (u32)link_widths << LINK_WIDTH_SHIFT;
-	return load_8051_config(dd, VERIFY_CAP_LOCAL_LINK_WIDTH, GENERAL_CONFIG,
+	return load_8051_config(dd, VERIFY_CAP_LOCAL_LINK_MODE, GENERAL_CONFIG,
 		     frame);
 }
 
@@ -9312,8 +9323,16 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 	if (loopback == LOOPBACK_SERDES)
 		misc_bits |= 1 << LOOPBACK_SERDES_CONFIG_BIT_MASK_SHIFT;
 
-	ret = write_vc_local_link_width(dd, misc_bits, 0,
-					opa_to_vc_link_widths(
+	/*
+	 * An external device configuration request is used to reset the LCB
+	 * to retry to obtain operational lanes when the first attempt is
+	 * unsuccesful.
+	 */
+	if (dd->dc8051_ver >= dc8051_ver(1, 25, 0))
+		misc_bits |= 1 << EXT_CFG_LCB_RESET_SUPPORTED_SHIFT;
+
+	ret = write_vc_local_link_mode(dd, misc_bits, 0,
+				       opa_to_vc_link_widths(
 						ppd->link_width_enabled));
 	if (ret != HCMD_SUCCESS)
 		goto set_local_link_attributes_fail;
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index c0d70f2..fdf389e 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -196,6 +196,15 @@
 #define LSTATE_ARMED   0x3
 #define LSTATE_ACTIVE  0x4
 
+/* DCC_CFG_RESET reset states */
+#define LCB_RX_FPE_TX_FPE_INTO_RESET   (DCC_CFG_RESET_RESET_LCB    | \
+					DCC_CFG_RESET_RESET_TX_FPE | \
+					DCC_CFG_RESET_RESET_RX_FPE | \
+					DCC_CFG_RESET_ENABLE_CCLK_BCC)
+					/* 0x17 */
+
+#define LCB_RX_FPE_TX_FPE_OUT_OF_RESET  DCC_CFG_RESET_ENABLE_CCLK_BCC /* 0x10 */
+
 /* DC8051_STS_CUR_STATE port values (physical link states) */
 #define PLS_DISABLED			   0x30
 #define PLS_OFFLINE				   0x90
@@ -283,6 +292,7 @@
 #define HREQ_SET_TX_EQ_ABS	0x04
 #define HREQ_SET_TX_EQ_REL	0x05
 #define HREQ_ENABLE		0x06
+#define HREQ_LCB_RESET		0x07
 #define HREQ_CONFIG_DONE	0xfe
 #define HREQ_INTERFACE_TEST	0xff
 
@@ -383,7 +393,7 @@
 #define TX_SETTINGS		     0x06
 #define VERIFY_CAP_LOCAL_PHY	     0x07
 #define VERIFY_CAP_LOCAL_FABRIC	     0x08
-#define VERIFY_CAP_LOCAL_LINK_WIDTH  0x09
+#define VERIFY_CAP_LOCAL_LINK_MODE   0x09
 #define LOCAL_DEVICE_ID		     0x0a
 #define RESERVED_REGISTERS	     0x0b
 #define LOCAL_LNI_INFO		     0x0c
@@ -584,8 +594,9 @@ enum {
 #define LOOPBACK_LCB	2
 #define LOOPBACK_CABLE	3	/* external cable */
 
-/* set up serdes bit in MISC_CONFIG_BITS */
+/* set up bits in MISC_CONFIG_BITS */
 #define LOOPBACK_SERDES_CONFIG_BIT_MASK_SHIFT 0
+#define EXT_CFG_LCB_RESET_SUPPORTED_SHIFT     3
 
 /* read and write hardware registers */
 u64 read_csr(const struct hfi1_devdata *dd, u32 offset);
diff --git a/drivers/infiniband/hw/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
index 793514f..da598b5 100644
--- a/drivers/infiniband/hw/hfi1/chip_registers.h
+++ b/drivers/infiniband/hw/hfi1/chip_registers.h
@@ -97,8 +97,11 @@
 #define DCC_CFG_PORT_CONFIG_MTU_CAP_SHIFT 32
 #define DCC_CFG_PORT_CONFIG_MTU_CAP_SMASK 0x700000000ull
 #define DCC_CFG_RESET (DCC_CSRS + 0x000000000000)
-#define DCC_CFG_RESET_RESET_LCB_SHIFT 0
-#define DCC_CFG_RESET_RESET_RX_FPE_SHIFT 2
+#define DCC_CFG_RESET_RESET_LCB          BIT_ULL(0)
+#define DCC_CFG_RESET_RESET_TX_FPE       BIT_ULL(1)
+#define DCC_CFG_RESET_RESET_RX_FPE       BIT_ULL(2)
+#define DCC_CFG_RESET_RESET_8051         BIT_ULL(3)
+#define DCC_CFG_RESET_ENABLE_CCLK_BCC    BIT_ULL(4)
 #define DCC_CFG_SC_VL_TABLE_15_0 (DCC_CSRS + 0x000000000028)
 #define DCC_CFG_SC_VL_TABLE_15_0_ENTRY0_SHIFT 0
 #define DCC_CFG_SC_VL_TABLE_15_0_ENTRY10_SHIFT 40

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
