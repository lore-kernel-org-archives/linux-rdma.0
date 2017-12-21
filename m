From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH rdma-next 13/14] RDMA/nldev: Provide global resource utilization
Date: Thu, 21 Dec 2017 20:17:47 +0200
Message-ID: <20171221181748.17126-14-leon@kernel.org>
References: <20171221181748.17126-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Export through netlink interface, the global device utilization
for the rdmatool as the main user of RDMA nldev interface.

Provide both dumpit and doit callbacks.

As an example of possible output from rdmatool for system with 5
Mellanox's card

$ rdma res
1: mlx5_0: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
2: mlx5_1: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
3: mlx5_2: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216
4: mlx5_3: curr/max: qp 2/262144 cq 3/16777216 pd 2/16777216
5: mlx5_4: curr/max: qp 4/262144 cq 5/16777216 pd 3/16777216

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/nldev.c  | 165 +++++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  11 +++
 2 files changed, 176 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index ed7e639e7dee..7aca9458e946 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -52,6 +52,12 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_PORT_STATE]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_ATTR_PORT_PHYS_STATE] = { .type = NLA_U8 },
 	[RDMA_NLDEV_ATTR_DEV_NODE_TYPE] = { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_SUMMARY]	= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY]	= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME] = { .type = NLA_NUL_STRING,
+					     .len = 16 },
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] = { .type = NLA_U64 },
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]	= { .type = NLA_U64 },
 };

 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -134,6 +140,79 @@ static int fill_port_info(struct sk_buff *msg,
 	return 0;
 }

+static int fill_res_info_entry(struct sk_buff *msg,
+			       const char *name, u64 curr, u64 max)
+{
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY);
+	if (!entry_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_string(msg, RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME, name))
+		goto err;
+	if (nla_put_u64_64bit(msg,
+			      RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR, curr, 0))
+		goto err;
+	if (nla_put_u64_64bit(msg,
+			      RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX, max, 0))
+		goto err;
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+	return -EMSGSIZE;
+}
+
+static u32 get_res_max(struct ib_device *dev, int idx)
+{
+	switch (idx) {
+	case RDMA_RESTRACK_PD: return dev->attrs.max_pd;
+	case RDMA_RESTRACK_CQ: return dev->attrs.max_cq;
+	case RDMA_RESTRACK_QP: return dev->attrs.max_qp;
+	default:	       return 0; /* unreachable */
+	}
+}
+
+static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
+{
+	static const char *names[_RDMA_RESTRACK_MAX] = {
+		[RDMA_RESTRACK_PD] = "pd",
+		[RDMA_RESTRACK_CQ] = "cq",
+		[RDMA_RESTRACK_QP] = "qp",
+	};
+
+	struct rdma_restrack_root *res = &device->res;
+	struct nlattr *table_attr;
+	int ret, i;
+
+	if (fill_nldev_handle(msg, device))
+		return -EMSGSIZE;
+
+	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_SUMMARY);
+	if (!table_attr)
+		return -EMSGSIZE;
+
+	for (i = 0; i < _RDMA_RESTRACK_MAX; i++) {
+		if (!names[i])
+			continue;
+		ret = fill_res_info_entry(msg, names[i],
+					  rdma_restrack_count(res, i),
+					  get_res_max(device, i));
+		if (ret)
+			goto err;
+	}
+
+	nla_nest_end(msg, table_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, table_attr);
+	return ret;
+}
+
 static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
@@ -325,6 +404,88 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 	return skb->len;
 }

+static int nldev_res_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index;
+	int ret = -ENOMEM;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(index);
+	if (!device)
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		goto err;
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
+			0, 0);
+
+	ret = fill_res_info(msg, device);
+	if (ret)
+		goto err_free;
+
+	nlmsg_end(msg, nlh);
+	put_device(&device->dev);
+
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_free:
+	nlmsg_free(msg);
+err:
+	put_device(&device->dev);
+	return ret;
+}
+
+static int _nldev_res_get_dumpit(struct ib_device *device,
+				 struct sk_buff *skb,
+				 struct netlink_callback *cb,
+				 unsigned int idx)
+{
+	int start = cb->args[0];
+	struct nlmsghdr *nlh;
+
+	if (idx < start)
+		return 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
+			0, NLM_F_MULTI);
+
+	if (fill_res_info(skb, device)) {
+		nlmsg_cancel(skb, nlh);
+		goto out;
+	}
+
+	nlmsg_end(skb, nlh);
+
+	idx++;
+
+out:
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int nldev_res_get_dumpit(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	/*
+	 * There is no need to take lock, because
+	 * we are relying on ib_core's lists_rwsem
+	 */
+	return ib_enum_all_devs(_nldev_res_get_dumpit, skb, cb);
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -334,6 +495,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_port_get_doit,
 		.dump = nldev_port_get_dumpit,
 	},
+	[RDMA_NLDEV_CMD_RES_GET] = {
+		.doit = nldev_res_get_doit,
+		.dump = nldev_res_get_dumpit,
+	},
 };

 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index cc002e316d09..e041d2eca4b8 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -236,6 +236,11 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_PORT_NEW,
 	RDMA_NLDEV_CMD_PORT_DEL,

+	RDMA_NLDEV_CMD_RES_GET, /* can dump */
+	RDMA_NLDEV_CMD_RES_SET,
+	RDMA_NLDEV_CMD_RES_NEW,
+	RDMA_NLDEV_CMD_RES_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };

@@ -303,6 +308,12 @@ enum rdma_nldev_attr {

 	RDMA_NLDEV_ATTR_DEV_NODE_TYPE,		/* u8 */

+	RDMA_NLDEV_ATTR_RES_SUMMARY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,	/* u64 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
