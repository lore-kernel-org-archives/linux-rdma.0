From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] IB/hfi1: Fix integrity check flags default values
Date: Mon, 10 Oct 2016 06:14:56 -0700
Message-ID: <20161010131455.17586.44406.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Prevent setting up integrity check flags when module is loaded
with NO_INTEGRITY capability.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h  |   40 +++++++++++++++++++++++++------------
 drivers/infiniband/hw/hfi1/pio.c  |   13 +++---------
 drivers/infiniband/hw/hfi1/sdma.c |   19 ++----------------
 3 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 7eef11b..3c06d20 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1848,7 +1848,13 @@ extern struct mutex hfi1_mutex;
 static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 						  u16 ctxt_type)
 {
-	u64 base_sc_integrity =
+	u64 base_sc_integrity;
+
+	/* No integrity checks if HFI1_CAP_NO_INTEGRITY is set */
+	if (HFI1_CAP_IS_KSET(NO_INTEGRITY))
+		return 0;
+
+	base_sc_integrity =
 	SEND_CTXT_CHECK_ENABLE_DISALLOW_BYPASS_BAD_PKT_LEN_SMASK
 	| SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK
 	| SEND_CTXT_CHECK_ENABLE_DISALLOW_TOO_LONG_BYPASS_PACKETS_SMASK
@@ -1863,7 +1869,6 @@ static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 	| SEND_CTXT_CHECK_ENABLE_CHECK_VL_MAPPING_SMASK
 	| SEND_CTXT_CHECK_ENABLE_CHECK_OPCODE_SMASK
 	| SEND_CTXT_CHECK_ENABLE_CHECK_SLID_SMASK
-	| SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK
 	| SEND_CTXT_CHECK_ENABLE_CHECK_VL_SMASK
 	| SEND_CTXT_CHECK_ENABLE_CHECK_ENABLE_SMASK;
 
@@ -1872,18 +1877,23 @@ static inline u64 hfi1_pkt_default_send_ctxt_mask(struct hfi1_devdata *dd,
 	else
 		base_sc_integrity |= HFI1_PKT_KERNEL_SC_INTEGRITY;
 
-	if (is_ax(dd))
-		/* turn off send-side job key checks - A0 */
-		return base_sc_integrity &
-		       ~SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+	/* turn on send-side job key checks if !A0 */
+	if (!is_ax(dd))
+		base_sc_integrity |= SEND_CTXT_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+
 	return base_sc_integrity;
 }
 
 static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 {
-	u64 base_sdma_integrity =
+	u64 base_sdma_integrity;
+
+	/* No integrity checks if HFI1_CAP_NO_INTEGRITY is set */
+	if (HFI1_CAP_IS_KSET(NO_INTEGRITY))
+		return 0;
+
+	base_sdma_integrity =
 	SEND_DMA_CHECK_ENABLE_DISALLOW_BYPASS_BAD_PKT_LEN_SMASK
-	| SEND_DMA_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK
 	| SEND_DMA_CHECK_ENABLE_DISALLOW_TOO_LONG_BYPASS_PACKETS_SMASK
 	| SEND_DMA_CHECK_ENABLE_DISALLOW_TOO_LONG_IB_PACKETS_SMASK
 	| SEND_DMA_CHECK_ENABLE_DISALLOW_BAD_PKT_LEN_SMASK
@@ -1895,14 +1905,18 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	| SEND_DMA_CHECK_ENABLE_CHECK_VL_MAPPING_SMASK
 	| SEND_DMA_CHECK_ENABLE_CHECK_OPCODE_SMASK
 	| SEND_DMA_CHECK_ENABLE_CHECK_SLID_SMASK
-	| SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK
 	| SEND_DMA_CHECK_ENABLE_CHECK_VL_SMASK
 	| SEND_DMA_CHECK_ENABLE_CHECK_ENABLE_SMASK;
 
-	if (is_ax(dd))
-		/* turn off send-side job key checks - A0 */
-		return base_sdma_integrity &
-		       ~SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+	if (!HFI1_CAP_IS_KSET(STATIC_RATE_CTRL))
+		base_sdma_integrity |=
+		SEND_DMA_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK;
+
+	/* turn on send-side job key checks if !A0 */
+	if (!is_ax(dd))
+		base_sdma_integrity |=
+			SEND_DMA_CHECK_ENABLE_CHECK_JOB_KEY_SMASK;
+
 	return base_sdma_integrity;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 385e4dc..e60fe3e 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -668,19 +668,12 @@ void sc_set_cr_threshold(struct send_context *sc, u32 new_threshold)
 void set_pio_integrity(struct send_context *sc)
 {
 	struct hfi1_devdata *dd = sc->dd;
-	u64 reg = 0;
 	u32 hw_context = sc->hw_context;
 	int type = sc->type;
 
-	/*
-	 * No integrity checks if HFI1_CAP_NO_INTEGRITY is set, or if
-	 * we're snooping.
-	 */
-	if (likely(!HFI1_CAP_IS_KSET(NO_INTEGRITY)) &&
-	    dd->hfi1_snoop.mode_flag != HFI1_PORT_SNOOP_MODE)
-		reg = hfi1_pkt_default_send_ctxt_mask(dd, type);
-
-	write_kctxt_csr(dd, hw_context, SC(CHECK_ENABLE), reg);
+	write_kctxt_csr(dd, hw_context,
+			SC(CHECK_ENABLE),
+			hfi1_pkt_default_send_ctxt_mask(dd, type));
 }
 
 static u32 get_buffers_allocated(struct send_context *sc)
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 7102a07..1d81cac 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -2009,11 +2009,6 @@ static void sdma_hw_start_up(struct sdma_engine *sde)
 	write_sde_csr(sde, SD(ENG_ERR_CLEAR), reg);
 }
 
-#define CLEAR_STATIC_RATE_CONTROL_SMASK(r) \
-(r &= ~SEND_DMA_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
-
-#define SET_STATIC_RATE_CONTROL_SMASK(r) \
-(r |= SEND_DMA_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
 /*
  * set_sdma_integrity
  *
@@ -2022,19 +2017,9 @@ static void sdma_hw_start_up(struct sdma_engine *sde)
 static void set_sdma_integrity(struct sdma_engine *sde)
 {
 	struct hfi1_devdata *dd = sde->dd;
-	u64 reg;
-
-	if (unlikely(HFI1_CAP_IS_KSET(NO_INTEGRITY)))
-		return;
-
-	reg = hfi1_pkt_base_sdma_integrity(dd);
-
-	if (HFI1_CAP_IS_KSET(STATIC_RATE_CTRL))
-		CLEAR_STATIC_RATE_CONTROL_SMASK(reg);
-	else
-		SET_STATIC_RATE_CONTROL_SMASK(reg);
 
-	write_sde_csr(sde, SD(CHECK_ENABLE), reg);
+	write_sde_csr(sde, SD(CHECK_ENABLE),
+		      hfi1_pkt_base_sdma_integrity(dd));
 }
 
 static void init_sdma_regs(

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
