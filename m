From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 27/33] RDMA/netlink: Export FW version
Date: Tue,  1 Aug 2017 15:05:30 +0300
Message-ID: <20170801120536.540-28-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add FW version to the device properties exported
by RDMA netlink, to be used by RDMAtool.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 9 +++++++++
 include/uapi/rdma/rdma_netlink.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 21e75928400c..40d5f0eb16f5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -40,10 +40,14 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = IB_DEVICE_NAME_MAX - 1},
 	[RDMA_NLDEV_ATTR_PORT_INDEX]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_FW_VERSION]	= { .type = NLA_NUL_STRING,
+					    .len = IB_FW_VERSION_NAME_MAX - 1},
 };
 
 static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 {
+	char fw[IB_FW_VERSION_NAME_MAX];
+
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
 		return -EMSGSIZE;
 	if (nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_NAME, device->name))
@@ -56,6 +60,11 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 			      device->attrs.device_cap_flags, 0))
 		return -EMSGSIZE;
 
+	ib_get_device_fw_str(device, fw);
+	/* Device without FW has strlen(fw) */
+	if (strlen(fw) && nla_put_string(msg, RDMA_NLDEV_ATTR_FW_VERSION, fw))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 8fc5278d07d6..fec735f73eee 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -262,6 +262,10 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_CAP_FLAGS,		/* u64 */
 
+	/*
+	 * FW version
+	 */
+	RDMA_NLDEV_ATTR_FW_VERSION,		/* string */
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
