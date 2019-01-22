From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 07/19] rdma: Move out resource CQ logic to separate file
Date: Tue, 22 Jan 2019 20:31:13 +0200
Message-ID: <20190122183125.15920-8-leon@kernel.org>
References: <20190122183125.15920-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Logically separate resource CQ logic to separate file,
in order to make CQ specific logic self-contained.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/res-cq.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/res.c    | 147 --------------------------------------------------
 rdma/res.h    |  13 +++++
 4 files changed, 157 insertions(+), 148 deletions(-)
 create mode 100644 rdma/res-cq.c

diff --git a/rdma/Makefile b/rdma/Makefile
index 0b4e1eef..e32ccd18 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -6,7 +6,7 @@ TARGETS :=
 ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
-RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o
+RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
new file mode 100644
index 00000000..fbfe593b
--- /dev/null
+++ b/rdma/res-cq.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-cq.c	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+static void print_cqe(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "cqe", val);
+	else
+		pr_out("cqe %u ", val);
+}
+
+static const char *poll_ctx_to_str(uint8_t idx)
+{
+	static const char * const cm_id_states_str[] = {
+		"DIRECT", "SOFTIRQ", "WORKQUEUE", "UNBOUND_WORKQUEUE"};
+
+	if (idx < ARRAY_SIZE(cm_id_states_str))
+		return cm_id_states_str[idx];
+	return "UNKNOWN";
+}
+
+static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx)
+{
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "poll-ctx",
+				   poll_ctx_to_str(poll_ctx));
+		return;
+	}
+	pr_out("poll-ctx %s ", poll_ctx_to_str(poll_ctx));
+}
+
+int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_CQ])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_CQ];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char *comm = NULL;
+		uint32_t pid = 0;
+		uint8_t poll_ctx = 0;
+		uint32_t ctxn = 0;
+		uint32_t cqn = 0;
+		uint64_t users;
+		uint32_t cqe;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
+
+		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+		if (rd_check_is_filtered(rd, "users", users))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]) {
+			poll_ctx = mnl_attr_get_u8(
+				nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
+			if (rd_check_is_string_filtered(
+				    rd, "poll-ctx", poll_ctx_to_str(poll_ctx)))
+				continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pid = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+			comm = get_task_name(pid);
+		}
+
+		if (rd_check_is_filtered(rd, "pid", pid)) {
+			free(comm);
+			continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+			cqn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+		if (rd_check_is_filtered(rd, "cqn", cqn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			ctxn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+		if (rd_check_is_filtered(rd, "ctxn", ctxn))
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
+		print_cqe(rd, cqe);
+		print_users(rd, users);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
+			print_poll_ctx(rd, poll_ctx);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+			res_print_uint(rd, "cqn", cqn);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			res_print_uint(rd, "ctxn", ctxn);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			free(comm);
+
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
+	}
+	return MNL_CB_OK;
+}
+
diff --git a/rdma/res.c b/rdma/res.c
index 1de8c797..7956882e 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -695,14 +695,6 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static void print_cqe(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "cqe", val);
-	else
-		pr_out("cqe %u ", val);
-}
-
 void print_users(struct rd *rd, uint64_t val)
 {
 	if (rd->json_output)
@@ -711,133 +703,6 @@ void print_users(struct rd *rd, uint64_t val)
 		pr_out("users %" PRIu64 " ", val);
 }
 
-static const char *poll_ctx_to_str(uint8_t idx)
-{
-	static const char * const cm_id_states_str[] = {
-		"DIRECT", "SOFTIRQ", "WORKQUEUE", "UNBOUND_WORKQUEUE"};
-
-	if (idx < ARRAY_SIZE(cm_id_states_str))
-		return cm_id_states_str[idx];
-	return "UNKNOWN";
-}
-
-static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx)
-{
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "poll-ctx",
-				   poll_ctx_to_str(poll_ctx));
-		return;
-	}
-	pr_out("poll-ctx %s ", poll_ctx_to_str(poll_ctx));
-}
-
-static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
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
-	    !tb[RDMA_NLDEV_ATTR_RES_CQ])
-		return MNL_CB_ERROR;
-
-	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	nla_table = tb[RDMA_NLDEV_ATTR_RES_CQ];
-
-	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		char *comm = NULL;
-		uint32_t pid = 0;
-		uint8_t poll_ctx = 0;
-		uint32_t ctxn = 0;
-		uint32_t cqn = 0;
-		uint64_t users;
-		uint32_t cqe;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return MNL_CB_ERROR;
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
-
-		users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
-		if (rd_check_is_filtered(rd, "users", users))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]) {
-			poll_ctx = mnl_attr_get_u8(
-					nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
-			if (rd_check_is_string_filtered(rd, "poll-ctx",
-						poll_ctx_to_str(poll_ctx)))
-				continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-			pid = mnl_attr_get_u32(
-					nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-			comm = get_task_name(pid);
-		}
-
-		if (rd_check_is_filtered(rd, "pid", pid)) {
-			free(comm);
-			continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
-			cqn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
-		if (rd_check_is_filtered(rd, "cqn", cqn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			ctxn = mnl_attr_get_u32(
-				 nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-		if (rd_check_is_filtered(rd, "ctxn", ctxn))
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
-		print_cqe(rd, cqe);
-		print_users(rd, users);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
-			print_poll_ctx(rd, poll_ctx);
-		print_pid(rd, pid);
-		print_comm(rd, comm, nla_line);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
-			res_print_uint(rd, "cqn", cqn);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-			res_print_uint(rd, "ctxn", ctxn);
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
@@ -875,18 +740,6 @@ struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
 
-static const
-struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
-	{ .name = "dev", .is_number = false },
-	{ .name = "users", .is_number = true },
-	{ .name = "poll-ctx", .is_number = false },
-	{ .name = "pid", .is_number = true },
-	{ .name = "cqn", .is_number = true },
-	{ .name = "ctxn", .is_number = true }
-};
-
-RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
-
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
diff --git a/rdma/res.h b/rdma/res.h
index e3619773..19f0d420 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -11,6 +11,7 @@
 int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback);
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 #define RES_FUNC(name, command, valid_filters, strict_port) \
 	static inline int _##name(struct rd *rd)\
@@ -58,6 +59,18 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
 
+static const
+struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "users", .is_number = true },
+	{ .name = "poll-ctx", .is_number = false },
+	{ .name = "pid", .is_number = true },
+	{ .name = "cqn", .is_number = true },
+	{ .name = "ctxn", .is_number = true }
+};
+
+RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
+
 char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_users(struct rd *rd, uint64_t val);
-- 
2.19.1
