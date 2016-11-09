From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 14/14] xprtrdma: Update documenting comment
Date: Wed, 09 Nov 2016 14:06:44 -0500
Message-ID: <20161109190644.15007.90538.stgit@manet.1015granger.net>
References: <20161109184735.15007.96507.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109184735.15007.96507.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: If reset fails, FRMRs are no longer abandoned, rather
they are released immediately. Update the comment to reflect this.

Fixes: 2ffc871a574d ('xprtrdma: Release orphaned MRs immediately')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 900dc40..47bed53 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -171,10 +171,6 @@
 }
 
 /* Reset of a single FRMR. Generate a fresh rkey by replacing the MR.
- *
- * There's no recovery if this fails. The FRMR is abandoned, but
- * remains in rb_all. It will be cleaned up when the transport is
- * destroyed.
  */
 static void
 frwr_op_recover_mr(struct rpcrdma_mw *mw)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
