From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 2/3] rdma: print driver resource attributes
Date: Tue, 15 May 2018 13:41:09 -0700
Message-ID: <4dcb3f83317aadf343babc364d09c470b5ac2da9.1526483157.git.swise@opengridcomputing.com>
References: <cover.1526483157.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1526483157.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This enhancement allows printing rdma device-specific state, if provided
by the kernel. This is done in a generic manner, so rdma tool doesn't
need to know about the details of every type of rdma device.

Driver attributes for a rdma resource are in the form of <key,
[print_type], value> tuples, where the key is a string and the value can
be any supported driver attribute. The print_type attribute, if present,
provides a print format to use vs the standard print format for the type.
For example, the default print type for a PROVIDER_S32 value is "%d ",
but "0x%x " if the print_type of PRINT_TYPE_HEX is included inthe tuple.

Driver resources are only printed when the -dd flag is present.
If -p is present, then the output is formatted to not exceed 80 columns,
otherwise it is printed as a single row to be grep/awk friendly.

Example output:

# rdma resource show qp lqpn 1028 -dd -p
link cxgb4_0/- lqpn 1028 rqpn 0 type RC state RTS rq-psn 0 sq-psn 0 path-mig-state MIGRATED pid 0 comm [nvme_rdma]
    sqid 1028 flushed 0 memsize 123968 cidx 85 pidx 85 wq_pidx 106 flush_cidx 85 in_use 0
    size 386 flags 0x0 rqid 1029 memsize 16768 cidx 43 pidx 41 wq_pidx 171 msn 44 rqt_hwaddr 0x2a8a5d00
    rqt_size 256 in_use 128 size 130

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/rdma.c  |   9 ++-
 rdma/rdma.h  |  11 ++++
 rdma/res.c   |  30 +++------
 rdma/utils.c | 196 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 224 insertions(+), 22 deletions(-)

diff --git a/rdma/rdma.c b/rdma/rdma.c
index b43e538..010e983 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -129,13 +129,14 @@ int main(int argc, char **argv)
 		{ "batch",		required_argument,	NULL, 'b' },
 		{ NULL, 0, NULL, 0 }
 	};
+	bool show_driver_details = false;
 	const char *batch_file = NULL;
 	bool pretty_output = false;
 	bool show_details = false;
 	bool json_output = false;
 	bool force = false;
-	char *filename;
 	struct rd rd = {};
+	char *filename;
 	int opt;
 	int err;
 
@@ -152,7 +153,10 @@ int main(int argc, char **argv)
 			pretty_output = true;
 			break;
 		case 'd':
-			show_details = true;
+			if (show_details)
+				show_driver_details = true;
+			else
+				show_details = true;
 			break;
 		case 'j':
 			json_output = true;
@@ -180,6 +184,7 @@ int main(int argc, char **argv)
 	argv += optind;
 
 	rd.show_details = show_details;
+	rd.show_driver_details = show_driver_details;
 	rd.json_output = json_output;
 	rd.pretty_output = pretty_output;
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 1908fc4..fcaf9e6 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -55,6 +55,7 @@ struct rd {
 	char **argv;
 	char *filename;
 	bool show_details;
+	bool show_driver_details;
 	struct list_head dev_map_list;
 	uint32_t dev_idx;
 	uint32_t port_idx;
@@ -115,4 +116,14 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t seq);
 void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
 int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
 int rd_attr_cb(const struct nlattr *attr, void *data);
+int rd_attr_check(const struct nlattr *attr, int *typep);
+
+/*
+ * Print helpers
+ */
+void print_driver_table(struct rd *rd, struct nlattr *tb);
+void newline(struct rd *rd);
+void newline_indent(struct rd *rd);
+#define MAX_LINE_LENGTH 80
+
 #endif /* _RDMA_TOOL_H_ */
diff --git a/rdma/res.c b/rdma/res.c
index 1a0aab6..074b992 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -439,10 +439,8 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
-		if (rd->json_output)
-			jsonw_end_array(rd->jw);
-		else
-			pr_out("\n");
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
 	}
 	return MNL_CB_OK;
 }
@@ -678,10 +676,8 @@ static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
-		if (rd->json_output)
-			jsonw_end_array(rd->jw);
-		else
-			pr_out("\n");
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
 	}
 	return MNL_CB_OK;
 }
@@ -804,10 +800,8 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
-		if (rd->json_output)
-			jsonw_end_array(rd->jw);
-		else
-			pr_out("\n");
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
 	}
 	return MNL_CB_OK;
 }
@@ -919,10 +913,8 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
-		if (rd->json_output)
-			jsonw_end_array(rd->jw);
-		else
-			pr_out("\n");
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
 	}
 	return MNL_CB_OK;
 }
@@ -1004,10 +996,8 @@ static int res_pd_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 			free(comm);
 
-		if (rd->json_output)
-			jsonw_end_array(rd->jw);
-		else
-			pr_out("\n");
+		print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+		newline(rd);
 	}
 	return MNL_CB_OK;
 }
diff --git a/rdma/utils.c b/rdma/utils.c
index 49c967f..79c3d9f 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -11,6 +11,7 @@
 
 #include "rdma.h"
 #include <ctype.h>
+#include <inttypes.h>
 
 int rd_argc(struct rd *rd)
 {
@@ -393,8 +394,32 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_MRLEN] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_NDEV_INDEX]		= MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_NDEV_NAME]		= MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_DRIVER] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_DRIVER_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_DRIVER_STRING] = MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_DRIVER_S32] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_DRIVER_U32] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_DRIVER_S64] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_DRIVER_U64] = MNL_TYPE_U64,
 };
 
+int rd_attr_check(const struct nlattr *attr, int *typep)
+{
+	int type;
+
+	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_validate(attr, nldev_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	*typep = nldev_policy[type];
+	return MNL_CB_OK;
+}
+
 int rd_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -660,3 +685,174 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index)
 	free(dev_name);
 	return dev_map;
 }
+
+#define nla_type(attr) ((attr)->nla_type & NLA_TYPE_MASK)
+
+void newline(struct rd *rd)
+{
+	if (rd->json_output)
+		jsonw_end_array(rd->jw);
+	else
+		pr_out("\n");
+}
+
+void newline_indent(struct rd *rd)
+{
+	newline(rd);
+	if (!rd->json_output)
+		pr_out("    ");
+}
+
+static int print_driver_string(struct rd *rd, const char *key_str,
+				 const char *val_str)
+{
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, key_str, val_str);
+		return 0;
+	} else {
+		return pr_out("%s %s ", key_str, val_str);
+	}
+}
+
+static int print_driver_s32(struct rd *rd, const char *key_str, int32_t val,
+			      enum rdma_nldev_print_type print_type)
+{
+	if (rd->json_output) {
+		jsonw_int_field(rd->jw, key_str, val);
+		return 0;
+	}
+	switch (print_type) {
+	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+		return pr_out("%s %d ", key_str, val);
+	case RDMA_NLDEV_PRINT_TYPE_HEX:
+		return pr_out("%s 0x%x ", key_str, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int print_driver_u32(struct rd *rd, const char *key_str, uint32_t val,
+			      enum rdma_nldev_print_type print_type)
+{
+	if (rd->json_output) {
+		jsonw_int_field(rd->jw, key_str, val);
+		return 0;
+	}
+	switch (print_type) {
+	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+		return pr_out("%s %u ", key_str, val);
+	case RDMA_NLDEV_PRINT_TYPE_HEX:
+		return pr_out("%s 0x%x ", key_str, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int print_driver_s64(struct rd *rd, const char *key_str, int64_t val,
+			      enum rdma_nldev_print_type print_type)
+{
+	if (rd->json_output) {
+		jsonw_int_field(rd->jw, key_str, val);
+		return 0;
+	}
+	switch (print_type) {
+	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+		return pr_out("%s %" PRId64 " ", key_str, val);
+	case RDMA_NLDEV_PRINT_TYPE_HEX:
+		return pr_out("%s 0x%" PRIx64 " ", key_str, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int print_driver_u64(struct rd *rd, const char *key_str, uint64_t val,
+			      enum rdma_nldev_print_type print_type)
+{
+	if (rd->json_output) {
+		jsonw_int_field(rd->jw, key_str, val);
+		return 0;
+	}
+	switch (print_type) {
+	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+		return pr_out("%s %" PRIu64 " ", key_str, val);
+	case RDMA_NLDEV_PRINT_TYPE_HEX:
+		return pr_out("%s 0x%" PRIx64 " ", key_str, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int print_driver_entry(struct rd *rd, struct nlattr *key_attr,
+				struct nlattr *val_attr,
+				enum rdma_nldev_print_type print_type)
+{
+	const char *key_str = mnl_attr_get_str(key_attr);
+	int attr_type = nla_type(val_attr);
+
+	switch (attr_type) {
+	case RDMA_NLDEV_ATTR_DRIVER_STRING:
+		return print_driver_string(rd, key_str,
+				mnl_attr_get_str(val_attr));
+	case RDMA_NLDEV_ATTR_DRIVER_S32:
+		return print_driver_s32(rd, key_str,
+				mnl_attr_get_u32(val_attr), print_type);
+	case RDMA_NLDEV_ATTR_DRIVER_U32:
+		return print_driver_u32(rd, key_str,
+				mnl_attr_get_u32(val_attr), print_type);
+	case RDMA_NLDEV_ATTR_DRIVER_S64:
+		return print_driver_s64(rd, key_str,
+				mnl_attr_get_u64(val_attr), print_type);
+	case RDMA_NLDEV_ATTR_DRIVER_U64:
+		return print_driver_u64(rd, key_str,
+				mnl_attr_get_u64(val_attr), print_type);
+	}
+	return -EINVAL;
+}
+
+void print_driver_table(struct rd *rd, struct nlattr *tb)
+{
+	int print_type = RDMA_NLDEV_PRINT_TYPE_UNSPEC;
+	struct nlattr *tb_entry, *key = NULL, *val;
+	int type, cc = 0;
+	int ret;
+
+	if (!rd->show_driver_details || !tb)
+		return;
+
+	if (rd->pretty_output)
+		newline_indent(rd);
+
+	/*
+	 * Driver attrs are tuples of {key, [print-type], value}.
+	 * The key must be a string.  If print-type is present, it 
+	 * defines an alternate printf format type vs the native format
+	 * for the attribute.  And the value can be any available
+	 * driver type.
+	 */
+	mnl_attr_for_each_nested(tb_entry, tb) {
+
+		if (cc > MAX_LINE_LENGTH) {
+			if (rd->pretty_output)
+				newline_indent(rd);
+			cc = 0;
+		}
+		if (rd_attr_check(tb_entry, &type) != MNL_CB_OK)
+			return;
+		if (!key) {
+			if (type != MNL_TYPE_NUL_STRING)
+				return;
+			key = tb_entry;
+		} else if (type == MNL_TYPE_U8) {
+			print_type = mnl_attr_get_u8(tb_entry);
+		} else {
+			val = tb_entry;
+			ret = print_driver_entry(rd, key, val, print_type);
+			if (ret < 0)
+				return;
+			cc += ret;
+			print_type = RDMA_NLDEV_PRINT_TYPE_UNSPEC;
+			key = NULL;
+		}
+	}
+	return;
+}
-- 
1.8.3.1
