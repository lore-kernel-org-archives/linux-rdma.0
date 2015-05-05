From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 14/23] IB/Verbs: Reform rest part in IB-core cma
Date: Tue,  5 May 2015 14:50:31 +0200
Message-ID: <1430830240-32389-15-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform rest part in IB-core cma.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3fb3458..d43f492f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -447,10 +447,10 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 	pkey = ntohs(addr->sib_pkey);
 
 	list_for_each_entry(cur_dev, &dev_list, list) {
-		if (rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
-			continue;
-
 		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
+			if (!rdma_ib_or_iboe(cur_dev->device, p))
+				continue;
+
 			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
 				continue;
 
@@ -645,10 +645,9 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
 	if (ret)
 		goto out;
 
-	if (rdma_node_get_transport(id_priv->cma_dev->device->node_type)
-	    == RDMA_TRANSPORT_IB &&
-	    rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)
-	    == IB_LINK_LAYER_ETHERNET) {
+	BUG_ON(id_priv->cma_dev->device != id_priv->id.device);
+
+	if (rdma_protocol_iboe(id_priv->id.device, id_priv->id.port_num)) {
 		ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
 
 		if (ret)
@@ -712,11 +711,10 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	int ret;
 	u16 pkey;
 
-	if (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num) ==
-	    IB_LINK_LAYER_INFINIBAND)
-		pkey = ib_addr_get_pkey(dev_addr);
-	else
+	if (rdma_protocol_iboe(id_priv->id.device, id_priv->id.port_num))
 		pkey = 0xffff;
+	else
+		pkey = ib_addr_get_pkey(dev_addr);
 
 	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
 				  pkey, &qp_attr->pkey_index);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
