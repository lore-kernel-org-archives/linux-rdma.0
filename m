From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 2/9] IB/core: Get/put peer memory client
Date: Thu, 23 Oct 2014 15:02:50 +0300
Message-ID: <1414065777-21173-3-git-send-email-yishaih@mellanox.com>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414065777-21173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Supplies an API to get/put a peer client functionality.
It encapsulates the details of how to acquire/release a peer client from
its callers and let them get the required peer client in case it exists.

The 'get' call iterates over registered peer clients looking for an
owner of a given address range by calling peer's 'acquire' call.
In case an owner is found the loop is stopped.

The 'put' call does the opposite, lets peer release its resources for
that given address range.

A reference counting/completion mechanism is used to prevent a peer
memory client from going down once there are active users for its memory.

In addition:
- ib_ucontext was extended to enable peers setting their private
  context, get it via the 'acquire' call then be able to recognize their memory. A given
  ucontext can be served only by one peer which it belongs to.
- an extra device capability named IB_DEVICE_PEER_MEMORY was introduced,
  to be used by low level drivers to mark that they support this functionality.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c   |   49 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |    2 +
 include/rdma/ib_peer_mem.h           |   10 +++++++
 include/rdma/ib_verbs.h              |    5 +++-
 4 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index c00af39..cc6e9e1 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -70,6 +70,14 @@ static int ib_memory_peer_check_mandatory(const struct peer_memory_client
 		return 0;
 }
 
+static void complete_peer(struct kref *kref)
+{
+	struct ib_peer_memory_client *ib_peer_client =
+		container_of(kref, struct ib_peer_memory_client, ref);
+
+	complete(&ib_peer_client->unload_comp);
+}
+
 void *ib_register_peer_memory_client(const struct peer_memory_client *peer_client,
 				     invalidate_peer_memory *invalidate_callback)
 {
@@ -82,6 +90,8 @@ void *ib_register_peer_memory_client(const struct peer_memory_client *peer_clien
 	if (!ib_peer_client)
 		return NULL;
 
+	init_completion(&ib_peer_client->unload_comp);
+	kref_init(&ib_peer_client->ref);
 	ib_peer_client->peer_mem = peer_client;
 	/* Once peer supplied a non NULL callback it's an indication that invalidation support is
 	 * required for any memory owning.
@@ -107,6 +117,45 @@ void ib_unregister_peer_memory_client(void *reg_handle)
 	list_del(&ib_peer_client->core_peer_list);
 	mutex_unlock(&peer_memory_mutex);
 
+	kref_put(&ib_peer_client->ref, complete_peer);
+	wait_for_completion(&ib_peer_client->unload_comp);
 	kfree(ib_peer_client);
 }
 EXPORT_SYMBOL(ib_unregister_peer_memory_client);
+
+struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
+						 size_t size, void **peer_client_context)
+{
+	struct ib_peer_memory_client *ib_peer_client;
+	int ret;
+
+	mutex_lock(&peer_memory_mutex);
+	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_list) {
+		ret = ib_peer_client->peer_mem->acquire(addr, size,
+						   context->peer_mem_private_data,
+						   context->peer_mem_name,
+						   peer_client_context);
+		if (ret > 0)
+			goto found;
+	}
+
+	ib_peer_client = NULL;
+
+found:
+	if (ib_peer_client)
+		kref_get(&ib_peer_client->ref);
+
+	mutex_unlock(&peer_memory_mutex);
+	return ib_peer_client;
+}
+EXPORT_SYMBOL(ib_get_peer_client);
+
+void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
+			void *peer_client_context)
+{
+	if (ib_peer_client->peer_mem->release)
+		ib_peer_client->peer_mem->release(peer_client_context);
+
+	kref_put(&ib_peer_client->ref, complete_peer);
+}
+EXPORT_SYMBOL(ib_put_peer_client);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0600c50..3f5d754 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -326,6 +326,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
 	ucontext->closing = 0;
+	ucontext->peer_mem_private_data = NULL;
+	ucontext->peer_mem_name = NULL;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
 
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index fac37b7..3353ae7 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -3,10 +3,20 @@
 
 #include <rdma/peer_mem.h>
 
+struct ib_ucontext;
+
 struct ib_peer_memory_client {
 	const struct peer_memory_client *peer_mem;
 	struct list_head	core_peer_list;
 	int invalidation_required;
+	struct kref ref;
+	struct completion unload_comp;
 };
 
+struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context, unsigned long addr,
+						 size_t size, void **peer_client_context);
+
+void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
+			void *peer_client_context);
+
 #endif
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ed44cc0..685e0b9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -123,7 +123,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
-	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
+	IB_DEVICE_PEER_MEMORY		= (1<<31)
 };
 
 enum ib_signature_prot_cap {
@@ -1131,6 +1132,8 @@ struct ib_ucontext {
 	struct list_head	xrcd_list;
 	struct list_head	rule_list;
 	int			closing;
+	void		 *peer_mem_private_data;
+	char		 *peer_mem_name;
 };
 
 struct ib_uobject {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
