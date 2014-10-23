From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 6/9] IB/core: Sysfs support for peer memory
Date: Thu, 23 Oct 2014 15:02:54 +0300
Message-ID: <1414065777-21173-7-git-send-email-yishaih@mellanox.com>
References: <1414065777-21173-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414065777-21173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Supplies the required functionality to expose information and
statistics over sysfs for a given peer memory client.

This mechanism enables userspace application to check
which peers are available (based on name & version) and based on that
decides whether it can run successfully.

Root sysfs directory is /sys/kernel/infiniband/<peer_name>, under that directory
will reside some files that represent the statistics for that peer.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/infiniband/peer_memory.txt |   64 +++++++++
 drivers/infiniband/core/core_priv.h      |    2 +
 drivers/infiniband/core/peer_mem.c       |  212 +++++++++++++++++++++++++++++-
 drivers/infiniband/core/sysfs.c          |    6 +
 drivers/infiniband/core/umem.c           |    6 +
 include/rdma/ib_peer_mem.h               |   13 ++
 6 files changed, 302 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/infiniband/peer_memory.txt

diff --git a/Documentation/infiniband/peer_memory.txt b/Documentation/infiniband/peer_memory.txt
new file mode 100644
index 0000000..be5e416
--- /dev/null
+++ b/Documentation/infiniband/peer_memory.txt
@@ -0,0 +1,64 @@
+Peer-Direct technology allows RDMA operations to directly target
+memory in external hardware devices, such as GPU cards, SSD based
+storage, dedicated ASIC accelerators, etc.
+
+This technology allows RDMA-based (over InfiniBand/RoCE) application
+to avoid unneeded data copying when sharing data between peer hardware
+devices.
+
+This file contains documentation for the sysfs interface provided by
+the feature. For documentation of the kernel level interface that peer
+memory clients should implement, please refer to the API documentation
+in include/rdma/peer_mem.h
+
+From the user application perspective, it is free to perform memory
+registration using pointers and handles provided by peer memory
+clients (i.e. OpenCL, Cuda, FPGA-specific handles, etc.). The kernel
+will transparently select the appropriate peer memory client to
+perform the memory registration, as needed.
+
+
+The peer-memory subsystem allows the user to monitor the current usage
+of the technology through a basic sysfs interface. For each peer
+memory client (i.e. GPU type, FPGA, etc.), the following files are
+created:
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/version - the version string
+  of the peer memory client
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_alloc_mrs - the number
+  of memory regions allocated using this peers memory. Note that this
+  counter is not decreased during de-registration of memory regions,
+  it is monotonically increasing. To get the number of memory regions
+  currently allocated on this peer, subtract the value of
+  num_dealloc_mrs from this counter.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_dealloc_mrs - the number
+  of memory regions de-allocated, and were originally using peer
+  memory.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_reg_pages - the amount
+  of peer_name's memory pages that have been mapped through peer
+  direct. Note that this is a monotonically increasing counter. To get
+  the number of pages currently mapped, subtract the value of
+  num_dereg_pages from this counter. Also, pay attention to the fact
+  that this counter is using device pages, which might differ in size
+  from the host memory page size.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_dereg_pages - the amount
+  of peer memory pages that have been unmapped through peer direct for
+  peer_name.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_reg_bytes - the number
+  of bytes that have been mapped through peer direct from
+  peer_name. Note that this is a monotonically increasing counter. To
+  get the number of bytes currently mapped, subtract the value of
+  num_dereg_bytes from this counter.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_dereg_bytes - the number
+  of bytes that have been unmapped through peer direct from peer_name.
+
+* /sys/kernel/infiniband/memory_peers/<peer_name>/num_free_callbacks - the
+  number of times the peer used the "invalidate" callback to free a
+  memory region before the application de-registered the memory
+  region.
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 87d1936..b404699 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,6 +38,8 @@
 
 #include <rdma/ib_verbs.h>
 
+extern struct kobject *infiniband_kobj;
+
 int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
 						   u8, struct kobject *));
diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
index d4cf31c..bf987aa 100644
--- a/drivers/infiniband/core/peer_mem.c
+++ b/drivers/infiniband/core/peer_mem.c
@@ -33,9 +33,211 @@
 #include <rdma/ib_peer_mem.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
+#include "core_priv.h"
 
 static DEFINE_MUTEX(peer_memory_mutex);
 static LIST_HEAD(peer_memory_list);
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
+static ssize_t num_dealloc_mrs_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_dealloc_mrs));
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
+static ssize_t num_reg_bytes_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_reg_bytes));
+		kref_put(&ib_peer_client->ref, complete_peer);
+		return strlen(buf);
+	}
+	/* not found - nothing is return */
+	return 0;
+}
+
+static ssize_t num_dereg_bytes_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct ib_peer_memory_client *ib_peer_client = get_peer_by_kobj(kobj);
+
+	if (ib_peer_client) {
+		sprintf(buf, "%llu\n", (u64)atomic64_read(&ib_peer_client->stats.num_dereg_bytes));
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
+static struct kobj_attribute num_dealloc_mrs = __ATTR_RO(num_dealloc_mrs);
+static struct kobj_attribute num_reg_pages = __ATTR_RO(num_reg_pages);
+static struct kobj_attribute num_dereg_pages = __ATTR_RO(num_dereg_pages);
+static struct kobj_attribute num_reg_bytes = __ATTR_RO(num_reg_bytes);
+static struct kobj_attribute num_dereg_bytes = __ATTR_RO(num_dereg_bytes);
+static struct kobj_attribute num_free_callbacks = __ATTR_RO(num_free_callbacks);
+
+static struct attribute *peer_mem_attrs[] = {
+			&version_attr.attr,
+			&num_alloc_mrs.attr,
+			&num_dealloc_mrs.attr,
+			&num_reg_pages.attr,
+			&num_dereg_pages.attr,
+			&num_reg_bytes.attr,
+			&num_dereg_bytes.attr,
+			&num_free_callbacks.attr,
+			NULL,
+};
+
+static void destroy_peer_sysfs(struct ib_peer_memory_client *ib_peer_client)
+{
+	kobject_put(ib_peer_client->kobj);
+	if (list_empty(&peer_memory_list))
+		kobject_put(peers_kobj);
+}
+
+static int create_peer_sysfs(struct ib_peer_memory_client *ib_peer_client)
+{
+	int ret;
+
+	if (list_empty(&peer_memory_list)) {
+		/* creating under /sys/kernel/infiniband */
+		peers_kobj = kobject_create_and_add("memory_peers", infiniband_kobj);
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
+	if (list_empty(&peer_memory_list))
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
@@ -60,6 +262,7 @@ static int ib_invalidate_peer_memory(void *reg_handle, u64 core_context)
 	int need_unlock = 1;
 
 	mutex_lock(&ib_peer_client->lock);
+	ib_peer_client->stats.num_free_callbacks += 1;
 	core_ticket = ib_peer_search_context(ib_peer_client, core_context);
 	if (!core_ticket)
 		goto out;
@@ -251,9 +454,15 @@ void *ib_register_peer_memory_client(const struct peer_memory_client *peer_clien
 	}
 
 	mutex_lock(&peer_memory_mutex);
+	if (create_peer_sysfs(ib_peer_client)) {
+		kfree(ib_peer_client);
+		ib_peer_client = NULL;
+		goto end;
+	}
 	list_add_tail(&ib_peer_client->core_peer_list, &peer_memory_list);
-	mutex_unlock(&peer_memory_mutex);
+end:
 
+	mutex_unlock(&peer_memory_mutex);
 	return ib_peer_client;
 }
 EXPORT_SYMBOL(ib_register_peer_memory_client);
@@ -264,6 +473,7 @@ void ib_unregister_peer_memory_client(void *reg_handle)
 
 	mutex_lock(&peer_memory_mutex);
 	list_del(&ib_peer_client->core_peer_list);
+	destroy_peer_sysfs(ib_peer_client);
 	mutex_unlock(&peer_memory_mutex);
 
 	kref_put(&ib_peer_client->ref, complete_peer);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cbd0383..eae6fb0 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -40,6 +40,8 @@
 
 #include <rdma/ib_mad.h>
 
+struct kobject *infiniband_kobj;
+
 struct ib_port {
 	struct kobject         kobj;
 	struct ib_device      *ibdev;
@@ -913,10 +915,14 @@ void ib_device_unregister_sysfs(struct ib_device *device)
 
 int ib_sysfs_setup(void)
 {
+	infiniband_kobj = kobject_create_and_add("infiniband", kernel_kobj);
+	if (!infiniband_kobj)
+		return -ENOMEM;
 	return class_register(&ib_class);
 }
 
 void ib_sysfs_cleanup(void)
 {
+	kobject_put(infiniband_kobj);
 	class_unregister(&ib_class);
 }
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6655d12..1fa5447 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -86,6 +86,9 @@ static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
 	if (ret)
 		goto put_pages;
 
+	atomic64_add(umem->nmap, &ib_peer_mem->stats.num_reg_pages);
+	atomic64_add(umem->nmap * umem->page_size, &ib_peer_mem->stats.num_reg_bytes);
+	atomic64_inc(&ib_peer_mem->stats.num_alloc_mrs);
 	return umem;
 
 put_pages:
@@ -114,6 +117,9 @@ static void peer_umem_release(struct ib_umem *umem)
 			    umem->context->device->dma_device);
 	peer_mem->put_pages(&umem->sg_head,
 			    umem->peer_mem_client_context);
+	atomic64_add(umem->nmap, &ib_peer_mem->stats.num_dereg_pages);
+	atomic64_add(umem->nmap * umem->page_size, &ib_peer_mem->stats.num_dereg_bytes);
+	atomic64_inc(&ib_peer_mem->stats.num_dealloc_mrs);
 	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
 	kfree(umem);
 }
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
index 58e0f99..1b865c8 100644
--- a/include/rdma/ib_peer_mem.h
+++ b/include/rdma/ib_peer_mem.h
@@ -3,6 +3,16 @@
 
 #include <rdma/peer_mem.h>
 
+struct ib_peer_memory_statistics {
+	atomic64_t num_alloc_mrs;
+	atomic64_t num_dealloc_mrs;
+	atomic64_t num_reg_pages;
+	atomic64_t num_dereg_pages;
+	atomic64_t num_reg_bytes;
+	atomic64_t num_dereg_bytes;
+	unsigned long num_free_callbacks;
+};
+
 struct ib_ucontext;
 struct ib_umem;
 struct invalidation_ctx;
@@ -17,6 +27,9 @@ struct ib_peer_memory_client {
 	struct mutex lock;
 	struct list_head   core_ticket_list;
 	u64	last_ticket;
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
