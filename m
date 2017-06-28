From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] RDMA/netink: Export lids and sm_lids
Date: Wed, 28 Jun 2017 16:34:44 +0300
Message-ID: <20170628133445.16550-4-leon@kernel.org>
References: <20170628133445.16550-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628133445.16550-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

According to the IB specification, the LID and SM_LID
are 16-bit wide, but to support OmniPath users, export
it as 32-bit value from the beginning.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 7 ++++++-
 include/uapi/rdma/rdma_netlink.h | 8 ++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 755b8167280b..6b290dada589 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -45,6 +45,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_GUID]		= { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_SYS_IMAGE_GUID] = { .type = NLA_U64 },
 	[RDMA_NLDEV_ATTR_SUBNET_PREFIX]	= { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_LID]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_SM_LID]	= { .type = NLA_U32 },
 };

 static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
@@ -99,7 +101,10 @@ static int fill_port_info(struct sk_buff *msg,
 	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_SUBNET_PREFIX,
 			      attr.subnet_prefix, 0))
 		return -EMSGSIZE;
-
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_LID, attr.lid))
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_SM_LID, attr.sm_lid))
+		return -EMSGSIZE;
 	return 0;
 }

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 5fec88038e6e..22e4870f2e31 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -284,6 +284,14 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_SUBNET_PREFIX,		/* u64 */

+	/*
+	 * Local Identifier (LID),
+	 * According to IB specification, It is 16-bit address assigned
+	 * by the Subnet Manager. Extended to be 32-bit for OmniPath users.
+	 */
+	RDMA_NLDEV_ATTR_LID,			/* u32 */
+	RDMA_NLDEV_ATTR_SM_LID,			/* u32 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
