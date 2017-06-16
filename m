From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/19] svcrdma: Avoid Send Queue overflow
Date: Fri, 16 Jun 2017 11:20:45 -0400
Message-ID: <20170616152045.14210.12739.stgit@klimt.1015granger.net>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616151535.14210.34926.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sanity case: Catch the case where more Work Requests are being
posted to the Send Queue than there are Send Queue Entries.

This might happen if a client sends a chunk with more segments than
there are SQEs for the transport. The server can't send that reply,
so the transport will deadlock unless the client drops the RPC.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c     |    5 +++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 0cf6202..3b35364 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -232,6 +232,9 @@ static int svc_rdma_post_chunk_ctxt(struct svc_rdma_chunk_ctxt *cc)
 	struct ib_cqe *cqe;
 	int ret;
 
+	if (cc->cc_sqecount > rdma->sc_sq_depth)
+		return -EINVAL;
+
 	first_wr = NULL;
 	cqe = &cc->cc_cqe;
 	list_for_each(tmp, &cc->cc_rwctxts) {
@@ -425,6 +428,7 @@ static int svc_rdma_send_xdr_pagelist(struct svc_rdma_write_info *info,
  *
  * Returns a non-negative number of bytes the chunk consumed, or
  *	%-E2BIG if the payload was larger than the Write chunk,
+ *	%-EINVAL if client provided too many segments,
  *	%-ENOMEM if rdma_rw context pool was exhausted,
  *	%-ENOTCONN if posting failed (connection is lost),
  *	%-EIO if rdma_rw initialization failed (DMA mapping, etc).
@@ -465,6 +469,7 @@ int svc_rdma_send_write_chunk(struct svcxprt_rdma *rdma, __be32 *wr_ch,
  *
  * Returns a non-negative number of bytes the chunk consumed, or
  *	%-E2BIG if the payload was larger than the Reply chunk,
+ *	%-EINVAL if client provided too many segments,
  *	%-ENOMEM if rdma_rw context pool was exhausted,
  *	%-ENOTCONN if posting failed (connection is lost),
  *	%-EIO if rdma_rw initialization failed (DMA mapping, etc).
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 5ba6d91..19fd01e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -684,7 +684,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	return 0;
 
  err2:
-	if (ret != -E2BIG)
+	if (ret != -E2BIG || ret != -EINVAL)
 		goto err1;
 
 	ret = svc_rdma_post_recv(rdma, GFP_KERNEL);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
