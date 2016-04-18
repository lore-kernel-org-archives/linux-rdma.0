From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 15/16] RDMA/i40iw: Fix SD calculation for initial HMC creation
Date: Mon, 18 Apr 2016 10:33:08 -0500
Message-ID: <1460993589-9428-16-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Correct SD calculation by using base address returned from commit FPM.
This alleviates any assumptions on resource ordering and alignment
requirement. Also consolidate SD estimation code into i40iw_est_sd().

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 93 +++++++++++++++++++++-----------
 drivers/infiniband/hw/i40iw/i40iw_type.h |  2 +-
 2 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 023a7ae..2c4b4d0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -114,16 +114,21 @@ static enum i40iw_status_code i40iw_cqp_poll_registers(
  * i40iw_sc_parse_fpm_commit_buf - parse fpm commit buffer
  * @buf: ptr to fpm commit buffer
  * @info: ptr to i40iw_hmc_obj_info struct
+ * @sd: number of SDs for HMC objects
  *
  * parses fpm commit info and copy base value
  * of hmc objects in hmc_info
  */
 static enum i40iw_status_code i40iw_sc_parse_fpm_commit_buf(
 				u64 *buf,
-				struct i40iw_hmc_obj_info *info)
+				struct i40iw_hmc_obj_info *info,
+				u32 *sd)
 {
 	u64 temp;
+	u64 size;
+	u64 base = 0;
 	u32 i, j;
+	u32 k = 0;
 	u32 low;
 
 	/* copy base values in obj_info */
@@ -131,10 +136,20 @@ static enum i40iw_status_code i40iw_sc_parse_fpm_commit_buf(
 			i <= I40IW_HMC_IW_PBLE; i++, j += 8) {
 		get_64bit_val(buf, j, &temp);
 		info[i].base = RS_64_1(temp, 32) * 512;
+		if (info[i].base > base) {
+			base = info[i].base;
+			k = i;
+		}
 		low = (u32)(temp);
 		if (low)
 			info[i].cnt = low;
 	}
+	size = info[k].cnt * info[k].size + info[k].base;
+	if (size & 0x1FFFFF)
+		*sd = (u32)((size >> 21) + 1); /* add 1 for remainder */
+	else
+		*sd = (u32)(size >> 21);
+
 	return 0;
 }
 
@@ -3206,7 +3221,7 @@ enum i40iw_status_code i40iw_sc_init_iw_hmc(struct i40iw_sc_dev *dev, u8 hmc_fn_
 		i40iw_cqp_commit_fpm_values_cmd(dev, &query_fpm_mem, hmc_fn_id);
 
 		/* parse the fpm_commit_buf and fill hmc obj info */
-		i40iw_sc_parse_fpm_commit_buf((u64 *)query_fpm_mem.va, hmc_info->hmc_obj);
+		i40iw_sc_parse_fpm_commit_buf((u64 *)query_fpm_mem.va, hmc_info->hmc_obj, &hmc_info->sd_table.sd_cnt);
 		mem_size = sizeof(struct i40iw_hmc_sd_entry) *
 			   (hmc_info->sd_table.sd_cnt + hmc_info->first_sd_index);
 		ret_code = i40iw_allocate_virt_mem(dev->hw, &virt_mem, mem_size);
@@ -3280,7 +3295,9 @@ static enum i40iw_status_code i40iw_sc_configure_iw_fpm(struct i40iw_sc_dev *dev
 
 	/* parse the fpm_commit_buf and fill hmc obj info */
 	if (!ret_code)
-		ret_code = i40iw_sc_parse_fpm_commit_buf(dev->fpm_commit_buf, hmc_info->hmc_obj);
+		ret_code = i40iw_sc_parse_fpm_commit_buf(dev->fpm_commit_buf,
+							 hmc_info->hmc_obj,
+							 &hmc_info->sd_table.sd_cnt);
 
 	i40iw_debug_buf(dev, I40IW_DEBUG_HMC, "COMMIT FPM BUFFER",
 			commit_fpm_mem.va, I40IW_COMMIT_FPM_BUF_SIZE);
@@ -3528,6 +3545,40 @@ static bool i40iw_ring_full(struct i40iw_sc_cqp *cqp)
 }
 
 /**
+ * i40iw_est_sd - returns approximate number of SDs for HMC
+ * @dev: sc device struct
+ * @hmc_info: hmc structure, size and count for HMC objects
+ */
+static u64 i40iw_est_sd(struct i40iw_sc_dev *dev, struct i40iw_hmc_info *hmc_info)
+{
+	int i;
+	u64 size = 0;
+	u64 sd;
+
+	for (i = I40IW_HMC_IW_QP; i < I40IW_HMC_IW_PBLE; i++)
+		size += hmc_info->hmc_obj[i].cnt * hmc_info->hmc_obj[i].size;
+
+	if (dev->is_pf)
+		size += hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].cnt * hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].size;
+
+	if (size & 0x1FFFFF)
+		sd = (size >> 21) + 1; /* add 1 for remainder */
+	else
+		sd = size >> 21;
+
+	if (!dev->is_pf) {
+		/* 2MB alignment for VF PBLE HMC */
+		size = hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].cnt * hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].size;
+		if (size & 0x1FFFFF)
+			sd += (size >> 21) + 1; /* add 1 for remainder */
+		else
+			sd += size >> 21;
+	}
+
+	return sd;
+}
+
+/**
  * i40iw_config_fpm_values - configure HMC objects
  * @dev: sc device struct
  * @qp_count: desired qp count
@@ -3538,7 +3589,7 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 	u32 i, mem_size;
 	u32 qpwantedoriginal, qpwanted, mrwanted, pblewanted;
 	u32 powerof2;
-	u64 sd_needed, bytes_needed;
+	u64 sd_needed;
 	u32 loop_count = 0;
 
 	struct i40iw_hmc_info *hmc_info;
@@ -3556,23 +3607,15 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 		return ret_code;
 	}
 
-	bytes_needed = 0;
-	for (i = I40IW_HMC_IW_QP; i < I40IW_HMC_IW_MAX; i++) {
+	for (i = I40IW_HMC_IW_QP; i < I40IW_HMC_IW_MAX; i++)
 		hmc_info->hmc_obj[i].cnt = hmc_info->hmc_obj[i].max_cnt;
-		bytes_needed +=
-		    (hmc_info->hmc_obj[i].max_cnt) * (hmc_info->hmc_obj[i].size);
-		i40iw_debug(dev, I40IW_DEBUG_HMC,
-			    "%s i[%04d] max_cnt[0x%04X] size[0x%04llx]\n",
-			    __func__, i, hmc_info->hmc_obj[i].max_cnt,
-			    hmc_info->hmc_obj[i].size);
-	}
-	sd_needed = (bytes_needed / I40IW_HMC_DIRECT_BP_SIZE) + 1; /* round up */
+	sd_needed = i40iw_est_sd(dev, hmc_info);
 	i40iw_debug(dev, I40IW_DEBUG_HMC,
 		    "%s: FW initial max sd_count[%08lld] first_sd_index[%04d]\n",
 		    __func__, sd_needed, hmc_info->first_sd_index);
 	i40iw_debug(dev, I40IW_DEBUG_HMC,
-		    "%s: bytes_needed=0x%llx sd count %d where max sd is %d\n",
-		    __func__, bytes_needed, hmc_info->sd_table.sd_cnt,
+		    "%s: sd count %d where max sd is %d\n",
+		    __func__, hmc_info->sd_table.sd_cnt,
 		    hmc_fpm_misc->max_sds);
 
 	qpwanted = min(qp_count, hmc_info->hmc_obj[I40IW_HMC_IW_QP].max_cnt);
@@ -3614,11 +3657,7 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 		hmc_info->hmc_obj[I40IW_HMC_IW_PBLE].cnt = pblewanted;
 
 		/* How much memory is needed for all the objects. */
-		bytes_needed = 0;
-		for (i = I40IW_HMC_IW_QP; i < I40IW_HMC_IW_MAX; i++)
-			bytes_needed +=
-			    (hmc_info->hmc_obj[i].cnt) * (hmc_info->hmc_obj[i].size);
-		sd_needed = (bytes_needed / I40IW_HMC_DIRECT_BP_SIZE) + 1;
+		sd_needed = i40iw_est_sd(dev, hmc_info);
 		if ((loop_count > 1000) ||
 		    ((!(loop_count % 10)) &&
 		    (qpwanted > qpwantedoriginal * 2 / 3))) {
@@ -3639,15 +3678,7 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 			pblewanted -= FPM_MULTIPLIER * 1000;
 	} while (sd_needed > hmc_fpm_misc->max_sds && loop_count < 2000);
 
-	bytes_needed = 0;
-	for (i = I40IW_HMC_IW_QP; i < I40IW_HMC_IW_MAX; i++) {
-		bytes_needed += (hmc_info->hmc_obj[i].cnt) * (hmc_info->hmc_obj[i].size);
-		i40iw_debug(dev, I40IW_DEBUG_HMC,
-			    "%s i[%04d] cnt[0x%04x] size[0x%04llx]\n",
-			    __func__, i, hmc_info->hmc_obj[i].cnt,
-			    hmc_info->hmc_obj[i].size);
-	}
-	sd_needed = (bytes_needed / I40IW_HMC_DIRECT_BP_SIZE) + 1;    /* round up not truncate. */
+	sd_needed = i40iw_est_sd(dev, hmc_info);
 
 	i40iw_debug(dev, I40IW_DEBUG_HMC,
 		    "loop_cnt=%d, sd_needed=%lld, qpcnt = %d, cqcnt=%d, mrcnt=%d, pblecnt=%d\n",
@@ -3665,8 +3696,6 @@ enum i40iw_status_code i40iw_config_fpm_values(struct i40iw_sc_dev *dev, u32 qp_
 		return ret_code;
 	}
 
-	hmc_info->sd_table.sd_cnt = (u32)sd_needed;
-
 	mem_size = sizeof(struct i40iw_hmc_sd_entry) *
 		   (hmc_info->sd_table.sd_cnt + hmc_info->first_sd_index + 1);
 	ret_code = i40iw_allocate_virt_mem(dev->hw, &virt_mem, mem_size);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index e8c9491..937b7ee 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -1112,7 +1112,7 @@ struct i40iw_hmc_ops {
 	enum i40iw_status_code (*parse_fpm_query_buf)(u64 *, struct i40iw_hmc_info *,
 						      struct i40iw_hmc_fpm_misc *);
 	enum i40iw_status_code (*configure_iw_fpm)(struct i40iw_sc_dev *, u8);
-	enum i40iw_status_code (*parse_fpm_commit_buf)(u64 *, struct i40iw_hmc_obj_info *);
+	enum i40iw_status_code (*parse_fpm_commit_buf)(u64 *, struct i40iw_hmc_obj_info *, u32 *sd);
 	enum i40iw_status_code (*create_hmc_object)(struct i40iw_sc_dev *dev,
 						    struct i40iw_hmc_create_obj_info *);
 	enum i40iw_status_code (*del_hmc_object)(struct i40iw_sc_dev *dev,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
