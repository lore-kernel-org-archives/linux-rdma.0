From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/7] IB/hfi1: Insure int mask for in-kernel receive
 contexts is clear
Date: Mon, 23 Oct 2017 06:06:16 -0700
Message-ID: <20171023130613.21191.30432.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The only use for the urg interrupt is for priority PSM packets.

There is no reason for this interrupt to be enabled for kernel
contexts.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 1702264..32e35d5 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12938,6 +12938,32 @@ int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp)
 	return ret;
 }
 
+/**
+ * get_int_mask - get 64 bit int mask
+ * @dd - the devdata
+ * @i - the csr (relative to CCE_INT_MASK)
+ *
+ * Returns the mask with the urgent interrupt mask
+ * bit clear for kernel receive contexts.
+ */
+static u64 get_int_mask(struct hfi1_devdata *dd, u32 i)
+{
+	u64 mask = U64_MAX; /* default to no change */
+
+	if (i >= (IS_RCVURGENT_START / 64) && i < (IS_RCVURGENT_END / 64)) {
+		int j = (i - (IS_RCVURGENT_START / 64)) * 64;
+		int k = !j ? IS_RCVURGENT_START % 64 : 0;
+
+		if (j)
+			j -= IS_RCVURGENT_START % 64;
+		/* j = 0..dd->first_dyn_alloc_ctxt - 1,k = 0..63 */
+		for (; j < dd->first_dyn_alloc_ctxt && k < 64; j++, k++)
+			/* convert to bit in mask and clear */
+			mask &= ~BIT_ULL(k);
+	}
+	return mask;
+}
+
 /* ========================================================================= */
 
 /*
@@ -12951,9 +12977,12 @@ void set_intr_state(struct hfi1_devdata *dd, u32 enable)
 	 * In HFI, the mask needs to be 1 to allow interrupts.
 	 */
 	if (enable) {
-		/* enable all interrupts */
-		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
-			write_csr(dd, CCE_INT_MASK + (8 * i), ~(u64)0);
+		/* enable all interrupts but urgent on kernel contexts */
+		for (i = 0; i < CCE_NUM_INT_CSRS; i++) {
+			u64 mask = get_int_mask(dd, i);
+
+			write_csr(dd, CCE_INT_MASK + (8 * i), mask);
+		}
 
 		init_qsfp_int(dd);
 	} else {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
