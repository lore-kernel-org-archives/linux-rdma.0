From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 16/19] rdma: Move QP code to separate function
Date: Sat, 23 Feb 2019 11:15:25 +0200
Message-ID: <20190223091528.8509-17-leon@kernel.org>
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

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-qp.c | 253 +++++++++++++++++++++++++-------------------------
 1 file changed, 127 insertions(+), 126 deletions(-)

diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index ecd2cbd6..e74c8b01 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -78,11 +78,133 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 		pr_out("path-mig-state %s ", path_mig_to_str(val));
 }
 
+static int res_qp_line(struct rd *rd, const char *name, int idx,
+		       struct nlattr *nla_entry)
+{
+	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+	uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
+	uint8_t type, state, path_mig_state = 0;
+	uint32_t port = 0, pid = 0;
+	uint32_t pdn = 0;
+	char *comm = NULL;
+	int err;
+
+	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
+	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+		return MNL_CB_ERROR;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	if (port != rd->port_idx)
+		goto out;
+
+	lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+	if (rd_check_is_filtered(rd, "lqpn", lqpn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	if (rd_check_is_filtered(rd, "pdn", pdn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
+		rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
+		if (rd_check_is_filtered(rd, "rqpn", rqpn))
+			goto out;
+	} else {
+		if (rd_check_is_key_exist(rd, "rqpn"))
+			goto out;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
+		rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
+		if (rd_check_is_filtered(rd, "rq-psn", rq_psn))
+			goto out;
+	} else {
+		if (rd_check_is_key_exist(rd, "rq-psn"))
+			goto out;
+	}
+
+	sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
+	if (rd_check_is_filtered(rd, "sq-psn", sq_psn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]) {
+		path_mig_state = mnl_attr_get_u8(
+			nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
+		if (rd_check_is_string_filtered(rd, "path-mig-state",
+						path_mig_to_str(path_mig_state)))
+			goto out;
+	} else {
+		if (rd_check_is_key_exist(rd, "path-mig-state"))
+			goto out;
+	}
+
+	type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+	if (rd_check_is_string_filtered(rd, "type", qp_types_to_str(type)))
+		goto out;
+
+	state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
+	if (rd_check_is_string_filtered(rd, "state", qp_states_to_str(state)))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+
+	if (rd_check_is_filtered(rd, "pid", pid))
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
+	print_link(rd, idx, name, port, nla_line);
+
+	res_print_uint(rd, "lqpn", lqpn);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+		res_print_uint(rd, "pdn", pdn);
+	print_rqpn(rd, rqpn, nla_line);
+
+	print_type(rd, type);
+	print_state(rd, state);
+
+	print_rqpsn(rd, rq_psn, nla_line);
+	res_print_uint(rd, "sq-psn", sq_psn);
+
+	print_pathmig(rd, path_mig_state, nla_line);
+	res_print_uint(rd, "pid", pid);
+	print_comm(rd, comm, nla_line);
+
+	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	newline(rd);
+out:
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return MNL_CB_OK;
+}
+
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
 	struct nlattr *nla_table, *nla_entry;
 	struct rd *rd = data;
+	int ret = MNL_CB_OK;
 	const char *name;
 	uint32_t idx;
 
@@ -96,131 +218,10 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
 
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
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
-			port = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
-
-		if (port != rd->port_idx)
-			continue;
-
-		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (rd_check_is_filtered(rd, "lqpn", lqpn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			pdn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-		if (rd_check_is_filtered(rd, "pdn", pdn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
-			rqpn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
-			if (rd_check_is_filtered(rd, "rqpn", rqpn))
-				continue;
-		} else {
-			if (rd_check_is_key_exist(rd, "rqpn"))
-				continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
-			rq_psn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
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
-			path_mig_state = mnl_attr_get_u8(
-				nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
-			if (rd_check_is_string_filtered(
-				    rd, "path-mig-state",
-				    path_mig_to_str(path_mig_state)))
-				continue;
-		} else {
-			if (rd_check_is_key_exist(rd, "path-mig-state"))
-				continue;
-		}
-
-		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
-		if (rd_check_is_string_filtered(rd, "type",
-						qp_types_to_str(type)))
-			continue;
-
-		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
-		if (rd_check_is_string_filtered(rd, "state",
-						qp_states_to_str(state)))
-			continue;
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
-		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-			/* discard const from mnl_attr_get_str */
-			comm = (char *)mnl_attr_get_str(
-				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
-		if (rd->json_output)
-			jsonw_start_array(rd->jw);
-
-		print_link(rd, idx, name, port, nla_line);
-
-		res_print_uint(rd, "lqpn", lqpn);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-			res_print_uint(rd, "pdn", pdn);
-		print_rqpn(rd, rqpn, nla_line);
-
-		print_type(rd, type);
-		print_state(rd, state);
-
-		print_rqpsn(rd, rq_psn, nla_line);
-		res_print_uint(rd, "sq-psn", sq_psn);
-
-		print_pathmig(rd, path_mig_state, nla_line);
-		res_print_uint(rd, "pid", pid);
-		print_comm(rd, comm, nla_line);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-			free(comm);
-
-		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
-		newline(rd);
+		ret = res_qp_line(rd, name, idx, nla_entry);
+
+		if (ret != MNL_CB_OK)
+			break;
 	}
-	return MNL_CB_OK;
+	return ret;
 }
-- 
2.19.1
