From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 11/19] rdma: Simplify code to reuse existing functions
Date: Wed, 20 Feb 2019 09:21:28 +0200
Message-ID: <20190220072136.3840-12-leon@kernel.org>
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

Remove duplicated functions in favour general res_print_uint() call.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cmid.c |  4 ++--
 rdma/res-cq.c   | 14 +++-----------
 rdma/res-mr.c   |  2 +-
 rdma/res-pd.c   |  4 ++--
 rdma/res-qp.c   | 14 +++-----------
 rdma/res.c      | 34 ++--------------------------------
 rdma/res.h      |  3 ---
 7 files changed, 13 insertions(+), 62 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index b63634a3..5eea7a6b 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -227,12 +227,12 @@ int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 		print_link(rd, idx, name, port, nla_line);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
-			print_lqpn(rd, lqpn);
+			res_print_uint(rd, "lqpn", lqpn);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 			print_qp_type(rd, type);
 		print_cm_id_state(rd, state);
 		print_ps(rd, ps);
-		print_pid(rd, pid);
+		res_print_uint(rd, "pid", pid);
 		print_comm(rd, comm, nla_line);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
 			res_print_uint(rd, "cm-idn", cm_idn);
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index fbfe593b..93c18251 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -7,14 +7,6 @@
 #include "res.h"
 #include <inttypes.h>
 
-static void print_cqe(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "cqe", val);
-	else
-		pr_out("cqe %u ", val);
-}
-
 static const char *poll_ctx_to_str(uint8_t idx)
 {
 	static const char * const cm_id_states_str[] = {
@@ -120,11 +112,11 @@ int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 			jsonw_start_array(rd->jw);
 
 		print_dev(rd, idx, name);
-		print_cqe(rd, cqe);
-		print_users(rd, users);
+		res_print_uint(rd, "cqe", cqe);
+		res_print_uint(rd, "users", users);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
 			print_poll_ctx(rd, poll_ctx);
-		print_pid(rd, pid);
+		res_print_uint(rd, "pid", pid);
 		print_comm(rd, comm, nla_line);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index dae5def2..e373035a 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -97,7 +97,7 @@ int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
 			print_key(rd, "iova", iova);
 		res_print_uint(rd, "mrlen", mrlen);
-		print_pid(rd, pid);
+		res_print_uint(rd, "pid", pid);
 		print_comm(rd, comm, nla_line);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index d879a21a..24ac7f1b 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -89,10 +89,10 @@ int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_dev(rd, idx, name);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
 			print_key(rd, "local_dma_lkey", local_dma_lkey);
-		print_users(rd, users);
+		res_print_uint(rd, "users", users);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
 			print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
-		print_pid(rd, pid);
+		res_print_uint(rd, "pid", pid);
 		print_comm(rd, comm, nla_line);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
 			res_print_uint(rd, "ctxn", ctxn);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 85725fea..ecd2cbd6 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -66,14 +66,6 @@ static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 		pr_out("rq-psn %u ", val);
 }
 
-static void print_sqpsn(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "sq-psn", val);
-	else
-		pr_out("sq-psn %u ", val);
-}
-
 static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 {
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
@@ -209,7 +201,7 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 		print_link(rd, idx, name, port, nla_line);
 
-		print_lqpn(rd, lqpn);
+		res_print_uint(rd, "lqpn", lqpn);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 			res_print_uint(rd, "pdn", pdn);
 		print_rqpn(rd, rqpn, nla_line);
@@ -218,10 +210,10 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_state(rd, state);
 
 		print_rqpsn(rd, rq_psn, nla_line);
-		print_sqpsn(rd, sq_psn);
+		res_print_uint(rd, "sq-psn", sq_psn);
 
 		print_pathmig(rd, path_mig_state, nla_line);
-		print_pid(rd, pid);
+		res_print_uint(rd, "pid", pid);
 		print_comm(rd, comm, nla_line);
 
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
diff --git a/rdma/res.c b/rdma/res.c
index f621afa8..140c0908 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -35,7 +35,6 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
 		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		char json_name[32];
 
 		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
 		if (err != MNL_CB_OK)
@@ -48,12 +47,7 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
 
 		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
 		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
-		if (rd->json_output) {
-			snprintf(json_name, 32, "%s", name);
-			jsonw_lluint_field(rd->jw, json_name, curr);
-		} else {
-			pr_out("%s %"PRId64 " ", name, curr);
-		}
+		res_print_uint(rd, name, curr);
 	}
 	return 0;
 }
@@ -127,22 +121,6 @@ const char *qp_types_to_str(uint8_t idx)
 	return "UNKNOWN";
 }
 
-void print_lqpn(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "lqpn", val);
-	else
-		pr_out("lqpn %u ", val);
-}
-
-void print_pid(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "pid", val);
-	else
-		pr_out("pid %u ", val);
-}
-
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 {
 	char tmp[18];
@@ -221,19 +199,11 @@ void print_key(struct rd *rd, const char *name, uint64_t val)
 void res_print_uint(struct rd *rd, const char *name, uint64_t val)
 {
 	if (rd->json_output)
-		jsonw_uint_field(rd->jw, name, val);
+		jsonw_u64_field(rd->jw, name, val);
 	else
 		pr_out("%s %" PRIu64 " ", name, val);
 }
 
-void print_users(struct rd *rd, uint64_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "users", val);
-	else
-		pr_out("users %" PRIu64 " ", val);
-}
-
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true);
 
 static int res_show(struct rd *rd)
diff --git a/rdma/res.h b/rdma/res.h
index 95d88a3a..89dd818a 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -112,12 +112,9 @@ char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
-void print_users(struct rd *rd, uint64_t val);
 void print_key(struct rd *rd, const char *name, uint64_t val);
 void res_print_uint(struct rd *rd, const char *name, uint64_t val);
-void print_pid(struct rd *rd, uint32_t val);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
 const char *qp_types_to_str(uint8_t idx);
-void print_lqpn(struct rd *rd, uint32_t val);
 
 #endif /* _RDMA_TOOL_RES_H_ */
-- 
2.19.1
