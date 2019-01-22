From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 13/19] rdma: Refactor CQ prints
Date: Tue, 22 Jan 2019 20:31:19 +0200
Message-ID: <20190122183125.15920-14-leon@kernel.org>
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
 rdma/res-cq.c | 177 ++++++++++++++++++++++++++------------------------
 1 file changed, 91 insertions(+), 86 deletions(-)

diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 93c18251..e50d76ce 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -27,11 +27,97 @@ static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx)
 	pr_out("poll-ctx %s ", poll_ctx_to_str(poll_ctx));
 }
 
+static int res_cq_line(struct rd *rd, const char *name, int idx,
+		       struct nlattr *nla_entry)
+{
+	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+	char *comm = NULL;
+	uint32_t pid = 0;
+	uint8_t poll_ctx = 0;
+	uint32_t ctxn = 0;
+	uint32_t cqn = 0;
+	uint64_t users;
+	uint32_t cqe;
+	int err;
+
+	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_CQE] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_USECNT] ||
+	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+		return MNL_CB_ERROR;
+	}
+
+	cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
+
+	users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+	if (rd_check_is_filtered(rd, "users", users))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]) {
+		poll_ctx =
+			mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
+		if (rd_check_is_string_filtered(rd, "poll-ctx",
+						poll_ctx_to_str(poll_ctx)))
+			goto out;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+
+	if (rd_check_is_filtered(rd, "pid", pid))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+		cqn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	if (rd_check_is_filtered(rd, "cqn", cqn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	if (rd_check_is_filtered(rd, "ctxn", ctxn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	if (rd->json_output)
+		jsonw_start_array(rd->jw);
+
+	print_dev(rd, idx, name);
+	res_print_uint(rd, "cqe", cqe);
+	res_print_uint(rd, "users", users);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
+		print_poll_ctx(rd, poll_ctx);
+	res_print_uint(rd, "pid", pid);
+	print_comm(rd, comm, nla_line);
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+		res_print_uint(rd, "cqn", cqn);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		res_print_uint(rd, "ctxn", ctxn);
+
+	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	newline(rd);
+
+out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return MNL_CB_OK;
+}
+
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
 	struct nlattr *nla_table, *nla_entry;
 	struct rd *rd = data;
+	int ret = MNL_CB_OK;
 	const char *name;
 	uint32_t idx;
 
@@ -45,91 +131,10 @@ int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_CQ];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
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
-				nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
-			if (rd_check_is_string_filtered(
-				    rd, "poll-ctx", poll_ctx_to_str(poll_ctx)))
-				continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-			pid = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
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
-				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
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
-		res_print_uint(rd, "cqe", cqe);
-		res_print_uint(rd, "users", users);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
-			print_poll_ctx(rd, poll_ctx);
-		res_print_uint(rd, "pid", pid);
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
+		ret = res_cq_line(rd, name, idx, nla_entry);
+
+		if (ret != MNL_CB_OK)
+			break;
 	}
-	return MNL_CB_OK;
+	return ret;
 }
-
-- 
2.19.1
