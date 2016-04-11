From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 06/18] xprtrdma: Update comments in rpcrdma_marshal_req()
Date: Mon, 11 Apr 2016 16:10:58 -0400
Message-ID: <20160411201058.20531.98867.stgit@manet.1015granger.net>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411200323.20531.8893.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update documenting comments to reflect code changes over the past
year.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 0105e65..c7c9bbb 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -494,13 +494,10 @@ static void rpcrdma_inline_pullup(struct rpc_rqst *rqst)
  * Marshal a request: the primary job of this routine is to choose
  * the transfer modes. See comments below.
  *
- * Uses multiple RDMA IOVs for a request:
- *  [0] -- RPC RDMA header, which uses memory from the *start* of the
- *         preregistered buffer that already holds the RPC data in
- *         its middle.
- *  [1] -- the RPC header/data, marshaled by RPC and the NFS protocol.
- *  [2] -- optional padding.
- *  [3] -- if padded, header only in [1] and data here.
+ * Prepares up to two IOVs per Call message:
+ *
+ *  [0] -- RPC RDMA header
+ *  [1] -- the RPC header/data
  *
  * Returns zero on success, otherwise a negative errno.
  */
@@ -624,13 +621,6 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 		__func__, transfertypes[wtype], hdrlen, rpclen,
 		headerp, base, rdmab_lkey(req->rl_rdmabuf));
 
-	/*
-	 * initialize send_iov's - normally only two: rdma chunk header and
-	 * single preregistered RPC header buffer, but if padding is present,
-	 * then use a preregistered (and zeroed) pad buffer between the RPC
-	 * header and any write data. In all non-rdma cases, any following
-	 * data has been copied into the RPC header buffer.
-	 */
 	req->rl_send_iov[0].addr = rdmab_addr(req->rl_rdmabuf);
 	req->rl_send_iov[0].length = hdrlen;
 	req->rl_send_iov[0].lkey = rdmab_lkey(req->rl_rdmabuf);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
