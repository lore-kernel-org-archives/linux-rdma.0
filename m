From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 20 May 2015 04:13:35 -0400
Message-ID: <1432109615-19564-15-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For devices which support OPA MADs

Use previously defined SMP support functions.

Pass correct base version to ib_create_send_mad when processing OPA MADs.

Process wc.pkey_index returned by agents for response because OPA SMP packets
must carry a valid pkey.

Carry the correct segment size (OPA vs IBTA) of RMPP messages within
ib_mad_recv_wc.

Handle variable length OPA MADs by:

        * Adjusting the 'fake' WC for locally routed SMP's to represent the
          proper incoming byte_len
        * out_mad_size is used from the local HCA agents
                1) when sending agent responses on the wire
                2) when passing responses through the local_completions
		   function

NOTE: wc.byte_len includes the GRH length and therefore is different from the
      in_mad_size specified to the local HCA agents.  out_mad_size should _not_
      include the GRH length as it is added by the verbs layer and is not part
      of MAD processing.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/agent.c    |  23 +++-
 drivers/infiniband/core/agent.h    |   3 +-
 drivers/infiniband/core/mad.c      | 222 +++++++++++++++++++++++++++++++------
 drivers/infiniband/core/mad_priv.h |   1 +
 drivers/infiniband/core/mad_rmpp.c |  20 +++-
 drivers/infiniband/core/user_mad.c |  19 ++--
 include/rdma/ib_mad.h              |   2 +
 7 files changed, 242 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 5c7627c3278c..fb305635c95d 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -80,13 +80,16 @@ ib_get_agent_port(struct ib_device *device, int port_num)
 
 void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 			 struct ib_wc *wc, struct ib_device *device,
-			 int port_num, int qpn)
+			 int port_num, int qpn, u32 resp_mad_len,
+			 bool opa)
 {
 	struct ib_agent_port_private *port_priv;
 	struct ib_mad_agent *agent;
 	struct ib_mad_send_buf *send_buf;
 	struct ib_ah *ah;
 	struct ib_mad_send_wr_private *mad_send_wr;
+	size_t data_len;
+	u8 base_version;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH)
 		port_priv = ib_get_agent_port(device, 0);
@@ -106,16 +109,26 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 		return;
 	}
 
+	/* On OPA devices base version determines MAD size */
+	base_version = mad->mad_hdr.base_version;
+	if (opa && base_version == OPA_MGMT_BASE_VERSION)
+		data_len = resp_mad_len - IB_MGMT_MAD_HDR;
+	else
+		data_len = IB_MGMT_MAD_DATA;
+
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
-				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-				      GFP_KERNEL,
-				      IB_MGMT_BASE_VERSION);
+				      IB_MGMT_MAD_HDR, data_len, GFP_KERNEL,
+				      base_version);
 	if (IS_ERR(send_buf)) {
 		dev_err(&device->dev, "ib_create_send_mad error\n");
 		goto err1;
 	}
 
-	memcpy(send_buf->mad, mad, sizeof *mad);
+	if (opa && base_version == OPA_MGMT_BASE_VERSION)
+		memcpy(send_buf->mad, mad, resp_mad_len);
+	else
+		memcpy(send_buf->mad, mad, sizeof(*mad));
+
 	send_buf->ah = ah;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 6669287009c2..7ede18b34ca8 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -46,6 +46,7 @@ extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
 extern void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 				struct ib_wc *wc, struct ib_device *device,
-				int port_num, int qpn);
+				int port_num, int qpn, u32 resp_mad_len,
+				bool opa);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 50a63247f6f9..e3328a353f92 100644
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
@@ -736,6 +738,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 {
 	int ret = 0;
 	struct ib_smp *smp = mad_send_wr->send_buf.mad;
+	struct opa_smp *opa_smp = (struct opa_smp *)smp;
 	unsigned long flags;
 	struct ib_mad_local_private *local;
 	struct ib_mad_private *mad_priv;
@@ -747,6 +750,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
 	size_t in_mad_size = max_mad_size(mad_agent_priv->qp_info->port_priv);
 	size_t out_mad_size;
+	u16 drslid;
+	bool opa = rdma_cap_opa_mad(mad_agent_priv->qp_info->port_priv->device,
+				    mad_agent_priv->qp_info->port_priv->port_num);
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -760,19 +766,47 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
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
@@ -793,10 +827,16 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
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
 				  (struct ib_mad_hdr *)smp, in_mad_size,
@@ -825,7 +865,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		port_priv = ib_get_mad_port(mad_agent_priv->agent.device,
 					    mad_agent_priv->agent.port_num);
 		if (port_priv) {
-			memcpy(&mad_priv->mad.mad, smp, sizeof(struct ib_mad));
+			if (opa && smp->base_version == OPA_MGMT_BASE_VERSION)
+				memcpy(&mad_priv->mad.mad, smp, sizeof(struct opa_mad));
+			else
+				memcpy(&mad_priv->mad.mad, smp, sizeof(struct ib_mad));
 			recv_mad_agent = find_mad_agent(port_priv,
 						        &mad_priv->mad.mad);
 		}
@@ -848,6 +891,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 
 	local->mad_send_wr = mad_send_wr;
+	local->mad_send_wr->send_wr.wr.ud.pkey_index = mad_wc.pkey_index;
+	local->return_wc_byte_len = out_mad_size;
 	/* Reference MAD agent until send side of local completion handled */
 	atomic_inc(&mad_agent_priv->refcount);
 	/* Queue local completion to local list */
@@ -1740,14 +1785,18 @@ out:
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
 
@@ -1995,7 +2044,9 @@ enum smi_action handle_ib_smi(struct ib_mad_port_private *port_priv,
 				    &response->grh, wc,
 				    port_priv->device,
 				    smi_get_fwd_port(&recv->mad.smp),
-				    qp_info->qp->qp_num);
+				    qp_info->qp->qp_num,
+				    sizeof(struct ib_mad),
+				    false);
 
 		return IB_SMI_DISCARD;
 	}
@@ -2008,7 +2059,9 @@ static size_t mad_recv_buf_size(struct ib_mad_port_private *port_priv)
 }
 
 static bool generate_unmatched_resp(struct ib_mad_private *recv,
-				    struct ib_mad_private *response)
+				    struct ib_mad_private *response,
+				    size_t *resp_len,
+				    bool opa)
 {
 	if (recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_GET ||
 	    recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_SET) {
@@ -2022,11 +2075,90 @@ static bool generate_unmatched_resp(struct ib_mad_private *recv,
 		if (recv->mad.mad.mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
 			response->mad.mad.mad_hdr.status |= IB_SMP_DIRECTION;
 
+		if (opa && recv->mad.mad.mad_hdr.base_version == OPA_MGMT_BASE_VERSION) {
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
+
+	if (opa_smi_handle_dr_smp_recv(&recv->mad.opa_smp,
+				   port_priv->device->node_type,
+				   port_num,
+				   port_priv->device->phys_port_cnt) ==
+				   IB_SMI_DISCARD)
+		return IB_SMI_DISCARD;
+
+	retsmi = opa_smi_check_forward_dr_smp(&recv->mad.opa_smp);
+	if (retsmi == IB_SMI_LOCAL)
+		return IB_SMI_HANDLE;
+
+	if (retsmi == IB_SMI_SEND) { /* don't forward */
+		if (opa_smi_handle_dr_smp_send(&recv->mad.opa_smp,
+					   port_priv->device->node_type,
+					   port_num) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+		if (opa_smi_check_local_smp(&recv->mad.opa_smp, port_priv->device) == IB_SMI_DISCARD)
+			return IB_SMI_DISCARD;
+
+	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+		/* forward case for switches */
+		memcpy(response, recv, sizeof(*response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.opa_mad = &response->mad.opa_mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+
+		agent_send_response((struct ib_mad *)&response->mad.mad,
+				    &response->grh, wc,
+				    port_priv->device,
+				    opa_smi_get_fwd_port(&recv->mad.opa_smp),
+				    qp_info->qp->qp_num,
+				    recv->header.wc.byte_len,
+				    1);
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
+	if (opa && recv->mad.mad.mad_hdr.base_version == OPA_MGMT_BASE_VERSION &&
+	    recv->mad.mad.mad_hdr.class_version == OPA_SMI_CLASS_VERSION)
+		return handle_opa_smi(port_priv, qp_info, wc, port_num, recv, response);
+
+	return handle_ib_smi(port_priv, qp_info, wc, port_num, recv, response);
+}
+
 static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 				     struct ib_wc *wc)
 {
@@ -2038,11 +2170,15 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	int port_num;
 	int ret = IB_MAD_RESULT_SUCCESS;
 	size_t resp_mad_size;
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
@@ -2054,7 +2190,13 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
 	recv->header.recv_wc.wc = &recv->header.wc;
-	recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+	if (opa && recv->mad.mad.mad_hdr.base_version == OPA_MGMT_BASE_VERSION) {
+		recv->header.recv_wc.mad_len = wc->byte_len - sizeof(struct ib_grh);
+		recv->header.recv_wc.mad_seg_size = sizeof(struct opa_mad);
+	} else {
+		recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
+		recv->header.recv_wc.mad_seg_size = sizeof(struct ib_mad);
+	}
 	recv->header.recv_wc.recv_buf.mad = &recv->mad.mad;
 	recv->header.recv_wc.recv_buf.grh = &recv->grh;
 
@@ -2062,7 +2204,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
 
 	/* Validate MAD */
-	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
+	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info, opa))
 		goto out;
 
 	resp_mad_size = max_mad_size(port_priv);
@@ -2080,8 +2222,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
 	if (recv->mad.mad.mad_hdr.mgmt_class ==
 	    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-		if (handle_ib_smi(port_priv, qp_info, wc, port_num, recv,
-				  response)
+		if (handle_smi(port_priv, qp_info, wc, port_num, recv, response, opa)
 		    == IB_SMI_DISCARD)
 			goto out;
 	}
@@ -2103,7 +2244,9 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 						    &recv->grh, wc,
 						    port_priv->device,
 						    port_num,
-						    qp_info->qp->qp_num);
+						    qp_info->qp->qp_num,
+						    resp_mad_size,
+						    opa);
 				goto out;
 			}
 		}
@@ -2118,9 +2261,12 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		 */
 		recv = NULL;
 	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
-		   generate_unmatched_resp(recv, response)) {
+		   generate_unmatched_resp(recv, response, &resp_mad_size, opa)) {
 		agent_send_response(&response->mad.mad, &recv->grh, wc,
-				    port_priv->device, port_num, qp_info->qp->qp_num);
+				    port_priv->device, port_num,
+				    qp_info->qp->qp_num,
+				    resp_mad_size,
+				    opa);
 	}
 
 out:
@@ -2522,10 +2668,14 @@ static void local_completions(struct work_struct *work)
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
@@ -2535,6 +2685,7 @@ static void local_completions(struct work_struct *work)
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 		free_mad = 0;
 		if (local->mad_priv) {
+			u8 base_version;
 			recv_mad_agent = local->recv_mad_agent;
 			if (!recv_mad_agent) {
 				dev_err(&mad_agent_priv->agent.device->dev,
@@ -2550,11 +2701,20 @@ static void local_completions(struct work_struct *work)
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
@@ -2703,7 +2863,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
 
 	/* Initialize common scatter list fields */
-	sg_list.length = sizeof *mad_priv - sizeof mad_priv->header;
+	sg_list.length = mad_recv_buf_size(qp_info->port_priv);
 	sg_list.lkey = (*qp_info->port_priv->mr).lkey;
 
 	/* Initialize common receive WR fields */
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 6e8b02fdcc5f..e8db522cc447 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -154,6 +154,7 @@ struct ib_mad_local_private {
 	struct ib_mad_private *mad_priv;
 	struct ib_mad_agent_private *recv_mad_agent;
 	struct ib_mad_send_wr_private *mad_send_wr;
+	size_t return_wc_byte_len;
 };
 
 struct ib_mad_mgmt_method_table {
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 9c284d9b4fa9..4930bb90319f 100644
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
 	struct ib_rmpp_base *rmpp_base;
 	int hdr_size, data_size, pad;
+	int opa = rdma_cap_opa_mad(rmpp_recv->agent->qp_info->port_priv->device,
+				   rmpp_recv->agent->qp_info->port_priv->port_num);
 
 	rmpp_base = (struct ib_rmpp_base *)rmpp_recv->cur_seg_buf->mad;
 
 	hdr_size = ib_get_mad_data_offset(rmpp_base->mad_hdr.mgmt_class);
-	data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
-	pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
-	if (pad > IB_MGMT_RMPP_DATA || pad < 0)
-		pad = 0;
+	if (opa && rmpp_recv->base_version == OPA_MGMT_BASE_VERSION) {
+		data_size = sizeof(struct opa_rmpp_mad) - hdr_size;
+		pad = OPA_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
+		if (pad > OPA_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	} else {
+		data_size = sizeof(struct ib_rmpp_mad) - hdr_size;
+		pad = IB_MGMT_RMPP_DATA - be32_to_cpu(rmpp_base->rmpp_hdr.paylen_newwin);
+		if (pad > IB_MGMT_RMPP_DATA || pad < 0)
+			pad = 0;
+	}
 
 	return hdr_size + rmpp_recv->seg_num * data_size - pad;
 }
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 6be72a563c61..8be631d94615 100644
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
 	struct ib_rmpp_base *rmpp_base;
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
index a8a6e9d2485e..e5b664098047 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -434,6 +434,7 @@ struct ib_mad_recv_buf {
  * @recv_buf: Specifies the location of the received data buffer(s).
  * @rmpp_list: Specifies a list of RMPP reassembled received MAD buffers.
  * @mad_len: The length of the received MAD, without duplicated headers.
+ * @mad_seg_size: The size of individual MAD segments
  *
  * For received response, the wr_id contains a pointer to the ib_mad_send_buf
  *   for the corresponding send request.
@@ -443,6 +444,7 @@ struct ib_mad_recv_wc {
 	struct ib_mad_recv_buf	recv_buf;
 	struct list_head	rmpp_list;
 	int			mad_len;
+	size_t			mad_seg_size;
 };
 
 /**
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
