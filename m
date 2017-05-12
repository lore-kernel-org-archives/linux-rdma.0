From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/hfi1: Defer setting VL15 credits to link-up interrupt
Date: Fri, 12 May 2017 09:01:37 -0700
Message-ID: <20170512160120.27868.29977.stgit@scvm10.sc.intel.com>
References: <20170512155936.27868.7128.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512155936.27868.7128.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Byczkowski, Jakub <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Keep VL15 credits at 0 during LNI, before link-up. Store
VL15 credits value during verify cap interrupt and set
in after link-up. This addresses an issue where VL15 MAD
packets could be sent by one side of the link before
the other side is ready to receive them.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c           |   67 ++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/chip_registers.h |    2 +
 drivers/infiniband/hw/hfi1/hfi.h            |   11 ++++
 drivers/infiniband/hw/hfi1/intr.c           |    3 +
 4 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 972da41..bbf7759 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6312,25 +6312,38 @@ static void handle_8051_request(struct hfi1_pportdata *ppd)
 	}
 }
 
-static void write_global_credit(struct hfi1_devdata *dd,
-				u8 vau, u16 total, u16 shared)
+/*
+ * Set up allocation unit vaulue.
+ */
+void set_up_vau(struct hfi1_devdata *dd, u8 vau)
 {
-	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
-		  ((u64)total <<
-		   SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT) |
-		  ((u64)shared <<
-		   SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT) |
-		  ((u64)vau << SEND_CM_GLOBAL_CREDIT_AU_SHIFT));
+	u64 reg = read_csr(dd, SEND_CM_GLOBAL_CREDIT);
+
+	/* do not modify other values in the register */
+	reg &= ~SEND_CM_GLOBAL_CREDIT_AU_SMASK;
+	reg |= (u64)vau << SEND_CM_GLOBAL_CREDIT_AU_SHIFT;
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, reg);
 }
 
 /*
  * Set up initial VL15 credits of the remote.  Assumes the rest of
- * the CM credit registers are zero from a previous global or credit reset .
+ * the CM credit registers are zero from a previous global or credit reset.
+ * Shared limit for VL15 will always be 0.
  */
-void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf)
+void set_up_vl15(struct hfi1_devdata *dd, u16 vl15buf)
 {
-	/* leave shared count at zero for both global and VL15 */
-	write_global_credit(dd, vau, vl15buf, 0);
+	u64 reg = read_csr(dd, SEND_CM_GLOBAL_CREDIT);
+
+	/* set initial values for total and shared credit limit */
+	reg &= ~(SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SMASK |
+		 SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SMASK);
+
+	/*
+	 * Set total limit to be equal to VL15 credits.
+	 * Leave shared limit at 0.
+	 */
+	reg |= (u64)vl15buf << SEND_CM_GLOBAL_CREDIT_TOTAL_CREDIT_LIMIT_SHIFT;
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, reg);
 
 	write_csr(dd, SEND_CM_CREDIT_VL15, (u64)vl15buf
 		  << SEND_CM_CREDIT_VL15_DEDICATED_LIMIT_VL_SHIFT);
@@ -6348,9 +6361,11 @@ void reset_link_credits(struct hfi1_devdata *dd)
 	for (i = 0; i < TXE_NUM_DATA_VL; i++)
 		write_csr(dd, SEND_CM_CREDIT_VL + (8 * i), 0);
 	write_csr(dd, SEND_CM_CREDIT_VL15, 0);
-	write_global_credit(dd, 0, 0, 0);
+	write_csr(dd, SEND_CM_GLOBAL_CREDIT, 0);
 	/* reset the CM block */
 	pio_send_control(dd, PSC_CM_RESET);
+	/* reset cached value */
+	dd->vl15buf_cached = 0;
 }
 
 /* convert a vCU to a CU */
@@ -6839,24 +6854,35 @@ void handle_link_up(struct work_struct *work)
 {
 	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
 						  link_up_work);
+	struct hfi1_devdata *dd = ppd->dd;
+
 	set_link_state(ppd, HLS_UP_INIT);
 
 	/* cache the read of DC_LCB_STS_ROUND_TRIP_LTP_CNT */
-	read_ltp_rtt(ppd->dd);
+	read_ltp_rtt(dd);
 	/*
 	 * OPA specifies that certain counters are cleared on a transition
 	 * to link up, so do that.
 	 */
-	clear_linkup_counters(ppd->dd);
+	clear_linkup_counters(dd);
 	/*
 	 * And (re)set link up default values.
 	 */
 	set_linkup_defaults(ppd);
 
+	/*
+	 * Set VL15 credits. Use cached value from verify cap interrupt.
+	 * In case of quick linkup or simulator, vl15 value will be set by
+	 * handle_linkup_change. VerifyCap interrupt handler will not be
+	 * called in those scenarios.
+	 */
+	if (!(quick_linkup || dd->icode == ICODE_FUNCTIONAL_SIMULATOR))
+		set_up_vl15(dd, dd->vl15buf_cached);
+
 	/* enforce link speed enabled */
 	if ((ppd->link_speed_active & ppd->link_speed_enabled) == 0) {
 		/* oops - current speed is not enabled, bounce */
-		dd_dev_err(ppd->dd,
+		dd_dev_err(dd,
 			   "Link speed active 0x%x is outside enabled 0x%x, downing link\n",
 			   ppd->link_speed_active, ppd->link_speed_enabled);
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SPEED_POLICY, 0,
@@ -7357,7 +7383,14 @@ void handle_verify_cap(struct work_struct *work)
 	 */
 	if (vau == 0)
 		vau = 1;
-	set_up_vl15(dd, vau, vl15buf);
+	set_up_vau(dd, vau);
+
+	/*
+	 * Set VL15 credits to 0 in global credit register. Cache remote VL15
+	 * credits value and wait for link-up interrupt ot set it.
+	 */
+	set_up_vl15(dd, 0);
+	dd->vl15buf_cached = vl15buf;
 
 	/* set up the LCB CRC mode */
 	crc_mask = ppd->port_crc_mode_enabled & partner_supported_crc;
diff --git a/drivers/infiniband/hw/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
index 5bfa839..793514f 100644
--- a/drivers/infiniband/hw/hfi1/chip_registers.h
+++ b/drivers/infiniband/hw/hfi1/chip_registers.h
@@ -839,7 +839,9 @@
 #define SEND_CM_CTRL_FORCE_CREDIT_MODE_SMASK 0x8ull
 #define SEND_CM_CTRL_RESETCSR 0x0000000000000020ull
 #define SEND_CM_GLOBAL_CREDIT (TXE + 0x000000000508)
+#define SEND_CM_GLOBAL_CREDIT_AU_MASK 0x7ull
 #define SEND_CM_GLOBAL_CREDIT_AU_SHIFT 16
+#define SEND_CM_GLOBAL_CREDIT_AU_SMASK 0x70000ull
 #define SEND_CM_GLOBAL_CREDIT_RESETCSR 0x0000094000030000ull
 #define SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_MASK 0xFFFFull
 #define SEND_CM_GLOBAL_CREDIT_SHARED_LIMIT_SHIFT 0
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 509df98..0f0abfd 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1045,6 +1045,14 @@ struct hfi1_devdata {
 	/* initial vl15 credits to use */
 	u16 vl15_init;
 
+	/*
+	 * Cached value for vl15buf, read during verify cap interrupt. VL15
+	 * credits are to be kept at 0 and set when handling the link-up
+	 * interrupt. This removes the possibility of receiving VL15 MAD
+	 * packets before this HFI is ready.
+	 */
+	u16 vl15buf_cached;
+
 	/* Misc small ints */
 	u8 n_krcv_queues;
 	u8 qos_shift;
@@ -1598,7 +1606,8 @@ static inline int valid_opa_max_mtu(unsigned int mtu)
 int fm_get_table(struct hfi1_pportdata *ppd, int which, void *t);
 int fm_set_table(struct hfi1_pportdata *ppd, int which, void *t);
 
-void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf);
+void set_up_vau(struct hfi1_devdata *dd, u8 vau);
+void set_up_vl15(struct hfi1_devdata *dd, u16 vl15buf);
 void reset_link_credits(struct hfi1_devdata *dd);
 void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu);
 
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index ba265d0..04a5082 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -130,7 +130,8 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		 * the remote values.  Both sides must be using the values.
 		 */
 		if (quick_linkup || dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
-			set_up_vl15(dd, dd->vau, dd->vl15_init);
+			set_up_vau(dd, dd->vau);
+			set_up_vl15(dd, dd->vl15_init);
 			assign_remote_cm_au_table(dd, dd->vcu);
 		}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
