From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 3/8] rdma: Add get per-port counter mode support
Date: Wed, 10 Apr 2019 14:21:16 +0300
Message-ID: <20190410112121.6790-4-leon@kernel.org>
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

Add an interface to show which mode is in active. Examples:

$ rdma statistic qp mode
0/1: mlx5_0/1: qp auto off
1/1: mlx5_1/1: qp auto off
2/1: mlx5_2/1: qp auto type on
3/1: mlx5_3/1: qp auto off

$ rdma statistic qp mode link mlx5_0
0/1: mlx5_0/1: qp auto off

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c  | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |   2 +
 2 files changed, 142 insertions(+)

diff --git a/rdma/stat.c b/rdma/stat.c
index 0c3abc99..f11252f7 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -18,13 +18,152 @@ static int stat_help(struct rd *rd)
 	pr_out("Usage: %s [ OPTIONS ] statistic { COMMAND | help }\n", rd->filename);
 	pr_out("       %s statistic OBJECT show\n", rd->filename);
 	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
+	pr_out("       %s statistic OBJECT mode\n", rd->filename);
+	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("Examples:\n");
 	pr_out("       %s statistic qp show\n", rd->filename);
 	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
+	pr_out("       %s statistic qp mode\n", rd->filename);
+	pr_out("       %s statistic qp mode link mlx5_0\n", rd->filename);
 
 	return 0;
 }
 
+struct counter_param {
+	char *name;
+	uint32_t attr;
+};
+
+static struct counter_param auto_params[] = {
+	{ "type", RDMA_COUNTER_MASK_QP_TYPE, },
+	{ NULL },
+};
+
+static int prepare_auto_mode_str(struct nlattr **tb, uint32_t mask,
+				 char *output, int len)
+{
+	char s[] = "qp auto";
+	int i, outlen = strlen(s);
+
+	memset(output, 0, len);
+	snprintf(output, len, "%s", s);
+
+	if (mask) {
+		for (i = 0; auto_params[i].name != NULL; i++) {
+			if (mask & auto_params[i].attr) {
+				outlen += strlen(auto_params[i].name) + 1;
+				if (outlen >= len)
+					return -EINVAL;
+				strcat(output, " ");
+				strcat(output, auto_params[i].name);
+			}
+		}
+
+		if (outlen + strlen(" on") >= len)
+			return -EINVAL;
+		strcat(output, " on");
+	} else {
+		if (outlen + strlen(" off") >= len)
+			return -EINVAL;
+		strcat(output, " off");
+	}
+
+	return 0;
+}
+
+static int qp_link_get_mode_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	uint32_t mode = 0, mask = 0;
+	char output[128] = {0};
+	struct rd *rd = data;
+	uint32_t idx, port;
+	const char *name;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	if (!tb[RDMA_NLDEV_ATTR_PORT_INDEX]) {
+		pr_err("This tool doesn't support switches yet\n");
+		return MNL_CB_ERROR;
+	}
+
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	if (tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		mode = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+
+	if (mode == RDMA_COUNTER_MODE_AUTO) {
+		if (!tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+			return MNL_CB_ERROR;
+		mask = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+		prepare_auto_mode_str(tb, mask, output, sizeof(output));
+	} else {
+		snprintf(output, sizeof(output), "qp auto off");
+	}
+
+	if (rd->json_output) {
+		jsonw_uint_field(rd->jw, "ifindex", idx);
+		jsonw_uint_field(rd->jw, "port", port);
+		jsonw_string_field(rd->jw, "mode", output);
+	} else {
+		pr_out("%u/%u: %s/%u: %s\n", idx, port, name, port, output);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int stat_one_qp_link_get_mode(struct rd *rd)
+{
+	uint32_t seq;
+	int ret;
+
+	if (!rd->port_idx)
+		return 0;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	/* Make RDMA_NLDEV_ATTR_STAT_MODE valid so that kernel knows
+	 * return only mode instead of all counters
+	 */
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_MANUAL);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, qp_link_get_mode_parse_cb, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+
+	return ret;
+}
+
+static int stat_qp_link_get_mode(struct rd* rd)
+{
+	return rd_exec_link(rd, stat_one_qp_link_get_mode, false);
+}
+
+static int stat_qp_get_mode(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_qp_link_get_mode },
+		{ "link",	stat_qp_link_get_mode },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int res_show_hwcounters(struct rd *rd, struct nlattr *hwc_table)
 {
 	struct nlattr *nla_entry;
@@ -243,6 +382,7 @@ static int stat_qp(struct rd *rd)
 		{ NULL,		stat_qp_show },
 		{ "show",	stat_qp_show },
 		{ "list",	stat_qp_show },
+		{ "mode",	stat_qp_get_mode },
 		{ "help",	stat_help },
 		{ 0 }
 	};
diff --git a/rdma/utils.c b/rdma/utils.c
index ff781517..5ad6c961 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -442,6 +442,8 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY] = MNL_TYPE_NESTED,
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_STAT_MODE] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1
