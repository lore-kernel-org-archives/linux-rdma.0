From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 05/19] rdma: Move resource PD logic to separate file
Date: Wed, 20 Feb 2019 09:21:22 +0200
Message-ID: <20190220072136.3840-6-leon@kernel.org>
References: <20190220072136.3840-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Logically separate resource PD logic to separate file,
in order to make PD specific logic self-contained.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/res-pd.c | 110 ++++++++++++++++++++++++++++++++++++
 rdma/res.c    | 154 +++-----------------------------------------------
 rdma/res.h    |  55 ++++++++++++++++++
 4 files changed, 175 insertions(+), 146 deletions(-)
 create mode 100644 rdma/res-pd.c
 create mode 100644 rdma/res.h

diff --git a/rdma/Makefile b/rdma/Makefile
index 0498994f..9c2fb203 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -6,7 +6,7 @@ TARGETS :=
 ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
-RDMA_OBJ = rdma.o utils.o dev.o link.o res.o
+RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
new file mode 100644
index 00000000..d879a21a
--- /dev/null
+++ b/rdma/res-pd.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-pd.c	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_PD])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_PD];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char *comm = NULL;
+		uint32_t ctxn = 0;
+		uint32_t pid = 0;
+		uint32_t pdn = 0;
+		uint64_t users;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+			local_dma_lkey = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
+
+		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+		if (rd_check_is_filtered(rd, "users", users))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+			unsafe_global_rkey = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pid = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+			comm = get_task_name(pid);
+		}
+
+		if (rd_check_is_filtered(rd, "pid", pid))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			ctxn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+
+		if (rd_check_is_filtered(rd, "ctxn", ctxn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			pdn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+		if (rd_check_is_filtered(rd, "pdn", pdn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+			/* discard const from mnl_attr_get_str */
+			comm = (char *)mnl_attr_get_str(
+				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+		if (rd->json_output)
+			jsonw_start_array(rd->jw);
+
+		print_dev(rd, idx, name);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
+			print_key(rd, "local_dma_lkey", local_dma_lkey);
+		print_users(rd, users);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
+			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			res_print_uint(rd, "ctxn", ctxn);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			res_print_uint(rd, "pdn", pdn);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			free(comm);
+
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
+	}
+	return MNL_CB_OK;
+}
diff --git a/rdma/res.c b/rdma/res.c
index 308f66c0..494a82e4 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -9,7 +9,7 @@
  * Authors:     Leon Romanovsky <leonro@mellanox.com>
  */
 
-#include "rdma.h"
+#include "res.h"
 #include <inttypes.h>
 
 static int res_help(struct rd *rd)
@@ -92,7 +92,7 @@ static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
+int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 {
 	uint32_t flags = NLM_F_REQUEST | NLM_F_ACK;
 	uint32_t seq;
@@ -119,27 +119,6 @@ static int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 	return ret;
 }
 
-#define RES_FUNC(name, command, valid_filters, strict_port) \
-	static int _##name(struct rd *rd)\
-	{ \
-		return _res_send_msg(rd, command, name##_parse_cb); \
-	} \
-	static int name(struct rd *rd) \
-	{\
-		int ret = rd_build_filter(rd, valid_filters); \
-		if (ret) \
-			return ret; \
-		if ((uintptr_t)valid_filters != (uintptr_t)NULL) { \
-			ret = rd_set_arg_to_devname(rd); \
-			if (ret) \
-				return ret;\
-		} \
-		if (strict_port) \
-			return rd_exec_dev(rd, _##name); \
-		else \
-			return rd_exec_link(rd, _##name, strict_port); \
-	}
-
 static const char *path_mig_to_str(uint8_t idx)
 {
 	static const char * const path_mig_str[] = { "MIGRATED",
@@ -244,7 +223,7 @@ static void print_pathmig(struct rd *rd, uint32_t val,
 		pr_out("path-mig-state %s ", path_mig_to_str(val));
 }
 
-static void print_pid(struct rd *rd, uint32_t val)
+void print_pid(struct rd *rd, uint32_t val)
 {
 	if (rd->json_output)
 		jsonw_uint_field(rd->jw, "pid", val);
@@ -252,8 +231,7 @@ static void print_pid(struct rd *rd, uint32_t val)
 		pr_out("pid %u ", val);
 }
 
-static void print_comm(struct rd *rd, const char *str,
-		       struct nlattr **nla_line)
+void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 {
 	char tmp[18];
 
@@ -271,7 +249,7 @@ static void print_comm(struct rd *rd, const char *str,
 	pr_out("comm %s ", tmp);
 }
 
-static void print_dev(struct rd *rd, uint32_t idx, const char *name)
+void print_dev(struct rd *rd, uint32_t idx, const char *name)
 {
 	if (rd->json_output) {
 		jsonw_uint_field(rd->jw, "ifindex", idx);
@@ -299,7 +277,7 @@ static void print_link(struct rd *rd, uint32_t idx, const char *name,
 	}
 }
 
-static char *get_task_name(uint32_t pid)
+char *get_task_name(uint32_t pid)
 {
 	char *comm;
 	FILE *f;
@@ -320,7 +298,7 @@ static char *get_task_name(uint32_t pid)
 	return comm;
 }
 
-static void print_key(struct rd *rd, const char *name, uint64_t val)
+void print_key(struct rd *rd, const char *name, uint64_t val)
 {
 	if (rd->json_output)
 		jsonw_xint_field(rd->jw, name, val);
@@ -328,7 +306,7 @@ static void print_key(struct rd *rd, const char *name, uint64_t val)
 		pr_out("%s 0x%" PRIx64 " ", name, val);
 }
 
-static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
+void res_print_uint(struct rd *rd, const char *name, uint64_t val)
 {
 	if (rd->json_output)
 		jsonw_uint_field(rd->jw, name, val);
@@ -725,7 +703,7 @@ static void print_cqe(struct rd *rd, uint32_t val)
 		pr_out("cqe %u ", val);
 }
 
-static void print_users(struct rd *rd, uint64_t val)
+void print_users(struct rd *rd, uint64_t val)
 {
 	if (rd->json_output)
 		jsonw_uint_field(rd->jw, "users", val);
@@ -969,108 +947,6 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
-	struct nlattr *nla_table, *nla_entry;
-	struct rd *rd = data;
-	const char *name;
-	uint32_t idx;
-
-	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
-	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
-	    !tb[RDMA_NLDEV_ATTR_RES_PD])
-		return MNL_CB_ERROR;
-
-	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	nla_table = tb[RDMA_NLDEV_ATTR_RES_PD];
-
-	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		char *comm = NULL;
-		uint32_t ctxn = 0;
-		uint32_t pid = 0;
-		uint32_t pdn = 0;
-		uint64_t users;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return MNL_CB_ERROR;
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
-			local_dma_lkey = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
-
-		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
-		if (rd_check_is_filtered(rd, "users", users))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
-			unsafe_global_rkey = mnl_attr_get_u32(
-			      nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-			pid = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-			comm = get_task_name(pid);
-		}
-
-                if (rd_check_is_filtered(rd, "pid", pid))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-
-		if (rd_check_is_filtered(rd, "ctxn", ctxn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			pdn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-		if (rd_check_is_filtered(rd, "pdn", pdn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-			/* discard const from mnl_attr_get_str */
-			comm = (char *)mnl_attr_get_str(
-				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
-		if (rd->json_output)
-			jsonw_start_array(rd->jw);
-
-		print_dev(rd, idx, name);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
-			print_key(rd, "local_dma_lkey", local_dma_lkey);
-		print_users(rd, users);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
-			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
-		print_pid(rd, pid);
-		print_comm(rd, comm, nla_line);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			res_print_uint(rd, "ctxn", ctxn);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			res_print_uint(rd, "pdn", pdn);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-			free(comm);
-
-		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
-		newline(rd);
-	}
-	return MNL_CB_OK;
-}
-
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
 static const struct
@@ -1133,18 +1009,6 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
 
-static const
-struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
-	{ .name = "dev", .is_number = false },
-	{ .name = "users", .is_number = true },
-	{ .name = "pid", .is_number = true },
-	{ .name = "ctxn", .is_number = true },
-	{ .name = "pdn", .is_number = true },
-	{ .name = "ctxn", .is_number = true }
-};
-
-RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
-
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
diff --git a/rdma/res.h b/rdma/res.h
new file mode 100644
index 00000000..dd01b803
--- /dev/null
+++ b/rdma/res.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * res.h	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+#ifndef _RDMA_TOOL_RES_H_
+#define _RDMA_TOOL_RES_H_
+
+#include "rdma.h"
+
+int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback);
+int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
+
+#define RES_FUNC(name, command, valid_filters, strict_port) \
+	static inline int _##name(struct rd *rd)\
+	{ \
+		return _res_send_msg(rd, command, name##_parse_cb); \
+	} \
+	static inline int name(struct rd *rd) \
+	{\
+		int ret = rd_build_filter(rd, valid_filters); \
+		if (ret) \
+			return ret; \
+		if ((uintptr_t)valid_filters != (uintptr_t)NULL) { \
+			ret = rd_set_arg_to_devname(rd); \
+			if (ret) \
+				return ret;\
+		} \
+		if (strict_port) \
+			return rd_exec_dev(rd, _##name); \
+		else \
+			return rd_exec_link(rd, _##name, strict_port); \
+	}
+
+static const
+struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "users", .is_number = true },
+	{ .name = "pid", .is_number = true },
+	{ .name = "ctxn", .is_number = true },
+	{ .name = "pdn", .is_number = true },
+	{ .name = "ctxn", .is_number = true }
+};
+
+RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
+
+char *get_task_name(uint32_t pid);
+void print_dev(struct rd *rd, uint32_t idx, const char *name);
+void print_users(struct rd *rd, uint64_t val);
+void print_key(struct rd *rd, const char *name, uint64_t val);
+void res_print_uint(struct rd *rd, const char *name, uint64_t val);
+void print_pid(struct rd *rd, uint32_t val);
+void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
+
+#endif /* _RDMA_TOOL_RES_H_ */
-- 
2.19.1
