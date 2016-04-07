From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 11/16] i40iw: Correct return code check in add_pble_pool
Date: Thu,  7 Apr 2016 11:30:59 -0500
Message-ID: <1460046664-552-12-git-send-email-mustafa.ismail@intel.com>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460046664-552-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move return code check to immediately after i40iw_hmc_sd_one call
where it is set instead of outside the then statement.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_pble.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
index ded853d..85993dc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_pble.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_pble.c
@@ -404,13 +404,14 @@ static enum i40iw_status_code add_pble_pool(struct i40iw_sc_dev *dev,
 			sd_entry->u.pd_table.pd_page_addr.pa : sd_entry->u.bp.addr.pa;
 	if (sd_entry->valid)
 		return 0;
-	if (dev->is_pf)
+	if (dev->is_pf) {
 		ret_code = i40iw_hmc_sd_one(dev, hmc_info->hmc_fn_id,
 					    sd_reg_val, idx->sd_idx,
 					    sd_entry->entry_type, true);
-	if (ret_code) {
-		i40iw_pr_err("cqp cmd failed for sd (pbles)\n");
-		goto error;
+		if (ret_code) {
+			i40iw_pr_err("cqp cmd failed for sd (pbles)\n");
+			goto error;
+		}
 	}
 
 	sd_entry->valid = true;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
