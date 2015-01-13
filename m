From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/20] xprtrdma: Display XIDs in host byte order
Date: Tue, 13 Jan 2015 11:25:08 -0500
Message-ID: <20150113162508.14086.72232.stgit@manet.1015granger.net>
References: <20150113161440.14086.24801.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113161440.14086.24801.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

xprtsock.c and the backchannel code display XIDs in host byte order.
Follow suit in xprtrdma.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index a6fb30b..150dd76 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -766,7 +766,8 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		spin_unlock(&xprt->transport_lock);
 		dprintk("RPC:       %s: reply 0x%p failed "
 			"to match any request xid 0x%08x len %d\n",
-			__func__, rep, headerp->rm_xid, rep->rr_len);
+			__func__, rep, be32_to_cpu(headerp->rm_xid),
+			rep->rr_len);
 repost:
 		r_xprt->rx_stats.bad_reply_count++;
 		rep->rr_func = rpcrdma_reply_handler;
@@ -782,13 +783,14 @@ repost:
 		spin_unlock(&xprt->transport_lock);
 		dprintk("RPC:       %s: duplicate reply 0x%p to RPC "
 			"request 0x%p: xid 0x%08x\n", __func__, rep, req,
-			headerp->rm_xid);
+			be32_to_cpu(headerp->rm_xid));
 		goto repost;
 	}
 
 	dprintk("RPC:       %s: reply 0x%p completes request 0x%p\n"
 		"                   RPC request 0x%p xid 0x%08x\n",
-			__func__, rep, req, rqst, headerp->rm_xid);
+			__func__, rep, req, rqst,
+			be32_to_cpu(headerp->rm_xid));
 
 	/* from here on, the reply is no longer an orphan */
 	req->rl_reply = rep;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
