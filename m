From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 19:31:36 +0530
Message-ID: <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405605697-11583-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If verndor driver is attempted for removal while xprtrdma still has an
active mount, the removal of driver may never complete and can cause
unseen races or in worst case system crash.

To solve this, xprtrdma module should get reference of struct ib_device
structure for every mount. Reference is taken after local device address
resolution is completed successfuly.

reference to the struct ib_device pointer is put just before cm_id destruction.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |   17 +++++++++++++++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 6ead5df..b00e55e 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -457,6 +457,11 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
 				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+	if (!ia->ri_async_rc && !try_module_get(id->device->owner)) {
+		dprintk("RPC:       %s: Failed to get device module\n",
+			__func__);
+		ia->ri_async_rc = -ENODEV;
+	}
 	rc = ia->ri_async_rc;
 	if (rc)
 		goto out;
@@ -466,16 +471,18 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 	if (rc) {
 		dprintk("RPC:       %s: rdma_resolve_route() failed %i\n",
 			__func__, rc);
-		goto out;
+		goto out_put;
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
 				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
 	rc = ia->ri_async_rc;
 	if (rc)
-		goto out;
+		goto out_put;
 
 	return id;
 
+out_put:
+	module_put(id->device->owner);
 out:
 	rdma_destroy_id(id);
 	return ERR_PTR(rc);
@@ -613,6 +620,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 	rwlock_init(&ia->ri_qplock);
 	return 0;
 out2:
+	module_put(ia->ri_id->device->owner);
 	rdma_destroy_id(ia->ri_id);
 	ia->ri_id = NULL;
 out1:
@@ -638,9 +646,11 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
 	if (ia->ri_id != NULL && !IS_ERR(ia->ri_id)) {
 		if (ia->ri_id->qp)
 			rdma_destroy_qp(ia->ri_id);
+		module_put(ia->ri_id->device->owner);
 		rdma_destroy_id(ia->ri_id);
 		ia->ri_id = NULL;
 	}
+
 	if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
 		rc = ib_dealloc_pd(ia->ri_pd);
 		dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
@@ -886,6 +896,7 @@ retry:
 		if (ia->ri_id->device != id->device) {
 			printk("RPC:       %s: can't reconnect on "
 				"different device!\n", __func__);
+			module_put(id->device->owner);
 			rdma_destroy_id(id);
 			rc = -ENETUNREACH;
 			goto out;
@@ -895,6 +906,7 @@ retry:
 		if (rc) {
 			dprintk("RPC:       %s: rdma_create_qp failed %i\n",
 				__func__, rc);
+			module_put(id->device->owner);
 			rdma_destroy_id(id);
 			rc = -ENETUNREACH;
 			goto out;
@@ -906,6 +918,7 @@ retry:
 		write_unlock(&ia->ri_qplock);
 
 		rdma_destroy_qp(old);
+		module_put(old->device->owner);
 		rdma_destroy_id(old);
 	} else {
 		dprintk("RPC:       %s: connecting...\n", __func__);
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index c419498..b35fa21 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -44,6 +44,7 @@
 #include <linux/spinlock.h> 		/* spinlock_t, etc */
 #include <linux/atomic.h>			/* atomic_t, etc */
 #include <linux/workqueue.h>		/* struct work_struct */
+#include <linux/module.h>		/* try_module_get()/module_put() */
 
 #include <rdma/rdma_cm.h>		/* RDMA connection api */
 #include <rdma/ib_verbs.h>		/* RDMA verbs api */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
