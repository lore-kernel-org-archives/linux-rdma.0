From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 31/33] RDMA/netlink: Export LID mask control (LMC)
Date: Thu, 10 Aug 2017 14:08:25 +0300
Message-ID: <20170810110827.9952-32-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 3 +++
 include/uapi/rdma/rdma_netlink.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 16f1d28bea69..11546f87c5dc 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -47,6 +47,7 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_SUBNET_PREFIX]	= { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_LID]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_SM_LID]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_LMC]		= { .type = NLA_U8 },
 };
 
 static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
@@ -109,6 +110,8 @@ static int fill_port_info(struct sk_buff *msg,
 			return -EMSGSIZE;
 		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_SM_LID, attr.sm_lid))
 			return -EMSGSIZE;
+		if (nla_put_u8(msg, RDMA_NLDEV_ATTR_LMC, attr.lmc))
+			return -EMSGSIZE;
 	}
 	return 0;
 }
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 7d5caaf54126..035706e6b016 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -292,6 +292,11 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_LID,			/* u32 */
 	RDMA_NLDEV_ATTR_SM_LID,			/* u32 */
 
+	/*
+	 * LID mask control (LMC)
+	 */
+	RDMA_NLDEV_ATTR_LMC,			/* u8 */
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
