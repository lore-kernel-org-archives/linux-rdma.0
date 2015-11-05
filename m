From: jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma/hfi1: Disable thermal polling before sensor initialization
Date: Wed,  4 Nov 2015 23:44:17 -0500
Message-ID: <1446698657-26743-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "jareer.h.abdel-qader" <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: jareer.h.abdel-qader <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During driver load the thermal sensor needs to be reset prior
to initialization of the sensor. This prevents a possible sensor lock
up which can cause the wrong temperature value to be reported.
This fix leads to remove disabling thermal polling from
reset_asic_csrs() function.

Reviewed by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jareer Abdel-Qader <jareer.h.abdel-qader-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..e1951f4 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9455,7 +9455,7 @@ static void reset_asic_csrs(struct hfi1_devdata *dd)
 	/* We might want to retain this state across FLR if we ever use it */
 	write_csr(dd, ASIC_CFG_DRV_STR, 0);
 
-	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0);
+	/* ASIC_CFG_THERM_POLL_EN leave alone */
 	/* ASIC_STS_THERM read-only */
 	/* ASIC_CFG_RESET leave alone */
 
@@ -10803,7 +10803,9 @@ static int thermal_init(struct hfi1_devdata *dd)
 
 	acquire_hw_mutex(dd);
 	dd_dev_info(dd, "Initializing thermal sensor\n");
-
+	/* Disable polling of thermal readings */
+	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x0);
+	msleep(100);
 	/* Thermal Sensor Initialization */
 	/*    Step 1: Reset the Thermal SBus Receiver */
 	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
