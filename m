From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 04/28] IB/Verbs: Reform IB-core cm
Date: Mon, 13 Apr 2015 14:23:46 +0200
Message-ID: <552BB552.1030905@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552BB470.4090407@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform IB-core cm.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cm.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..50321fe 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3761,9 +3761,7 @@ static void cm_add_one(struct ib_device *ib_device)
 	unsigned long flags;
 	int ret;
 	u8 i;
-
-	if (rdma_node_get_transport(ib_device->node_type) != RDMA_TRANSPORT_IB)
-		return;
+	int count = 0;
 
 	cm_dev = kzalloc(sizeof(*cm_dev) + sizeof(*port) *
 			 ib_device->phys_port_cnt, GFP_KERNEL);
@@ -3783,6 +3781,9 @@ static void cm_add_one(struct ib_device *ib_device)
 
 	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
+		if (!rdma_ib_or_iboe(ib_device, i))
+			continue;
+
 		port = kzalloc(sizeof *port, GFP_KERNEL);
 		if (!port)
 			goto error1;
@@ -3809,7 +3810,16 @@ static void cm_add_one(struct ib_device *ib_device)
 		ret = ib_modify_port(ib_device, i, 0, &port_modify);
 		if (ret)
 			goto error3;
+
+		count++;
 	}
+
+	if (!count) {
+		device_unregister(cm_dev->device);
+		kfree(cm_dev);
+		return;
+	}
+
 	ib_set_client_data(ib_device, &cm_client, cm_dev);
 
 	write_lock_irqsave(&cm.device_lock, flags);
@@ -3825,6 +3835,9 @@ error1:
 	port_modify.set_port_cap_mask = 0;
 	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
 	while (--i) {
+		if (!rdma_ib_or_iboe(ib_device, i))
+			continue;
+
 		port = cm_dev->port[i-1];
 		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
 		ib_unregister_mad_agent(port->mad_agent);
@@ -3853,6 +3866,9 @@ static void cm_remove_one(struct ib_device *ib_device)
 	write_unlock_irqrestore(&cm.device_lock, flags);
 
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
+		if (!rdma_ib_or_iboe(ib_device, i))
+			continue;
+
 		port = cm_dev->port[i-1];
 		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
 		ib_unregister_mad_agent(port->mad_agent);
-- 
2.1.0
