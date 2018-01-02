From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 7/9] rdma: Add resource tracking summary
Date: Tue,  2 Jan 2018 11:37:23 +0200
Message-ID: <20180102093725.6172-8-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102093725.6172-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The global resource summary information. The object names, current utilization
and maximum numbers are received as is from the kernel.

$ rdma res
1: mlx5_0: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
2: mlx5_1: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
3: mlx5_2: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
4: mlx5_3: curr/max: pd 2/16777216 cq 3/16777216 qp 2/262144
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144

$ rdma res show mlx5_4
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/rdma.c   |   3 +-
 rdma/rdma.h   |   1 +
 rdma/res.c    | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c  |   5 ++
 5 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100644 rdma/res.c

diff --git a/rdma/Makefile b/rdma/Makefile
index c8966bfd..875fe53c 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -3,7 +3,7 @@ include ../config.mk
 
 ifeq ($(HAVE_MNL),y)
 
-RDMA_OBJ = rdma.o utils.o dev.o link.o
+RDMA_OBJ = rdma.o utils.o dev.o link.o res.o
 
 TARGETS=rdma
 endif
diff --git a/rdma/rdma.c b/rdma/rdma.c
index a21ba440..19608f41 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -15,7 +15,7 @@
 static void help(char *name)
 {
 	pr_out("Usage: %s [ OPTIONS ] OBJECT { COMMAND | help }\n"
-	       "where  OBJECT := { dev | link | help }\n"
+	       "where  OBJECT := { dev | link | resource | help }\n"
 	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty]}\n", name);
 }
 
@@ -32,6 +32,7 @@ static int rd_cmd(struct rd *rd)
 		{ "help",	cmd_help },
 		{ "dev",	cmd_dev },
 		{ "link",	cmd_link },
+		{ "resource",	cmd_res },
 		{ 0 }
 	};
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 816c8ddd..f1ddedd2 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -77,6 +77,7 @@ char *rd_argv(struct rd *rd);
  */
 int cmd_dev(struct rd *rd);
 int cmd_link(struct rd *rd);
+int cmd_res(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
diff --git a/rdma/res.c b/rdma/res.c
new file mode 100644
index 00000000..a70e87dd
--- /dev/null
+++ b/rdma/res.c
@@ -0,0 +1,168 @@
+/*
+ * res.c	RDMA tool
+ *
+ *              This program is free software; you can redistribute it and/or
+ *              modify it under the terms of the GNU General Public License
+ *              as published by the Free Software Foundation; either version
+ *              2 of the License, or (at your option) any later version.
+ *
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "rdma.h"
+#include <inttypes.h>
+
+static int res_help(struct rd *rd)
+{
+	pr_out("Usage: %s resource\n", rd->filename);
+	pr_out("          resource show [DEV]\n");
+	return 0;
+}
+
+static int res_print_summary(struct rd *rd, struct nlattr **tb)
+{
+	struct nlattr *nla_table = tb[RDMA_NLDEV_ATTR_RES_SUMMARY];
+	struct nlattr *nla_entry;
+	uint64_t max, curr;
+	const char *name;
+	int err;
+
+	if (!rd->json_output)
+		pr_out("curr/max: ");
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char json_name[32];
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]) {
+			return -EINVAL;
+		}
+
+		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
+		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
+		if (rd->json_output) {
+			snprintf(json_name, 32, "curr_%s", name);
+			jsonw_lluint_field(rd->jw, json_name, curr);
+		}
+
+		max = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]);
+		if (rd->json_output) {
+			snprintf(json_name, 32, "max_%s", name);
+			jsonw_lluint_field(rd->jw, json_name, max);
+		} else {
+			pr_out("%s %"PRId64 "/%"PRId64 " ", name, curr, max);
+		}
+	}
+	return 0;
+}
+
+static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_SUMMARY])
+		return MNL_CB_ERROR;
+
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	if (rd->json_output) {
+		jsonw_uint_field(rd->jw, "ifindex", idx);
+		jsonw_string_field(rd->jw, "ifname", name);
+	} else {
+		pr_out("%u: %s: ", idx, name);
+	}
+
+	res_print_summary(rd, tb);
+
+	if (!rd->json_output)
+		pr_out("\n");
+	return MNL_CB_OK;
+}
+
+static int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
+{
+	uint32_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	uint32_t seq;
+	int ret;
+
+	if (command != RDMA_NLDEV_CMD_RES_GET)
+		flags |= NLM_F_DUMP;
+
+	rd_prepare_msg(rd, command, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	if (rd->port_idx)
+		mnl_attr_put_u32(rd->nlh,
+				 RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, callback, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+	return ret;
+}
+
+#define RES_FUNC(name, command, valid_filters, strict_port) \
+	static int _##name(struct rd *rd)\
+	{ \
+		return _res_send_msg(rd, command, name##_parse_cb); \
+	} \
+	static int name(struct rd *rd) \
+	{\
+		int ret = rd_build_filter(rd, valid_filters); \
+		if (ret) \
+			return ret; \
+		if ((uintptr_t)valid_filters != (uintptr_t)NULL) { \
+			ret = rd_set_arg_to_devname(rd); \
+			if (ret) \
+				return ret;\
+		} \
+		return rd_exec_link(rd, _##name, strict_port); \
+	}
+
+RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
+
+static int res_show(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		res_no_args	},
+		{ 0 }
+	};
+
+	/*
+	 * Special case to support "rdma res show DEV_NAME"
+	 */
+	if (rd_argc(rd) == 1 && dev_map_lookup(rd, false))
+		return rd_exec_dev(rd, _res_no_args);
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+int cmd_res(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		res_show },
+		{ "show",	res_show },
+		{ "list",	res_show },
+		{ "help",	res_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "resource command");
+}
diff --git a/rdma/utils.c b/rdma/utils.c
index a63a7c2f..859ad7ab 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -339,6 +339,11 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_PORT_STATE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_ATTR_PORT_PHYS_STATE] = MNL_TYPE_U8,
 	[RDMA_NLDEV_ATTR_DEV_NODE_TYPE] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY]	= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY]	= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]	= MNL_TYPE_U64,
 };
 
 int rd_attr_cb(const struct nlattr *attr, void *data)
-- 
2.15.1
