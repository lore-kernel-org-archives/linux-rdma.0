From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/core: Sysfs support for peer memory
Date: Wed,  1 Oct 2014 18:18:34 +0300
Message-ID: <1412176717-11979-7-git-send-email-yishaih@mellanox.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412176717-11979-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Supplies the required functionality to expose information and
statistics over sysfs for a given peer memory client.

This mechanism enables userspace application to check
which peers are available (based on name & version) and based on that
decides whether it can run successfully.

Root sysfs directory is /sys/kernel/mm/<peer_name>, under that directory
will reside some files that represent the statistics for that peer.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/peer_mem.c |  162 +++++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/umem.c     |    4 +
 include/rdma/ib_peer_mem.h         |   11 +++
 3 files changed, 176 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index d6bd192..74ec8b4 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -37,6 +37,159 @@
 static DEFINE_MUTEX(peer_memory_mutex);
 static LIST_HEAD(peer_memory_list);
 static int num_registered_peers;
+static struct kobject *peers_kobj;
+
+static void complete_peer(struct kref *kref);
+static struct ib_peer_memory_client *get_peer_by_kobj(void *kobj);
+static ssize_t version_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%s\n", ib_peer_client->peer_mem->version);
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static ssize_t num_alloc_mrs_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_alloc_mrs));
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static ssize_t num_reg_pages_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_reg_pages));
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static ssize_t num_dereg_pages_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_dereg_pages));
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static ssize_t num_free_callbacks_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%lu\n", ib_peer_client->stats.num_free_callbacks);
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static struct kobj_attribute version_attr = __ATTR_RO(version);
+static struct kobj_attribute num_alloc_mrs = __ATTR_RO(num_alloc_mrs);
+static struct kobj_attribute num_reg_pages = __ATTR_RO(num_reg_pages);
+static struct kobj_attribute num_dereg_pages = __ATTR_RO(num_dereg_pages);
+static struct kobj_attribute num_free_callbacks = __ATTR_RO(num_free_callbacks);
+
+static struct attribute *peer_mem_attrs[] = {
+			&version_attr.attr,
+			&num_alloc_mrs.attr,
+			&num_reg_pages.attr,
+			&num_dereg_pages.attr,
+			&num_free_callbacks.attr,
+			NULL,
+};
+
+static void destroy_peer_sysfs(struct ib_peer_memory_client *ib_peer_client)
+{
+	kobject_put(ib_peer_client->kobj);
+	if (!num_registered_peers)
+		kobject_put(peers_kobj);
+}
+
+static int create_peer_sysfs(struct ib_peer_memory_client *ib_peer_client)
+{
+	int ret;
+
+	if (!num_registered_peers) {
+		/* creating under /sys/kernel/mm */
+		peers_kobj = kobject_create_and_add("memory_peers", mm_kobj);
+		if (!peers_kobj)
+			return -ENOMEM;
+	}
+
+	ib_peer_client->peer_mem_attr_group.attrs = peer_mem_attrs;
+	/* Dir alreday was created explicitly to get its kernel object for further usage */
+	ib_peer_client->peer_mem_attr_group.name =  NULL;
+	ib_peer_client->kobj = kobject_create_and_add(ib_peer_client->peer_mem->name,
+		peers_kobj);
+
+	if (!ib_peer_client->kobj) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	/* Create the files associated with this kobject */
+	ret = sysfs_create_group(ib_peer_client->kobj,
+				 &ib_peer_client->peer_mem_attr_group);
+	if (ret)
+		goto peer_free;
+
+	return 0;
+
+peer_free:
+	kobject_put(ib_peer_client->kobj);
+
+free:
+	if (!num_registered_peers)
+		kobject_put(peers_kobj);
+
+	return ret;
+}
+
+static struct ib_peer_memory_client *get_peer_by_kobj(void *kobj)
+{
+	struct ib_peer_memory_client *ib_peer_client;
+
+	mutex_lock(&peer_memory_mutex);
+	list_for_each_entry(ib_peer_client, &peer_memory_list, core_peer_list) {
+		if (ib_peer_client->kobj == kobj) {
+			kref_get(&ib_peer_client->ref);
+			goto found;
+		}
+	}
+
+	ib_peer_client = NULL;
+found:
+	mutex_unlock(&peer_memory_mutex);
+	return ib_peer_client;
+}
 
 /* Caller should be holding the peer client lock, ib_peer_client->lock */
 static struct core_ticket *ib_peer_search_context(struct ib_peer_memory_client *ib_peer_client,
@@ -62,6 +215,7 @@ static int ib_invalidate_peer_memory(void *reg_handle, void *core_context)
 	int need_unlock = 1;
 
 	mutex_lock(&ib_peer_client->lock);
+	ib_peer_client->stats.num_free_callbacks += 1;
 	core_ticket = ib_peer_search_context(ib_peer_client,
 					     (unsigned long)core_context);
 	if (!core_ticket)
@@ -303,10 +457,15 @@ void *ib_register_peer_memory_client(const struct peer_memory_client *peer_clien
 		ib_peer_client->invalidation_required = 1;
 	}
 	mutex_lock(&peer_memory_mutex);
+	if (create_peer_sysfs(ib_peer_client)) {
+		kfree(ib_peer_client);
+		ib_peer_client = NULL;
+		goto end;
+	}
 	list_add_tail(&ib_peer_client->core_peer_list, &peer_memory_list);
 	num_registered_peers++;
+end:
 	mutex_unlock(&peer_memory_mutex);
-
 	return ib_peer_client;
 }
 EXPORT_SYMBOL(ib_register_peer_memory_client);
@@ -319,6 +478,7 @@ void ib_unregister_peer_memory_client(void *reg_handle)
 	mutex_lock(&peer_memory_mutex);
 	list_del(&ib_peer_client->core_peer_list);
 	num_registered_peers--;
+	destroy_peer_sysfs(ib_peer_client);
 	mutex_unlock(&peer_memory_mutex);
 	kref_put(&ib_peer_client->ref, complete_peer);
 	wait_for_completion(&ib_peer_client->unload_comp);
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 51f32a1..9df5616 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -87,6 +87,8 @@ static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 	if (ret)
 		goto put_pages;
 
+	atomic64_add(umem->nmap * (umem->page_size >> PAGE_SHIFT), &ib_peer_mem->stats.num_reg_pages);
+	atomic64_inc(&ib_peer_mem->stats.num_alloc_mrs);
 	return umem;
 
 put_pages:
@@ -115,6 +117,8 @@ static void peer_umem_release(struct ib_umem *umem)
 			    umem->context->device->dma_device);
 	peer_mem->put_pages(&umem->sg_head,
 			    umem->peer_mem_client_context);
+	atomic64_add(umem->nmap * (umem->page_size >> PAGE_SHIFT), &ib_peer_mem->stats.num_dereg_pages);
+	atomic64_inc(&ib_peer_mem->stats.num_dealloc_mrs);
 	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	kfree(umem);
 }
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 8f67aaf..4b1ae14 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -3,6 +3,14 @@
 
 #include <rdma/peer_mem.h>
 
+struct ib_peer_memory_statistics {
+	atomic64_t num_alloc_mrs;
+	atomic64_t num_dealloc_mrs;
+	atomic64_t num_reg_pages;
+	atomic64_t num_dereg_pages;
+	unsigned long num_free_callbacks;
+};
+
 struct ib_ucontext;
 struct ib_umem;
 struct invalidation_ctx;
@@ -18,6 +26,9 @@ struct ib_peer_memory_client {
 	struct list_head   core_ticket_list;
 	unsigned long       last_ticket;
 	int ticket_wrapped;
+	struct kobject *kobj;
+	struct attribute_group peer_mem_attr_group;
+	struct ib_peer_memory_statistics stats;
 };
 
 enum ib_peer_mem_flags {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
