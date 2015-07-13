From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/14] xprtrdma: Increase default credit limit
Date: Mon, 13 Jul 2015 12:30:10 -0400
Message-ID: <20150713163010.17630.18221.stgit@manet.1015granger.net>
References: <20150713160617.17630.97475.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150713160617.17630.97475.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In preparation for similar increases on NFS/RDMA servers, bump the
advertised credit limit for RPC/RDMA to 128. This allocates some
extra resources, but the client will continue to allow only the
number of RPCs in flight that the server requests via its advertised
credit limit.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-By: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/sunrpc/xprtrdma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
index b176130..b7b279b 100644
--- a/include/linux/sunrpc/xprtrdma.h
+++ b/include/linux/sunrpc/xprtrdma.h
@@ -49,7 +49,7 @@
  * a single chunk type per message is supported currently.
  */
 #define RPCRDMA_MIN_SLOT_TABLE	(2U)
-#define RPCRDMA_DEF_SLOT_TABLE	(32U)
+#define RPCRDMA_DEF_SLOT_TABLE	(128U)
 #define RPCRDMA_MAX_SLOT_TABLE	(256U)
 
 #define RPCRDMA_DEF_INLINE  (1024)	/* default inline max */

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
