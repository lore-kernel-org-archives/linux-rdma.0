From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 5/5] i40iw: Notify user of established connection after QP in RTS
Date: Tue, 21 Nov 2017 16:18:34 -0600
Message-ID: <20171121221834.12524-6-henry.orosco@intel.com>
References: <20171121221834.12524-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121221834.12524-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Established CM event is sent prior to modifying QP to RTS state.
This can result in application closing the connection before the
QP is actually in RTS state. Move sending of established CM
event to after modify QP to RTS.

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 3a35d56..a2b242d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3687,11 +3687,15 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_id->add_ref(cm_id);
 	i40iw_add_ref(&iwqp->ibqp);
 
-	i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_ESTABLISHED, 0);
-
 	attr.qp_state = IB_QPS_RTS;
 	cm_node->qhash_set = false;
 	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+
+	cm_node->accelerated = 1;
+	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_ESTABLISHED, 0);
+	if (status)
+		i40iw_debug(dev, I40IW_DEBUG_CM, "error sending cm event - ESTABLISHED\n");
+
 	if (cm_node->loopbackpartner) {
 		cm_node->loopbackpartner->pdata.size = conn_param->private_data_len;
 
@@ -3702,7 +3706,6 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		i40iw_create_event(cm_node->loopbackpartner, I40IW_CM_EVENT_CONNECTED);
 	}
 
-	cm_node->accelerated = 1;
 	if (cm_node->accept_pend) {
 		atomic_dec(&cm_node->listener->pend_accepts_cnt);
 		cm_node->accept_pend = 0;
@@ -4047,9 +4050,6 @@ static void i40iw_cm_event_connected(struct i40iw_cm_event *event)
 	dev->iw_priv_qp_ops->qp_send_rtt(&iwqp->sc_qp, read0);
 	if (iwqp->page)
 		kunmap(iwqp->page);
-	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY, 0);
-	if (status)
-		i40iw_pr_err("send cm event\n");
 
 	memset(&attr, 0, sizeof(attr));
 	attr.qp_state = IB_QPS_RTS;
@@ -4057,6 +4057,9 @@ static void i40iw_cm_event_connected(struct i40iw_cm_event *event)
 	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
 
 	cm_node->accelerated = 1;
+	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY, 0);
+	if (status)
+		i40iw_debug(dev, I40IW_DEBUG_CM, "error sending cm event - CONNECT_REPLY\n");
 
 	return;
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
