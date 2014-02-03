From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/8] SUNRPC: remove KERN_INFO from dprintk() call sites
Date: Mon, 03 Feb 2014 16:02:15 -0500
Message-ID: <20140203210215.3533.98794.stgit@manet.1015granger.net>
References: <20140203205903.3533.39213.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140203205903.3533.39213.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The use of KERN_INFO causes garbage characters to appear when
debugging is enabled.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/transport.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 285dc08..1eb9c46 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -733,7 +733,7 @@ static void __exit xprt_rdma_cleanup(void)
 {
 	int rc;
 
-	dprintk(KERN_INFO "RPCRDMA Module Removed, deregister RPC RDMA transport\n");
+	dprintk("RPCRDMA Module Removed, deregister RPC RDMA transport\n");
 #ifdef RPC_DEBUG
 	if (sunrpc_table_header) {
 		unregister_sysctl_table(sunrpc_table_header);
@@ -755,14 +755,14 @@ static int __init xprt_rdma_init(void)
 	if (rc)
 		return rc;
 
-	dprintk(KERN_INFO "RPCRDMA Module Init, register RPC RDMA transport\n");
+	dprintk("RPCRDMA Module Init, register RPC RDMA transport\n");
 
-	dprintk(KERN_INFO "Defaults:\n");
-	dprintk(KERN_INFO "\tSlots %d\n"
+	dprintk("Defaults:\n");
+	dprintk("\tSlots %d\n"
 		"\tMaxInlineRead %d\n\tMaxInlineWrite %d\n",
 		xprt_rdma_slot_table_entries,
 		xprt_rdma_max_inline_read, xprt_rdma_max_inline_write);
-	dprintk(KERN_INFO "\tPadding %d\n\tMemreg %d\n",
+	dprintk("\tPadding %d\n\tMemreg %d\n",
 		xprt_rdma_inline_write_padding, xprt_rdma_memreg_strategy);
 
 #ifdef RPC_DEBUG

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
