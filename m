From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 01/10] svcrdma: Do not send XDR roundup bytes for a write
 chunk
Date: Wed, 03 Feb 2016 10:51:30 -0500
Message-ID: <20160203155130.13868.17835.stgit@klimt.1015granger.net>
References: <20160203154411.13868.48268.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203154411.13868.48268.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the Linux server writes an odd-length data item into a Write
chunk, it finishes with XDR pad bytes. If the data item is smaller
than the Write chunk, the pad bytes are written at the end of the
data item, but still inside the chunk. That can expose these zero
bytes to the RPC consumer on the client.

XDR pad bytes are inserted in order to preserve the XDR alignment
of the next XDR data item in an XDR stream. But Write chunks do not
appear in the payload XDR stream, and only one data item is allowed
in each chunk. So XDR padding is unneeded.

Thus the server should not write XDR pad bytes in Write chunks.

I believe this is not an operational problem. Short NFS READs that
are returned in a Write chunk would be affected by this issue. But
they happen only when the read request goes past the EOF. Those are
zero bytes anyway, and there's no file data in the client's buffer
past EOF.

Otherwise, current NFS clients provide a separate extra segment for
catching XDR padding. If an odd-size data item fills the chunk,
then the XDR pad will be written to the extra segment.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index df57f3c..8591314 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -308,7 +308,7 @@ static int send_write_chunks(struct svcxprt_rdma *xprt,
 			     struct svc_rqst *rqstp,
 			     struct svc_rdma_req_map *vec)
 {
-	u32 xfer_len = rqstp->rq_res.page_len + rqstp->rq_res.tail[0].iov_len;
+	u32 xfer_len = rqstp->rq_res.page_len;
 	int write_len;
 	u32 xdr_off;
 	int chunk_off;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
