From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 07/12] xprtrdma: Don't provide a reply chunk when
 expecting a short reply
Date: Thu, 09 Jul 2015 16:42:46 -0400
Message-ID: <20150709204246.26247.10367.stgit@manet.1015granger.net>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709203242.26247.4848.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently Linux always offers a reply chunk, even for small replies
(unless a read or write list is needed for the RPC operation).

A comment in rpcrdma_marshal_req() reads:

> Currently we try to not actually use read inline.
> Reply chunks have the desirable property that
> they land, packed, directly in the target buffers
> without headers, so they require no fixup. The
> additional RDMA Write op sends the same amount
> of data, streams on-the-wire and adds no overhead
> on receive. Therefore, we request a reply chunk
> for non-writes wherever feasible and efficient.

This considers only the network bandwidth cost of sending the RPC
reply. For replies which are only a few dozen bytes, this is
typically not a good trade-off.

If the server chooses to return the reply inline:

 - The client has registered and invalidated a memory region to
   catch the reply, which is then not used

If the server chooses to use the reply chunk:

 - The server sends a few bytes using a heavyweight RDMA WRITE for
   operation. The entire RPC reply is conveyed in two RDMA
   operations (WRITE_ONLY, SEND) instead of one.

Note that both the server and client have to prepare or copy the
reply data anyway to construct these replies. There's no benefit to
using an RDMA transfer since the host CPU has to be involved.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e569da4..8ac1448c 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -429,7 +429,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 	 *
 	 * o Read ops return data as write chunk(s), header as inline.
 	 * o If the expected result is under the inline threshold, all ops
-	 *   return as inline (but see later).
+	 *   return as inline.
 	 * o Large non-read ops return as a single reply chunk.
 	 */
 	if (rqst->rq_rcv_buf.flags & XDRBUF_READ)
@@ -503,18 +503,6 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 			headerp->rm_body.rm_nochunks.rm_empty[2] = xdr_zero;
 			/* new length after pullup */
 			rpclen = rqst->rq_svec[0].iov_len;
-			/*
-			 * Currently we try to not actually use read inline.
-			 * Reply chunks have the desirable property that
-			 * they land, packed, directly in the target buffers
-			 * without headers, so they require no fixup. The
-			 * additional RDMA Write op sends the same amount
-			 * of data, streams on-the-wire and adds no overhead
-			 * on receive. Therefore, we request a reply chunk
-			 * for non-writes wherever feasible and efficient.
-			 */
-			if (wtype == rpcrdma_noch)
-				wtype = rpcrdma_replych;
 		}
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
