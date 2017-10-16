From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/12] i40iw: Move exception_lan_queue to VSI structure
Date: Mon, 16 Oct 2017 15:45:57 -0500
Message-ID: <20171016204605.37512-5-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Consolidate exception_lan_queue under VSI structure
where it belongs. Remove it from device and QP structures.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 6 +++---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 4 ++--
 drivers/infiniband/hw/i40iw/i40iw_type.h | 5 ++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index f75144e..58249d0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2406,7 +2406,6 @@ static enum i40iw_status_code i40iw_sc_qp_init(struct i40iw_sc_qp *qp,
 	qp->rcv_tph_en = info->rcv_tph_en;
 	qp->xmit_tph_en = info->xmit_tph_en;
 	qp->qs_handle = qp->vsi->qos[qp->user_pri].qs_handle;
-	qp->exception_lan_queue = qp->pd->dev->exception_lan_queue;
 
 	return 0;
 }
@@ -2741,7 +2740,7 @@ static enum i40iw_status_code i40iw_sc_qp_setctx(
 		      LS_64(qp->sq_tph_val, I40IWQPC_SQTPHVAL) |
 		      LS_64(qp->rq_tph_val, I40IWQPC_RQTPHVAL) |
 		      LS_64(qp->qs_handle, I40IWQPC_QSHANDLE) |
-		      LS_64(qp->exception_lan_queue, I40IWQPC_EXCEPTION_LAN_QUEUE));
+		      LS_64(vsi->exception_lan_queue, I40IWQPC_EXCEPTION_LAN_QUEUE));
 
 	if (info->iwarp_info_valid) {
 		qw0 |= LS_64(iw->ddp_ver, I40IWQPC_DDP_VER) |
@@ -4584,6 +4583,8 @@ void i40iw_sc_vsi_init(struct i40iw_sc_vsi *vsi, struct i40iw_vsi_init_info *inf
 	vsi->dev = info->dev;
 	vsi->back_vsi = info->back_vsi;
 	vsi->mss = info->params->mss;
+	vsi->exception_lan_queue = info->exception_lan_queue;
+
 	i40iw_fill_qos_list(info->params->qs_handle_list);
 
 	for (i = 0; i < I40IW_MAX_USER_PRIORITY; i++) {
@@ -5067,7 +5068,6 @@ enum i40iw_status_code i40iw_device_init(struct i40iw_sc_dev *dev,
 	dev->debug_mask = info->debug_mask;
 
 	dev->hmc_fn_id = info->hmc_fn_id;
-	dev->exception_lan_queue = info->exception_lan_queue;
 	dev->is_pf = info->is_pf;
 
 	dev->fpm_query_buf_pa = info->fpm_query_buf_pa;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 27590ae..ee0323f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -958,7 +958,7 @@ static enum i40iw_status_code i40iw_initialize_ieq(struct i40iw_device *iwdev)
 	memset(&info, 0, sizeof(info));
 	info.type = I40IW_PUDA_RSRC_TYPE_IEQ;
 	info.cq_id = 2;
-	info.qp_id = iwdev->sc_dev.exception_lan_queue;
+	info.qp_id = iwdev->vsi.exception_lan_queue;
 	info.count = 1;
 	info.pd_id = 2;
 	info.sq_size = 8192;
@@ -1338,7 +1338,6 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 			iwdev->dcb = true;
 	}
 	i40iw_pr_info("DCB is set/clear = %d\n", iwdev->dcb);
-	info.exception_lan_queue = 1;
 	info.vchnl_send = i40iw_virtchnl_send;
 	status = i40iw_device_init(&iwdev->sc_dev, &info);
 
@@ -1348,6 +1347,7 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 	vsi_info.dev = &iwdev->sc_dev;
 	vsi_info.back_vsi = (void *)iwdev;
 	vsi_info.params = &l2params;
+	vsi_info.exception_lan_queue = 1;
 	i40iw_sc_vsi_init(&iwdev->vsi, &vsi_info);
 
 	if (dev->is_pf) {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index 0ee450d4..c718a525 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -380,7 +380,6 @@ struct i40iw_sc_qp {
 	u8 *q2_buf;
 	u64 qp_compl_ctx;
 	u16 qs_handle;
-	u16 exception_lan_queue;
 	u16 push_idx;
 	u8 sq_tph_val;
 	u8 rq_tph_val;
@@ -459,6 +458,7 @@ struct i40iw_sc_vsi {
 	u32 ieq_count;
 	struct i40iw_virt_mem ieq_mem;
 	struct i40iw_puda_rsrc *ieq;
+	u16 exception_lan_queue;
 	u16 mss;
 	u8 fcn_id;
 	bool stats_fcn_id_alloc;
@@ -501,7 +501,6 @@ struct i40iw_sc_dev {
 
 	struct i40iw_hmc_fpm_misc hmc_fpm_misc;
 	u32 debug_mask;
-	u16 exception_lan_queue;
 	u8 hmc_fn_id;
 	bool is_pf;
 	bool vchnl_up;
@@ -573,6 +572,7 @@ struct i40iw_vsi_init_info {
 	struct i40iw_sc_dev *dev;
 	void  *back_vsi;
 	struct i40iw_l2params *params;
+	u16 exception_lan_queue;
 };
 
 struct i40iw_vsi_stats_info {
@@ -590,7 +590,6 @@ struct i40iw_device_init_info {
 	struct i40iw_hw *hw;
 	void __iomem *bar0;
 	enum i40iw_status_code (*vchnl_send)(struct i40iw_sc_dev *, u32, u8 *, u16);
-	u16 exception_lan_queue;
 	u8 hmc_fn_id;
 	bool is_pf;
 	u32 debug_mask;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
