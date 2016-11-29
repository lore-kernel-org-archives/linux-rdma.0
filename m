From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 11/12] xprtrdma: Update dprintk in rpcrdma_count_chunks
Date: Tue, 29 Nov 2016 10:53:29 -0500
Message-ID: <20161129155329.23061.92044.stgit@manet.1015granger.net>
References: <20161129154845.23061.29385.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129154845.23061.29385.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: offset and handle should be zero-filled, just like in the
chunk encoders.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index d987c2d..01f5cbc 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -786,7 +786,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 		ifdebug(FACILITY) {
 			u64 off;
 			xdr_decode_hyper((__be32 *)&seg->rs_offset, &off);
-			dprintk("RPC:       %s: chunk %d@0x%llx:0x%x\n",
+			dprintk("RPC:       %s: chunk %d@0x%016llx:0x%08x\n",
 				__func__,
 				be32_to_cpu(seg->rs_length),
 				(unsigned long long)off,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
