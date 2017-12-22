From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 5/9] i40iw: Selectively teardown QPs on IP addr change event
Date: Fri, 22 Dec 2017 14:29:28 -0600
Message-ID: <20171222202932.9324-6-shiraz.saleem@intel.com>
References: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222202932.9324-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On IP address change event, all connected QPs are torn down
irrespective of whether IP address is involved in a connection.

Only teardown connections those source or destination address
matches the netdev interface IP address being changed, and if
they are on the same VLAN as the netdev.

Fixes: e5e74b61b165 ("i40iw: Add IP addr handling on netdev events")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c   | 27 +++++++++++++++++++--------
 drivers/infiniband/hw/i40iw/i40iw_cm.h   |  3 ++-
 drivers/infiniband/hw/i40iw/i40iw_main.c |  2 +-
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 03e6fc6..7810642 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -4228,10 +4228,15 @@ static void i40iw_qhash_ctrl(struct i40iw_device *iwdev,
 }
 
 /**
- * i40iw_cm_disconnect_all - disconnect all connected qp's
+ * i40iw_cm_teardown_connections - teardown QPs
  * @iwdev: device pointer
+ * @ipaddr: Pointer to IPv4 or IPv6 address
+ * @ipv4: flag indicating IPv4 when true
+ * @disconnect_all: flag indicating disconnect all QPs
+ * teardown QPs where source or destination addr matches ip addr
  */
-void i40iw_cm_disconnect_all(struct i40iw_device *iwdev)
+void i40iw_cm_teardown_connections(struct i40iw_device *iwdev, u32 *ipaddr,
+				   struct i40iw_cm_info *nfo, bool disconnect_all)
 {
 	struct i40iw_cm_core *cm_core = &iwdev->cm_core;
 	struct list_head *list_core_temp;
@@ -4245,8 +4250,13 @@ void i40iw_cm_disconnect_all(struct i40iw_device *iwdev)
 	spin_lock_irqsave(&cm_core->ht_lock, flags);
 	list_for_each_safe(list_node, list_core_temp, &cm_core->connected_nodes) {
 		cm_node = container_of(list_node, struct i40iw_cm_node, list);
-		atomic_inc(&cm_node->ref_count);
-		list_add(&cm_node->connected_entry, &connected_list);
+		if (disconnect_all ||
+		    (nfo->vlan_id == cm_node->vlan_id &&
+		    (!memcmp(cm_node->loc_addr, ipaddr, nfo->ipv4 ? 4 : 16) ||
+		     !memcmp(cm_node->rem_addr, ipaddr, nfo->ipv4 ? 4 : 16)))) {
+			atomic_inc(&cm_node->ref_count);
+			list_add(&cm_node->connected_entry, &connected_list);
+		}
 	}
 	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 
@@ -4280,6 +4290,9 @@ void i40iw_if_notify(struct i40iw_device *iwdev, struct net_device *netdev,
 	enum i40iw_quad_hash_manage_type op =
 		ifup ? I40IW_QHASH_MANAGE_TYPE_ADD : I40IW_QHASH_MANAGE_TYPE_DELETE;
 
+	nfo.vlan_id = vlan_id;
+	nfo.ipv4 = ipv4;
+
 	/* Disable or enable qhash for listeners */
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
 	list_for_each_entry(listen_node, &cm_core->listen_nodes, list) {
@@ -4289,8 +4302,6 @@ void i40iw_if_notify(struct i40iw_device *iwdev, struct net_device *netdev,
 			memcpy(nfo.loc_addr, listen_node->loc_addr,
 			       sizeof(nfo.loc_addr));
 			nfo.loc_port = listen_node->loc_port;
-			nfo.ipv4 = listen_node->ipv4;
-			nfo.vlan_id = listen_node->vlan_id;
 			nfo.user_pri = listen_node->user_pri;
 			if (!list_empty(&listen_node->child_listen_list)) {
 				i40iw_qhash_ctrl(iwdev,
@@ -4312,7 +4323,7 @@ void i40iw_if_notify(struct i40iw_device *iwdev, struct net_device *netdev,
 	}
 	spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 
-	/* disconnect any connected qp's on ifdown */
+	/* teardown connected qp's on ifdown */
 	if (!ifup)
-		i40iw_cm_disconnect_all(iwdev);
+		i40iw_cm_teardown_connections(iwdev, ipaddr, &nfo, false);
 }
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 1577608..638f4c3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -453,5 +453,6 @@ int i40iw_arp_table(struct i40iw_device *iwdev,
 
 void i40iw_if_notify(struct i40iw_device *iwdev, struct net_device *netdev,
 		     u32 *ipaddr, bool ipv4, bool ifup);
-void i40iw_cm_disconnect_all(struct i40iw_device *iwdev);
+void i40iw_cm_teardown_connections(struct i40iw_device *iwdev, u32 *ipaddr,
+				   struct i40iw_cm_info *nfo, bool disconnect_all);
 #endif /* I40IW_CM_H */
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index a4a8458..8a9815e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1800,7 +1800,7 @@ static void i40iw_close(struct i40e_info *ldev, struct i40e_client *client, bool
 	if (reset)
 		iwdev->reset = true;
 
-	i40iw_cm_disconnect_all(iwdev);
+	i40iw_cm_teardown_connections(iwdev, NULL, NULL, true);
 	destroy_workqueue(iwdev->virtchnl_wq);
 	i40iw_deinit_device(iwdev);
 }
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
