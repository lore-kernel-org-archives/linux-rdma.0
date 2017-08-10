From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 28/33] RDMA/netlink: Export node_guid and sys_image_guid
Date: Thu, 10 Aug 2017 14:08:22 +0300
Message-ID: <20170810110827.9952-29-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add Node GUID and system image GUID to the device properties
exported by RDMA netlink, to be used by RDMAtool.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  |  8 ++++++++
 include/uapi/rdma/rdma_netlink.h | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index cdc970ca5a1b..f932c2c3fad0 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -42,6 +42,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_PORT_INDEX]	= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_FW_VERSION]	= { .type = NLA_NUL_STRING,
 					    .len = IB_FW_VERSION_NAME_MAX - 1},
+	[RDMA_NLDEV_ATTR_NODE_GUID]	= { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_SYS_IMAGE_GUID] = { .type = NLA_U64 },
 };
 
 static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
@@ -65,6 +67,12 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 	if (strlen(fw) && nla_put_string(msg, RDMA_NLDEV_ATTR_FW_VERSION, fw))
 		return -EMSGSIZE;
 
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_NODE_GUID,
+			      be64_to_cpu(device->node_guid), 0))
+		return -EMSGSIZE;
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_SYS_IMAGE_GUID,
+			      be64_to_cpu(device->attrs.sys_image_guid), 0))
+		return -EMSGSIZE;
 	return 0;
 }
 
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 5159858730b0..fe3a7429e7a1 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -266,6 +266,19 @@ enum rdma_nldev_attr {
 	 * FW version
 	 */
 	RDMA_NLDEV_ATTR_FW_VERSION,		/* string */
+
+	/*
+	 * Node GUID (in host byte order) associated with the RDMA device.
+	 */
+	RDMA_NLDEV_ATTR_NODE_GUID,			/* u64 */
+
+	/*
+	 * System image GUID (in host byte order) associated with
+	 * this RDMA device and other devices which are part of a
+	 * single system.
+	 */
+	RDMA_NLDEV_ATTR_SYS_IMAGE_GUID,		/* u64 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
