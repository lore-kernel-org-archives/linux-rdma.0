From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH iproute2-next v1 8/9] rdma: Add QP resource tracking information
Date: Thu,  4 Jan 2018 09:01:49 +0200
Message-ID: <20180104070150.15625-9-leon@kernel.org>
References: <20180104070150.15625-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104070150.15625-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds ss-similar interface to view various resource
tracked objects. At this stage, only QP is presented.

1. Get all QPs for the specific device:
$ rdma res show qp link mlx5_4
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

$ rdma res show qp link mlx5_4/
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

2. Provide illegal port number (0 is illegal):
$ rdma res show qp link mlx5_4/0
Wrong device name

3. Get QPs of specific port:
$ rdma res show qp link mlx5_4/1
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]

4. Get QPs which have not assigned port yet:
$ rdma res show qp link mlx5_4/-
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]

5. Detailed view:
$ rdma res show qp link mlx5_4/- -d
DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM            SQ-PSN     RQ-PSN     PATH-MIG
mlx5_4/-  8          ---        UD    RESET  0          [ipoib-verbs]   0          ---        ---

6. Limit to specific columns (dev/port is always available):
$ rdma res show qp link mlx5_4/1 display pid,lqpn,comm
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]

7. Detailed view (no change, due to "display" option):
$ rdma res show qp link mlx5_4/1 display pid,lqpn,comm -d
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]

8. Limit to specific Local QPNs:
$ rdma res show qp link mlx5_4/1 display pid,lqpn,comm lqpn 0-6
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 rdma/res.c   | 367 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |  11 ++
 2 files changed, 378 insertions(+)

diff --git a/rdma/res.c b/rdma/res.c
index a70e87dd..ecd6b392 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -16,6 +16,9 @@ static int res_help(struct rd *rd)
 {
 	pr_out("Usage: %s resource\n", rd->filename);
 	pr_out("          resource show [DEV]\n");
+	pr_out("          resource show [qp]\n");
+	pr_out("          resource show qp link [DEV/PORT]\n");
+	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
 
@@ -136,12 +139,376 @@ static int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 		return rd_exec_link(rd, _##name, strict_port); \
 	}
 
+struct column {
+	char filter_name[32];
+	char column_name[32];
+	bool in_simple_view;
+};
+
+static bool show_column(struct rd *rd, struct column *c)
+{
+	if (rd->json_output)
+		return true;
+
+	if (rd_check_is_key_exist(rd, "display"))
+		return rd_check_is_string_filtered(rd, "display", c->filter_name);
+
+	if (!rd->show_details)
+		return c->in_simple_view;
+	return true;
+}
+
+static const char *path_mig_to_str(uint8_t idx)
+{
+	static const char * const path_mig_str[] = { "MIGRATED",
+						     "REARM", "ARMED" };
+
+	if (idx < ARRAY_SIZE(path_mig_str))
+		return path_mig_str[idx];
+	return "UNKNOWN";
+}
+
+static const char *qp_states_to_str(uint8_t idx)
+{
+	static const char * const qp_states_str[] = { "RESET", "INIT",
+						      "RTR", "RTS", "SQD",
+						      "SQE", "ERR" };
+
+	if (idx < ARRAY_SIZE(qp_states_str))
+		return qp_states_str[idx];
+	return "UNKNOWN";
+}
+
+static const char *qp_types_to_str(uint8_t idx)
+{
+	static const char * const qp_types_str[] = { "SMI", "GSI", "RC",
+						     "UC", "UD", "RAW_IPV6",
+						     "RAW_ETHERTYPE",
+						     "UNKNOWN", "RAW_PACKET",
+						     "XRC_INI", "XRC_TGT" };
+
+	if (idx < ARRAY_SIZE(qp_types_str))
+		return qp_types_str[idx];
+	return "UNKNOWN";
+}
+
+static void print_lqpn(struct rd *rd, struct column *c, uint32_t val)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "lqpn")) {
+		if (rd->json_output) {
+			jsonw_uint_field(rd->jw, "lqpn", val);
+			return;
+		}
+		pr_out("%-11u", val);
+	}
+}
+
+static void print_rqpn(struct rd *rd, struct column *c,
+		       uint32_t val, struct nlattr **nla_line)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "rqpn")) {
+		if (rd->json_output) {
+			if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
+				jsonw_uint_field(rd->jw, "rqpn", val);
+			return;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
+			pr_out("%-11u", val);
+		else
+			pr_out("%-11s", "---");
+	}
+}
+
+static void print_type(struct rd *rd, struct column *c, uint32_t val)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "type")) {
+		if (rd->json_output) {
+			jsonw_string_field(rd->jw, "type",
+					   qp_types_to_str(val));
+			return;
+		}
+		pr_out("%-6s", qp_types_to_str(val));
+	}
+}
+
+static void print_state(struct rd *rd, struct column *c, uint32_t val)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "state")) {
+		if (rd->json_output) {
+			jsonw_string_field(rd->jw, "state",
+					   qp_states_to_str(val));
+			return;
+		}
+		pr_out("%-7s", qp_states_to_str(val));
+	}
+}
+
+static void print_rqpsn(struct rd *rd, struct column *c,
+			uint32_t val, struct nlattr **nla_line)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "rq-psn")) {
+		if (rd->json_output) {
+			if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
+				jsonw_uint_field(rd->jw, "rq-psn", val);
+			return;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
+			pr_out("%-11u", val);
+		else
+			pr_out("%-11s", "---");
+	}
+}
+
+static void print_sqpsn(struct rd *rd, struct column *c, uint32_t val)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "sq-psn")) {
+		if (rd->json_output) {
+			jsonw_uint_field(rd->jw, "sq-psn", val);
+			return;
+		}
+		pr_out("%-11d", val);
+	}
+}
+
+static void print_pathmig(struct rd *rd, struct column *c,
+			  uint32_t val, struct nlattr **nla_line)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "path-mig")) {
+		if (rd->json_output) {
+			if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
+				jsonw_string_field(rd->jw,
+						   "path-mig-state",
+						   path_mig_to_str(val));
+			return;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
+			pr_out("%-16s", path_mig_to_str(val));
+		else
+			pr_out("%-16s", "---");
+	}
+}
+
+static void print_pid(struct rd *rd, struct column *c, uint32_t val)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "pid")) {
+		if (rd->json_output) {
+			jsonw_uint_field(rd->jw, "pid", val);
+			return;
+		}
+		pr_out("%-11d", val);
+	}
+}
+
+static void print_comm(struct rd *rd, struct column *c,
+		       const char *str, struct nlattr **nla_line)
+{
+	if (!show_column(rd, c))
+		return;
+
+	if (!strcmpx(c->filter_name, "comm")) {
+		if (rd->json_output) {
+			/* Don't beatify output in JSON format */
+			jsonw_string_field(rd->jw, "comm", str);
+			return;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pr_out("%-16s ", str);
+		} else {
+			char tmp[18];
+
+			snprintf(tmp, sizeof(tmp), "[%s]", str);
+			pr_out("%-16s", tmp);
+		}
+	}
+}
+
+static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	static struct column c[] = { { .filter_name = "lqpn",
+				       .column_name = "LQPN       ",
+				       .in_simple_view = true },
+				     { .filter_name = "rqpn",
+				       .column_name = "RQPN       " },
+				     { .filter_name = "type",
+				       .column_name = "TYPE  ",
+					.in_simple_view = true },
+				     { .filter_name = "state",
+				       .column_name = "STATE  ",
+				       .in_simple_view = true },
+				     { .filter_name = "pid",
+				       .column_name = "PID        ",
+				       .in_simple_view = true },
+				     { .filter_name = "comm",
+				       .column_name = "COMM            ",
+				       .in_simple_view = true },
+				     { .filter_name = "sq-psn",
+				       .column_name = "SQ-PSN     " },
+				     { .filter_name = "rq-psn",
+				       .column_name = "RQ-PSN     " },
+				     { .filter_name = "path-mig",
+				       .column_name = "PATH-MIG        " } };
+
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	static bool print_header = true;
+	struct rd *rd = data;
+	uint32_t cidx, idx;
+	const char *name;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_QP])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
+	if (!rd->json_output && print_header) {
+		pr_out("DEV/PORT  ");
+		for (cidx = 0; cidx < ARRAY_SIZE(c); cidx++)
+			if (show_column(rd, &c[cidx]))
+				pr_out("%s", c[cidx].column_name);
+		pr_out("\n");
+		print_header = false;
+	}
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
+		uint8_t type, state, path_mig_state = 0;
+		uint32_t port = 0, pid = 0;
+		bool ignore_value = false;
+		char port_name[32];
+		const char *comm;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_PID_COMM]) {
+			return -EINVAL;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+			port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+		if (port != rd->port_idx)
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+			snprintf(port_name, 32, "%s/%u", name, port);
+		else
+			snprintf(port_name, 32, "%s/-", name);
+
+		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd_check_is_filtered(rd, "lqpn", lqpn, false))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
+			rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
+		else
+			ignore_value = true;
+
+		if (rd_check_is_filtered(rd, "rqpn", rqpn, ignore_value))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
+			rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
+
+		sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
+			path_mig_state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
+		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+
+		if (rd_check_is_filtered(rd, "pid", pid, false))
+			continue;
+
+		comm = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_PID_COMM]);
+
+		if (rd->json_output) {
+			jsonw_start_array(rd->jw);
+			jsonw_uint_field(rd->jw, "ifindex", idx);
+
+			if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+				jsonw_uint_field(rd->jw, "port", port);
+
+			jsonw_string_field(rd->jw, "ifname", port_name);
+		} else {
+			pr_out("%-10s", port_name);
+		}
+
+		for (cidx = 0; cidx < ARRAY_SIZE(c); cidx++) {
+			print_lqpn(rd, &c[cidx], lqpn);
+			print_rqpn(rd, &c[cidx], rqpn, nla_line);
+
+			print_type(rd, &c[cidx], type);
+			print_state(rd, &c[cidx], state);
+
+			print_rqpsn(rd, &c[cidx], rq_psn, nla_line);
+			print_sqpsn(rd, &c[cidx], sq_psn);
+
+			print_pathmig(rd, &c[cidx], path_mig_state, nla_line);
+			print_pid(rd, &c[cidx], pid);
+			print_comm(rd, &c[cidx], comm, nla_line);
+		}
+
+		if (rd->json_output)
+			jsonw_end_array(rd->jw);
+		else
+			pr_out("\n");
+	}
+	return MNL_CB_OK;
+}
+
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
+static const char * const qp_valid_filters[] = { "link", "lqpn", "rqpn",
+						 "pid", "display", NULL };
+RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
+
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		res_no_args	},
+		{ "qp",		res_qp		},
 		{ 0 }
 	};
 
diff --git a/rdma/utils.c b/rdma/utils.c
index d39e926e..288c6b9b 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -352,6 +352,17 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
 	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]	= MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_RES_QP]		= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_QP_ENTRY]		= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_LQPN]	= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_RQPN]	= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_RQ_PSN]		= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_SQ_PSN]		= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]	= MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_TYPE]		= MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_STATE]		= MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_PID]		= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_PID_COMM]	= MNL_TYPE_NUL_STRING,
 };
 
 int rd_attr_cb(const struct nlattr *attr, void *data)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
