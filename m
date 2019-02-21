From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 3/4] rdma: add 'link add/delete' commands
Date: Thu, 21 Feb 2019 08:19:12 -0800
Message-ID: <5dd9d9aeada48bc5db0eb0394ed4e3ce38ee41bc.1550773362.git.swise@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
device to a netdev interface.

EG:

rdma link add rxe_eth0 type rxe netdev eth0
rdma link delete rxe_eth0

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/link.c  | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/rdma.h  |  1 +
 rdma/utils.c |  2 +-
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/rdma/link.c b/rdma/link.c
index c064be627be2..afaf19663728 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -14,6 +14,9 @@
 static int link_help(struct rd *rd)
 {
 	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
+	pr_out("Usage: %s link add NAME type TYPE netdev NETDEV\n",
+	       rd->filename);
+	pr_out("Usage: %s link delete NAME\n", rd->filename);
 	return 0;
 }
 
@@ -341,10 +344,74 @@ static int link_show(struct rd *rd)
 	return rd_exec_link(rd, link_one_show, true);
 }
 
+static int link_add(struct rd *rd)
+{
+	char *name;
+	char *type = NULL;
+	char *dev = NULL;
+	uint32_t seq;
+
+	if (rd_no_arg(rd)) {
+		pr_err("No link name was supplied\n");
+		return -EINVAL;
+	}
+	name = rd_argv(rd);
+	rd_arg_inc(rd);
+	while (!rd_no_arg(rd)) {
+		if (rd_argv_match(rd, "type")) {
+			rd_arg_inc(rd);
+			type = rd_argv(rd);
+		} else if (rd_argv_match(rd, "netdev")) {
+			rd_arg_inc(rd);
+			dev = rd_argv(rd);
+		} else {
+			pr_err("Invalid parameter %s\n", rd_argv(rd));
+			return -EINVAL;
+		}
+		rd_arg_inc(rd);
+	}
+	if (!type) {
+		pr_err("No type was supplied\n");
+		return -EINVAL;
+	}
+	if (!dev) {
+		pr_err("No net device was supplied\n");
+		return -EINVAL;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
+		       (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
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
index 20be2f12c4f8..af4597f45640 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -79,6 +79,7 @@ struct rd_cmd {
  */
 bool rd_no_arg(struct rd *rd);
 void rd_arg_inc(struct rd *rd);
+bool rd_argv_match(struct rd *rd, const char *pattern);
 
 char *rd_argv(struct rd *rd);
 
diff --git a/rdma/utils.c b/rdma/utils.c
index a6f2826c9605..85a954167511 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -32,7 +32,7 @@ int strcmpx(const char *str1, const char *str2)
 	return strncmp(str1, str2, strlen(str1));
 }
 
-static bool rd_argv_match(struct rd *rd, const char *pattern)
+bool rd_argv_match(struct rd *rd, const char *pattern)
 {
 	if (!rd_argc(rd))
 		return false;
-- 
1.8.3.1
