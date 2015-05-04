From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned IB objects
Date: Mon, 04 May 2015 13:57:00 -0400
Message-ID: <20150504175700.3483.57728.stgit@manet.1015granger.net>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504174626.3483.97639.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Print an error during transport destruction if ib_dealloc_pd()
fails. This is a sign that xprtrdma orphaned one or more RDMA API
objects at some point, which can pin lower layer kernel modules
and cause shutdown to hang.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 4870d27..0cc4617 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -710,8 +710,8 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
 	}
 	if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
 		rc = ib_dealloc_pd(ia->ri_pd);
-		dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
-			__func__, rc);
+		if (rc)
+			pr_warn("rpcrdma: ib_dealloc_pd status %i\n", rc);
 	}
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
