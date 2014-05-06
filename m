From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/5] ib/mad: update module to pr_* style print messages
Date: Mon,  5 May 2014 21:44:47 -0400
Message-ID: <1399340690-27677-3-git-send-email-ira.weiny@intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399340690-27677-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Also combine previously line broken user-visible strings as per
Documentation/CodingStyle

"However, never break user-visible strings such as printk messages, because
that breaks the ability to grep for them."

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/agent.c |  14 +++---
 drivers/infiniband/core/mad.c   | 109 +++++++++++++++++++---------------------
 2 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 2bc7f5a..e1f08b4 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -36,6 +36,8 @@
  *
  */
 
+#define pr_fmt(fmt) SPFX fmt
+
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -94,14 +96,14 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 		port_priv = ib_get_agent_port(device, port_num);
 
 	if (!port_priv) {
-		printk(KERN_ERR SPFX "Unable to find port agent\n");
+		pr_err("Unable to find port agent\n");
 		return;
 	}
 
 	agent = port_priv->agent[qpn];
 	ah = ib_create_ah_from_wc(agent->qp->pd, wc, grh, port_num);
 	if (IS_ERR(ah)) {
-		printk(KERN_ERR SPFX "ib_create_ah_from_wc error %ld\n",
+		pr_err("ib_create_ah_from_wc error %ld\n",
 			PTR_ERR(ah));
 		return;
 	}
@@ -110,7 +112,7 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
 				      GFP_KERNEL);
 	if (IS_ERR(send_buf)) {
-		printk(KERN_ERR SPFX "ib_create_send_mad error\n");
+		pr_err("ib_create_send_mad error\n");
 		goto err1;
 	}
 
@@ -125,7 +127,7 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 	}
 
 	if (ib_post_send_mad(send_buf, NULL)) {
-		printk(KERN_ERR SPFX "ib_post_send_mad error\n");
+		pr_err("ib_post_send_mad error\n");
 		goto err2;
 	}
 	return;
@@ -151,7 +153,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
 	if (!port_priv) {
-		printk(KERN_ERR SPFX "No memory for ib_agent_port_private\n");
+		pr_err("No memory for ib_agent_port_private\n");
 		ret = -ENOMEM;
 		goto error1;
 	}
@@ -202,7 +204,7 @@ int ib_agent_port_close(struct ib_device *device, int port_num)
 	port_priv = __ib_get_agent_port(device, port_num);
 	if (port_priv == NULL) {
 		spin_unlock_irqrestore(&ib_agent_port_list_lock, flags);
-		printk(KERN_ERR SPFX "Port %d not found\n", port_num);
+		pr_err("Port %d not found\n", port_num);
 		return -ENODEV;
 	}
 	list_del(&port_priv->port_list);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ab31f13..7395e23 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -33,6 +33,9 @@
  * SOFTWARE.
  *
  */
+
+#define pr_fmt(fmt) PFX fmt
+
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -706,7 +709,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	     smi_handle_dr_smp_send(smp, device->node_type, port_num) ==
 	     IB_SMI_DISCARD) {
 		ret = -EINVAL;
-		printk(KERN_ERR PFX "Invalid directed route\n");
+		pr_err("Invalid directed route\n");
 		goto out;
 	}
 
@@ -718,7 +721,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	local = kmalloc(sizeof *local, GFP_ATOMIC);
 	if (!local) {
 		ret = -ENOMEM;
-		printk(KERN_ERR PFX "No memory for ib_mad_local_private\n");
+		pr_err("No memory for ib_mad_local_private\n");
 		goto out;
 	}
 	local->mad_priv = NULL;
@@ -726,7 +729,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
 	if (!mad_priv) {
 		ret = -ENOMEM;
-		printk(KERN_ERR PFX "No memory for local response MAD\n");
+		pr_err("No memory for local response MAD\n");
 		kfree(local);
 		goto out;
 	}
@@ -837,8 +840,7 @@ static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
 	for (left = send_buf->data_len + pad; left > 0; left -= seg_size) {
 		seg = kmalloc(sizeof (*seg) + seg_size, gfp_mask);
 		if (!seg) {
-			printk(KERN_ERR "alloc_send_rmpp_segs: RMPP mem "
-			       "alloc failed for len %zd, gfp %#x\n",
+			pr_err("alloc_send_rmpp_segs: RMPP mem alloc failed for len %zd, gfp %#x\n",
 			       sizeof (*seg) + seg_size, gfp_mask);
 			free_send_rmpp_list(send_wr);
 			return -ENOMEM;
@@ -1199,7 +1201,7 @@ EXPORT_SYMBOL(ib_redirect_mad_qp);
 int ib_process_mad_wc(struct ib_mad_agent *mad_agent,
 		      struct ib_wc *wc)
 {
-	printk(KERN_ERR PFX "ib_process_mad_wc() not implemented yet\n");
+	pr_err("ib_process_mad_wc() not implemented yet\n");
 	return 0;
 }
 EXPORT_SYMBOL(ib_process_mad_wc);
@@ -1211,7 +1213,7 @@ static int method_in_use(struct ib_mad_mgmt_method_table **method,
 
 	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS) {
 		if ((*method)->agent[i]) {
-			printk(KERN_ERR PFX "Method %d already in use\n", i);
+			pr_err("Method %d already in use\n", i);
 			return -EINVAL;
 		}
 	}
@@ -1223,8 +1225,7 @@ static int allocate_method_table(struct ib_mad_mgmt_method_table **method)
 	/* Allocate management method table */
 	*method = kzalloc(sizeof **method, GFP_ATOMIC);
 	if (!*method) {
-		printk(KERN_ERR PFX "No memory for "
-		       "ib_mad_mgmt_method_table\n");
+		pr_err("No memory for ib_mad_mgmt_method_table\n");
 		return -ENOMEM;
 	}
 
@@ -1319,8 +1320,7 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate management class table for "new" class version */
 		*class = kzalloc(sizeof **class, GFP_ATOMIC);
 		if (!*class) {
-			printk(KERN_ERR PFX "No memory for "
-			       "ib_mad_mgmt_class_table\n");
+			pr_err("No memory for ib_mad_mgmt_class_table\n");
 			ret = -ENOMEM;
 			goto error1;
 		}
@@ -1386,8 +1386,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate mgmt vendor class table for "new" class version */
 		vendor = kzalloc(sizeof *vendor, GFP_ATOMIC);
 		if (!vendor) {
-			printk(KERN_ERR PFX "No memory for "
-			       "ib_mad_mgmt_vendor_class_table\n");
+			pr_err("No memory for ib_mad_mgmt_vendor_class_table\n");
 			goto error1;
 		}
 
@@ -1397,8 +1396,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		/* Allocate table for this management vendor class */
 		vendor_class = kzalloc(sizeof *vendor_class, GFP_ATOMIC);
 		if (!vendor_class) {
-			printk(KERN_ERR PFX "No memory for "
-			       "ib_mad_mgmt_vendor_class\n");
+			pr_err("No memory for ib_mad_mgmt_vendor_class\n");
 			goto error2;
 		}
 
@@ -1429,7 +1427,7 @@ static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			goto check_in_use;
 		}
 	}
-	printk(KERN_ERR PFX "All OUI slots in use\n");
+	pr_err("All OUI slots in use\n");
 	goto error3;
 
 check_in_use:
@@ -1640,8 +1638,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 		if (mad_agent->agent.recv_handler)
 			atomic_inc(&mad_agent->refcount);
 		else {
-			printk(KERN_NOTICE PFX "No receive handler for client "
-			       "%p on port %d\n",
+			pr_notice("No receive handler for client %p on port %d\n",
 			       &mad_agent->agent, port_priv->port_num);
 			mad_agent = NULL;
 		}
@@ -1658,8 +1655,8 @@ static int validate_mad(struct ib_mad *mad, u32 qp_num)
 
 	/* Make sure MAD base version is understood */
 	if (mad->mad_hdr.base_version != IB_MGMT_BASE_VERSION) {
-		printk(KERN_ERR PFX "MAD received with unsupported base "
-		       "version %d\n", mad->mad_hdr.base_version);
+		pr_err("MAD received with unsupported base version %d\n",
+			mad->mad_hdr.base_version);
 		goto out;
 	}
 
@@ -1911,8 +1908,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 
 	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
 	if (!response) {
-		printk(KERN_ERR PFX "ib_mad_recv_done_handler no memory "
-		       "for response buffer\n");
+		pr_err("ib_mad_recv_done_handler no memory for response buffer\n");
 		goto out;
 	}
 
@@ -2176,7 +2172,7 @@ retry:
 		ret = ib_post_send(qp_info->qp, &queued_send_wr->send_wr,
 				   &bad_send_wr);
 		if (ret) {
-			printk(KERN_ERR PFX "ib_post_send failed: %d\n", ret);
+			pr_err("ib_post_send failed: %d\n", ret);
 			mad_send_wr = queued_send_wr;
 			wc->status = IB_WC_LOC_QP_OP_ERR;
 			goto retry;
@@ -2248,8 +2244,8 @@ static void mad_error_handler(struct ib_mad_port_private *port_priv,
 					   IB_QP_STATE | IB_QP_CUR_STATE);
 			kfree(attr);
 			if (ret)
-				printk(KERN_ERR PFX "mad_error_handler - "
-				       "ib_modify_qp to RTS : %d\n", ret);
+				pr_err("mad_error_handler - ib_modify_qp to RTS : %d\n",
+					ret);
 			else
 				mark_sends_for_retry(qp_info);
 		}
@@ -2408,7 +2404,7 @@ static void local_completions(struct work_struct *work)
 		if (local->mad_priv) {
 			recv_mad_agent = local->recv_mad_agent;
 			if (!recv_mad_agent) {
-				printk(KERN_ERR PFX "No receive MAD agent for local completion\n");
+				pr_err("No receive MAD agent for local completion\n");
 				free_mad = 1;
 				goto local_send_completion;
 			}
@@ -2589,7 +2585,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 		} else {
 			mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
 			if (!mad_priv) {
-				printk(KERN_ERR PFX "No memory for receive buffer\n");
+				pr_err("No memory for receive buffer\n");
 				ret = -ENOMEM;
 				break;
 			}
@@ -2625,7 +2621,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 					      sizeof mad_priv->header,
 					    DMA_FROM_DEVICE);
 			kmem_cache_free(ib_mad_cache, mad_priv);
-			printk(KERN_ERR PFX "ib_post_recv failed: %d\n", ret);
+			pr_err("ib_post_recv failed: %d\n", ret);
 			break;
 		}
 	} while (post);
@@ -2681,7 +2677,7 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr) {
-		printk(KERN_ERR PFX "Couldn't kmalloc ib_qp_attr\n");
+		pr_err("Couldn't kmalloc ib_qp_attr\n");
 		return -ENOMEM;
 	}
 
@@ -2705,16 +2701,16 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		ret = ib_modify_qp(qp, attr, IB_QP_STATE |
 					     IB_QP_PKEY_INDEX | IB_QP_QKEY);
 		if (ret) {
-			printk(KERN_ERR PFX "Couldn't change QP%d state to "
-			       "INIT: %d\n", i, ret);
+			pr_err("Couldn't change QP%d state to INIT: %d\n",
+				i, ret);
 			goto out;
 		}
 
 		attr->qp_state = IB_QPS_RTR;
 		ret = ib_modify_qp(qp, attr, IB_QP_STATE);
 		if (ret) {
-			printk(KERN_ERR PFX "Couldn't change QP%d state to "
-			       "RTR: %d\n", i, ret);
+			pr_err("Couldn't change QP%d state to RTR: %d\n",
+				i, ret);
 			goto out;
 		}
 
@@ -2722,16 +2718,16 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 		attr->sq_psn = IB_MAD_SEND_Q_PSN;
 		ret = ib_modify_qp(qp, attr, IB_QP_STATE | IB_QP_SQ_PSN);
 		if (ret) {
-			printk(KERN_ERR PFX "Couldn't change QP%d state to "
-			       "RTS: %d\n", i, ret);
+			pr_err("Couldn't change QP%d state to RTS: %d\n",
+				i, ret);
 			goto out;
 		}
 	}
 
 	ret = ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
 	if (ret) {
-		printk(KERN_ERR PFX "Failed to request completion "
-		       "notification: %d\n", ret);
+		pr_err("Failed to request completion notification: %d\n",
+			ret);
 		goto out;
 	}
 
@@ -2741,7 +2737,7 @@ static int ib_mad_port_start(struct ib_mad_port_private *port_priv)
 
 		ret = ib_mad_post_receive_mads(&port_priv->qp_info[i], NULL);
 		if (ret) {
-			printk(KERN_ERR PFX "Couldn't post receive WRs\n");
+			pr_err("Couldn't post receive WRs\n");
 			goto out;
 		}
 	}
@@ -2755,7 +2751,7 @@ static void qp_event_handler(struct ib_event *event, void *qp_context)
 	struct ib_mad_qp_info	*qp_info = qp_context;
 
 	/* It's worse than that! He's dead, Jim! */
-	printk(KERN_ERR PFX "Fatal error (%d) on MAD QP (%d)\n",
+	pr_err("Fatal error (%d) on MAD QP (%d)\n",
 		event->event, qp_info->qp->qp_num);
 }
 
@@ -2801,7 +2797,7 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	qp_init_attr.event_handler = qp_event_handler;
 	qp_info->qp = ib_create_qp(qp_info->port_priv->pd, &qp_init_attr);
 	if (IS_ERR(qp_info->qp)) {
-		printk(KERN_ERR PFX "Couldn't create ib_mad QP%d\n",
+		pr_err("Couldn't create ib_mad QP%d\n",
 		       get_spl_qp_index(qp_type));
 		ret = PTR_ERR(qp_info->qp);
 		goto error;
@@ -2840,7 +2836,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
 	if (!port_priv) {
-		printk(KERN_ERR PFX "No memory for ib_mad_port_private\n");
+		pr_err("No memory for ib_mad_port_private\n");
 		return -ENOMEM;
 	}
 
@@ -2860,21 +2856,21 @@ static int ib_mad_port_open(struct ib_device *device,
 				     ib_mad_thread_completion_handler,
 				     NULL, port_priv, cq_size, 0);
 	if (IS_ERR(port_priv->cq)) {
-		printk(KERN_ERR PFX "Couldn't create ib_mad CQ\n");
+		pr_err("Couldn't create ib_mad CQ\n");
 		ret = PTR_ERR(port_priv->cq);
 		goto error3;
 	}
 
 	port_priv->pd = ib_alloc_pd(device);
 	if (IS_ERR(port_priv->pd)) {
-		printk(KERN_ERR PFX "Couldn't create ib_mad PD\n");
+		pr_err("Couldn't create ib_mad PD\n");
 		ret = PTR_ERR(port_priv->pd);
 		goto error4;
 	}
 
 	port_priv->mr = ib_get_dma_mr(port_priv->pd, IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(port_priv->mr)) {
-		printk(KERN_ERR PFX "Couldn't get ib_mad DMA MR\n");
+		pr_err("Couldn't get ib_mad DMA MR\n");
 		ret = PTR_ERR(port_priv->mr);
 		goto error5;
 	}
@@ -2902,7 +2898,7 @@ static int ib_mad_port_open(struct ib_device *device,
 
 	ret = ib_mad_port_start(port_priv);
 	if (ret) {
-		printk(KERN_ERR PFX "Couldn't start port\n");
+		pr_err("Couldn't start port\n");
 		goto error9;
 	}
 
@@ -2946,7 +2942,7 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	port_priv = __ib_get_mad_port(device, port_num);
 	if (port_priv == NULL) {
 		spin_unlock_irqrestore(&ib_mad_port_list_lock, flags);
-		printk(KERN_ERR PFX "Port %d not found\n", port_num);
+		pr_err("Port %d not found\n", port_num);
 		return -ENODEV;
 	}
 	list_del_init(&port_priv->port_list);
@@ -2984,13 +2980,12 @@ static void ib_mad_init_device(struct ib_device *device)
 
 	for (i = start; i <= end; i++) {
 		if (ib_mad_port_open(device, i)) {
-			printk(KERN_ERR PFX "Couldn't open %s port %d\n",
+			pr_err("Couldn't open %s port %d\n",
 			       device->name, i);
 			goto error;
 		}
 		if (ib_agent_port_open(device, i)) {
-			printk(KERN_ERR PFX "Couldn't open %s port %d "
-			       "for agents\n",
+			pr_err("Couldn't open %s port %d for agents\n",
 			       device->name, i);
 			goto error_agent;
 		}
@@ -2999,7 +2994,7 @@ static void ib_mad_init_device(struct ib_device *device)
 
 error_agent:
 	if (ib_mad_port_close(device, i))
-		printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+		pr_err("Couldn't close %s port %d\n",
 		       device->name, i);
 
 error:
@@ -3007,11 +3002,10 @@ error:
 
 	while (i >= start) {
 		if (ib_agent_port_close(device, i))
-			printk(KERN_ERR PFX "Couldn't close %s port %d "
-			       "for agents\n",
+			pr_err("Couldn't close %s port %d for agents\n",
 			       device->name, i);
 		if (ib_mad_port_close(device, i))
-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+			pr_err("Couldn't close %s port %d\n",
 			       device->name, i);
 		i--;
 	}
@@ -3033,11 +3027,10 @@ static void ib_mad_remove_device(struct ib_device *device)
 	}
 	for (i = 0; i < num_ports; i++, cur_port++) {
 		if (ib_agent_port_close(device, cur_port))
-			printk(KERN_ERR PFX "Couldn't close %s port %d "
-			       "for agents\n",
+			pr_err("Couldn't close %s port %d for agents\n",
 			       device->name, cur_port);
 		if (ib_mad_port_close(device, cur_port))
-			printk(KERN_ERR PFX "Couldn't close %s port %d\n",
+			pr_err("Couldn't close %s port %d\n",
 			       device->name, cur_port);
 	}
 }
@@ -3064,7 +3057,7 @@ static int __init ib_mad_init_module(void)
 					 SLAB_HWCACHE_ALIGN,
 					 NULL);
 	if (!ib_mad_cache) {
-		printk(KERN_ERR PFX "Couldn't create ib_mad cache\n");
+		pr_err("Couldn't create ib_mad cache\n");
 		ret = -ENOMEM;
 		goto error1;
 	}
@@ -3072,7 +3065,7 @@ static int __init ib_mad_init_module(void)
 	INIT_LIST_HEAD(&ib_mad_port_list);
 
 	if (ib_register_client(&mad_client)) {
-		printk(KERN_ERR PFX "Couldn't register ib_mad client\n");
+		pr_err("Couldn't register ib_mad client\n");
 		ret = -EINVAL;
 		goto error2;
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
