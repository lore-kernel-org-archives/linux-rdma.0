From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 09/17] xprtrdma: mount reports "Invalid mount option" if
	memreg mode not supported
Date: Mon, 21 Apr 2014 18:02:05 -0400
Message-ID: <20140421220205.12569.42838.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the selected memory registration mode is not supported by the
underlying provider/HCA, the NFS mount command reports that there was
an invalid mount option, and fails. This is misleading.

Reporting a problem allocating memory is a lot closer to the truth.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/verbs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a352798..35dcd10 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -513,7 +513,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 #if RPCRDMA_PERSISTENT_REGISTRATION
 			memreg = RPCRDMA_ALLPHYSICAL;
 #else
-			rc = -EINVAL;
+			rc = -ENOMEM;
 			goto out2;
 #endif
 		}
@@ -556,7 +556,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	default:
 		printk(KERN_ERR "%s: invalid memory registration mode %d\n",
 				__func__, memreg);
-		rc = -EINVAL;
+		rc = -ENOMEM;
 		goto out2;
 	}
 	dprintk("RPC:       %s: memory registration strategy is %d\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
