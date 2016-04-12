From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/21] IB/hfi1: Remove module presence check outside pre-LNI
 checks
Date: Tue, 12 Apr 2016 11:25:57 -0700
Message-ID: <20160412182546.25419.51352.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The pre-LNI SerDes and channel tuning algorithm already checks for
module presence assertion for the relevant port types. The extraneous
check removed in this patch blocks link up for port types for which
the module presence assertion is not relevant.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   20 ++++++--------------
 drivers/staging/rdma/hfi1/platform.c |    8 ++++++--
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 962cca0..38c0e97 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6849,7 +6849,7 @@ void handle_link_down(struct work_struct *work)
 	 * If there is no cable attached, turn the DC off. Otherwise,
 	 * start the link bring up.
 	 */
-	if (!qsfp_mod_present(ppd)) {
+	if (ppd->port_type == PORT_TYPE_QSFP && !qsfp_mod_present(ppd)) {
 		dc_shutdown(ppd->dd);
 	} else {
 		tune_serdes(ppd);
@@ -9008,9 +9008,9 @@ set_local_link_attributes_fail:
 }
 
 /*
- * Call this to start the link.  Schedule a retry if the cable is not
- * present or if unable to start polling.  Do not do anything if the
- * link is disabled.  Returns 0 if link is disabled or moved to polling
+ * Call this to start the link.
+ * Do not do anything if the link is disabled.
+ * Returns 0 if link is disabled, moved to polling, or the driver is not ready.
  */
 int start_link(struct hfi1_pportdata *ppd)
 {
@@ -9027,15 +9027,7 @@ int start_link(struct hfi1_pportdata *ppd)
 		return 0;
 	}
 
-	if (qsfp_mod_present(ppd) || loopback == LOOPBACK_SERDES ||
-	    loopback == LOOPBACK_LCB ||
-	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
-		return set_link_state(ppd, HLS_DN_POLL);
-
-	dd_dev_info(ppd->dd,
-		    "%s: stopping link start because no cable is present\n",
-		    __func__);
-	return -EAGAIN;
+	return set_link_state(ppd, HLS_DN_POLL);
 }
 
 static void wait_for_qsfp_init(struct hfi1_pportdata *ppd)
@@ -9206,7 +9198,7 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 	return 0;
 }
 
-/* This routine will only be scheduled if the QSFP module is present */
+/* This routine will only be scheduled if the QSFP module present is asserted */
 void qsfp_event(struct work_struct *work)
 {
 	struct qsfp_data *qd;
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 19d0223..b97027d 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -838,9 +838,11 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 			total_atten = platform_atten + remote_atten;
 
 			tuning_method = OPA_PASSIVE_TUNING;
-		} else
+		} else {
 			ppd->offline_disabled_reason =
 			     HFI1_ODR_MASK(OPA_LINKDOWN_REASON_CHASSIS_CONFIG);
+			goto bail;
+		}
 		break;
 	case PORT_TYPE_QSFP:
 		if (qsfp_mod_present(ppd)) {
@@ -869,10 +871,12 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 					   __func__);
 				goto bail;
 			}
-		} else
+		} else {
 			ppd->offline_disabled_reason =
 			   HFI1_ODR_MASK(
 				OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED);
+			goto bail;
+		}
 		break;
 	default:
 		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
