From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 02/12] xprtrdma: Clean up unused
 RPCRDMA_INLINE_PAD_THRESH macro
Date: Thu, 18 Feb 2016 12:30:11 -0500
Message-ID: <20160218173011.14009.4267.stgit@manet.1015granger.net>
References: <20160218172449.14009.47311.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218172449.14009.47311.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: b3221d6a53c4 ('xprtrdma: Remove logic that constructs...')
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/xprtrdma.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
index b7b279b..767190b 100644
--- a/include/linux/sunrpc/xprtrdma.h
+++ b/include/linux/sunrpc/xprtrdma.h
@@ -54,8 +54,6 @@
 
 #define RPCRDMA_DEF_INLINE  (1024)	/* default inline max */
 
-#define RPCRDMA_INLINE_PAD_THRESH  (512)/* payload threshold to pad (bytes) */
-
 /* Memory registration strategies, by number.
  * This is part of a kernel / user space API. Do not remove. */
 enum rpcrdma_memreg {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
