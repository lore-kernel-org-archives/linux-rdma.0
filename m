From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 2/2] i40iw: Change accelerated flag to bool
Date: Sun, 17 Dec 2017 12:21:39 -0600
Message-ID: <20171217182139.17096-3-shiraz.saleem@intel.com>
References: <20171217182139.17096-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171217182139.17096-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The accelerated flag only utilizes two values: 0 and 1.
Modify accelerated flag in struct i40iw_cm_node to bool.

Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
 drivers/infiniband/hw/i40iw/i40iw_cm.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 77870f9..0d4c2f4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3691,7 +3691,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_node->qhash_set = false;
 	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
 
-	cm_node->accelerated = 1;
+	cm_node->accelerated = true;
 	status =
 		i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_ESTABLISHED, 0);
 	if (status)
@@ -4058,7 +4058,7 @@ static void i40iw_cm_event_connected(struct i40iw_cm_event *event)
 	cm_node->qhash_set = false;
 	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
 
-	cm_node->accelerated = 1;
+	cm_node->accelerated = true;
 	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY,
 				     0);
 	if (status)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 0d5840d..e09b1f5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -337,7 +337,7 @@ struct i40iw_cm_node {
 	u16     mpav2_ird_ord;
 	struct iw_cm_id *cm_id;
 	struct list_head list;
-	int accelerated;
+	bool accelerated;
 	struct i40iw_cm_listener *listener;
 	int apbvt_set;
 	int accept_pend;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
