From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 17/26] IB/Verbs: Use management helper cap_ib_smi()
Date: Fri, 24 Apr 2015 14:23:41 +0200
Message-ID: <1429878230-11749-18-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Introduce helper cap_ib_smi() to help us check if the port of an
IB device support Infiniband Subnet Management Interface.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/agent.c |  2 +-
 drivers/infiniband/core/mad.c   |  2 +-
 include/rdma/ib_verbs.h         | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index ffdef4d..61471ee 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -156,7 +156,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		goto error1;
 	}
 
-	if (rdma_tech_ib(device, port_num)) {
+	if (cap_ib_smi(device, port_num)) {
 		/* Obtain send only MAD agent for SMI QP */
 		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
 							    IB_QPT_SMI, NULL, 0,
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4315aeb6..ee3a05e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	init_mad_qp(port_priv, &port_priv->qp_info[1]);
 
 	cq_size = mad_sendq_size + mad_recvq_size;
-	has_smi = rdma_tech_ib(device, port_num);
+	has_smi = cap_ib_smi(device, port_num);
 	if (has_smi)
 		cq_size *= 2;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 624e963..873b9a6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1788,6 +1788,21 @@ static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
 	return rdma_ib_or_iboe(device, port_num);
 }
 
+/**
+ * cap_ib_smi - Check if the port of device has the capability Infiniband
+ * Subnet Management Interface.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Subnet Management Interface.
+ */
+static inline int cap_ib_smi(struct ib_device *device, u8 port_num)
+{
+	return rdma_tech_ib(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0
