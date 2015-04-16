From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v4 26/27] IB/Verbs: Clean up rdma_ib_or_iboe()
Date: Thu, 16 Apr 2015 10:15:24 +0200
Message-ID: <552F6F9C.1050001@profitbricks.com>
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


We have finished introducing the cap_XX(), and raw helper rdma_ib_or_iboe()
is no longer necessary, thus clean it up.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 include/rdma/ib_verbs.h                  | 19 +++++++++----------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  6 ++++--
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09c83ae..262bf44 100644
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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
