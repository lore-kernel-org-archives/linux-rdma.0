From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 07/12] rpcrdma: Add RPCRDMA_HDRLEN_ERR
Date: Thu, 18 Feb 2016 12:30:51 -0500
Message-ID: <20160218173051.14009.58818.stgit@manet.1015granger.net>
References: <20160218172449.14009.47311.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218172449.14009.47311.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Error headers are shorter than either RDMA_MSG or RDMA_NOMSG.

Since HDRLEN_MIN is already used in several other places that would
be annoying to change, add RPCRDMA_HDRLEN_ERR for the one or two
spots where the shorter length is needed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 include/linux/sunrpc/rpc_rdma.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
index f33c5a4..8c6d23c 100644
--- a/include/linux/sunrpc/rpc_rdma.h
+++ b/include/linux/sunrpc/rpc_rdma.h
@@ -102,6 +102,7 @@ struct rpcrdma_msg {
  * Smallest RPC/RDMA header: rm_xid through rm_type, then rm_nochunks
  */
 #define RPCRDMA_HDRLEN_MIN	(sizeof(__be32) * 7)
+#define RPCRDMA_HDRLEN_ERR	(sizeof(__be32) * 5)
 
 enum rpcrdma_errcode {
 	ERR_VERS = 1,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
