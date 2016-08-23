From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 15/22] rpcrdma: RDMA/CM private message data structure
Date: Tue, 23 Aug 2016 13:54:06 -0400
Message-ID: <20160823175406.13038.79913.stgit@manet.1015granger.net>
References: <20160823174402.13038.84561.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823174402.13038.84561.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce data structure used by both client and server to exchange
implementation details during RDMA/CM connection establishment.

This is an experimental out-of-band exchange between Linux
RPC-over-RDMA Version One implementations, replacing the deprecated
CCP (see RFC 5666bis). The purpose of this extension is to enable
prototyping of features that might be introduced in a subsequent
version of RPC-over-RDMA.

Suggested by Christoph Hellwig and Devesh Sharma.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/linux/sunrpc/rpc_rdma.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
index 3b1ff38..a7da6bf 100644
--- a/include/linux/sunrpc/rpc_rdma.h
+++ b/include/linux/sunrpc/rpc_rdma.h
@@ -41,6 +41,7 @@
 #define _LINUX_SUNRPC_RPC_RDMA_H
 
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #define RPCRDMA_VERSION		1
 #define rpcrdma_version		cpu_to_be32(RPCRDMA_VERSION)
@@ -129,4 +130,38 @@ enum rpcrdma_proc {
 #define rdma_done	cpu_to_be32(RDMA_DONE)
 #define rdma_error	cpu_to_be32(RDMA_ERROR)
 
+/*
+ * Private extension to RPC-over-RDMA Version One.
+ * Message passed during RDMA-CM connection set-up.
+ *
+ * Add new fields at the end, and don't permute existing
+ * fields.
+ */
+struct rpcrdma_connect_private {
+	__be32			cp_magic;
+	u8			cp_version;
+	u8			cp_flags;
+	u8			cp_send_size;
+	u8			cp_recv_size;
+} __packed;
+
+#define rpcrdma_cmp_magic	__cpu_to_be32(0xf6ab0e18)
+
+enum {
+	RPCRDMA_CMP_VERSION		= 1,
+	RPCRDMA_CMP_F_SND_W_INV_OK	= BIT(0),
+};
+
+static inline u8
+rpcrdma_encode_buffer_size(unsigned int size)
+{
+	return (size >> 10) - 1;
+}
+
+static inline unsigned int
+rpcrdma_decode_buffer_size(u8 val)
+{
+	return ((unsigned int)val + 1) << 10;
+}
+
 #endif				/* _LINUX_SUNRPC_RPC_RDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
