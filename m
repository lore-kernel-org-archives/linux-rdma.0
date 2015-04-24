From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 15/26] IB/Verbs: Reform rest part in IB-core cma
Date: Fri, 24 Apr 2015 14:23:39 +0200
Message-ID: <1429878230-11749-16-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform rest part in IB-core cma.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b80495c..a20566e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -468,10 +468,10 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
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
 
@@ -666,10 +666,9 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
 	if (ret)
 		goto out;
 
-	if (rdma_node_get_transport(id_priv->cma_dev->device->node_type)
-	    == RDMA_TRANSPORT_IB &&
-	    rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)
-	    == IB_LINK_LAYER_ETHERNET) {
+	BUG_ON(id_priv->cma_dev->device != id_priv->id.device);
+
+	if (rdma_tech_iboe(id_priv->id.device, id_priv->id.port_num)) {
 		ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
 
 		if (ret)
@@ -733,11 +732,10 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	int ret;
 	u16 pkey;
 
-	if (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num) ==
-	    IB_LINK_LAYER_INFINIBAND)
-		pkey = ib_addr_get_pkey(dev_addr);
-	else
+	if (rdma_tech_iboe(id_priv->id.device, id_priv->id.port_num))
 		pkey = 0xffff;
+	else
+		pkey = ib_addr_get_pkey(dev_addr);
 
 	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
 				  pkey, &qp_attr->pkey_index);
-- 
2.1.0
