From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v4 15/27] IB/Verbs: Reform rest part in IB-core cma
Date: Thu, 16 Apr 2015 10:10:11 +0200
Message-ID: <552F6E63.4080709@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552F6CF2.4000606@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, hal@dev.mellanox.co.il, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform rest part in IB-core cma.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 902cc1a..40ca5c6 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -469,10 +469,10 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
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
 
@@ -667,10 +667,9 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
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
@@ -734,8 +733,7 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	int ret;
 	u16 pkey;
 
-	if (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num) ==
-	    IB_LINK_LAYER_INFINIBAND)
+	if (rdma_tech_ib(id_priv->id.device, id_priv->id.port_num))
 		pkey = ib_addr_get_pkey(dev_addr);
 	else
 		pkey = 0xffff;
-- 
2.1.0
