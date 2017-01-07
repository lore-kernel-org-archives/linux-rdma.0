From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 12/22] svcrdma: Reduce size of sge array in struct
 svc_rdma_op_ctxt
Date: Sat, 07 Jan 2017 12:16:54 -0500
Message-ID: <20170107171654.14126.78088.stgit@klimt.1015granger.net>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170107170258.14126.8503.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The sge array in struct svc_rdma_op_ctxt is no longer used for
sending RDMA Write WRs. It need only accomodate the construction of
Send and Receive WRs. The maximum inline size is the largest payload
it needs to handle now.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h |    9 +++++++--
 net/sunrpc/xprtrdma/svc_rdma.c  |    6 +++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 65c2425..538a220 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -48,6 +48,12 @@
 #include <rdma/rdma_cm.h>
 #define SVCRDMA_DEBUG
 
+/* Default and maximum inline threshold sizes */
+enum {
+	RPCRDMA_DEF_REQ_SIZE = 4096,
+	RPCRDMA_MAX_REQ_SIZE = 65536
+};
+
 /* RPC/RDMA parameters and stats */
 extern unsigned int svcrdma_ord;
 extern unsigned int svcrdma_max_requests;
@@ -86,7 +92,7 @@ struct svc_rdma_op_ctxt {
 	int count;
 	unsigned int mapped_sges;
 	struct ib_send_wr send_wr;
-	struct ib_sge sge[RPCSVC_MAXPAGES];
+	struct ib_sge sge[1 + RPCRDMA_MAX_REQ_SIZE / PAGE_SIZE];
 	struct page *pages[RPCSVC_MAXPAGES];
 };
 
@@ -188,7 +194,6 @@ struct svcxprt_rdma {
  * page size of 4k, or 32k * 2 ops / 4k = 16 outstanding RDMA_READ.  */
 #define RPCRDMA_ORD             (64/4)
 #define RPCRDMA_MAX_REQUESTS    32
-#define RPCRDMA_MAX_REQ_SIZE    4096
 
 /* Typical ULP usage of BC requests is NFSv4.1 backchannel. Our
  * current NFSv4.1 implementation supports one backchannel slot.
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 9124441..1f9f408 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -58,9 +58,9 @@
 unsigned int svcrdma_max_bc_requests = RPCRDMA_MAX_BC_REQUESTS;
 static unsigned int min_max_requests = 4;
 static unsigned int max_max_requests = 16384;
-unsigned int svcrdma_max_req_size = RPCRDMA_MAX_REQ_SIZE;
-static unsigned int min_max_inline = 4096;
-static unsigned int max_max_inline = 65536;
+unsigned int svcrdma_max_req_size = RPCRDMA_DEF_REQ_SIZE;
+static unsigned int min_max_inline = RPCRDMA_DEF_REQ_SIZE;
+static unsigned int max_max_inline = RPCRDMA_MAX_REQ_SIZE;
 
 atomic_t rdma_stat_recv;
 atomic_t rdma_stat_read;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
