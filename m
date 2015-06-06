From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 03/14] IB/mad: Split IB SMI handling from MAD Recv handler
Date: Sat,  6 Jun 2015 14:38:24 -0400
Message-ID: <1433615915-24591-4-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make a helper function to process Directed Route SMPs to be called by the IB
MAD Recv Handler, ib_mad_recv_done_handler.

This cleans up the MAD receive handler code a bit and allows for us to better
share the SMP processing code between IB and OPA SMPs.

IB and OPA SMPs share the same processing algorithm but have different header
formats and permissive LID detection.  Therefore this and subsequent patches
split the common processing code from the IB specific code in anticipation of
sharing those algorithms with the OPA code.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	add const to input variables
	make static
	Reword commit message

 drivers/infiniband/core/mad.c | 85 +++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index fa9157db7b2e..b1c7990f36e3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1924,6 +1924,52 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	}
 }
 
+static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv,
+				     const struct ib_mad_qp_info *qp_info,
+				     const struct ib_wc *wc,
+				     int port_num,
+				     struct ib_mad_private *recv,
+				     struct ib_mad_private *response)
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
@@ -1996,45 +2042,12 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
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
 		ret = port_priv->device->process_mad(port_priv->device, 0,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
