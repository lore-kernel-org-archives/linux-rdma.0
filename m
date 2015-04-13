From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 27/28] IB/Verbs: Clean up rdma_ib_or_iboe()
Date: Mon, 13 Apr 2015 14:36:45 +0200
Message-ID: <552BB85D.7010400@profitbricks.com>
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


We have finished introducing the cap_XX(), and raw helper rdma_ib_or_iboe()
is no longer necessary, thus clean it up.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 include/rdma/ib_verbs.h                  | 19 +++++++++----------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  6 ++++--
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 78a5cdb2..9f6b88e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1766,13 +1766,6 @@ static inline int rdma_tech_iwarp(struct ib_device *device, u8 port_num)
 			== RDMA_TRANSPORT_IWARP;
 }
 
-static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
-{
-	enum rdma_transport_type tp = device->query_transport(device, port_num);
-
-	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
-}
-
 /**
  * cap_ib_mad - Check if the port of device has the capability Infiniband
  * Management Datagrams.
@@ -1785,7 +1778,9 @@ static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
  */
 static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	enum rdma_transport_type tp = device->query_transport(device, port_num);
+
+	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
 }
 
 /**
@@ -1815,7 +1810,9 @@ static inline int cap_ib_smi(struct ib_device *device, u8 port_num)
  */
 static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	enum rdma_transport_type tp = device->query_transport(device, port_num);
+
+	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
 }
 
 /**
@@ -1890,7 +1887,9 @@ static inline int cap_ipoib(struct ib_device *device, u8 port_num)
  */
 static inline int cap_af_ib(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	enum rdma_transport_type tp = device->query_transport(device, port_num);
+
+	return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
 }
 
 /**
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index a09b7a1..8af6f92 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -987,8 +987,10 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	 */
 	if (!rdma_tech_iwarp(newxprt->sc_cm_id->device,
 			     newxprt->sc_cm_id->port_num) &&
-	    !rdma_ib_or_iboe(newxprt->sc_cm_id->device,
-			     newxprt->sc_cm_id->port_num))
+	    !rdma_tech_ib(newxprt->sc_cm_id->device,
+			  newxprt->sc_cm_id->port_num) &&
+	    !rdma_tech_iboe(newxprt->sc_cm_id->device,
+			    newxprt->sc_cm_id->port_num))
 		goto errout;
 
 	if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
-- 
2.1.0
