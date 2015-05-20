From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/14] IB/mad: Convert allocations from kmem_cache to kmalloc
Date: Wed, 20 May 2015 04:13:30 -0400
Message-ID: <1432109615-19564-10-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

kmalloc is more flexible to support devices with different sized MADs and
research and testing showed that the current use of kmem_cache does not provide
performance benefits over kmalloc.

Use the new max_mad_size specified by devices for the allocations and DMA maps.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c | 82 +++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ea25e9467cb5..cb5c1e484901 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -59,8 +59,6 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
-static struct kmem_cache *ib_mad_cache;
-
 static struct list_head ib_mad_port_list;
 static u32 ib_mad_client_id = 0;
 
@@ -717,6 +715,17 @@ static void build_smp_wc(struct ib_qp *qp,
 	wc->port_num = port_num;
 }
 
+static struct ib_mad_private *alloc_mad_priv(size_t mad_size, gfp_t flags)
+{
+	return (kmalloc(sizeof(struct ib_mad_private_header) +
+			sizeof(struct ib_grh) + mad_size, flags));
+}
+
+static size_t max_mad_size(struct ib_mad_port_private *port_priv)
+{
+	return rdma_max_mad_size(port_priv->device, port_priv->port_num);
+}
+
 /*
  * Return 0 if SMP is to be sent
  * Return 1 if SMP was consumed locally (whether or not solicited)
@@ -771,7 +780,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 	local->mad_priv = NULL;
 	local->recv_mad_agent = NULL;
-	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
+
+	mad_priv = alloc_mad_priv(max_mad_size(mad_agent_priv->qp_info->port_priv),
+				  GFP_ATOMIC);
 	if (!mad_priv) {
 		ret = -ENOMEM;
 		dev_err(&device->dev, "No memory for local response MAD\n");
@@ -801,10 +812,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
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
@@ -820,14 +831,14 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
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
@@ -1238,7 +1249,7 @@ void ib_free_recv_mad(struct ib_mad_recv_wc *mad_recv_wc)
 					    recv_wc);
 		priv = container_of(mad_priv_hdr, struct ib_mad_private,
 				    header);
-		kmem_cache_free(ib_mad_cache, priv);
+		kfree(priv);
 	}
 }
 EXPORT_SYMBOL(ib_free_recv_mad);
@@ -1971,6 +1982,11 @@ enum smi_action handle_ib_smi(struct ib_mad_port_private *port_priv,
 	return IB_SMI_HANDLE;
 }
 
+static size_t mad_recv_buf_size(struct ib_mad_port_private *port_priv)
+{
+	return(sizeof(struct ib_grh) + max_mad_size(port_priv));
+}
+
 static bool generate_unmatched_resp(struct ib_mad_private *recv,
 				    struct ib_mad_private *response)
 {
@@ -2011,8 +2027,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	recv = container_of(mad_priv_hdr, struct ib_mad_private, header);
 	ib_dma_unmap_single(port_priv->device,
 			    recv->header.mapping,
-			    sizeof(struct ib_mad_private) -
-			      sizeof(struct ib_mad_private_header),
+			    mad_recv_buf_size(port_priv),
 			    DMA_FROM_DEVICE);
 
 	/* Setup MAD receive work completion from "normal" work completion */
@@ -2029,7 +2044,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
 		goto out;
 
-	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
+	response = alloc_mad_priv(max_mad_size(port_priv), GFP_KERNEL);
 	if (!response) {
 		dev_err(&port_priv->device->dev,
 			"ib_mad_recv_done_handler no memory for response buffer\n");
@@ -2089,7 +2104,7 @@ out:
 	if (response) {
 		ib_mad_post_receive_mads(qp_info, response);
 		if (recv)
-			kmem_cache_free(ib_mad_cache, recv);
+			kfree(recv);
 	} else
 		ib_mad_post_receive_mads(qp_info, recv);
 }
@@ -2549,7 +2564,7 @@ local_send_completion:
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		atomic_dec(&mad_agent_priv->refcount);
 		if (free_mad)
-			kmem_cache_free(ib_mad_cache, local->mad_priv);
+			kfree(local->mad_priv);
 		kfree(local);
 	}
 	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
@@ -2678,7 +2693,8 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			mad_priv = mad;
 			mad = NULL;
 		} else {
-			mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
+			mad_priv =
+			alloc_mad_priv(max_mad_size(qp_info->port_priv), GFP_KERNEL);
 			if (!mad_priv) {
 				dev_err(&qp_info->port_priv->device->dev,
 					"No memory for receive buffer\n");
@@ -2688,8 +2704,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 		}
 		sg_list.addr = ib_dma_map_single(qp_info->port_priv->device,
 						 &mad_priv->grh,
-						 sizeof *mad_priv -
-						   sizeof mad_priv->header,
+						 mad_recv_buf_size(qp_info->port_priv),
 						 DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
 						  sg_list.addr))) {
@@ -2713,10 +2728,9 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			spin_unlock_irqrestore(&recv_queue->lock, flags);
 			ib_dma_unmap_single(qp_info->port_priv->device,
 					    mad_priv->header.mapping,
-					    sizeof *mad_priv -
-					      sizeof mad_priv->header,
+					    mad_recv_buf_size(qp_info->port_priv),
 					    DMA_FROM_DEVICE);
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			kfree(mad_priv);
 			dev_err(&qp_info->port_priv->device->dev,
 				"ib_post_recv failed: %d\n", ret);
 			break;
@@ -2753,10 +2767,9 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 
 		ib_dma_unmap_single(qp_info->port_priv->device,
 				    recv->header.mapping,
-				    sizeof(struct ib_mad_private) -
-				      sizeof(struct ib_mad_private_header),
+				    mad_recv_buf_size(qp_info->port_priv),
 				    DMA_FROM_DEVICE);
-		kmem_cache_free(ib_mad_cache, recv);
+		kfree(recv);
 	}
 
 	qp_info->recv_queue.count = 0;
@@ -2937,9 +2950,8 @@ static int ib_mad_port_open(struct ib_device *device,
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
 	int has_smi;
-	size_t max_mad_size = rdma_max_mad_size(device, port_num);
 
-	if (WARN_ON(max_mad_size < IB_MGMT_MAD_SIZE))
+	if (WARN_ON(rdma_max_mad_size(device, port_num) < IB_MGMT_MAD_SIZE))
 		return -EFAULT;
 
 	/* Create new device info */
@@ -3149,45 +3161,25 @@ static struct ib_client mad_client = {
 
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
+		return(-EINVAL);
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
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
