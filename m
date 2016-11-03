From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 02/17] IB/core: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:10 +0200
Message-ID: <1478184265-9620-3-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/agent.c         |  1 -
 drivers/infiniband/core/device.c        |  5 +----
 drivers/infiniband/core/fmr_pool.c      |  1 -
 drivers/infiniband/core/iwpm_msg.c      |  1 -
 drivers/infiniband/core/iwpm_util.c     | 12 ++++--------
 drivers/infiniband/core/roce_gid_mgmt.c | 21 ++++++---------------
 6 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 4fa524d..11dacd9 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -156,7 +156,6 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
 	if (!port_priv) {
-		dev_err(&device->dev, "No memory for ib_agent_port_private\n");
 		ret = -ENOMEM;
 		goto error1;
 	}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 760ef60..571974c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -254,11 +254,8 @@ static int add_client_context(struct ib_device *device, struct ib_client *client
 	unsigned long flags;
 
 	context = kmalloc(sizeof *context, GFP_KERNEL);
-	if (!context) {
-		pr_warn("Couldn't allocate client context for %s/%s\n",
-			device->name, client->name);
+	if (!context)
 		return -ENOMEM;
-	}
 
 	context->client = client;
 	context->data   = NULL;
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index cdbb1f1..cdfad5f 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -247,7 +247,6 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 			kmalloc(IB_FMR_HASH_SIZE * sizeof *pool->cache_bucket,
 				GFP_KERNEL);
 		if (!pool->cache_bucket) {
-			pr_warn(PFX "Failed to allocate cache in pool\n");
 			ret = -ENOMEM;
 			goto out_free_pool;
 		}
diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 1c41b95..a0e7c16 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -604,7 +604,6 @@ int iwpm_remote_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rem_info = kzalloc(sizeof(struct iwpm_remote_info), GFP_ATOMIC);
 	if (!rem_info) {
-		pr_err("%s: Unable to allocate a remote info\n", __func__);
 		ret = -ENOMEM;
 		return ret;
 	}
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index ade71e7..3ef51a9 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -62,7 +62,6 @@ int iwpm_init(u8 nl_client)
 					sizeof(struct hlist_head), GFP_KERNEL);
 		if (!iwpm_hash_bucket) {
 			ret = -ENOMEM;
-			pr_err("%s Unable to create mapinfo hash table\n", __func__);
 			goto init_exit;
 		}
 		iwpm_reminfo_bucket = kzalloc(IWPM_REMINFO_HASH_SIZE *
@@ -70,7 +69,6 @@ int iwpm_init(u8 nl_client)
 		if (!iwpm_reminfo_bucket) {
 			kfree(iwpm_hash_bucket);
 			ret = -ENOMEM;
-			pr_err("%s Unable to create reminfo hash table\n", __func__);
 			goto init_exit;
 		}
 	}
@@ -128,10 +126,9 @@ int iwpm_create_mapinfo(struct sockaddr_storage *local_sockaddr,
 	if (!iwpm_valid_client(nl_client))
 		return ret;
 	map_info = kzalloc(sizeof(struct iwpm_mapping_info), GFP_KERNEL);
-	if (!map_info) {
-		pr_err("%s: Unable to allocate a mapping info\n", __func__);
+	if (!map_info)
 		return -ENOMEM;
-	}
+
 	memcpy(&map_info->local_sockaddr, local_sockaddr,
 	       sizeof(struct sockaddr_storage));
 	memcpy(&map_info->mapped_sockaddr, mapped_sockaddr,
@@ -309,10 +306,9 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	unsigned long flags;
 
 	nlmsg_request = kzalloc(sizeof(struct iwpm_nlmsg_request), gfp);
-	if (!nlmsg_request) {
-		pr_err("%s Unable to allocate a nlmsg_request\n", __func__);
+	if (!nlmsg_request)
 		return NULL;
-	}
+
 	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
 	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
 	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 06556c3..c86ddce 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -304,10 +304,9 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 	for_ifa(in_dev) {
 		struct sin_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 
-		if (!entry) {
-			pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv4 update\n");
+		if (!entry)
 			continue;
-		}
+
 		entry->ip.sin_family = AF_INET;
 		entry->ip.sin_addr.s_addr = ifa->ifa_address;
 		list_add_tail(&entry->list, &sin_list);
@@ -348,10 +347,8 @@ static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
 	list_for_each_entry(ifp, &in6_dev->addr_list, if_list) {
 		struct sin6_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 
-		if (!entry) {
-			pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv6 update\n");
+		if (!entry)
 			continue;
-		}
 
 		entry->sin6.sin6_family = AF_INET6;
 		entry->sin6.sin6_addr = ifp->addr;
@@ -459,10 +456,8 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
 		struct upper_list *entry = kmalloc(sizeof(*entry),
 						   GFP_ATOMIC);
 
-		if (!entry) {
-			pr_info("roce_gid_mgmt: couldn't allocate entry to delete ndev\n");
+		if (!entry)
 			continue;
-		}
 
 		list_add_tail(&entry->list, &upper_list);
 		dev_hold(upper);
@@ -555,10 +550,8 @@ static int netdevice_queue_work(struct netdev_event_work_cmd *cmds,
 	struct netdev_event_work *ndev_work =
 		kmalloc(sizeof(*ndev_work), GFP_KERNEL);
 
-	if (!ndev_work) {
-		pr_warn("roce_gid_mgmt: can't allocate work for netdevice_event\n");
+	if (!ndev_work)
 		return NOTIFY_DONE;
-	}
 
 	memcpy(ndev_work->cmds, cmds, sizeof(ndev_work->cmds));
 	for (i = 0; i < ARRAY_SIZE(ndev_work->cmds) && ndev_work->cmds[i].cb; i++) {
@@ -692,10 +685,8 @@ static int addr_event(struct notifier_block *this, unsigned long event,
 	}
 
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (!work) {
-		pr_warn("roce_gid_mgmt: Couldn't allocate work for addr_event\n");
+	if (!work)
 		return NOTIFY_DONE;
-	}
 
 	INIT_WORK(&work->work, update_gid_event_work_handler);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
