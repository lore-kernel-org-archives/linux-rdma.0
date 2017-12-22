From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 4/9] i40iw: Add notifier for network device events
Date: Fri, 22 Dec 2017 14:29:27 -0600
Message-ID: <20171222202932.9324-5-shiraz.saleem@intel.com>
References: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222202932.9324-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Register a netdevice notifier for netdev UP/DOWN
notification events and report the appropriate ib event.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       |  3 ++
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  6 ++++
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 50 +++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 4ae9131..bcddd70 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -587,5 +587,8 @@ int i40iw_inet6addr_event(struct notifier_block *notifier,
 int i40iw_net_event(struct notifier_block *notifier,
 		    unsigned long event,
 		    void *ptr);
+int i40iw_netdevice_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr);
 
 #endif
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 3aecf4c..a4a8458 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -99,6 +99,10 @@ static struct notifier_block i40iw_net_notifier = {
 	.notifier_call = i40iw_net_event
 };
 
+static struct notifier_block i40iw_netdevice_notifier = {
+	.notifier_call = i40iw_netdevice_event
+};
+
 /**
  * i40iw_find_i40e_handler - find a handler given a client info
  * @ldev: pointer to a client info
@@ -1394,6 +1398,7 @@ static void i40iw_register_notifiers(void)
 	register_inetaddr_notifier(&i40iw_inetaddr_notifier);
 	register_inet6addr_notifier(&i40iw_inetaddr6_notifier);
 	register_netevent_notifier(&i40iw_net_notifier);
+	register_netdevice_notifier(&i40iw_netdevice_notifier);
 }
 
 /**
@@ -1405,6 +1410,7 @@ static void i40iw_unregister_notifiers(void)
 	unregister_netevent_notifier(&i40iw_net_notifier);
 	unregister_inetaddr_notifier(&i40iw_inetaddr_notifier);
 	unregister_inet6addr_notifier(&i40iw_inetaddr6_notifier);
+	unregister_netdevice_notifier(&i40iw_netdevice_notifier);
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 8845dba..ddc1056 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -137,7 +137,7 @@ inline u32 i40iw_rd32(struct i40iw_hw *hw, u32 reg)
 }
 
 /**
- * i40iw_inetaddr_event - system notifier for netdev events
+ * i40iw_inetaddr_event - system notifier for ipv4 addr events
  * @notfier: not used
  * @event: event for notifier
  * @ptr: if address
@@ -200,7 +200,7 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 }
 
 /**
- * i40iw_inet6addr_event - system notifier for ipv6 netdev events
+ * i40iw_inet6addr_event - system notifier for ipv6 addr events
  * @notfier: not used
  * @event: event for notifier
  * @ptr: if address
@@ -252,7 +252,7 @@ int i40iw_inet6addr_event(struct notifier_block *notifier,
 }
 
 /**
- * i40iw_net_event - system notifier for net events
+ * i40iw_net_event - system notifier for netevents
  * @notfier: not used
  * @event: event for notifier
  * @ptr: neighbor
@@ -297,6 +297,50 @@ int i40iw_net_event(struct notifier_block *notifier, unsigned long event, void *
 }
 
 /**
+ * i40iw_netdevice_event - system notifier for netdev events
+ * @notfier: not used
+ * @event: event for notifier
+ * @ptr: netdev
+ */
+int i40iw_netdevice_event(struct notifier_block *notifier,
+			  unsigned long event,
+			  void *ptr)
+{
+	struct net_device *event_netdev;
+	struct net_device *netdev;
+	struct i40iw_device *iwdev;
+	struct i40iw_handler *hdl;
+
+	event_netdev = netdev_notifier_info_to_dev(ptr);
+
+	hdl = i40iw_find_netdev(event_netdev);
+	if (!hdl)
+		return NOTIFY_DONE;
+
+	iwdev = &hdl->device;
+	if (iwdev->init_state < RDMA_DEV_REGISTERED || iwdev->closing)
+		return NOTIFY_DONE;
+
+	netdev = iwdev->ldev->netdev;
+	if (netdev != event_netdev)
+		return NOTIFY_DONE;
+
+	iwdev->iw_status = 1;
+
+	switch (event) {
+	case NETDEV_DOWN:
+		iwdev->iw_status = 0;
+		/* Fall through */
+	case NETDEV_UP:
+		i40iw_port_ibevent(iwdev);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+/**
  * i40iw_get_cqp_request - get cqp struct
  * @cqp: device cqp ptr
  * @wait: cqp to be used in wait mode
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
