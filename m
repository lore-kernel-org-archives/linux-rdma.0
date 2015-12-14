From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 06/11] svcrdma: Remove unused req_map and ctxt kmem_caches
Date: Mon, 14 Dec 2015 16:30:50 -0500
Message-ID: <20151214213050.12932.10521.stgit@klimt.1015granger.net>
References: <20151214211951.12932.99017.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211951.12932.99017.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h |    1 +
 net/sunrpc/xprtrdma/svc_rdma.c  |   35 -----------------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |    7 -------
 3 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 05bf4fe..141edbb 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -242,6 +242,7 @@ extern struct svc_xprt_class svc_rdma_bc_class;
 #endif
 
 /* svc_rdma.c */
+extern struct workqueue_struct *svc_rdma_wq;
 extern int svc_rdma_init(void);
 extern void svc_rdma_cleanup(void);
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 1b7051b..e894e06 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -71,10 +71,6 @@ atomic_t rdma_stat_rq_prod;
 atomic_t rdma_stat_sq_poll;
 atomic_t rdma_stat_sq_prod;
 
-/* Temporary NFS request map and context caches */
-struct kmem_cache *svc_rdma_map_cachep;
-struct kmem_cache *svc_rdma_ctxt_cachep;
-
 struct workqueue_struct *svc_rdma_wq;
 
 /*
@@ -243,8 +239,6 @@ void svc_rdma_cleanup(void)
 	svc_unreg_xprt_class(&svc_rdma_bc_class);
 #endif
 	svc_unreg_xprt_class(&svc_rdma_class);
-	kmem_cache_destroy(svc_rdma_map_cachep);
-	kmem_cache_destroy(svc_rdma_ctxt_cachep);
 }
 
 int svc_rdma_init(void)
@@ -264,39 +258,10 @@ int svc_rdma_init(void)
 		svcrdma_table_header =
 			register_sysctl_table(svcrdma_root_table);
 
-	/* Create the temporary map cache */
-	svc_rdma_map_cachep = kmem_cache_create("svc_rdma_map_cache",
-						sizeof(struct svc_rdma_req_map),
-						0,
-						SLAB_HWCACHE_ALIGN,
-						NULL);
-	if (!svc_rdma_map_cachep) {
-		printk(KERN_INFO "Could not allocate map cache.\n");
-		goto err0;
-	}
-
-	/* Create the temporary context cache */
-	svc_rdma_ctxt_cachep =
-		kmem_cache_create("svc_rdma_ctxt_cache",
-				  sizeof(struct svc_rdma_op_ctxt),
-				  0,
-				  SLAB_HWCACHE_ALIGN,
-				  NULL);
-	if (!svc_rdma_ctxt_cachep) {
-		printk(KERN_INFO "Could not allocate WR ctxt cache.\n");
-		goto err1;
-	}
-
 	/* Register RDMA with the SVC transport switch */
 	svc_reg_xprt_class(&svc_rdma_class);
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 	svc_reg_xprt_class(&svc_rdma_bc_class);
 #endif
 	return 0;
- err1:
-	kmem_cache_destroy(svc_rdma_map_cachep);
- err0:
-	unregister_sysctl_table(svcrdma_table_header);
-	destroy_workqueue(svc_rdma_wq);
-	return -ENOMEM;
 }
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 4197191..72276c7 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -528,11 +528,4 @@ void xprt_rdma_bc_free_rqst(struct rpc_rqst *);
 void xprt_rdma_bc_destroy(struct rpc_xprt *, unsigned int);
 #endif	/* CONFIG_SUNRPC_BACKCHANNEL */
 
-/* Temporary NFS request map cache. Created in svc_rdma.c  */
-extern struct kmem_cache *svc_rdma_map_cachep;
-/* WR context cache. Created in svc_rdma.c  */
-extern struct kmem_cache *svc_rdma_ctxt_cachep;
-/* Workqueue created in svc_rdma.c */
-extern struct workqueue_struct *svc_rdma_wq;
-
 #endif				/* _LINUX_SUNRPC_XPRT_RDMA_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
