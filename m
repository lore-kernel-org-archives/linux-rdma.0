From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 09/19] rdma: Move resource PD logic to separate file
Date: Tue, 22 Jan 2019 20:31:15 +0200
Message-ID: <20190122183125.15920-10-leon@kernel.org>
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

Logically separate resource PD logic to separate file,
in order to make PD specific logic self-contained.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/res-qp.c | 234 +++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/res.c    | 236 --------------------------------------------------
 rdma/res.h    |  17 ++++
 4 files changed, 252 insertions(+), 237 deletions(-)
 create mode 100644 rdma/res-qp.c

diff --git a/rdma/Makefile b/rdma/Makefile
index ef240404..ad7f4177 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o
+	   res-cmid.o res-qp.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
new file mode 100644
index 00000000..85725fea
--- /dev/null
+++ b/rdma/res-qp.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-qp.c	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+static const char *path_mig_to_str(uint8_t idx)
+{
+	static const char *const path_mig_str[] = { "MIGRATED", "REARM",
+						    "ARMED" };
+
+	if (idx < ARRAY_SIZE(path_mig_str))
+		return path_mig_str[idx];
+	return "UNKNOWN";
+}
+
+static const char *qp_states_to_str(uint8_t idx)
+{
+	static const char *const qp_states_str[] = { "RESET", "INIT", "RTR",
+						     "RTS",   "SQD",  "SQE",
+						     "ERR" };
+
+	if (idx < ARRAY_SIZE(qp_states_str))
+		return qp_states_str[idx];
+	return "UNKNOWN";
+}
+
+static void print_rqpn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
+{
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
+		return;
+
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "rqpn", val);
+	else
+		pr_out("rqpn %u ", val);
+}
+
+static void print_type(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_string_field(rd->jw, "type", qp_types_to_str(val));
+	else
+		pr_out("type %s ", qp_types_to_str(val));
+}
+
+static void print_state(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_string_field(rd->jw, "state", qp_states_to_str(val));
+	else
+		pr_out("state %s ", qp_states_to_str(val));
+}
+
+static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
+{
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
+		return;
+
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "rq-psn", val);
+	else
+		pr_out("rq-psn %u ", val);
+}
+
+static void print_sqpsn(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "sq-psn", val);
+	else
+		pr_out("sq-psn %u ", val);
+}
+
+static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
+{
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
+		return;
+
+	if (rd->json_output)
+		jsonw_string_field(rd->jw, "path-mig-state",
+				   path_mig_to_str(val));
+	else
+		pr_out("path-mig-state %s ", path_mig_to_str(val));
+}
+
+int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_QP])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
+		uint8_t type, state, path_mig_state = 0;
+		uint32_t port = 0, pid = 0;
+		uint32_t pdn = 0;
+		char *comm = NULL;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+			port = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+		if (port != rd->port_idx)
+			continue;
+
+		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd_check_is_filtered(rd, "lqpn", lqpn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			pdn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+		if (rd_check_is_filtered(rd, "pdn", pdn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
+			rqpn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
+			if (rd_check_is_filtered(rd, "rqpn", rqpn))
+				continue;
+		} else {
+			if (rd_check_is_key_exist(rd, "rqpn"))
+				continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
+			rq_psn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
+			if (rd_check_is_filtered(rd, "rq-psn", rq_psn))
+				continue;
+		} else {
+			if (rd_check_is_key_exist(rd, "rq-psn"))
+				continue;
+		}
+
+		sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
+		if (rd_check_is_filtered(rd, "sq-psn", sq_psn))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]) {
+			path_mig_state = mnl_attr_get_u8(
+				nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
+			if (rd_check_is_string_filtered(
+				    rd, "path-mig-state",
+				    path_mig_to_str(path_mig_state)))
+				continue;
+		} else {
+			if (rd_check_is_key_exist(rd, "path-mig-state"))
+				continue;
+		}
+
+		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+		if (rd_check_is_string_filtered(rd, "type",
+						qp_types_to_str(type)))
+			continue;
+
+		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
+		if (rd_check_is_string_filtered(rd, "state",
+						qp_states_to_str(state)))
+			continue;
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
+		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+			/* discard const from mnl_attr_get_str */
+			comm = (char *)mnl_attr_get_str(
+				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+		if (rd->json_output)
+			jsonw_start_array(rd->jw);
+
+		print_link(rd, idx, name, port, nla_line);
+
+		print_lqpn(rd, lqpn);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			res_print_uint(rd, "pdn", pdn);
+		print_rqpn(rd, rqpn, nla_line);
+
+		print_type(rd, type);
+		print_state(rd, state);
+
+		print_rqpsn(rd, rq_psn, nla_line);
+		print_sqpsn(rd, sq_psn);
+
+		print_pathmig(rd, path_mig_state, nla_line);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
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
index d5ae60e1..6d4da38c 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -119,27 +119,6 @@ int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 	return ret;
 }
 
-static const char *path_mig_to_str(uint8_t idx)
-{
-	static const char * const path_mig_str[] = { "MIGRATED",
-						     "REARM", "ARMED" };
-
-	if (idx < ARRAY_SIZE(path_mig_str))
-		return path_mig_str[idx];
-	return "UNKNOWN";
-}
-
-static const char *qp_states_to_str(uint8_t idx)
-{
-	static const char * const qp_states_str[] = { "RESET", "INIT",
-						      "RTR", "RTS", "SQD",
-						      "SQE", "ERR" };
-
-	if (idx < ARRAY_SIZE(qp_states_str))
-		return qp_states_str[idx];
-	return "UNKNOWN";
-}
-
 const char *qp_types_to_str(uint8_t idx)
 {
 	static const char * const qp_types_str[] = { "SMI", "GSI", "RC",
@@ -161,68 +140,6 @@ void print_lqpn(struct rd *rd, uint32_t val)
 		pr_out("lqpn %u ", val);
 }
 
-static void print_rqpn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
-{
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
-		return;
-
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "rqpn", val);
-	else
-		pr_out("rqpn %u ", val);
-}
-
-static void print_type(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "type",
-				   qp_types_to_str(val));
-	else
-		pr_out("type %s ", qp_types_to_str(val));
-}
-
-static void print_state(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "state",
-				   qp_states_to_str(val));
-	else
-		pr_out("state %s ", qp_states_to_str(val));
-}
-
-static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
-{
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
-		return;
-
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "rq-psn", val);
-	else
-		pr_out("rq-psn %u ", val);
-}
-
-static void print_sqpsn(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "sq-psn", val);
-	else
-		pr_out("sq-psn %u ", val);
-}
-
-static void print_pathmig(struct rd *rd, uint32_t val,
-			  struct nlattr **nla_line)
-{
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
-		return;
-
-	if (rd->json_output)
-		jsonw_string_field(rd->jw,
-				   "path-mig-state",
-				   path_mig_to_str(val));
-	else
-		pr_out("path-mig-state %s ", path_mig_to_str(val));
-}
-
 void print_pid(struct rd *rd, uint32_t val)
 {
 	if (rd->json_output)
@@ -314,143 +231,6 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val)
 		pr_out("%s %" PRIu64 " ", name, val);
 }
 
-static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
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
-	    !tb[RDMA_NLDEV_ATTR_RES_QP])
-		return MNL_CB_ERROR;
-
-	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
-
-	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
-		uint8_t type, state, path_mig_state = 0;
-		uint32_t port = 0, pid = 0;
-		uint32_t pdn = 0;
-		char *comm = NULL;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return MNL_CB_ERROR;
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-			port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
-
-		if (port != rd->port_idx)
-			continue;
-
-		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (rd_check_is_filtered(rd, "lqpn", lqpn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-		if (rd_check_is_filtered(rd, "pdn", pdn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
-			rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
-			if (rd_check_is_filtered(rd, "rqpn", rqpn))
-				continue;
-		} else {
-			if (rd_check_is_key_exist(rd, "rqpn"))
-				continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
-			rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
-			if (rd_check_is_filtered(rd, "rq-psn", rq_psn))
-				continue;
-		} else {
-			if (rd_check_is_key_exist(rd, "rq-psn"))
-				continue;
-		}
-
-		sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
-		if (rd_check_is_filtered(rd, "sq-psn", sq_psn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]) {
-			path_mig_state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
-			if (rd_check_is_string_filtered(rd, "path-mig-state", path_mig_to_str(path_mig_state)))
-				continue;
-		} else {
-			if (rd_check_is_key_exist(rd, "path-mig-state"))
-				continue;
-		}
-
-		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
-		if (rd_check_is_string_filtered(rd, "type", qp_types_to_str(type)))
-			continue;
-
-		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
-		if (rd_check_is_string_filtered(rd, "state", qp_states_to_str(state)))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-			pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-			comm = get_task_name(pid);
-		}
-
-		if (rd_check_is_filtered(rd, "pid", pid)) {
-			free(comm);
-			continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-			/* discard const from mnl_attr_get_str */
-			comm = (char *)mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
-		if (rd->json_output)
-			jsonw_start_array(rd->jw);
-
-		print_link(rd, idx, name, port, nla_line);
-
-		print_lqpn(rd, lqpn);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			res_print_uint(rd, "pdn", pdn);
-		print_rqpn(rd, rqpn, nla_line);
-
-		print_type(rd, type);
-		print_state(rd, state);
-
-		print_rqpsn(rd, rq_psn, nla_line);
-		print_sqpsn(rd, sq_psn);
-
-		print_pathmig(rd, path_mig_state, nla_line);
-		print_pid(rd, pid);
-		print_comm(rd, comm, nla_line);
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
 void print_users(struct rd *rd, uint64_t val)
 {
 	if (rd->json_output)
@@ -461,22 +241,6 @@ void print_users(struct rd *rd, uint64_t val)
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
-static const struct
-filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
-	{ .name = "link", .is_number = false },
-	{ .name = "lqpn", .is_number = true },
-	{ .name = "rqpn", .is_number = true },
-	{ .name = "pid",  .is_number = true },
-	{ .name = "sq-psn", .is_number = true },
-	{ .name = "rq-psn", .is_number = true },
-	{ .name = "type", .is_number = false },
-	{ .name = "path-mig-state", .is_number = false },
-	{ .name = "state", .is_number = false },
-	{ .name = "pdn", .is_number = true },
-};
-
-RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
-
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
diff --git a/rdma/res.h b/rdma/res.h
index e9d0d12e..95d88a3a 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -13,6 +13,7 @@ int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 #define RES_FUNC(name, command, valid_filters, strict_port) \
 	static inline int _##name(struct rd *rd)\
@@ -91,6 +92,22 @@ struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
 
+static const struct
+filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "link", .is_number = false },
+	{ .name = "lqpn", .is_number = true },
+	{ .name = "rqpn", .is_number = true },
+	{ .name = "pid",  .is_number = true },
+	{ .name = "sq-psn", .is_number = true },
+	{ .name = "rq-psn", .is_number = true },
+	{ .name = "type", .is_number = false },
+	{ .name = "path-mig-state", .is_number = false },
+	{ .name = "state", .is_number = false },
+	{ .name = "pdn", .is_number = true },
+};
+
+RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
+
 char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
-- 
2.19.1
