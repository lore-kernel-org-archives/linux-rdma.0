From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 4/9] IB/core: Infrastructure to manage peer core context
Date: Mon,  6 Oct 2014 16:26:54 +0300
Message-ID: <1412602019-30659-5-git-send-email-yishaih@mellanox.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412602019-30659-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adds an infrastructure to manage core context for a given umem,
it's needed for the invalidation flow.

Core context is supplied to peer clients as some opaque data for a given
memory pages represented by a umem.

If the peer client needs to invalidate memory it provided through the peer memory callbacks,
it should call the invalidation callback, supplying the relevant core context.
IB core will use this context to invalidate the relevant memory.

To prevent cases when there are inflight invalidation calls in parallel
to releasing this memory (e.g. by dereg_mr) we must ensure that context
is valid before accessing it, that's why couldn't use the core context
pointer directly. For that reason we added a lookup table to map between
a ticket id to a core context. Peer client will get/supply the ticket
id, core will check whether exists before accessing its corresponding
context.

The ticket id is provided to the peer memory client, as part of the
get_pages API. The only "remote" party using it is the peer memory
client. It is used for invalidation flow, to specify what memory
registration should be invalidated. This flow might be called
asynchronously, in parallel to an ongoing dereg_mr operation. As such,
the invalidation flow might be called after the memory registration
has been completely released. Relying on a pointer-based, or IDR-based
ticket value can result in spurious invalidation of unrelated memory
regions. Internally, we carefully lock the data structures and
synchronize as needed when extracting the context from the
ticket. This ensures a proper, synchronized release of the memory
mapping. The ticket mechanism allows us to safely ignore inflight
invalidation calls that were arrived too late.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c |   84 ++++++++++++++++++++++++++++++++++++
 include/rdma/ib_peer_mem.h         |   18 ++++++++
 include/rdma/ib_umem.h             |    6 +++
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index cc6e9e1..2f34552 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -42,6 +42,87 @@ static int ib_invalidate_peer_memory(void *reg_handle, u64 core_context)
 	return -ENOSYS;
 }
 
+static int ib_peer_insert_context(struct ib_peer_memory_client *ib_peer_client,
+				  void *context,
+				  u64 *context_ticket)
+{
+	struct core_ticket *core_ticket = kzalloc(sizeof(*core_ticket), GFP_KERNEL);
+
+	if (!core_ticket)
+		return -ENOMEM;
+
+	mutex_lock(&ib_peer_client->lock);
+	core_ticket->key = ib_peer_client->last_ticket++;
+	core_ticket->context = context;
+	list_add_tail(&core_ticket->ticket_list,
+		      &ib_peer_client->core_ticket_list);
+	*context_ticket = core_ticket->key;
+	mutex_unlock(&ib_peer_client->lock);
+
+	return 0;
+}
+
+/* Caller should be holding the peer client lock, specifically, the caller should hold ib_peer_client->lock */
+static int ib_peer_remove_context(struct ib_peer_memory_client *ib_peer_client,
+				  u64 key)
+{
+	struct core_ticket *core_ticket;
+
+	list_for_each_entry(core_ticket, &ib_peer_client->core_ticket_list,
+			    ticket_list) {
+		if (core_ticket->key == key) {
+			list_del(&core_ticket->ticket_list);
+			kfree(core_ticket);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+/**
+** ib_peer_create_invalidation_ctx - creates invalidation context for a given umem
+** @ib_peer_mem: peer client to be used
+** @umem: umem struct belongs to that context
+** @invalidation_ctx: output context
+**/
+int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem, struct ib_umem *umem,
+				    struct invalidation_ctx **invalidation_ctx)
+{
+	int ret;
+	struct invalidation_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ret = ib_peer_insert_context(ib_peer_mem, ctx,
+				     &ctx->context_ticket);
+	if (ret) {
+		kfree(ctx);
+		return ret;
+	}
+
+	ctx->umem = umem;
+	umem->invalidation_ctx = ctx;
+	*invalidation_ctx = ctx;
+	return 0;
+}
+
+/**
+ * ** ib_peer_destroy_invalidation_ctx - destroy a given invalidation context
+ * ** @ib_peer_mem: peer client to be used
+ * ** @invalidation_ctx: context to be invalidated
+ * **/
+void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem,
+				      struct invalidation_ctx *invalidation_ctx)
+{
+	mutex_lock(&ib_peer_mem->lock);
+	ib_peer_remove_context(ib_peer_mem, invalidation_ctx->context_ticket);
+	mutex_unlock(&ib_peer_mem->lock);
+
+	kfree(invalidation_ctx);
+}
 static int ib_memory_peer_check_mandatory(const struct peer_memory_client
 						     *peer_client)
 {
@@ -90,9 +171,12 @@ void *ib_register_peer_memory_client(const struct peer_memory_client *peer_clien
 	if (!ib_peer_client)
 		return NULL;
 
+	INIT_LIST_HEAD(&ib_peer_client->core_ticket_list);
+	mutex_init(&ib_peer_client->lock);
 	init_completion(&ib_peer_client->unload_comp);
 	kref_init(&ib_peer_client->ref);
 	ib_peer_client->peer_mem = peer_client;
+	ib_peer_client->last_ticket = 1;
 	/* Once peer supplied a non NULL callback it's an indication that invalidation support is
 	 * required for any memory owning.
 	 */
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 98056c5..8b28bfe 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -4,6 +4,8 @@
 #include <rdma/peer_mem.h>
 
 struct ib_ucontext;
+struct ib_umem;
+struct invalidation_ctx;
 
 struct ib_peer_memory_client {
 	const struct peer_memory_client *peer_mem;
@@ -11,16 +13,32 @@ struct ib_peer_memory_client {
 	int invalidation_required;
 	struct kref ref;
 	struct completion unload_comp;
+	/* lock is used via the invalidation flow */
+	struct mutex lock;
+	struct list_head   core_ticket_list;
+	u64	last_ticket;
 };
 
 enum ib_peer_mem_flags {
 	IB_PEER_MEM_ALLOW	= 1,
 };
 
+struct core_ticket {
+	unsigned long key;
+	void *context;
+	struct list_head   ticket_list;
+};
+
 struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
 						 size_t size, void **peer_client_context);
 
 void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
 			void *peer_client_context);
 
+int ib_peer_create_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem, struct ib_umem *umem,
+				    struct invalidation_ctx **invalidation_ctx);
+
+void ib_peer_destroy_invalidation_ctx(struct ib_peer_memory_client *ib_peer_mem,
+				      struct invalidation_ctx *invalidation_ctx);
+
 #endif
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index a22dde0..3352b14 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -40,6 +40,11 @@
 
 struct ib_ucontext;
 
+struct invalidation_ctx {
+	struct ib_umem *umem;
+	u64 context_ticket;
+};
+
 struct ib_umem {
 	struct ib_ucontext     *context;
 	size_t			length;
@@ -56,6 +61,7 @@ struct ib_umem {
 	int             npages;
 	/* peer memory that manages this umem */
 	struct ib_peer_memory_client *ib_peer_mem;
+	struct invalidation_ctx *invalidation_ctx;
 	/* peer memory private context */
 	void *peer_mem_client_context;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
