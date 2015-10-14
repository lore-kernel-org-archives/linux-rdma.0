From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/6] IB/mad: Use helpers to get ib_device and ib_pd from ib_mad_agent
Date: Wed, 14 Oct 2015 11:29:43 +0300
Message-ID: <1444811388-22486-2-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_mad_agent currently exposes an ib_qp and an ib_device unnecessarily.
Replace these fields with a single ib_pd, and use helper functions to get
the device and pd instead of accessing the fields directly.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/agent.c         |  4 +-
 drivers/infiniband/core/cm.c            |  5 ++-
 drivers/infiniband/core/mad.c           | 69 ++++++++++++++++++---------------
 drivers/infiniband/core/mad_rmpp.c      |  4 +-
 drivers/infiniband/core/sa_query.c      | 10 +++--
 drivers/infiniband/core/user_mad.c      |  4 +-
 drivers/infiniband/hw/mlx4/mad.c        |  2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  2 +-
 include/rdma/ib_mad.h                   | 16 ++++++--
 10 files changed, 67 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 0429040304fd..444279ae3827 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -59,7 +59,7 @@ __ib_get_agent_port(const struct ib_device *device, int port_num)
 	struct ib_agent_port_private *entry;
 
 	list_for_each_entry(entry, &ib_agent_port_list, port_list) {
-		if (entry->agent[1]->device == device &&
+		if (ib_mad_agent_device(entry->agent[1]) == device &&
 		    entry->agent[1]->port_num == port_num)
 			return entry;
 	}
@@ -99,7 +99,7 @@ void agent_send_response(const struct ib_mad_hdr *mad_hdr, const struct ib_grh *
 	}
 
 	agent = port_priv->agent[qpn];
-	ah = ib_create_ah_from_wc(agent->qp->pd, wc, grh, port_num);
+	ah = ib_create_ah_from_wc(ib_mad_agent_pd(agent), wc, grh, port_num);
 	if (IS_ERR(ah)) {
 		dev_err(&device->dev, "ib_create_ah_from_wc error %ld\n",
 			PTR_ERR(ah));
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ea4db9c1d44f..c6150c5b6ada 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -263,7 +263,7 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 	struct ib_ah *ah;
 
 	mad_agent = cm_id_priv->av.port->mad_agent;
-	ah = ib_create_ah(mad_agent->qp->pd, &cm_id_priv->av.ah_attr);
+	ah = ib_create_ah(ib_mad_agent_pd(mad_agent), &cm_id_priv->av.ah_attr);
 	if (IS_ERR(ah))
 		return PTR_ERR(ah);
 
@@ -294,7 +294,8 @@ static int cm_alloc_response_msg(struct cm_port *port,
 	struct ib_mad_send_buf *m;
 	struct ib_ah *ah;
 
-	ah = ib_create_ah_from_wc(port->mad_agent->qp->pd, mad_recv_wc->wc,
+	ah = ib_create_ah_from_wc(ib_mad_agent_pd(port->mad_agent),
+				  mad_recv_wc->wc,
 				  mad_recv_wc->recv_buf.grh, port->port_num);
 	if (IS_ERR(ah))
 		return PTR_ERR(ah);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4b5c72311deb..62ce3a4c20b7 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -350,11 +350,10 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	mad_agent_priv->qp_info = &port_priv->qp_info[qpn];
 	mad_agent_priv->reg_req = reg_req;
 	mad_agent_priv->agent.rmpp_version = rmpp_version;
-	mad_agent_priv->agent.device = device;
 	mad_agent_priv->agent.recv_handler = recv_handler;
 	mad_agent_priv->agent.send_handler = send_handler;
 	mad_agent_priv->agent.context = context;
-	mad_agent_priv->agent.qp = port_priv->qp_info[qpn].qp;
+	mad_agent_priv->agent.pd = port_priv->qp_info[qpn].qp->pd;
 	mad_agent_priv->agent.port_num = port_num;
 	mad_agent_priv->agent.flags = registration_flags;
 	spin_lock_init(&mad_agent_priv->lock);
@@ -516,11 +515,10 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 
 	/* Now, fill in the various structures */
 	mad_snoop_priv->qp_info = &port_priv->qp_info[qpn];
-	mad_snoop_priv->agent.device = device;
 	mad_snoop_priv->agent.recv_handler = recv_handler;
 	mad_snoop_priv->agent.snoop_handler = snoop_handler;
 	mad_snoop_priv->agent.context = context;
-	mad_snoop_priv->agent.qp = port_priv->qp_info[qpn].qp;
+	mad_snoop_priv->agent.pd = port_priv->qp_info[qpn].qp->pd;
 	mad_snoop_priv->agent.port_num = port_num;
 	mad_snoop_priv->mad_snoop_flags = mad_snoop_flags;
 	init_completion(&mad_snoop_priv->comp);
@@ -749,7 +747,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_mad_private *mad_priv;
 	struct ib_mad_port_private *port_priv;
 	struct ib_mad_agent_private *recv_mad_agent = NULL;
-	struct ib_device *device = mad_agent_priv->agent.device;
+	struct ib_device *device = ib_mad_agent_device(&mad_agent_priv->agent);
 	u8 port_num;
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
@@ -831,7 +829,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		goto out;
 	}
 
-	build_smp_wc(mad_agent_priv->agent.qp,
+	build_smp_wc(mad_agent_priv->qp_info->qp,
 		     send_wr->wr_id, drslid,
 		     send_wr->wr.ud.pkey_index,
 		     send_wr->wr.ud.port_num, &mad_wc);
@@ -867,8 +865,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		break;
 	case IB_MAD_RESULT_SUCCESS:
 		/* Treat like an incoming receive MAD */
-		port_priv = ib_get_mad_port(mad_agent_priv->agent.device,
-					    mad_agent_priv->agent.port_num);
+		port_priv = ib_get_mad_port(
+				ib_mad_agent_device(&mad_agent_priv->agent),
+				mad_agent_priv->agent.port_num);
 		if (port_priv) {
 			memcpy(mad_priv->mad, smp, mad_priv->mad_size);
 			recv_mad_agent = find_mad_agent(port_priv,
@@ -949,7 +948,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 	for (left = send_buf->data_len + pad; left > 0; left -= seg_size) {
 		seg = kmalloc(sizeof (*seg) + seg_size, gfp_mask);
 		if (!seg) {
-			dev_err(&send_buf->mad_agent->device->dev,
+			dev_err(&ib_mad_agent_device(send_buf->mad_agent)->dev,
 				"alloc_send_rmpp_segs: RMPP mem alloc failed for len %zd, gfp %#x\n",
 				sizeof (*seg) + seg_size, gfp_mask);
 			free_send_rmpp_list(send_wr);
@@ -997,7 +996,8 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	mad_agent_priv = container_of(mad_agent, struct ib_mad_agent_private,
 				      agent);
 
-	opa = rdma_cap_opa_mad(mad_agent->device, mad_agent->port_num);
+	opa = rdma_cap_opa_mad(ib_mad_agent_device(mad_agent),
+			       mad_agent->port_num);
 
 	if (opa && base_version == OPA_MGMT_BASE_VERSION)
 		mad_size = sizeof(struct opa_mad);
@@ -1028,7 +1028,8 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 
 	mad_send_wr->mad_agent_priv = mad_agent_priv;
 	mad_send_wr->sg_list[0].length = hdr_len;
-	mad_send_wr->sg_list[0].lkey = mad_agent->qp->pd->local_dma_lkey;
+	mad_send_wr->sg_list[0].lkey =
+		ib_mad_agent_pd(mad_agent)->local_dma_lkey;
 
 	/* OPA MADs don't have to be the full 2048 bytes */
 	if (opa && base_version == OPA_MGMT_BASE_VERSION &&
@@ -1037,7 +1038,8 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	else
 		mad_send_wr->sg_list[1].length = mad_size - hdr_len;
 
-	mad_send_wr->sg_list[1].lkey = mad_agent->qp->pd->local_dma_lkey;
+	mad_send_wr->sg_list[1].lkey =
+		ib_mad_agent_pd(mad_agent)->local_dma_lkey;
 
 	mad_send_wr->send_wr.wr_id = (unsigned long) mad_send_wr;
 	mad_send_wr->send_wr.sg_list = mad_send_wr->sg_list;
@@ -1156,21 +1158,23 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 
 	mad_agent = mad_send_wr->send_buf.mad_agent;
 	sge = mad_send_wr->sg_list;
-	sge[0].addr = ib_dma_map_single(mad_agent->device,
+	sge[0].addr = ib_dma_map_single(ib_mad_agent_device(mad_agent),
 					mad_send_wr->send_buf.mad,
 					sge[0].length,
 					DMA_TO_DEVICE);
-	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[0].addr)))
+	if (unlikely(ib_dma_mapping_error(ib_mad_agent_device(mad_agent),
+					  sge[0].addr)))
 		return -ENOMEM;
 
 	mad_send_wr->header_mapping = sge[0].addr;
 
-	sge[1].addr = ib_dma_map_single(mad_agent->device,
+	sge[1].addr = ib_dma_map_single(ib_mad_agent_device(mad_agent),
 					ib_get_payload(mad_send_wr),
 					sge[1].length,
 					DMA_TO_DEVICE);
-	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[1].addr))) {
-		ib_dma_unmap_single(mad_agent->device,
+	if (unlikely(ib_dma_mapping_error(ib_mad_agent_device(mad_agent),
+					  sge[1].addr))) {
+		ib_dma_unmap_single(ib_mad_agent_device(mad_agent),
 				    mad_send_wr->header_mapping,
 				    sge[0].length, DMA_TO_DEVICE);
 		return -ENOMEM;
@@ -1179,7 +1183,7 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 
 	spin_lock_irqsave(&qp_info->send_queue.lock, flags);
 	if (qp_info->send_queue.count < qp_info->send_queue.max_active) {
-		ret = ib_post_send(mad_agent->qp, &mad_send_wr->send_wr,
+		ret = ib_post_send(qp_info->qp, &mad_send_wr->send_wr,
 				   &bad_send_wr);
 		list = &qp_info->send_queue.list;
 	} else {
@@ -1193,10 +1197,10 @@ int ib_send_mad(struct ib_mad_send_wr_private *mad_send_wr)
 	}
 	spin_unlock_irqrestore(&qp_info->send_queue.lock, flags);
 	if (ret) {
-		ib_dma_unmap_single(mad_agent->device,
+		ib_dma_unmap_single(ib_mad_agent_device(mad_agent),
 				    mad_send_wr->header_mapping,
 				    sge[0].length, DMA_TO_DEVICE);
-		ib_dma_unmap_single(mad_agent->device,
+		ib_dma_unmap_single(ib_mad_agent_device(mad_agent),
 				    mad_send_wr->payload_mapping,
 				    sge[1].length, DMA_TO_DEVICE);
 	}
@@ -1337,7 +1341,7 @@ EXPORT_SYMBOL(ib_redirect_mad_qp);
 int ib_process_mad_wc(struct ib_mad_agent *mad_agent,
 		      struct ib_wc *wc)
 {
-	dev_err(&mad_agent->device->dev,
+	dev_err(&ib_mad_agent_device(mad_agent)->dev,
 		"ib_process_mad_wc() not implemented yet\n");
 	return 0;
 }
@@ -1457,7 +1461,7 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate management class table for "new" class version */
 		*class = kzalloc(sizeof **class, GFP_ATOMIC);
 		if (!*class) {
-			dev_err(&agent_priv->agent.device->dev,
+			dev_err(&ib_mad_agent_device(&agent_priv->agent)->dev,
 				"No memory for ib_mad_mgmt_class_table\n");
 			ret = -ENOMEM;
 			goto error1;
@@ -1524,7 +1528,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate mgmt vendor class table for "new" class version */
 		vendor = kzalloc(sizeof *vendor, GFP_ATOMIC);
 		if (!vendor) {
-			dev_err(&agent_priv->agent.device->dev,
+			dev_err(&ib_mad_agent_device(&agent_priv->agent)->dev,
 				"No memory for ib_mad_mgmt_vendor_class_table\n");
 			goto error1;
 		}
@@ -1535,7 +1539,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate table for this management vendor class */
 		vendor_class = kzalloc(sizeof *vendor_class, GFP_ATOMIC);
 		if (!vendor_class) {
-			dev_err(&agent_priv->agent.device->dev,
+			dev_err(&ib_mad_agent_device(&agent_priv->agent)->dev,
 				"No memory for ib_mad_mgmt_vendor_class\n");
 			goto error2;
 		}
@@ -1567,7 +1571,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			goto check_in_use;
 		}
 	}
-	dev_err(&agent_priv->agent.device->dev, "All OUI slots in use\n");
+	dev_err(&ib_mad_agent_device(&agent_priv->agent)->dev, "All OUI slots in use\n");
 	goto error3;
 
 check_in_use:
@@ -1847,7 +1851,7 @@ static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_
 	struct ib_ah_attr attr;
 	u8 send_resp, rcv_resp;
 	union ib_gid sgid;
-	struct ib_device *device = mad_agent_priv->agent.device;
+	struct ib_device *device = mad_agent_priv->agent.pd->device;
 	u8 port_num = mad_agent_priv->agent.port_num;
 	u8 lmc;
 
@@ -2417,6 +2421,7 @@ static void ib_mad_send_done_handler(struct ib_mad_port_private *port_priv,
 	struct ib_mad_queue		*send_queue;
 	struct ib_send_wr		*bad_send_wr;
 	struct ib_mad_send_wc		mad_send_wc;
+	struct ib_device		*ibdev;
 	unsigned long flags;
 	int ret;
 
@@ -2427,11 +2432,10 @@ static void ib_mad_send_done_handler(struct ib_mad_port_private *port_priv,
 	qp_info = send_queue->qp_info;
 
 retry:
-	ib_dma_unmap_single(mad_send_wr->send_buf.mad_agent->device,
-			    mad_send_wr->header_mapping,
+	ibdev = ib_mad_agent_device(mad_send_wr->send_buf.mad_agent);
+	ib_dma_unmap_single(ibdev, mad_send_wr->header_mapping,
 			    mad_send_wr->sg_list[0].length, DMA_TO_DEVICE);
-	ib_dma_unmap_single(mad_send_wr->send_buf.mad_agent->device,
-			    mad_send_wr->payload_mapping,
+	ib_dma_unmap_single(ibdev, mad_send_wr->payload_mapping,
 			    mad_send_wr->sg_list[1].length, DMA_TO_DEVICE);
 	queued_send_wr = NULL;
 	spin_lock_irqsave(&send_queue->lock, flags);
@@ -2700,7 +2704,8 @@ static void local_completions(struct work_struct *work)
 			u8 base_version;
 			recv_mad_agent = local->recv_mad_agent;
 			if (!recv_mad_agent) {
-				dev_err(&mad_agent_priv->agent.device->dev,
+				dev_err(&ib_mad_agent_device(
+						&mad_agent_priv->agent)->dev,
 					"No receive MAD agent for local completion\n");
 				free_mad = 1;
 				goto local_send_completion;
@@ -2710,7 +2715,7 @@ static void local_completions(struct work_struct *work)
 			 * Defined behavior is to complete response
 			 * before request
 			 */
-			build_smp_wc(recv_mad_agent->agent.qp,
+			build_smp_wc(recv_mad_agent->qp_info->qp,
 				     (unsigned long) local->mad_send_wr,
 				     be16_to_cpu(IB_LID_PERMISSIVE),
 				     local->mad_send_wr->send_wr.wr.ud.pkey_index,
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 382941b46e43..1d415f71258f 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -160,7 +160,7 @@ static struct ib_mad_send_buf *alloc_response_msg(struct ib_mad_agent *agent,
 	struct ib_ah *ah;
 	int hdr_len;
 
-	ah = ib_create_ah_from_wc(agent->qp->pd, recv_wc->wc,
+	ah = ib_create_ah_from_wc(ib_mad_agent_pd(agent), recv_wc->wc,
 				  recv_wc->recv_buf.grh, agent->port_num);
 	if (IS_ERR(ah))
 		return (void *) ah;
@@ -291,7 +291,7 @@ create_rmpp_recv(struct ib_mad_agent_private *agent,
 	if (!rmpp_recv)
 		return NULL;
 
-	rmpp_recv->ah = ib_create_ah_from_wc(agent->agent.qp->pd,
+	rmpp_recv->ah = ib_create_ah_from_wc(ib_mad_agent_pd(&agent->agent),
 					     mad_recv_wc->wc,
 					     mad_recv_wc->recv_buf.grh,
 					     agent->agent.port_num);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8c014b33d8e0..3afd8ba408fa 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -443,7 +443,8 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
 	/* Construct the family header first */
 	header = (struct rdma_ls_resolve_header *)
 		skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
-	memcpy(header->device_name, query->port->agent->device->name,
+	memcpy(header->device_name,
+	       ib_mad_agent_device(query->port->agent)->name,
 	       LS_DEVICE_NAME_MAX);
 	header->port_num = query->port->port_num;
 
@@ -855,7 +856,8 @@ static void update_sm_ah(struct work_struct *work)
 	struct ib_port_attr port_attr;
 	struct ib_ah_attr   ah_attr;
 
-	if (ib_query_port(port->agent->device, port->port_num, &port_attr)) {
+	if (ib_query_port(ib_mad_agent_device(port->agent), port->port_num,
+			  &port_attr)) {
 		printk(KERN_WARNING "Couldn't query port\n");
 		return;
 	}
@@ -870,7 +872,7 @@ static void update_sm_ah(struct work_struct *work)
 	new_ah->src_path_mask = (1 << port_attr.lmc) - 1;
 
 	new_ah->pkey_index = 0;
-	if (ib_find_pkey(port->agent->device, port->port_num,
+	if (ib_find_pkey(ib_mad_agent_device(port->agent), port->port_num,
 			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index))
 		printk(KERN_ERR "Couldn't find index for default PKey\n");
 
@@ -879,7 +881,7 @@ static void update_sm_ah(struct work_struct *work)
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
 
-	new_ah->ah = ib_create_ah(port->agent->qp->pd, &ah_attr);
+	new_ah->ah = ib_create_ah(ib_mad_agent_pd(port->agent), &ah_attr);
 	if (IS_ERR(new_ah->ah)) {
 		printk(KERN_WARNING "Couldn't create new SM AH\n");
 		kfree(new_ah);
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 57f281f8d686..ed81fbf4e285 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -236,7 +236,7 @@ static void recv_handler(struct ib_mad_agent *agent,
 	if (packet->mad.hdr.grh_present) {
 		struct ib_ah_attr ah_attr;
 
-		ib_init_ah_from_wc(agent->device, agent->port_num,
+		ib_init_ah_from_wc(ib_mad_agent_device(agent), agent->port_num,
 				   mad_recv_wc->wc, mad_recv_wc->recv_buf.grh,
 				   &ah_attr);
 
@@ -501,7 +501,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		ah_attr.grh.traffic_class  = packet->mad.hdr.traffic_class;
 	}
 
-	ah = ib_create_ah(agent->qp->pd, &ah_attr);
+	ah = ib_create_ah(ib_mad_agent_pd(agent), &ah_attr);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_up;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1cd75ff02251..b8771d3eaebf 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -197,7 +197,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 	ah_attr.sl       = sl;
 	ah_attr.port_num = port_num;
 
-	new_ah = ib_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
+	new_ah = ib_create_ah(ib_mad_agent_pd(dev->send_agent[port_num - 1][0]),
 			      &ah_attr);
 	if (IS_ERR(new_ah))
 		return;
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 7c3f2fb44ba5..5c3e2eff1c25 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -86,7 +86,7 @@ static void update_sm_ah(struct mthca_dev *dev,
 	ah_attr.sl       = sl;
 	ah_attr.port_num = port_num;
 
-	new_ah = ib_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
+	new_ah = ib_create_ah(ib_mad_agent_pd(dev->send_agent[port_num - 1][0]),
 			      &ah_attr);
 	if (IS_ERR(new_ah))
 		return;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f6fe0414139b..4c8288cc6297 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -465,7 +465,7 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 	if (!mad_wc || !mad_wc->recv_buf.mad)
 		return;
 
-	ah = ib_create_ah_from_wc(mad_agent->qp->pd, mad_wc->wc,
+	ah = ib_create_ah_from_wc(ib_mad_agent_pd(mad_agent), mad_wc->wc,
 				  mad_wc->recv_buf.grh, mad_agent->port_num);
 	if (IS_ERR(ah))
 		goto err;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 188df91d5851..368001f5efa7 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -449,8 +449,7 @@ typedef void (*ib_mad_recv_handler)(struct ib_mad_agent *mad_agent,
 
 /**
  * ib_mad_agent - Used to track MAD registration with the access layer.
- * @device: Reference to device registration is on.
- * @qp: Reference to QP used for sending and receiving MADs.
+ * @pd: Reference to PD used for sending and receiving MADs.
  * @mr: Memory region for system memory usable for DMA.
  * @recv_handler: Callback handler for a received MAD.
  * @send_handler: Callback handler for a sent MAD.
@@ -467,8 +466,7 @@ enum {
 	IB_MAD_USER_RMPP = IB_USER_MAD_USER_RMPP,
 };
 struct ib_mad_agent {
-	struct ib_device	*device;
-	struct ib_qp		*qp;
+	struct ib_pd		*pd;
 	ib_mad_recv_handler	recv_handler;
 	ib_mad_send_handler	send_handler;
 	ib_mad_snoop_handler	snoop_handler;
@@ -479,6 +477,16 @@ struct ib_mad_agent {
 	u8			rmpp_version;
 };
 
+static inline struct ib_pd *ib_mad_agent_pd(struct ib_mad_agent *agent)
+{
+	return agent->pd;
+}
+
+static inline struct ib_device *ib_mad_agent_device(struct ib_mad_agent *agent)
+{
+	return agent->pd->device;
+}
+
 /**
  * ib_mad_send_wc - MAD send completion information.
  * @send_buf: Send MAD data buffer associated with the send MAD request.
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
