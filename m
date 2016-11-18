From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/12] xprtrdma: Squelch "max send,
 max recv" messages at connect time
Date: Fri, 18 Nov 2016 10:00:08 -0500
Message-ID: <20161118150008.10592.96160.stgit@manet.1015granger.net>
References: <20161118145547.10592.66470.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118145547.10592.66470.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: This message was intended to be a dprintk, as it is on the
server-side.

Fixes: 87cfb9a0c85c ('xprtrdma: Client-side support for ...')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index cbb1885..9f66fd8 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -223,8 +223,8 @@
 		cdata->inline_rsize = rsize;
 	if (wsize < cdata->inline_wsize)
 		cdata->inline_wsize = wsize;
-	pr_info("rpcrdma: max send %u, max recv %u\n",
-		cdata->inline_wsize, cdata->inline_rsize);
+	dprintk("RPC:       %s: max send %u, max recv %u\n",
+		__func__, cdata->inline_wsize, cdata->inline_rsize);
 	rpcrdma_set_max_header_sizes(r_xprt);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
