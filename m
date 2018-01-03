From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] xprtrdma: Correct some documenting comments
Date: Wed, 03 Jan 2018 15:38:17 -0500
Message-ID: <20180103203817.29209.49686.stgit@manet.1015granger.net>
References: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103203540.29209.4620.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix kernel-doc warnings in net/sunrpc/xprtrdma/ .

net/sunrpc/xprtrdma/verbs.c:1575: warning: No description found for parameter 'count'
net/sunrpc/xprtrdma/verbs.c:1575: warning: Excess function parameter 'min_reqs' description in 'rpcrdma_ep_post_extra_recv'

net/sunrpc/xprtrdma/backchannel.c:288: warning: No description found for parameter 'r_xprt'
net/sunrpc/xprtrdma/backchannel.c:288: warning: Excess function parameter 'xprt' description in 'rpcrdma_bc_receive_call'

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index ca0c5d3..ed1a4a3 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -294,7 +294,7 @@ void xprt_rdma_bc_free_rqst(struct rpc_rqst *rqst)
 
 /**
  * rpcrdma_bc_receive_call - Handle a backward direction call
- * @xprt: transport receiving the call
+ * @r_xprt: transport receiving the call
  * @rep: receive buffer containing the call
  *
  * Operational assumptions:
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 57e1139..f4eb63e 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1584,7 +1584,7 @@ struct rpcrdma_regbuf *
 /**
  * rpcrdma_ep_post_extra_recv - Post buffers for incoming backchannel requests
  * @r_xprt: transport associated with these backchannel resources
- * @min_reqs: minimum number of incoming requests expected
+ * @count: minimum number of incoming requests expected
  *
  * Returns zero if all requested buffers were posted, or a negative errno.
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
