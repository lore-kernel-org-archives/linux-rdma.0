From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 04/14] xprtrdma: Don't fall back to PHYSICAL memory
 registration
Date: Mon, 13 Jul 2015 12:30:19 -0400
Message-ID: <20150713163019.17630.91612.stgit@manet.1015granger.net>
References: <20150713160617.17630.97475.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150713160617.17630.97475.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

PHYSICAL memory registration uses a single rkey for all of the
client's memory, thus is insecure. It is still useful in some cases
for testing.

Retain the ability to select PHYSICAL memory registration capability
via /proc/sys/sunrpc/rdma_memreg_strategy, but don't fall back to it
if the HCA does not support FRWR or FMR.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 891c4ed..1065808 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -539,7 +539,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		if (!ia->ri_device->alloc_fmr) {
 			dprintk("RPC:       %s: MTHCAFMR registration "
 				"not supported by HCA\n", __func__);
-			memreg = RPCRDMA_ALLPHYSICAL;
+			goto out3;
 		}
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
