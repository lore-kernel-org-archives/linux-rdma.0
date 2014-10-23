From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 5/9] IB/core: Invalidation support for peer memory
Date: Thu, 23 Oct 2014 15:02:53 +0300
Message-ID: <1414065777-21173-6-git-send-email-yishaih@mellanox.com>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414065777-21173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
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
dead-lock in case IB core will call get/put pages APIs with the IB core peer's lock taken,
for that reason as part of  ib_umem_activate_invalidation_notifier lock is taken
then checking for some inflight invalidation state before activating it.

3) Once a peer client admits as part of its registration that it may
require invalidation support, it can't be an owner of a memory range
which doesn't support it.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c |   83 +++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/umem.c     |   50 ++++++++++++++++++---
 include/rdma/ib_peer_mem.h         |    4 +-
 include/rdma/ib_umem.h             |   17 +++++++
 4 files changed, 140 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index 2f34552..d4cf31c 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -37,9 +37,55 @@
 static DEFINE_MUTEX(peer_memory_mutex);
 static LIST_HEAD(peer_memory_list);
 
+/* Caller should be holding the peer client lock, ib_peer_client->lock */
+static struct core_ticket *ib_peer_search_context(struct ib_peer_memory_client *ib_peer_client,
+						  u64 key)
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
+	int need_unlock = 1;
+
+	mutex_lock(&ib_peer_client->lock);
+	core_ticket = ib_peer_search_context(ib_peer_client, core_context);
+	if (!core_ticket)
+		goto out;
+
+	invalidation_ctx = (struct invalidation_ctx *)core_ticket->context;
+	/* If context is not ready yet, mark it to be invalidated */
+	if (!invalidation_ctx->func) {
+		invalidation_ctx->peer_invalidated = 1;
+		goto out;
+	}
+	invalidation_ctx->func(invalidation_ctx->cookie,
+					invalidation_ctx->umem, 0, 0);
+	if (invalidation_ctx->inflight_invalidation) {
+		/* init the completion to wait on before letting other thread to run */
+		init_completion(&invalidation_ctx->comp);
+		mutex_unlock(&ib_peer_client->lock);
+		need_unlock = 0;
+		wait_for_completion(&invalidation_ctx->comp);
+	}
+
+	kfree(invalidation_ctx);
+out:
+	if (need_unlock)
+		mutex_unlock(&ib_peer_client->lock);
+
+	return 0;
 }
 
 static int ib_peer_insert_context(struct ib_peer_memory_client *ib_peer_client,
@@ -117,11 +163,30 @@ int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem, s
 void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem,
 				      struct invalidation_ctx *invalidation_ctx)
 {
-	mutex_lock(&ib_peer_mem->lock);
-	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticket);
-	mutex_unlock(&ib_peer_mem->lock);
+	int peer_callback;
+	int inflight_invalidation;
 
-	kfree(invalidation_ctx);
+	/* If we are under peer callback lock was already taken.*/
+	if (!invalidation_ctx->peer_callback)
+		mutex_lock(&ib_peer_mem->lock);
+	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticket);
+	/* make sure to check inflight flag after took the lock and remove from tree.
+	 * in addition, from that point using local variables for peer_callback and
+	 * inflight_invalidation as after the complete invalidation_ctx can't be accessed
+	 * any more as it may be freed by the callback.
+	 */
+	peer_callback = invalidation_ctx->peer_callback;
+	inflight_invalidation = invalidation_ctx->inflight_invalidation;
+	if (inflight_invalidation)
+		complete(&invalidation_ctx->comp);
+
+	/* On peer callback lock is handled externally */
+	if (!peer_callback)
+		mutex_unlock(&ib_peer_mem->lock);
+
+	/* in case under callback context or callback is pending let it free the invalidation context */
+	if (!peer_callback && !inflight_invalidation)
+		kfree(invalidation_ctx);
 }
 static int ib_memory_peer_check_mandatory(const struct peer_memory_client
 						     *peer_client)
@@ -208,13 +273,19 @@ void ib_unregister_peer_memory_client(void *reg_handle)
 EXPORT_SYMBOL(ib_unregister_peer_memory_client);
 
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
-						 size_t size, void **peer_client_context)
+						 size_t size, unsigned long peer_mem_flags,
+						 void **peer_client_context)
 {
 	struct ib_peer_memory_client *ib_peer_client;
 	int ret;
 
 	mutex_lock(&peer_memory_mutex);
 	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_list) {
+		/* In case peer requires invalidation it can't own memory which doesn't support it */
+		if (ib_peer_client->invalidation_required &&
+		    (!(peer_mem_flags & IB_PEER_MEM_INVAL_SUPP)))
+			continue;
+
 		ret = ib_peer_client->peer_mem->acquire(addr, size,
 						   context->peer_mem_private_data,
 						   context->peer_mem_name,
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index f3e445c..6655d12 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -44,12 +44,19 @@
 
 static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 				     struct ib_umem *umem, unsigned long addr,
-				     int dmasync)
+				     int dmasync, unsigned long peer_mem_flags)
 {
 	int ret;
 	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+	struct invalidation_ctx *invalidation_ctx = NULL;
 
 	umem->ib_peer_mem = ib_peer_mem;
+	if (peer_mem_flags & IB_PEER_MEM_INVAL_SUPP) {
+		ret = ib_peer_create_invalidation_ctx(ib_peer_mem, umem, &invalidation_ctx);
+		if (ret)
+			goto end;
+	}
+
 	/*
 	 * We always request write permissions to the pages, to force breaking of any CoW
 	 * during the registration of the MR. For read-only MRs we use the "force" flag to
@@ -60,7 +67,8 @@ static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 				  1, !umem->writable,
 				  &umem->sg_head,
 				  umem->peer_mem_client_context,
-				  0);
+				  invalidation_ctx ?
+				  invalidation_ctx->context_ticket : 0);
 	if (ret)
 		goto out;
 
@@ -84,6 +92,9 @@ put_pages:
 	peer_mem->put_pages(umem->peer_mem_client_context,
 					&umem->sg_head);
 out:
+	if (invalidation_ctx)
+		ib_peer_destroy_invalidation_ctx(ib_peer_mem, invalidation_ctx);
+end:
 	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	kfree(umem);
 	return ERR_PTR(ret);
@@ -91,15 +102,19 @@ out:
 
 static void peer_umem_release(struct ib_umem *umem)
 {
-	const struct peer_memory_client *peer_mem =
-				umem->ib_peer_mem->peer_mem;
+	struct ib_peer_memory_client *ib_peer_mem = umem->ib_peer_mem;
+	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+	struct invalidation_ctx *invalidation_ctx = umem->invalidation_ctx;
+
+	if (invalidation_ctx)
+		ib_peer_destroy_invalidation_ctx(ib_peer_mem, invalidation_ctx);
 
 	peer_mem->dma_unmap(&umem->sg_head,
 			    umem->peer_mem_client_context,
 			    umem->context->device->dma_device);
 	peer_mem->put_pages(&umem->sg_head,
 			    umem->peer_mem_client_context);
-	ib_put_peer_client(umem->ib_peer_mem, umem->peer_mem_client_context);
+	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	kfree(umem);
 }
 
@@ -127,6 +142,27 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 }
 
+int ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
+					   umem_invalidate_func_t func,
+					   void *cookie)
+{
+	struct invalidation_ctx *invalidation_ctx = umem->invalidation_ctx;
+	int ret = 0;
+
+	mutex_lock(&umem->ib_peer_mem->lock);
+	if (invalidation_ctx->peer_invalidated) {
+		pr_err("ib_umem_activate_invalidation_notifier: pages were invalidated by peer\n");
+		ret = -EINVAL;
+		goto end;
+	}
+	invalidation_ctx->func = func;
+	invalidation_ctx->cookie = cookie;
+	/* from that point any pending invalidations can be called */
+end:
+	mutex_unlock(&umem->ib_peer_mem->lock);
+	return ret;
+}
+EXPORT_SYMBOL(ib_umem_activate_invalidation_notifier);
 /**
  * ib_umem_get - Pin and DMA map userspace memory.
  * @context: userspace context to pin memory for
@@ -179,11 +215,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (peer_mem_flags & IB_PEER_MEM_ALLOW) {
 		struct ib_peer_memory_client *peer_mem_client;
 
-		peer_mem_client =  ib_get_peer_client(context, addr, size,
+		peer_mem_client =  ib_get_peer_client(context, addr, size, peer_mem_flags,
 						      &umem->peer_mem_client_context);
 		if (peer_mem_client)
 			return peer_umem_get(peer_mem_client, umem, addr,
-					dmasync);
+					dmasync, peer_mem_flags);
 	}
 
 	/* We assume the memory is from hugetlb until proved otherwise */
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 8b28bfe..58e0f99 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -21,6 +21,7 @@ struct ib_peer_memory_client {
 
 enum ib_peer_mem_flags {
 	IB_PEER_MEM_ALLOW	= 1,
+	IB_PEER_MEM_INVAL_SUPP = (1<<1),
 };
 
 struct core_ticket {
@@ -30,7 +31,8 @@ struct core_ticket {
 };
 
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
-						 size_t size, void **peer_client_context);
+						 size_t size, unsigned long peer_mem_flags,
+						 void **peer_client_context);
 
 void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
 			void *peer_client_context);
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 3352b14..6cf433b 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -39,10 +39,21 @@
 #include <rdma/ib_peer_mem.h>
 
 struct ib_ucontext;
+struct ib_umem;
+
+typedef void (*umem_invalidate_func_t)(void *invalidation_cookie,
+					    struct ib_umem *umem,
+					    unsigned long addr, size_t size);
 
 struct invalidation_ctx {
 	struct ib_umem *umem;
 	u64 context_ticket;
+	umem_invalidate_func_t func;
+	void *cookie;
+	int peer_callback;
+	int inflight_invalidation;
+	int peer_invalidated;
+	struct completion comp;
 };
 
 struct ib_umem {
@@ -73,6 +84,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			       unsigned long peer_mem_flags);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
+int  ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
+					    umem_invalidate_func_t func,
+					    void *cookie);
 
 #else /* CONFIG_INFINIBAND_USER_MEM */
 
@@ -87,6 +101,9 @@ static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 static inline void ib_umem_release(struct ib_umem *umem) { }
 static inline int ib_umem_page_count(struct ib_umem *umem) { return 0; }
 
+static inline int ib_umem_activate_invalidation_notifier(struct ib_umem *umem,
+							 umem_invalidate_func_t func,
+							 void *cookie) {return 0; }
 #endif /* CONFIG_INFINIBAND_USER_MEM */
 
 #endif /* IB_UMEM_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
