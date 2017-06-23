From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] i40iw: Release cm_id ref on PCI function reset
Date: Fri, 23 Jun 2017 16:03:58 -0500
Message-ID: <20170623210402.19988-5-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On PCI function reset, cm_id reference is not released
which causes an application hang, as it waits on the
cm_id to be released on rdma_destroy.

To fix this, call i40iw_cm_disconn during a PCI function
reset to clean-up resources and release cm_id reference.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 6ae98aa..5a2fa74 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3487,7 +3487,8 @@ static void i40iw_cm_disconn_true(struct i40iw_qp *iwqp)
 	if (((original_hw_tcp_state == I40IW_TCP_STATE_CLOSED) ||
 	     (original_hw_tcp_state == I40IW_TCP_STATE_TIME_WAIT) ||
 	     (last_ae == I40IW_AE_RDMAP_ROE_BAD_LLP_CLOSE) ||
-	     (last_ae == I40IW_AE_LLP_CONNECTION_RESET))) {
+	     (last_ae == I40IW_AE_LLP_CONNECTION_RESET) ||
+	      iwdev->reset)) {
 		issue_close = 1;
 		iwqp->cm_id = NULL;
 		if (!iwqp->flush_issued) {
@@ -4265,6 +4266,8 @@ void i40iw_cm_disconnect_all(struct i40iw_device *iwdev)
 		cm_node = container_of(list_node, struct i40iw_cm_node, connected_entry);
 		attr.qp_state = IB_QPS_ERR;
 		i40iw_modify_qp(&cm_node->iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+		if (iwdev->reset)
+			i40iw_cm_disconn(cm_node->iwqp);
 		i40iw_rem_ref_cm_node(cm_node);
 	}
 }
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
