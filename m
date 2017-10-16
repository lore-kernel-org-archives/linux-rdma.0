From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/12] i40iw: Remove UDA QP from QoS list if creation fails
Date: Mon, 16 Oct 2017 15:46:04 -0500
Message-ID: <20171016204605.37512-12-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ivan Barrera <ivan.d.barrera-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ivan Barrera <ivan.d.barrera-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If User-space Direct Access (UDA) QP creation fails,
the QP entry is not removed from QoS list. Fix this
by removing QP from QoS list if create QP fails.

Fixes: 0fc2dc58896f ("i40iw: Add Quality of Service support")
Signed-off-by: Ivan Barrera <ivan.d.barrera-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h    | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 70d86bc..25625a4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -377,7 +377,7 @@ void i40iw_change_l2params(struct i40iw_sc_vsi *vsi, struct i40iw_l2params *l2pa
  * i40iw_qp_rem_qos - remove qp from qos lists during destroy qp
  * @qp: qp to be removed from qos
  */
-static void i40iw_qp_rem_qos(struct i40iw_sc_qp *qp)
+void i40iw_qp_rem_qos(struct i40iw_sc_qp *qp)
 {
 	struct i40iw_sc_vsi *vsi = qp->vsi;
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_p.h b/drivers/infiniband/hw/i40iw/i40iw_p.h
index 717fbe7..e99311a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_p.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_p.h
@@ -84,7 +84,7 @@ void i40iw_sc_vsi_init(struct i40iw_sc_vsi *vsi, struct i40iw_vsi_init_info *inf
 
 void i40iw_change_l2params(struct i40iw_sc_vsi *vsi, struct i40iw_l2params *l2params);
 void i40iw_qp_add_qos(struct i40iw_sc_qp *qp);
-
+void i40iw_qp_rem_qos(struct i40iw_sc_qp *qp);
 void i40iw_terminate_send_fin(struct i40iw_sc_qp *qp);
 
 void i40iw_terminate_connection(struct i40iw_sc_qp *qp, struct i40iw_aeqe_info *info);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index d75fc81..95355c8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -618,8 +618,10 @@ static enum i40iw_status_code i40iw_puda_qp_create(struct i40iw_puda_rsrc *rsrc)
 		ret = i40iw_cqp_qp_create_cmd(rsrc->dev, qp);
 	else
 		ret = i40iw_puda_qp_wqe(rsrc->dev, qp);
-	if (ret)
+	if (ret) {
+		i40iw_qp_rem_qos(qp);
 		i40iw_free_dma_mem(rsrc->dev->hw, &rsrc->qpmem);
+	}
 	return ret;
 }
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
