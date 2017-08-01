From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 22/33] RDMA/netlink: Add nldev device doit implementation
Date: Tue,  1 Aug 2017 15:05:25 +0300
Message-ID: <20170801120536.540-23-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide ability to query specific device.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/nldev.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4b8b0f5d5344..666940f2b49a 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -53,6 +53,45 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 	return 0;
 }
 
+static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index;
+	int err;
+
+	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	device = __ib_device_get_by_index(index);
+	if (!device)
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
+	err = fill_dev_info(msg, device);
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
 static int _nldev_get_dumpit(struct ib_device *device,
 			     struct sk_buff *skb,
 			     struct netlink_callback *cb,
@@ -92,6 +131,7 @@ static int nldev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 
 static const struct rdma_nl_cbs nldev_cb_table[] = {
 	[RDMA_NLDEV_CMD_GET] = {
+		.doit = nldev_get_doit,
 		.dump = nldev_get_dumpit,
 	},
 };
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
