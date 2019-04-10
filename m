From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 2/8] rdma: Add "stat qp show" support
Date: Wed, 10 Apr 2019 14:21:15 +0300
Message-ID: <20190410112121.6790-3-leon@kernel.org>
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

Show qp counters statistics in detail. Filters are also enabled.

Examples:
$ rdma stat qp show
link mlx5_2/1 cntn 5 pid 31609 comm client.1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0 resp_cqe_flush_error 0 req_cqe_flush_error 0
    LQPN: <178>
$ rdma stat show link mlx5_2/1

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/rdma.c   |   3 +-
 rdma/rdma.h   |   1 +
 rdma/stat.c   | 263 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c  |   7 ++
 5 files changed, 274 insertions(+), 2 deletions(-)
 create mode 100644 rdma/stat.c

diff --git a/rdma/Makefile b/rdma/Makefile
index 6a424234..e1af4414 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o
+	   res-cmid.o res-qp.o stat.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 676e03c2..c8984764 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -11,7 +11,7 @@ static void help(char *name)
 {
 	pr_out("Usage: %s [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       %s [ -f[orce] ] -b[atch] filename\n"
-	       "where  OBJECT := { dev | link | resource | help }\n"
+	       "where  OBJECT := { dev | link | resource | statistic | help }\n"
 	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty]}\n", name, name);
 }
 
@@ -29,6 +29,7 @@ static int rd_cmd(struct rd *rd, int argc, char **argv)
 		{ "dev",	cmd_dev },
 		{ "link",	cmd_link },
 		{ "resource",	cmd_res },
+		{ "statistic",	cmd_stat },
 		{ 0 }
 	};
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 9ed9e045..b5ddcb07 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -93,6 +93,7 @@ char *rd_argv(struct rd *rd);
 int cmd_dev(struct rd *rd);
 int cmd_link(struct rd *rd);
 int cmd_res(struct rd *rd);
+int cmd_stat(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_require_dev(struct rd *rd, int (*cb)(struct rd *rd));
diff --git a/rdma/stat.c b/rdma/stat.c
new file mode 100644
index 00000000..0c3abc99
--- /dev/null
+++ b/rdma/stat.c
@@ -0,0 +1,263 @@
+/*
+ * stat.c	RDMA tool
+ *
+ *              This program is free software; you can redistribute it and/or
+ *              modify it under the terms of the GNU General Public License
+ *              as published by the Free Software Foundation; either version
+ *              2 of the License, or (at your option) any later version.
+ *
+ * Authors:     Mark Zhang <markz@mellanox.com>
+ */
+
+#include "rdma.h"
+#include "res.h"
+#include <inttypes.h>
+
+static int stat_help(struct rd *rd)
+{
+	pr_out("Usage: %s [ OPTIONS ] statistic { COMMAND | help }\n", rd->filename);
+	pr_out("       %s statistic OBJECT show\n", rd->filename);
+	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
+	pr_out("Examples:\n");
+	pr_out("       %s statistic qp show\n", rd->filename);
+	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
+
+	return 0;
+}
+
+static int res_show_hwcounters(struct rd *rd, struct nlattr *hwc_table)
+{
+	struct nlattr *nla_entry;
+	const char *nm;
+	uint64_t v;
+	int err;
+
+	mnl_attr_for_each_nested(nla_entry, hwc_table) {
+		struct nlattr *hw_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, hw_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] ||
+		    !hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE]) {
+			return -EINVAL;
+		}
+
+		nm = mnl_attr_get_str(hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+		v = mnl_attr_get_u64(hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE]);
+		res_print_uint(rd, nm, v, hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int res_counter_line(struct rd *rd, const char *name, int index,
+		       struct nlattr **nla_line)
+{
+	uint32_t cntn, port = 0, pid = 0, qpn;
+	struct nlattr *hwc_table, *qp_table;
+	struct nlattr *nla_entry;
+	const char *comm = NULL;
+	int err;
+
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	hwc_table = nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS];
+	qp_table = nla_line[RDMA_NLDEV_ATTR_RES_QP];
+	if (!hwc_table || !qp_table ||
+	    !nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+		return MNL_CB_ERROR;
+
+	cntn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+	if (rd_is_filtered_attr(rd, "cntn", cntn,
+				nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]))
+		return MNL_CB_OK;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
+		return MNL_CB_OK;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	mnl_attr_for_each_nested(nla_entry, qp_table) {
+		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			return -EINVAL;
+
+		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd_is_filtered_attr(rd, "lqpn", qpn,
+					qp_line[RDMA_NLDEV_ATTR_RES_LQPN]))
+			return MNL_CB_OK;
+	}
+
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "ifname", name);
+		if (port)
+			jsonw_uint_field(rd->jw, "port", port);
+		jsonw_uint_field(rd->jw, "cntn", cntn);
+	} else {
+		if (port)
+			pr_out("link %s/%u cntn %u ", name, port, cntn);
+		else
+			pr_out("dev %s cntn %u ", name, cntn);
+	}
+
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	print_comm(rd, comm, nla_line);
+
+	err = res_show_hwcounters(rd, hwc_table);
+	if (err != MNL_CB_OK)
+		return err;
+
+	mnl_attr_for_each_nested(nla_entry, qp_table) {
+		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
+		static bool isfirst = true;
+
+		if (isfirst && !rd->json_output)
+			pr_out("\n    LQPN: <");
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			return -EINVAL;
+
+		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd->json_output) {
+			jsonw_uint_field(rd->jw, "lqpn", qpn);
+		} else {
+			if (isfirst)
+				pr_out("%d", qpn);
+			else
+				pr_out(", %d", qpn);
+		}
+		isfirst = false;
+	}
+
+	if (!rd->json_output)
+		pr_out(">\n");
+	return MNL_CB_OK;
+}
+
+static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+	int ret;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_STAT_COUNTER])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_STAT_COUNTER];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = res_counter_line(rd, name, idx, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+	}
+
+	return ret;
+}
+
+static const struct filters stat_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "cntn", .is_number = true },
+	{ .name = "lqpn", .is_number = true },
+	{ .name = "pid", .is_number = true },
+};
+
+static int stat_qp_show_one_link(struct rd *rd)
+{
+	int flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP;
+	uint32_t seq;
+	int ret;
+
+	if (!rd->port_idx)
+		return 0;
+
+	ret = rd_build_filter(rd, stat_valid_filters);
+	if (ret)
+		return ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, stat_qp_show_parse_cb, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+
+	return ret;
+}
+
+static int stat_qp_show_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_qp_show_one_link, false);
+}
+
+static int stat_qp_show(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_qp_show_link },
+		{ "link",	stat_qp_show_link },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_qp(struct rd *rd)
+{
+	const struct rd_cmd cmds[] =  {
+		{ NULL,		stat_qp_show },
+		{ "show",	stat_qp_show },
+		{ "list",	stat_qp_show },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+int cmd_stat(struct rd *rd)
+{
+	const struct rd_cmd cmds[] =  {
+		{ NULL,		stat_help },
+		{ "help",	stat_help },
+		{ "qp",		stat_qp },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "statistic command");
+}
diff --git a/rdma/utils.c b/rdma/utils.c
index 11ed8a73..ff781517 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -435,6 +435,13 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DRIVER_U32] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_DRIVER_S64] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_DRIVER_U64] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ID] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1
