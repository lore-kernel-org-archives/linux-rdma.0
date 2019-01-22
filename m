From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 18/19] rdma: Perform single .doit call to query specific objects
Date: Tue, 22 Jan 2019 20:31:24 +0200
Message-ID: <20190122183125.15920-19-leon@kernel.org>
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

If user provides specific index, we can speedup query
by using .doit callback and save full dump and filtering
after that.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h     | 10 +++++-
 rdma/res-cmid.c | 33 +++++++++++++------
 rdma/res-cq.c   | 34 ++++++++++++++------
 rdma/res-mr.c   | 33 ++++++++++++++-----
 rdma/res-pd.c   | 32 ++++++++++++++-----
 rdma/res-qp.c   | 32 ++++++++++++++-----
 rdma/res.c      | 34 +++++++++++++++++++-
 rdma/res.h      | 84 ++++++++++++++++++++++++++++++++-----------------
 rdma/utils.c    | 20 ++++++++++++
 9 files changed, 239 insertions(+), 73 deletions(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index d2559e7c..e86c7f21 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -30,13 +30,20 @@
 #define MAX_NUMBER_OF_FILTERS 64
 struct filters {
 	const char *name;
-	bool is_number;
+	uint8_t is_number:1;
+	uint8_t is_doit:1;
 };
 
 struct filter_entry {
 	struct list_head list;
 	char *key;
 	char *value;
+	/*
+	 * This field menas that we can try to issue .doit calback
+	 * on value above. This value can be converted to integer
+	 * with simple atoi(). Otherwise "is_doit" will be false.
+	 */
+	uint8_t is_doit:1;
 };
 
 struct dev_map {
@@ -101,6 +108,7 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index);
 /*
  * Filter manipulation
  */
+bool rd_doit_index(struct rd *rd, uint32_t *idx);
 int rd_build_filter(struct rd *rd, const struct filters valid_filters[]);
 bool rd_check_is_filtered(struct rd *rd, const char *key, uint32_t val);
 bool rd_check_is_string_filtered(struct rd *rd, const char *key, const char *val);
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 22d99a8b..0b61e433 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -107,11 +107,9 @@ static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
 	}
 	return 0;
 }
-
 static int res_cm_id_line(struct rd *rd, const char *name, int idx,
-			  struct nlattr *nla_entry)
+		       struct nlattr **nla_line)
 {
-	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 	char src_addr_str[INET6_ADDRSTRLEN];
 	char dst_addr_str[INET6_ADDRSTRLEN];
 	uint16_t src_port, dst_port;
@@ -120,11 +118,6 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 	uint32_t lqpn = 0, ps;
 	uint32_t cm_idn = 0;
 	char *comm = NULL;
-	int err;
-
-	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-	if (err != MNL_CB_OK)
-		return MNL_CB_ERROR;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
@@ -225,6 +218,23 @@ out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 	return MNL_CB_OK;
 }
 
+int res_cm_id_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	int idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_cm_id_line(rd, name, idx, tb);
+}
+
 int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -244,8 +254,13 @@ int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_CM_ID];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		ret = res_cm_id_line(rd, name, idx, nla_entry);
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
 
+		ret = res_cm_id_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index cea4f6bd..c14637e6 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -31,9 +31,8 @@ static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx, struct nlattr *attr)
 }
 
 static int res_cq_line(struct rd *rd, const char *name, int idx,
-		       struct nlattr *nla_entry)
+		       struct nlattr **nla_line)
 {
-	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 	char *comm = NULL;
 	uint32_t pid = 0;
 	uint8_t poll_ctx = 0;
@@ -41,11 +40,6 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	uint32_t cqn = 0;
 	uint64_t users;
 	uint32_t cqe;
-	int err;
-
-	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-	if (err != MNL_CB_OK)
-		return MNL_CB_ERROR;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
@@ -80,7 +74,6 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		cqn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
 	if (rd_check_is_filtered(rd, "cqn", cqn))
 		goto out;
-
 	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
 		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
 	if (rd_check_is_filtered(rd, "ctxn", ctxn))
@@ -112,6 +105,23 @@ out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 	return MNL_CB_OK;
 }
 
+int res_cq_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_cq_line(rd, name, idx, tb);
+}
+
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -131,7 +141,13 @@ int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_CQ];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		ret = res_cq_line(rd, name, idx, nla_entry);
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = res_cq_line(rd, name, idx, nla_line);
 
 		if (ret != MNL_CB_OK)
 			break;
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 82e6d150..d42e8d81 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -8,20 +8,14 @@
 #include <inttypes.h>
 
 static int res_mr_line(struct rd *rd, const char *name, int idx,
-		       struct nlattr *nla_entry)
+		       struct nlattr **nla_line)
 {
-	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 	uint32_t rkey = 0, lkey = 0;
 	uint64_t iova = 0, mrlen;
 	char *comm = NULL;
 	uint32_t pdn = 0;
 	uint32_t mrn = 0;
 	uint32_t pid = 0;
-	int err;
-
-	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-	if (err != MNL_CB_OK)
-		return MNL_CB_ERROR;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_MRLEN] ||
 	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
@@ -84,6 +78,24 @@ out:
 		free(comm);
 	return MNL_CB_OK;
 }
+
+int res_mr_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_mr_line(rd, name, idx, tb);
+}
+
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -103,8 +115,13 @@ int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_MR];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		ret = res_mr_line(rd, name, idx, nla_entry);
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
 
+		ret = res_mr_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index e8c042dc..956d4d9f 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -8,20 +8,14 @@
 #include <inttypes.h>
 
 static int res_pd_line(struct rd *rd, const char *name, int idx,
-		       struct nlattr *nla_entry)
+		       struct nlattr **nla_line)
 {
 	uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
-	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 	char *comm = NULL;
 	uint32_t ctxn = 0;
 	uint32_t pid = 0;
 	uint32_t pdn = 0;
 	uint64_t users;
-	int err;
-
-	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-	if (err != MNL_CB_OK)
-		return MNL_CB_ERROR;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
 	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
@@ -88,6 +82,23 @@ out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 	return MNL_CB_OK;
 }
 
+int res_pd_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_pd_line(rd, name, idx, tb);
+}
+
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -107,8 +118,13 @@ int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_PD];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		ret = res_pd_line(rd, name, idx, nla_entry);
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
 
+		ret = res_pd_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 5d5ef27b..ac9976fc 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -79,19 +79,13 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 }
 
 static int res_qp_line(struct rd *rd, const char *name, int idx,
-		       struct nlattr *nla_entry)
+		       struct nlattr **nla_line)
 {
-	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 	uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
 	uint8_t type, state, path_mig_state = 0;
 	uint32_t port = 0, pid = 0;
 	uint32_t pdn = 0;
 	char *comm = NULL;
-	int err;
-
-	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-	if (err != MNL_CB_OK)
-		return MNL_CB_ERROR;
 
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
@@ -199,6 +193,23 @@ out:
 	return MNL_CB_OK;
 }
 
+int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_qp_line(rd, name, idx, tb);
+}
+
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -218,8 +229,13 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		ret = res_qp_line(rd, name, idx, nla_entry);
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
 
+		ret = res_qp_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res.c b/rdma/res.c
index 564af9b4..ef863f14 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -54,6 +54,11 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
 	return 0;
 }
 
+static int res_no_args_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return MNL_CB_OK;
+}
+
 static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -83,6 +88,33 @@ static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+int _res_send_idx_msg(struct rd *rd, uint32_t command, mnl_cb_t callback,
+		      uint32_t idx, uint32_t id)
+{
+	uint32_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	uint32_t seq;
+	int ret;
+
+	rd_prepare_msg(rd, command, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	if (rd->port_idx)
+		mnl_attr_put_u32(rd->nlh,
+				 RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+
+	mnl_attr_put_u32(rd->nlh, id, idx);
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
 int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 {
 	uint32_t flags = NLM_F_REQUEST | NLM_F_ACK;
@@ -214,7 +246,7 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 		pr_out("%s %" PRIu64 " ", name, val);
 }
 
-RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
+RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
 
 static int res_show(struct rd *rd)
 {
diff --git a/rdma/res.h b/rdma/res.h
index 575e1192..b4a7e552 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -9,31 +9,52 @@
 #include "rdma.h"
 
 int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback);
+int _res_send_idx_msg(struct rd *rd, uint32_t command, mnl_cb_t callback,
+		      uint32_t idx, uint32_t id);
+
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_pd_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_mr_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_cq_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_cm_id_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 
-#define RES_FUNC(name, command, valid_filters, strict_port) \
-	static inline int _##name(struct rd *rd)\
-	{ \
-		return _res_send_msg(rd, command, name##_parse_cb); \
-	} \
-	static inline int name(struct rd *rd) \
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
+#define RES_FUNC(name, command, valid_filters, strict_port, id)                        \
+	static inline int _##name(struct rd *rd)                                       \
+	{                                                                              \
+		uint32_t idx;                                                          \
+		int ret;                                                               \
+		if (id) {                                                              \
+			ret = rd_doit_index(rd, &idx);                                 \
+			if (ret) {                                                     \
+				ret = _res_send_idx_msg(rd, command,                   \
+							name##_idx_parse_cb,           \
+							idx, id);                      \
+				if (!ret)                                              \
+					return ret;                                    \
+				/* Fallback for old systems without .doit callbacks */ \
+			}                                                              \
+		}                                                                      \
+		return _res_send_msg(rd, command, name##_parse_cb);                    \
+	}                                                                              \
+	static inline int name(struct rd *rd)                                          \
+	{                                                                              \
+		int ret = rd_build_filter(rd, valid_filters);                          \
+		if (ret)                                                               \
+			return ret;                                                    \
+		if ((uintptr_t)valid_filters != (uintptr_t)NULL) {                     \
+			ret = rd_set_arg_to_devname(rd);                               \
+			if (ret)                                                       \
+				return ret;                                            \
+		}                                                                      \
+		if (strict_port)                                                       \
+			return rd_exec_dev(rd, _##name);                               \
+		else                                                                   \
+			return rd_exec_link(rd, _##name, strict_port);                 \
 	}
 
 static const
@@ -42,11 +63,12 @@ struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "users", .is_number = true },
 	{ .name = "pid", .is_number = true },
 	{ .name = "ctxn", .is_number = true },
-	{ .name = "pdn", .is_number = true },
+	{ .name = "pdn", .is_number = true, .is_doit = true },
 	{ .name = "ctxn", .is_number = true }
 };
 
-RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
+RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_PDN);
 
 static const
 struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
@@ -55,11 +77,12 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "lkey", .is_number = true },
 	{ .name = "mrlen", .is_number = true },
 	{ .name = "pid", .is_number = true },
-	{ .name = "mrn", .is_number = true },
+	{ .name = "mrn", .is_number = true, .is_doit = true },
 	{ .name = "pdn", .is_number = true }
 };
 
-RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
+RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_MRN);
 
 static const
 struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
@@ -67,11 +90,12 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "users", .is_number = true },
 	{ .name = "poll-ctx", .is_number = false },
 	{ .name = "pid", .is_number = true },
-	{ .name = "cqn", .is_number = true },
+	{ .name = "cqn", .is_number = true, .is_doit = true },
 	{ .name = "ctxn", .is_number = true }
 };
 
-RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
+RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_CQN);
 
 static const
 struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
@@ -87,15 +111,16 @@ struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "src-port", .is_number = true },
 	{ .name = "dst-addr", .is_number = false },
 	{ .name = "dst-port", .is_number = true },
-	{ .name = "cm-idn", .is_number = true }
+	{ .name = "cm-idn", .is_number = true, .is_doit = true }
 };
 
-RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
+RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false,
+	 RDMA_NLDEV_ATTR_RES_CM_IDN);
 
 static const struct
 filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "link", .is_number = false },
-	{ .name = "lqpn", .is_number = true },
+	{ .name = "lqpn", .is_number = true, .is_doit = true },
 	{ .name = "rqpn", .is_number = true },
 	{ .name = "pid",  .is_number = true },
 	{ .name = "sq-psn", .is_number = true },
@@ -106,7 +131,8 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "pdn", .is_number = true },
 };
 
-RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
+RES_FUNC(res_qp, RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false,
+	 RDMA_NLDEV_ATTR_RES_LQPN);
 
 char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
diff --git a/rdma/utils.c b/rdma/utils.c
index bce052d5..cff5297d 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -121,6 +121,7 @@ static int add_filter(struct rd *rd, char *key, char *value,
 	struct filter_entry *fe;
 	bool key_found = false;
 	int idx = 0;
+	char *endp;
 	int ret;
 
 	fe = calloc(1, sizeof(*fe));
@@ -163,6 +164,11 @@ static int add_filter(struct rd *rd, char *key, char *value,
 		goto err_alloc;
 	}
 
+	errno = 0;
+	strtol(fe->value, &endp, 10);
+	if (valid_filters[idx].is_doit && !errno && *endp == '\0')
+		fe->is_doit = true;
+
 	for (idx = 0; idx < strlen(fe->value); idx++)
 		fe->value[idx] = tolower(fe->value[idx]);
 
@@ -177,6 +183,20 @@ err:
 	return ret;
 }
 
+bool rd_doit_index(struct rd *rd, uint32_t *idx)
+{
+	struct filter_entry *fe;
+
+	list_for_each_entry(fe, &rd->filter_list, list) {
+		if (fe->is_doit) {
+			*idx = atoi(fe->value);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 int rd_build_filter(struct rd *rd, const struct filters valid_filters[])
 {
 	int ret = 0;
-- 
2.19.1
