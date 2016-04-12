From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/21] IB/hfi1: Fix double QSFP resource acquire on cache
 refresh
Date: Tue, 12 Apr 2016 11:28:36 -0700
Message-ID: <20160412182828.26701.64220.stgit@scvm10.sc.intel.com>
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

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The function refresh_qsfp_cache() acquires the i2c chain resource,
but one caller already holds the resource.  Change the acquire so
all calls to refresh_qsfp_cache() are covered by the acquire and
remove the acquire within refresh_qsfp_cache().

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/platform.c |   40 +++++++++++++++++-----------------
 drivers/staging/rdma/hfi1/qsfp.c     |   12 +++-------
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index b97027d..8fe8a20 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -603,6 +603,7 @@ static void apply_tunings(
 		       "Applying TX settings");
 }
 
+/* Must be holding the QSFP i2c resource */
 static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			    u32 *ptr_rx_preset, u32 *ptr_total_atten)
 {
@@ -610,26 +611,19 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 	u16 lss = ppd->link_speed_supported, lse = ppd->link_speed_enabled;
 	u8 *cache = ppd->qsfp_info.cache;
 
-	ret = acquire_chip_resource(ppd->dd, qsfp_resource(ppd->dd), QSFP_WAIT);
-	if (ret) {
-		dd_dev_err(ppd->dd, "%s: hfi%d: cannot lock i2c chain\n",
-			   __func__, (int)ppd->dd->hfi1_id);
-		return ret;
-	}
-
 	ppd->qsfp_info.limiting_active = 1;
 
 	ret = set_qsfp_tx(ppd, 0);
 	if (ret)
-		goto bail_unlock;
+		return ret;
 
 	ret = qual_power(ppd);
 	if (ret)
-		goto bail_unlock;
+		return ret;
 
 	ret = qual_bitrate(ppd);
 	if (ret)
-		goto bail_unlock;
+		return ret;
 
 	if (ppd->qsfp_info.reset_needed) {
 		reset_qsfp(ppd);
@@ -641,7 +635,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 
 	ret = set_qsfp_high_power(ppd);
 	if (ret)
-		goto bail_unlock;
+		return ret;
 
 	if (cache[QSFP_EQ_INFO_OFFS] & 0x4) {
 		ret = get_platform_config_field(
@@ -651,7 +645,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			ptr_tx_preset, 4);
 		if (ret) {
 			*ptr_tx_preset = OPA_INVALID_INDEX;
-			goto bail_unlock;
+			return ret;
 		}
 	} else {
 		ret = get_platform_config_field(
@@ -661,7 +655,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			ptr_tx_preset, 4);
 		if (ret) {
 			*ptr_tx_preset = OPA_INVALID_INDEX;
-			goto bail_unlock;
+			return ret;
 		}
 	}
 
@@ -670,7 +664,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 		PORT_TABLE_RX_PRESET_IDX, ptr_rx_preset, 4);
 	if (ret) {
 		*ptr_rx_preset = OPA_INVALID_INDEX;
-		goto bail_unlock;
+		return ret;
 	}
 
 	if ((lss & OPA_LINK_SPEED_25G) && (lse & OPA_LINK_SPEED_25G))
@@ -690,8 +684,6 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 
 	ret = set_qsfp_tx(ppd, 1);
 
-bail_unlock:
-	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
 	return ret;
 }
 
@@ -846,6 +838,14 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		break;
 	case PORT_TYPE_QSFP:
 		if (qsfp_mod_present(ppd)) {
+			ret = acquire_chip_resource(ppd->dd,
+						    qsfp_resource(ppd->dd),
+						    QSFP_WAIT);
+			if (ret) {
+				dd_dev_err(ppd->dd, "%s: hfi%d: cannot lock i2c chain\n",
+					   __func__, (int)ppd->dd->hfi1_id);
+				goto bail;
+			}
 			refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 
 			if (ppd->qsfp_info.cache_valid) {
@@ -860,17 +860,17 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 				 * update the cache to reflect the changes
 				 */
 				refresh_qsfp_cache(ppd, &ppd->qsfp_info);
-				if (ret)
-					goto bail;
-
 				limiting_active =
 						ppd->qsfp_info.limiting_active;
 			} else {
 				dd_dev_err(dd,
 					   "%s: Reading QSFP memory failed\n",
 					   __func__);
-				goto bail;
+				ret = -EINVAL; /* a fail indication */
 			}
+			release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
+			if (ret)
+				goto bail;
 		} else {
 			ppd->offline_disabled_reason =
 			   HFI1_ODR_MASK(
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index dc5d186..2441669 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -355,6 +355,8 @@ int one_qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
  * The calls to qsfp_{read,write} in this function correctly handle the
  * address map difference between this mapping and the mapping implemented
  * by those functions
+ *
+ * The caller must be holding the QSFP i2c chain resource.
  */
 int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 {
@@ -371,13 +373,9 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 
 	if (!qsfp_mod_present(ppd)) {
 		ret = -ENODEV;
-		goto bail_no_release;
+		goto bail;
 	}
 
-	ret = acquire_chip_resource(ppd->dd, qsfp_resource(ppd->dd), QSFP_WAIT);
-	if (ret)
-		goto bail_no_release;
-
 	ret = qsfp_read(ppd, target, 0, cache, QSFP_PAGESIZE);
 	if (ret != QSFP_PAGESIZE) {
 		dd_dev_info(ppd->dd,
@@ -440,8 +438,6 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 		}
 	}
 
-	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
-
 	spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 	ppd->qsfp_info.cache_valid = 1;
 	ppd->qsfp_info.cache_refresh_required = 0;
@@ -450,8 +446,6 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 	return 0;
 
 bail:
-	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
-bail_no_release:
 	memset(cache, 0, (QSFP_MAX_NUM_PAGES * 128));
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
