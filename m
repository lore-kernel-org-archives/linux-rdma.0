From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH v1] xprtrdma: take vendor driver refcount at client
Date: Wed, 29 Jul 2015 18:11:01 +0530
Message-ID: <1438173661-12497-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Chuck Lever for the valuable feedback and suggestions.

This is a rework of the following patch sent almost a year back:
http://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg20730.html

In presence of active mount if someone tries to rmmod vendor-driver, the
command remains stuck forever waiting for destruction of all rdma-cm-id.
in worst case client can crash during shutdown with active mounts.

The existing code assumes that ia->ri_id->device cannot change during
the lifetime of a transport. xprtrdma do not have support for
DEVICE_REMOVAL event either. Lifting that assumption and adding support
for DEVICE_REMOVAL event is a long chain of work, and is in plan.

The community decided that preventing the hang right now is more
important than waiting for architectural changes.

Thus, this patch intorduces a temorary workaround to acquire module
reference count during the mount of a nfs-rdma mount point.

CC:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
CC:linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 891c4ed..d59d638 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -52,6 +52,7 @@
 #include <linux/prefetch.h>
 #include <linux/sunrpc/addr.h>
 #include <asm/bitops.h>
+#include <linux/module.h> /* try_module_get()/module_put() */
 
 #include "xprt_rdma.h"
 
@@ -414,6 +415,14 @@ connected:
 	return 0;
 }
 
+static void rpcrdma_destroy_id(struct rdma_cm_id *id)
+{
+	if (id) {
+		module_put(id->device->owner);
+		rdma_destroy_id(id);
+	}
+}
+
 static struct rdma_cm_id *
 rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 			struct rpcrdma_ia *ia, struct sockaddr *addr)
@@ -440,6 +449,18 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
 				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+
+	/* FIXME: We hate to break the notion of ULP<-->Core<-->Provider
+	 * by calling try_module_get() on vendor driver. This is to prevent a
+	 * system hang or a possible crash during reboot with active nfs-rdma
+	 * mount. We will keep this workaround until xprtrdma comes back with a
+	 * massive architectural changes to have proper fix.
+	 */
+	if (!ia->ri_async_rc && !try_module_get(id->device->owner)) {
+		dprintk("RPC:       %s: Failed to get device module\n",
+			__func__);
+		ia->ri_async_rc = -ENODEV;
+	}
 	rc = ia->ri_async_rc;
 	if (rc)
 		goto out;
@@ -449,16 +470,17 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 	if (rc) {
 		dprintk("RPC:       %s: rdma_resolve_route() failed %i\n",
 			__func__, rc);
-		goto out;
+		goto put;
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
 				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
 	rc = ia->ri_async_rc;
 	if (rc)
-		goto out;
+		goto put;
 
 	return id;
-
+put:
+	module_put(id->device->owner);
 out:
 	rdma_destroy_id(id);
 	return ERR_PTR(rc);
@@ -592,7 +614,7 @@ out3:
 	ib_dealloc_pd(ia->ri_pd);
 	ia->ri_pd = NULL;
 out2:
-	rdma_destroy_id(ia->ri_id);
+	rpcrdma_destroy_id(ia->ri_id);
 	ia->ri_id = NULL;
 out1:
 	return rc;
@@ -618,7 +640,7 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
 	if (ia->ri_id != NULL && !IS_ERR(ia->ri_id)) {
 		if (ia->ri_id->qp)
 			rdma_destroy_qp(ia->ri_id);
-		rdma_destroy_id(ia->ri_id);
+		rpcrdma_destroy_id(ia->ri_id);
 		ia->ri_id = NULL;
 	}
 
@@ -825,7 +847,7 @@ retry:
 		if (ia->ri_device != id->device) {
 			printk("RPC:       %s: can't reconnect on "
 				"different device!\n", __func__);
-			rdma_destroy_id(id);
+			rpcrdma_destroy_id(id);
 			rc = -ENETUNREACH;
 			goto out;
 		}
@@ -834,7 +856,7 @@ retry:
 		if (rc) {
 			dprintk("RPC:       %s: rdma_create_qp failed %i\n",
 				__func__, rc);
-			rdma_destroy_id(id);
+			rpcrdma_destroy_id(id);
 			rc = -ENETUNREACH;
 			goto out;
 		}
@@ -845,7 +867,7 @@ retry:
 		write_unlock(&ia->ri_qplock);
 
 		rdma_destroy_qp(old);
-		rdma_destroy_id(old);
+		rpcrdma_destroy_id(old);
 	} else {
 		dprintk("RPC:       %s: connecting...\n", __func__);
 		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
