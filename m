From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v4 iproute2-next 5/7] rdma: Add CQ resource tracking
 information
Date: Thu, 29 Mar 2018 09:10:39 -0700
Message-ID: <e2aef21436bd2e243107eb29b0b6494ac35a4c7f.1522359537.git.swise@opengridcomputing.com>
References: <cover.1522359537.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522359537.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Sample output:

# rdma resource show cq
dev cxgb4_0 cqe 46 users 2 pid 30503 comm rping
dev cxgb4_0 cqe 46 users 2 pid 30498 comm rping
dev mlx4_0 cqe 63 users 2 pid 30494 comm rping
dev mlx4_0 cqe 63 users 2 pid 30489 comm rping
dev mlx4_0 cqe 1023 users 2 poll_ctx WORKQUEUE pid 0 comm [ib_core]

# rdma resource show cq pid 30489
dev mlx4_0 cqe 63 users 2 pid 30489 comm rping

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c   | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |   5 ++
 2 files changed, 154 insertions(+)

diff --git a/rdma/res.c b/rdma/res.c
index 5506cf3..bb5f3dd 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -21,6 +21,8 @@ static int res_help(struct rd *rd)
 	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show cm_id link [DEV/PORT]\n");
 	pr_out("          resource show cm_id link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show cq link [DEV/PORT]\n");
+	pr_out("          resource show cq link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
 
@@ -265,6 +267,16 @@ static void print_comm(struct rd *rd, const char *str,
 	pr_out("comm %s ", tmp);
 }
 
+static void print_dev(struct rd *rd, uint32_t idx, const char *name)
+{
+	if (rd->json_output) {
+		jsonw_uint_field(rd->jw, "ifindex", idx);
+		jsonw_string_field(rd->jw, "ifname", name);
+	} else {
+		pr_out("dev %s ", name);
+	}
+}
+
 static void print_link(struct rd *rd, uint32_t idx, const char *name,
 		       uint32_t port, struct nlattr **nla_line)
 {
@@ -674,6 +686,132 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static void print_cqe(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "cqe", val);
+	else
+		pr_out("cqe %u ", val);
+}
+
+static void print_users(struct rd *rd, uint64_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "users", val);
+	else
+		pr_out("users %" PRIu64 " ", val);
+}
+
+static const char *poll_ctx_to_str(uint8_t idx)
+{
+	static const char * const cm_id_states_str[] = {
+		"DIRECT", "SOFTIRQ", "WORKQUEUE"};
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
+static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_CQ])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_CQ];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char *comm = NULL;
+		uint32_t pid = 0;
+		uint8_t poll_ctx = 0;
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
+					nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
+			if (rd_check_is_string_filtered(rd, "poll-ctx",
+						poll_ctx_to_str(poll_ctx)))
+				continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pid = mnl_attr_get_u32(
+					nla_line[RDMA_NLDEV_ATTR_RES_PID]);
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
+		print_dev(rd, idx, name);
+		print_cqe(rd, cqe);
+		print_users(rd, users);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
+			print_poll_ctx(rd, poll_ctx);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			free(comm);
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
 
 static const struct
@@ -716,12 +854,23 @@ struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
 
+static const
+struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "users", .is_number = true },
+	{ .name = "poll-ctx", .is_number = false },
+	{ .name = "pid", .is_number = true }
+};
+
+RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
+
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		res_no_args	},
 		{ "qp",		res_qp		},
 		{ "cm_id",	res_cm_id	},
+		{ "cq",		res_cq		},
 		{ 0 }
 	};
 
diff --git a/rdma/utils.c b/rdma/utils.c
index ec81737..5e79b62 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -380,6 +380,11 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_PS]		= MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_RES_SRC_ADDR]		= MNL_TYPE_UNSPEC,
 	[RDMA_NLDEV_ATTR_RES_DST_ADDR]		= MNL_TYPE_UNSPEC,
+	[RDMA_NLDEV_ATTR_RES_CQ] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_CQ_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_CQE] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_USECNT] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_RES_POLL_CTX] = MNL_TYPE_U8,
 };
 
 int rd_attr_cb(const struct nlattr *attr, void *data)
-- 
1.8.3.1
