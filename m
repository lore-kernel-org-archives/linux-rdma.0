From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 3/3] rdma: Add an option to rename IB device interface
Date: Thu, 18 Oct 2018 14:51:20 +0300
Message-ID: <20181018115120.17893-4-leon@kernel.org>
References: <20181018115120.17893-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181018115120.17893-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Enrich rdmatool with an option to rename IB devices,
the command interface follows Iproute2 convention:
"rdma dev set [OLD-DEVNAME] name NEW-DEVNAME"

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/dev.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/rdma/dev.c b/rdma/dev.c
index e2eafe47..760b7fb3 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -14,6 +14,7 @@
 static int dev_help(struct rd *rd)
 {
 	pr_out("Usage: %s dev show [DEV]\n", rd->filename);
+	pr_out("       %s dev set [DEV] name DEVNAME\n", rd->filename);
 	return 0;
 }
 
@@ -240,17 +241,51 @@ static int dev_one_show(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int dev_set_name(struct rd *rd)
+{
+	uint32_t seq;
+
+	if (rd_no_arg(rd)) {
+		pr_err("Please provide device new name.\n");
+		return -EINVAL;
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
+
+	return rd_send_msg(rd);
+}
+
+static int dev_one_set(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		dev_help},
+		{ "name",	dev_set_name},
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int dev_show(struct rd *rd)
 {
 	return rd_exec_dev(rd, dev_one_show);
 }
 
+static int dev_set(struct rd *rd)
+{
+	return rd_exec_require_dev(rd, dev_one_set);
+}
+
 int cmd_dev(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		dev_show },
 		{ "show",	dev_show },
 		{ "list",	dev_show },
+		{ "set",	dev_set },
 		{ "help",	dev_help },
 		{ 0 }
 	};
-- 
2.14.4
