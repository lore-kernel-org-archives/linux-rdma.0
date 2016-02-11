From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 2/7] IB/core: Get/put peer memory client
Date: Thu, 11 Feb 2016 18:12:52 +0200
Message-ID: <1455207177-11949-3-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
- an extra device capability named IB_DEVICE_PEER_MEMORY was introduced,
  to be used by low level drivers to mark that they support this
  functionality.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c | 55 ++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_peer_mem.h         | 12 +++++++++
 include/rdma/ib_verbs.h            |  5 ++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index 2c26a39..74e4caa 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -42,6 +42,14 @@ static int ib_invalidate_peer_memory(void *reg_handle, u64 core_context)
 	return -ENOSYS;
 }
 
+static void complete_peer(struct kref *kref)
+{
+	struct ib_peer_memory_client *ib_peer_client =
+		container_of(kref, struct ib_peer_memory_client, ref);
+
+	complete(&ib_peer_client->unload_comp);
+}
+
 void *ib_register_peer_memory_client(struct peer_memory_client *peer_client,
 				     int (**invalidate_callback)
 				     (void *reg_handle, u64 core_context))
@@ -52,6 +60,8 @@ void *ib_register_peer_memory_client(struct peer_memory_client *peer_client,
 	if (!ib_peer_client)
 		return NULL;
 
+	init_completion(&ib_peer_client->unload_comp);
+	kref_init(&ib_peer_client->ref);
 	ib_peer_client->peer_mem = peer_client;
 	/* Once peer supplied a non NULL callback it's an indication that
 	 * invalidation support is required for any memory owning.
@@ -77,6 +87,51 @@ void ib_unregister_peer_memory_client(void *reg_handle)
 	list_del(&ib_peer_client->core_peer_list);
 	mutex_unlock(&peer_memory_mutex);
 
+	kref_put(&ib_peer_client->ref, complete_peer);
+	wait_for_completion(&ib_peer_client->unload_comp);
 	kfree(ib_peer_client);
 }
 EXPORT_SYMBOL(ib_unregister_peer_memory_client);
+
+struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context,
+						 unsigned long addr,
+						 size_t size,
+						 void **peer_client_context)
+{
+	struct ib_peer_memory_client *ib_peer_client;
+	int ret;
+
+	mutex_lock(&peer_memory_mutex);
+	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_list) {
+		ret = ib_peer_client->peer_mem->acquire(addr, size,
+							peer_client_context);
+		if (ret > 0)
+			goto found;
+
+		if (ret < 0) {
+			mutex_unlock(&peer_memory_mutex);
+			return ERR_PTR(ret);
+		}
+	}
+
+	ib_peer_client = NULL;
+
+found:
+	mutex_unlock(&peer_memory_mutex);
+
+	if (ib_peer_client)
+		kref_get(&ib_peer_client->ref);
+
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
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index cbe928e..7f41ce5 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -35,10 +35,22 @@
 
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
 
+struct ib_peer_memory_client *ib_get_peer_client(struct ib_ucontext *context,
+						 unsigned long addr,
+						 size_t size,
+						 void **peer_client_context);
+
+void ib_put_peer_client(struct ib_peer_memory_client *ib_peer_client,
+			void *peer_client_context);
+
 #endif
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 284b00c..3917230 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -209,6 +209,11 @@ enum ib_device_cap_flags {
 	 * by hardware.
 	 */
 	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
+	/*
+	 * Device supports RDMA access to memory registered by
+	 * other locally connected devices (e.g. GPU).
+	 */
+	IB_DEVICE_PEER_MEMORY			= (1 << 28),
 	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
