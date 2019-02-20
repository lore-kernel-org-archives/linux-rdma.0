From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 12/19] rdma: Simplify CM_ID print code
Date: Wed, 20 Feb 2019 09:21:29 +0200
Message-ID: <20190220072136.3840-13-leon@kernel.org>
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

Refactor our the CM_ID print code.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cmid.c | 246 ++++++++++++++++++++++++------------------------
 1 file changed, 124 insertions(+), 122 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 5eea7a6b..12d1acee 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -108,11 +108,130 @@ static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
 	return 0;
 }
 
+static int res_cm_id_line(struct rd *rd, const char *name, int idx,
+			  struct nlattr *nla_entry)
+{
+	struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+	char src_addr_str[INET6_ADDRSTRLEN];
+	char dst_addr_str[INET6_ADDRSTRLEN];
+	uint16_t src_port, dst_port;
+	uint32_t port = 0, pid = 0;
+	uint8_t type = 0, state;
+	uint32_t lqpn = 0, ps;
+	uint32_t cm_idn = 0;
+	char *comm = NULL;
+	int err;
+
+	err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
+	    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
+	    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+	     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+		return MNL_CB_ERROR;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	if (port && port != rd->port_idx)
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd_check_is_filtered(rd, "lqpn", lqpn))
+			goto out;
+	}
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
+		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+		if (rd_check_is_string_filtered(rd, "qp-type",
+						qp_types_to_str(type)))
+			goto out;
+	}
+
+	ps = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PS]);
+	if (rd_check_is_string_filtered(rd, "ps", cm_id_ps_to_str(ps)))
+		goto out;
+
+	state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
+	if (rd_check_is_string_filtered(rd, "state", cm_id_state_to_str(state)))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]) {
+		if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR],
+			    src_addr_str, &src_port))
+			goto out;
+		if (rd_check_is_string_filtered(rd, "src-addr", src_addr_str))
+			goto out;
+		if (rd_check_is_filtered(rd, "src-port", src_port))
+			goto out;
+	}
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]) {
+		if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR],
+			    dst_addr_str, &dst_port))
+			goto out;
+		if (rd_check_is_string_filtered(rd, "dst-addr", dst_addr_str))
+			goto out;
+		if (rd_check_is_filtered(rd, "dst-port", dst_port))
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
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+		cm_idn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
+	if (rd_check_is_filtered(rd, "cm-idn", cm_idn))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+	}
+
+	if (rd->json_output)
+		jsonw_start_array(rd->jw);
+
+	print_link(rd, idx, name, port, nla_line);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
+		res_print_uint(rd, "lqpn", lqpn);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
+		print_qp_type(rd, type);
+	print_cm_id_state(rd, state);
+	print_ps(rd, ps);
+	res_print_uint(rd, "pid", pid);
+	print_comm(rd, comm, nla_line);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+		res_print_uint(rd, "cm-idn", cm_idn);
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
+		print_ipaddr(rd, "src-addr", src_addr_str, src_port);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR])
+		print_ipaddr(rd, "dst-addr", dst_addr_str, dst_port);
+
+	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	newline(rd);
+
+out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return MNL_CB_OK;
+}
+
 int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
 	struct nlattr *nla_table, *nla_entry;
 	struct rd *rd = data;
+	int ret = MNL_CB_OK;
 	const char *name;
 	int idx;
 
@@ -124,129 +243,12 @@ int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	nla_table = tb[RDMA_NLDEV_ATTR_RES_CM_ID];
+
 	mnl_attr_for_each_nested(nla_entry, nla_table) {
-		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
-		char src_addr_str[INET6_ADDRSTRLEN];
-		char dst_addr_str[INET6_ADDRSTRLEN];
-		uint16_t src_port, dst_port;
-		uint32_t port = 0, pid = 0;
-		uint8_t type = 0, state;
-		uint32_t lqpn = 0, ps;
-		uint32_t cm_idn = 0;
-		char *comm = NULL;
-		int err;
-
-		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
-		if (err != MNL_CB_OK)
-			return -EINVAL;
+		ret = res_cm_id_line(rd, name, idx, nla_entry);
 
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-			port = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
-
-		if (port && port != rd->port_idx)
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
-			lqpn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-			if (rd_check_is_filtered(rd, "lqpn", lqpn))
-				continue;
-		}
-		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
-			type = mnl_attr_get_u8(
-				nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
-			if (rd_check_is_string_filtered(rd, "qp-type",
-							qp_types_to_str(type)))
-				continue;
-		}
-
-		ps = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PS]);
-		if (rd_check_is_string_filtered(rd, "ps", cm_id_ps_to_str(ps)))
-			continue;
-
-		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
-		if (rd_check_is_string_filtered(rd, "state",
-						cm_id_state_to_str(state)))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]) {
-			if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR],
-				    src_addr_str, &src_port))
-				continue;
-			if (rd_check_is_string_filtered(rd, "src-addr",
-							src_addr_str))
-				continue;
-			if (rd_check_is_filtered(rd, "src-port", src_port))
-				continue;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]) {
-			if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR],
-				    dst_addr_str, &dst_port))
-				continue;
-			if (rd_check_is_string_filtered(rd, "dst-addr",
-							dst_addr_str))
-				continue;
-			if (rd_check_is_filtered(rd, "dst-port", dst_port))
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
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
-			cm_idn = mnl_attr_get_u32(
-				nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
-		if (rd_check_is_filtered(rd, "cm-idn", cm_idn))
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
-			/* discard const from mnl_attr_get_str */
-			comm = (char *)mnl_attr_get_str(
-				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-		}
-
-		if (rd->json_output)
-			jsonw_start_array(rd->jw);
-
-		print_link(rd, idx, name, port, nla_line);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
-			res_print_uint(rd, "lqpn", lqpn);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
-			print_qp_type(rd, type);
-		print_cm_id_state(rd, state);
-		print_ps(rd, ps);
-		res_print_uint(rd, "pid", pid);
-		print_comm(rd, comm, nla_line);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
-			res_print_uint(rd, "cm-idn", cm_idn);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
-			print_ipaddr(rd, "src-addr", src_addr_str, src_port);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR])
-			print_ipaddr(rd, "dst-addr", dst_addr_str, dst_port);
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-			free(comm);
-
-		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
-		newline(rd);
+		if (ret != MNL_CB_OK)
+			break;
 	}
-	return MNL_CB_OK;
+	return ret;
 }
-- 
2.19.1
