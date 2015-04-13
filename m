From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 23/28] IB/Verbs: Use management helper cap_read_multi_sge()
Date: Mon, 13 Apr 2015 14:34:14 +0200
Message-ID: <552BB7C6.8010700@profitbricks.com>
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


Introduce helper cap_read_multi_sge() to help us check if the port of an
IB device support RDMA Read Multiple Scatter-Gather Entries.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 include/rdma/ib_verbs.h                 | 15 +++++++++++++++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ac62b3a..60f7efb 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1878,6 +1878,21 @@ static inline int cap_ipoib(struct ib_device *device, u8 port_num)
 	return rdma_tech_ib(device, port_num);
 }
 
+/**
+ * cap_read_multi_sge - Check if the port of device has the capability
+ * RDMA Read Multiple Scatter-Gather Entries.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support
+ * RDMA Read Multiple Scatter-Gather Entries.
+ */
+static inline int cap_read_multi_sge(struct ib_device *device, u8 port_num)
+{
+	return !rdma_tech_iwarp(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index a5bed5b..7711b7a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -117,7 +117,8 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 
 static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_count)
 {
-	if (rdma_tech_iwarp(xprt->sc_cm_id->device, xprt->sc_cm_id->port_num))
+	if (!cap_read_multi_sge(xprt->sc_cm_id->device,
+				xprt->sc_cm_id->port_num))
 		return 1;
 	else
 		return min_t(int, sge_count, xprt->sc_max_sge);
-- 
2.1.0
