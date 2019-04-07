From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 10/17] RDMA/nldev: Allow counter auto mode configration through RDMA netlink
Date: Sun,  7 Apr 2019 10:50:06 +0300
Message-ID: <20190407075013.12955-11-leon@kernel.org>
References: <20190407075013.12955-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190407075013.12955-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Provide an option to enable/disable per-port counter auto mode through
RDMA netlink. Limit it to users with ADMIN capability only.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c  | 78 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  8 ++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2da1703cbbb1..44c53d053089 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -120,6 +120,9 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DEV_PROTOCOL]		= { .type = NLA_NUL_STRING,
 				    .len = RDMA_NLDEV_ATTR_ENTRY_STRLEN },
 	[RDMA_NLDEV_NET_NS_FD]			= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_MODE]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_RES]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]	= { .type = NLA_U32 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -1385,6 +1388,78 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	u32 index, port, mode, mask = 0;
+	struct ib_device *device;
+	struct sk_buff *msg;
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	/* Currently only counter for QP is supported */
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		return -EINVAL;
+
+	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), index);
+	if (!device)
+		return -EINVAL;
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_SET),
+			0, 0);
+
+	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+	if (mode != RDMA_COUNTER_MODE_AUTO) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+		mask = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+
+	ret = rdma_counter_set_auto_mode(device, port,
+					 mask ? true : false, mask);
+	if (ret)
+		goto err_msg;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_MODE, mode) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask)) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -1435,6 +1510,9 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	},
 	[RDMA_NLDEV_CMD_SYS_SET] = {
 		.doit = nldev_set_sys_set_doit,
+	},
+	[RDMA_NLDEV_CMD_STAT_SET] = {
+		.doit = nldev_stat_set_doit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
 };
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index e910ff6a2a80..d1439df60ce5 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -267,6 +267,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_SET,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -478,6 +480,12 @@ enum rdma_nldev_attr {
 	 * Device protocol, e.g. ib, iw, usnic, roce and opa
 	 */
 	RDMA_NLDEV_ATTR_DEV_PROTOCOL,		/* string */
+	/*
+	 * Counter-specific attributes.
+	 */
+	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
 
 	/*
 	 * Always the end
-- 
2.20.1
