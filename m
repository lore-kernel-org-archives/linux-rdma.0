From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 12/12] xprtrdma: Fix documenting comments in frwr_ops.c
Date: Tue, 23 May 2017 10:55:15 -0400
Message-ID: <20170523145515.961.4917.stgit@manet.1015granger.net>
References: <20170523142629.961.81233.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523142629.961.81233.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

FASTREG and LOCAL_INV WRs are typically not signaled. localinv_wake
is used for the last LOCAL_INV WR in a chain, which is always
signaled. The documenting comments should reflect that.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 8f63d38..6aea36a 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -277,7 +277,7 @@
 }
 
 /**
- * frwr_wc_fastreg - Invoked by RDMA provider for each polled FastReg WC
+ * frwr_wc_fastreg - Invoked by RDMA provider for a flushed FastReg WC
  * @cq:	completion queue (ignored)
  * @wc:	completed WR
  *
@@ -298,7 +298,7 @@
 }
 
 /**
- * frwr_wc_localinv - Invoked by RDMA provider for each polled LocalInv WC
+ * frwr_wc_localinv - Invoked by RDMA provider for a flushed LocalInv WC
  * @cq:	completion queue (ignored)
  * @wc:	completed WR
  *
@@ -319,7 +319,7 @@
 }
 
 /**
- * frwr_wc_localinv - Invoked by RDMA provider for each polled LocalInv WC
+ * frwr_wc_localinv_wake - Invoked by RDMA provider for a signaled LocalInv WC
  * @cq:	completion queue (ignored)
  * @wc:	completed WR
  *

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
