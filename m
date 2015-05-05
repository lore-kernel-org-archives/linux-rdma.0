From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 08/23] IB/Verbs: Reform IB-ulp xprtrdma
Date: Tue,  5 May 2015 14:50:25 +0200
Message-ID: <1430830240-32389-9-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform IB-ulp xprtrdma.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  4 +--
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 45 +++++++++++++-------------------
 2 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index f9f13a3..2cc625d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -117,8 +117,8 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 
 static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_count)
 {
-	if (rdma_node_get_transport(xprt->sc_cm_id->device->node_type) ==
-	     RDMA_TRANSPORT_IWARP)
+	if (rdma_protocol_iwarp(xprt->sc_cm_id->device,
+				xprt->sc_cm_id->port_num))
 		return 1;
 	else
 		return min_t(int, sge_count, xprt->sc_max_sge);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index f609c1c..3df8320 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -851,7 +851,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
 	int uninitialized_var(dma_mr_acc);
-	int need_dma_mr;
+	int need_dma_mr = 0;
 	int ret;
 	int i;
 
@@ -985,35 +985,26 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	/*
 	 * Determine if a DMA MR is required and if so, what privs are required
 	 */
-	switch (rdma_node_get_transport(newxprt->sc_cm_id->device->node_type)) {
-	case RDMA_TRANSPORT_IWARP:
-		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
-		if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
-			need_dma_mr = 1;
-			dma_mr_acc =
-				(IB_ACCESS_LOCAL_WRITE |
-				 IB_ACCESS_REMOTE_WRITE);
-		} else if (!(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
-			need_dma_mr = 1;
-			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
-		} else
-			need_dma_mr = 0;
-		break;
-	case RDMA_TRANSPORT_IB:
-		if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
-			need_dma_mr = 1;
-			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
-		} else if (!(devattr.device_cap_flags &
-			     IB_DEVICE_LOCAL_DMA_LKEY)) {
-			need_dma_mr = 1;
-			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
-		} else
-			need_dma_mr = 0;
-		break;
-	default:
+	if (!rdma_protocol_iwarp(newxprt->sc_cm_id->device,
+				 newxprt->sc_cm_id->port_num) &&
+	    !rdma_ib_or_iboe(newxprt->sc_cm_id->device,
+			     newxprt->sc_cm_id->port_num))
 		goto errout;
+
+	if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG) ||
+	    !(devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
+		need_dma_mr = 1;
+		dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
+		if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
+					newxprt->sc_cm_id->port_num) &&
+		    !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG))
+			dma_mr_acc |= IB_ACCESS_REMOTE_WRITE;
 	}
 
+	if (rdma_protocol_iwarp(newxprt->sc_cm_id->device,
+				newxprt->sc_cm_id->port_num))
+		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV;
+
 	/* Create the DMA MR if needed, otherwise, use the DMA LKEY */
 	if (need_dma_mr) {
 		/* Register all of physical memory */
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
