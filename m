From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/10] NFS: Clean up nfs4_init_callback()
Date: Sat, 08 Nov 2014 20:15:26 -0500
Message-ID: <20141109011526.8806.76442.stgit@manet.1015granger.net>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109010328.8806.5861.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

nfs4_init_callback() is never invoked for NFS versions other than 4.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfs/nfs4client.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index ffdb28d..5f4b818 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -241,28 +241,25 @@ void nfs4_free_client(struct nfs_client *clp)
  */
 static int nfs4_init_callback(struct nfs_client *clp)
 {
+	struct rpc_xprt *xprt;
 	int error;
 
-	if (clp->rpc_ops->version == 4) {
-		struct rpc_xprt *xprt;
+	xprt = rcu_dereference_raw(clp->cl_rpcclient->cl_xprt);
 
-		xprt = rcu_dereference_raw(clp->cl_rpcclient->cl_xprt);
-
-		if (nfs4_has_session(clp)) {
-			error = xprt_setup_backchannel(xprt,
-						NFS41_BC_MIN_CALLBACKS);
-			if (error < 0)
-				return error;
-		}
-
-		error = nfs_callback_up(clp->cl_mvops->minor_version, xprt);
-		if (error < 0) {
-			dprintk("%s: failed to start callback. Error = %d\n",
-				__func__, error);
+	if (nfs4_has_session(clp)) {
+		error = xprt_setup_backchannel(xprt, NFS41_BC_MIN_CALLBACKS);
+		if (error < 0)
 			return error;
-		}
-		__set_bit(NFS_CS_CALLBACK, &clp->cl_res_state);
 	}
+
+	error = nfs_callback_up(clp->cl_mvops->minor_version, xprt);
+	if (error < 0) {
+		dprintk("%s: failed to start callback. Error = %d\n",
+			__func__, error);
+		return error;
+	}
+	__set_bit(NFS_CS_CALLBACK, &clp->cl_res_state);
+
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
