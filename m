From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/13] staging/rdma/hfi1: Use BIT macro
Date: Mon, 16 Nov 2015 21:59:23 -0500
Message-ID: <1447729175-28745-2-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes the checkpatch issue:
CHECK: Prefer using the BIT macro

Use of BIT macro for HDRQ_INCREMENT in chip.h causes a change in
format specifier for error message in init.c in order to avoid a
build warning.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.h   |   48 ++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/common.h |    4 +-
 drivers/staging/rdma/hfi1/diag.c   |    4 +-
 drivers/staging/rdma/hfi1/hfi.h    |   22 ++++++++--------
 drivers/staging/rdma/hfi1/init.c   |    2 +-
 drivers/staging/rdma/hfi1/mad.c    |    4 +-
 drivers/staging/rdma/hfi1/qp.h     |    2 +-
 drivers/staging/rdma/hfi1/qsfp.h   |   10 +++---
 drivers/staging/rdma/hfi1/sdma.c   |    8 +++---
 drivers/staging/rdma/hfi1/verbs.h  |    6 ++--
 10 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index d74aed8..cb923c1 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -242,18 +242,18 @@
 #define HCMD_SUCCESS 2
 
 /* DC_DC8051_DBG_ERR_INFO_SET_BY_8051.ERROR - error flags */
-#define SPICO_ROM_FAILED		    (1 <<  0)
-#define UNKNOWN_FRAME		    (1 <<  1)
-#define TARGET_BER_NOT_MET		    (1 <<  2)
-#define FAILED_SERDES_INTERNAL_LOOPBACK (1 <<  3)
-#define FAILED_SERDES_INIT		    (1 <<  4)
-#define FAILED_LNI_POLLING		    (1 <<  5)
-#define FAILED_LNI_DEBOUNCE		    (1 <<  6)
-#define FAILED_LNI_ESTBCOMM		    (1 <<  7)
-#define FAILED_LNI_OPTEQ		    (1 <<  8)
-#define FAILED_LNI_VERIFY_CAP1	    (1 <<  9)
-#define FAILED_LNI_VERIFY_CAP2	    (1 << 10)
-#define FAILED_LNI_CONFIGLT		    (1 << 11)
+#define SPICO_ROM_FAILED		BIT(0)
+#define UNKNOWN_FRAME			BIT(1)
+#define TARGET_BER_NOT_MET		BIT(2)
+#define FAILED_SERDES_INTERNAL_LOOPBACK	BIT(3)
+#define FAILED_SERDES_INIT		BIT(4)
+#define FAILED_LNI_POLLING		BIT(5)
+#define FAILED_LNI_DEBOUNCE		BIT(6)
+#define FAILED_LNI_ESTBCOMM		BIT(7)
+#define FAILED_LNI_OPTEQ		BIT(8)
+#define FAILED_LNI_VERIFY_CAP1		BIT(9)
+#define FAILED_LNI_VERIFY_CAP2		BIT(10)
+#define FAILED_LNI_CONFIGLT		BIT(11)
 
 #define FAILED_LNI (FAILED_LNI_POLLING | FAILED_LNI_DEBOUNCE \
 			| FAILED_LNI_ESTBCOMM | FAILED_LNI_OPTEQ \
@@ -262,16 +262,16 @@
 			| FAILED_LNI_CONFIGLT)
 
 /* DC_DC8051_DBG_ERR_INFO_SET_BY_8051.HOST_MSG - host message flags */
-#define HOST_REQ_DONE	   (1 << 0)
-#define BC_PWR_MGM_MSG	   (1 << 1)
-#define BC_SMA_MSG		   (1 << 2)
-#define BC_BCC_UNKOWN_MSG	   (1 << 3)
-#define BC_IDLE_UNKNOWN_MSG	   (1 << 4)
-#define EXT_DEVICE_CFG_REQ	   (1 << 5)
-#define VERIFY_CAP_FRAME	   (1 << 6)
-#define LINKUP_ACHIEVED	   (1 << 7)
-#define LINK_GOING_DOWN	   (1 << 8)
-#define LINK_WIDTH_DOWNGRADED  (1 << 9)
+#define HOST_REQ_DONE		BIT(0)
+#define BC_PWR_MGM_MSG		BIT(1)
+#define BC_SMA_MSG		BIT(2)
+#define BC_BCC_UNKNOWN_MSG	BIT(3)
+#define BC_IDLE_UNKNOWN_MSG	BIT(4)
+#define EXT_DEVICE_CFG_REQ	BIT(5)
+#define VERIFY_CAP_FRAME	BIT(6)
+#define LINKUP_ACHIEVED		BIT(7)
+#define LINK_GOING_DOWN		BIT(8)
+#define LINK_WIDTH_DOWNGRADED	BIT(9)
 
 /* DC_DC8051_CFG_EXT_DEV_1.REQ_TYPE - 8051 host requests */
 #define HREQ_LOAD_CONFIG	0x01
@@ -335,14 +335,14 @@
  * the CSR fields hold multiples of this value.
  */
 #define RCV_SHIFT 3
-#define RCV_INCREMENT (1 << RCV_SHIFT)
+#define RCV_INCREMENT BIT(RCV_SHIFT)
 
 /*
  * Receive header queue entry increment - the CSR holds multiples of
  * this value.
  */
 #define HDRQ_SIZE_SHIFT 5
-#define HDRQ_INCREMENT (1 << HDRQ_SIZE_SHIFT)
+#define HDRQ_INCREMENT BIT(HDRQ_SIZE_SHIFT)
 
 /*
  * Freeze handling flags
diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index 5dd9272..e4b1dc6 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -349,10 +349,10 @@ struct hfi1_message_header {
 #define HFI1_QPN_MASK 0xFFFFFF
 #define HFI1_FECN_SHIFT 31
 #define HFI1_FECN_MASK 1
-#define HFI1_FECN_SMASK (1 << HFI1_FECN_SHIFT)
+#define HFI1_FECN_SMASK BIT(HFI1_FECN_SHIFT)
 #define HFI1_BECN_SHIFT 30
 #define HFI1_BECN_MASK 1
-#define HFI1_BECN_SMASK (1 << HFI1_BECN_SHIFT)
+#define HFI1_BECN_SMASK BIT(HFI1_BECN_SHIFT)
 #define HFI1_MULTICAST_LID_BASE 0xC000
 
 static inline __u64 rhf_to_cpu(const __le32 *rbuf)
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 88414d7..076a419 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -78,8 +78,8 @@
 	hfi1_cdbg(SNOOP, fmt, ##__VA_ARGS__)
 
 /* Snoop option mask */
-#define SNOOP_DROP_SEND	(1 << 0)
-#define SNOOP_USE_METADATA	(1 << 1)
+#define SNOOP_DROP_SEND		BIT(0)
+#define SNOOP_USE_METADATA	BIT(1)
 
 static u8 snoop_flags;
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 70891fb..488aa34 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -404,17 +404,17 @@ struct hfi1_sge_state;
 #define __HLS_GOING_OFFLINE_BP  9
 #define __HLS_LINK_COOLDOWN_BP 10
 
-#define HLS_UP_INIT	  (1 << __HLS_UP_INIT_BP)
-#define HLS_UP_ARMED	  (1 << __HLS_UP_ARMED_BP)
-#define HLS_UP_ACTIVE	  (1 << __HLS_UP_ACTIVE_BP)
-#define HLS_DN_DOWNDEF	  (1 << __HLS_DN_DOWNDEF_BP) /* link down default */
-#define HLS_DN_POLL	  (1 << __HLS_DN_POLL_BP)
-#define HLS_DN_DISABLE	  (1 << __HLS_DN_DISABLE_BP)
-#define HLS_DN_OFFLINE	  (1 << __HLS_DN_OFFLINE_BP)
-#define HLS_VERIFY_CAP	  (1 << __HLS_VERIFY_CAP_BP)
-#define HLS_GOING_UP	  (1 << __HLS_GOING_UP_BP)
-#define HLS_GOING_OFFLINE (1 << __HLS_GOING_OFFLINE_BP)
-#define HLS_LINK_COOLDOWN (1 << __HLS_LINK_COOLDOWN_BP)
+#define HLS_UP_INIT	  BIT(__HLS_UP_INIT_BP)
+#define HLS_UP_ARMED	  BIT(__HLS_UP_ARMED_BP)
+#define HLS_UP_ACTIVE	  BIT(__HLS_UP_ACTIVE_BP)
+#define HLS_DN_DOWNDEF	  BIT(__HLS_DN_DOWNDEF_BP) /* link down default */
+#define HLS_DN_POLL	  BIT(__HLS_DN_POLL_BP)
+#define HLS_DN_DISABLE	  BIT(__HLS_DN_DISABLE_BP)
+#define HLS_DN_OFFLINE	  BIT(__HLS_DN_OFFLINE_BP)
+#define HLS_VERIFY_CAP	  BIT(__HLS_VERIFY_CAP_BP)
+#define HLS_GOING_UP	  BIT(__HLS_GOING_UP_BP)
+#define HLS_GOING_OFFLINE BIT(__HLS_GOING_OFFLINE_BP)
+#define HLS_LINK_COOLDOWN BIT(__HLS_LINK_COOLDOWN_BP)
 
 #define HLS_UP (HLS_UP_INIT | HLS_UP_ARMED | HLS_UP_ACTIVE)
 
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 4a79744..5fdd9dd 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -253,7 +253,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		/* Validate and initialize Rcv Hdr Q variables */
 		if (rcvhdrcnt % HDRQ_INCREMENT) {
 			dd_dev_err(dd,
-				   "ctxt%u: header queue count %d must be divisible by %d\n",
+				   "ctxt%u: header queue count %d must be divisible by %lu\n",
 				   rcd->ctxt, rcvhdrcnt, HDRQ_INCREMENT);
 			goto bail;
 		}
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a122565..1baeb01 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1781,7 +1781,7 @@ static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
 	u32 len = OPA_AM_CI_LEN(am) + 1;
 	int ret;
 
-#define __CI_PAGE_SIZE (1 << 7) /* 128 bytes */
+#define __CI_PAGE_SIZE BIT(7) /* 128 bytes */
 #define __CI_PAGE_MASK ~(__CI_PAGE_SIZE - 1)
 #define __CI_PAGE_NUM(a) ((a) & __CI_PAGE_MASK)
 
@@ -3447,7 +3447,7 @@ struct opa_led_info {
 };
 
 #define OPA_LED_SHIFT	31
-#define OPA_LED_MASK	(1 << OPA_LED_SHIFT)
+#define OPA_LED_MASK	BIT(OPA_LED_SHIFT)
 
 static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 				   struct ib_device *ibdev, u8 port,
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index b9c1575..0d0e0c7 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -54,7 +54,7 @@
 #include "verbs.h"
 #include "sdma.h"
 
-#define QPN_MAX                 (1 << 24)
+#define QPN_MAX                 BIT(24)
 #define QPNMAP_ENTRIES          (QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
 
 /*
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index d30c2a6..16aebdc 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -59,11 +59,11 @@
  * Below are masks for QSFP pins.  Pins are the same for HFI0 and HFI1.
  * _N means asserted low
  */
-#define QSFP_HFI0_I2CCLK    (1 << 0)
-#define QSFP_HFI0_I2CDAT    (1 << 1)
-#define QSFP_HFI0_RESET_N   (1 << 2)
-#define QSFP_HFI0_INT_N	    (1 << 3)
-#define QSFP_HFI0_MODPRST_N (1 << 4)
+#define QSFP_HFI0_I2CCLK    BIT(0)
+#define QSFP_HFI0_I2CDAT    BIT(1)
+#define QSFP_HFI0_RESET_N   BIT(2)
+#define QSFP_HFI0_INT_N	    BIT(3)
+#define QSFP_HFI0_MODPRST_N BIT(4)
 
 /* QSFP is paged at 256 bytes */
 #define QSFP_PAGESIZE 256
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index f185545..98324ae 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -112,10 +112,10 @@ MODULE_PARM_DESC(desct_intr, "Number of SDMA descriptor before interrupt");
 	| SD(ENG_ERR_STATUS_SDMA_HEADER_REQUEST_FIFO_UNC_ERR_SMASK))
 
 /* sdma_sendctrl operations */
-#define SDMA_SENDCTRL_OP_ENABLE    (1U << 0)
-#define SDMA_SENDCTRL_OP_INTENABLE (1U << 1)
-#define SDMA_SENDCTRL_OP_HALT      (1U << 2)
-#define SDMA_SENDCTRL_OP_CLEANUP   (1U << 3)
+#define SDMA_SENDCTRL_OP_ENABLE    BIT(0)
+#define SDMA_SENDCTRL_OP_INTENABLE BIT(1)
+#define SDMA_SENDCTRL_OP_HALT      BIT(2)
+#define SDMA_SENDCTRL_OP_CLEANUP   BIT(3)
 
 /* handle long defines */
 #define SDMA_EGRESS_PACKET_OCCUPANCY_SMASK \
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 041ad07..600bd1b 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -120,9 +120,9 @@ struct hfi1_packet;
 
 #define HFI1_VENDOR_IPG		cpu_to_be16(0xFFA0)
 
-#define IB_BTH_REQ_ACK		(1 << 31)
-#define IB_BTH_SOLICITED	(1 << 23)
-#define IB_BTH_MIG_REQ		(1 << 22)
+#define IB_BTH_REQ_ACK		BIT(31)
+#define IB_BTH_SOLICITED	BIT(23)
+#define IB_BTH_MIG_REQ		BIT(22)
 
 #define IB_GRH_VERSION		6
 #define IB_GRH_VERSION_MASK	0xF
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
