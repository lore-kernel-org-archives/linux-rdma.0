From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 06/19] rdma: Refactor out resource MR logic to separate file
Date: Sat, 23 Feb 2019 11:15:15 +0200
Message-ID: <20190223091528.8509-7-leon@kernel.org>
References: <20190223091528.8509-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223091528.8509-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Logically separate resource MR logic to separate file,
in order to make MR specific logic self-contained.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/res-mr.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++
 rdma/res.c    | 122 --------------------------------------------------
 rdma/res.h    |  14 ++++++
 4 files changed, 132 insertions(+), 123 deletions(-)
 create mode 100644 rdma/res-mr.c

diff --git a/rdma/Makefile b/rdma/Makefile
index 9c2fb203..0b4e1eef 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -6,7 +6,7 @@ TARGETS :=
 ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
-RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o
+RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
new file mode 100644
index 00000000..dae5def2
--- /dev/null
+++ b/rdma/res-mr.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-mr.c	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_MR])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_MR];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		uint32_t rkey = 0, lkey = 0;
+		uint64_t iova = 0, mrlen;
+		char *comm = NULL;
+		uint32_t pdn = 0;
+		uint32_t mrn = 0;
+		uint32_t pid = 0;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
+			rkey = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
+			lkey = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
+			iova = mnl_attr_get_u64(
+				nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
+
+		mrlen = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
+		if (rd_check_is_filtered(rd, "mrlen", mrlen))
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
+		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
+			mrn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+		if (rd_check_is_filtered(rd, "mrn", mrn))
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
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
+			print_key(rd, "rkey", rkey);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
+			print_key(rd, "lkey", lkey);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
+			print_key(rd, "iova", iova);
+		res_print_uint(rd, "mrlen", mrlen);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
+			res_print_uint(rd, "mrn", mrn);
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
+
diff --git a/rdma/res.c b/rdma/res.c
index 494a82e4..1de8c797 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -838,115 +838,6 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
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
-	    !tb[RDMA_NLDEV_ATTR_RES_MR])
-		return MNL_CB_ERROR;
-
-	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	nla_table = tb[RDMA_NLDEV_ATTR_RES_MR];
-
-	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		uint32_t rkey = 0, lkey = 0;
-		uint64_t iova = 0, mrlen;
-		char *comm = NULL;
-		uint32_t pdn = 0;
-		uint32_t mrn = 0;
-		uint32_t pid = 0;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return MNL_CB_ERROR;
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
-			rkey = mnl_attr_get_u32(
-					nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
-			lkey = mnl_attr_get_u32(
-					nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
-			iova = mnl_attr_get_u64(
-					nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
-
-		mrlen = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
-		if (rd_check_is_filtered(rd, "mrlen", mrlen))
-			continue;
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
-		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
-			mrn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
-		if (rd_check_is_filtered(rd, "mrn", mrn))
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
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
-			print_key(rd, "rkey", rkey);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
-			print_key(rd, "lkey", lkey);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
-			print_key(rd, "iova", iova);
-		res_print_uint(rd, "mrlen", mrlen);
-		print_pid(rd, pid);
-		print_comm(rd, comm, nla_line);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
-			res_print_uint(rd, "mrn", mrn);
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
@@ -996,19 +887,6 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
 
-static const
-struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
-	{ .name = "dev", .is_number = false },
-	{ .name = "rkey", .is_number = true },
-	{ .name = "lkey", .is_number = true },
-	{ .name = "mrlen", .is_number = true },
-	{ .name = "pid", .is_number = true },
-	{ .name = "mrn", .is_number = true },
-	{ .name = "pdn", .is_number = true }
-};
-
-RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
-
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
diff --git a/rdma/res.h b/rdma/res.h
index dd01b803..e3619773 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -10,6 +10,7 @@
 
 int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback);
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 #define RES_FUNC(name, command, valid_filters, strict_port) \
 	static inline int _##name(struct rd *rd)\
@@ -44,6 +45,19 @@ struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
 
+static const
+struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "rkey", .is_number = true },
+	{ .name = "lkey", .is_number = true },
+	{ .name = "mrlen", .is_number = true },
+	{ .name = "pid", .is_number = true },
+	{ .name = "mrn", .is_number = true },
+	{ .name = "pdn", .is_number = true }
+};
+
+RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
+
 char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_users(struct rd *rd, uint64_t val);
-- 
2.19.1
