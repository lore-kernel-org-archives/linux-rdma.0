From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 04/19] rdma: Provide parent context index for all objects except CM_ID
Date: Wed, 20 Feb 2019 09:21:21 +0200
Message-ID: <20190220072136.3840-5-leon@kernel.org>
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

Allow users to correlate allocated object with relevant parent

[leonro@server ~]$ rdma res show pd
dev mlx5_0 users 5 pid 0 comm [ib_core] pdn 1
dev mlx5_0 users 7 pid 0 comm [ib_ipoib] pdn 2
dev mlx5_0 users 0 pid 0 comm [mlx5_ib] pdn 3
dev mlx5_0 users 2 pid 548 comm ibv_rc_pingpong ctxn 0 pdn 4

[leonro@server ~]$ rdma res show cq cqn 0-100
dev mlx5_0 cqe 2047 users 6 poll-ctx UNBOUND_WORKQUEUE pid 0 comm [ib_core] cqn 2
dev mlx5_0 cqe 255 users 2 poll-ctx SOFTIRQ pid 0 comm [mlx5_ib] cqn 3
dev mlx5_0 cqe 511 users 1 poll-ctx DIRECT pid 0 comm [ib_ipoib] cqn 4
dev mlx5_0 cqe 255 users 1 poll-ctx DIRECT pid 0 comm [ib_ipoib] cqn 5
dev mlx5_0 cqe 255 users 0 poll-ctx SOFTIRQ pid 0 comm [mlx5_ib] cqn 6
dev mlx5_0 cqe 511 users 2 pid 548 comm ibv_rc_pingpong cqn 7 ctxn 0

[leonro@server ~]$ rdma res show mr
dev mlx5_0 mrlen 4096 pid 548 comm ibv_rc_pingpong mrn 4 pdn 0

[leonro@nps-server-14-015 ~]$ /images/leonro/src/iproute2/rdma/rdma res show qp
link mlx5_0/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
link mlx5_0/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
link mlx5_0/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
link mlx5_0/1 lqpn 8 type UD state RTS sq-psn 0 pid 0 comm [ib_ipoib]
link mlx5_0/1 lqpn 9 pdn 4 rqpn 0 type RC state INIT rq-psn 0 sq-psn 0 path-mig-state MIGRATED pid 548 comm ibv_rc_pingpong

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 110 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 38 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index f941de5c..308f66c0 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -320,6 +320,22 @@ static char *get_task_name(uint32_t pid)
 	return comm;
 }
 
+static void print_key(struct rd *rd, const char *name, uint64_t val)
+{
+	if (rd->json_output)
+		jsonw_xint_field(rd->jw, name, val);
+	else
+		pr_out("%s 0x%" PRIx64 " ", name, val);
+}
+
+static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
+{
+	if (rd->json_output)
+		jsonw_uint_field(rd->jw, name, val);
+	else
+		pr_out("%s %" PRIu64 " ", name, val);
+}
+
 static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -343,6 +359,7 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
 		uint8_t type, state, path_mig_state = 0;
 		uint32_t port = 0, pid = 0;
+		uint32_t pdn = 0;
 		char *comm = NULL;
 		int err;
 
@@ -369,6 +386,11 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (rd_check_is_filtered(rd, "lqpn", lqpn))
 			continue;
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+		if (rd_check_is_filtered(rd, "pdn", pdn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
 			rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
 			if (rd_check_is_filtered(rd, "rqpn", rqpn))
@@ -428,6 +450,8 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_link(rd, idx, name, port, nla_line);
 
 		print_lqpn(rd, lqpn);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			res_print_uint(rd, "pdn", pdn);
 		print_rqpn(rd, rqpn, nla_line);
 
 		print_type(rd, type);
@@ -549,22 +573,6 @@ static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
 	return 0;
 }
 
-static void print_key(struct rd *rd, const char *name, uint64_t val)
-{
-	if (rd->json_output)
-		jsonw_xint_field(rd->jw, name, val);
-	else
-		pr_out("%s 0x%" PRIx64 " ", name, val);
-}
-
-static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, name, val);
-	else
-		pr_out("%s %" PRIu64 " ", name, val);
-}
-
 static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -768,6 +776,7 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		char *comm = NULL;
 		uint32_t pid = 0;
 		uint8_t poll_ctx = 0;
+		uint32_t ctxn = 0;
 		uint32_t cqn = 0;
 		uint64_t users;
 		uint32_t cqe;
@@ -815,6 +824,12 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (rd_check_is_filtered(rd, "cqn", cqn))
 			continue;
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			ctxn = mnl_attr_get_u32(
+				 nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+		if (rd_check_is_filtered(rd, "ctxn", ctxn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
 			/* discard const from mnl_attr_get_str */
 			comm = (char *)mnl_attr_get_str(
@@ -833,6 +848,8 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
 			res_print_uint(rd, "cqn", cqn);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			res_print_uint(rd, "ctxn", ctxn);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
@@ -866,6 +883,7 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		uint32_t rkey = 0, lkey = 0;
 		uint64_t iova = 0, mrlen;
 		char *comm = NULL;
+		uint32_t pdn = 0;
 		uint32_t mrn = 0;
 		uint32_t pid = 0;
 		int err;
@@ -911,6 +929,12 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (rd_check_is_filtered(rd, "mrn", mrn))
 			continue;
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			pdn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+		if (rd_check_is_filtered(rd, "pdn", pdn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
 			/* discard const from mnl_attr_get_str */
 			comm = (char *)mnl_attr_get_str(
@@ -933,6 +957,9 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
 			res_print_uint(rd, "mrn", mrn);
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			res_print_uint(rd, "pdn", pdn);
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
@@ -964,6 +991,7 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
 		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 		char *comm = NULL;
+		uint32_t ctxn = 0;
 		uint32_t pid = 0;
 		uint32_t pdn = 0;
 		uint64_t users;
@@ -997,7 +1025,13 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 			comm = get_task_name(pid);
 		}
 
-		if (rd_check_is_filtered(rd, "pid", pid))
+                if (rd_check_is_filtered(rd, "pid", pid))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+
+		if (rd_check_is_filtered(rd, "ctxn", ctxn))
 			continue;
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
@@ -1022,6 +1056,8 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+			res_print_uint(rd, "ctxn", ctxn);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 			res_print_uint(rd, "pdn", pdn);
@@ -1038,24 +1074,18 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
 static const struct
-filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {{ .name = "link",
-						   .is_number = false },
-						   { .name = "lqpn",
-						   .is_number = true },
-						   { .name = "rqpn",
-						   .is_number = true },
-						   { .name = "pid",
-						   .is_number = true },
-						   { .name = "sq-psn",
-						   .is_number = true },
-						   { .name = "rq-psn",
-						   .is_number = true },
-						   { .name = "type",
-						   .is_number = false },
-						   { .name = "path-mig-state",
-						   .is_number = false },
-						   { .name = "state",
-						   .is_number = false } };
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
 
 RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
 
@@ -1084,7 +1114,8 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "users", .is_number = true },
 	{ .name = "poll-ctx", .is_number = false },
 	{ .name = "pid", .is_number = true },
-	{ .name = "cqn", .is_number = true }
+	{ .name = "cqn", .is_number = true },
+	{ .name = "ctxn", .is_number = true }
 };
 
 RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
@@ -1096,7 +1127,8 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "lkey", .is_number = true },
 	{ .name = "mrlen", .is_number = true },
 	{ .name = "pid", .is_number = true },
-	{ .name = "mrn", .is_number = true }
+	{ .name = "mrn", .is_number = true },
+	{ .name = "pdn", .is_number = true }
 };
 
 RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
@@ -1106,7 +1138,9 @@ struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "dev", .is_number = false },
 	{ .name = "users", .is_number = true },
 	{ .name = "pid", .is_number = true },
-	{ .name = "pdn", .is_number = true }
+	{ .name = "ctxn", .is_number = true },
+	{ .name = "pdn", .is_number = true },
+	{ .name = "ctxn", .is_number = true }
 };
 
 RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
-- 
2.19.1
