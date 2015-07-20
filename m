From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 10/15] xprtrdma: Don't provide a reply chunk when
 expecting a short reply
Date: Mon, 20 Jul 2015 15:03:58 -0400
Message-ID: <20150720190358.10997.15596.stgit@manet.1015granger.net>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720185624.10997.51574.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently Linux always offers a reply chunk, even when the reply
can be sent inline (ie. is smaller than 1KB).

On the client, registering a memory region can be expensive. A
server may choose not to use the reply chunk, wasting the cost of
the registration.

This is a change only for RPC replies smaller than 1KB which the
server constructs in the RPC reply send buffer. Because the elements
of the reply must be XDR encoded, a copy-free data transfer has no
benefit in this case.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e7cf976..62150ae 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -420,7 +420,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 	 *
 	 * o Read ops return data as write chunk(s), header as inline.
 	 * o If the expected result is under the inline threshold, all ops
-	 *   return as inline (but see later).
+	 *   return as inline.
 	 * o Large non-read ops return as a single reply chunk.
 	 */
 	if (rqst->rq_rcv_buf.flags & XDRBUF_READ)
@@ -476,17 +476,6 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 		headerp->rm_body.rm_nochunks.rm_empty[2] = xdr_zero;
 		/* new length after pullup */
 		rpclen = rqst->rq_svec[0].iov_len;
-		/* Currently we try to not actually use read inline.
-		 * Reply chunks have the desirable property that
-		 * they land, packed, directly in the target buffers
-		 * without headers, so they require no fixup. The
-		 * additional RDMA Write op sends the same amount
-		 * of data, streams on-the-wire and adds no overhead
-		 * on receive. Therefore, we request a reply chunk
-		 * for non-writes wherever feasible and efficient.
-		 */
-		if (wtype == rpcrdma_noch)
-			wtype = rpcrdma_replych;
 	}
 
 	if (rtype != rpcrdma_noch) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
