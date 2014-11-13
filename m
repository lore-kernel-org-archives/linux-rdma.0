From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 16/16] ib/mad: Implement Intel Omni-Path Architecture General MAD processing
Date: Thu, 13 Nov 2014 14:54:25 -0500
Message-ID: <1415908465-24392-17-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA SMP packets must carry a valid pkey
	process wc.pkey_index returned by agents for response.

Handle variable length OPA MADs based on the Base Version
Support is provided by:

	* Adjusting the 'fake' WC for locally routed SMP's to represent the
	  proper incoming byte_len
	* out_mad_size is used from the local HCA agents
		1) when sending agent responses on the wire
		2) when passing responses through the local_completions function

NOTE: wc.byte_len includes the GRH length and therefore is different from the
      in_mad_size specified to the local HCA agents.  out_mad_size should _not_
      include the GRH length as it is added by the verbs layer and is not part
      of MAD processing.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/agent.c    |  57 +++--
 drivers/infiniband/core/agent.h    |   2 +-
 drivers/infiniband/core/mad.c      | 440 +++++++++++++++++++++++++++++++++----
 drivers/infiniband/core/mad_priv.h |   1 +
 drivers/infiniband/core/mad_rmpp.c |  30 ++-
 drivers/infiniband/core/user_mad.c |  39 ++--
 6 files changed, 486 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index b6bd305..d7a2905 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -78,16 +78,11 @@ ib_get_agent_port(struct ib_device *device, int port_num)
 	return entry;
 }
 
-void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
-			 struct ib_wc *wc, struct ib_device *device,
-			 int port_num, int qpn)
+static int get_agent_ah(struct ib_device *device, int port_num,
+			struct ib_grh *grh, struct ib_wc *wc, int qpn,
+			struct ib_mad_agent **agent, struct ib_ah **ah)
 {
 	struct ib_agent_port_private *port_priv;
-	struct ib_mad_agent *agent;
-	struct ib_mad_send_buf *send_buf;
-	struct ib_ah *ah;
-	struct ib_mad_send_wr_private *mad_send_wr;
-
 	if (device->node_type == RDMA_NODE_IB_SWITCH)
 		port_priv = ib_get_agent_port(device, 0);
 	else
@@ -95,27 +90,57 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 
 	if (!port_priv) {
 		dev_err(&device->dev, "Unable to find port agent\n");
-		return;
+		return 1;
 	}
 
-	agent = port_priv->agent[qpn];
-	ah = ib_create_ah_from_wc(agent->qp->pd, wc, grh, port_num);
-	if (IS_ERR(ah)) {
+	*agent = port_priv->agent[qpn];
+	*ah = ib_create_ah_from_wc((*agent)->qp->pd, wc, grh, port_num);
+	if (IS_ERR(*ah)) {
 		dev_err(&device->dev, "ib_create_ah_from_wc error %ld\n",
 			PTR_ERR(ah));
+		return 1;
+	}
+	return 0;
+}
+
+void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
+			 struct ib_wc *wc, struct ib_device *device,
+			 int port_num, int qpn, u32 resp_mad_len)
+{
+	struct ib_mad_agent *agent;
+	struct ib_mad_send_buf *send_buf;
+	struct ib_ah *ah;
+	size_t data_len;
+	size_t hdr_len;
+	struct ib_mad_send_wr_private *mad_send_wr;
+	u8 base_version;
+
+	if (get_agent_ah(device, port_num, grh, wc, qpn, &agent, &ah))
 		return;
+
+	/* base version determines MAD size */
+	base_version = mad->mad_hdr.base_version;
+	if (base_version == OPA_MGMT_BASE_VERSION) {
+		data_len = resp_mad_len - JUMBO_MGMT_MAD_HDR;
+		hdr_len = JUMBO_MGMT_MAD_HDR;
+	} else {
+		data_len = IB_MGMT_MAD_DATA;
+		hdr_len = IB_MGMT_MAD_HDR;
 	}
 
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
-				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-				      GFP_KERNEL,
-				      IB_MGMT_BASE_VERSION);
+				      hdr_len, data_len, GFP_KERNEL,
+				      base_version);
 	if (IS_ERR(send_buf)) {
 		dev_err(&device->dev, "ib_create_send_mad error\n");
 		goto err1;
 	}
 
-	memcpy(send_buf->mad, mad, sizeof *mad);
+	if (base_version == OPA_MGMT_BASE_VERSION)
+		memcpy(send_buf->mad, mad, JUMBO_MGMT_MAD_HDR + data_len);
+	else
+		memcpy(send_buf->mad, mad, sizeof(*mad));
+
 	send_buf->ah = ah;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 6669287..cb4081d 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -46,6 +46,6 @@ extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
 extern void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 				struct ib_wc *wc, struct ib_device *device,
-				int port_num, int qpn);
+				int port_num, int qpn, u32 resp_mad_len);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7bd67e8..e73a116 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2005 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies Ltd.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -44,6 +45,7 @@
 #include "mad_priv.h"
 #include "mad_rmpp.h"
 #include "smi.h"
+#include "opa_smi.h"
 #include "agent.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
@@ -85,6 +87,8 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			      u8 mgmt_class);
 static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			   struct ib_mad_agent_private *agent_priv);
+static int ib_mad_post_jumbo_rcv_mads(struct ib_mad_qp_info *qp_info,
+				      struct jumbo_mad_private *mad);
 
 static void mad_priv_cache_free(struct ib_mad_private *mad_priv)
 {
@@ -742,9 +746,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 {
 	int ret = 0;
 	struct ib_smp *smp = mad_send_wr->send_buf.mad;
+	struct opa_smp *opa_smp = (struct opa_smp *)smp;
 	unsigned long flags;
 	struct ib_mad_local_private *local;
-	struct ib_mad_private *mad_priv;
+	struct ib_mad_private *mad_priv; /* or jumbo_mad_priv */
 	struct ib_mad_port_private *port_priv;
 	struct ib_mad_agent_private *recv_mad_agent = NULL;
 	struct ib_device *device = mad_agent_priv->agent.device;
@@ -753,6 +758,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
 	size_t in_mad_size = sizeof(struct ib_mad);
 	size_t out_mad_size = sizeof(struct ib_mad);
+	u32 opa_drslid;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -766,13 +772,34 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	 * If we are at the start of the LID routed part, don't update the
 	 * hop_ptr or hop_cnt.  See section 14.2.2, Vol 1 IB spec.
 	 */
-	if ((ib_get_smp_direction(smp) ? smp->dr_dlid : smp->dr_slid) ==
-	     IB_LID_PERMISSIVE &&
-	     smi_handle_dr_smp_send(smp, device->node_type, port_num) ==
-	     IB_SMI_DISCARD) {
-		ret = -EINVAL;
-		dev_err(&device->dev, "Invalid directed route\n");
-		goto out;
+	if (smp->class_version == OPA_SMP_CLASS_VERSION) {
+		if ((opa_get_smp_direction(opa_smp)
+		     ? opa_smp->route.dr.dr_dlid : opa_smp->route.dr.dr_slid) ==
+		     OPA_LID_PERMISSIVE &&
+		     opa_smi_handle_dr_smp_send(opa_smp, device->node_type,
+						port_num) == IB_SMI_DISCARD) {
+			ret = -EINVAL;
+			dev_err(&device->dev, "OPA Invalid directed route\n");
+			goto out;
+		}
+		opa_drslid = be32_to_cpu(opa_smp->route.dr.dr_slid);
+		if (opa_drslid != OPA_LID_PERMISSIVE &&
+		    opa_drslid & 0xffff0000) {
+			ret = -EINVAL;
+			dev_err(&device->dev, "OPA Invalid dr_slid 0x%x\n",
+			       opa_drslid);
+			goto out;
+		}
+	} else {
+		if ((ib_get_smp_direction(smp) ? smp->dr_dlid : smp->dr_slid) ==
+		     IB_LID_PERMISSIVE &&
+		     smi_handle_dr_smp_send(smp, device->node_type, port_num) ==
+		     IB_SMI_DISCARD) {
+			ret = -EINVAL;
+			dev_err(&device->dev, "Invalid directed route\n");
+			goto out;
+		}
+		opa_drslid = be16_to_cpu(smp->dr_slid);
 	}
 
 	/* Check to post send on QP or process locally */
@@ -789,10 +816,15 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	local->mad_priv = NULL;
 	local->recv_mad_agent = NULL;
 
-	if (mad_agent_priv->qp_info->supports_jumbo_mads)
+	if (mad_agent_priv->qp_info->supports_jumbo_mads) {
 		mad_priv = kmem_cache_alloc(jumbo_mad_cache, GFP_ATOMIC);
-	else
+		in_mad_size = sizeof(struct jumbo_mad);
+		out_mad_size = sizeof(struct jumbo_mad);
+	} else {
 		mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
+		in_mad_size = sizeof(struct ib_mad);
+		out_mad_size = sizeof(struct ib_mad);
+	}
 
 	if (!mad_priv) {
 		ret = -ENOMEM;
@@ -802,10 +834,16 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	build_smp_wc(mad_agent_priv->agent.qp,
-		     send_wr->wr_id, be16_to_cpu(smp->dr_slid),
+		     send_wr->wr_id, (u16)(opa_drslid & 0x0000ffff),
 		     send_wr->wr.ud.pkey_index,
 		     send_wr->wr.ud.port_num, &mad_wc);
 
+	if (smp->base_version == OPA_MGMT_BASE_VERSION) {
+		mad_wc.byte_len = mad_send_wr->send_buf.hdr_len
+					+ mad_send_wr->send_buf.data_len
+					+ sizeof(struct ib_grh);
+	}
+
 	/* No GRH for DR SMP */
 	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
 				  (struct ib_mad_hdr *)smp, in_mad_size,
@@ -857,6 +895,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	local->mad_send_wr = mad_send_wr;
+	local->mad_send_wr->send_wr.wr.ud.pkey_index = mad_wc.pkey_index;
+	local->return_wc_byte_len = out_mad_size;
 	/* Reference MAD agent until send side of local completion handled */
 	atomic_inc(&mad_agent_priv->refcount);
 	/* Queue local completion to local list */
@@ -1749,14 +1789,15 @@ out:
 	return mad_agent;
 }
 
-static int validate_mad(struct ib_mad *mad, u32 qp_num)
+int validate_mad(struct ib_mad *mad, u32 qp_num, int jumbo)
 {
 	int valid = 0;
 
 	/* Make sure MAD base version is understood */
-	if (mad->mad_hdr.base_version != IB_MGMT_BASE_VERSION) {
-		pr_err("MAD received with unsupported base version %d\n",
-			mad->mad_hdr.base_version);
+	if (mad->mad_hdr.base_version != IB_MGMT_BASE_VERSION
+	    && (!jumbo && mad->mad_hdr.base_version != OPA_MGMT_BASE_VERSION)) {
+		pr_err("MAD received with unsupported base version %d %s\n",
+			mad->mad_hdr.base_version, jumbo ? "(jumbo)" : "");
 		goto out;
 	}
 
@@ -1856,18 +1897,18 @@ ib_find_send_mad(struct ib_mad_agent_private *mad_agent_priv,
 		 struct ib_mad_recv_wc *wc)
 {
 	struct ib_mad_send_wr_private *wr;
-	struct ib_mad *mad;
+	struct ib_mad_hdr *mad_hdr;
 
-	mad = (struct ib_mad *)wc->recv_buf.mad;
+	mad_hdr = (struct ib_mad_hdr *)wc->recv_buf.mad;
 
 	list_for_each_entry(wr, &mad_agent_priv->wait_list, agent_list) {
-		if ((wr->tid == mad->mad_hdr.tid) &&
+		if ((wr->tid == mad_hdr->tid) &&
 		    rcv_has_same_class(wr, wc) &&
 		    /*
 		     * Don't check GID for direct routed MADs.
 		     * These might have permissive LIDs.
 		     */
-		    (is_direct(wc->recv_buf.mad->mad_hdr.mgmt_class) ||
+		    (is_direct(mad_hdr->mgmt_class) ||
 		     rcv_has_same_gid(mad_agent_priv, wr, wc)))
 			return (wr->status == IB_WC_SUCCESS) ? wr : NULL;
 	}
@@ -1878,14 +1919,14 @@ ib_find_send_mad(struct ib_mad_agent_private *mad_agent_priv,
 	 */
 	list_for_each_entry(wr, &mad_agent_priv->send_list, agent_list) {
 		if (is_rmpp_data_mad(mad_agent_priv, wr->send_buf.mad) &&
-		    wr->tid == mad->mad_hdr.tid &&
+		    wr->tid == mad_hdr->tid &&
 		    wr->timeout &&
 		    rcv_has_same_class(wr, wc) &&
 		    /*
 		     * Don't check GID for direct routed MADs.
 		     * These might have permissive LIDs.
 		     */
-		    (is_direct(wc->recv_buf.mad->mad_hdr.mgmt_class) ||
+		    (is_direct(mad_hdr->mgmt_class) ||
 		     rcv_has_same_gid(mad_agent_priv, wr, wc)))
 			/* Verify request has not been canceled */
 			return (wr->status == IB_WC_SUCCESS) ? wr : NULL;
@@ -1901,7 +1942,7 @@ void ib_mark_mad_done(struct ib_mad_send_wr_private *mad_send_wr)
 			      &mad_send_wr->mad_agent_priv->done_list);
 }
 
-static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
+void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 				 struct ib_mad_recv_wc *mad_recv_wc)
 {
 	struct ib_mad_send_wr_private *mad_send_wr;
@@ -2004,7 +2045,8 @@ enum smi_action handle_ib_smi(struct ib_mad_port_private *port_priv,
 				    &response->grh, wc,
 				    port_priv->device,
 				    smi_get_fwd_port(&recv->mad.smp),
-				    qp_info->qp->qp_num);
+				    qp_info->qp->qp_num,
+				    sizeof(struct ib_mad));
 
 		return IB_SMI_DISCARD;
 	}
@@ -2032,22 +2074,15 @@ static bool generate_unmatched_resp(struct ib_mad_private *recv,
 	}
 }
 static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
-				     struct ib_wc *wc)
+				     struct ib_wc *wc,
+				     struct ib_mad_private_header *mad_priv_hdr,
+				     struct ib_mad_qp_info *qp_info)
 {
-	struct ib_mad_qp_info *qp_info;
-	struct ib_mad_private_header *mad_priv_hdr;
 	struct ib_mad_private *recv, *response = NULL;
-	struct ib_mad_list_head *mad_list;
 	struct ib_mad_agent_private *mad_agent;
 	int port_num;
 	int ret = IB_MAD_RESULT_SUCCESS;
 
-	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
-	qp_info = mad_list->mad_queue->qp_info;
-	dequeue_mad(mad_list);
-
-	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header,
-				    mad_list);
 	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
 	ib_dma_unmap_single(port_priv->device,
 			    recv->header.mapping,
@@ -2066,7 +2101,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
 
 	/* Validate MAD */
-	if (!validate_mad(&recv->mad.mad, qp_info->qp->qp_num))
+	if (!validate_mad(&recv->mad.mad, qp_info->qp->qp_num, 0))
 		goto out;
 
 	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
@@ -2107,7 +2142,8 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 						    &recv->grh, wc,
 						    port_priv->device,
 						    port_num,
-						    qp_info->qp->qp_num);
+						    qp_info->qp->qp_num,
+						    sizeof(struct ib_mad));
 				goto out;
 			}
 		}
@@ -2124,7 +2160,9 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
 		   generate_unmatched_resp(recv, response)) {
 		agent_send_response(&response->mad.mad, &recv->grh, wc,
-				    port_priv->device, port_num, qp_info->qp->qp_num);
+				    port_priv->device, port_num,
+				    qp_info->qp->qp_num,
+				    sizeof(struct ib_mad));
 	}
 
 out:
@@ -2391,6 +2429,241 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
 	}
 }
 
+static enum smi_action
+handle_opa_smi(struct ib_mad_port_private *port_priv,
+	       struct ib_mad_qp_info *qp_info,
+	       struct ib_wc *wc,
+	       int port_num,
+	       struct jumbo_mad_private *recv,
+	       struct jumbo_mad_private *response)
+{
+	enum smi_forward_action retsmi;
+
+	if (opa_smi_handle_dr_smp_recv(&recv->mad.smp,
+				   port_priv->device->node_type,
+				   port_num,
+				   port_priv->device->phys_port_cnt) ==
+				   IB_SMI_DISCARD)
+		return IB_SMI_DISCARD;
+
+	retsmi = opa_smi_check_forward_dr_smp(&recv->mad.smp);
+	if (retsmi == IB_SMI_LOCAL)
+		return IB_SMI_HANDLE;
+
+	if (retsmi == IB_SMI_SEND) { /* don't forward */
+		if (opa_smi_handle_dr_smp_send(&recv->mad.smp,
+					   port_priv->device->node_type,
+					   port_num) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+		if (opa_smi_check_local_smp(&recv->mad.smp, port_priv->device) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+		/* forward case for switches */
+		memcpy(response, recv, sizeof(*response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.mad = (struct ib_mad *)&response->mad.mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+
+		agent_send_response((struct ib_mad *)&response->mad.mad,
+				    &response->grh, wc,
+				    port_priv->device,
+				    opa_smi_get_fwd_port(&recv->mad.smp),
+				    qp_info->qp->qp_num,
+				    recv->header.wc.byte_len);
+
+		return IB_SMI_DISCARD;
+	}
+
+	return IB_SMI_HANDLE;
+}
+
+static enum smi_action
+jumbo_handle_smi(struct ib_mad_port_private *port_priv,
+		 struct ib_mad_qp_info *qp_info,
+		 struct ib_wc *wc,
+		 int port_num,
+		 struct jumbo_mad_private *recv,
+		 struct jumbo_mad_private *response)
+{
+	if (recv->mad.mad.mad_hdr.base_version == OPA_MGMT_BASE_VERSION) {
+		switch (recv->mad.mad.mad_hdr.class_version) {
+		case OPA_SMI_CLASS_VERSION:
+			return handle_opa_smi(port_priv, qp_info, wc, port_num,
+					      recv, response);
+			/* stub for other Jumbo SMI versions */
+		}
+	}
+
+	return handle_ib_smi(port_priv, qp_info, wc, port_num,
+			     (struct ib_mad_private *)recv,
+			     (struct ib_mad_private *)response);
+}
+
+static bool generate_jumbo_unmatched_resp(struct jumbo_mad_private *recv,
+					  struct jumbo_mad_private *response,
+					  size_t *resp_len)
+{
+	if (recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_GET ||
+	    recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_SET) {
+		memcpy(response, recv, sizeof(*response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.mad = (struct ib_mad *)&response->mad.mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
+		response->mad.mad.mad_hdr.status =
+			cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB);
+		if (recv->mad.mad.mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+			response->mad.mad.mad_hdr.status |= IB_SMP_DIRECTION;
+
+		if (recv->mad.mad.mad_hdr.base_version == OPA_MGMT_BASE_VERSION) {
+			if (recv->mad.mad.mad_hdr.mgmt_class ==
+			    IB_MGMT_CLASS_SUBN_LID_ROUTED ||
+			    recv->mad.mad.mad_hdr.mgmt_class ==
+			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+				*resp_len = opa_get_smp_header_size(
+							(struct opa_smp *)&recv->mad.smp);
+			else
+				*resp_len = sizeof(struct ib_mad_hdr);
+		}
+
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * NOTE: Processing of recv jumbo MADs is kept separate for buffer handling
+ */
+void ib_mad_recv_done_jumbo_handler(struct ib_mad_port_private *port_priv,
+				    struct ib_wc *wc,
+				    struct ib_mad_private_header *mad_priv_hdr,
+				    struct ib_mad_qp_info *qp_info)
+{
+	struct jumbo_mad_private *recv, *response = NULL;
+	struct ib_mad_agent_private *mad_agent;
+	int port_num;
+	int ret = IB_MAD_RESULT_SUCCESS;
+	u8 base_version;
+	size_t resp_len = 0;
+
+	recv = container_of(mad_priv_hdr, struct jumbo_mad_private, header);
+	ib_dma_unmap_single(port_priv->device,
+			    recv->header.mapping,
+			    sizeof(struct jumbo_mad_private) -
+			      sizeof(struct ib_mad_private_header),
+			    DMA_FROM_DEVICE);
+
+	/* Setup MAD receive work completion from "normal" work completion */
+	recv->header.wc = *wc;
+	recv->header.recv_wc.wc = &recv->header.wc;
+	base_version = recv->mad.mad.mad_hdr.base_version;
+	if (base_version == OPA_MGMT_BASE_VERSION)
+		recv->header.recv_wc.mad_len = wc->byte_len - sizeof(struct ib_grh);
+	else
+		recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+	recv->header.recv_wc.recv_buf.mad = (struct ib_mad *)&recv->mad.mad;
+	recv->header.recv_wc.recv_buf.grh = &recv->grh;
+
+	if (atomic_read(&qp_info->snoop_count))
+		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
+
+	if (!validate_mad((struct ib_mad *)&recv->mad.mad, qp_info->qp->qp_num, 1))
+		goto out;
+
+	response = kmem_cache_alloc(jumbo_mad_cache, GFP_KERNEL);
+	if (!response) {
+		pr_err("ib_mad_recv_done_jumbo_handler no memory for response buffer (jumbo)\n");
+		goto out;
+	}
+
+	if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH)
+		port_num = wc->port_num;
+	else
+		port_num = port_priv->port_num;
+
+	if (recv->mad.mad.mad_hdr.mgmt_class ==
+	    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
+		if (jumbo_handle_smi(port_priv, qp_info, wc, port_num, recv, response)
+		    == IB_SMI_DISCARD)
+			goto out;
+	}
+
+	/* Give driver "right of first refusal" on incoming MAD */
+	if (port_priv->device->process_mad) {
+		resp_len = sizeof(struct jumbo_mad),
+		ret = port_priv->device->process_mad(port_priv->device, 0,
+						     port_priv->port_num,
+						     wc, &recv->grh,
+						     (struct ib_mad_hdr *)&recv->mad.mad,
+						     sizeof(struct jumbo_mad),
+						     (struct ib_mad_hdr *)&response->mad.mad,
+						     &resp_len);
+		if (ret & IB_MAD_RESULT_SUCCESS) {
+			if (ret & IB_MAD_RESULT_CONSUMED)
+				goto out;
+			if (ret & IB_MAD_RESULT_REPLY) {
+				agent_send_response((struct ib_mad *)&response->mad.mad,
+						    &recv->grh, wc,
+						    port_priv->device,
+						    port_num,
+						    qp_info->qp->qp_num,
+						    resp_len);
+				goto out;
+			}
+		}
+	}
+
+	mad_agent = find_mad_agent(port_priv, (struct ib_mad *)&recv->mad.mad);
+	if (mad_agent) {
+		ib_mad_complete_recv(mad_agent, &recv->header.recv_wc);
+		/*
+		 * recv is freed up in error cases in ib_mad_complete_recv
+		 * or via recv_handler in ib_mad_complete_recv()
+		 */
+		recv = NULL;
+	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
+		   generate_jumbo_unmatched_resp(recv, response, &resp_len)) {
+		agent_send_response((struct ib_mad *)&response->mad.mad, &recv->grh, wc,
+				    port_priv->device, port_num,
+				    qp_info->qp->qp_num,
+				    resp_len);
+	}
+
+out:
+	/* Post another receive request for this QP */
+	if (response) {
+		ib_mad_post_jumbo_rcv_mads(qp_info, response);
+		if (recv) {
+			BUG_ON(!(recv->header.flags & IB_MAD_PRIV_FLAG_JUMBO));
+			kmem_cache_free(jumbo_mad_cache, recv);
+		}
+	} else
+		ib_mad_post_jumbo_rcv_mads(qp_info, recv);
+}
+
+static void ib_mad_recv_mad(struct ib_mad_port_private *port_priv,
+			    struct ib_wc *wc)
+{
+	struct ib_mad_qp_info *qp_info;
+	struct ib_mad_list_head *mad_list;
+	struct ib_mad_private_header *mad_priv_hdr;
+
+	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
+	qp_info = mad_list->mad_queue->qp_info;
+	dequeue_mad(mad_list);
+
+	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header,
+				    mad_list);
+
+	if (qp_info->supports_jumbo_mads)
+		ib_mad_recv_done_jumbo_handler(port_priv, wc, mad_priv_hdr, qp_info);
+	else
+		ib_mad_recv_done_handler(port_priv, wc, mad_priv_hdr, qp_info);
+}
+
 /*
  * IB MAD completion callback
  */
@@ -2409,7 +2682,7 @@ static void ib_mad_completion_handler(struct work_struct *work)
 				ib_mad_send_done_handler(port_priv, &wc);
 				break;
 			case IB_WC_RECV:
-				ib_mad_recv_done_handler(port_priv, &wc);
+				ib_mad_recv_mad(port_priv, &wc);
 				break;
 			default:
 				BUG_ON(1);
@@ -2541,6 +2814,7 @@ static void local_completions(struct work_struct *work)
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 		free_mad = 0;
 		if (local->mad_priv) {
+			u8 base_version;
 			recv_mad_agent = local->recv_mad_agent;
 			if (!recv_mad_agent) {
 				dev_err(&mad_agent_priv->agent.device->dev,
@@ -2556,11 +2830,17 @@ static void local_completions(struct work_struct *work)
 			build_smp_wc(recv_mad_agent->agent.qp,
 				     (unsigned long) local->mad_send_wr,
 				     be16_to_cpu(IB_LID_PERMISSIVE),
-				     0, recv_mad_agent->agent.port_num, &wc);
+				     local->mad_send_wr->send_wr.wr.ud.pkey_index,
+				     recv_mad_agent->agent.port_num, &wc);
 
 			local->mad_priv->header.recv_wc.wc = &wc;
-			local->mad_priv->header.recv_wc.mad_len =
-						sizeof(struct ib_mad);
+
+			base_version = local->mad_priv->mad.mad.mad_hdr.base_version;
+			if (base_version == OPA_MGMT_BASE_VERSION)
+				local->mad_priv->header.recv_wc.mad_len = local->return_wc_byte_len;
+			else
+				local->mad_priv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+
 			INIT_LIST_HEAD(&local->mad_priv->header.recv_wc.rmpp_list);
 			list_add(&local->mad_priv->header.recv_wc.recv_buf.list,
 				 &local->mad_priv->header.recv_wc.rmpp_list);
@@ -2818,6 +3098,81 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 }
 
 /*
+ * Allocate jumbo receive MADs and post receive WRs for them
+ */
+static int ib_mad_post_jumbo_rcv_mads(struct ib_mad_qp_info *qp_info,
+				      struct jumbo_mad_private *mad)
+{
+	unsigned long flags;
+	int post, ret;
+	struct jumbo_mad_private *mad_priv;
+	struct ib_sge sg_list;
+	struct ib_recv_wr recv_wr, *bad_recv_wr;
+	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
+
+	if (unlikely(!qp_info->supports_jumbo_mads)) {
+		pr_err("Attempt to post jumbo MAD on non-jumbo QP\n");
+		return -EINVAL;
+	}
+
+	/* Initialize common scatter list fields */
+	sg_list.length = sizeof(*mad_priv) - sizeof(mad_priv->header);
+	sg_list.lkey = (*qp_info->port_priv->mr).lkey;
+
+	/* Initialize common receive WR fields */
+	recv_wr.next = NULL;
+	recv_wr.sg_list = &sg_list;
+	recv_wr.num_sge = 1;
+
+	do {
+		/* Allocate and map receive buffer */
+		if (mad) {
+			mad_priv = mad;
+			mad = NULL;
+		} else {
+			mad_priv = kmem_cache_alloc(jumbo_mad_cache, GFP_KERNEL);
+			if (!mad_priv) {
+				pr_err("No memory for jumbo receive buffer\n");
+				ret = -ENOMEM;
+				break;
+			}
+		}
+		sg_list.addr = ib_dma_map_single(qp_info->port_priv->device,
+						 &mad_priv->grh,
+						 sizeof(*mad_priv) -
+						   sizeof(mad_priv->header),
+						 DMA_FROM_DEVICE);
+		mad_priv->header.mapping = sg_list.addr;
+		recv_wr.wr_id = (unsigned long)&mad_priv->header.mad_list;
+		mad_priv->header.mad_list.mad_queue = recv_queue;
+
+		/* Post receive WR */
+		spin_lock_irqsave(&recv_queue->lock, flags);
+		post = (++recv_queue->count < recv_queue->max_active);
+		list_add_tail(&mad_priv->header.mad_list.list, &recv_queue->list);
+		spin_unlock_irqrestore(&recv_queue->lock, flags);
+		ret = ib_post_recv(qp_info->qp, &recv_wr, &bad_recv_wr);
+		if (ret) {
+			spin_lock_irqsave(&recv_queue->lock, flags);
+			list_del(&mad_priv->header.mad_list.list);
+			recv_queue->count--;
+			spin_unlock_irqrestore(&recv_queue->lock, flags);
+			ib_dma_unmap_single(qp_info->port_priv->device,
+					    mad_priv->header.mapping,
+					    sizeof(*mad_priv)-
+					      sizeof(mad_priv->header),
+					    DMA_FROM_DEVICE);
+			BUG_ON(!(mad_priv->header.flags & IB_MAD_PRIV_FLAG_JUMBO));
+			kmem_cache_free(jumbo_mad_cache, mad_priv);
+			pr_err("ib_post_recv failed: %d\n", ret);
+			break;
+		}
+	} while (post);
+
+	return ret;
+}
+
+/*
  * Start the port
  */
 static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
@@ -2892,7 +3247,10 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		if (!port_priv->qp_info[i].qp)
 			continue;
 
-		ret = ib_mad_post_receive_mads(&port_priv->qp_info[i], NULL);
+		if (port_priv->qp_info[i].supports_jumbo_mads)
+			ret = ib_mad_post_jumbo_rcv_mads(&port_priv->qp_info[i], NULL);
+		else
+			ret = ib_mad_post_receive_mads(&port_priv->qp_info[i], NULL);
 		if (ret) {
 			dev_err(&port_priv->device->dev,
 				"Couldn't post receive WRs\n");
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 7a82950..6c54be8 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -175,6 +175,7 @@ struct ib_mad_local_private {
 	struct ib_mad_private *mad_priv; /* can be struct jumbo_mad_private */
 	struct ib_mad_agent_private *recv_mad_agent;
 	struct ib_mad_send_wr_private *mad_send_wr;
+	size_t return_wc_byte_len;
 };
 
 struct ib_mad_mgmt_method_table {
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 7184530..514f0a1 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005 Intel Inc. All rights reserved.
  * Copyright (c) 2005-2006 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -67,6 +68,7 @@ struct mad_rmpp_recv {
 	u8 mgmt_class;
 	u8 class_version;
 	u8 method;
+	u8 base_version;
 };
 
 static inline void deref_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
@@ -318,6 +320,7 @@ create_rmpp_recv(struct ib_mad_agent_private *agent,
 	rmpp_recv->mgmt_class = mad_hdr->mgmt_class;
 	rmpp_recv->class_version = mad_hdr->class_version;
 	rmpp_recv->method  = mad_hdr->method;
+	rmpp_recv->base_version  = mad_hdr->base_version;
 	return rmpp_recv;
 
 error:	kfree(rmpp_recv);
@@ -431,16 +434,23 @@ static void update_seg_num(struct mad_rmpp_recv *rmpp_recv,
 
 static inline int get_mad_len(struct mad_rmpp_recv *rmpp_recv)
 {
-	struct ib_rmpp_mad *rmpp_mad;
+	struct ib_rmpp_base *rmpp_base;
 	int hdr_size, data_size, pad;
 
-	rmpp_mad = (struct ib_rmpp_mad *)rmpp_recv->cur_seg_buf->mad;
+	rmpp_base = &((struct jumbo_rmpp_mad *)rmpp_recv->cur_seg_buf->mad)->base;
 
-	hdr_size = ib_get_mad_data_offset(rmpp_mad->base.mad_hdr.mgmt_class);
-	data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
-	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->base.rmpp_hdr.paylen_newwin);
-	if (pad > IB_MGMT_RMPP_DATA || pad < 0)
-		pad = 0;
+	hdr_size = ib_get_mad_data_offset(rmpp_base->mad_hdr.mgmt_class);
+	if (rmpp_recv->base_version == OPA_MGMT_BASE_VERSION) {
+		data_size = sizeof(struct jumbo_rmpp_mad) - hdr_size;
+		pad = JUMBO_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
+		if (pad > JUMBO_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	} else {
+		data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
+		pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
+		if (pad > IB_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	}
 
 	return hdr_size + rmpp_recv->seg_num * data_size - pad;
 }
@@ -933,11 +943,11 @@ int ib_process_rmpp_send_wc(struct ib_mad_send_wr_private *mad_send_wr,
 
 int ib_retry_rmpp(struct ib_mad_send_wr_private *mad_send_wr)
 {
-	struct ib_rmpp_base *rmpp_base;
+	struct ib_rmpp_mad *rmpp_mad;
 	int ret;
 
-	rmpp_base = mad_send_wr->send_buf.mad;
-	if (!(ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
+	rmpp_mad = mad_send_wr->send_buf.mad;
+	if (!(ib_get_rmpp_flags(&rmpp_mad->base.rmpp_hdr) &
 	      IB_MGMT_RMPP_FLAG_ACTIVE))
 		return IB_RMPP_RESULT_UNHANDLED; /* RMPP not active */
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 3b4b614..aca72e4 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -263,20 +263,27 @@ static ssize_t copy_recv_mad(struct ib_umad_file *file, char __user *buf,
 {
 	struct ib_mad_recv_buf *recv_buf;
 	int left, seg_payload, offset, max_seg_payload;
+	int seg_size;
 
-	/* We need enough room to copy the first (or only) MAD segment. */
 	recv_buf = &packet->recv_wc->recv_buf;
-	if ((packet->length <= sizeof (*recv_buf->mad) &&
+
+	if (recv_buf->mad->mad_hdr.base_version == OPA_MGMT_BASE_VERSION)
+		seg_size = sizeof(struct jumbo_mad);
+	else
+		seg_size = sizeof(struct ib_mad);
+
+	/* We need enough room to copy the first (or only) MAD segment. */
+	if ((packet->length <= seg_size &&
 	     count < hdr_size(file) + packet->length) ||
-	    (packet->length > sizeof (*recv_buf->mad) &&
-	     count < hdr_size(file) + sizeof (*recv_buf->mad)))
+	    (packet->length > seg_size &&
+	     count < hdr_size(file) + seg_size))
 		return -EINVAL;
 
 	if (copy_to_user(buf, &packet->mad, hdr_size(file)))
 		return -EFAULT;
 
 	buf += hdr_size(file);
-	seg_payload = min_t(int, packet->length, sizeof (*recv_buf->mad));
+	seg_payload = min_t(int, packet->length, seg_size);
 	if (copy_to_user(buf, recv_buf->mad, seg_payload))
 		return -EFAULT;
 
@@ -293,7 +300,7 @@ static ssize_t copy_recv_mad(struct ib_umad_file *file, char __user *buf,
 			return -ENOSPC;
 		}
 		offset = ib_get_mad_data_offset(recv_buf->mad->mad_hdr.mgmt_class);
-		max_seg_payload = sizeof (struct ib_mad) - offset;
+		max_seg_payload = seg_size - offset;
 
 		for (left = packet->length - seg_payload, buf += seg_payload;
 		     left; left -= seg_payload, buf += seg_payload) {
@@ -448,9 +455,10 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_mad_agent *agent;
 	struct ib_ah_attr ah_attr;
 	struct ib_ah *ah;
-	struct ib_rmpp_base *rmpp_base;
+	struct ib_rmpp_mad *rmpp_mad;
 	__be64 *tid;
 	int ret, data_len, hdr_len, copy_offset, rmpp_active;
+	u8 base_version;
 
 	if (count < hdr_size(file) + IB_MGMT_RMPP_HDR)
 		return -EINVAL;
@@ -504,25 +512,26 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		goto err_up;
 	}
 
-	rmpp_base = (struct ib_rmpp_base *) packet->mad.data;
-	hdr_len = ib_get_mad_data_offset(rmpp_base->mad_hdr.mgmt_class);
+	rmpp_mad = (struct ib_rmpp_mad *) packet->mad.data;
+	hdr_len = ib_get_mad_data_offset(rmpp_mad->base.mad_hdr.mgmt_class);
 
-	if (ib_is_mad_class_rmpp(rmpp_base->mad_hdr.mgmt_class)
+	if (ib_is_mad_class_rmpp(rmpp_mad->base.mad_hdr.mgmt_class)
 	    && ib_mad_kernel_rmpp_agent(agent)) {
 		copy_offset = IB_MGMT_RMPP_HDR;
-		rmpp_active = ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) &
+		rmpp_active = ib_get_rmpp_flags(&rmpp_mad->base.rmpp_hdr) &
 						IB_MGMT_RMPP_FLAG_ACTIVE;
 	} else {
 		copy_offset = IB_MGMT_MAD_HDR;
 		rmpp_active = 0;
 	}
 
+	base_version = ((struct ib_mad_hdr *)&packet->mad.data)->base_version;
 	data_len = count - hdr_size(file) - hdr_len;
 	packet->msg = ib_create_send_mad(agent,
 					 be32_to_cpu(packet->mad.hdr.qpn),
 					 packet->mad.hdr.pkey_index, rmpp_active,
 					 hdr_len, data_len, GFP_KERNEL,
-					 IB_MGMT_BASE_VERSION);
+					 base_version);
 	if (IS_ERR(packet->msg)) {
 		ret = PTR_ERR(packet->msg);
 		goto err_ah;
@@ -558,12 +567,12 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		tid = &((struct ib_mad_hdr *) packet->msg->mad)->tid;
 		*tid = cpu_to_be64(((u64) agent->hi_tid) << 32 |
 				   (be64_to_cpup(tid) & 0xffffffff));
-		rmpp_base->mad_hdr.tid = *tid;
+		rmpp_mad->base.mad_hdr.tid = *tid;
 	}
 
 	if (!ib_mad_kernel_rmpp_agent(agent)
-	   && ib_is_mad_class_rmpp(rmpp_base->mad_hdr.mgmt_class)
-	   && (ib_get_rmpp_flags(&rmpp_base->rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
+	   && ib_is_mad_class_rmpp(rmpp_mad->base.mad_hdr.mgmt_class)
+	   && (ib_get_rmpp_flags(&rmpp_mad->base.rmpp_hdr) & IB_MGMT_RMPP_FLAG_ACTIVE)) {
 		spin_lock_irq(&file->send_lock);
 		list_add_tail(&packet->list, &file->send_list);
 		spin_unlock_irq(&file->send_lock);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
