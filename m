From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 14/33] RDMA/core: Add and expose static device index
Date: Thu, 10 Aug 2017 14:08:08 +0300
Message-ID: <20170810110827.9952-15-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds static device index in similar fashion to
already available in netdev world (struct net->ifindex).

In downstream patches, the RDMA nelink will use this idx-to-ib_device
conversion, so as part of this commit, we are exposing the translation
function to be visible for IB/core users.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  5 +++++
 drivers/infiniband/core/device.c    | 37 ++++++++++++++++++++++++++++++++++++-
 include/rdma/ib_verbs.h             |  2 ++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0c175590cf92..cbdcc81e1df8 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -309,4 +309,9 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
 	return 0;
 }
 #endif
+
+struct ib_device *__ib_device_get_by_index(u32 ifindex);
+/* RDMA device netlink */
+void nldev_init(void);
+void nldev_exit(void);
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 8828f26250a8..deae8b940994 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -134,6 +134,17 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	return 0;
 }
 
+struct ib_device *__ib_device_get_by_index(u32 index)
+{
+	struct ib_device *device;
+
+	list_for_each_entry(device, &device_list, core_list)
+		if (device->index == index)
+			return device;
+
+	return NULL;
+}
+
 static struct ib_device *__ib_device_get_by_name(const char *name)
 {
 	struct ib_device *device;
@@ -145,7 +156,6 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
 	return NULL;
 }
 
-
 static int alloc_name(char *name)
 {
 	unsigned long *inuse;
@@ -394,6 +404,30 @@ static int ib_security_change(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_OK;
 }
 
+/**
+ *	__dev_new_index	-	allocate an device index
+ *
+ *	Returns a suitable unique value for a new device interface
+ *	number.  It assumes that there are less than 2^32-1 ib devices
+ *	will be present in the system.
+ */
+static u32 __dev_new_index(void)
+{
+	/*
+	 * The device index to allow stable naming.
+	 * Similar to struct net -> ifindex.
+	 */
+	static u32 index;
+
+	for (;;) {
+		if (!(++index))
+			index = 1;
+
+		if (!__ib_device_get_by_index(index))
+			return index;
+	}
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -492,6 +526,7 @@ int ib_register_device(struct ib_device *device,
 		if (client->add && !add_client_context(device, client))
 			client->add(device);
 
+	device->index = __dev_new_index();
 	down_write(&lists_rwsem);
 	list_add_tail(&device->core_list, &device_list);
 	up_write(&lists_rwsem);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1082b4c81b2c..3391df5fdc9c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2298,6 +2298,8 @@ struct ib_device {
 	struct rdmacg_device         cg_device;
 #endif
 
+	u32                          index;
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
