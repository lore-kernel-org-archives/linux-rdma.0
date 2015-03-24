From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/15] SUNRPC: Introduce missing well-known netids
Date: Tue, 24 Mar 2015 16:30:38 -0400
Message-ID: <20150324203038.2311.6629.stgit@manet.1015granger.net>
References: <20150324201849.2311.53599.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150324201849.2311.53599.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/msg_prot.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/msg_prot.h b/include/linux/sunrpc/msg_prot.h
index aadc6a0..8073713 100644
--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -142,12 +142,18 @@ typedef __be32	rpc_fraghdr;
 	(RPC_REPHDRSIZE + (2 + RPC_MAX_AUTH_SIZE/4))
 
 /*
- * RFC1833/RFC3530 rpcbind (v3+) well-known netid's.
+ * Well-known netids. See:
+ *
+ *   http://www.iana.org/assignments/rpc-netids/rpc-netids.xhtml
  */
 #define RPCBIND_NETID_UDP	"udp"
 #define RPCBIND_NETID_TCP	"tcp"
+#define RPCBIND_NETID_RDMA	"rdma"
+#define RPCBIND_NETID_SCTP	"sctp"
 #define RPCBIND_NETID_UDP6	"udp6"
 #define RPCBIND_NETID_TCP6	"tcp6"
+#define RPCBIND_NETID_RDMA6	"rdma6"
+#define RPCBIND_NETID_SCTP6	"sctp6"
 #define RPCBIND_NETID_LOCAL	"local"
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
