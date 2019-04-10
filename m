From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 4/8] rdma: Add rdma statistic counter per-port auto mode support
Date: Wed, 10 Apr 2019 14:21:17 +0300
Message-ID: <20190410112121.6790-5-leon@kernel.org>
References: <20190410112121.6790-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190410112121.6790-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Mark Zhang <markz@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

With per-QP statistic counter support, a user is allowed to monitor
specific QPs categories, which are bound to/unbound from counters
dynamically allocated/deallocated.

In per-port "auto" mode, QPs are bound to counters automatically
according to common criteria. For example a per "type"(qp type)
scheme, where in each process all QPs have same qp type are bind
automatically to a single counter.
Currently only "type" (qp type) is supported. Examples:

$ rdma statistic qp set link mlx5_2/1 auto type on
$ rdma statistic qp set link mlx5_2/1 auto off

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c  | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |   1 +
 2 files changed, 104 insertions(+)

diff --git a/rdma/stat.c b/rdma/stat.c
index f11252f7..aec0e837 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -19,12 +19,17 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic OBJECT show\n", rd->filename);
 	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
 	pr_out("       %s statistic OBJECT mode\n", rd->filename);
+	pr_out("       %s statistic OBJECT set COUNTER_SCOPE [DEV/PORT_INDEX] auto {CRITERIA | off}\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
+	pr_out("       CRITERIA : = { type }\n");
+	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
 	pr_out("Examples:\n");
 	pr_out("       %s statistic qp show\n", rd->filename);
 	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
 	pr_out("       %s statistic qp mode\n", rd->filename);
 	pr_out("       %s statistic qp mode link mlx5_0\n", rd->filename);
+	pr_out("       %s statistic qp set link mlx5_2/1 auto type on\n", rd->filename);
+	pr_out("       %s statistic qp set link mlx5_2/1 auto off\n", rd->filename);
 
 	return 0;
 }
@@ -376,6 +381,103 @@ static int stat_qp_show(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int qp_set_link_auto_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return MNL_CB_OK;
+}
+
+static int stat_qp_set_link_auto_sendmsg(struct rd *rd, uint32_t mask)
+{
+	uint32_t seq;
+	int ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_AUTO);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask);
+
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, qp_set_link_auto_parse_cb, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+
+	return ret;
+}
+
+static int stat_one_qp_set_link_auto_off(struct rd *rd)
+{
+	return stat_qp_set_link_auto_sendmsg(rd, 0);
+}
+
+static int stat_one_qp_set_auto_type_on(struct rd *rd)
+{
+	return stat_qp_set_link_auto_sendmsg(rd, RDMA_COUNTER_MASK_QP_TYPE);
+}
+
+static int stat_one_qp_set_link_auto_type(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "on",		stat_one_qp_set_auto_type_on },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_one_qp_set_link_auto(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_one_qp_link_get_mode },
+		{ "off",	stat_one_qp_set_link_auto_off },
+		{ "type", 	stat_one_qp_set_link_auto_type },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_one_qp_set_link(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_one_qp_link_get_mode },
+		{ "auto",	stat_one_qp_set_link_auto },
+		{ 0 }
+	};
+
+	if (!rd->port_idx)
+		return 0;
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_qp_set_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_qp_set_link, false);
+}
+
+static int stat_qp_set(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_qp_set_link },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int stat_qp(struct rd *rd)
 {
 	const struct rd_cmd cmds[] =  {
@@ -383,6 +485,7 @@ static int stat_qp(struct rd *rd)
 		{ "show",	stat_qp_show },
 		{ "list",	stat_qp_show },
 		{ "mode",	stat_qp_get_mode },
+		{ "set",	stat_qp_set },
 		{ "help",	stat_help },
 		{ 0 }
 	};
diff --git a/rdma/utils.c b/rdma/utils.c
index 5ad6c961..1fda2879 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -444,6 +444,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_STAT_MODE] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK] = MNL_TYPE_U32,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1
