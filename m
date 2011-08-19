From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/20 v2] ib/cm: Update xrc support based on xrc annex errata
Date: Fri, 19 Aug 2011 02:14:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A49@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The xrc annex was updated to have xrc behave more like rdd.
Specifically, the xrc tgt qpn moves from the local qpn to
local eecn field.  Lookup of srqn is done using the REQ/REP
protocol.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I kept this change separate, so that it could be easily discarded.
Once the errata has been approved, it would make sense to merge this
patch with the previous patch before pushing upstream.

 drivers/infiniband/core/cm.c      |   15 ++++++++-------
 drivers/infiniband/core/cm_msgs.h |   19 ++++++++++++++++++-
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d2e1cfb..42a7a9b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1605,7 +1605,6 @@ static void cm_format_rep(struct cm_rep_msg *rep_msg,
 	cm_format_mad_hdr(&rep_msg->hdr, CM_REP_ATTR_ID, cm_id_priv->tid);
 	rep_msg->local_comm_id = cm_id_priv->id.local_id;
 	rep_msg->remote_comm_id = cm_id_priv->id.remote_id;
-	cm_rep_set_local_qpn(rep_msg, cpu_to_be32(param->qp_num));
 	cm_rep_set_starting_psn(rep_msg, cpu_to_be32(param->starting_psn));
 	rep_msg->resp_resources = param->responder_resources;
 	cm_rep_set_target_ack_delay(rep_msg,
@@ -1618,8 +1617,10 @@ static void cm_format_rep(struct cm_rep_msg *rep_msg,
 		rep_msg->initiator_depth = param->initiator_depth;
 		cm_rep_set_flow_ctrl(rep_msg, param->flow_control);
 		cm_rep_set_srq(rep_msg, param->srq);
+		cm_rep_set_local_qpn(rep_msg, cpu_to_be32(param->qp_num));
 	} else {
 		cm_rep_set_srq(rep_msg, 1);
+		cm_rep_set_local_eecn(rep_msg, cpu_to_be32(param->qp_num));
 	}
 
 	if (param->private_data && param->private_data_len)
@@ -1669,7 +1670,7 @@ int ib_send_cm_rep(struct ib_cm_id *cm_id,
 	cm_id_priv->initiator_depth = param->initiator_depth;
 	cm_id_priv->responder_resources = param->responder_resources;
 	cm_id_priv->rq_psn = cm_rep_get_starting_psn(rep_msg);
-	cm_id_priv->local_qpn = cm_rep_get_local_qpn(rep_msg);
+	cm_id_priv->local_qpn = cpu_to_be32(param->qp_num & 0xFFFFFF);
 
 out:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return ret;
@@ -1740,7 +1741,7 @@ error:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 }
 EXPORT_SYMBOL(ib_send_cm_rtu);
 
-static void cm_format_rep_event(struct cm_work *work)
+static void cm_format_rep_event(struct cm_work *work, enum ib_qp_type qp_type)
 {
 	struct cm_rep_msg *rep_msg;
 	struct ib_cm_rep_event_param *param;
@@ -1749,7 +1750,7 @@ static void cm_format_rep_event(struct cm_work *work)
 	param = &work->cm_event.param.rep_rcvd;
 	param->remote_ca_guid = rep_msg->local_ca_guid;
 	param->remote_qkey = be32_to_cpu(rep_msg->local_qkey);
-	param->remote_qpn = be32_to_cpu(cm_rep_get_local_qpn(rep_msg));
+	param->remote_qpn = be32_to_cpu(cm_rep_get_qpn(rep_msg, qp_type));
 	param->starting_psn = be32_to_cpu(cm_rep_get_starting_psn(rep_msg));
 	param->responder_resources = rep_msg->initiator_depth;
 	param->initiator_depth = rep_msg->resp_resources;
@@ -1817,7 +1818,7 @@ static int cm_rep_handler(struct cm_work *work)
 		return -EINVAL;
 	}
 
-	cm_format_rep_event(work);
+	cm_format_rep_event(work, cm_id_priv->qp_type);
 
 	spin_lock_irq(&cm_id_priv->lock);
 	switch (cm_id_priv->id.state) {
@@ -1832,7 +1833,7 @@ static int cm_rep_handler(struct cm_work *work)
 
 	cm_id_priv->timewait_info->work.remote_id = rep_msg->local_comm_id;
 	cm_id_priv->timewait_info->remote_ca_guid = rep_msg->local_ca_guid;
-	cm_id_priv->timewait_info->remote_qpn = cm_rep_get_local_qpn(rep_msg);
+	cm_id_priv->timewait_info->remote_qpn = cm_rep_get_qpn(rep_msg, cm_id_priv->qp_type);
 
 	spin_lock(&cm.lock);
 	/* Check for duplicate REP. */
@@ -1859,7 +1860,7 @@ static int cm_rep_handler(struct cm_work *work)
 
 	cm_id_priv->id.state = IB_CM_REP_RCVD;
 	cm_id_priv->id.remote_id = rep_msg->local_comm_id;
-	cm_id_priv->remote_qpn = cm_rep_get_local_qpn(rep_msg);
+	cm_id_priv->remote_qpn = cm_rep_get_qpn(rep_msg, cm_id_priv->qp_type);
 	cm_id_priv->initiator_depth = rep_msg->resp_resources;
 	cm_id_priv->responder_resources = rep_msg->initiator_depth;
 	cm_id_priv->sq_psn = cm_rep_get_starting_psn(rep_msg);
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index 3ade320..d5dcd05 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2004 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2004,2011 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
  *
@@ -538,6 +538,23 @@ static inline void cm_rep_set_local_qpn(struct cm_rep_msg *rep_msg, __be32 qpn)
 			    (be32_to_cpu(rep_msg->offset12) & 0x000000FF));
 }
 
+static inline __be32 cm_rep_get_local_eecn(struct cm_rep_msg *rep_msg)
+{
+	return cpu_to_be32(be32_to_cpu(rep_msg->offset16) >> 8);
+}
+
+static inline void cm_rep_set_local_eecn(struct cm_rep_msg *rep_msg, __be32 eecn)
+{
+	rep_msg->offset16 = cpu_to_be32((be32_to_cpu(eecn) << 8) |
+			    (be32_to_cpu(rep_msg->offset16) & 0x000000FF));
+}
+
+static inline __be32 cm_rep_get_qpn(struct cm_rep_msg *rep_msg, enum ib_qp_type qp_type)
+{
+	return (qp_type == IB_QPT_XRC_INI) ?
+		cm_rep_get_local_eecn(rep_msg) : cm_rep_get_local_qpn(rep_msg);
+}
+
 static inline __be32 cm_rep_get_starting_psn(struct cm_rep_msg *rep_msg)
 {
 	return cpu_to_be32(be32_to_cpu(rep_msg->offset20) >> 8);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
