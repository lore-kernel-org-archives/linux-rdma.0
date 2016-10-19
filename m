From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Enable message packing
Date: Wed, 19 Oct 2016 15:32:53 -0500
Message-ID: <20161019203253.14316-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the parameter to disable message packing and
always enable it.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 5 -----
 drivers/infiniband/hw/i40iw/i40iw_main.c | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_type.h | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 31c4a0c..6c6a1ef 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -429,12 +429,10 @@ static enum i40iw_status_code i40iw_sc_cqp_init(struct i40iw_sc_cqp *cqp,
 /**
  * i40iw_sc_cqp_create - create cqp during bringup
  * @cqp: struct for cqp hw
- * @disable_pfpdus: if pfpdu to be disabled
  * @maj_err: If error, major err number
  * @min_err: If error, minor err number
  */
 static enum i40iw_status_code i40iw_sc_cqp_create(struct i40iw_sc_cqp *cqp,
-						  bool disable_pfpdus,
 						  u16 *maj_err,
 						  u16 *min_err)
 {
@@ -453,9 +451,6 @@ static enum i40iw_status_code i40iw_sc_cqp_create(struct i40iw_sc_cqp *cqp,
 	temp = LS_64(cqp->hw_sq_size, I40IW_CQPHC_SQSIZE) |
 	       LS_64(cqp->struct_ver, I40IW_CQPHC_SVER);
 
-	if (disable_pfpdus)
-		temp |= LS_64(1, I40IW_CQPHC_DISABLE_PFPDUS);
-
 	set_64bit_val(cqp->host_ctx, 0, temp);
 	set_64bit_val(cqp->host_ctx, 8, cqp->sq_pa);
 	temp = LS_64(cqp->enabled_vf_count, I40IW_CQPHC_ENABLED_VFS) |
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index e6dafc7..2a4ca8a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -603,7 +603,7 @@ static enum i40iw_status_code i40iw_create_cqp(struct i40iw_device *iwdev)
 		i40iw_pr_err("cqp init status %d\n", status);
 		goto exit;
 	}
-	status = dev->cqp_ops->cqp_create(dev->cqp, true, &maj_err, &min_err);
+	status = dev->cqp_ops->cqp_create(dev->cqp, &maj_err, &min_err);
 	if (status) {
 		i40iw_pr_err("cqp create status %d maj_err %d min_err %d\n",
 			     status, maj_err, min_err);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index b6f448a..d1847e6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -988,7 +988,7 @@ struct i40iw_cqp_query_fpm_values {
 struct i40iw_cqp_ops {
 	enum i40iw_status_code (*cqp_init)(struct i40iw_sc_cqp *,
 					   struct i40iw_cqp_init_info *);
-	enum i40iw_status_code (*cqp_create)(struct i40iw_sc_cqp *, bool, u16 *, u16 *);
+	enum i40iw_status_code (*cqp_create)(struct i40iw_sc_cqp *, u16 *, u16 *);
 	void (*cqp_post_sq)(struct i40iw_sc_cqp *);
 	u64 *(*cqp_get_next_send_wqe)(struct i40iw_sc_cqp *, u64 scratch);
 	enum i40iw_status_code (*cqp_destroy)(struct i40iw_sc_cqp *);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
