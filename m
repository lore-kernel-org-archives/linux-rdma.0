From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/20] sunrpc: Update RPCBIND_MAXNETIDLEN
Date: Mon, 02 May 2016 14:40:31 -0400
Message-ID: <20160502184031.10798.63289.stgit@manet.1015granger.net>
References: <20160502183144.10798.99847.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502183144.10798.99847.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 176e21ee2ec8 ("SUNRPC: Support for RPC over AF_LOCAL
transports") added a 5-character netid, but did not bump
RPCBIND_MAXNETIDLEN from 4 to 5.

Fixes: 176e21ee2ec8 ("SUNRPC: Support for RPC over AF_LOCAL ...")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/msg_prot.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/msg_prot.h b/include/linux/sunrpc/msg_prot.h
index 8073713..59cbf16 100644
--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -158,9 +158,9 @@ typedef __be32	rpc_fraghdr;
 
 /*
  * Note that RFC 1833 does not put any size restrictions on the
- * netid string, but all currently defined netid's fit in 4 bytes.
+ * netid string, but all currently defined netid's fit in 5 bytes.
  */
-#define RPCBIND_MAXNETIDLEN	(4u)
+#define RPCBIND_MAXNETIDLEN	(5u)
 
 /*
  * Universal addresses are introduced in RFC 1833 and further spelled

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
