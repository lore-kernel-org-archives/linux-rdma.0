From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 12/18] SUNRPC: Remove the TCP-only restriction in
 bc_svc_process()
Date: Thu, 17 Sep 2015 16:45:49 -0400
Message-ID: <20150917204549.19671.26366.stgit@manet.1015granger.net>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917202829.19671.90044.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow the use of other transport classes when handling a backward
direction RPC call.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/svc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index a8f579d..bc5b7b5 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1367,11 +1367,6 @@ bc_svc_process(struct svc_serv *serv, struct rpc_rqst *req,
 	/* reset result send buffer "put" position */
 	resv->iov_len = 0;
 
-	if (rqstp->rq_prot != IPPROTO_TCP) {
-		printk(KERN_ERR "No support for Non-TCP transports!\n");
-		BUG();
-	}
-
 	/*
 	 * Skip the next two words because they've already been
 	 * processed in the transport

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
