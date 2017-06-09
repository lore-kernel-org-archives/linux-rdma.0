From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/10] IB/hfi1: Set proper logging levels on QSFP
 cable error events
Date: Fri, 09 Jun 2017 15:59:33 -0700
Message-ID: <20170609225931.26710.63446.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change QSFP cable error events logging levels from info to error.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   64 +++++++++++++++++++------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a344dd8..358559c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9376,13 +9376,13 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 
 	if ((qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_ALARM) ||
 	    (qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
-		dd_dev_info(dd, "%s: QSFP cable temperature too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: QSFP cable temperature too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[0] & QSFP_LOW_TEMP_ALARM) ||
 	    (qsfp_interrupt_status[0] & QSFP_LOW_TEMP_WARNING))
-		dd_dev_info(dd, "%s: QSFP cable temperature too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: QSFP cable temperature too low\n",
+			   __func__);
 
 	/*
 	 * The remaining alarms/warnings don't matter if the link is down.
@@ -9392,75 +9392,75 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 
 	if ((qsfp_interrupt_status[1] & QSFP_HIGH_VCC_ALARM) ||
 	    (qsfp_interrupt_status[1] & QSFP_HIGH_VCC_WARNING))
-		dd_dev_info(dd, "%s: QSFP supply voltage too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: QSFP supply voltage too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[1] & QSFP_LOW_VCC_ALARM) ||
 	    (qsfp_interrupt_status[1] & QSFP_LOW_VCC_WARNING))
-		dd_dev_info(dd, "%s: QSFP supply voltage too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: QSFP supply voltage too low\n",
+			   __func__);
 
 	/* Byte 2 is vendor specific */
 
 	if ((qsfp_interrupt_status[3] & QSFP_HIGH_POWER_ALARM) ||
 	    (qsfp_interrupt_status[3] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable RX channel 1/2 power too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable RX channel 1/2 power too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[3] & QSFP_LOW_POWER_ALARM) ||
 	    (qsfp_interrupt_status[3] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable RX channel 1/2 power too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable RX channel 1/2 power too low\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[4] & QSFP_HIGH_POWER_ALARM) ||
 	    (qsfp_interrupt_status[4] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable RX channel 3/4 power too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable RX channel 3/4 power too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[4] & QSFP_LOW_POWER_ALARM) ||
 	    (qsfp_interrupt_status[4] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable RX channel 3/4 power too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable RX channel 3/4 power too low\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_ALARM) ||
 	    (qsfp_interrupt_status[5] & QSFP_HIGH_BIAS_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 1/2 bias too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 1/2 bias too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[5] & QSFP_LOW_BIAS_ALARM) ||
 	    (qsfp_interrupt_status[5] & QSFP_LOW_BIAS_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 1/2 bias too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 1/2 bias too low\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_ALARM) ||
 	    (qsfp_interrupt_status[6] & QSFP_HIGH_BIAS_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 3/4 bias too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 3/4 bias too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[6] & QSFP_LOW_BIAS_ALARM) ||
 	    (qsfp_interrupt_status[6] & QSFP_LOW_BIAS_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 3/4 bias too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 3/4 bias too low\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[7] & QSFP_HIGH_POWER_ALARM) ||
 	    (qsfp_interrupt_status[7] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 1/2 power too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 1/2 power too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[7] & QSFP_LOW_POWER_ALARM) ||
 	    (qsfp_interrupt_status[7] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 1/2 power too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 1/2 power too low\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[8] & QSFP_HIGH_POWER_ALARM) ||
 	    (qsfp_interrupt_status[8] & QSFP_HIGH_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 3/4 power too high\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 3/4 power too high\n",
+			   __func__);
 
 	if ((qsfp_interrupt_status[8] & QSFP_LOW_POWER_ALARM) ||
 	    (qsfp_interrupt_status[8] & QSFP_LOW_POWER_WARNING))
-		dd_dev_info(dd, "%s: Cable TX channel 3/4 power too low\n",
-			    __func__);
+		dd_dev_err(dd, "%s: Cable TX channel 3/4 power too low\n",
+			   __func__);
 
 	/* Bytes 9-10 and 11-12 are reserved */
 	/* Bytes 13-15 are vendor specific */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
