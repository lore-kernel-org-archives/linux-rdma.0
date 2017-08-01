From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 32/33] RDMA/netlink: Provide port state and physical link state
Date: Tue,  1 Aug 2017 15:05:35 +0300
Message-ID: <20170801120536.540-33-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add port state and physical link state to the users of RDMA netlink.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 6 ++++++
 include/uapi/rdma/rdma_netlink.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index f968a40ef5d3..30fe1e9ff5ce 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -48,6 +48,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_LID]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_SM_LID]	= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_LMC]		= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_PORT_STATE]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_PORT_PHYS_STATE] = { .type = NLA_U8 },
 };
 
 static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
@@ -113,6 +115,10 @@ static int fill_port_info(struct sk_buff *msg,
 		if (nla_put_u8(msg, RDMA_NLDEV_ATTR_LMC, attr.lmc))
 			return -EMSGSIZE;
 	}
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_PORT_STATE, attr.state))
+		return -EMSGSIZE;
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_PORT_PHYS_STATE, attr.phys_state))
+		return -EMSGSIZE;
 	return 0;
 }
 
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index b85a08a7255f..ea8e1f01ba0d 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -297,6 +297,9 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_LMC,			/* u8 */
 
+	RDMA_NLDEV_ATTR_PORT_STATE,		/* u8 */
+	RDMA_NLDEV_ATTR_PORT_PHYS_STATE,	/* u8 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
