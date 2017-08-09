From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 24/33] RDMA/netlink: Implement nldev port doit callback
Date: Wed,  9 Aug 2017 19:03:56 +0300
Message-ID: <20170809160405.25142-25-leon@kernel.org>
References: <20170809160405.25142-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide ability to get specific to device and port information.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/nldev.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4413eda8c435..533ac72a05b8 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -141,6 +141,49 @@ static int nldev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	return ib_enum_all_devs(_nldev_get_dumpit, skb, cb);
 }
 
+static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index;
+	u32 port;
+	int err;
+
+	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (err || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = __ib_device_get_by_index(index);
+	if (!device)
+		return -EINVAL;
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port))
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
+			0, 0);
+
+	err = fill_port_info(msg, device, port);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	nlmsg_end(msg, nlh);
+
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+}
+
 static int nldev_port_get_dumpit(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
@@ -193,6 +236,7 @@ static const struct rdma_nl_cbs nldev_cb_table[] = {
 		.dump = nldev_get_dumpit,
 	},
 	[RDMA_NLDEV_CMD_PORT_GET] = {
+		.doit = nldev_port_get_doit,
 		.dump = nldev_port_get_dumpit,
 	},
 };
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
