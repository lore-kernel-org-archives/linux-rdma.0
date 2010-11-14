From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] RDMA_CM: Netlink Callbacks
Date: Sun, 14 Nov 2010 18:12:53 +0200
Message-ID: <4CE00A85.8060402@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add callbacks and data types for statistics export.
One callback is implemented that exports all of the current devices/ids.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   83 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_cm.h        |   38 +++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6884da2..42dc3ec 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -148,6 +148,7 @@ struct rdma_id_private {
 	u32			qp_num;
 	u8			srq;
 	u8			tos;
+	pid_t			owner;
 };
 
 struct cma_multicast {
@@ -432,6 +433,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
+	id_priv->owner = current->pid;
 	id_priv->state = CMA_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
@@ -752,6 +754,81 @@ static int cma_get_net_info(void *hdr, enum rdma_port_space ps,
 	return 0;
 }
 
+int cma_get_stats_size(int *size)
+{
+	struct cma_device *cma_dev;
+	struct rdma_id_private *id_priv;
+
+	mutex_lock(&lock);
+	*size = sizeof(struct rdma_cm_stats);
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		*size += sizeof(struct rdma_cm_device_stats);
+		list_for_each_entry(id_priv, &cma_dev->id_list, list) {
+			*size += sizeof(struct rdma_cm_id_stats);
+		}
+	}
+	mutex_unlock(&lock);
+	return 0;
+}
+EXPORT_SYMBOL(cma_get_stats_size);
+
+int cma_get_stats(void *buff, int len)
+{
+	struct rdma_id_private *id_priv;
+	struct rdma_cm_id *id = NULL;
+	struct cma_device *cma_dev;
+	void *buff_head;
+	struct rdma_cm_stats *stats;
+	struct rdma_cm_device_stats *cur_device_stats;
+	struct rdma_cm_id_stats *cur_id_stats;
+
+	mutex_lock(&lock);
+	stats = buff;
+	buff_head = stats + 1;
+	stats->num_devices = 0;
+	if (buff_head - buff > len)
+		goto errmem;
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		stats->num_devices++;
+		cur_device_stats = buff_head;
+		buff_head = cur_device_stats + 1;
+		if (buff_head - buff > len)
+			goto errmem;
+		cur_device_stats->num_ids = 0;
+		strncpy(cur_device_stats->name, cma_dev->device->name,
+			IB_DEVICE_NAME_MAX);
+		list_for_each_entry(id_priv, &cma_dev->id_list, list) {
+			cur_device_stats->num_ids++;
+			cur_id_stats = buff_head;
+			buff_head = cur_id_stats + 1;
+			if (buff_head - buff > len)
+				goto errmem;
+			id = &id_priv->id;
+			cur_id_stats->nt = id->route.addr.dev_addr.dev_type;
+			cur_id_stats->port_num = id->port_num;
+			cur_id_stats->bound_dev_if =
+				id->route.addr.dev_addr.bound_dev_if;
+			memcpy(&(cur_id_stats->local_addr),
+				&(id->route.addr.src_addr),
+				sizeof(struct sockaddr));
+			memcpy(&(cur_id_stats->remote_addr),
+				&(id->route.addr.dst_addr),
+				sizeof(struct sockaddr));
+			cur_id_stats->ps = id->ps;
+			cur_id_stats->cma_state = id_priv->state;
+			cur_id_stats->qp_num = id_priv->qp_num;
+			cur_id_stats->pid = id_priv->owner;
+		}
+	}
+	mutex_unlock(&lock);
+	return 0;
+errmem:
+	printk(KERN_INFO "RDMA CM out of buffer space for stats\n");
+	mutex_unlock(&lock);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(cma_get_stats);
+
 static void cma_save_net_info(struct rdma_addr *addr,
 			      struct rdma_addr *listen_addr,
 			      u8 ip_ver, __be16 port,
@@ -2681,8 +2758,14 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
+	unsigned long flags;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+
+	spin_lock_irqsave(&id_priv->lock, flags);
+	id_priv->owner = current->pid;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+
 	if (!cma_comp(id_priv, CMA_CONNECT))
 		return -EINVAL;
 
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 4fae903..a3cd1c7 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -133,6 +133,28 @@ struct rdma_cm_id {
 	u8			 port_num;
 };
 
+struct rdma_cm_id_stats {
+	enum rdma_node_type nt;
+	int port_num;
+	int bound_dev_if;
+	struct sockaddr local_addr;
+	struct sockaddr remote_addr;
+	enum rdma_port_space ps;
+	int cma_state;
+	int qp_num;
+	pid_t pid;
+};
+
+struct rdma_cm_device_stats {
+	char name[IB_DEVICE_NAME_MAX];
+	int num_ids;
+};
+
+struct rdma_cm_stats {
+	int num_devices;
+};
+
+
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
@@ -329,4 +351,20 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr);
  */
 void rdma_set_service_type(struct rdma_cm_id *id, int tos);
 
+/**
+ * cma_get_stats_size - Return the number of needed bytes of all
+ *   current stats for ib_netlink.
+ * @size: The size to fill
+ */
+int cma_get_stats_size(int *size);
+
+
+/**
+ * cma_get_stats - Fill a buffer with all of the current devices/id's that
+     are held by rdma cm.
+ * @buff: An empty buffer to fill
+ * @len: Maximum available length for writing.
+ */
+int cma_get_stats(void *buff, int len);
+
 #endif /* RDMA_CM_H */
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
