From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 19/24] xprtrdma: Do not update {head,
 tail}.iov_len in rpcrdma_inline_fixup()
Date: Wed, 29 Jun 2016 13:54:41 -0400
Message-ID: <20160629175441.15094.64143.stgit@manet.1015granger.net>
References: <20160629173231.15094.52660.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629173231.15094.52660.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While trying NFSv4.0/RDMA with sec=krb5p, I noticed small NFS READ
operations failed. After the client unwrapped the NFS READ reply
message, the NFS READ XDR decoder was not able to decode the reply.
The message was "Server cheating in reply", with the reported
number of received payload bytes being zero. Applications reported
a read(2) that returned -1/EIO.

The problem is rpcrdma_inline_fixup() sets the tail.iov_len to zero
when the incoming reply fits entirely in the head iovec. The zero
tail.iov_len confused xdr_buf_trim(), which then mangled the actual
reply data instead of simply removing the trailing GSS checksum.

As near as I can tell, RPC transports are not supposed to update the
head.iov_len, page_len, or tail.iov_len fields in the receive XDR
buffer when handling an incoming RPC reply message. These fields
contain the length of each component of the XDR buffer, and hence
the maximum number of bytes of reply data that can be stored in each
XDR buffer component. I've concluded this because:

- This is how xdr_partial_copy_from_skb() appears to behave
- rpcrdma_inline_fixup() already does not alter page_len
- call_decode() compares rq_private_buf and rq_rcv_buf and WARNs
   if they are not exactly the same

Unfortunately, as soon as I tried the simple fix to just remove the
line that sets tail.iov_len to zero, I saw that the logic that
appends the implicit Write chunk pad inline depends on inline_fixup
setting tail.iov_len to zero.

To address this, re-organize the tail iovec handling logic to use
the same approach as with the head iovec: simply point tail.iov_base
to the correct bytes in the receive buffer.

While I remember all this, write down the conclusion in documenting
comments.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   61 ++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e3560c2..d018eb7 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -740,8 +740,16 @@ rpcrdma_count_chunks(struct rpcrdma_rep *rep, int wrchunk, __be32 **iptrp)
 	return total_len;
 }
 
-/*
- * Scatter inline received data back into provided iov's.
+/**
+ * rpcrdma_inline_fixup - Scatter inline received data into rqst's iovecs
+ * @rqst: controlling RPC request
+ * @srcp: points to RPC message payload in receive buffer
+ * @copy_len: remaining length of receive buffer content
+ * @pad: Write chunk pad bytes needed (zero for pure inline)
+ *
+ * The upper layer has set the maximum number of bytes it can
+ * receive in each component of rq_rcv_buf. These values are set in
+ * the head.iov_len, page_len, tail.iov_len, and buflen fields.
  */
 static void
 rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
@@ -751,17 +759,19 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 	struct page **ppages;
 	int page_base;
 
+	/* The head iovec is redirected to the RPC reply message
+	 * in the receive buffer, to avoid a memcopy.
+	 */
+	rqst->rq_rcv_buf.head[0].iov_base = srcp;
+
+	/* The contents of the receive buffer that follow
+	 * head.iov_len bytes are copied into the page list.
+	 */
 	curlen = rqst->rq_rcv_buf.head[0].iov_len;
-	if (curlen > copy_len) {	/* write chunk header fixup */
+	if (curlen > copy_len)
 		curlen = copy_len;
-		rqst->rq_rcv_buf.head[0].iov_len = curlen;
-	}
-
 	dprintk("RPC:       %s: srcp 0x%p len %d hdrlen %d\n",
 		__func__, srcp, copy_len, curlen);
-
-	/* Shift pointer for first receive segment only */
-	rqst->rq_rcv_buf.head[0].iov_base = srcp;
 	srcp += curlen;
 	copy_len -= curlen;
 
@@ -798,28 +808,23 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 				break;
 			page_base = 0;
 		}
-	}
 
-	if (copy_len && rqst->rq_rcv_buf.tail[0].iov_len) {
-		curlen = copy_len;
-		if (curlen > rqst->rq_rcv_buf.tail[0].iov_len)
-			curlen = rqst->rq_rcv_buf.tail[0].iov_len;
-		if (rqst->rq_rcv_buf.tail[0].iov_base != srcp)
-			memmove(rqst->rq_rcv_buf.tail[0].iov_base, srcp, curlen);
-		dprintk("RPC:       %s: tail srcp 0x%p len %d curlen %d\n",
-			__func__, srcp, copy_len, curlen);
-		rqst->rq_rcv_buf.tail[0].iov_len = curlen;
-		copy_len -= curlen; ++i;
-	} else
-		rqst->rq_rcv_buf.tail[0].iov_len = 0;
-
-	if (pad) {
-		/* implicit padding on terminal chunk */
-		unsigned char *p = rqst->rq_rcv_buf.tail[0].iov_base;
-		while (pad--)
-			p[rqst->rq_rcv_buf.tail[0].iov_len++] = 0;
+		/* Implicit padding for the last segment in a Write
+		 * chunk is inserted inline at the front of the tail
+		 * iovec. The upper layer ignores the content of
+		 * the pad. Simply ensure inline content in the tail
+		 * that follows the Write chunk is properly aligned.
+		 */
+		if (pad)
+			srcp -= pad;
 	}
 
+	/* The tail iovec is redirected to the remaining data
+	 * in the receive buffer, to avoid a memcopy.
+	 */
+	if (copy_len || pad)
+		rqst->rq_rcv_buf.tail[0].iov_base = srcp;
+
 	if (copy_len)
 		dprintk("RPC:       %s: %d bytes in"
 			" %d extra segments (%d lost)\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
