From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 7/8] rdma: Add MR resource tracking
 information
Date: Mon, 26 Mar 2018 13:57:39 -0700
Message-ID: <4f1876e2a31e9b6d0784131bda2140d421f25ffb.1522097991.git.swise@opengridcomputing.com>
References: <cover.1522097991.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522097991.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Sample output:

Without CAP_NET_ADMIN:

$ rdma resource show mr mrlen 65536
link mlx4_0/- mrlen 65536 pid 0 comm [nvme_rdma]
link cxgb4_0/- mrlen 65536 pid 0 comm [nvme_rdma]

With CAP_NET_ADMIN:

# rdma resource show mr mrlen 65536
link mlx4_0/- rkey 0x12702 lkey 0x12702 iova 0x85724a000 mrlen 65536 pid 0 comm [nvme_rdma]
link cxgb4_0/- rkey 0x68fe4e9 lkey 0x68fe4e9 iova 0x835b91000 mrlen 65536 pid 0 comm [nvme_rdma]

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/json_writer.h |   2 +
 lib/json_writer.c     |  11 +++++
 rdma/res.c            | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c          |   6 +++
 4 files changed, 146 insertions(+)

diff --git a/include/json_writer.h b/include/json_writer.h
index 45459fa..4b4dec2 100644
--- a/include/json_writer.h
+++ b/include/json_writer.h
@@ -35,6 +35,7 @@ void jsonw_bool(json_writer_t *self, bool value);
 void jsonw_float(json_writer_t *self, double number);
 void jsonw_float_fmt(json_writer_t *self, const char *fmt, double num);
 void jsonw_uint(json_writer_t *self, uint64_t number);
+void jsonw_xint(json_writer_t *self, uint64_t number);
 void jsonw_hu(json_writer_t *self, unsigned short number);
 void jsonw_int(json_writer_t *self, int64_t number);
 void jsonw_null(json_writer_t *self);
@@ -45,6 +46,7 @@ void jsonw_string_field(json_writer_t *self, const char *prop, const char *val);
 void jsonw_bool_field(json_writer_t *self, const char *prop, bool value);
 void jsonw_float_field(json_writer_t *self, const char *prop, double num);
 void jsonw_uint_field(json_writer_t *self, const char *prop, uint64_t num);
+void jsonw_xint_field(json_writer_t *self, const char *prop, uint64_t num);
 void jsonw_hu_field(json_writer_t *self, const char *prop, unsigned short num);
 void jsonw_int_field(json_writer_t *self, const char *prop, int64_t num);
 void jsonw_null_field(json_writer_t *self, const char *prop);
diff --git a/lib/json_writer.c b/lib/json_writer.c
index 68401ae..0ad0421 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -225,6 +225,11 @@ void jsonw_uint(json_writer_t *self, uint64_t num)
 	jsonw_printf(self, "%"PRIu64, num);
 }
 
+void jsonw_xint(json_writer_t *self, uint64_t num)
+{
+	jsonw_printf(self, "%"PRIx64, num);
+}
+
 void jsonw_lluint(json_writer_t *self, unsigned long long int num)
 {
 	jsonw_printf(self, "%llu", num);
@@ -269,6 +274,12 @@ void jsonw_uint_field(json_writer_t *self, const char *prop, uint64_t num)
 	jsonw_uint(self, num);
 }
 
+void jsonw_xint_field(json_writer_t *self, const char *prop, uint64_t num)
+{
+	jsonw_name(self, prop);
+	jsonw_xint(self, num);
+}
+
 void jsonw_hu_field(json_writer_t *self, const char *prop, unsigned short num)
 {
 	jsonw_name(self, prop);
diff --git a/rdma/res.c b/rdma/res.c
index f1a90d3..aa61e73 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -802,6 +802,121 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static void print_key(struct rd *rd, const char *name, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_xint_field(rd->jw, name, val);
+	else
+		pr_out("%s 0x%x ", name, val);
+}
+
+static void print_iova(struct rd *rd, uint64_t val)
+{
+	if (rd->json_output)
+		jsonw_xint_field(rd->jw, "iova", val);
+	else
+		pr_out("iova 0x%" PRIx64 " ", val);
+}
+
+static void print_mrlen(struct rd *rd, uint64_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, "mrlen", val);
+	else
+		pr_out("mrlen %" PRIu64 " ", val);
+}
+
+static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
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
+	    !tb[RDMA_NLDEV_ATTR_RES_MR])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_MR];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		uint32_t rkey = 0, lkey = 0;
+		uint64_t iova = 0, mrlen;
+		char *comm = NULL;
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
+					nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
+			lkey = mnl_attr_get_u32(
+					nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
+			iova = mnl_attr_get_u64(
+					nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
+
+		mrlen = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
+		if (rd_check_is_filtered(rd, "mrlen", mrlen)) 
+			continue;
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
+		print_link(rd, idx, name, 0, nla_line);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
+			print_key(rd, "rkey", rkey);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
+			print_key(rd, "lkey", lkey);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
+			print_iova(rd, iova);
+		print_mrlen(rd, mrlen);
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
@@ -854,6 +969,17 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
 
+static const
+struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "link", .is_number = false },
+	{ .name = "rkey", .is_number = true },
+	{ .name = "lkey", .is_number = true },
+	{ .name = "mrlen", .is_number = true },
+	{ .name = "pid", .is_number = true }
+};
+
+RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
+
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
@@ -861,6 +987,7 @@ static int res_show(struct rd *rd)
 		{ "qp",		res_qp		},
 		{ "cm_id",	res_cm_id	},
 		{ "cq",		res_cq		},
+		{ "mr",		res_mr		},
 		{ 0 }
 	};
 
diff --git a/rdma/utils.c b/rdma/utils.c
index 5e79b62..a2e08e9 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -385,6 +385,12 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_CQE] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_RES_USECNT] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_RES_POLL_CTX] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_MR] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_MR_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_RKEY] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_LKEY] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_IOVA] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_RES_MRLEN] = MNL_TYPE_U64,
 };
 
 int rd_attr_cb(const struct nlattr *attr, void *data)
-- 
1.8.3.1
