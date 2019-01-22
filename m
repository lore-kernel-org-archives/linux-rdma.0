From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 03/19] rdma: Provide unique indexes for all visible objects
Date: Tue, 22 Jan 2019 20:31:09 +0200
Message-ID: <20190122183125.15920-4-leon@kernel.org>
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

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 83 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index 87865ec8..f941de5c 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -549,6 +549,22 @@ static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
 	return 0;
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
 static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -574,6 +590,7 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 		uint32_t port = 0, pid = 0;
 		uint8_t type = 0, state;
 		uint32_t lqpn = 0, ps;
+		uint32_t cm_idn = 0;
 		char *comm = NULL;
 		int err;
 
@@ -651,6 +668,12 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 			continue;
 		}
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+			cm_idn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
+		if (rd_check_is_filtered(rd, "cm-idn", cm_idn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
 			/* discard const from mnl_attr_get_str */
 			comm = (char *)mnl_attr_get_str(
@@ -669,6 +692,8 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_ps(rd, ps);
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+			res_print_uint(rd, "cm-idn", cm_idn);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
 			print_ipaddr(rd, "src-addr", src_addr_str, src_port);
@@ -743,6 +768,7 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		char *comm = NULL;
 		uint32_t pid = 0;
 		uint8_t poll_ctx = 0;
+		uint32_t cqn = 0;
 		uint64_t users;
 		uint32_t cqe;
 		int err;
@@ -783,6 +809,12 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 			continue;
 		}
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+			cqn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+		if (rd_check_is_filtered(rd, "cqn", cqn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
 			/* discard const from mnl_attr_get_str */
 			comm = (char *)mnl_attr_get_str(
@@ -799,6 +831,9 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+			res_print_uint(rd, "cqn", cqn);
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
@@ -808,22 +843,6 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
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
 static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
@@ -847,6 +866,7 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		uint32_t rkey = 0, lkey = 0;
 		uint64_t iova = 0, mrlen;
 		char *comm = NULL;
+		uint32_t mrn = 0;
 		uint32_t pid = 0;
 		int err;
 
@@ -885,6 +905,12 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 			continue;
 		}
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
+			mrn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+		if (rd_check_is_filtered(rd, "mrn", mrn))
+			continue;
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
 			/* discard const from mnl_attr_get_str */
 			comm = (char *)mnl_attr_get_str(
@@ -904,6 +930,9 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
+			res_print_uint(rd, "mrn", mrn);
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
@@ -936,6 +965,7 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
 		char *comm = NULL;
 		uint32_t pid = 0;
+		uint32_t pdn = 0;
 		uint64_t users;
 		int err;
 
@@ -970,6 +1000,12 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (rd_check_is_filtered(rd, "pid", pid))
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
@@ -987,6 +1023,9 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
 
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+			res_print_uint(rd, "pdn", pdn);
+
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
@@ -1033,7 +1072,8 @@ struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "src-addr", .is_number = false },
 	{ .name = "src-port", .is_number = true },
 	{ .name = "dst-addr", .is_number = false },
-	{ .name = "dst-port", .is_number = true }
+	{ .name = "dst-port", .is_number = true },
+	{ .name = "cm-idn", .is_number = true }
 };
 
 RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
@@ -1043,7 +1083,8 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "dev", .is_number = false },
 	{ .name = "users", .is_number = true },
 	{ .name = "poll-ctx", .is_number = false },
-	{ .name = "pid", .is_number = true }
+	{ .name = "pid", .is_number = true },
+	{ .name = "cqn", .is_number = true }
 };
 
 RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
@@ -1054,7 +1095,8 @@ struct filters mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "rkey", .is_number = true },
 	{ .name = "lkey", .is_number = true },
 	{ .name = "mrlen", .is_number = true },
-	{ .name = "pid", .is_number = true }
+	{ .name = "pid", .is_number = true },
+	{ .name = "mrn", .is_number = true }
 };
 
 RES_FUNC(res_mr, RDMA_NLDEV_CMD_RES_MR_GET, mr_valid_filters, true);
@@ -1063,7 +1105,8 @@ static const
 struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "dev", .is_number = false },
 	{ .name = "users", .is_number = true },
-	{ .name = "pid", .is_number = true }
+	{ .name = "pid", .is_number = true },
+	{ .name = "pdn", .is_number = true }
 };
 
 RES_FUNC(res_pd, RDMA_NLDEV_CMD_RES_PD_GET, pd_valid_filters, true);
-- 
2.19.1
