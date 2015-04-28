From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v7 07/23] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 28 Apr 2015 17:10:07 +0200
Message-ID: <1430233823-7075-8-git-send-email-yun.wang@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform IB-ulp ipoib.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7cad4dd..468fc2b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1680,9 +1680,7 @@ static void ipoib_add_one(struct ib_device *device)
 	struct net_device *dev;
 	struct ipoib_dev_priv *priv;
 	int s, e, p;
-
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
+	int count = 0;
 
 	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
 	if (!dev_list)
@@ -1699,15 +1697,21 @@ static void ipoib_add_one(struct ib_device *device)
 	}
 
 	for (p = s; p <= e; ++p) {
-		if (rdma_port_get_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
+		if (!rdma_protocol_ib(device, p))
 			continue;
 		dev = ipoib_add_port("ib%d", device, p);
 		if (!IS_ERR(dev)) {
 			priv = netdev_priv(dev);
 			list_add_tail(&priv->list, dev_list);
+			count++;
 		}
 	}
 
+	if (!count) {
+		kfree(dev_list);
+		return;
+	}
+
 	ib_set_client_data(device, &ipoib_client, dev_list);
 }
 
@@ -1716,9 +1720,6 @@ static void ipoib_remove_one(struct ib_device *device)
 	struct ipoib_dev_priv *priv, *tmp;
 	struct list_head *dev_list;
 
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
-
 	dev_list = ib_get_client_data(device, &ipoib_client);
 	if (!dev_list)
 		return;
-- 
2.1.0
