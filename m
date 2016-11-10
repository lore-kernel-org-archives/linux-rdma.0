From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Remove check on return from device_init_pestat()
Date: Wed,  9 Nov 2016 21:42:26 -0600
Message-ID: <20161110034226.21248-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove unnecessary check for return code from
device_init_pestat() and change func to void.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 10 ++--------
 drivers/infiniband/hw/i40iw/i40iw_p.h        |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  6 +-----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 57a4236..9a5f4b8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -4709,10 +4709,9 @@ static void i40iw_hw_stat_refresh_all(struct i40iw_dev_pestat *devstat)
  * i40iw_device_init_pestat - Initialize the pestat structure
  * @dev: pestat struct
  */
-enum i40iw_status_code i40iw_device_init_pestat(struct i40iw_dev_pestat *devstat)
+void i40iw_device_init_pestat(struct i40iw_dev_pestat *devstat)
 {
 	devstat->ops = iw_device_pestat_ops;
-	return 0;
 }
 
 /**
@@ -4736,12 +4735,7 @@ enum i40iw_status_code i40iw_device_init(struct i40iw_sc_dev *dev,
 
 	dev->debug_mask = info->debug_mask;
 
-	ret_code = i40iw_device_init_pestat(&dev->dev_pestat);
-	if (ret_code) {
-		i40iw_debug(dev, I40IW_DEBUG_DEV,
-			    "%s: i40iw_device_init_pestat failed\n", __func__);
-		return ret_code;
-	}
+	i40iw_device_init_pestat(&dev->dev_pestat);
 	dev->hmc_fn_id = info->hmc_fn_id;
 	dev->qs_handle = info->qs_handle;
 	dev->exception_lan_queue = info->exception_lan_queue;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_p.h b/drivers/infiniband/hw/i40iw/i40iw_p.h
index a0b8ca1..8a59c74 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_p.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_p.h
@@ -47,7 +47,7 @@ void i40iw_debug_buf(struct i40iw_sc_dev *dev, enum i40iw_debug_flag mask,
 enum i40iw_status_code i40iw_device_init(struct i40iw_sc_dev *dev,
 					 struct i40iw_device_init_info *info);
 
-enum i40iw_status_code i40iw_device_init_pestat(struct i40iw_dev_pestat *);
+void i40iw_device_init_pestat(struct i40iw_dev_pestat *devstat);
 
 void i40iw_sc_cqp_post_sq(struct i40iw_sc_cqp *cqp);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
index 3041003..dbd39c4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
@@ -496,11 +496,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct i40iw_sc_dev *dev,
 				i40iw_debug(dev, I40IW_DEBUG_VIRT,
 					    "VF%u error CQP HMC Function operation.\n",
 					    vf_id);
-			ret_code = i40iw_device_init_pestat(&vf_dev->dev_pestat);
-			if (ret_code)
-				i40iw_debug(dev, I40IW_DEBUG_VIRT,
-					    "VF%u - i40iw_device_init_pestat failed\n",
-					    vf_id);
+			i40iw_device_init_pestat(&vf_dev->dev_pestat);
 			vf_dev->dev_pestat.ops.iw_hw_stat_init(&vf_dev->dev_pestat,
 							      (u8)vf_dev->pmf_index,
 							      dev->hw, false);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
