From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 5/7] RDMA/core: Provide locked variant of device name to index function
Date: Mon,  1 Jan 2018 13:07:15 +0200
Message-ID: <20180101110717.29686-6-leon@kernel.org>
References: <20180101110717.29686-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180101110717.29686-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add self-contained with locks device name to index function.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  1 +
 drivers/infiniband/core/device.c    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0deff4c4911b..a7e516d720d7 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -295,6 +295,7 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
 #endif
 
 struct ib_device *__ib_device_get_by_index(u32 ifindex);
+struct ib_device *ib_device_get_by_index(u32 ifindex);
 /* RDMA device netlink */
 void nldev_init(void);
 void nldev_exit(void);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a8757b5552de..34c6cb2a0977 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -145,6 +145,22 @@ struct ib_device *__ib_device_get_by_index(u32 index)
 	return NULL;
 }
 
+/*
+ * Caller is responsible to return refrerence count by calling put_device()
+ */
+struct ib_device *ib_device_get_by_index(u32 index)
+{
+	struct ib_device *device;
+
+	down_read(&lists_rwsem);
+	device = __ib_device_get_by_index(index);
+	if (device)
+		get_device(&device->dev);
+
+	up_read(&lists_rwsem);
+	return device;
+}
+
 static struct ib_device *__ib_device_get_by_name(const char *name)
 {
 	struct ib_device *device;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
