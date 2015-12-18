From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 7/7] IB/core: Remove ib_query_device
Date: Fri, 18 Dec 2015 10:59:50 +0200
Message-ID: <1450429190-5898-8-git-send-email-ogerlitz@mellanox.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450429190-5898-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The copy of the attributes present on the device is now used by all consumers
expect for uverbs in case of serving user-space query, where dev->query_device
is called.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 19 -------------------
 include/rdma/ib_verbs.h          |  3 ---
 2 files changed, 22 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 568592e3..6def2f7 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -636,25 +636,6 @@ void ib_dispatch_event(struct ib_event *event)
 EXPORT_SYMBOL(ib_dispatch_event);
 
 /**
- * ib_query_device - Query IB device attributes
- * @device:Device to query
- * @device_attr:Device attributes
- *
- * ib_query_device() returns the attributes of a device through the
- * @device_attr pointer.
- */
-int ib_query_device(struct ib_device *device,
-		    struct ib_device_attr *device_attr)
-{
-	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
-
-	memset(device_attr, 0, sizeof(*device_attr));
-
-	return device->query_device(device, device_attr, &uhw);
-}
-EXPORT_SYMBOL(ib_query_device);
-
-/**
  * ib_query_port - Query IB port attributes
  * @device:Device to query
  * @port_num:Port number to query
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 730dcfb..0567866 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1913,9 +1913,6 @@ int ib_register_event_handler  (struct ib_event_handler *event_handler);
 int ib_unregister_event_handler(struct ib_event_handler *event_handler);
 void ib_dispatch_event(struct ib_event *event);
 
-int ib_query_device(struct ib_device *device,
-		    struct ib_device_attr *device_attr);
-
 int ib_query_port(struct ib_device *device,
 		  u8 port_num, struct ib_port_attr *port_attr);
 
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
