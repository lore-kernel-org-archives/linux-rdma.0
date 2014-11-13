From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 14/16] ib/mad: Create helper function for SMI processing
Date: Thu, 13 Nov 2014 14:54:23 -0500
Message-ID: <1415908465-24392-15-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This helper function will be used for processing both IB and OPA SMPs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 85 +++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 0ddfbd7..7bd67e8 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1965,6 +1965,52 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	}
 }
 
+enum smi_action handle_ib_smi(struct ib_mad_port_private *port_priv,
+			      struct ib_mad_qp_info *qp_info,
+			      struct ib_wc *wc,
+			      int port_num,
+			      struct ib_mad_private *recv,
+			      struct ib_mad_private *response)
+{
+	enum smi_forward_action retsmi;
+
+	if (smi_handle_dr_smp_recv(&recv->mad.smp,
+				   port_priv->device->node_type,
+				   port_num,
+				   port_priv->device->phys_port_cnt) ==
+				   IB_SMI_DISCARD)
+		return IB_SMI_DISCARD;
+
+	retsmi = smi_check_forward_dr_smp(&recv->mad.smp);
+	if (retsmi == IB_SMI_LOCAL)
+		return IB_SMI_HANDLE;
+
+	if (retsmi == IB_SMI_SEND) { /* don't forward */
+		if (smi_handle_dr_smp_send(&recv->mad.smp,
+					   port_priv->device->node_type,
+					   port_num) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+		if (smi_check_local_smp(&recv->mad.smp, port_priv->device) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+		/* forward case for switches */
+		memcpy(response, recv, sizeof(*response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+
+		agent_send_response(&response->mad.mad,
+				    &response->grh, wc,
+				    port_priv->device,
+				    smi_get_fwd_port(&recv->mad.smp),
+				    qp_info->qp->qp_num);
+
+		return IB_SMI_DISCARD;
+	}
+	return IB_SMI_HANDLE;
+}
+
 static bool generate_unmatched_resp(struct ib_mad_private *recv,
 				    struct ib_mad_private *response)
 {
@@ -2037,45 +2083,12 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
 	if (recv->mad.mad.mad_hdr.mgmt_class ==
 	    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-		enum smi_forward_action retsmi;
-
-		if (smi_handle_dr_smp_recv(&recv->mad.smp,
-					   port_priv->device->node_type,
-					   port_num,
-					   port_priv->device->phys_port_cnt) ==
-					   IB_SMI_DISCARD)
+		if (handle_ib_smi(port_priv, qp_info, wc, port_num, recv,
+				  response)
+		    == IB_SMI_DISCARD)
 			goto out;
-
-		retsmi = smi_check_forward_dr_smp(&recv->mad.smp);
-		if (retsmi == IB_SMI_LOCAL)
-			goto local;
-
-		if (retsmi == IB_SMI_SEND) { /* don't forward */
-			if (smi_handle_dr_smp_send(&recv->mad.smp,
-						   port_priv->device->node_type,
-						   port_num) == IB_SMI_DISCARD)
-				goto out;
-
-			if (smi_check_local_smp(&recv->mad.smp, port_priv->device) == IB_SMI_DISCARD)
-				goto out;
-		} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
-			/* forward case for switches */
-			memcpy(response, recv, sizeof(*response));
-			response->header.recv_wc.wc = &response->header.wc;
-			response->header.recv_wc.recv_buf.mad = &response->mad.mad;
-			response->header.recv_wc.recv_buf.grh = &response->grh;
-
-			agent_send_response(&response->mad.mad,
-					    &response->grh, wc,
-					    port_priv->device,
-					    smi_get_fwd_port(&recv->mad.smp),
-					    qp_info->qp->qp_num);
-
-			goto out;
-		}
 	}
 
-local:
 	/* Give driver "right of first refusal" on incoming MAD */
 	if (port_priv->device->process_mad) {
 		size_t resp_mad_size = sizeof(struct ib_mad);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
