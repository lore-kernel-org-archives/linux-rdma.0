From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/9] IB/hfi1: Reclassify type of messages printed
 for platform config logic
Date: Fri, 26 May 2017 05:35:57 -0700
Message-ID: <20170526123555.8158.42385.stgit@scvm10.sc.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526123257.8158.23943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reclassify messages printed out to /var/log/messages into
warnings and errors to facilitate debugging in the future
for issues related to the platform config logic.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 838fe84..cbda9b1 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -242,7 +242,7 @@ static int qual_power(struct hfi1_pportdata *ppd)
 
 	if (ppd->offline_disabled_reason ==
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY)) {
-		dd_dev_info(
+		dd_dev_err(
 			ppd->dd,
 			"%s: Port disabled due to system power restrictions\n",
 			__func__);
@@ -268,7 +268,7 @@ static int qual_bitrate(struct hfi1_pportdata *ppd)
 
 	if (ppd->offline_disabled_reason ==
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_LINKSPEED_POLICY)) {
-		dd_dev_info(
+		dd_dev_err(
 			ppd->dd,
 			"%s: Cable failed bitrate check, disabling port\n",
 			__func__);
@@ -709,15 +709,15 @@ static void apply_tunings(
 		ret = load_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS,
 				       GENERAL_CONFIG, config_data);
 		if (ret != HCMD_SUCCESS)
-			dd_dev_info(ppd->dd,
-				    "%s: Failed set ext device config params\n",
-				    __func__);
+			dd_dev_err(ppd->dd,
+				   "%s: Failed set ext device config params\n",
+				   __func__);
 	}
 
 	if (tx_preset_index == OPA_INVALID_INDEX) {
 		if (ppd->port_type == PORT_TYPE_QSFP && limiting_active)
-			dd_dev_info(ppd->dd, "%s: Invalid Tx preset index\n",
-				    __func__);
+			dd_dev_err(ppd->dd, "%s: Invalid Tx preset index\n",
+				   __func__);
 		return;
 	}
 
@@ -900,7 +900,7 @@ static int tune_qsfp(struct hfi1_pportdata *ppd,
 	case 0xD: /* fallthrough */
 	case 0xF:
 	default:
-		dd_dev_info(ppd->dd, "%s: Unknown/unsupported cable\n",
+		dd_dev_warn(ppd->dd, "%s: Unknown/unsupported cable\n",
 			    __func__);
 		break;
 	}
@@ -942,7 +942,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 	case PORT_TYPE_DISCONNECTED:
 		ppd->offline_disabled_reason =
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_DISCONNECTED);
-		dd_dev_info(dd, "%s: Port disconnected, disabling port\n",
+		dd_dev_warn(dd, "%s: Port disconnected, disabling port\n",
 			    __func__);
 		goto bail;
 	case PORT_TYPE_FIXED:
@@ -1027,7 +1027,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		}
 		break;
 	default:
-		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);
+		dd_dev_warn(ppd->dd, "%s: Unknown port type\n", __func__);
 		ppd->port_type = PORT_TYPE_UNKNOWN;
 		tuning_method = OPA_UNKNOWN_TUNING;
 		total_atten = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
