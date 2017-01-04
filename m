From: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] svcrdma: avoid duplicate dma unmapping during error recovery
Date: Wed,  4 Jan 2017 21:33:29 +0530
Message-ID: <20170104160329.24436-1-sriharsha.basavapatna@broadcom.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In rdma_read_chunk_frmr() when ib_post_send() fails, the error code path
invokes ib_dma_unmap_sg() to unmap the sg list. It then invokes
svc_rdma_put_frmr() which in turn tries to unmap the same sg list through
ib_dma_unmap_sg() again. This second unmap is invalid and could lead to
problems when the iova being unmapped is subsequently reused. Remove
the call to unmap in rdma_read_chunk_frmr() and let svc_rdma_put_frmr()
handle it.

Fixes: 412a15c0fe53 ("svcrdma: Port to new memory registration API")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 57d35fbb1c28..172b537f8cfc 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -347,8 +347,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	atomic_inc(&rdma_stat_read);
 	return ret;
  err:
-	ib_dma_unmap_sg(xprt->sc_cm_id->device,
-			frmr->sg, frmr->sg_nents, frmr->direction);
 	svc_rdma_put_context(ctxt, 0);
 	svc_rdma_put_frmr(xprt, frmr);
 	return ret;
-- 
2.11.0.258.ge05806da9

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
