From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 03/16] RDMA/i40iw: Fix refused connections
Date: Mon, 18 Apr 2016 10:32:56 -0500
Message-ID: <1460993589-9428-4-git-send-email-mustafa.ismail@intel.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Make sure cm_node is setup before sending SYN packet and
ORD/IRD negotiation.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 85 ++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 38f917a..bdd4104 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2852,7 +2852,6 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 					void *private_data,
 					struct i40iw_cm_info *cm_info)
 {
-	int ret;
 	struct i40iw_cm_node *cm_node;
 	struct i40iw_cm_listener *loopback_remotelistener;
 	struct i40iw_cm_node *loopback_remotenode;
@@ -2922,29 +2921,6 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 	memcpy(cm_node->pdata_buf, private_data, private_data_len);
 
 	cm_node->state = I40IW_CM_STATE_SYN_SENT;
-	ret = i40iw_send_syn(cm_node, 0);
-
-	if (ret) {
-		if (cm_node->ipv4)
-			i40iw_debug(cm_node->dev,
-				    I40IW_DEBUG_CM,
-				    "Api - connect() FAILED: dest addr=%pI4",
-				    cm_node->rem_addr);
-		else
-			i40iw_debug(cm_node->dev, I40IW_DEBUG_CM,
-				    "Api - connect() FAILED: dest addr=%pI6",
-				    cm_node->rem_addr);
-		i40iw_rem_ref_cm_node(cm_node);
-		cm_node = NULL;
-	}
-
-	if (cm_node)
-		i40iw_debug(cm_node->dev,
-			    I40IW_DEBUG_CM,
-			    "Api - connect(): port=0x%04x, cm_node=%p, cm_id = %p.\n",
-			    cm_node->rem_port,
-			    cm_node,
-			    cm_node->cm_id);
 
 	return cm_node;
 }
@@ -3828,23 +3804,8 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 				       conn_param->private_data_len,
 				       (void *)conn_param->private_data,
 				       &cm_info);
-	if (!cm_node) {
-		i40iw_manage_qhash(iwdev,
-				   &cm_info,
-				   I40IW_QHASH_TYPE_TCP_ESTABLISHED,
-				   I40IW_QHASH_MANAGE_TYPE_DELETE,
-				   NULL,
-				   false);
-
-		if (apbvt_set && !i40iw_listen_port_in_use(&iwdev->cm_core,
-							   cm_info.loc_port))
-			i40iw_manage_apbvt(iwdev,
-					   cm_info.loc_port,
-					   I40IW_MANAGE_APBVT_DEL);
-		cm_id->rem_ref(cm_id);
-		iwdev->cm_core.stats_connect_errs++;
-		return -ENOMEM;
-	}
+	if (!cm_node)
+		goto err;
 
 	i40iw_record_ird_ord(cm_node, (u16)conn_param->ird, (u16)conn_param->ord);
 	if (cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO &&
@@ -3857,7 +3818,49 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_node->iwqp = iwqp;
 	iwqp->cm_id = cm_id;
 	i40iw_add_ref(&iwqp->ibqp);
+
+	if (cm_node->state == I40IW_CM_STATE_SYN_SENT) {
+		if (i40iw_send_syn(cm_node, 0)) {
+			i40iw_rem_ref_cm_node(cm_node);
+			goto err;
+		}
+	}
+
+	i40iw_debug(cm_node->dev,
+		    I40IW_DEBUG_CM,
+		    "Api - connect(): port=0x%04x, cm_node=%p, cm_id = %p.\n",
+		    cm_node->rem_port,
+		    cm_node,
+		    cm_node->cm_id);
 	return 0;
+
+err:
+	if (cm_node) {
+		if (cm_node->ipv4)
+			i40iw_debug(cm_node->dev,
+				    I40IW_DEBUG_CM,
+				    "Api - connect() FAILED: dest addr=%pI4",
+				    cm_node->rem_addr);
+		else
+			i40iw_debug(cm_node->dev, I40IW_DEBUG_CM,
+				    "Api - connect() FAILED: dest addr=%pI6",
+				    cm_node->rem_addr);
+	}
+	i40iw_manage_qhash(iwdev,
+			   &cm_info,
+			   I40IW_QHASH_TYPE_TCP_ESTABLISHED,
+			   I40IW_QHASH_MANAGE_TYPE_DELETE,
+			   NULL,
+			   false);
+
+	if (apbvt_set && !i40iw_listen_port_in_use(&iwdev->cm_core,
+						   cm_info.loc_port))
+		i40iw_manage_apbvt(iwdev,
+				   cm_info.loc_port,
+				   I40IW_MANAGE_APBVT_DEL);
+	cm_id->rem_ref(cm_id);
+	iwdev->cm_core.stats_connect_errs++;
+	return -ENOMEM;
 }
 
 /**
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
