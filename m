From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 01/13] IB/core: lock client data with lists_rwsem
Date: Wed, 29 Jul 2015 14:06:19 +0300
Message-ID: <1438167991-17211-2-git-send-email-haggaie@mellanox.com>
References: <1438167991-17211-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438167991-17211-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

An ib_client callback that is called with the lists_rwsem locked only for
read is protected from changes to the IB client lists, but not from
ib_unregister_device() freeing its client data. This is because
ib_unregister_device() will remove the device from the device list with
lists_rwsem locked for write, but perform the rest of the cleanup,
including the call to remove() without that lock.

Mark client data that is undergoing de-registration with a new going_down
flag in the client data context. Lock the client data list with lists_rwsem
for write in addition to using the spinlock, so that functions calling the
callback would be able to lock only lists_rwsem for read and let callbacks
sleep.

Since ib_unregister_client() now marks the client data context, no need for
remove() to search the context again, so pass the client data directly to
remove() callbacks.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c           |  2 +-
 drivers/infiniband/core/cm.c              |  7 ++--
 drivers/infiniband/core/cma.c             |  7 ++--
 drivers/infiniband/core/device.c          | 53 +++++++++++++++++++++++++------
 drivers/infiniband/core/mad.c             |  2 +-
 drivers/infiniband/core/multicast.c       |  7 ++--
 drivers/infiniband/core/sa_query.c        |  6 ++--
 drivers/infiniband/core/ucm.c             |  6 ++--
 drivers/infiniband/core/user_mad.c        |  6 ++--
 drivers/infiniband/core/uverbs_main.c     |  6 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  7 ++--
 drivers/infiniband/ulp/srp/ib_srp.c       |  6 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c     |  5 ++-
 include/rdma/ib_verbs.h                   |  4 ++-
 net/rds/ib.c                              |  5 ++-
 net/rds/iw.c                              |  5 ++-
 16 files changed, 82 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 871da832d016..c93af66cc091 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -394,7 +394,7 @@ err:
 	kfree(device->cache.lmc_cache);
 }
 
-static void ib_cache_cleanup_one(struct ib_device *device)
+static void ib_cache_cleanup_one(struct ib_device *device, void *client_data)
 {
 	int p;
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3a972ebf3c0d..82d5c4362aa8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -58,7 +58,7 @@ MODULE_DESCRIPTION("InfiniBand CM");
 MODULE_LICENSE("Dual BSD/GPL");
 
 static void cm_add_one(struct ib_device *device);
-static void cm_remove_one(struct ib_device *device);
+static void cm_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client cm_client = {
 	.name   = "cm",
@@ -3886,9 +3886,9 @@ free:
 	kfree(cm_dev);
 }
 
-static void cm_remove_one(struct ib_device *ib_device)
+static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 {
-	struct cm_device *cm_dev;
+	struct cm_device *cm_dev = client_data;
 	struct cm_port *port;
 	struct ib_port_modify port_modify = {
 		.clr_port_cap_mask = IB_PORT_CM_SUP
@@ -3896,7 +3896,6 @@ static void cm_remove_one(struct ib_device *ib_device)
 	unsigned long flags;
 	int i;
 
-	cm_dev = ib_get_client_data(ib_device, &cm_client);
 	if (!cm_dev)
 		return;
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 143ded2bbe7c..6b6cdfa5d231 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -94,7 +94,7 @@ const char *rdma_event_msg(enum rdma_cm_event_type event)
 EXPORT_SYMBOL(rdma_event_msg);
 
 static void cma_add_one(struct ib_device *device);
-static void cma_remove_one(struct ib_device *device);
+static void cma_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client cma_client = {
 	.name   = "cma",
@@ -3551,11 +3551,10 @@ static void cma_process_remove(struct cma_device *cma_dev)
 	wait_for_completion(&cma_dev->comp);
 }
 
-static void cma_remove_one(struct ib_device *device)
+static void cma_remove_one(struct ib_device *device, void *client_data)
 {
-	struct cma_device *cma_dev;
+	struct cma_device *cma_dev = client_data;
 
-	cma_dev = ib_get_client_data(device, &cma_client);
 	if (!cma_dev)
 		return;
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f08d438205ed..623d8e191ced 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -50,6 +50,9 @@ struct ib_client_data {
 	struct list_head  list;
 	struct ib_client *client;
 	void *            data;
+	/* The device or client is going down. Do not call client or device
+	 * callbacks other than remove(). */
+	bool		  going_down;
 };
 
 struct workqueue_struct *ib_wq;
@@ -69,6 +72,8 @@ static LIST_HEAD(client_list);
  * to the lists must be done with a write lock. A special case is when the
  * device_mutex is locked. In this case locking the lists for read access is
  * not necessary as the device_mutex implies it.
+ *
+ * lists_rwsem also protects access to the client data list.
  */
 static DEFINE_MUTEX(device_mutex);
 static DECLARE_RWSEM(lists_rwsem);
@@ -210,10 +215,13 @@ static int add_client_context(struct ib_device *device, struct ib_client *client
 
 	context->client = client;
 	context->data   = NULL;
+	context->going_down = false;
 
+	down_write(&lists_rwsem);
 	spin_lock_irqsave(&device->client_data_lock, flags);
 	list_add(&context->list, &device->client_data_list);
 	spin_unlock_irqrestore(&device->client_data_lock, flags);
+	up_write(&lists_rwsem);
 
 	return 0;
 }
@@ -340,7 +348,6 @@ EXPORT_SYMBOL(ib_register_device);
  */
 void ib_unregister_device(struct ib_device *device)
 {
-	struct ib_client *client;
 	struct ib_client_data *context, *tmp;
 	unsigned long flags;
 
@@ -348,20 +355,29 @@ void ib_unregister_device(struct ib_device *device)
 
 	down_write(&lists_rwsem);
 	list_del(&device->core_list);
-	up_write(&lists_rwsem);
+	spin_lock_irqsave(&device->client_data_lock, flags);
+	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
+		context->going_down = true;
+	spin_unlock_irqrestore(&device->client_data_lock, flags);
+	downgrade_write(&lists_rwsem);
 
-	list_for_each_entry_reverse(client, &client_list, list)
-		if (client->remove)
-			client->remove(device);
+	list_for_each_entry_safe(context, tmp, &device->client_data_list,
+				 list) {
+		if (context->client->remove)
+			context->client->remove(device, context->data);
+	}
+	up_read(&lists_rwsem);
 
 	mutex_unlock(&device_mutex);
 
 	ib_device_unregister_sysfs(device);
 
+	down_write(&lists_rwsem);
 	spin_lock_irqsave(&device->client_data_lock, flags);
 	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
 		kfree(context);
 	spin_unlock_irqrestore(&device->client_data_lock, flags);
+	up_write(&lists_rwsem);
 
 	device->reg_state = IB_DEV_UNREGISTERED;
 }
@@ -421,16 +437,35 @@ void ib_unregister_client(struct ib_client *client)
 	up_write(&lists_rwsem);
 
 	list_for_each_entry(device, &device_list, core_list) {
-		if (client->remove)
-			client->remove(device);
+		struct ib_client_data *found_context = NULL;
 
+		down_write(&lists_rwsem);
 		spin_lock_irqsave(&device->client_data_lock, flags);
 		list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
 			if (context->client == client) {
-				list_del(&context->list);
-				kfree(context);
+				context->going_down = true;
+				found_context = context;
+				break;
 			}
 		spin_unlock_irqrestore(&device->client_data_lock, flags);
+		up_write(&lists_rwsem);
+
+		if (client->remove)
+			client->remove(device, found_context ?
+					       found_context->data : NULL);
+
+		if (!found_context) {
+			pr_warn("No client context found for %s/%s\n",
+				device->name, client->name);
+			continue;
+		}
+
+		down_write(&lists_rwsem);
+		spin_lock_irqsave(&device->client_data_lock, flags);
+		list_del(&found_context->list);
+		kfree(found_context);
+		spin_unlock_irqrestore(&device->client_data_lock, flags);
+		up_write(&lists_rwsem);
 	}
 
 	mutex_unlock(&device_mutex);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 786fc51bf04b..66b4b3eb8f67 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3335,7 +3335,7 @@ error:
 	}
 }
 
-static void ib_mad_remove_device(struct ib_device *device)
+static void ib_mad_remove_device(struct ib_device *device, void *client_data)
 {
 	int i;
 
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 2cb865c7ce7a..d38d8b2b2979 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -43,7 +43,7 @@
 #include "sa.h"
 
 static void mcast_add_one(struct ib_device *device);
-static void mcast_remove_one(struct ib_device *device);
+static void mcast_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client mcast_client = {
 	.name   = "ib_multicast",
@@ -840,13 +840,12 @@ static void mcast_add_one(struct ib_device *device)
 	ib_register_event_handler(&dev->event_handler);
 }
 
-static void mcast_remove_one(struct ib_device *device)
+static void mcast_remove_one(struct ib_device *device, void *client_data)
 {
-	struct mcast_device *dev;
+	struct mcast_device *dev = client_data;
 	struct mcast_port *port;
 	int i;
 
-	dev = ib_get_client_data(device, &mcast_client);
 	if (!dev)
 		return;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index ca919f429666..d40be3673b79 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -107,7 +107,7 @@ struct ib_sa_mcmember_query {
 };
 
 static void ib_sa_add_one(struct ib_device *device);
-static void ib_sa_remove_one(struct ib_device *device);
+static void ib_sa_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client sa_client = {
 	.name   = "sa",
@@ -1221,9 +1221,9 @@ free:
 	return;
 }
 
-static void ib_sa_remove_one(struct ib_device *device)
+static void ib_sa_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ib_sa_device *sa_dev = ib_get_client_data(device, &sa_client);
+	struct ib_sa_device *sa_dev = client_data;
 	int i;
 
 	if (!sa_dev)
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 009481073644..8cde48b96f19 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -109,7 +109,7 @@ enum {
 #define IB_UCM_BASE_DEV MKDEV(IB_UCM_MAJOR, IB_UCM_BASE_MINOR)
 
 static void ib_ucm_add_one(struct ib_device *device);
-static void ib_ucm_remove_one(struct ib_device *device);
+static void ib_ucm_remove_one(struct ib_device *device, void *client_data);
 
 static struct ib_client ucm_client = {
 	.name   = "ucm",
@@ -1310,9 +1310,9 @@ err:
 	return;
 }
 
-static void ib_ucm_remove_one(struct ib_device *device)
+static void ib_ucm_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ib_ucm_device *ucm_dev = ib_get_client_data(device, &ucm_client);
+	struct ib_ucm_device *ucm_dev = client_data;
 
 	if (!ucm_dev)
 		return;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 35567fffaa4e..57f281f8d686 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -133,7 +133,7 @@ static DEFINE_SPINLOCK(port_lock);
 static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORTS);
 
 static void ib_umad_add_one(struct ib_device *device);
-static void ib_umad_remove_one(struct ib_device *device);
+static void ib_umad_remove_one(struct ib_device *device, void *client_data);
 
 static void ib_umad_release_dev(struct kobject *kobj)
 {
@@ -1322,9 +1322,9 @@ free:
 	kobject_put(&umad_dev->kobj);
 }
 
-static void ib_umad_remove_one(struct ib_device *device)
+static void ib_umad_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ib_umad_device *umad_dev = ib_get_client_data(device, &umad_client);
+	struct ib_umad_device *umad_dev = client_data;
 	int i;
 
 	if (!umad_dev)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f6eef2da7097..46c92294afa5 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -128,7 +128,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
-static void ib_uverbs_remove_one(struct ib_device *device);
+static void ib_uverbs_remove_one(struct ib_device *device, void *client_data);
 
 static void ib_uverbs_release_dev(struct kref *ref)
 {
@@ -948,9 +948,9 @@ err:
 	return;
 }
 
-static void ib_uverbs_remove_one(struct ib_device *device)
+static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ib_uverbs_device *uverbs_dev = ib_get_client_data(device, &uverbs_client);
+	struct ib_uverbs_device *uverbs_dev = client_data;
 
 	if (!uverbs_dev)
 		return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b2943c84a5dd..cca1a0c91ec4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -89,7 +89,7 @@ struct workqueue_struct *ipoib_workqueue;
 struct ib_sa_client ipoib_sa_client;
 
 static void ipoib_add_one(struct ib_device *device);
-static void ipoib_remove_one(struct ib_device *device);
+static void ipoib_remove_one(struct ib_device *device, void *client_data);
 static void ipoib_neigh_reclaim(struct rcu_head *rp);
 
 static struct ib_client ipoib_client = {
@@ -1715,12 +1715,11 @@ static void ipoib_add_one(struct ib_device *device)
 	ib_set_client_data(device, &ipoib_client, dev_list);
 }
 
-static void ipoib_remove_one(struct ib_device *device)
+static void ipoib_remove_one(struct ib_device *device, void *client_data)
 {
 	struct ipoib_dev_priv *priv, *tmp;
-	struct list_head *dev_list;
+	struct list_head *dev_list = client_data;
 
-	dev_list = ib_get_client_data(device, &ipoib_client);
 	if (!dev_list)
 		return;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31a20b462266..7755df444cfd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -131,7 +131,7 @@ MODULE_PARM_DESC(ch_count,
 		 "Number of RDMA channels to use for communication with an SRP target. Using more than one channel improves performance if the HCA supports multiple completion vectors. The default value is the minimum of four times the number of online CPU sockets and the number of completion vectors supported by the HCA.");
 
 static void srp_add_one(struct ib_device *device);
-static void srp_remove_one(struct ib_device *device);
+static void srp_remove_one(struct ib_device *device, void *client_data);
 static void srp_recv_completion(struct ib_cq *cq, void *ch_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *ch_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
@@ -3460,13 +3460,13 @@ free_attr:
 	kfree(dev_attr);
 }
 
-static void srp_remove_one(struct ib_device *device)
+static void srp_remove_one(struct ib_device *device, void *client_data)
 {
 	struct srp_device *srp_dev;
 	struct srp_host *host, *tmp_host;
 	struct srp_target_port *target;
 
-	srp_dev = ib_get_client_data(device, &srp_client);
+	srp_dev = client_data;
 	if (!srp_dev)
 		return;
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 60ff0a2390e5..4c59ceb40fff 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3326,12 +3326,11 @@ err:
 /**
  * srpt_remove_one() - InfiniBand device removal callback function.
  */
-static void srpt_remove_one(struct ib_device *device)
+static void srpt_remove_one(struct ib_device *device, void *client_data)
 {
-	struct srpt_device *sdev;
+	struct srpt_device *sdev = client_data;
 	int i;
 
-	sdev = ib_get_client_data(device, &srpt_client);
 	if (!sdev) {
 		pr_info("%s(%s): nothing to do.\n", __func__, device->name);
 		return;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e3b2e7..5b83e0c10d55 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1550,6 +1550,8 @@ struct ib_device {
 
 	spinlock_t                    client_data_lock;
 	struct list_head              core_list;
+	/* Access to the client_data_list is protected by the client_data_lock
+	 * spinlock and the lists_rwsem read-write semaphore */
 	struct list_head              client_data_list;
 
 	struct ib_cache               cache;
@@ -1761,7 +1763,7 @@ struct ib_device {
 struct ib_client {
 	char  *name;
 	void (*add)   (struct ib_device *);
-	void (*remove)(struct ib_device *);
+	void (*remove)(struct ib_device *, void *client_data);
 
 	struct list_head list;
 };
diff --git a/net/rds/ib.c b/net/rds/ib.c
index ba2dffeff608..348ac37c1161 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -230,11 +230,10 @@ struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device)
  *
  * This can be called at any time and can be racing with any other RDS path.
  */
-static void rds_ib_remove_one(struct ib_device *device)
+static void rds_ib_remove_one(struct ib_device *device, void *client_data)
 {
-	struct rds_ib_device *rds_ibdev;
+	struct rds_ib_device *rds_ibdev = client_data;
 
-	rds_ibdev = ib_get_client_data(device, &rds_ib_client);
 	if (!rds_ibdev)
 		return;
 
diff --git a/net/rds/iw.c b/net/rds/iw.c
index 589935661d66..7cc2f32a0cb3 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -125,12 +125,11 @@ free_attr:
 	kfree(dev_attr);
 }
 
-static void rds_iw_remove_one(struct ib_device *device)
+static void rds_iw_remove_one(struct ib_device *device, void *client_data)
 {
-	struct rds_iw_device *rds_iwdev;
+	struct rds_iw_device *rds_iwdev = client_data;
 	struct rds_iw_cm_id *i_cm_id, *next;
 
-	rds_iwdev = ib_get_client_data(device, &rds_iw_client);
 	if (!rds_iwdev)
 		return;
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
