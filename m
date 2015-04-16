From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v4 03/27] IB/Verbs: Reform IB-core mad/agent/user_mad
Date: Thu, 16 Apr 2015 10:05:39 +0200
Message-ID: <552F6D53.70804@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552F6CF2.4000606-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform IB-core mad/agent/user_mad.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/agent.c    |  2 +-
 drivers/infiniband/core/mad.c      | 20 ++++++++++----------
 drivers/infiniband/core/user_mad.c | 26 ++++++++++++++++++++------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index f6d2961..ffdef4d 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -156,7 +156,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		goto error1;
 	}
 
-	if (rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND) {
+	if (rdma_tech_ib(device, port_num)) {
 		/* Obtain send only MAD agent for SMI QP */
 		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
 							    IB_QPT_SMI, NULL, 0,
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74c30f4..d451a47 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	init_mad_qp(port_priv, &port_priv->qp_info[1]);
 
 	cq_size = mad_sendq_size + mad_recvq_size;
-	has_smi = rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND;
+	has_smi = rdma_tech_ib(device, port_num);
 	if (has_smi)
 		cq_size *= 2;
 
@@ -3057,9 +3057,6 @@ static void ib_mad_init_device(struct ib_device *device)
 {
 	int start, end, i;
 
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
-
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		start = 0;
 		end   = 0;
@@ -3069,6 +3066,9 @@ static void ib_mad_init_device(struct ib_device *device)
 	}
 
 	for (i = start; i <= end; i++) {
+		if (!rdma_ib_or_iboe(device, i))
+			continue;
+
 		if (ib_mad_port_open(device, i)) {
 			dev_err(&device->dev, "Couldn't open port %d\n", i);
 			goto error;
@@ -3086,15 +3086,15 @@ error_agent:
 		dev_err(&device->dev, "Couldn't close port %d\n", i);
 
 error:
-	i--;
+	while (--i >= start) {
+		if (!rdma_ib_or_iboe(device, i))
+			continue;
 
-	while (i >= start) {
 		if (ib_agent_port_close(device, i))
 			dev_err(&device->dev,
 				"Couldn't close port %d for agents\n", i);
 		if (ib_mad_port_close(device, i))
 			dev_err(&device->dev, "Couldn't close port %d\n", i);
-		i--;
 	}
 }
 
@@ -3102,9 +3102,6 @@ static void ib_mad_remove_device(struct ib_device *device)
 {
 	int i, num_ports, cur_port;
 
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
-
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		num_ports = 1;
 		cur_port = 0;
@@ -3113,6 +3110,9 @@ static void ib_mad_remove_device(struct ib_device *device)
 		cur_port = 1;
 	}
 	for (i = 0; i < num_ports; i++, cur_port++) {
+		if (!rdma_ib_or_iboe(device, i))
+			continue;
+
 		if (ib_agent_port_close(device, cur_port))
 			dev_err(&device->dev,
 				"Couldn't close port %d for agents\n",
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 928cdd2..71fc8ba 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1273,9 +1273,7 @@ static void ib_umad_add_one(struct ib_device *device)
 {
 	struct ib_umad_device *umad_dev;
 	int s, e, i;
-
-	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
-		return;
+	int count = 0;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH)
 		s = e = 0;
@@ -1296,11 +1294,21 @@ static void ib_umad_add_one(struct ib_device *device)
 	umad_dev->end_port   = e;
 
 	for (i = s; i <= e; ++i) {
+		if (!rdma_ib_or_iboe(device, i))
+			continue;
+
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
 		if (ib_umad_init_port(device, i, umad_dev,
 				      &umad_dev->port[i - s]))
 			goto err;
+
+		count++;
+	}
+
+	if (!count) {
+		kobject_put(&umad_dev->kobj);
+		return;
 	}
 
 	ib_set_client_data(device, &umad_client, umad_dev);
@@ -1308,8 +1316,12 @@ static void ib_umad_add_one(struct ib_device *device)
 	return;
 
 err:
-	while (--i >= s)
+	while (--i >= s) {
+		if (!rdma_ib_or_iboe(device, i))
+			continue;
+
 		ib_umad_kill_port(&umad_dev->port[i - s]);
+	}
 
 	kobject_put(&umad_dev->kobj);
 }
@@ -1322,8 +1334,10 @@ static void ib_umad_remove_one(struct ib_device *device)
 	if (!umad_dev)
 		return;
 
-	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
-		ib_umad_kill_port(&umad_dev->port[i]);
+	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
+		if (rdma_ib_or_iboe(device, i))
+			ib_umad_kill_port(&umad_dev->port[i]);
+	}
 
 	kobject_put(&umad_dev->kobj);
 }
-- 
2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
