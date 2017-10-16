From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/12] i40iw: Account for IPv6 header when setting MSS
Date: Mon, 16 Oct 2017 15:45:59 -0500
Message-ID: <20171016204605.37512-7-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The IPv6 header size is not subtracted from MTU when MSS is
set for QPs.

Save MTU opposed to MSS in the vsi struct during
initialization and calculate the MSS based on IPv4 vs
IPv6 connection.

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h      | 3 ---
 drivers/infiniband/hw/i40iw/i40iw_cm.c   | 3 ++-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 5 ++---
 drivers/infiniband/hw/i40iw/i40iw_d.h    | 4 ++++
 drivers/infiniband/hw/i40iw/i40iw_main.c | 6 +++---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 3 ++-
 drivers/infiniband/hw/i40iw/i40iw_type.h | 4 ++--
 7 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index a65e4cbd..4ae9131 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -119,9 +119,6 @@
 #define I40IW_CQP_COMPL_SQ_WQE_FLUSHED    3
 #define I40IW_CQP_COMPL_RQ_SQ_WQE_FLUSHED 4
 
-#define I40IW_MTU_TO_MSS		40
-#define I40IW_DEFAULT_MSS		1460
-
 struct i40iw_cqp_compl_info {
 	u32 op_ret_val;
 	u16 maj_err_code;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index f5cfb22..596a46b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2193,7 +2193,8 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 			I40IW_CM_DEFAULT_RCV_WND_SCALED >> I40IW_CM_DEFAULT_RCV_WND_SCALE;
 	ts = current_kernel_time();
 	cm_node->tcp_cntxt.loc_seq_num = ts.tv_nsec;
-	cm_node->tcp_cntxt.mss = iwdev->vsi.mss;
+	cm_node->tcp_cntxt.mss = (cm_node->ipv4) ? (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV4) :
+				 (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV6);
 
 	cm_node->iwdev = iwdev;
 	cm_node->dev = &iwdev->sc_dev;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 58249d0..eabbd6d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -348,7 +348,7 @@ void i40iw_change_l2params(struct i40iw_sc_vsi *vsi, struct i40iw_l2params *l2pa
 	u16 qs_handle;
 	int i;
 
-	vsi->mss = l2params->mss;
+	vsi->mtu = l2params->mtu;
 
 	i40iw_fill_qos_list(l2params->qs_handle_list);
 	for (i = 0; i < I40IW_MAX_USER_PRIORITY; i++) {
@@ -4582,9 +4582,8 @@ void i40iw_sc_vsi_init(struct i40iw_sc_vsi *vsi, struct i40iw_vsi_init_info *inf
 
 	vsi->dev = info->dev;
 	vsi->back_vsi = info->back_vsi;
-	vsi->mss = info->params->mss;
+	vsi->mtu = info->params->mtu;
 	vsi->exception_lan_queue = info->exception_lan_queue;
-
 	i40iw_fill_qos_list(info->params->qs_handle_list);
 
 	for (i = 0; i < I40IW_MAX_USER_PRIORITY; i++) {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index 40d4743..17ed45b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -73,6 +73,10 @@
 #define I40IW_FIRST_NON_PF_STAT	4
 
 
+#define I40IW_MTU_TO_MSS_IPV4		40
+#define I40IW_MTU_TO_MSS_IPV6		60
+#define I40IW_DEFAULT_MTU		1500
+
 #define LS_64_1(val, bits)      ((u64)(uintptr_t)val << bits)
 #define RS_64_1(val, bits)      ((u64)(uintptr_t)val >> bits)
 #define LS_32_1(val, bits)      (u32)(val << bits)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index ee0323f..438f526 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1327,8 +1327,8 @@ static enum i40iw_status_code i40iw_initialize_dev(struct i40iw_device *iwdev,
 	info.bar0 = ldev->hw_addr;
 	info.hw = &iwdev->hw;
 	info.debug_mask = debug;
-	l2params.mss =
-		(ldev->params.mtu) ? ldev->params.mtu - I40IW_MTU_TO_MSS : I40IW_DEFAULT_MSS;
+	l2params.mtu =
+		(ldev->params.mtu) ? ldev->params.mtu : I40IW_DEFAULT_MTU;
 	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++) {
 		qset = ldev->params.qos.prio_qos[i].qs_handle;
 		l2params.qs_handle_list[i] = qset;
@@ -1748,7 +1748,7 @@ static void i40iw_l2param_change(struct i40e_info *ldev, struct i40e_client *cli
 	for (i = 0; i < I40E_CLIENT_MAX_USER_PRIORITY; i++)
 		l2params->qs_handle_list[i] = params->qos.prio_qos[i].qs_handle;
 
-	l2params->mss = (params->mtu) ? params->mtu - I40IW_MTU_TO_MSS : iwdev->vsi.mss;
+	l2params->mtu = (params->mtu) ? params->mtu : iwdev->vsi.mtu;
 
 	INIT_WORK(&work->work, i40iw_l2params_worker);
 	queue_work(iwdev->param_wq, &work->work);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index 2a3bf64..875898b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -1404,7 +1404,8 @@ static void i40iw_ieq_handle_exception(struct i40iw_puda_rsrc *ieq,
 		pfpdu->rcv_nxt = fps;
 		pfpdu->fps = fps;
 		pfpdu->mode = true;
-		pfpdu->max_fpdu_data = ieq->vsi->mss;
+		pfpdu->max_fpdu_data = (buf->ipv4) ? (ieq->vsi->mtu - I40IW_MTU_TO_MSS_IPV4) :
+				       (ieq->vsi->mtu - I40IW_MTU_TO_MSS_IPV6);
 		pfpdu->pmode_count++;
 		INIT_LIST_HEAD(rxlist);
 		i40iw_ieq_check_first_buf(buf, fps);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index c718a525..fb20d91 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -459,7 +459,7 @@ struct i40iw_sc_vsi {
 	struct i40iw_virt_mem ieq_mem;
 	struct i40iw_puda_rsrc *ieq;
 	u16 exception_lan_queue;
-	u16 mss;
+	u16 mtu;
 	u8 fcn_id;
 	bool stats_fcn_id_alloc;
 	struct i40iw_qos qos[I40IW_MAX_USER_PRIORITY];
@@ -565,7 +565,7 @@ struct i40iw_ccq_cqe_info {
 
 struct i40iw_l2params {
 	u16 qs_handle_list[I40IW_MAX_USER_PRIORITY];
-	u16 mss;
+	u16 mtu;
 };
 
 struct i40iw_vsi_init_info {
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
