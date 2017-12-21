From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH rdma-next 04/14] RDMA/nldev: Refactor nldev handle to be common function
Date: Thu, 21 Dec 2017 20:17:38 +0200
Message-ID: <20171221181748.17126-5-leon@kernel.org>
References: <20171221181748.17126-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The NLDEV commands are using IB device indexes and names as a handler
for netlink communications. Put all relevant code into one function,
so it will be reused easily.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 9a05245a1acf..2b631307349d 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -54,14 +54,23 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DEV_NODE_TYPE] = { .type = NLA_U8 },
 };

-static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
+static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
 {
-	char fw[IB_FW_VERSION_NAME_MAX];
-
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
 		return -EMSGSIZE;
 	if (nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_NAME, device->name))
 		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
+{
+	char fw[IB_FW_VERSION_NAME_MAX];
+
+	if (fill_nldev_handle(msg, device))
+		return -EMSGSIZE;
+
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, rdma_end_port(device)))
 		return -EMSGSIZE;

@@ -92,10 +101,9 @@ static int fill_port_info(struct sk_buff *msg,
 	struct ib_port_attr attr;
 	int ret;

-	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
-		return -EMSGSIZE;
-	if (nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_NAME, device->name))
+	if (fill_nldev_handle(msg, device))
 		return -EMSGSIZE;
+
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
 		return -EMSGSIZE;

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
