From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/4] infiniband-diags: move core saquery functionality to
 ibdiag_common
Date: Tue, 5 Jul 2011 12:08:13 -0700
Message-ID: <20110705120813.39fc4ab5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


While this is sub-optimal it is the easiest way to get saquery support to the
other diags.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |   45 +++++++++++
 src/ibdiag_common.c     |  172 ++++++++++++++++++++++++++++++++++++++++
 src/saquery.c           |  198 ++---------------------------------------------
 3 files changed, 224 insertions(+), 191 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index b113cfe..69cddfb 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -81,4 +81,49 @@ extern int ibdiag_process_opts(int argc, char *const argv[], void *context,
 extern void ibdiag_show_usage();
 extern void iberror(const char *fn, char *msg, ...);
 
+/* define an SA query structure to be common
+ * This is by no means optimal but it moves the saquery functionality out of
+ * the saquery tool and provides it to other utilities.
+ */
+struct bind_handle {
+	int fd, agent;
+	ib_portid_t dport;
+	struct ibmad_port *srcport;
+};
+typedef struct bind_handle * bind_handle_t;
+bind_handle_t sa_get_bind_handle(void);
+void sa_free_bind_handle(bind_handle_t h);
+
+struct sa_query_result {
+	uint32_t status;
+	unsigned result_cnt;
+	void *p_result_madw;
+};
+int sa_query(struct bind_handle *h, uint8_t method,
+	     uint16_t attr, uint32_t mod, uint64_t comp_mask, uint64_t sm_key,
+	     void *data, struct sa_query_result *result);
+void sa_free_result_mad(struct sa_query_result *result);
+void *sa_get_query_rec(void *mad, unsigned i);
+void sa_report_err(int status);
+
+#define cl_hton8(x) (x)
+#define CHECK_AND_SET_VAL(val, size, comp_with, target, name, mask) \
+	if ((int##size##_t) val != (int##size##_t) comp_with) { \
+		target = cl_hton##size((uint##size##_t) val); \
+		comp_mask |= IB_##name##_COMPMASK_##mask; \
+	}
+
+#define CHECK_AND_SET_GID(val, target, name, mask) \
+	if (valid_gid(&(val))) { \
+		memcpy(&(target), &(val), sizeof(val)); \
+		comp_mask |= IB_##name##_COMPMASK_##mask; \
+	}
+
+#define CHECK_AND_SET_VAL_AND_SEL(val, target, name, mask, sel) \
+	if (val) { \
+		target = val; \
+		comp_mask |= IB_##name##_COMPMASK_##mask##sel; \
+		comp_mask |= IB_##name##_COMPMASK_##mask; \
+	}
+
 #endif				/* _IBDIAG_COMMON_H_ */
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 82f72af..6d03a43 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -337,3 +337,175 @@ void iberror(const char *fn, char *msg, ...)
 
 	exit(-1);
 }
+
+/* define an SA query structure to be common
+ * This is by no means optimal but it moves the saquery functionality out of
+ * the saquery tool and provides it to other utilities.
+ */
+bind_handle_t sa_get_bind_handle(void)
+{
+	struct ibmad_port * srcport;
+	bind_handle_t handle;
+	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
+
+	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
+	if (!srcport) {
+		IBWARN("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
+		return (NULL);
+	}
+
+	handle = calloc(1, sizeof(*handle));
+	if (!handle)
+		IBPANIC("calloc failed");
+
+	ib_resolve_smlid_via(&handle->dport, ibd_timeout, srcport);
+	if (!handle->dport.lid) {
+		IBWARN("No SM found.");
+		free(handle);
+		return (NULL);
+	}
+
+	handle->dport.qp = 1;
+	if (!handle->dport.qkey)
+		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
+
+	handle->srcport = srcport;
+	handle->fd = mad_rpc_portid(srcport);
+	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
+
+	return handle;
+}
+
+void sa_free_bind_handle(bind_handle_t h)
+{
+	umad_unregister(h->fd, h->agent);
+	mad_rpc_close_port(h->srcport);
+	free(h);
+}
+
+int sa_query(bind_handle_t h, uint8_t method,
+		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
+		    uint64_t sm_key, void *data, struct sa_query_result *result)
+{
+	ib_rpc_t rpc;
+	void *umad, *mad;
+	int ret, offset, len = 256;
+
+	memset(&rpc, 0, sizeof(rpc));
+	rpc.mgtclass = IB_SA_CLASS;
+	rpc.method = method;
+	rpc.attr.id = attr;
+	rpc.attr.mod = mod;
+	rpc.mask = comp_mask;
+	rpc.datasz = IB_SA_DATA_SIZE;
+	rpc.dataoffs = IB_SA_DATA_OFFS;
+
+	umad = calloc(1, len + umad_size());
+	if (!umad)
+		IBPANIC("cannot alloc mem for umad: %s\n", strerror(errno));
+
+	mad_build_pkt(umad, &rpc, &h->dport, NULL, data);
+
+	mad_set_field64(umad_get_mad(umad), 0, IB_SA_MKEY_F, sm_key);
+
+	if (ibdebug > 1)
+		xdump(stdout, "SA Request:\n", umad_get_mad(umad), len);
+
+	ret = umad_send(h->fd, h->agent, umad, len, ibd_timeout, 0);
+	if (ret < 0) {
+		IBWARN("umad_send failed: attr %u: %s\n",
+			attr, strerror(errno));
+		free(umad);
+		return (IB_ERROR);
+	}
+
+recv_mad:
+	ret = umad_recv(h->fd, umad, &len, ibd_timeout);
+	if (ret < 0) {
+		if (errno == ENOSPC) {
+			umad = realloc(umad, umad_size() + len);
+			goto recv_mad;
+		}
+		IBWARN("umad_recv failed: attr 0x%x: %s\n", attr,
+			strerror(errno));
+		free(umad);
+		return (IB_ERROR);
+	}
+
+	if ((ret = umad_status(umad)))
+		return ret;
+
+	mad = umad_get_mad(umad);
+
+	if (ibdebug > 1)
+		xdump(stdout, "SA Response:\n", mad, len);
+
+	method = (uint8_t) mad_get_field(mad, 0, IB_MAD_METHOD_F);
+	offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
+	result->status = mad_get_field(mad, 0, IB_MAD_STATUS_F);
+	result->p_result_madw = mad;
+	if (result->status != IB_SA_MAD_STATUS_SUCCESS)
+		result->result_cnt = 0;
+	else if (method != IB_MAD_METHOD_GET_TABLE)
+		result->result_cnt = 1;
+	else if (!offset)
+		result->result_cnt = 0;
+	else
+		result->result_cnt = (len - IB_SA_DATA_OFFS) / (offset << 3);
+
+	return 0;
+}
+
+void sa_free_result_mad(struct sa_query_result *result)
+{
+	if (result->p_result_madw) {
+		free((uint8_t *) result->p_result_madw - umad_size());
+		result->p_result_madw = NULL;
+	}
+}
+
+void *sa_get_query_rec(void *mad, unsigned i)
+{
+	int offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
+	return (uint8_t *) mad + IB_SA_DATA_OFFS + i * (offset << 3);
+}
+
+static const char *ib_sa_error_str[] = {
+	"SA_NO_ERROR",
+	"SA_ERR_NO_RESOURCES",
+	"SA_ERR_REQ_INVALID",
+	"SA_ERR_NO_RECORDS",
+	"SA_ERR_TOO_MANY_RECORDS",
+	"SA_ERR_REQ_INVALID_GID",
+	"SA_ERR_REQ_INSUFFICIENT_COMPONENTS",
+	"SA_ERR_REQ_DENIED",
+	"SA_ERR_STATUS_PRIO_SUGGESTED",
+	"SA_ERR_UNKNOWN"
+};
+
+#define ARR_SIZE(a) (sizeof(a)/sizeof((a)[0]))
+#define SA_ERR_UNKNOWN (ARR_SIZE(ib_sa_error_str) - 1)
+
+static inline const char *ib_sa_err_str(IN uint8_t status)
+{
+	if (status > SA_ERR_UNKNOWN)
+		status = SA_ERR_UNKNOWN;
+	return (ib_sa_error_str[status]);
+}
+
+void sa_report_err(int status)
+{
+	int st = status & 0xff;
+	char sm_err_str[64] = { 0 };
+	char sa_err_str[64] = { 0 };
+
+	if (st)
+		sprintf(sm_err_str, " SM(%s)", ib_get_err_str(st));
+
+	st = status >> 8;
+	if (st)
+		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str((uint8_t) st));
+
+	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
+		status, sm_err_str, sa_err_str);
+}
diff --git a/src/saquery.c b/src/saquery.c
index 73acea5..95f7e6e 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -59,19 +59,6 @@
 
 #include "ibdiag_common.h"
 
-struct bind_handle {
-	int fd, agent;
-	ib_portid_t dport;
-};
-
-struct sa_query_result {
-	uint32_t status;
-	unsigned result_cnt;
-	void *p_result_madw;
-};
-
-typedef struct bind_handle *bind_handle_t;
-
 struct query_params {
 	ib_gid_t sgid, dgid, gid, mgid;
 	uint16_t slid, dlid, mlid;
@@ -122,121 +109,6 @@ int requested_lid_flag = 0;
 uint64_t requested_guid = 0;
 int requested_guid_flag = 0;
 
-#define ARR_SIZE(a) (sizeof(a)/sizeof((a)[0]))
-
-static const char *ib_sa_error_str[] = {
-	"SA_NO_ERROR",
-	"SA_ERR_NO_RESOURCES",
-	"SA_ERR_REQ_INVALID",
-	"SA_ERR_NO_RECORDS",
-	"SA_ERR_TOO_MANY_RECORDS",
-	"SA_ERR_REQ_INVALID_GID",
-	"SA_ERR_REQ_INSUFFICIENT_COMPONENTS",
-	"SA_ERR_REQ_DENIED",
-	"SA_ERR_STATUS_PRIO_SUGGESTED",
-	"SA_ERR_UNKNOWN"
-};
-
-#define SA_ERR_UNKNOWN (ARR_SIZE(ib_sa_error_str) - 1)
-
-static inline const char *ib_sa_err_str(IN uint8_t status)
-{
-	if (status > SA_ERR_UNKNOWN)
-		status = SA_ERR_UNKNOWN;
-	return (ib_sa_error_str[status]);
-}
-
-static inline void report_err(int status)
-{
-	int st = status & 0xff;
-	char sm_err_str[64] = { 0 };
-	char sa_err_str[64] = { 0 };
-
-	if (st)
-		sprintf(sm_err_str, " SM(%s)", ib_get_err_str(st));
-
-	st = status >> 8;
-	if (st)
-		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str((uint8_t) st));
-
-	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
-		status, sm_err_str, sa_err_str);
-}
-
-static int sa_query(struct bind_handle *h, uint8_t method,
-		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
-		    uint64_t sm_key, void *data, struct sa_query_result *result)
-{
-	ib_rpc_t rpc;
-	void *umad, *mad;
-	int ret, offset, len = 256;
-
-	memset(&rpc, 0, sizeof(rpc));
-	rpc.mgtclass = IB_SA_CLASS;
-	rpc.method = method;
-	rpc.attr.id = attr;
-	rpc.attr.mod = mod;
-	rpc.mask = comp_mask;
-	rpc.datasz = IB_SA_DATA_SIZE;
-	rpc.dataoffs = IB_SA_DATA_OFFS;
-
-	umad = calloc(1, len + umad_size());
-	if (!umad)
-		IBPANIC("cannot alloc mem for umad: %s\n", strerror(errno));
-
-	mad_build_pkt(umad, &rpc, &h->dport, NULL, data);
-
-	mad_set_field64(umad_get_mad(umad), 0, IB_SA_MKEY_F, sm_key);
-
-	if (ibdebug > 1)
-		xdump(stdout, "SA Request:\n", umad_get_mad(umad), len);
-
-	ret = umad_send(h->fd, h->agent, umad, len, ibd_timeout, 0);
-	if (ret < 0)
-		IBPANIC("umad_send failed: attr %u: %s\n",
-			attr, strerror(errno));
-
-recv_mad:
-	ret = umad_recv(h->fd, umad, &len, ibd_timeout);
-	if (ret < 0) {
-		if (errno == ENOSPC) {
-			umad = realloc(umad, umad_size() + len);
-			goto recv_mad;
-		}
-		IBPANIC("umad_recv failed: attr 0x%x: %s\n", attr,
-			strerror(errno));
-	}
-
-	if ((ret = umad_status(umad)))
-		return ret;
-
-	mad = umad_get_mad(umad);
-
-	if (ibdebug > 1)
-		xdump(stdout, "SA Response:\n", mad, len);
-
-	method = (uint8_t) mad_get_field(mad, 0, IB_MAD_METHOD_F);
-	offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
-	result->status = mad_get_field(mad, 0, IB_MAD_STATUS_F);
-	result->p_result_madw = mad;
-	if (result->status != IB_SA_MAD_STATUS_SUCCESS)
-		result->result_cnt = 0;
-	else if (method != IB_MAD_METHOD_GET_TABLE)
-		result->result_cnt = 1;
-	else if (!offset)
-		result->result_cnt = 0;
-	else
-		result->result_cnt = (len - IB_SA_DATA_OFFS) / (offset << 3);
-
-	return 0;
-}
-
-static void *sa_get_query_rec(void *mad, unsigned i)
-{
-	int offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
-	return (uint8_t *) mad + IB_SA_DATA_OFFS + i * (offset << 3);
-}
-
 static unsigned valid_gid(ib_gid_t * gid)
 {
 	ib_gid_t zero_gid;
@@ -837,14 +709,6 @@ static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
 	}
 }
 
-static void sa_free_result_mad(struct sa_query_result *result)
-{
-	if (result->p_result_madw) {
-		free((uint8_t *) result->p_result_madw - umad_size());
-		result->p_result_madw = NULL;
-	}
-}
-
 /**
  * Get any record(s)
  */
@@ -861,7 +725,7 @@ static int get_any_records(bind_handle_t h,
 	}
 
 	if (result->status != IB_SA_MAD_STATUS_SUCCESS) {
-		report_err(result->status);
+		sa_report_err(result->status);
 		return EIO;
 	}
 
@@ -1004,26 +868,6 @@ static int parse_lid_and_ports(bind_handle_t h,
 	return 0;
 }
 
-#define cl_hton8(x) (x)
-#define CHECK_AND_SET_VAL(val, size, comp_with, target, name, mask) \
-	if ((int##size##_t) val != (int##size##_t) comp_with) { \
-		target = cl_hton##size((uint##size##_t) val); \
-		comp_mask |= IB_##name##_COMPMASK_##mask; \
-	}
-
-#define CHECK_AND_SET_GID(val, target, name, mask) \
-	if (valid_gid(&(val))) { \
-		memcpy(&(target), &(val), sizeof(val)); \
-		comp_mask |= IB_##name##_COMPMASK_##mask; \
-	}
-
-#define CHECK_AND_SET_VAL_AND_SEL(val, target, name, mask, sel) \
-	if (val) { \
-		target = val; \
-		comp_mask |= IB_##name##_COMPMASK_##mask##sel; \
-		comp_mask |= IB_##name##_COMPMASK_##mask; \
-	}
-
 /*
  * Get the portinfo records available with IsSM or IsSMdisabled CapabilityMask bit on.
  */
@@ -1095,7 +939,7 @@ static int get_print_class_port_info(bind_handle_t h)
 		return ret;
 	}
 	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
-		report_err(result.status);
+		sa_report_err(result.status);
 		ret = EIO;
 		goto Exit;
 	}
@@ -1434,37 +1278,6 @@ static int query_mft_records(const struct query_cmd *q, bind_handle_t h,
 					&mftr, 0, dump_one_mft_record);
 }
 
-static bind_handle_t get_bind_handle(void)
-{
-	static struct ibmad_port *srcport;
-	static struct bind_handle handle;
-	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
-
-	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
-	if (!srcport)
-		IBERROR("Failed to open '%s' port '%d'", ibd_ca, ibd_ca_port);
-
-	ib_resolve_smlid_via(&handle.dport, ibd_timeout, srcport);
-	if (!handle.dport.lid)
-		IBPANIC("No SM found.");
-
-	handle.dport.qp = 1;
-	if (!handle.dport.qkey)
-		handle.dport.qkey = IB_DEFAULT_QP1_QKEY;
-
-	handle.fd = mad_rpc_portid(srcport);
-	handle.agent = umad_register(handle.fd, IB_SA_CLASS, 2, 1, NULL);
-
-	return &handle;
-}
-
-static void clean_up(struct bind_handle *h)
-{
-	umad_unregister(h->fd, h->agent);
-	umad_close_port(h->fd);
-	umad_done();
-}
-
 static const struct query_cmd query_cmds[] = {
 	{"ClassPortInfo", "CPI", CLASS_PORT_INFO,
 	 NULL, query_class_port_info},
@@ -1861,7 +1674,10 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 	}
 
-	h = get_bind_handle();
+	h = sa_get_bind_handle();
+	if (!h)
+		IBPANIC("Failed to bind to the SA");
+
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (src_lid && *src_lid)
@@ -1898,7 +1714,7 @@ int main(int argc, char **argv)
 
 	if (src_lid)
 		free(src_lid);
-	clean_up(h);
+	sa_free_bind_handle(h);
 	close_node_name_map(node_name_map);
 	return (status);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
