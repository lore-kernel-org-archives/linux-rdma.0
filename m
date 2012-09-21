From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: move sa query code into it's own common
 file
Date: Fri, 21 Sep 2012 09:46:20 -0700
Message-ID: <20120921094620.003705cb9c1f80d886f8ba1b@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Also remove bind from handle name

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am             |    2 +-
 include/ibdiag_common.h |   46 ----------
 include/ibdiag_sa.h     |   92 +++++++++++++++++++++
 src/ibdiag_common.c     |  165 -------------------------------------
 src/ibdiag_sa.c         |  210 +++++++++++++++++++++++++++++++++++++++++++++++
 src/saquery.c           |   63 +++++++-------
 6 files changed, 335 insertions(+), 243 deletions(-)
 create mode 100644 include/ibdiag_sa.h
 create mode 100644 src/ibdiag_sa.c

diff --git a/Makefile.am b/Makefile.am
index 33b5f90..a169809 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -91,7 +91,7 @@ noinst_LIBRARIES = libcommon.a
 AM_CFLAGS = -Wall $(DBGFLAGS)
 LDADD = libcommon.a
 
-libcommon_a_SOURCES = src/ibdiag_common.c
+libcommon_a_SOURCES = src/ibdiag_common.c src/ibdiag_sa.c
 src_ibaddr_SOURCES = src/ibaddr.c
 src_ibnetdiscover_SOURCES = src/ibnetdiscover.c
 src_ibnetdiscover_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index c297c4d..b9f59f9 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -102,51 +102,6 @@ extern char *conv_cnt_human_readable(uint64_t val64, float *val, int data);
 
 int is_mlnx_ext_port_info_supported(uint32_t devid);
 
-/* define an SA query structure to be common
- * This is by no means optimal but it moves the saquery functionality out of
- * the saquery tool and provides it to other utilities.
- */
-struct bind_handle {
-	int fd, agent;
-	ib_portid_t dport;
-	struct ibmad_port *srcport;
-};
-typedef struct bind_handle * bind_handle_t;
-bind_handle_t sa_get_bind_handle(void);
-void sa_free_bind_handle(bind_handle_t h);
-
-struct sa_query_result {
-	uint32_t status;
-	unsigned result_cnt;
-	void *p_result_madw;
-};
-int sa_query(struct bind_handle *h, uint8_t method,
-	     uint16_t attr, uint32_t mod, uint64_t comp_mask, uint64_t sm_key,
-	     void *data, size_t datasz, struct sa_query_result *result);
-void sa_free_result_mad(struct sa_query_result *result);
-void *sa_get_query_rec(void *mad, unsigned i);
-void sa_report_err(int status);
-
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
 void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
 		 ibnd_port_t * port);
 
@@ -162,7 +117,6 @@ int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
 		  const char *format, ...);
 void dump_portinfo(void *pi, int pisize, int tabs);
 
-
 /**
  * Some common command line parsing
  */
diff --git a/include/ibdiag_sa.h b/include/ibdiag_sa.h
new file mode 100644
index 0000000..41b4a4c
--- /dev/null
+++ b/include/ibdiag_sa.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2006-2007 The Regents of the University of California.
+ * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2012 Lawrence Livermore National Security. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef _IBDIAG_SA_H_
+#define _IBDIAG_SA_H_
+
+#include <infiniband/mad.h>
+#include <infiniband/iba/ib_types.h>
+
+/* define an SA query structure to be common
+ * This is by no means optimal but it moves the saquery functionality out of
+ * the saquery tool and provides it to other utilities.
+ */
+struct sa_handle {
+	int fd, agent;
+	ib_portid_t dport;
+	struct ibmad_port *srcport;
+};
+
+struct sa_query_result {
+	uint32_t status;
+	unsigned result_cnt;
+	void *p_result_madw;
+};
+
+struct sa_handle * sa_get_handle(void);
+void sa_free_handle(struct sa_handle * h);
+
+int sa_query(struct sa_handle *h, uint8_t method,
+	     uint16_t attr, uint32_t mod, uint64_t comp_mask, uint64_t sm_key,
+	     void *data, size_t datasz, struct sa_query_result *result);
+void sa_free_result_mad(struct sa_query_result *result);
+void *sa_get_query_rec(void *mad, unsigned i);
+void sa_report_err(int status);
+
+/* Macros for setting query values and ComponentMasks */
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
+#endif /* _IBDIAG_SA_H_ */
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index d550529..3d9e1ad 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -686,171 +686,6 @@ int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
 	return -1;
 }
 
-/* define a common SA query structure
- * This is by no means optimal but it moves the saquery functionality out of
- * the saquery tool and provides it to other utilities.
- */
-bind_handle_t sa_get_bind_handle(void)
-{
-	bind_handle_t handle;
-	handle = calloc(1, sizeof(*handle));
-	if (!handle)
-		IBPANIC("calloc failed");
-
-	resolve_sm_portid(ibd_ca, ibd_ca_port, &handle->dport);
-	if (!handle->dport.lid) {
-		IBWARN("No SM/SA found on port %s:%d",
-			ibd_ca ? "" : ibd_ca,
-			ibd_ca_port);
-		free(handle);
-		return (NULL);
-	}
-
-	handle->dport.qp = 1;
-	if (!handle->dport.qkey)
-		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
-
-	handle->fd = umad_open_port(ibd_ca, ibd_ca_port);
-	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
-
-	return handle;
-}
-
-void sa_free_bind_handle(bind_handle_t h)
-{
-	umad_unregister(h->fd, h->agent);
-	umad_close_port(h->fd);
-	free(h);
-}
-
-int sa_query(bind_handle_t h, uint8_t method,
-		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
-		    uint64_t sm_key, void *data, size_t datasz,
-		    struct sa_query_result *result)
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
-	rpc.datasz = datasz;
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
-	if (ret < 0) {
-		IBWARN("umad_send failed: attr %u: %s\n",
-			attr, strerror(errno));
-		free(umad);
-		return (-ret);
-	}
-
-recv_mad:
-	ret = umad_recv(h->fd, umad, &len, ibd_timeout);
-	if (ret < 0) {
-		if (errno == ENOSPC) {
-			umad = realloc(umad, umad_size() + len);
-			goto recv_mad;
-		}
-		IBWARN("umad_recv failed: attr 0x%x: %s\n", attr,
-			strerror(errno));
-		free(umad);
-		return (-ret);
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
-void sa_free_result_mad(struct sa_query_result *result)
-{
-	if (result->p_result_madw) {
-		free((uint8_t *) result->p_result_madw - umad_size());
-		result->p_result_madw = NULL;
-	}
-}
-
-void *sa_get_query_rec(void *mad, unsigned i)
-{
-	int offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
-	return (uint8_t *) mad + IB_SA_DATA_OFFS + i * (offset << 3);
-}
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
-#define ARR_SIZE(a) (sizeof(a)/sizeof((a)[0]))
-#define SA_ERR_UNKNOWN (ARR_SIZE(ib_sa_error_str) - 1)
-
-static inline const char *ib_sa_err_str(IN uint8_t status)
-{
-	if (status > SA_ERR_UNKNOWN)
-		status = SA_ERR_UNKNOWN;
-	return (ib_sa_error_str[status]);
-}
-
-void sa_report_err(int status)
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
 static unsigned int get_max(unsigned int num)
 {
 	unsigned r = 0;		// r will be lg(num)
diff --git a/src/ibdiag_sa.c b/src/ibdiag_sa.c
new file mode 100644
index 0000000..2b84bfa
--- /dev/null
+++ b/src/ibdiag_sa.c
@@ -0,0 +1,210 @@
+/*
+ * Copyright (c) 2006-2007 The Regents of the University of California.
+ * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2011 Lawrence Livermore National Security. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+
+#include <errno.h>
+#include <infiniband/umad.h>
+
+#include "ibdiag_common.h"
+#include "ibdiag_sa.h"
+
+/* define a common SA query structure
+ * This is by no means optimal but it moves the saquery functionality out of
+ * the saquery tool and provides it to other utilities.
+ */
+
+struct sa_handle * sa_get_handle(void)
+{
+	struct sa_handle * handle;
+	handle = calloc(1, sizeof(*handle));
+	if (!handle)
+		IBPANIC("calloc failed");
+
+	resolve_sm_portid(ibd_ca, ibd_ca_port, &handle->dport);
+	if (!handle->dport.lid) {
+		IBWARN("No SM/SA found on port %s:%d",
+			ibd_ca ? "" : ibd_ca,
+			ibd_ca_port);
+		free(handle);
+		return (NULL);
+	}
+
+	handle->dport.qp = 1;
+	if (!handle->dport.qkey)
+		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
+
+	handle->fd = umad_open_port(ibd_ca, ibd_ca_port);
+	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
+
+	return handle;
+}
+
+void sa_free_handle(struct sa_handle * h)
+{
+	umad_unregister(h->fd, h->agent);
+	umad_close_port(h->fd);
+	free(h);
+}
+
+int sa_query(struct sa_handle * h, uint8_t method,
+		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
+		    uint64_t sm_key, void *data, size_t datasz,
+		    struct sa_query_result *result)
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
+	rpc.datasz = datasz;
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
+		return (-ret);
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
+		return (-ret);
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
index 4ff2f65..60c78ed 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -58,6 +58,7 @@
 #include <complib/cl_nodenamemap.h>
 
 #include "ibdiag_common.h"
+#include "ibdiag_sa.h"
 
 struct query_params {
 	ib_gid_t sgid, dgid, gid, mgid;
@@ -79,7 +80,7 @@ struct query_cmd {
 	const char *name, *alias;
 	uint16_t query_type;
 	const char *usage;
-	int (*handler) (const struct query_cmd * q, bind_handle_t h,
+	int (*handler) (const struct query_cmd * q, struct sa_handle * h,
 			struct query_params * p, int argc, char *argv[]);
 };
 
@@ -721,7 +722,7 @@ static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
 /**
  * Get any record(s)
  */
-static int get_any_records(bind_handle_t h,
+static int get_any_records(struct sa_handle * h,
 			   uint16_t attr_id, uint32_t attr_mod,
 			   ib_net64_t comp_mask, void *attr,
 			   size_t attr_size,
@@ -742,7 +743,7 @@ static int get_any_records(bind_handle_t h,
 	return ret;
 }
 
-static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
+static int get_and_dump_any_records(struct sa_handle * h, uint16_t attr_id,
 				    uint32_t attr_mod, ib_net64_t comp_mask,
 				    void *attr,
 				    size_t attr_size,
@@ -762,13 +763,13 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 /**
  * Get all the records available for requested query type.
  */
-static int get_all_records(bind_handle_t h, uint16_t attr_id,
+static int get_all_records(struct sa_handle * h, uint16_t attr_id,
 			   struct sa_query_result *result)
 {
 	return get_any_records(h, attr_id, 0, 0, NULL, 0, result);
 }
 
-static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
+static int get_and_dump_all_records(struct sa_handle * h, uint16_t attr_id,
 				    void (*dump_func) (void *))
 {
 	struct sa_query_result result;
@@ -784,7 +785,7 @@ static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
 /**
  * return the lid from the node descriptor (name) supplied
  */
-static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
+static int get_lid_from_name(struct sa_handle * h, const char *name, uint16_t * lid)
 {
 	ib_node_record_t *node_record = NULL;
 	ib_node_info_t *p_ni = NULL;
@@ -813,7 +814,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	return ret;
 }
 
-static uint16_t get_lid(bind_handle_t h, const char *name)
+static uint16_t get_lid(struct sa_handle * h, const char *name)
 {
 	int rc = 0;
 	uint16_t rc_lid = 0;
@@ -840,7 +841,7 @@ static uint16_t get_lid(bind_handle_t h, const char *name)
 	return rc_lid;
 }
 
-static int parse_lid_and_ports(bind_handle_t h,
+static int parse_lid_and_ports(struct sa_handle * h,
 			       char *str, int *lid, int *port1, int *port2)
 {
 	char *p, *e;
@@ -883,7 +884,7 @@ static int parse_lid_and_ports(bind_handle_t h,
 /*
  * Get the portinfo records available with IsSM or IsSMdisabled CapabilityMask bit on.
  */
-static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask,
+static int get_issm_records(struct sa_handle * h, ib_net32_t capability_mask,
 			    struct sa_query_result *result)
 {
 	ib_portinfo_record_t attr;
@@ -895,7 +896,7 @@ static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask,
 			       IB_PIR_COMPMASK_CAPMASK, &attr, sizeof(attr), result);
 }
 
-static int print_node_records(bind_handle_t h)
+static int print_node_records(struct sa_handle * h)
 {
 	unsigned i;
 	int ret;
@@ -940,7 +941,7 @@ static int print_node_records(bind_handle_t h)
 	return ret;
 }
 
-static int get_print_class_port_info(bind_handle_t h)
+static int get_print_class_port_info(struct sa_handle * h)
 {
 	struct sa_query_result result;
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
@@ -960,7 +961,7 @@ Exit:
 	return ret;
 }
 
-static int query_path_records(const struct query_cmd *q, bind_handle_t h,
+static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
 			      struct query_params *p, int argc, char *argv[])
 {
 	ib_path_rec_t pr;
@@ -994,7 +995,7 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
 					&pr, sizeof(pr), dump_path_record);
 }
 
-static int print_issm_records(bind_handle_t h)
+static int print_issm_records(struct sa_handle * h)
 {
 	struct sa_query_result result;
 	int ret = 0;
@@ -1020,7 +1021,7 @@ static int print_issm_records(bind_handle_t h)
 	return (ret);
 }
 
-static int print_multicast_member_records(bind_handle_t h)
+static int print_multicast_member_records(struct sa_handle * h)
 {
 	struct sa_query_result mc_group_result;
 	struct sa_query_result nr_result;
@@ -1050,19 +1051,19 @@ return_mc:
 	return ret;
 }
 
-static int print_multicast_group_records(bind_handle_t h)
+static int print_multicast_group_records(struct sa_handle * h)
 {
 	return get_and_dump_all_records(h, IB_SA_ATTR_MCRECORD,
 					dump_multicast_group_record);
 }
 
-static int query_class_port_info(const struct query_cmd *q, bind_handle_t h,
+static int query_class_port_info(const struct query_cmd *q, struct sa_handle * h,
 				 struct query_params *p, int argc, char *argv[])
 {
 	return get_print_class_port_info(h);
 }
 
-static int query_node_records(const struct query_cmd *q, bind_handle_t h,
+static int query_node_records(const struct query_cmd *q, struct sa_handle * h,
 			      struct query_params *p, int argc, char *argv[])
 {
 	ib_node_record_t nr;
@@ -1080,7 +1081,7 @@ static int query_node_records(const struct query_cmd *q, bind_handle_t h,
 }
 
 static int query_portinfo_records(const struct query_cmd *q,
-				  bind_handle_t h, struct query_params *p,
+				  struct sa_handle * h, struct query_params *p,
 				  int argc, char *argv[])
 {
 	ib_portinfo_record_t pir;
@@ -1101,7 +1102,7 @@ static int query_portinfo_records(const struct query_cmd *q,
 }
 
 static int query_mcmember_records(const struct query_cmd *q,
-				  bind_handle_t h, struct query_params *p,
+				  struct sa_handle * h, struct query_params *p,
 				  int argc, char *argv[])
 {
 	ib_member_rec_t mr;
@@ -1132,7 +1133,7 @@ static int query_mcmember_records(const struct query_cmd *q,
 					&mr, sizeof(mr), dump_one_mcmember_record);
 }
 
-static int query_service_records(const struct query_cmd *q, bind_handle_t h,
+static int query_service_records(const struct query_cmd *q, struct sa_handle * h,
 				 struct query_params *p, int argc, char *argv[])
 {
 	return get_and_dump_all_records(h, IB_SA_ATTR_SERVICERECORD,
@@ -1140,14 +1141,14 @@ static int query_service_records(const struct query_cmd *q, bind_handle_t h,
 }
 
 static int query_informinfo_records(const struct query_cmd *q,
-				    bind_handle_t h, struct query_params *p,
+				    struct sa_handle * h, struct query_params *p,
 				    int argc, char *argv[])
 {
 	return get_and_dump_all_records(h, IB_SA_ATTR_INFORMINFORECORD,
 					dump_inform_info_record);
 }
 
-static int query_link_records(const struct query_cmd *q, bind_handle_t h,
+static int query_link_records(const struct query_cmd *q, struct sa_handle * h,
 			      struct query_params *p, int argc, char *argv[])
 {
 	ib_link_record_t lr;
@@ -1170,7 +1171,7 @@ static int query_link_records(const struct query_cmd *q, bind_handle_t h,
 					&lr, sizeof(lr), dump_one_link_record);
 }
 
-static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
+static int query_sl2vl_records(const struct query_cmd *q, struct sa_handle * h,
 			       struct query_params *p, int argc, char *argv[])
 {
 	ib_slvl_table_record_t slvl;
@@ -1190,7 +1191,7 @@ static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
 					dump_one_slvl_record);
 }
 
-static int query_vlarb_records(const struct query_cmd *q, bind_handle_t h,
+static int query_vlarb_records(const struct query_cmd *q, struct sa_handle * h,
 			       struct query_params *p, int argc, char *argv[])
 {
 	ib_vl_arb_table_record_t vlarb;
@@ -1211,7 +1212,7 @@ static int query_vlarb_records(const struct query_cmd *q, bind_handle_t h,
 }
 
 static int query_pkey_tbl_records(const struct query_cmd *q,
-				  bind_handle_t h, struct query_params *p,
+				  struct sa_handle * h, struct query_params *p,
 				  int argc, char *argv[])
 {
 	ib_pkey_table_record_t pktr;
@@ -1231,7 +1232,7 @@ static int query_pkey_tbl_records(const struct query_cmd *q,
 					dump_one_pkey_tbl_record);
 }
 
-static int query_lft_records(const struct query_cmd *q, bind_handle_t h,
+static int query_lft_records(const struct query_cmd *q, struct sa_handle * h,
 			     struct query_params *p, int argc, char *argv[])
 {
 	ib_lft_record_t lftr;
@@ -1249,7 +1250,7 @@ static int query_lft_records(const struct query_cmd *q, bind_handle_t h,
 					&lftr, sizeof(lftr), dump_one_lft_record);
 }
 
-static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
+static int query_guidinfo_records(const struct query_cmd *q, struct sa_handle * h,
 				  struct query_params *p, int argc, char *argv[])
 {
 	ib_guidinfo_record_t gir;
@@ -1268,7 +1269,7 @@ static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
 					dump_one_guidinfo_record);
 }
 
-static int query_mft_records(const struct query_cmd *q, bind_handle_t h,
+static int query_mft_records(const struct query_cmd *q, struct sa_handle * h,
 			     struct query_params *p, int argc, char *argv[])
 {
 	ib_mft_record_t mftr;
@@ -1537,7 +1538,7 @@ static int process_opt(void *context, int ch, char *optarg)
 int main(int argc, char **argv)
 {
 	char usage_args[1024];
-	bind_handle_t h;
+	struct sa_handle * h;
 	struct query_params params;
 	const struct query_cmd *q;
 	int status;
@@ -1687,7 +1688,7 @@ int main(int argc, char **argv)
 		ibdiag_show_usage();
 	}
 
-	h = sa_get_bind_handle();
+	h = sa_get_handle();
 	if (!h)
 		IBPANIC("Failed to bind to the SA");
 
@@ -1727,7 +1728,7 @@ int main(int argc, char **argv)
 
 	if (src_lid)
 		free(src_lid);
-	sa_free_bind_handle(h);
+	sa_free_handle(h);
 	close_node_name_map(node_name_map);
 	return (status);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
