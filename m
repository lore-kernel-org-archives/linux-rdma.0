From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 19/22] xprtrdma: Support larger inline thresholds
Date: Tue, 23 Aug 2016 13:54:38 -0400
Message-ID: <20160823175438.13038.1624.stgit@manet.1015granger.net>
References: <20160823174402.13038.84561.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823174402.13038.84561.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RPC-over-RDMA Version Two will likely require at least a 4KB inline
threshold by default. The Version One inline threshold is still 1KB,
and it's automatically negotiated down to in
rpcrdma_update_connect_private.

The maximum is somewhat arbitrary. There's no fundamental
architectural limit I'm aware of, but it's good to keep the size of
Receive buffers reasonable. Now that Send can use a s/g list, a
Send buffer is only as large as each RPC requires. Receive buffers
are always the size of the inline threshold, however.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/xprtrdma.h |    4 ++--
 net/sunrpc/xprtrdma/transport.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
index 39267dc..221b7a2 100644
--- a/include/linux/sunrpc/xprtrdma.h
+++ b/include/linux/sunrpc/xprtrdma.h
@@ -53,8 +53,8 @@
 #define RPCRDMA_MAX_SLOT_TABLE	(256U)
 
 #define RPCRDMA_MIN_INLINE  (1024)	/* min inline thresh */
-#define RPCRDMA_DEF_INLINE  (1024)	/* default inline thresh */
-#define RPCRDMA_MAX_INLINE  (3068)	/* max inline thresh */
+#define RPCRDMA_DEF_INLINE  (4096)	/* default inline thresh */
+#define RPCRDMA_MAX_INLINE  (65536)	/* max inline thresh */
 
 /* Memory registration strategies, by number.
  * This is part of a kernel / user space API. Do not remove. */
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 6a358ab..ed5e285 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -97,7 +97,7 @@ static struct ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_max_inline_read,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_inline_size,
 		.extra2		= &max_inline_size,
 	},
@@ -106,7 +106,7 @@ static struct ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_max_inline_write,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_inline_size,
 		.extra2		= &max_inline_size,
 	},

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
