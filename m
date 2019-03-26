From: Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH v2 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Tue, 26 Mar 2019 14:18:29 -0500
Message-ID: <a1b4b7640efb89346c45db060e88bb66103b4f50.1553627811.git.larrystevenwise@gmail.com>
References: <cover.1553627811.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1553627811.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: Steve Wise <larrystevenwise@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
device to a netdev interface.

EG:

rdma link add rxe_eth0 type rxe netdev eth0
rdma link delete rxe_eth0

Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
---
 rdma/link.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/rdma.h |  2 ++
 2 files changed, 85 insertions(+)

diff --git a/rdma/link.c b/rdma/link.c
index 89e81b84..982c2b16 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -9,6 +9,9 @@
 static int link_help(struct rd *rd)
 {
 	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
+	pr_out("Usage: %s link add NAME type TYPE netdev NETDEV\n",
+	       rd->filename);
+	pr_out("Usage: %s link delete NAME\n", rd->filename);
 	return 0;
 }
 
@@ -336,10 +339,90 @@ static int link_show(struct rd *rd)
 	return rd_exec_link(rd, link_one_show, true);
 }
 
+static int link_add_netdev(struct rd *rd)
+{
+	rd->link_netdev = rd_argv(rd);
+	rd_arg_inc(rd);
+	return 0;
+}
+
+static int link_add_type(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		link_help},
+		{ "netdev",	link_add_netdev},
+		{ 0 }
+	};
+	rd->link_type = rd_argv(rd);
+	rd_arg_inc(rd);
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int link_add(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		link_help},
+		{ "type",	link_add_type},
+		{ 0 }
+	};
+
+	uint32_t seq;
+	char *name;
+	int ret;
+
+	if (rd_no_arg(rd)) {
+		pr_err("Please provide a link name to add.\n");
+		return -EINVAL;
+	}
+	name = rd_argv(rd);
+	rd_arg_inc(rd);
+
+	ret = rd_exec_cmd(rd, cmds, "parameter");
+	if (ret)
+		return ret;
+
+	if (!rd->link_type) {
+		pr_err("Please provide a link type name.\n");
+		return -EINVAL;
+	}
+	if (!rd->link_netdev) {
+		pr_err("Please provide a net device name.\n");
+		return -EINVAL;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
+		       (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, rd->link_type);
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, rd->link_netdev);
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int _link_del(struct rd *rd)
+{
+	uint32_t seq;
+
+	if (!rd_no_arg(rd)) {
+		pr_err("Unknown parameter %s\n", rd_argv(rd));
+		return -EINVAL;
+	}
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_DELLINK, &seq,
+		       (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int link_del(struct rd *rd)
+{
+	return rd_exec_require_dev(rd, _link_del);
+}
+
 int cmd_link(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		link_show },
+		{ "add",	link_add },
+		{ "delete",	link_del },
 		{ "show",	link_show },
 		{ "list",	link_show },
 		{ "help",	link_help },
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 6c7f7d15..070c8ddf 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -70,6 +70,8 @@ struct rd {
 	bool pretty_output;
 	bool suppress_errors;
 	struct list_head filter_list;
+	char *link_type;
+	char *link_netdev;
 };
 
 struct rd_cmd {
-- 
2.20.1
