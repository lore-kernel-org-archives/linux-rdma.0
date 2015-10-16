From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 09/16] SUNRPC: Abstract backchannel operations
Date: Fri, 16 Oct 2015 09:25:14 -0400
Message-ID: <20151016132514.6819.45488.stgit@oracle-122.nfsv4bat.org>
References: <20151016131958.6819.98407.stgit@oracle-122.nfsv4bat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151016131958.6819.98407.stgit-SEkpj4eus7zuCzdexAEDLOpQh6Td+b7Z@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

xprt_{setup,destroy}_backchannel() won't be adequate for RPC/RMDA
bi-direction. In particular, receive buffers have to be pre-
registered and posted in order to receive incoming backchannel
requests.

Add a virtual function call to allow the insertion of appropriate
backchannel setup and destruction methods for each transport.

In addition, freeing a backchannel request is a little different
for RPC/RDMA. Introduce an rpc_xprt_op to handle the difference.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 include/linux/sunrpc/bc_xprt.h |    5 +++++
 include/linux/sunrpc/xprt.h    |    5 +++++
 net/sunrpc/backchannel_rqst.c  |   24 ++++++++++++++++++++++--
 net/sunrpc/xprtsock.c          |   15 +++++++++++++++
 4 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/bc_xprt.h b/include/linux/sunrpc/bc_xprt.h
index 8df43c9f..4397a48 100644
--- a/include/linux/sunrpc/bc_xprt.h
+++ b/include/linux/sunrpc/bc_xprt.h
@@ -38,6 +38,11 @@ void xprt_free_bc_request(struct rpc_rqst *req);
 int xprt_setup_backchannel(struct rpc_xprt *, unsigned int min_reqs);
 void xprt_destroy_backchannel(struct rpc_xprt *, unsigned int max_reqs);
 
+/* Socket backchannel transport methods */
+int xprt_setup_bc(struct rpc_xprt *xprt, unsigned int min_reqs);
+void xprt_destroy_bc(struct rpc_xprt *xprt, unsigned int max_reqs);
+void xprt_free_bc_rqst(struct rpc_rqst *req);
+
 /*
  * Determine if a shared backchannel is in use
  */
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 0fb9acb..3f79c4a 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -136,6 +136,11 @@ struct rpc_xprt_ops {
 	int		(*enable_swap)(struct rpc_xprt *xprt);
 	void		(*disable_swap)(struct rpc_xprt *xprt);
 	void		(*inject_disconnect)(struct rpc_xprt *xprt);
+	int		(*bc_setup)(struct rpc_xprt *xprt,
+				    unsigned int min_reqs);
+	void		(*bc_free_rqst)(struct rpc_rqst *rqst);
+	void		(*bc_destroy)(struct rpc_xprt *xprt,
+				      unsigned int max_reqs);
 };
 
 /*
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 6255d14..229956b 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -138,6 +138,14 @@ out_free:
  */
 int xprt_setup_backchannel(struct rpc_xprt *xprt, unsigned int min_reqs)
 {
+	if (!xprt->ops->bc_setup)
+		return 0;
+	return xprt->ops->bc_setup(xprt, min_reqs);
+}
+EXPORT_SYMBOL_GPL(xprt_setup_backchannel);
+
+int xprt_setup_bc(struct rpc_xprt *xprt, unsigned int min_reqs)
+{
 	struct rpc_rqst *req;
 	struct list_head tmp_list;
 	int i;
@@ -192,7 +200,6 @@ out_free:
 	dprintk("RPC:       setup backchannel transport failed\n");
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(xprt_setup_backchannel);
 
 /**
  * xprt_destroy_backchannel - Destroys the backchannel preallocated structures.
@@ -205,6 +212,13 @@ EXPORT_SYMBOL_GPL(xprt_setup_backchannel);
  */
 void xprt_destroy_backchannel(struct rpc_xprt *xprt, unsigned int max_reqs)
 {
+	if (xprt->ops->bc_destroy)
+		xprt->ops->bc_destroy(xprt, max_reqs);
+}
+EXPORT_SYMBOL_GPL(xprt_destroy_backchannel);
+
+void xprt_destroy_bc(struct rpc_xprt *xprt, unsigned int max_reqs)
+{
 	struct rpc_rqst *req = NULL, *tmp = NULL;
 
 	dprintk("RPC:        destroy backchannel transport\n");
@@ -227,7 +241,6 @@ out:
 	dprintk("RPC:        backchannel list empty= %s\n",
 		list_empty(&xprt->bc_pa_list) ? "true" : "false");
 }
-EXPORT_SYMBOL_GPL(xprt_destroy_backchannel);
 
 static struct rpc_rqst *xprt_alloc_bc_request(struct rpc_xprt *xprt, __be32 xid)
 {
@@ -264,6 +277,13 @@ void xprt_free_bc_request(struct rpc_rqst *req)
 {
 	struct rpc_xprt *xprt = req->rq_xprt;
 
+	xprt->ops->bc_free_rqst(req);
+}
+
+void xprt_free_bc_rqst(struct rpc_rqst *req)
+{
+	struct rpc_xprt *xprt = req->rq_xprt;
+
 	dprintk("RPC:       free backchannel req=%p\n", req);
 
 	req->rq_connect_cookie = xprt->connect_cookie - 1;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1a85e0e..3084163 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2539,6 +2539,11 @@ static struct rpc_xprt_ops xs_local_ops = {
 	.print_stats		= xs_local_print_stats,
 	.enable_swap		= xs_enable_swap,
 	.disable_swap		= xs_disable_swap,
+#ifdef CONFIG_SUNRPC_BACKCHANNEL
+	.bc_setup		= xprt_setup_bc,
+	.bc_free_rqst		= xprt_free_bc_rqst,
+	.bc_destroy		= xprt_destroy_bc,
+#endif
 };
 
 static struct rpc_xprt_ops xs_udp_ops = {
@@ -2561,6 +2566,11 @@ static struct rpc_xprt_ops xs_udp_ops = {
 	.enable_swap		= xs_enable_swap,
 	.disable_swap		= xs_disable_swap,
 	.inject_disconnect	= xs_inject_disconnect,
+#ifdef CONFIG_SUNRPC_BACKCHANNEL
+	.bc_setup		= xprt_setup_bc,
+	.bc_free_rqst		= xprt_free_bc_rqst,
+	.bc_destroy		= xprt_destroy_bc,
+#endif
 };
 
 static struct rpc_xprt_ops xs_tcp_ops = {
@@ -2580,6 +2590,11 @@ static struct rpc_xprt_ops xs_tcp_ops = {
 	.enable_swap		= xs_enable_swap,
 	.disable_swap		= xs_disable_swap,
 	.inject_disconnect	= xs_inject_disconnect,
+#ifdef CONFIG_SUNRPC_BACKCHANNEL
+	.bc_setup		= xprt_setup_bc,
+	.bc_free_rqst		= xprt_free_bc_rqst,
+	.bc_destroy		= xprt_destroy_bc,
+#endif
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
