From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 03/11] xprtrdma: Clean up dprintk format string
 containing a newline
Date: Fri, 04 Mar 2016 11:27:43 -0500
Message-ID: <20160304162743.13590.23268.stgit@oracle120-ib.cthon.org>
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

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 0f28f2d..e9dfd6a 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -809,10 +809,8 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	 */
 	list_del_init(&rqst->rq_list);
 	spin_unlock_bh(&xprt->transport_lock);
-	dprintk("RPC:       %s: reply 0x%p completes request 0x%p\n"
-		"                   RPC request 0x%p xid 0x%08x\n",
-			__func__, rep, req, rqst,
-			be32_to_cpu(headerp->rm_xid));
+	dprintk("RPC:       %s: reply %p completes request %p (xid 0x%08x)\n",
+		__func__, rep, req, be32_to_cpu(headerp->rm_xid));
 
 	/* from here on, the reply is no longer an orphan */
 	req->rl_reply = rep;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
