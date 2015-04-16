From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v4 25/27] IB/Verbs: Use management helper cap_eth_ah()
Date: Thu, 16 Apr 2015 10:15:02 +0200
Message-ID: <552F6F86.8090800@profitbricks.com>
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


Introduce helper cap_eth_ah() to help us check if the port of an
IB device support Ethernet Address Handler.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c      |  6 +++---
 drivers/infiniband/core/sa_query.c |  2 +-
 drivers/infiniband/core/verbs.c    |  2 +-
 include/rdma/ib_verbs.h            | 15 +++++++++++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d72a2a4..e91ee7a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -733,10 +733,10 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	int ret;
 	u16 pkey;
 
-	if (rdma_tech_ib(id_priv->id.device, id_priv->id.port_num))
-		pkey = ib_addr_get_pkey(dev_addr);
-	else
+	if (cap_eth_ah(id_priv->id.device, id_priv->id.port_num))
 		pkey = 0xffff;
+	else
+		pkey = ib_addr_get_pkey(dev_addr);
 
 	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
 				  pkey, &qp_attr->pkey_index);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index fc7e161..409ec4e 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -540,7 +540,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 	ah_attr->port_num = port_num;
 	ah_attr->static_rate = rec->rate;
 
-	force_grh = rdma_tech_iboe(device, port_num);
+	force_grh = cap_eth_ah(device, port_num);
 
 	if (rec->hop_limit > 1 || force_grh) {
 		ah_attr->ah_flags = IB_AH_GRH;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7264860..ee4b5cb 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -202,7 +202,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 	int ret;
 
 	memset(ah_attr, 0, sizeof *ah_attr);
-	if (rdma_tech_iboe(device, port_num)) {
+	if (cap_eth_ah(device, port_num)) {
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 87ab01b..09c83ae 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1894,6 +1894,21 @@ static inline int cap_af_ib(struct ib_device *device, u8 port_num)
 }
 
 /**
+ * cap_eth_ah - Check if the port of device has the capability
+ * Ethernet Address Handler.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support
+ * Ethernet Address Handler.
+ */
+static inline int cap_eth_ah(struct ib_device *device, u8 port_num)
+{
+	return rdma_tech_iboe(device, port_num);
+}
+
+/**
  * cap_read_multi_sge - Check if the port of device has the capability
  * RDMA Read Multiple Scatter-Gather Entries.
  *
-- 
2.1.0
