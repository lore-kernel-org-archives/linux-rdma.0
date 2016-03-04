From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 04/11] xprtrdma: Segment head and tail XDR buffers on
 page boundaries
Date: Fri, 04 Mar 2016 11:27:52 -0500
Message-ID: <20160304162752.13590.38067.stgit@oracle120-ib.cthon.org>
References: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304162447.13590.9524.stgit-HOT7RYQ5zl57mBIHr/i2/HG1qET/BF4J@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A single memory allocation is used for the pair of buffers wherein
the RPC client builds an RPC call message and decodes its matching
reply. These buffers are sized based on the maximum possible size
of the RPC call and reply messages for the operation in progress.

This means that as the call buffer increases in size, the start of
the reply buffer is pushed farther into the memory allocation.

RPC requests are growing in size. It used to be that both the call
and reply buffers fit inside a single page.

But these days, thanks to NFSv4 (and especially security labels in
NFSv4.2) the maximum call and reply sizes are large. NFSv4.0 OPEN,
for example, now requires a 6KB allocation for a pair of call and
reply buffers, and NFSv4 LOOKUP is not far behind.

As the maximum size of a call increases, the reply buffer is pushed
far enough into the buffer's memory allocation that a page boundary
can appear in the middle of it.

When the maximum possible reply size is larger than the client's
RDMA receive buffers (currently 1KB), the client has to register a
Reply chunk for the server to RDMA Write the reply into.

The logic in rpcrdma_convert_iovs() assumes that xdr_buf head and
tail buffers would always be contained on a single page. It supplies
just one segment for the head and one for the tail.

FMR, for example, registers up to a page boundary (only a portion of
the reply buffer in the OPEN case above). But without additional
segments, it doesn't register the rest of the buffer.

When the server tries to write the OPEN reply, the RDMA Write fails
with a remote access error since the client registered only part of
the Reply chunk.

rpcrdma_convert_iovs() must split the XDR buffer into multiple
segments, each of which are guaranteed not to contain a page
boundary. That way fmr_op_map is given the proper number of segments
to register the whole reply buffer.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   42 ++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e9dfd6a..0607391 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -132,6 +132,33 @@ rpcrdma_tail_pullup(struct xdr_buf *buf)
 	return tlen;
 }
 
+/* Split "vec" on page boundaries into segments. FMR registers pages,
+ * not a byte range. Other modes coalesce these segments into a single
+ * MR when they can.
+ */
+static int
+rpcrdma_convert_kvec(struct kvec *vec, struct rpcrdma_mr_seg *seg,
+		     int n, int nsegs)
+{
+	size_t page_offset;
+	u32 remaining;
+	char *base;
+
+	base = vec->iov_base;
+	page_offset = offset_in_page(base);
+	remaining = vec->iov_len;
+	while (remaining && n < nsegs) {
+		seg[n].mr_page = NULL;
+		seg[n].mr_offset = base;
+		seg[n].mr_len = min_t(u32, PAGE_SIZE - page_offset, remaining);
+		remaining -= seg[n].mr_len;
+		base += seg[n].mr_len;
+		++n;
+		page_offset = 0;
+	}
+	return n;
+}
+
 /*
  * Chunk assembly from upper layer xdr_buf.
  *
@@ -150,11 +177,10 @@ rpcrdma_convert_iovs(struct xdr_buf *xdrbuf, unsigned int pos,
 	int page_base;
 	struct page **ppages;
 
-	if (pos == 0 && xdrbuf->head[0].iov_len) {
-		seg[n].mr_page = NULL;
-		seg[n].mr_offset = xdrbuf->head[0].iov_base;
-		seg[n].mr_len = xdrbuf->head[0].iov_len;
-		++n;
+	if (pos == 0) {
+		n = rpcrdma_convert_kvec(&xdrbuf->head[0], seg, n, nsegs);
+		if (n == nsegs)
+			return -EIO;
 	}
 
 	len = xdrbuf->page_len;
@@ -192,13 +218,9 @@ rpcrdma_convert_iovs(struct xdr_buf *xdrbuf, unsigned int pos,
 		 * xdr pad bytes, saving the server an RDMA operation. */
 		if (xdrbuf->tail[0].iov_len < 4 && xprt_rdma_pad_optimize)
 			return n;
+		n = rpcrdma_convert_kvec(&xdrbuf->tail[0], seg, n, nsegs);
 		if (n == nsegs)
-			/* Tail remains, but we're out of segments */
 			return -EIO;
-		seg[n].mr_page = NULL;
-		seg[n].mr_offset = xdrbuf->tail[0].iov_base;
-		seg[n].mr_len = xdrbuf->tail[0].iov_len;
-		++n;
 	}
 
 	return n;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
