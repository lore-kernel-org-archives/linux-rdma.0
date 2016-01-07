From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 08/10] svcrdma: Make map_xdr non-static
Date: Thu, 07 Jan 2016 14:49:53 -0500
Message-ID: <20160107194953.2662.52372.stgit@klimt.1015granger.net>
References: <20160107194251.2662.88158.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160107194251.2662.88158.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Pre-requisite to use map_xdr in the backchannel code.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h       |    2 ++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 729ff35..aeffa30 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -213,6 +213,8 @@ extern int rdma_read_chunk_frmr(struct svcxprt_rdma *, struct svc_rqst *,
 				u32, u32, u64, bool);
 
 /* svc_rdma_sendto.c */
+extern int svc_rdma_map_xdr(struct svcxprt_rdma *, struct xdr_buf *,
+			    struct svc_rdma_req_map *);
 extern int svc_rdma_sendto(struct svc_rqst *);
 extern struct rpcrdma_read_chunk *
 	svc_rdma_get_read_chunk(struct rpcrdma_msg *);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index de7df7b..3c25052 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -50,9 +50,9 @@
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
-static int map_xdr(struct svcxprt_rdma *xprt,
-		   struct xdr_buf *xdr,
-		   struct svc_rdma_req_map *vec)
+int svc_rdma_map_xdr(struct svcxprt_rdma *xprt,
+		     struct xdr_buf *xdr,
+		     struct svc_rdma_req_map *vec)
 {
 	int sge_no;
 	u32 sge_bytes;
@@ -62,7 +62,7 @@ static int map_xdr(struct svcxprt_rdma *xprt,
 
 	if (xdr->len !=
 	    (xdr->head[0].iov_len + xdr->page_len + xdr->tail[0].iov_len)) {
-		pr_err("svcrdma: map_xdr: XDR buffer length error\n");
+		pr_err("svcrdma: %s: XDR buffer length error\n", __func__);
 		return -EIO;
 	}
 
@@ -97,9 +97,9 @@ static int map_xdr(struct svcxprt_rdma *xprt,
 		sge_no++;
 	}
 
-	dprintk("svcrdma: map_xdr: sge_no %d page_no %d "
+	dprintk("svcrdma: %s: sge_no %d page_no %d "
 		"page_base %u page_len %u head_len %zu tail_len %zu\n",
-		sge_no, page_no, xdr->page_base, xdr->page_len,
+		__func__, sge_no, page_no, xdr->page_base, xdr->page_len,
 		xdr->head[0].iov_len, xdr->tail[0].iov_len);
 
 	vec->count = sge_no;
@@ -592,7 +592,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	ctxt = svc_rdma_get_context(rdma);
 	ctxt->direction = DMA_TO_DEVICE;
 	vec = svc_rdma_get_req_map(rdma);
-	ret = map_xdr(rdma, &rqstp->rq_res, vec);
+	ret = svc_rdma_map_xdr(rdma, &rqstp->rq_res, vec);
 	if (ret)
 		goto err0;
 	inline_bytes = rqstp->rq_res.len;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
