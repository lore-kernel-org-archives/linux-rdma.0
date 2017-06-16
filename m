From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 02/19] svcrdma: Squelch disconnection messages
Date: Fri, 16 Jun 2017 11:20:37 -0400
Message-ID: <20170616152037.14210.75651.stgit@klimt.1015granger.net>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616151535.14210.34926.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The server displays "svcrdma: failed to post Send WR (-107)" in the
kernel log when the client disconnects. This could flood the server's
log, so remove the message.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 1736337..5ba6d91 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -313,13 +313,17 @@ static int svc_rdma_dma_map_buf(struct svcxprt_rdma *rdma,
 	dma_addr = ib_dma_map_page(dev, virt_to_page(base),
 				   offset, len, DMA_TO_DEVICE);
 	if (ib_dma_mapping_error(dev, dma_addr))
-		return -EIO;
+		goto out_maperr;
 
 	ctxt->sge[sge_no].addr = dma_addr;
 	ctxt->sge[sge_no].length = len;
 	ctxt->sge[sge_no].lkey = rdma->sc_pd->local_dma_lkey;
 	svc_rdma_count_mappings(rdma, ctxt);
 	return 0;
+
+out_maperr:
+	pr_err("svcrdma: failed to map buffer\n");
+	return -EIO;
 }
 
 static int svc_rdma_dma_map_page(struct svcxprt_rdma *rdma,
@@ -334,13 +338,17 @@ static int svc_rdma_dma_map_page(struct svcxprt_rdma *rdma,
 
 	dma_addr = ib_dma_map_page(dev, page, offset, len, DMA_TO_DEVICE);
 	if (ib_dma_mapping_error(dev, dma_addr))
-		return -EIO;
+		goto out_maperr;
 
 	ctxt->sge[sge_no].addr = dma_addr;
 	ctxt->sge[sge_no].length = len;
 	ctxt->sge[sge_no].lkey = rdma->sc_pd->local_dma_lkey;
 	svc_rdma_count_mappings(rdma, ctxt);
 	return 0;
+
+out_maperr:
+	pr_err("svcrdma: failed to map page\n");
+	return -EIO;
 }
 
 /**
@@ -547,7 +555,6 @@ static int svc_rdma_send_reply_msg(struct svcxprt_rdma *rdma,
 	return 0;
 
 err:
-	pr_err("svcrdma: failed to post Send WR (%d)\n", ret);
 	svc_rdma_unmap_dma(ctxt);
 	svc_rdma_put_context(ctxt, 1);
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
