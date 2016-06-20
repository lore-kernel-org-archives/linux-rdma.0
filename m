From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 23/25] svc: Avoid garbage replies when pc_func() returns
 rpc_drop_reply
Date: Mon, 20 Jun 2016 12:11:43 -0400
Message-ID: <20160620161143.10809.2958.stgit@manet.1015granger.net>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620155751.10809.22262.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If an RPC program does not set vs_dispatch and pc_func() returns
rpc_drop_reply, the server sends a reply anyway containing a single
word containing the value RPC_DROP_REPLY (in network byte-order, of
course). This is a nonsense RPC message.

Fixes: 9e701c610923 ("svcrpc: simpler request dropping")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/svc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index cc98528..87290a5 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1188,7 +1188,8 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 		*statp = procp->pc_func(rqstp, rqstp->rq_argp, rqstp->rq_resp);
 
 		/* Encode reply */
-		if (test_bit(RQ_DROPME, &rqstp->rq_flags)) {
+		if (*statp == rpc_drop_reply ||
+		    test_bit(RQ_DROPME, &rqstp->rq_flags)) {
 			if (procp->pc_release)
 				procp->pc_release(rqstp, NULL, rqstp->rq_resp);
 			goto dropit;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
