From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v3 12/28] IB/Verbs: Reform mcast related part in IB-core cma
Date: Mon, 13 Apr 2015 14:28:22 +0200
Message-ID: <552BB666.1010503@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552BB470.4090407-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform mcast related part in IB-core cma.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 57 +++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8c41b3f..0a36a42 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -998,17 +998,12 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 		mc = container_of(id_priv->mc_list.next,
 				  struct cma_multicast, list);
 		list_del(&mc->list);
-		switch (rdma_port_get_link_layer(id_priv->cma_dev->device, id_priv->id.port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
+		if (rdma_tech_ib(id_priv->cma_dev->device,
+				      id_priv->id.port_num)) {
 			ib_sa_free_multicast(mc->multicast.ib);
 			kfree(mc);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
+		} else
 			kref_put(&mc->mcref, release_mc);
-			break;
-		default:
-			break;
-		}
 	}
 }
 
@@ -3316,24 +3311,13 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	list_add(&mc->list, &id_priv->mc_list);
 	spin_unlock(&id_priv->lock);
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
-		switch (rdma_port_get_link_layer(id->device, id->port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
-			ret = cma_join_ib_multicast(id_priv, mc);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
-			kref_init(&mc->mcref);
-			ret = cma_iboe_join_multicast(id_priv, mc);
-			break;
-		default:
-			ret = -EINVAL;
-		}
-		break;
-	default:
+	if (rdma_tech_iboe(id->device, id->port_num)) {
+		kref_init(&mc->mcref);
+		ret = cma_iboe_join_multicast(id_priv, mc);
+	} else if (rdma_tech_ib(id->device, id->port_num))
+		ret = cma_join_ib_multicast(id_priv, mc);
+	else
 		ret = -ENOSYS;
-		break;
-	}
 
 	if (ret) {
 		spin_lock_irq(&id_priv->lock);
@@ -3361,19 +3345,16 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 				ib_detach_mcast(id->qp,
 						&mc->multicast.ib->rec.mgid,
 						be16_to_cpu(mc->multicast.ib->rec.mlid));
-			if (rdma_node_get_transport(id_priv->cma_dev->device->node_type) == RDMA_TRANSPORT_IB) {
-				switch (rdma_port_get_link_layer(id->device, id->port_num)) {
-				case IB_LINK_LAYER_INFINIBAND:
-					ib_sa_free_multicast(mc->multicast.ib);
-					kfree(mc);
-					break;
-				case IB_LINK_LAYER_ETHERNET:
-					kref_put(&mc->mcref, release_mc);
-					break;
-				default:
-					break;
-				}
-			}
+
+			BUG_ON(id_priv->cma_dev->device != id->device);
+
+			if (rdma_tech_ib(id->device, id->port_num)) {
+				ib_sa_free_multicast(mc->multicast.ib);
+				kfree(mc);
+			} else if (rdma_tech_iboe(id->device,
+						       id->port_num))
+				kref_put(&mc->mcref, release_mc);
+
 			return;
 		}
 	}
-- 
2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
