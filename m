From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] svcrdma: Do not send XDR roundup bytes for a write chunk
Date: Fri, 16 Oct 2015 09:30:15 -0400
Message-ID: <20151016132938.8597.65237.stgit@oracle-120.nfsv4bat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Minor optimization: when dealing with write chunk XDR roundup, do
not post a Write WR for the zero bytes in the pad. Simply update
the write segment in the RPC-over-RDMA header to reflect the extra
pad bytes.

The Reply chunk is also a write chunk, but the server does not use
send_write_chunks() to send the Reply chunk. That's OK in this case:
the server Upper Layer typically marshals the Reply chunk contents
in a single contiguous buffer, without a separate tail for the XDR
pad.

The comments and the variable naming refer to "chunks" but what is
really meant is "segments." The existing code sends only one
xdr_write_chunk per RPC reply.

The fix assumes this as well. When the XDR pad in the first write
chunk is reached, the assumption is the Write list is complete and
send_write_chunks() returns.

That will remain a valid assumption until the server Upper Layer can
support multiple bulk payload results per RPC.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 1dfae83..6c48901 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -342,6 +342,13 @@ static int send_write_chunks(struct svcxprt_rdma *xprt,
 						arg_ch->rs_handle,
 						arg_ch->rs_offset,
 						write_len);
+
+		/* Do not send XDR pad bytes */
+		if (chunk_no && write_len < 4) {
+			chunk_no++;
+			break;
+		}
+
 		chunk_off = 0;
 		while (write_len) {
 			ret = send_write(xprt, rqstp,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
