From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 17/17] RDMA/nldev: Allow get default counter statistics through RDMA netlink
Date: Mon, 29 Apr 2019 11:34:53 +0300
Message-ID: <20190429083453.16654-18-leon@kernel.org>
References: <20190429083453.16654-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

This patch adds the ability to return the hwstats of per-port default
counters (which can also be queried through sysfs nodes).

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 101 +++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 53c1d2d82a06..cb2dd38f49f1 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1709,6 +1709,98 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int nldev_res_get_default_counter_doit(struct sk_buff *skb,
+					      struct nlmsghdr *nlh,
+					      struct netlink_ext_ack *extack,
+					      struct nlattr *tb[])
+{
+	struct rdma_hw_stats *stats;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int ret, num_cnts, i;
+	struct sk_buff *msg;
+	u32 index, port;
+	u64 v;
+
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), index);
+	if (!device)
+		return -EINVAL;
+
+	if (!device->ops.alloc_hw_stats || !device->ops.get_hw_stats) {
+		ret = -EINVAL;
+		goto err;
+	}
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
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_GET),
+			0, 0);
+
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	stats = device->ops.alloc_hw_stats(device, port);
+	if (!stats) {
+		ret = -ENOMEM;
+		goto err_msg;
+	}
+
+	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
+	if (num_cnts < 0) {
+		ret = -EINVAL;
+		goto err_stats;
+	}
+
+	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err_stats;
+	}
+	for (i = 0; i < num_cnts; i++) {
+		v = stats->value[i] +
+			rdma_counter_get_hwstat_value(device, port, i);
+		if (fill_stat_hwcounter_entry(msg, stats->names[i], v)) {
+			ret = -EMSGSIZE;
+			goto err_table;
+		}
+	}
+	nla_nest_end(msg, table_attr);
+
+	kfree(stats);
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_table:
+	nla_nest_cancel(msg, table_attr);
+err_stats:
+	kfree(stats);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
@@ -1725,8 +1817,13 @@ static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ret)
 		return -EINVAL;
 
-	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE])
-		return nldev_res_get_counter_doit(skb, nlh, extack);
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		if (!tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+			return nldev_res_get_default_counter_doit(skb, nlh,
+								  extack, tb);
+		else
+			return nldev_res_get_counter_doit(skb, nlh, extack);
+	}
 
 	if (!tb[RDMA_NLDEV_ATTR_STAT_RES] || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
 	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
-- 
2.20.1
