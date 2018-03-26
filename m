From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 5/8] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 13:57:37 -0700
Message-ID: <5a2d6eb9b5767e1691d12f1fe206d7a24c9d7ef0.1522097991.git.swise@opengridcomputing.com>
References: <cover.1522097991.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522097991.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Sample output:

# rdma resource
2: cxgb4_0: pd 5 cq 2 qp 2 cm_id 3 mr 7
3: mlx4_0: pd 7 cq 3 qp 3 cm_id 3 mr 7

# rdma resource show cm_id
link cxgb4_0/- lqpn 0 qp-type RC state LISTEN ps TCP pid 30485 comm rping src-addr 0.0.0.0:7174
link cxgb4_0/2 lqpn 1048 qp-type RC state CONNECT ps TCP pid 30503 comm rping src-addr 172.16.2.1:7174 dst-addr 172.16.2.1:38246
link cxgb4_0/2 lqpn 1040 qp-type RC state CONNECT ps TCP pid 30498 comm rping src-addr 172.16.2.1:38246 dst-addr 172.16.2.1:7174
link mlx4_0/- lqpn 0 qp-type RC state LISTEN ps TCP pid 30485 comm rping src-addr 0.0.0.0:7174
link mlx4_0/1 lqpn 539 qp-type RC state CONNECT ps TCP pid 30494 comm rping src-addr 172.16.99.1:7174 dst-addr 172.16.99.1:43670
link mlx4_0/1 lqpn 538 qp-type RC state CONNECT ps TCP pid 30492 comm rping src-addr 172.16.99.1:43670 dst-addr 172.16.99.1:7174

# rdma resource show cm_id dst-port 7174
link cxgb4_0/2 lqpn 1040 qp-type RC state CONNECT ps TCP pid 30498 comm rping src-addr 172.16.2.1:38246 dst-addr 172.16.2.1:7174
link mlx4_0/1 lqpn 538 qp-type RC state CONNECT ps TCP pid 30492 comm rping src-addr 172.16.99.1:43670 dst-addr 172.16.99.1:7174

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h  |   2 +
 rdma/res.c   | 262 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 rdma/utils.c |   5 ++
 3 files changed, 268 insertions(+), 1 deletion(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index 5809f70..e55205b 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -18,10 +18,12 @@
 #include <libmnl/libmnl.h>
 #include <rdma/rdma_netlink.h>
 #include <time.h>
+#include <net/if_arp.h>
 
 #include "list.h"
 #include "utils.h"
 #include "json_writer.h"
+#include <rdma/rdma_cma.h>
 
 #define pr_err(args...) fprintf(stderr, ##args)
 #define pr_out(args...) fprintf(stdout, ##args)
diff --git a/rdma/res.c b/rdma/res.c
index 62f5c54..5506cf3 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -16,9 +16,11 @@ static int res_help(struct rd *rd)
 {
 	pr_out("Usage: %s resource\n", rd->filename);
 	pr_out("          resource show [DEV]\n");
-	pr_out("          resource show [qp]\n");
+	pr_out("          resource show [qp|cm_id]\n");
 	pr_out("          resource show qp link [DEV/PORT]\n");
 	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show cm_id link [DEV/PORT]\n");
+	pr_out("          resource show cm_id link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
 
@@ -433,6 +435,245 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static void print_qp_type(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_string_field(rd->jw, "qp-type",
+				   qp_types_to_str(val));
+	else
+		pr_out("qp-type %s ", qp_types_to_str(val));
+}
+
+static const char *cm_id_state_to_str(uint8_t idx)
+{
+	static const char * const cm_id_states_str[] = {
+		"IDLE", "ADDR_QUERY", "ADDR_RESOLVED", "ROUTE_QUERY",
+		"ROUTE_RESOLVED", "CONNECT", "DISCONNECT", "ADDR_BOUND",
+		"LISTEN", "DEVICE_REMOVAL", "DESTROYING" };
+
+	if (idx < ARRAY_SIZE(cm_id_states_str))
+		return cm_id_states_str[idx];
+	return "UNKNOWN";
+}
+
+static const char *cm_id_ps_to_str(uint32_t ps)
+{
+	switch (ps) {
+	case RDMA_PS_IPOIB:
+		return "IPoIB";
+	case RDMA_PS_IB:
+		return "IPoIB";
+	case RDMA_PS_TCP:
+		return "TCP";
+	case RDMA_PS_UDP:
+		return "UDP";
+	default:
+		return "---";
+	}
+}
+
+static void print_cm_id_state(struct rd *rd, uint8_t state)
+{
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "state", cm_id_state_to_str(state));
+		return;
+	}
+	pr_out("state %s ", cm_id_state_to_str(state));
+}
+
+static void print_ps(struct rd *rd, uint32_t ps)
+{
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "ps", cm_id_ps_to_str(ps));
+		return;
+	}
+	pr_out("ps %s ", cm_id_ps_to_str(ps));
+}
+
+static void print_ipaddr(struct rd *rd, const char *key, char *addrstr,
+			 uint16_t port)
+{
+	if (rd->json_output) {
+		int name_size = INET6_ADDRSTRLEN+strlen(":65535");
+		char json_name[name_size];
+
+		snprintf(json_name, name_size, "%s:%u", addrstr, port);
+		jsonw_string_field(rd->jw, key, json_name);
+		return;
+	}
+	pr_out("%s %s:%u ", key, addrstr, port);
+}
+
+static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
+{
+	struct __kernel_sockaddr_storage *addr;
+
+	addr = (struct __kernel_sockaddr_storage *)
+						mnl_attr_get_payload(nla_line);
+	switch (addr->ss_family) {
+	case AF_INET: {
+		struct sockaddr_in *sin = (struct sockaddr_in *)addr;
+
+		if (!inet_ntop(AF_INET, (const void *)&sin->sin_addr, addr_str,
+			       INET6_ADDRSTRLEN))
+			return -EINVAL;
+		*port = ntohs(sin->sin_port);
+		break;
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)addr;
+
+		if (!inet_ntop(AF_INET6, (const void *)&sin6->sin6_addr,
+			       addr_str, INET6_ADDRSTRLEN))
+			return -EINVAL;
+		*port = ntohs(sin6->sin6_port);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	int idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_CM_ID])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_CM_ID];
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char src_addr_str[INET6_ADDRSTRLEN];
+		char dst_addr_str[INET6_ADDRSTRLEN];
+		uint16_t src_port, dst_port;
+		uint32_t port = 0, pid = 0;
+		uint8_t type = 0, state;
+		uint32_t lqpn = 0, ps;
+		char *comm = NULL;
+		int err;
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
+		    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
+		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
+		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
+			return MNL_CB_ERROR;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+			port = mnl_attr_get_u32(
+					nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+		if (port && port != rd->port_idx)
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			lqpn = mnl_attr_get_u32(
+					nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+			if (rd_check_is_filtered(rd, "lqpn", lqpn))
+				continue;
+		}
+		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
+			type = mnl_attr_get_u8(
+					nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+			if (rd_check_is_string_filtered(rd, "qp-type",
+							qp_types_to_str(type)))
+				continue;
+		}
+
+		ps = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PS]);
+		if (rd_check_is_string_filtered(rd, "ps", cm_id_ps_to_str(ps)))
+			continue;
+
+		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
+		if (rd_check_is_string_filtered(rd, "state",
+						cm_id_state_to_str(state)))
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]) {
+			if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR],
+				    src_addr_str, &src_port))
+				continue;
+			if (rd_check_is_string_filtered(rd, "src-addr",
+							src_addr_str))
+				continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]) {
+			if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR],
+				    dst_addr_str, &dst_port))
+				continue;
+			if (rd_check_is_string_filtered(rd, "dst-addr",
+							dst_addr_str))
+				continue;
+		}
+
+		if (rd_check_is_filtered(rd, "src-port", src_port))
+			continue;
+
+		if (rd_check_is_filtered(rd, "dst-port", dst_port))
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
+		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+			/* discard const from mnl_attr_get_str */
+			comm = (char *)mnl_attr_get_str(
+				nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+		}
+
+		if (rd->json_output)
+			jsonw_start_array(rd->jw);
+
+		print_link(rd, idx, name, port, nla_line);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			print_lqpn(rd, lqpn);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
+			print_qp_type(rd, type);
+		print_cm_id_state(rd, state);
+		print_ps(rd, ps);
+		print_pid(rd, pid);
+		print_comm(rd, comm, nla_line);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
+			print_ipaddr(rd, "src-addr", src_addr_str, src_port);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR])
+			print_ipaddr(rd, "dst-addr", dst_addr_str, dst_port);
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
@@ -457,11 +698,30 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {{ .name = "link",
 
 RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
 
+static const
+struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "link", .is_number = false },
+	{ .name = "lqpn", .is_number = true },
+	{ .name = "qp-type", .is_number = false },
+	{ .name = "state", .is_number = false },
+	{ .name = "ps", .is_number = false },
+	{ .name = "dev-type", .is_number = false },
+	{ .name = "transport-type", .is_number = false },
+	{ .name = "pid", .is_number = true },
+	{ .name = "src-addr", .is_number = false },
+	{ .name = "src-port", .is_number = true },
+	{ .name = "dst-addr", .is_number = false },
+	{ .name = "dst-port", .is_number = true }
+};
+
+RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
+
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		res_no_args	},
 		{ "qp",		res_qp		},
+		{ "cm_id",	res_cm_id	},
 		{ 0 }
 	};
 
diff --git a/rdma/utils.c b/rdma/utils.c
index f946016..ec81737 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -375,6 +375,11 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_STATE]		= MNL_TYPE_U8,
 	[RDMA_NLDEV_ATTR_RES_PID]		= MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_RES_KERN_NAME]	= MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_RES_CM_ID]		= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY]	= MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_PS]		= MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_SRC_ADDR]		= MNL_TYPE_UNSPEC,
+	[RDMA_NLDEV_ATTR_RES_DST_ADDR]		= MNL_TYPE_UNSPEC,
 };
 
 int rd_attr_cb(const struct nlattr *attr, void *data)
-- 
1.8.3.1
