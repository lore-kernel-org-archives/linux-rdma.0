From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 08/19] rdma: Move out resource CM-ID logic to separate file
Date: Wed, 20 Feb 2019 09:21:25 +0200
Message-ID: <20190220072136.3840-9-leon@kernel.org>
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

Logically separate resource CM-ID logic to separate file,
in order to make CM-ID specific logic self-contained.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile   |   3 +-
 rdma/res-cmid.c | 252 ++++++++++++++++++++++++++++++++++++++++++++
 rdma/res.c      | 271 +-----------------------------------------------
 rdma/res.h      |  24 +++++
 4 files changed, 282 insertions(+), 268 deletions(-)
 create mode 100644 rdma/res-cmid.c

diff --git a/rdma/Makefile b/rdma/Makefile
index e32ccd18..ef240404 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -6,7 +6,8 @@ TARGETS :=
 ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
-RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o
+RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
+	   res-cmid.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
new file mode 100644
index 00000000..b63634a3
--- /dev/null
+++ b/rdma/res-cmid.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-cmid.c	RDMA tool
+ * Authors:     Leon Romanovsky <leonro@mellanox.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+static void print_qp_type(struct rd *rd, uint32_t val)
+{
+	if (rd->json_output)
+		jsonw_string_field(rd->jw, "qp-type", qp_types_to_str(val));
+	else
+		pr_out("qp-type %s ", qp_types_to_str(val));
+}
+
+static const char *cm_id_state_to_str(uint8_t idx)
+{
+	static const char *const cm_id_states_str[] = {
+		"IDLE",		  "ADDR_QUERY",     "ADDR_RESOLVED",
+		"ROUTE_QUERY",    "ROUTE_RESOLVED", "CONNECT",
+		"DISCONNECT",     "ADDR_BOUND",     "LISTEN",
+		"DEVICE_REMOVAL", "DESTROYING"
+	};
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
+		int name_size = INET6_ADDRSTRLEN + strlen(":65535");
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
+	addr = (struct __kernel_sockaddr_storage *)mnl_attr_get_payload(
+		nla_line);
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
+int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	int idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_CM_ID])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_CM_ID];
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+		char src_addr_str[INET6_ADDRSTRLEN];
+		char dst_addr_str[INET6_ADDRSTRLEN];
+		uint16_t src_port, dst_port;
+		uint32_t port = 0, pid = 0;
+		uint8_t type = 0, state;
+		uint32_t lqpn = 0, ps;
+		uint32_t cm_idn = 0;
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
+				nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+		if (port && port != rd->port_idx)
+			continue;
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			lqpn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+			if (rd_check_is_filtered(rd, "lqpn", lqpn))
+				continue;
+		}
+		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
+			type = mnl_attr_get_u8(
+				nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
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
+			if (rd_check_is_filtered(rd, "src-port", src_port))
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
+			if (rd_check_is_filtered(rd, "dst-port", dst_port))
+				continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+			pid = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+			comm = get_task_name(pid);
+		}
+
+		if (rd_check_is_filtered(rd, "pid", pid)) {
+			free(comm);
+			continue;
+		}
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+			cm_idn = mnl_attr_get_u32(
+				nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
+		if (rd_check_is_filtered(rd, "cm-idn", cm_idn))
+			continue;
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
+		if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
+			res_print_uint(rd, "cm-idn", cm_idn);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
+			print_ipaddr(rd, "src-addr", src_addr_str, src_port);
+		if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR])
+			print_ipaddr(rd, "dst-addr", dst_addr_str, dst_port);
+
+		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+			free(comm);
+
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
+	}
+	return MNL_CB_OK;
+}
diff --git a/rdma/res.c b/rdma/res.c
index 7956882e..d5ae60e1 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -140,7 +140,7 @@ static const char *qp_states_to_str(uint8_t idx)
 	return "UNKNOWN";
 }
 
-static const char *qp_types_to_str(uint8_t idx)
+const char *qp_types_to_str(uint8_t idx)
 {
 	static const char * const qp_types_str[] = { "SMI", "GSI", "RC",
 						     "UC", "UD", "RAW_IPV6",
@@ -153,7 +153,7 @@ static const char *qp_types_to_str(uint8_t idx)
 	return "UNKNOWN";
 }
 
-static void print_lqpn(struct rd *rd, uint32_t val)
+void print_lqpn(struct rd *rd, uint32_t val)
 {
 	if (rd->json_output)
 		jsonw_uint_field(rd->jw, "lqpn", val);
@@ -259,8 +259,8 @@ void print_dev(struct rd *rd, uint32_t idx, const char *name)
 	}
 }
 
-static void print_link(struct rd *rd, uint32_t idx, const char *name,
-		       uint32_t port, struct nlattr **nla_line)
+void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
+		struct nlattr **nla_line)
 {
 	if (rd->json_output) {
 		jsonw_uint_field(rd->jw, "ifindex", idx);
@@ -451,250 +451,6 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static void print_qp_type(struct rd *rd, uint32_t val)
-{
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "qp-type",
-				   qp_types_to_str(val));
-	else
-		pr_out("qp-type %s ", qp_types_to_str(val));
-}
-
-static const char *cm_id_state_to_str(uint8_t idx)
-{
-	static const char * const cm_id_states_str[] = {
-		"IDLE", "ADDR_QUERY", "ADDR_RESOLVED", "ROUTE_QUERY",
-		"ROUTE_RESOLVED", "CONNECT", "DISCONNECT", "ADDR_BOUND",
-		"LISTEN", "DEVICE_REMOVAL", "DESTROYING" };
-
-	if (idx < ARRAY_SIZE(cm_id_states_str))
-		return cm_id_states_str[idx];
-	return "UNKNOWN";
-}
-
-static const char *cm_id_ps_to_str(uint32_t ps)
-{
-	switch (ps) {
-	case RDMA_PS_IPOIB:
-		return "IPoIB";
-	case RDMA_PS_IB:
-		return "IPoIB";
-	case RDMA_PS_TCP:
-		return "TCP";
-	case RDMA_PS_UDP:
-		return "UDP";
-	default:
-		return "---";
-	}
-}
-
-static void print_cm_id_state(struct rd *rd, uint8_t state)
-{
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "state", cm_id_state_to_str(state));
-		return;
-	}
-	pr_out("state %s ", cm_id_state_to_str(state));
-}
-
-static void print_ps(struct rd *rd, uint32_t ps)
-{
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "ps", cm_id_ps_to_str(ps));
-		return;
-	}
-	pr_out("ps %s ", cm_id_ps_to_str(ps));
-}
-
-static void print_ipaddr(struct rd *rd, const char *key, char *addrstr,
-			 uint16_t port)
-{
-	if (rd->json_output) {
-		int name_size = INET6_ADDRSTRLEN+strlen(":65535");
-		char json_name[name_size];
-
-		snprintf(json_name, name_size, "%s:%u", addrstr, port);
-		jsonw_string_field(rd->jw, key, json_name);
-		return;
-	}
-	pr_out("%s %s:%u ", key, addrstr, port);
-}
-
-static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
-{
-	struct __kernel_sockaddr_storage *addr;
-
-	addr = (struct __kernel_sockaddr_storage *)
-						mnl_attr_get_payload(nla_line);
-	switch (addr->ss_family) {
-	case AF_INET: {
-		struct sockaddr_in *sin = (struct sockaddr_in *)addr;
-
-		if (!inet_ntop(AF_INET, (const void *)&sin->sin_addr, addr_str,
-			       INET6_ADDRSTRLEN))
-			return -EINVAL;
-		*port = ntohs(sin->sin_port);
-		break;
-	}
-	case AF_INET6: {
-		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)addr;
-
-		if (!inet_ntop(AF_INET6, (const void *)&sin6->sin6_addr,
-			       addr_str, INET6_ADDRSTRLEN))
-			return -EINVAL;
-		*port = ntohs(sin6->sin6_port);
-		break;
-	}
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
-	struct nlattr *nla_table, *nla_entry;
-	struct rd *rd = data;
-	const char *name;
-	int idx;
-
-	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
-	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
-	    !tb[RDMA_NLDEV_ATTR_RES_CM_ID])
-		return MNL_CB_ERROR;
-
-	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	nla_table = tb[RDMA_NLDEV_ATTR_RES_CM_ID];
-	mnl_attr_for_each_nested(nla_entry, nla_table) {
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
-
-		if (!nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
-		    !nla_line[RDMA_NLDEV_ATTR_RES_PS] ||
-		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
-		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
-			return MNL_CB_ERROR;
-		}
-
-		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-			port = mnl_attr_get_u32(
-					nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
-
-		if (port && port != rd->port_idx)
-			continue;
-
-		if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
-			lqpn = mnl_attr_get_u32(
-					nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-			if (rd_check_is_filtered(rd, "lqpn", lqpn))
-				continue;
-		}
-		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
-			type = mnl_attr_get_u8(
-					nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
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
-					nla_line[RDMA_NLDEV_ATTR_RES_PID]);
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
-			print_lqpn(rd, lqpn);
-		if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
-			print_qp_type(rd, type);
-		print_cm_id_state(rd, state);
-		print_ps(rd, ps);
-		print_pid(rd, pid);
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
-	}
-	return MNL_CB_OK;
-}
-
 void print_users(struct rd *rd, uint64_t val)
 {
 	if (rd->json_output)
@@ -721,25 +477,6 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
 
-static const
-struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
-	{ .name = "link", .is_number = false },
-	{ .name = "lqpn", .is_number = true },
-	{ .name = "qp-type", .is_number = false },
-	{ .name = "state", .is_number = false },
-	{ .name = "ps", .is_number = false },
-	{ .name = "dev-type", .is_number = false },
-	{ .name = "transport-type", .is_number = false },
-	{ .name = "pid", .is_number = true },
-	{ .name = "src-addr", .is_number = false },
-	{ .name = "src-port", .is_number = true },
-	{ .name = "dst-addr", .is_number = false },
-	{ .name = "dst-port", .is_number = true },
-	{ .name = "cm-idn", .is_number = true }
-};
-
-RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
-
 static int res_show(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
diff --git a/rdma/res.h b/rdma/res.h
index 19f0d420..e9d0d12e 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -12,6 +12,7 @@ int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback);
 int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 #define RES_FUNC(name, command, valid_filters, strict_port) \
 	static inline int _##name(struct rd *rd)\
@@ -71,12 +72,35 @@ struct filters cq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 
 RES_FUNC(res_cq, RDMA_NLDEV_CMD_RES_CQ_GET, cq_valid_filters, true);
 
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
+	{ .name = "dst-port", .is_number = true },
+	{ .name = "cm-idn", .is_number = true }
+};
+
+RES_FUNC(res_cm_id, RDMA_NLDEV_CMD_RES_CM_ID_GET, cm_id_valid_filters, false);
+
 char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
+void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
+		struct nlattr **nla_line);
 void print_users(struct rd *rd, uint64_t val);
 void print_key(struct rd *rd, const char *name, uint64_t val);
 void res_print_uint(struct rd *rd, const char *name, uint64_t val);
 void print_pid(struct rd *rd, uint32_t val);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
+const char *qp_types_to_str(uint8_t idx);
+void print_lqpn(struct rd *rd, uint32_t val);
 
 #endif /* _RDMA_TOOL_RES_H_ */
-- 
2.19.1
