From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache
Date: Thu, 13 Nov 2014 14:54:16 -0500
Message-ID: <1415908465-24392-8-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Create the jumbo MAD kmem_cache and flag the MAD private structure properly.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 86 +++++++++++++++++++++++++++++++-------
 drivers/infiniband/core/mad_priv.h |  4 ++
 2 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index aecd54e..cde1d5d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -60,6 +60,7 @@ module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
 static struct kmem_cache *ib_mad_cache;
+struct kmem_cache *jumbo_mad_cache;
 
 static struct list_head ib_mad_port_list;
 static u32 ib_mad_client_id = 0;
@@ -85,6 +86,14 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 static int add_oui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 			   struct ib_mad_agent_private *agent_priv);
 
+static void mad_priv_cache_free(struct ib_mad_private *mad_priv)
+{
+	if (mad_priv->header.flags & IB_MAD_PRIV_FLAG_JUMBO)
+		kmem_cache_free(jumbo_mad_cache, mad_priv);
+	else
+		kmem_cache_free(ib_mad_cache, mad_priv);
+}
+
 /*
  * Returns a ib_mad_port_private structure or NULL for a device/port
  * Assumes ib_mad_port_list_lock is being held
@@ -773,7 +782,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	}
 	local->mad_priv = NULL;
 	local->recv_mad_agent = NULL;
-	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
+
+	if (mad_agent_priv->qp_info->supports_jumbo_mads)
+		mad_priv = kmem_cache_alloc(jumbo_mad_cache, GFP_ATOMIC);
+	else
+		mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
+
 	if (!mad_priv) {
 		ret = -ENOMEM;
 		dev_err(&device->dev, "No memory for local response MAD\n");
@@ -804,10 +818,10 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			 */
 			atomic_inc(&mad_agent_priv->refcount);
 		} else
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			mad_priv_cache_free(mad_priv);
 		break;
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED:
-		kmem_cache_free(ib_mad_cache, mad_priv);
+		mad_priv_cache_free(mad_priv);
 		break;
 	case IB_MAD_RESULT_SUCCESS:
 		/* Treat like an incoming receive MAD */
@@ -823,14 +837,14 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			 * No receiving agent so drop packet and
 			 * generate send completion.
 			 */
-			kmem_cache_free(ib_mad_cache, mad_priv);
+			mad_priv_cache_free(mad_priv);
 			break;
 		}
 		local->mad_priv = mad_priv;
 		local->recv_mad_agent = recv_mad_agent;
 		break;
 	default:
-		kmem_cache_free(ib_mad_cache, mad_priv);
+		mad_priv_cache_free(mad_priv);
 		kfree(local);
 		ret = -EINVAL;
 		goto out;
@@ -1241,7 +1255,7 @@ void ib_free_recv_mad(struct ib_mad_recv_wc *mad_recv_wc)
 					    recv_wc);
 		priv = container_of(mad_priv_hdr, struct ib_mad_private,
 				    header);
-		kmem_cache_free(ib_mad_cache, priv);
+		mad_priv_cache_free(priv);
 	}
 }
 EXPORT_SYMBOL(ib_free_recv_mad);
@@ -2081,8 +2095,10 @@ out:
 	/* Post another receive request for this QP */
 	if (response) {
 		ib_mad_post_receive_mads(qp_info, response);
-		if (recv)
+		if (recv) {
+			BUG_ON(recv->header.flags & IB_MAD_PRIV_FLAG_JUMBO);
 			kmem_cache_free(ib_mad_cache, recv);
+		}
 	} else
 		ib_mad_post_receive_mads(qp_info, recv);
 }
@@ -2542,7 +2558,7 @@ local_send_completion:
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		atomic_dec(&mad_agent_priv->refcount);
 		if (free_mad)
-			kmem_cache_free(ib_mad_cache, local->mad_priv);
+			mad_priv_cache_free(local->mad_priv);
 		kfree(local);
 	}
 	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
@@ -2709,6 +2725,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 					    sizeof *mad_priv -
 					      sizeof mad_priv->header,
 					    DMA_FROM_DEVICE);
+			BUG_ON(mad_priv->header.flags & IB_MAD_PRIV_FLAG_JUMBO);
 			kmem_cache_free(ib_mad_cache, mad_priv);
 			dev_err(&qp_info->port_priv->device->dev,
 				"ib_post_recv failed: %d\n", ret);
@@ -2744,12 +2761,21 @@ static void cleanup_recv_queue(struct ib_mad_qp_info *qp_info)
 		/* Remove from posted receive MAD list */
 		list_del(&mad_list->list);
 
-		ib_dma_unmap_single(qp_info->port_priv->device,
-				    recv->header.mapping,
-				    sizeof(struct ib_mad_private) -
-				      sizeof(struct ib_mad_private_header),
-				    DMA_FROM_DEVICE);
-		kmem_cache_free(ib_mad_cache, recv);
+		if (recv->header.flags & IB_MAD_PRIV_FLAG_JUMBO) {
+			ib_dma_unmap_single(qp_info->port_priv->device,
+					    recv->header.mapping,
+					    sizeof(struct jumbo_mad_private) -
+					      sizeof(struct ib_mad_private_header),
+					    DMA_FROM_DEVICE);
+			kmem_cache_free(jumbo_mad_cache, recv);
+		} else {
+			ib_dma_unmap_single(qp_info->port_priv->device,
+					    recv->header.mapping,
+					    sizeof(struct ib_mad_private) -
+					      sizeof(struct ib_mad_private_header),
+					    DMA_FROM_DEVICE);
+			kmem_cache_free(ib_mad_cache, recv);
+		}
 	}
 
 	qp_info->recv_queue.count = 0;
@@ -3157,6 +3183,20 @@ static struct ib_client mad_client = {
 	.remove = ib_mad_remove_device
 };
 
+static void init_ib_mad_private(void *obj)
+{
+	struct ib_mad_private *mp = (struct ib_mad_private *)obj;
+
+	mp->header.flags = 0;
+}
+
+static void init_jumbo_mad_private(void *obj)
+{
+	struct jumbo_mad_private *mp = (struct jumbo_mad_private *)obj;
+
+	mp->header.flags = IB_MAD_PRIV_FLAG_JUMBO;
+}
+
 static int __init ib_mad_init_module(void)
 {
 	int ret;
@@ -3171,23 +3211,36 @@ static int __init ib_mad_init_module(void)
 					 sizeof(struct ib_mad_private),
 					 0,
 					 SLAB_HWCACHE_ALIGN,
-					 NULL);
+					 init_ib_mad_private);
 	if (!ib_mad_cache) {
 		pr_err("Couldn't create ib_mad cache\n");
 		ret = -ENOMEM;
 		goto error1;
 	}
 
+	jumbo_mad_cache = kmem_cache_create("ib_mad_jumbo",
+					 sizeof(struct jumbo_mad_private),
+					 0,
+					 SLAB_HWCACHE_ALIGN,
+					 init_jumbo_mad_private);
+	if (!jumbo_mad_cache) {
+		pr_err("Couldn't create ib_mad cache\n");
+		ret = -ENOMEM;
+		goto error2;
+	}
+
 	INIT_LIST_HEAD(&ib_mad_port_list);
 
 	if (ib_register_client(&mad_client)) {
 		pr_err("Couldn't register ib_mad client\n");
 		ret = -EINVAL;
-		goto error2;
+		goto error3;
 	}
 
 	return 0;
 
+error3:
+	kmem_cache_destroy(jumbo_mad_cache);
 error2:
 	kmem_cache_destroy(ib_mad_cache);
 error1:
@@ -3197,6 +3250,7 @@ error1:
 static void __exit ib_mad_cleanup_module(void)
 {
 	ib_unregister_client(&mad_client);
+	kmem_cache_destroy(jumbo_mad_cache);
 	kmem_cache_destroy(ib_mad_cache);
 }
 
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index c1b5f36..206187a 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -66,11 +66,15 @@ struct ib_mad_list_head {
 	struct ib_mad_queue *mad_queue;
 };
 
+enum ib_mad_private_flags {
+	IB_MAD_PRIV_FLAG_JUMBO = (1 << 0)
+};
 struct ib_mad_private_header {
 	struct ib_mad_list_head mad_list;
 	struct ib_mad_recv_wc recv_wc;
 	struct ib_wc wc;
 	u64 mapping;
+	u64 flags;
 } __attribute__ ((packed));
 
 struct ib_mad_private {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
