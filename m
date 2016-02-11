From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 5/7] IB/core: Invalidation support for peer memory
Date: Thu, 11 Feb 2016 18:12:55 +0200
Message-ID: <1455207177-11949-6-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds the required functionality to invalidate a given peer
memory represented by some core context.

Each umem that was built over peer memory and supports invalidation has
some invalidation context assigned to it with the required data to
manage, once peer will call the invalidation callback below actions are
taken:

1) Taking lock on peer client to sync with inflight dereg_mr on that
memory.
2) Once lock is taken have a lookup for ticket id to find the matching
core context.
3) In case found will call umem invalidation function, otherwise call is
returned.

Some notes:
1) As peer invalidate callback defined to be blocking it must return
just after that pages are not going to be accessed any more. For that
reason ib_invalidate_peer_memory is waiting for a completion event in
case there is other inflight call coming as part of dereg_mr.

2) The peer memory API assumes that a lock might be taken by a peer
client to protect its memory operations. Specifically, its invalidate
callback might be called under that lock which may lead to an AB/BA
dead-lock in case IB core will call get/put pages APIs with the IB core
peer's lock taken, for that reason as part of
ib_umem_activate_invalidation_notifier lock is taken
then checking for some inflight invalidation state before activating it.

3) Once a peer client admits as part of its registration that it may
require invalidation support, it can't be an owner of a memory range
which doesn't support it.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c | 85 ++++++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/umem.c     | 56 +++++++++++++++++++++----
 include/rdma/ib_peer_mem.h         |  1 +
 include/rdma/ib_umem.h             | 19 +++++++++
 4 files changed, 148 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index 57afb76..f9aaef2 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -37,9 +37,56 @@
 static DEFINE_MUTEX(peer_memory_mutex);
 static LIST_HEAD(peer_memory_list);
 
+/* Caller should be holding the peer client lock, ib_peer_client->lock */
+static struct core_ticket *ib_peer_search_context(
+		struct ib_peer_memory_client *ib_peer_client,
+		u64 key)
+{
+	struct core_ticket *core_ticket;
+
+	list_for_each_entry(core_ticket, &ib_peer_client->core_ticket_list,
+			    ticket_list) {
+		if (core_ticket->key == key)
+			return core_ticket;
+	}
+
+	return NULL;
+}
+
 static int ib_invalidate_peer_memory(void *reg_handle, u64 core_context)
 {
-	return -ENOSYS;
+	struct ib_peer_memory_client *ib_peer_client = reg_handle;
+	struct invalidation_ctx *invalidation_ctx;
+	struct core_ticket *core_ticket;
+
+	mutex_lock(&ib_peer_client->lock);
+	core_ticket = ib_peer_search_context(ib_peer_client, core_context);
+	if (!core_ticket) {
+		mutex_unlock(&ib_peer_client->lock);
+		return 0;
+	}
+
+	invalidation_ctx = (struct invalidation_ctx *)core_ticket->context;
+	/* If context is not ready yet, mark it to be invalidated */
+	if (!invalidation_ctx->func) {
+		invalidation_ctx->peer_invalidated = 1;
+		mutex_unlock(&ib_peer_client->lock);
+		return 0;
+	}
+	invalidation_ctx->func(invalidation_ctx->cookie,
+					invalidation_ctx->umem, 0, 0);
+	if (invalidation_ctx->inflight_invalidation) {
+		/* init the completion to wait on
+		 * before letting other thread to run
+		 */
+		init_completion(&invalidation_ctx->comp);
+		mutex_unlock(&ib_peer_client->lock);
+		wait_for_completion(&invalidation_ctx->comp);
+	}
+
+	kfree(invalidation_ctx);
+
+	return 0;
 }
 
 static int ib_peer_insert_context(struct ib_peer_memory_client *ib_peer_client,
@@ -122,11 +169,33 @@ int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem,
 void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem,
 				      struct invalidation_ctx *invalidation_ctx)
 {
-	mutex_lock(&ib_peer_mem->lock);
+	int peer_callback;
+	int inflight_invalidation;
+
+	/* If we are under peer callback lock was already taken.*/
+	if (!invalidation_ctx->peer_callback)
+		mutex_lock(&ib_peer_mem->lock);
 	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticket);
-	mutex_unlock(&ib_peer_mem->lock);
+	/* Make sure to check inflight flag after took the lock and remove
+	 * from tree. In addition, from that point using local variables for
+	 * peer_callback and inflight_invalidation as after the complete
+	 * invalidation_ctx can't be accessed any more as it may be freed
+	 * by the callback.
+	 */
+	peer_callback = invalidation_ctx->peer_callback;
+	inflight_invalidation = invalidation_ctx->inflight_invalidation;
+	if (inflight_invalidation)
+		complete(&invalidation_ctx->comp);
 
-	kfree(invalidation_ctx);
+	/* On peer callback lock is handled externally */
+	if (!peer_callback)
+		mutex_unlock(&ib_peer_mem->lock);
+
+	/* In case under callback context or callback is pending
+	 * let it free the invalidation context
+	 */
+	if (!peer_callback && !inflight_invalidation)
+		kfree(invalidation_ctx);
 }
 
 static void complete_peer(struct kref *kref)
@@ -186,6 +255,7 @@ EXPORT_SYMBOL(ib_unregister_peer_memory_client);
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context,
 						 unsigned long addr,
 						 size_t size,
+						 unsigned long flags,
 						 void **peer_client_context)
 {
 	struct ib_peer_memory_client *ib_peer_client;
@@ -193,6 +263,13 @@ struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context,
 
 	mutex_lock(&peer_memory_mutex);
 	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_list) {
+		/* In case peer requires invalidation it can't own memory
+		 * which doesn't support it
+		 */
+		if (ib_peer_client->invalidation_required &&
+		    (!(flags & IB_UMEM_PEER_INVAL_SUPP)))
+			continue;
+
 		ret = ib_peer_client->peer_mem->acquire(addr, size,
 							peer_client_context);
 		if (ret > 0)
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 2eab34e..f478f63 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -46,12 +46,19 @@
 #ifdef CONFIG_INFINIBAND_PEER_MEM
 static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 				     struct ib_umem *umem, unsigned long addr,
-				     int dmasync)
+				     unsigned long flags)
 {
 	int ret;
 	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+	struct invalidation_ctx *ictx = NULL;
 
 	umem->ib_peer_mem = ib_peer_mem;
+	if (flags & IB_UMEM_PEER_INVAL_SUPP) {
+		ret = ib_peer_create_invalidation_ctx(ib_peer_mem, umem, &ictx);
+		if (ret)
+			goto end;
+	}
+
 	/*
 	 * We always request write permissions to the pages, to force breaking
 	 * of any CoW during the registration of the MR. For read-only MRs we
@@ -62,7 +69,7 @@ static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 				  1, !umem->writable,
 				  &umem->sg_head,
 				  umem->peer_mem_client_context,
-				  0);
+				  ictx ? ictx->context_ticket : 0);
 	if (ret)
 		goto out;
 
@@ -71,7 +78,7 @@ static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 	ret = peer_mem->dma_map(&umem->sg_head,
 				umem->peer_mem_client_context,
 				umem->context->device->dma_device,
-				dmasync,
+				flags & IB_UMEM_DMA_SYNC,
 				&umem->nmap);
 	if (ret)
 		goto put_pages;
@@ -82,23 +89,54 @@ put_pages:
 	peer_mem->put_pages(&umem->sg_head,
 			    umem->peer_mem_client_context);
 out:
+	if (ictx)
+		ib_peer_destroy_invalidation_ctx(ib_peer_mem, ictx);
+end:
 	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	return ERR_PTR(ret);
 }
 
 static void peer_umem_release(struct ib_umem *umem)
 {
-	const struct peer_memory_client *peer_mem =
-				umem->ib_peer_mem->peer_mem;
+	struct ib_peer_memory_client *ib_peer_mem = umem->ib_peer_mem;
+	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+	struct invalidation_ctx *ictx = umem->invalidation_ctx;
+
+	if (ictx)
+		ib_peer_destroy_invalidation_ctx(ib_peer_mem, ictx);
 
 	peer_mem->dma_unmap(&umem->sg_head,
 			    umem->peer_mem_client_context,
 			    umem->context->device->dma_device);
 	peer_mem->put_pages(&umem->sg_head,
 			    umem->peer_mem_client_context);
-	ib_put_peer_client(umem->ib_peer_mem, umem->peer_mem_client_context);
+	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	kfree(umem);
 }
+
+int ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
+					   void (*func)(void *cookie,
+					   struct ib_umem *umem,
+					   unsigned long addr, size_t size),
+					   void *cookie)
+{
+	struct invalidation_ctx *ictx = umem->invalidation_ctx;
+	int ret = 0;
+
+	mutex_lock(&umem->ib_peer_mem->lock);
+	if (ictx->peer_invalidated) {
+		pr_err("ib_umem_activate_invalidation_notifier: pages were invalidated by peer\n");
+		ret = -EINVAL;
+		goto end;
+	}
+	ictx->func = func;
+	ictx->cookie = cookie;
+	/* from that point any pending invalidations can be called */
+end:
+	mutex_unlock(&umem->ib_peer_mem->lock);
+	return ret;
+}
+EXPORT_SYMBOL(ib_umem_activate_invalidation_notifier);
 #endif
 
 static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int dirty)
@@ -209,15 +247,15 @@ struct ib_umem *ib_umem_get_flags(struct ib_ucontext *context,
 		struct ib_umem *peer_umem;
 
 		peer_mem_client =
-			ib_get_peer_client(context, addr, size,
+			ib_get_peer_client(context, addr, size, flags,
 					   &umem->peer_mem_client_context);
 		if (IS_ERR(peer_mem_client)) {
 			kfree(umem);
 			return ERR_CAST(peer_mem_client);
 
 		} else if (peer_mem_client) {
-			peer_umem = peer_umem_get(peer_mem_client, umem, addr,
-						  flags & IB_UMEM_DMA_SYNC);
+			peer_umem = peer_umem_get(peer_mem_client, umem,
+						  addr, flags);
 			if (IS_ERR(peer_umem))
 				kfree(umem);
 			return peer_umem;
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 6f3dc84..d2b2d5f 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -60,6 +60,7 @@ struct core_ticket {
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context,
 						 unsigned long addr,
 						 size_t size,
+						 unsigned long flags,
 						 void **peer_client_context);
 
 void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 5d0fb41..002da1e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -42,11 +42,20 @@
 
 struct ib_ucontext;
 struct ib_umem_odp;
+struct ib_umem;
 
 #ifdef CONFIG_INFINIBAND_PEER_MEM
 struct invalidation_ctx {
 	struct ib_umem *umem;
 	u64 context_ticket;
+	void (*func)(void *invalidation_cookie,
+		     struct ib_umem *umem,
+		     unsigned long addr, size_t size);
+	void *cookie;
+	int peer_callback;
+	int inflight_invalidation;
+	int peer_invalidated;
+	struct completion comp;
 };
 #endif
 
@@ -100,6 +109,7 @@ static inline size_t ib_umem_num_pages(struct ib_umem *umem)
 enum ib_peer_mem_flags {
 	IB_UMEM_DMA_SYNC	= (1 << 0),
 	IB_UMEM_PEER_ALLOW	= (1 << 1),
+	IB_UMEM_PEER_INVAL_SUPP	= (1 << 2),
 };
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
@@ -112,6 +122,14 @@ int ib_umem_page_count(struct ib_umem *umem);
 int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 		      size_t length);
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+int ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
+					   void (*func)(void *cookie,
+					   struct ib_umem *umem,
+					   unsigned long addr, size_t size),
+					   void *cookie);
+#endif
+
 #else /* CONFIG_INFINIBAND_USER_MEM */
 
 #include <linux/err.h>
@@ -129,6 +147,7 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
 		      		    size_t length) {
 	return -EINVAL;
 }
+
 #endif /* CONFIG_INFINIBAND_USER_MEM */
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
