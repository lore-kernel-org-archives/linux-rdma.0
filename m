From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 02/11] staging/rdma/hfi1: Clear the QSFP reset that is asserted on FLR
Date: Fri,  6 Nov 2015 20:06:57 -0500
Message-ID: <1446858426-30509-3-git-send-email-jubin.john@intel.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446858426-30509-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The FLR on driver load asserts the QSFP reset pin and the driver does
not deassert it after. This patch allows the external QSFP cable to exit
reset by writing 1 to all the QSFP pins.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..e309828 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9929,19 +9929,16 @@ static void init_chip(struct hfi1_devdata *dd)
 		setextled(dd, 0);
 	/*
 	 * Clear the QSFP reset.
-	 * A0 leaves the out lines floating on power on, then on an FLR
-	 * enforces a 0 on all out pins.  The driver does not touch
+	 * An FLR enforces a 0 on all out pins. The driver does not touch
 	 * ASIC_QSFPn_OUT otherwise.  This leaves RESET_N low and
-	 * anything  plugged constantly in reset, if it pays attention
+	 * anything plugged constantly in reset, if it pays attention
 	 * to RESET_N.
-	 * A prime example of this is SiPh. For now, set all pins high.
+	 * Prime examples of this are optical cables. Set all pins high.
 	 * I2CCLK and I2CDAT will change per direction, and INT_N and
 	 * MODPRS_N are input only and their value is ignored.
 	 */
-	if (is_a0(dd)) {
-		write_csr(dd, ASIC_QSFP1_OUT, 0x1f);
-		write_csr(dd, ASIC_QSFP2_OUT, 0x1f);
-	}
+	write_csr(dd, ASIC_QSFP1_OUT, 0x1f);
+	write_csr(dd, ASIC_QSFP2_OUT, 0x1f);
 }
 
 static void init_early_variables(struct hfi1_devdata *dd)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
