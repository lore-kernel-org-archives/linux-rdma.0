From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RESEND PATCH v3 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 16:16:48 -0400
Message-ID: <1433967408-27728-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For devices which support OPA MADs

   1) Use previously defined SMP support functions.

   2) Pass correct base version to ib_create_send_mad when processing OPA MADs.

   3) Process out_mad_key_index returned by agents for a response.  This is
      necessary because OPA SMP packets must carry a valid pkey.

   4) Carry the correct segment size (OPA vs IBTA) of RMPP messages within
      ib_mad_recv_wc.

   5) Handle variable length OPA MADs by:

        * Adjusting the 'fake' WC for locally routed SMP's to represent the
          proper incoming byte_len
        * out_mad_size is used from the local HCA agents
                1) when sending agent responses on the wire
                2) when passing responses through the local_completions
		   function

	NOTE: wc.byte_len includes the GRH length and therefore is different
	      from the in_mad_size specified to the local HCA agents.
	      out_mad_size should _not_ include the GRH length as it is added

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Resent because the patch did not seem to get to the list.

Changes from V2:
	Fix out_mad_pkey_index handling in ib_mad_recv_done_handler.
		Previously the WC was automatically passed in to the
		agent_send_response.  Update the WC to be used.

Changes from V1:
	Use out_mad_pkey_index rather than the wc.pkey_index from the agents
		This is a much cleaner interface than returning data in the
		in_wc which can now remain const.
	Correct all opa variables to be bool type
	Adjust for ib_mad_private being a flex array

 drivers/infiniband/core/agent.c    |    7 +-
 drivers/infiniband/core/agent.h    |    2 +-
 drivers/infiniband/core/mad.c      |  224 +++++++++++++++++++++++++++++++-----
 drivers/infiniband/core/mad_priv.h |    1 +
 drivers/infiniband/core/mad_rmpp.c |   20 +++-
 drivers/infiniband/core/user_mad.c |   19 ++-
 include/rdma/ib_mad.h              |    8 ++
 7 files changed, 238 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 6c42073..c7dcfe4 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -80,7 +80,7 @@ ib_get_agent_port(const struct ib_device *device, int port_num)
 
 void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *grh,
 			 const struct ib_wc *wc, const struct ib_device *device,
-			 int port_num, int qpn, size_t resp_mad_len)
+			 int port_num, int qpn, size_t resp_mad_len, bool opa)
 {
 	struct ib_agent_port_private *port_priv;
 	struct ib_mad_agent *agent;
@@ -106,11 +106,14 @@ void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *
 		return;
 	}
 
+	if (opa && mad_hdr->base_version != OPA_MGMT_BASE_VERSION)
+		resp_mad_len = IB_MGMT_MAD_SIZE;
+
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
 				      IB_MGMT_MAD_HDR,
 				      resp_mad_len - IB_MGMT_MAD_HDR,
 				      GFP_KERNEL,
-				      IB_MGMT_BASE_VERSION);
+				      mad_hdr->base_version);
 	if (IS_ERR(send_buf)) {
 		dev_err(&device->dev, "ib_create_send_mad error\n");
 		goto err1;
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 234c8aa..65f92be 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -46,6 +46,6 @@ extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
 extern void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *grh,
 				const struct ib_wc *wc, const struct ib_device *device,
-				int port_num, int qpn, size_t resp_mad_len);
+				int port_num, int qpn, size_t resp_mad_len, bool opa);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 81acde8..835e4dd 100644
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
@@ -751,6 +753,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 {
 	int ret = 0;
 	struct ib_smp *smp = mad_send_wr->send_buf.mad;
+	struct opa_smp *opa_smp = (struct opa_smp *)smp;
 	unsigned long flags;
 	struct ib_mad_local_private *local;
 	struct ib_mad_private *mad_priv;
@@ -762,6 +765,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
 	size_t mad_size = port_mad_size(mad_agent_priv->qp_info->port_priv);
 	u16 out_mad_pkey_index = 0;
+	u16 drslid;
+	bool opa = rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
+				    mad_agent_priv->qp_info->port_priv->port_num);
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -775,19 +781,48 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
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
-	}
+	if (opa && smp->class_version == OPA_SMP_CLASS_VERSION) {
+		u32 opa_drslid;
+
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
+		drslid = (u16)(opa_drslid & 0x0000ffff);
 
-	/* Check to post send on QP or process locally */
-	if (smi_check_local_smp(smp, device) == IB_SMI_DISCARD &&
-	    smi_check_local_returning_smp(smp, device) == IB_SMI_DISCARD)
-		goto out;
+		/* Check to post send on QP or process locally */
+		if (opa_smi_check_local_smp(opa_smp, device) == IB_SMI_DISCARD &&
+		    opa_smi_check_local_returning_smp(opa_smp, device) == IB_SMI_DISCARD)
+			goto out;
+	} else {
+		if ((ib_get_smp_direction(smp) ? smp->dr_dlid : smp->dr_slid) ==
+		     IB_LID_PERMISSIVE &&
+		     smi_handle_dr_smp_send(smp, device->node_type, port_num) ==
+		     IB_SMI_DISCARD) {
+			ret = -EINVAL;
+			dev_err(&device->dev, "Invalid directed route\n");
+			goto out;
+		}
+		drslid = be16_to_cpu(smp->dr_slid);
+
+		/* Check to post send on QP or process locally */
+		if (smi_check_local_smp(smp, device) == IB_SMI_DISCARD &&
+		    smi_check_local_returning_smp(smp, device) == IB_SMI_DISCARD)
+			goto out;
+	}
 
 	local = kmalloc(sizeof *local, GFP_ATOMIC);
 	if (!local) {
@@ -806,10 +841,16 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	build_smp_wc(mad_agent_priv->agent.qp,
-		     send_wr->wr_id, be16_to_cpu(smp->dr_slid),
+		     send_wr->wr_id, drslid,
 		     send_wr->wr.ud.pkey_index,
 		     send_wr->wr.ud.port_num, &mad_wc);
 
+	if (opa && smp->base_version == OPA_MGMT_BASE_VERSION) {
+		mad_wc.byte_len = mad_send_wr->send_buf.hdr_len
+					+ mad_send_wr->send_buf.data_len
+					+ sizeof(struct ib_grh);
+	}
+
 	/* No GRH for DR SMP */
 	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
 				  (const struct ib_mad_hdr *)smp, mad_size,
@@ -861,6 +902,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	local->mad_send_wr = mad_send_wr;
+	if (opa) {
+		local->mad_send_wr->send_wr.wr.ud.pkey_index = out_mad_pkey_index;
+		local->return_wc_byte_len = mad_size;
+	}
 	/* Reference MAD agent until send side of local completion handled */
 	atomic_inc(&mad_agent_priv->refcount);
 	/* Queue local completion to local list */
@@ -1754,14 +1799,18 @@ out:
 	return mad_agent;
 }
 
-static int validate_mad(const struct ib_mad_hdr *mad_hdr, u32 qp_num)
+static int validate_mad(const struct ib_mad_hdr *mad_hdr,
+			const struct ib_mad_qp_info *qp_info,
+			bool opa)
 {
 	int valid = 0;
+	u32 qp_num = qp_info->qp->qp_num;
 
 	/* Make sure MAD base version is understood */
-	if (mad_hdr->base_version != IB_MGMT_BASE_VERSION) {
-		pr_err("MAD received with unsupported base version %d\n",
-			mad_hdr->base_version);
+	if (mad_hdr->base_version != IB_MGMT_BASE_VERSION &&
+	    (!opa || mad_hdr->base_version != OPA_MGMT_BASE_VERSION)) {
+		pr_err("MAD received with unsupported base version %d %s\n",
+		       mad_hdr->base_version, opa ? "(opa)" : "");
 		goto out;
 	}
 
@@ -2011,7 +2060,8 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 				    port_priv->device,
 				    smi_get_fwd_port(smp),
 				    qp_info->qp->qp_num,
-				    response->mad_size);
+				    response->mad_size,
+				    false);
 
 		return IB_SMI_DISCARD;
 	}
@@ -2019,7 +2069,8 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 }
 
 static bool generate_unmatched_resp(const struct ib_mad_private *recv,
-				    struct ib_mad_private *response)
+				    struct ib_mad_private *response,
+				    size_t *resp_len, bool opa)
 {
 	const struct ib_mad_hdr *recv_hdr = (const struct ib_mad_hdr *)recv->mad;
 	struct ib_mad_hdr *resp_hdr = (struct ib_mad_hdr *)response->mad;
@@ -2035,11 +2086,96 @@ static bool generate_unmatched_resp(const struct ib_mad_private *recv,
 		if (recv_hdr->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
 			resp_hdr->status |= IB_SMP_DIRECTION;
 
+		if (opa && recv_hdr->base_version == OPA_MGMT_BASE_VERSION) {
+			if (recv_hdr->mgmt_class ==
+			    IB_MGMT_CLASS_SUBN_LID_ROUTED ||
+			    recv_hdr->mgmt_class ==
+			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+				*resp_len = opa_get_smp_header_size(
+							(struct opa_smp *)recv->mad);
+			else
+				*resp_len = sizeof(struct ib_mad_hdr);
+		}
+
 		return true;
 	} else {
 		return false;
 	}
 }
+
+static enum smi_action
+handle_opa_smi(struct ib_mad_port_private *port_priv,
+	       struct ib_mad_qp_info *qp_info,
+	       struct ib_wc *wc,
+	       int port_num,
+	       struct ib_mad_private *recv,
+	       struct ib_mad_private *response)
+{
+	enum smi_forward_action retsmi;
+	struct opa_smp *smp = (struct opa_smp *)recv->mad;
+
+	if (opa_smi_handle_dr_smp_recv(smp,
+				   port_priv->device->node_type,
+				   port_num,
+				   port_priv->device->phys_port_cnt) ==
+				   IB_SMI_DISCARD)
+		return IB_SMI_DISCARD;
+
+	retsmi = opa_smi_check_forward_dr_smp(smp);
+	if (retsmi == IB_SMI_LOCAL)
+		return IB_SMI_HANDLE;
+
+	if (retsmi == IB_SMI_SEND) { /* don't forward */
+		if (opa_smi_handle_dr_smp_send(smp,
+					   port_priv->device->node_type,
+					   port_num) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+		if (opa_smi_check_local_smp(smp, port_priv->device) ==
+		    IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+		/* forward case for switches */
+		memcpy(response, recv, mad_priv_size(response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.opa_mad =
+				(struct opa_mad *)response->mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+
+		agent_send_response((const struct ib_mad_hdr *)response->mad,
+				    &response->grh, wc,
+				    port_priv->device,
+				    opa_smi_get_fwd_port(smp),
+				    qp_info->qp->qp_num,
+				    recv->header.wc.byte_len,
+				    true);
+
+		return IB_SMI_DISCARD;
+	}
+
+	return IB_SMI_HANDLE;
+}
+
+static enum smi_action
+handle_smi(struct ib_mad_port_private *port_priv,
+	   struct ib_mad_qp_info *qp_info,
+	   struct ib_wc *wc,
+	   int port_num,
+	   struct ib_mad_private *recv,
+	   struct ib_mad_private *response,
+	   bool opa)
+{
+	struct ib_mad_hdr *mad_hdr = (struct ib_mad_hdr *)recv->mad;
+
+	if (opa && mad_hdr->base_version == OPA_MGMT_BASE_VERSION &&
+	    mad_hdr->class_version == OPA_SMI_CLASS_VERSION)
+		return handle_opa_smi(port_priv, qp_info, wc, port_num, recv,
+				      response);
+
+	return handle_ib_smi(port_priv, qp_info, wc, port_num, recv, response);
+}
+
 static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 				     struct ib_wc *wc)
 {
@@ -2052,11 +2188,15 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	int ret = IB_MAD_RESULT_SUCCESS;
 	size_t mad_size;
 	u16 resp_mad_pkey_index = 0;
+	bool opa;
 
 	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
 	qp_info = mad_list->mad_queue->qp_info;
 	dequeue_mad(mad_list);
 
+	opa = rdma_cap_opa_mad(qp_info->port_priv->device,
+			       qp_info->port_priv->port_num);
+
 	mad_priv_hdr = container_of(mad_list, struct ib_mad_private_header,
 				    mad_list);
 	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
@@ -2068,7 +2208,15 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
 	recv->header.recv_wc.wc = &recv->header.wc;
-	recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+
+	if (opa && ((struct ib_mad_hdr *)(recv->mad))->base_version == OPA_MGMT_BASE_VERSION) {
+		recv->header.recv_wc.mad_len = wc->byte_len - sizeof(struct ib_grh);
+		recv->header.recv_wc.mad_seg_size = sizeof(struct opa_mad);
+	} else {
+		recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+		recv->header.recv_wc.mad_seg_size = sizeof(struct ib_mad);
+	}
+
 	recv->header.recv_wc.recv_buf.mad = (struct ib_mad *)recv->mad;
 	recv->header.recv_wc.recv_buf.grh = &recv->grh;
 
@@ -2076,7 +2224,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
 
 	/* Validate MAD */
-	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info->qp->qp_num))
+	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info, opa))
 		goto out;
 
 	mad_size = recv->mad_size;
@@ -2094,8 +2242,8 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
 	if (((struct ib_mad_hdr *)recv->mad)->mgmt_class ==
 	    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-		if (handle_ib_smi(port_priv, qp_info, wc, port_num, recv,
-				  response)
+		if (handle_smi(port_priv, qp_info, wc, port_num, recv,
+			       response, opa)
 		    == IB_SMI_DISCARD)
 			goto out;
 	}
@@ -2109,6 +2257,10 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 						     recv->mad_size,
 						     (struct ib_mad_hdr *)response->mad,
 						     &mad_size, &resp_mad_pkey_index);
+
+		if (opa)
+			wc->pkey_index = resp_mad_pkey_index;
+
 		if (ret & IB_MAD_RESULT_SUCCESS) {
 			if (ret & IB_MAD_RESULT_CONSUMED)
 				goto out;
@@ -2118,7 +2270,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 						    port_priv->device,
 						    port_num,
 						    qp_info->qp->qp_num,
-						    response->mad_size);
+						    mad_size, opa);
 				goto out;
 			}
 		}
@@ -2133,10 +2285,10 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		 */
 		recv = NULL;
 	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
-		   generate_unmatched_resp(recv, response)) {
+		   generate_unmatched_resp(recv, response, &mad_size, opa)) {
 		agent_send_response((const struct ib_mad_hdr *)response->mad, &recv->grh, wc,
 				    port_priv->device, port_num,
-				    qp_info->qp->qp_num, response->mad_size);
+				    qp_info->qp->qp_num, mad_size, opa);
 	}
 
 out:
@@ -2537,10 +2689,14 @@ static void local_completions(struct work_struct *work)
 	int free_mad;
 	struct ib_wc wc;
 	struct ib_mad_send_wc mad_send_wc;
+	bool opa;
 
 	mad_agent_priv =
 		container_of(work, struct ib_mad_agent_private, local_work);
 
+	opa = rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
+			       mad_agent_priv->qp_info->port_priv->port_num);
+
 	spin_lock_irqsave(&mad_agent_priv->lock, flags);
 	while (!list_empty(&mad_agent_priv->local_list)) {
 		local = list_entry(mad_agent_priv->local_list.next,
@@ -2550,6 +2706,7 @@ static void local_completions(struct work_struct *work)
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 		free_mad = 0;
 		if (local->mad_priv) {
+			u8 base_version;
 			recv_mad_agent = local->recv_mad_agent;
 			if (!recv_mad_agent) {
 				dev_err(&mad_agent_priv->agent.device->dev,
@@ -2565,11 +2722,20 @@ static void local_completions(struct work_struct *work)
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
+			base_version = ((struct ib_mad_hdr *)(local->mad_priv->mad))->base_version;
+			if (opa && base_version == OPA_MGMT_BASE_VERSION) {
+				local->mad_priv->header.recv_wc.mad_len = local->return_wc_byte_len;
+				local->mad_priv->header.recv_wc.mad_seg_size = sizeof(struct opa_mad);
+			} else {
+				local->mad_priv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+				local->mad_priv->header.recv_wc.mad_seg_size = sizeof(struct ib_mad);
+			}
+
 			INIT_LIST_HEAD(&local->mad_priv->header.recv_wc.rmpp_list);
 			list_add(&local->mad_priv->header.recv_wc.recv_buf.list,
 				 &local->mad_priv->header.recv_wc.rmpp_list);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 4423f68..5be89f9 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -148,6 +148,7 @@ struct ib_mad_local_private {
 	struct ib_mad_private *mad_priv;
 	struct ib_mad_agent_private *recv_mad_agent;
 	struct ib_mad_send_wr_private *mad_send_wr;
+	size_t return_wc_byte_len;
 };
 
 struct ib_mad_mgmt_method_table {
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index f4e4fe6..382941b 100644
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
@@ -433,14 +436,23 @@ static inline int get_mad_len(struct mad_rmpp_recv *rmpp_recv)
 {
 	struct ib_rmpp_mad *rmpp_mad;
 	int hdr_size, data_size, pad;
+	bool opa = rdma_cap_opa_mad(rmpp_recv->agent->qp_info->port_priv->device,
+				    rmpp_recv->agent->qp_info->port_priv->port_num);
 
 	rmpp_mad = (struct ib_rmpp_mad *)rmpp_recv->cur_seg_buf->mad;
 
 	hdr_size = ib_get_mad_data_offset(rmpp_mad->mad_hdr.mgmt_class);
-	data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
-	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
-	if (pad > IB_MGMT_RMPP_DATA || pad < 0)
-		pad = 0;
+	if (opa && rmpp_recv->base_version == OPA_MGMT_BASE_VERSION) {
+		data_size = sizeof(struct opa_rmpp_mad) - hdr_size;
+		pad = OPA_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
+		if (pad > OPA_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	} else {
+		data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
+		pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_mad->rmpp_hdr.paylen_newwin);
+		if (pad > IB_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	}
 
 	return hdr_size + rmpp_recv->seg_num * data_size - pad;
 }
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index d428671..35567ff 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -262,20 +262,23 @@ static ssize_t copy_recv_mad(struct ib_umad_file *file, char __user *buf,
 {
 	struct ib_mad_recv_buf *recv_buf;
 	int left, seg_payload, offset, max_seg_payload;
+	size_t seg_size;
 
-	/* We need enough room to copy the first (or only) MAD segment. */
 	recv_buf = &packet->recv_wc->recv_buf;
-	if ((packet->length <= sizeof (*recv_buf->mad) &&
+	seg_size = packet->recv_wc->mad_seg_size;
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
 
@@ -292,7 +295,7 @@ static ssize_t copy_recv_mad(struct ib_umad_file *file, char __user *buf,
 			return -ENOSPC;
 		}
 		offset = ib_get_mad_data_offset(recv_buf->mad->mad_hdr.mgmt_class);
-		max_seg_payload = sizeof (struct ib_mad) - offset;
+		max_seg_payload = seg_size - offset;
 
 		for (left = packet->length - seg_payload, buf += seg_payload;
 		     left; left -= seg_payload, buf += seg_payload) {
@@ -450,6 +453,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_rmpp_mad *rmpp_mad;
 	__be64 *tid;
 	int ret, data_len, hdr_len, copy_offset, rmpp_active;
+	u8 base_version;
 
 	if (count < hdr_size(file) + IB_MGMT_RMPP_HDR)
 		return -EINVAL;
@@ -516,12 +520,13 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
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
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index eaa8c5d..c8422d5 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -199,6 +199,12 @@ struct ib_rmpp_mad {
 	u8			data[IB_MGMT_RMPP_DATA];
 };
 
+struct opa_rmpp_mad {
+	struct ib_mad_hdr	mad_hdr;
+	struct ib_rmpp_hdr	rmpp_hdr;
+	u8			data[OPA_MGMT_RMPP_DATA];
+};
+
 struct ib_sa_mad {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
@@ -429,6 +435,7 @@ struct ib_mad_recv_buf {
  * @recv_buf: Specifies the location of the received data buffer(s).
  * @rmpp_list: Specifies a list of RMPP reassembled received MAD buffers.
  * @mad_len: The length of the received MAD, without duplicated headers.
+ * @mad_seg_size: The size of individual MAD segments
  *
  * For received response, the wr_id contains a pointer to the ib_mad_send_buf
  *   for the corresponding send request.
@@ -438,6 +445,7 @@ struct ib_mad_recv_wc {
 	struct ib_mad_recv_buf	recv_buf;
 	struct list_head	rmpp_list;
 	int			mad_len;
+	size_t			mad_seg_size;
 };
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
