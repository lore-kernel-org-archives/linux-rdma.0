From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/14] IB/mad: Convert allocations from kmem_cache to kzalloc
Date: Sat,  6 Jun 2015 14:38:30 -0400
Message-ID: <1433615915-24591-10-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch implements allocating alternate receive MAD buffers within the MAD
stack.  Support for OPA to send/recv variable sized MADs is implemented later.

    1) Convert MAD allocations from kmem_cache to kzalloc

       kzalloc is more flexible to support devices with different sized MADs
       and research and testing showed that the current use of kmem_cache does
       not provide performance benefits over kzalloc.

    2) Change struct ib_mad_private to use a flex array for the mad data
    3) Allocate ib_mad_private based on the size specified by devices in
       rdma_max_mad_size.
    4) Carry the allocated size in ib_mad_private to be used when processing
       ib_mad_private objects.
    5) Alter DMA mappings based on the mad_size of ib_mad_private.
    6) Replace the use of sizeof and static defines as appropriate
    7) Add appropriate casts for the MAD data when calling processing
       functions.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Completely redesigned based on Jasons comments to make ib_mad a flex
	array.

	It turns out that making ib_mad a flex array is really not what we
	need.  The MAD layer uses struct ib_mad_private to track its buffers.
	Therefore it was more appropriate to make ib_mad_private a flex array.

 drivers/infiniband/core/agent.c    |   9 +-
 drivers/infiniband/core/agent.h    |   4 +-
 drivers/infiniband/core/mad.c      | 169 +++++++++++++++++++------------------
 drivers/infiniband/core/mad_priv.h |   7 +-
 4 files changed, 97 insertions(+), 92 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 4fe1fb6b37cd..6c420736ce93 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -78,9 +78,9 @@ ib_get_agent_port(const struct ib_device *device, int port_num)
 	return entry;
 }
 
-void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
+void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *grh,
 			 const struct ib_wc *wc, const struct ib_device *device,
-			 int port_num, int qpn)
+			 int port_num, int qpn, size_t resp_mad_len)
 {
 	struct ib_agent_port_private *port_priv;
 	struct ib_mad_agent *agent;
@@ -107,7 +107,8 @@ void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
 	}
 
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
-				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
+				      IB_MGMT_MAD_HDR,
+				      resp_mad_len - IB_MGMT_MAD_HDR,
 				      GFP_KERNEL,
 				      IB_MGMT_BASE_VERSION);
 	if (IS_ERR(send_buf)) {
@@ -115,7 +116,7 @@ void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
 		goto err1;
 	}
 
-	memcpy(send_buf->mad, mad, sizeof *mad);
+	memcpy(send_buf->mad, mad_hdr, resp_mad_len);
 	send_buf->ah = ah;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 94b5fb5b3eef..234c8aa380e0 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -44,8 +44,8 @@ extern int ib_agent_port_open(struct ib_device *device, int port_num);
 
 extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
-extern void agent_send_response(const struct ib_mad *mad, const struct ib_grh *grh,
+extern void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *grh,
 				const struct ib_wc *wc, const struct ib_device *device,
-				int port_num, int qpn);
+				int port_num, int qpn, size_t resp_mad_len);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7b94be9aa6de..64b66ffae2cb 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -59,8 +59,6 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
-static struct kmem_cache *ib_mad_cache;
-
 static struct list_head ib_mad_port_list;
 static u32 ib_mad_client_id = 0;
 
@@ -717,6 +715,32 @@ static void build_smp_wc(struct ib_qp *qp,
 	wc->port_num = port_num;
 }
 
+static size_t mad_priv_size(const struct ib_mad_private *mp)
+{
+	return sizeof(struct ib_mad_private) + mp->mad_size;
+}
+
+static struct ib_mad_private *alloc_mad_private(size_t mad_size, gfp_t flags)
+{
+	size_t size = sizeof(struct ib_mad_private) + mad_size;
+	struct ib_mad_private *ret = kzalloc(size, flags);
+
+	if (ret)
+		ret->mad_size = mad_size;
+
+	return ret;
+}
+
+static size_t port_mad_size(const struct ib_mad_port_private *port_priv)
+{
+	return rdma_max_mad_size(port_priv->device, port_priv->port_num);
+}
+
+static size_t mad_priv_dma_size(const struct ib_mad_private *mp)
+{
+	return sizeof(struct ib_grh) + mp->mad_size;
+}
+
 /*
  * Return 0 if SMP is to be sent
  * Return 1 if SMP was consumed locally (whether or not solicited)
@@ -736,6 +760,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	u8 port_num;
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
+	size_t mad_size = port_mad_size(mad_agent_priv->qp_info->port_priv);
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -771,7 +796,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 	local->mad_priv = NULL;
 	local->recv_mad_agent = NULL;
-	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
+	mad_priv = alloc_mad_private(mad_size, GFP_ATOMIC);
 	if (!mad_priv) {
 		ret = -ENOMEM;
 		dev_err(&device->dev, "No memory for local response MAD\n");
@@ -786,12 +811,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 
 	/* No GRH for DR SMP */
 	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
-				  (struct ib_mad *)smp,
-				  (struct ib_mad *)&mad_priv->mad);
+				  (const struct ib_mad *)smp,
+				  (struct ib_mad *)mad_priv->mad);
 	switch (ret)
 	{
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY:
-		if (ib_response_mad(&mad_priv->mad.mad.mad_hdr) &&
+		if (ib_response_mad((const struct ib_mad_hdr *)mad_priv->mad) &&
 		    mad_agent_priv->agent.recv_handler) {
 			local->mad_priv = mad_priv;
 			local->recv_mad_agent = mad_agent_priv;
@@ -801,33 +826,33 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			 */
 			atomic_inc(&mad_agent_priv->refcount);
 		} else
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			kfree(mad_priv);
 		break;
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED:
-		kmem_cache_free(ib_mad_cache, mad_priv);
+		kfree(mad_priv);
 		break;
 	case IB_MAD_RESULT_SUCCESS:
 		/* Treat like an incoming receive MAD */
 		port_priv = ib_get_mad_port(mad_agent_priv->agent.device,
 					    mad_agent_priv->agent.port_num);
 		if (port_priv) {
-			memcpy(&mad_priv->mad.mad, smp, sizeof(struct ib_mad));
+			memcpy(mad_priv->mad, smp, mad_priv->mad_size);
 			recv_mad_agent = find_mad_agent(port_priv,
-						        &mad_priv->mad.mad.mad_hdr);
+						        (const struct ib_mad_hdr *)mad_priv->mad);
 		}
 		if (!port_priv || !recv_mad_agent) {
 			/*
 			 * No receiving agent so drop packet and
 			 * generate send completion.
 			 */
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			kfree(mad_priv);
 			break;
 		}
 		local->mad_priv = mad_priv;
 		local->recv_mad_agent = recv_mad_agent;
 		break;
 	default:
-		kmem_cache_free(ib_mad_cache, mad_priv);
+		kfree(mad_priv);
 		kfree(local);
 		ret = -EINVAL;
 		goto out;
@@ -877,7 +902,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 	struct ib_rmpp_segment *seg = NULL;
 	int left, seg_size, pad;
 
-	send_buf->seg_size = sizeof (struct ib_mad) - send_buf->hdr_len;
+	send_buf->seg_size = sizeof(struct ib_mad) - send_buf->hdr_len;
 	seg_size = send_buf->seg_size;
 	pad = send_wr->pad;
 
@@ -1238,7 +1263,7 @@ void ib_free_recv_mad(struct ib_mad_recv_wc *mad_recv_wc)
 					    recv_wc);
 		priv = container_of(mad_priv_hdr, struct ib_mad_private,
 				    header);
-		kmem_cache_free(ib_mad_cache, priv);
+		kfree(priv);
 	}
 }
 EXPORT_SYMBOL(ib_free_recv_mad);
@@ -1933,58 +1958,62 @@ static enum smi_action handle_ib_smi(const struct ib_mad_port_private *port_priv
 				     struct ib_mad_private *response)
 {
 	enum smi_forward_action retsmi;
+	struct ib_smp *smp = (struct ib_smp *)recv->mad;
 
-	if (smi_handle_dr_smp_recv(&recv->mad.smp,
+	if (smi_handle_dr_smp_recv(smp,
 				   port_priv->device->node_type,
 				   port_num,
 				   port_priv->device->phys_port_cnt) ==
 				   IB_SMI_DISCARD)
 		return IB_SMI_DISCARD;
 
-	retsmi = smi_check_forward_dr_smp(&recv->mad.smp);
+	retsmi = smi_check_forward_dr_smp(smp);
 	if (retsmi == IB_SMI_LOCAL)
 		return IB_SMI_HANDLE;
 
 	if (retsmi == IB_SMI_SEND) { /* don't forward */
-		if (smi_handle_dr_smp_send(&recv->mad.smp,
+		if (smi_handle_dr_smp_send(smp,
 					   port_priv->device->node_type,
 					   port_num) == IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
 
-		if (smi_check_local_smp(&recv->mad.smp, port_priv->device) == IB_SMI_DISCARD)
+		if (smi_check_local_smp(smp, port_priv->device) == IB_SMI_DISCARD)
 			return IB_SMI_DISCARD;
 	} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
 		/* forward case for switches */
-		memcpy(response, recv, sizeof(*response));
+		memcpy(response, recv, mad_priv_size(response));
 		response->header.recv_wc.wc = &response->header.wc;
-		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
+		response->header.recv_wc.recv_buf.mad = (struct ib_mad *)response->mad;
 		response->header.recv_wc.recv_buf.grh = &response->grh;
 
-		agent_send_response(&response->mad.mad,
+		agent_send_response((const struct ib_mad_hdr *)response->mad,
 				    &response->grh, wc,
 				    port_priv->device,
-				    smi_get_fwd_port(&recv->mad.smp),
-				    qp_info->qp->qp_num);
+				    smi_get_fwd_port(smp),
+				    qp_info->qp->qp_num,
+				    response->mad_size);
 
 		return IB_SMI_DISCARD;
 	}
 	return IB_SMI_HANDLE;
 }
 
-static bool generate_unmatched_resp(struct ib_mad_private *recv,
+static bool generate_unmatched_resp(const struct ib_mad_private *recv,
 				    struct ib_mad_private *response)
 {
-	if (recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_GET ||
-	    recv->mad.mad.mad_hdr.method == IB_MGMT_METHOD_SET) {
-		memcpy(response, recv, sizeof *response);
+	const struct ib_mad_hdr *recv_hdr = (const struct ib_mad_hdr *)recv->mad;
+	struct ib_mad_hdr *resp_hdr = (struct ib_mad_hdr *)response->mad;
+
+	if (recv_hdr->method == IB_MGMT_METHOD_GET ||
+	    recv_hdr->method == IB_MGMT_METHOD_SET) {
+		memcpy(response, recv, mad_priv_size(response));
 		response->header.recv_wc.wc = &response->header.wc;
-		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
+		response->header.recv_wc.recv_buf.mad = (struct ib_mad *)response->mad;
 		response->header.recv_wc.recv_buf.grh = &response->grh;
-		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
-		response->mad.mad.mad_hdr.status =
-			cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB);
-		if (recv->mad.mad.mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
-			response->mad.mad.mad_hdr.status |= IB_SMP_DIRECTION;
+		resp_hdr->method = IB_MGMT_METHOD_GET_RESP;
+		resp_hdr->status = cpu_to_be16(IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB);
+		if (recv_hdr->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+			resp_hdr->status |= IB_SMP_DIRECTION;
 
 		return true;
 	} else {
@@ -2011,25 +2040,24 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
 	ib_dma_unmap_single(port_priv->device,
 			    recv->header.mapping,
-			    sizeof(struct ib_mad_private) -
-			      sizeof(struct ib_mad_private_header),
+			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
 	recv->header.recv_wc.wc = &recv->header.wc;
 	recv->header.recv_wc.mad_len = sizeof(struct ib_mad);
-	recv->header.recv_wc.recv_buf.mad = &recv->mad.mad;
+	recv->header.recv_wc.recv_buf.mad = (struct ib_mad *)recv->mad;
 	recv->header.recv_wc.recv_buf.grh = &recv->grh;
 
 	if (atomic_read(&qp_info->snoop_count))
 		snoop_recv(qp_info, &recv->header.recv_wc, IB_MAD_SNOOP_RECVS);
 
 	/* Validate MAD */
-	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
+	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info->qp->qp_num))
 		goto out;
 
-	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
+	response = alloc_mad_private(recv->mad_size, GFP_ATOMIC);
 	if (!response) {
 		dev_err(&port_priv->device->dev,
 			"ib_mad_recv_done_handler no memory for response buffer\n");
@@ -2041,7 +2069,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	else
 		port_num = port_priv->port_num;
 
-	if (recv->mad.mad.mad_hdr.mgmt_class ==
+	if (((struct ib_mad_hdr *)recv->mad)->mgmt_class ==
 	    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
 		if (handle_ib_smi(port_priv, qp_info, wc, port_num, recv,
 				  response)
@@ -2054,23 +2082,24 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		ret = port_priv->device->process_mad(port_priv->device, 0,
 						     port_priv->port_num,
 						     wc, &recv->grh,
-						     &recv->mad.mad,
-						     &response->mad.mad);
+						     (const struct ib_mad *)recv->mad,
+						     (struct ib_mad *)response->mad);
 		if (ret & IB_MAD_RESULT_SUCCESS) {
 			if (ret & IB_MAD_RESULT_CONSUMED)
 				goto out;
 			if (ret & IB_MAD_RESULT_REPLY) {
-				agent_send_response(&response->mad.mad,
+				agent_send_response((const struct ib_mad_hdr *)response->mad,
 						    &recv->grh, wc,
 						    port_priv->device,
 						    port_num,
-						    qp_info->qp->qp_num);
+						    qp_info->qp->qp_num,
+						    response->mad_size);
 				goto out;
 			}
 		}
 	}
 
-	mad_agent = find_mad_agent(port_priv, &recv->mad.mad.mad_hdr);
+	mad_agent = find_mad_agent(port_priv, (const struct ib_mad_hdr *)recv->mad);
 	if (mad_agent) {
 		ib_mad_complete_recv(mad_agent, &recv->header.recv_wc);
 		/*
@@ -2080,16 +2109,16 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		recv = NULL;
 	} else if ((ret & IB_MAD_RESULT_SUCCESS) &&
 		   generate_unmatched_resp(recv, response)) {
-		agent_send_response(&response->mad.mad, &recv->grh, wc,
-				    port_priv->device, port_num, qp_info->qp->qp_num);
+		agent_send_response((const struct ib_mad_hdr *)response->mad, &recv->grh, wc,
+				    port_priv->device, port_num,
+				    qp_info->qp->qp_num, response->mad_size);
 	}
 
 out:
 	/* Post another receive request for this QP */
 	if (response) {
 		ib_mad_post_receive_mads(qp_info, response);
-		if (recv)
-			kmem_cache_free(ib_mad_cache, recv);
+		kfree(recv);
 	} else
 		ib_mad_post_receive_mads(qp_info, recv);
 }
@@ -2521,7 +2550,7 @@ static void local_completions(struct work_struct *work)
 				 &local->mad_priv->header.recv_wc.rmpp_list);
 			local->mad_priv->header.recv_wc.recv_buf.grh = NULL;
 			local->mad_priv->header.recv_wc.recv_buf.mad =
-						&local->mad_priv->mad.mad;
+						(struct ib_mad *)local->mad_priv->mad;
 			if (atomic_read(&recv_mad_agent->qp_info->snoop_count))
 				snoop_recv(recv_mad_agent->qp_info,
 					  &local->mad_priv->header.recv_wc,
@@ -2549,7 +2578,7 @@ local_send_completion:
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		atomic_dec(&mad_agent_priv->refcount);
 		if (free_mad)
-			kmem_cache_free(ib_mad_cache, local->mad_priv);
+			kfree(local->mad_priv);
 		kfree(local);
 	}
 	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
@@ -2664,7 +2693,6 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
 
 	/* Initialize common scatter list fields */
-	sg_list.length = sizeof *mad_priv - sizeof mad_priv->header;
 	sg_list.lkey = (*qp_info->port_priv->mr).lkey;
 
 	/* Initialize common receive WR fields */
@@ -2678,7 +2706,8 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			mad_priv = mad;
 			mad = NULL;
 		} else {
-			mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
+			mad_priv = alloc_mad_private(port_mad_size(qp_info->port_priv),
+						     GFP_ATOMIC);
 			if (!mad_priv) {
 				dev_err(&qp_info->port_priv->device->dev,
 					"No memory for receive buffer\n");
@@ -2686,10 +2715,10 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 				break;
 			}
 		}
+		sg_list.length = mad_priv_dma_size(mad_priv);
 		sg_list.addr = ib_dma_map_single(qp_info->port_priv->device,
 						 &mad_priv->grh,
-						 sizeof *mad_priv -
-						   sizeof mad_priv->header,
+						 mad_priv_dma_size(mad_priv),
 						 DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
 						  sg_list.addr))) {
@@ -2713,10 +2742,9 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			spin_unlock_irqrestore(&recv_queue->lock, flags);
 			ib_dma_unmap_single(qp_info->port_priv->device,
 					    mad_priv->header.mapping,
-					    sizeof *mad_priv -
-					      sizeof mad_priv->header,
+					    mad_priv_dma_size(mad_priv),
 					    DMA_FROM_DEVICE);
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			kfree(mad_priv);
 			dev_err(&qp_info->port_priv->device->dev,
 				"ib_post_recv failed: %d\n", ret);
 			break;
@@ -2753,10 +2781,9 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 
 		ib_dma_unmap_single(qp_info->port_priv->device,
 				    recv->header.mapping,
-				    sizeof(struct ib_mad_private) -
-				      sizeof(struct ib_mad_private_header),
+				    mad_priv_dma_size(recv),
 				    DMA_FROM_DEVICE);
-		kmem_cache_free(ib_mad_cache, recv);
+		kfree(recv);
 	}
 
 	qp_info->recv_queue.count = 0;
@@ -3148,45 +3175,25 @@ static struct ib_client mad_client = {
 
 static int __init ib_mad_init_module(void)
 {
-	int ret;
-
 	mad_recvq_size = min(mad_recvq_size, IB_MAD_QP_MAX_SIZE);
 	mad_recvq_size = max(mad_recvq_size, IB_MAD_QP_MIN_SIZE);
 
 	mad_sendq_size = min(mad_sendq_size, IB_MAD_QP_MAX_SIZE);
 	mad_sendq_size = max(mad_sendq_size, IB_MAD_QP_MIN_SIZE);
 
-	ib_mad_cache = kmem_cache_create("ib_mad",
-					 sizeof(struct ib_mad_private),
-					 0,
-					 SLAB_HWCACHE_ALIGN,
-					 NULL);
-	if (!ib_mad_cache) {
-		pr_err("Couldn't create ib_mad cache\n");
-		ret = -ENOMEM;
-		goto error1;
-	}
-
 	INIT_LIST_HEAD(&ib_mad_port_list);
 
 	if (ib_register_client(&mad_client)) {
 		pr_err("Couldn't register ib_mad client\n");
-		ret = -EINVAL;
-		goto error2;
+		return -EINVAL;
 	}
 
 	return 0;
-
-error2:
-	kmem_cache_destroy(ib_mad_cache);
-error1:
-	return ret;
 }
 
 static void __exit ib_mad_cleanup_module(void)
 {
 	ib_unregister_client(&mad_client);
-	kmem_cache_destroy(ib_mad_cache);
 }
 
 module_init(ib_mad_init_module);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 7b19cba2adf0..44c0a7842a70 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -75,12 +75,9 @@ struct ib_mad_private_header {
 
 struct ib_mad_private {
 	struct ib_mad_private_header header;
+	size_t mad_size;
 	struct ib_grh grh;
-	union {
-		struct ib_mad mad;
-		struct ib_rmpp_mad rmpp_mad;
-		struct ib_smp smp;
-	} mad;
+	u8 mad[0];
 } __attribute__ ((packed));
 
 struct ib_rmpp_segment {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
