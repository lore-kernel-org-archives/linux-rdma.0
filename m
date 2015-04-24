From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v6 16/26] IB/Verbs: Use management helper cap_ib_mad()
Date: Fri, 24 Apr 2015 14:23:40 +0200
Message-ID: <1429878230-11749-17-git-send-email-yun.wang@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Introduce helper cap_ib_mad() to help us check if the port of an
IB device support Infiniband Management Datagrams.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/mad.c      |  6 +++---
 drivers/infiniband/core/user_mad.c |  6 +++---
 include/rdma/ib_verbs.h            | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 1822932..4315aeb6 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3066,7 +3066,7 @@ static void ib_mad_init_device(struct ib_device *device)
 	}
 
 	for (i = start; i <= end; i++) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_mad_port_open(device, i)) {
@@ -3087,7 +3087,7 @@ error_agent:
 
 error:
 	while (--i >= start) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_agent_port_close(device, i))
@@ -3111,7 +3111,7 @@ static void ib_mad_remove_device(struct ib_device *device)
 	}
 
 	for (i = start; i <= end; i++) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		if (ib_agent_port_close(device, i))
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index aa8b334..e3ccbf2 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1294,7 +1294,7 @@ static void ib_umad_add_one(struct ib_device *device)
 	umad_dev->end_port   = e;
 
 	for (i = s; i <= e; ++i) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		umad_dev->port[i - s].umad_dev = umad_dev;
@@ -1315,7 +1315,7 @@ static void ib_umad_add_one(struct ib_device *device)
 
 err:
 	while (--i >= s) {
-		if (!rdma_ib_or_iboe(device, i))
+		if (!cap_ib_mad(device, i))
 			continue;
 
 		ib_umad_kill_port(&umad_dev->port[i - s]);
@@ -1333,7 +1333,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 		return;
 
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
-		if (rdma_ib_or_iboe(device, i))
+		if (cap_ib_mad(device, i))
 			ib_umad_kill_port(&umad_dev->port[i]);
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a12e876..624e963 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1773,6 +1773,21 @@ static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
 	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
 }
 
+/**
+ * cap_ib_mad - Check if the port of device has the capability Infiniband
+ * Management Datagrams.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Management Datagrams.
+ */
+static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
+{
+	return rdma_ib_or_iboe(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0
