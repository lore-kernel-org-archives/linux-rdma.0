From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/6 v2] [OFED] libibverbs: Support both OFED verbs and
 ibverbs
Date: Fri, 19 Aug 2011 02:47:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41B90@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch allows libibverbs to support both libibverbs API that shipped with
OFED 1.5 and the upstream libibverbs API.  This supports existing apps
that are compiled against the upstream libibverbs (ibverbs).  And in ideal
cases, an application coded to the OFED version of libibverbs (ofverbs)
would only need to be recompiled with 'CFLAGS=-DOFED_VERBS' given as a
configuration option.

Support for OFED verbs is done using macros that convert the OFED APIs to
ibverbs APIs.  In most cases, simple data casts are all that are necessary,
with XRC support being the primary exception.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
OFED should probably carry this patch for backwards compatibility purposes,
but I'm not sure that Roland will want to carry it upstream.

changes from v1:
Updated to use ibv_open_qp() for ibv_reg_xrc_rcv_qp().

 Makefile.am                       |    5 -
 include/infiniband/ofverbs-defs.h |   54 ++++++
 include/infiniband/ofverbs.h      |  360 +++++++++++++++++++++++++++++++++++++
 include/infiniband/verbs.h        |    8 +
 src/libibverbs.map                |   10 +
 src/ofverbs.c                     |  216 ++++++++++++++++++++++
 6 files changed, 651 insertions(+), 2 deletions(-)
 create mode 100644 include/infiniband/ofverbs-defs.h
 create mode 100644 include/infiniband/ofverbs.h
 create mode 100644 src/ofverbs.c

diff --git a/Makefile.am b/Makefile.am
index 99227bb..d4bc047 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,7 +10,7 @@ libibverbs_version_script = @LIBIBVERBS_VERSION_SCRIPT@
 
 src_libibverbs_la_SOURCES = src/cmd.c src/compat-1_0.c src/device.c src/init.c \
 			    src/marshall.c src/memory.c src/sysfs.c src/verbs.c \
-			    src/enum_strs.c
+			    src/enum_strs.c src/ofverbs.c
 src_libibverbs_la_LDFLAGS = -version-info 1 -export-dynamic \
     $(libibverbs_version_script)
 src_libibverbs_la_DEPENDENCIES = $(srcdir)/src/libibverbs.map
@@ -39,7 +39,8 @@ libibverbsincludedir = $(includedir)/infiniband
 
 libibverbsinclude_HEADERS = include/infiniband/arch.h include/infiniband/driver.h \
     include/infiniband/kern-abi.h include/infiniband/opcode.h include/infiniband/verbs.h \
-    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h
+    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h \
+    include/infiniband/ofverbs.h include/infiniband/ofverbs-defs.h
 
 man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_rc_pingpong.1 man/ibv_uc_pingpong.1 man/ibv_ud_pingpong.1	\
diff --git a/include/infiniband/ofverbs-defs.h b/include/infiniband/ofverbs-defs.h
new file mode 100644
index 0000000..c260006
--- /dev/null
+++ b/include/infiniband/ofverbs-defs.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2004, 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc.  All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
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
+ */
+
+#ifndef OFVERBS_DEFS_H
+#define OFVERBS_DEFS_H
+
+/*
+ * Include this file before verbs.h or at the top of verbs.h.  This will
+ * map the names of the ibv_* structures to _real_ibv_*.  The
+ * ofv_* structure names are then mapped to ibv_*.
+ */
+#ifdef OFED_VERBS
+
+#define ibv_srq			_real_ibv_srq
+#define ibv_qp			_real_ibv_qp
+#define ibv_qp_init_attr	_real_ibv_qp_init_attr
+#define ibv_send_wr		_real_ibv_send_wr
+#define ibv_async_event		_real_ibv_async_event
+
+#endif /* OFED_VERBS */
+
+#endif /* OFVERBS_DEFS_H */
diff --git a/include/infiniband/ofverbs.h b/include/infiniband/ofverbs.h
new file mode 100644
index 0000000..b03d7ae
--- /dev/null
+++ b/include/infiniband/ofverbs.h
@@ -0,0 +1,360 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2004, 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc.  All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc.  All rights reserved.
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
+ */
+
+#ifndef OFVERBS_H
+#define OFVERBS_H
+
+/*
+ * Include this file after verbs.h or at the end of verbs.h.  This will
+ * replace ibv_* structures and calls with syntax matching that shipped
+ * with the OFED version of libibverbs.
+ */
+
+#include <stdint.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <errno.h>
+
+#ifdef __cplusplus
+#  define BEGIN_C_DECLS extern "C" {
+#  define END_C_DECLS   }
+#else /* !__cplusplus */
+#  define BEGIN_C_DECLS
+#  define END_C_DECLS
+#endif /* __cplusplus */
+
+#if __GNUC__ >= 3
+#  define __attribute_const __attribute__((const))
+#else
+#  define __attribute_const
+#endif
+
+BEGIN_C_DECLS
+
+/* Unmap defines from ofverbs-defs.h */
+#if OFED_VERBS
+#undef ibv_srq
+#undef ibv_qp
+#undef ibv_qp_init_attr
+#undef ibv_send_wr
+#undef ibv_async_event
+
+#define ofv_srq			ibv_srq
+#define ofv_qp			ibv_qp
+#define ofv_qp_init_attr	ibv_qp_init_attr
+#define ofv_send_wr		ibv_send_wr
+#define ofv_async_event		ibv_async_event
+#define ofv_xrc_domain		ibv_xrc_domain
+
+#define OFV_XRC_QP_EVENT_FLAG	IBV_XRC_QP_EVENT_FLAG
+
+#else
+
+#define _real_ibv_srq		ibv_srq
+#define _real_ibv_qp		ibv_qp
+#define _real_ibv_qp_init_attr	ibv_qp_init_attr
+#define _real_ibv_send_wr	ibv_send_wr
+#define _real_ibv_async_event	ibv_async_event
+#endif /* OFED_VERBS */
+
+enum ofv_event_flags {
+	OFV_XRC_QP_EVENT_FLAG = 0x80000000,
+};
+
+struct ofv_async_event {
+	union {
+		struct ibv_cq  *cq;
+		struct ofv_qp  *qp;
+		struct ofv_srq *srq;
+		int		port_num;
+		uint32_t	xrc_qp_num;
+	} element;
+	enum ibv_event_type	event_type;
+	void                   *private;
+};
+
+int ofv_get_async_event(struct ibv_context *context,
+			struct ofv_async_event *event);
+
+void ofv_ack_async_event(struct ofv_async_event *event);
+
+struct ofv_xrc_domain {
+	struct ibv_context     *context;
+	uint32_t		handle;
+
+	struct ibv_xrcd	        *xrcd;
+	void                    *qp_tree;
+};
+
+struct ofv_xrc_domain *ofv_open_xrc_domain(struct ibv_context *context,
+					   int fd, int oflags);
+
+int ofv_close_xrc_domain(struct ofv_xrc_domain *xrcd);
+
+enum {
+	OFV_QPT_XRC = IBV_QPT_XRC_SEND
+};
+
+struct ofv_srq {
+	struct ibv_context     *context;
+	void		       *srq_context;
+	struct ibv_pd	       *pd;
+	uint32_t		handle;
+
+	pthread_mutex_t		mutex;
+	pthread_cond_t		cond;
+	uint32_t		events_completed;
+
+	enum ibv_srq_type	srq_type;
+	struct ofv_xrc_domain  *xrc_domain;
+	struct ibv_cq          *xrc_cq;
+	uint32_t	 	xrc_srq_num;
+};
+
+static inline struct ofv_srq *
+ofv_create_srq(struct ibv_pd *pd, struct ibv_srq_init_attr *srq_init_attr)
+{
+	return (struct ofv_srq *) ibv_create_srq(pd, srq_init_attr);
+}
+
+static inline struct ofv_srq *
+ofv_create_xrc_srq(struct ibv_pd *pd, struct ofv_xrc_domain *xrc_domain,
+		   struct ibv_cq *xrc_cq, struct ibv_srq_init_attr *srq_init_attr)
+{
+	srq_init_attr->srq_type = IBV_SRQT_XRC;
+	srq_init_attr->ext.xrc.xrcd = xrc_domain->xrcd;
+	srq_init_attr->ext.xrc.cq = xrc_cq;
+	return (struct ofv_srq *) ibv_create_xsrq(pd, srq_init_attr);
+}
+
+static inline int
+ofv_modify_srq(struct ofv_srq *srq, struct ibv_srq_attr *srq_attr, int srq_attr_mask)
+{
+	return ibv_modify_srq((struct _real_ibv_srq *) srq, srq_attr, srq_attr_mask);
+}
+
+static inline int ofv_query_srq(struct ofv_srq *srq, struct ibv_srq_attr *srq_attr)
+{
+	return ibv_query_srq((struct _real_ibv_srq *) srq, srq_attr);
+}
+
+static inline int ofv_destroy_srq(struct ofv_srq *srq)
+{
+	return ibv_destroy_srq((struct _real_ibv_srq *) srq);
+}
+
+static inline int ofv_post_srq_recv(struct ofv_srq *srq,
+				    struct ibv_recv_wr *recv_wr,
+				    struct ibv_recv_wr **bad_recv_wr)
+{
+	return ibv_post_srq_recv((struct _real_ibv_srq *) srq, recv_wr, bad_recv_wr);
+}
+
+struct ofv_qp_init_attr {
+	void		       *qp_context;
+	struct ibv_cq	       *send_cq;
+	struct ibv_cq	       *recv_cq;
+	struct ofv_srq	       *srq;
+	struct ibv_qp_cap	cap;
+	enum ibv_qp_type	qp_type;
+	int			sq_sig_all;
+
+	struct ofv_xrc_domain  *xrc_domain;
+};
+
+struct ofv_qp {
+	struct ibv_context     *context;
+	void		       *qp_context;
+	struct ibv_pd	       *pd;
+	struct ibv_cq	       *send_cq;
+	struct ibv_cq	       *recv_cq;
+	struct ofv_srq	       *srq;
+	uint32_t		handle;
+	uint32_t		qp_num;
+	enum ibv_qp_state       state;
+	enum ibv_qp_type	qp_type;
+
+	pthread_mutex_t		mutex;
+	pthread_cond_t		cond;
+	uint32_t		events_completed;
+
+	struct ofv_xrc_domain  *xrc_domain;
+};
+
+static inline struct ofv_qp *
+ofv_create_qp(struct ibv_pd *pd, struct ofv_qp_init_attr *qp_init_attr)
+{
+	return (struct ofv_qp *)
+		ibv_create_qp(pd, (struct _real_ibv_qp_init_attr *) qp_init_attr);
+}
+
+static inline int ofv_modify_qp(struct ofv_qp *qp, struct ibv_qp_attr *attr,
+				int attr_mask)
+{
+	return ibv_modify_qp((struct _real_ibv_qp *) qp, attr, attr_mask);
+}
+
+static inline int ofv_query_qp(struct ofv_qp *qp, struct ibv_qp_attr *attr,
+			       int attr_mask, struct ofv_qp_init_attr *init_attr)
+{
+	return ibv_query_qp((struct _real_ibv_qp *) qp, attr, attr_mask,
+			    (struct _real_ibv_qp_init_attr *) init_attr);
+}
+
+
+static inline int ofv_destroy_qp(struct ofv_qp *qp)
+{
+	return ibv_destroy_qp((struct _real_ibv_qp *) qp);
+}
+
+struct ofv_send_wr {
+	uint64_t		wr_id;
+	struct ibv_send_wr     *next;
+	struct ibv_sge	       *sg_list;
+	int			num_sge;
+	enum ibv_wr_opcode	opcode;
+	int			send_flags;
+	uint32_t		imm_data;	/* in network byte order */
+	union {
+		union {
+			struct {
+				uint64_t	remote_addr;
+				uint32_t	rkey;
+			} rdma;
+			struct {
+				uint64_t	remote_addr;
+				uint64_t	compare_add;
+				uint64_t	swap;
+				uint32_t	rkey;
+			} atomic;
+			struct {
+				struct ibv_ah  *ah;
+				uint32_t	remote_qpn;
+				uint32_t	remote_qkey;
+			} ud;
+			struct {
+				uint64_t	reserved[3];
+				uint32_t	reserved2;
+				uint32_t	remote_srqn;
+			} xrc;
+		} wr;
+		struct {
+			uint64_t	reserved[3];
+			uint32_t	reserved2;
+			uint32_t	xrc_remote_srq_num;
+		};
+	};
+};
+
+static inline int ofv_post_send(struct ofv_qp *qp, struct ofv_send_wr *wr,
+				struct ofv_send_wr **bad_wr)
+{
+	return ibv_post_send((struct _real_ibv_qp *) qp, (struct _real_ibv_send_wr *) wr,
+			     (struct _real_ibv_send_wr **) bad_wr);
+}
+
+static inline int ofv_post_recv(struct ofv_qp *qp, struct ibv_recv_wr *wr,
+				struct ibv_recv_wr **bad_wr)
+{
+	return ibv_post_recv((struct _real_ibv_qp *) qp, wr, bad_wr);
+}
+
+static inline int ofv_attach_mcast(struct ofv_qp *qp, const union ibv_gid *gid,
+				   uint16_t lid)
+{
+	return ibv_attach_mcast((struct _real_ibv_qp *) qp, gid, lid);
+}
+
+static inline int ofv_detach_mcast(struct ofv_qp *qp, const union ibv_gid *gid,
+				   uint16_t lid)
+{
+	return ibv_detach_mcast((struct _real_ibv_qp *) qp, gid, lid);
+}
+
+int ofv_create_xrc_rcv_qp(struct ofv_qp_init_attr *init_attr, uint32_t *xrc_rcv_qpn);
+
+int ofv_modify_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain,
+			  uint32_t xrc_qp_num,
+			  struct ibv_qp_attr *attr, int attr_mask);
+
+int ofv_query_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain,
+			 uint32_t xrc_qp_num,
+			 struct ibv_qp_attr *attr, int attr_mask,
+			 struct ofv_qp_init_attr *init_attr);
+
+int ofv_reg_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain, uint32_t xrc_qp_num);
+
+int ofv_unreg_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain, uint32_t xrc_qp_num);
+
+/*
+ * Map the ibv_* calls to OFED verbs versions.
+ */
+#ifdef OFED_VERBS
+#define ibv_get_async_event(c,e)	ofv_get_async_event(c,e)
+#define ibv_ack_async_event(e)		ofv_ack_async_event(e)
+
+#define ibv_open_xrc_domain(c,f,g)	ofv_open_xrc_domain(c,f,g)
+#define ibv_close_xrc_domain(d)		ofv_close_xrc_domain(d)
+
+#define ibv_create_srq(p,a)		ofv_create_srq(p,a)
+#define ibv_create_xrc_srq(p,d,c,a)	ofv_create_xrc_srq(p,d,c,a)
+#define ibv_modify_srq(s,a,m)		ofv_modify_srq(s,a,m)
+#define ibv_query_srq(s,a)		ofv_query_srq(s,a)
+#define ibv_destroy_srq(s)		ofv_destroy_srq(s)
+#define ibv_post_srq_recv(s,w,b)	ofv_post_srq_recv(s,w,b)
+
+#define IBV_QPT_XRC 			((enum ibv_qp_type) OFV_QPT_XRC)
+#define ibv_create_qp(p,a)		ofv_create_qp(p,a)
+#define ibv_query_qp(q,a,m,i)		ofv_query_qp(p,a,m,i)
+#define ibv_modify_qp(q,a,m)		ofv_modify_qp(q,a,m)
+#define ibv_query_qp(q,a,m,i)		ofv_query_qp(q,a,m,i)
+#define ibv_destroy_qp(q)		ofv_destroy_qp(q)
+#define ibv_post_send(q,w,b)		ofv_post_send(q,w,b)
+#define ibv_post_recv(q,w,b)		ofv_post_recv(q,w,b)
+#define ibv_attach_mcast(q,g,l)		ofv_attach_mcast(q,g,l)
+#define ibv_detach_mcast(q,g,l)		ofv_detach_mcast(q,g,l)
+
+#define ibv_create_xrc_rcv_qp(a,q)	ofv_create_xrc_rcv_qp(a,q)
+#define ibv_modify_xrc_rcv_qp(d,q,a,m)	ofv_modify_xrc_rcv_qp(d,q,a,m)
+#define ibv_query_xrc_rcv_qp(d,q,a,m,i)	ofv_query_xrc_rcv_qp(d,q,a,m,i)
+#define ibv_reg_xrc_rcv_qp(d,q)		ofv_reg_xrc_rcv_qp(d,q)
+#define ibv_unreg_xrc_rcv_qp(d,q)	ofv_unreg_xrc_rcv_qp(d,q)
+#endif /* OFED_VERBS */
+
+END_C_DECLS
+
+#  undef __attribute_const
+
+#endif /* OFVERBS_H */
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 81077d8..4914728 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -39,6 +39,10 @@
 #include <stdint.h>
 #include <pthread.h>
 
+#ifdef OFED_VERBS
+#include <infiniband/ofverbs-defs.h>
+#endif /* OFED_VERBS */
+
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
 #  define END_C_DECLS   }
@@ -1221,4 +1225,8 @@ END_C_DECLS
 
 #  undef __attribute_const
 
+#ifdef OFED_VERBS
+#include <infiniband/ofverbs.h>
+#endif /* OFED_VERBS */
+
 #endif /* INFINIBAND_VERBS_H */
diff --git a/src/libibverbs.map b/src/libibverbs.map
index efd6712..558bc69 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -110,4 +110,14 @@ IBVERBS_1.1 {
 		ibv_create_xsrq;
 		ibv_cmd_open_qp;
 		ibv_open_qp;
+
+		ofv_get_async_event;
+		ofv_ack_async_event;
+		ofv_open_xrc_domain;
+		ofv_close_xrc_domain;
+		ofv_create_xrc_rcv_qp;
+		ofv_modify_xrc_rcv_qp;
+		ofv_query_xrc_rcv_qp;
+		ofv_reg_xrc_rcv_qp;
+		ofv_unreg_xrc_rcv_qp;
 } IBVERBS_1.0;
diff --git a/src/ofverbs.c b/src/ofverbs.c
new file mode 100644
index 0000000..3eba02c
--- /dev/null
+++ b/src/ofverbs.c
@@ -0,0 +1,216 @@
+/*
+ * Copyright (c) 2011 Intel Corporation, Inc.  All rights reserved.
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
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif /* HAVE_CONFIG_H */
+
+#include <stdint.h>
+#include <search.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <errno.h>
+
+#include <infiniband/ofverbs-defs.h>
+#include <infiniband/verbs.h>
+#include <infiniband/ofverbs.h>
+#include "ibverbs.h"
+
+int __ofv_get_async_event(struct ibv_context *context,
+			  struct ofv_async_event *event)
+{
+	int ret;
+
+	ret = ibv_get_async_event(context, (struct ibv_async_event *) event);
+	if (!ret) {
+		switch (event->event_type) {
+		case IBV_EVENT_QP_FATAL:
+		case IBV_EVENT_QP_REQ_ERR:
+		case IBV_EVENT_QP_ACCESS_ERR:
+		case IBV_EVENT_COMM_EST:
+		case IBV_EVENT_PATH_MIG:
+		case IBV_EVENT_PATH_MIG_ERR:
+		case IBV_EVENT_QP_LAST_WQE_REACHED:
+			if (event->element.qp->qp_type == IBV_QPT_XRC_RECV) {
+				event->private = event->element.qp;
+				event->event_type |= OFV_XRC_QP_EVENT_FLAG;
+				event->element.xrc_qp_num = event->element.qp->qp_num;
+			}
+		default:
+			break;
+		}
+	}
+	return ret;
+}
+default_symver(__ofv_get_async_event, ofv_get_async_event);
+
+void ofv_ack_async_event(struct ofv_async_event *event)
+{
+	if (event->event_type & OFV_XRC_QP_EVENT_FLAG)
+		event->element.qp = event->private;
+	ibv_ack_async_event((struct ibv_async_event *) event);
+}
+default_symver(__ofv_ack_async_event, ofv_ack_async_event);
+
+struct ofv_xrc_domain *
+__ofv_open_xrc_domain(struct ibv_context *context, int fd, int oflags)
+{
+	struct ofv_xrc_domain *xrcd;
+
+	xrcd = calloc(1, sizeof *xrcd);
+	if (!xrcd)
+		return NULL;
+
+	xrcd->xrcd = ibv_open_xrcd(context, fd, oflags);
+	if (!xrcd->xrcd) {
+		free(xrcd);
+		return NULL;
+	}
+
+	xrcd->context = context;
+	xrcd->handle = xrcd->xrcd->handle;
+	return xrcd;
+}
+default_symver(__ofv_open_xrc_domain, ofv_open_xrc_domain);
+
+static void ofv_free_node(void *node)
+{
+}
+
+int __ofv_close_xrc_domain(struct ofv_xrc_domain *xrcd)
+{
+	int ret;
+
+	ret = ibv_close_xrcd(xrcd->xrcd);
+	if (ret)
+		return ret;
+
+	tdestroy(xrcd->qp_tree, ofv_free_node);
+	free(xrcd);
+	return 0;
+}
+default_symver(__ofv_close_xrc_domain, ofv_close_xrc_domain);
+
+static int ofv_qp_compare(const void *a, const void *b)
+{
+	if ((*(uint32_t *) a) < (*(uint32_t *) b))
+		return -1;
+	else if ((*(uint32_t *) a) > (*(uint32_t *) b))
+		return 1;
+	else
+		return 0;
+}
+
+int __ofv_create_xrc_rcv_qp(struct ofv_qp_init_attr *init_attr, uint32_t *xrc_rcv_qpn)
+{
+	struct ofv_xrc_domain *xrcd;
+	struct ibv_qp *qp;
+
+	xrcd = init_attr->xrc_domain;
+	init_attr->qp_type = IBV_QPT_XRC_RECV;
+	((struct ibv_qp_init_attr *) init_attr)->ext.xrc_recv.xrcd = xrcd->xrcd;
+	qp = ibv_create_qp(NULL, (struct ibv_qp_init_attr *) init_attr);
+	init_attr->xrc_domain = xrcd;
+	if (!qp)
+		return ENOMEM;
+
+	tsearch(&qp->qp_num, &xrcd->qp_tree, ofv_qp_compare);
+	*xrc_rcv_qpn = qp->qp_num;
+	return 0;
+}
+default_symver(__ofv_create_xrc_rcv_qp, ofv_create_xrc_rcv_qp);
+
+int __ofv_modify_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain,
+			  uint32_t xrc_qp_num,
+			  struct ibv_qp_attr *attr, int attr_mask)
+{
+	struct ibv_qp *qp;
+	uint32_t **qpn;
+
+	qpn = tfind(&xrc_qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	if (!qpn)
+		return EINVAL;
+
+	qp = ((struct ibv_qp *) ((void *) *qpn - offsetof(struct ibv_qp, qp_num)));
+	return ibv_modify_qp(qp, attr, attr_mask);
+}
+default_symver(__ofv_modify_xrc_rcv_qp, ofv_modify_xrc_rcv_qp);
+
+int __ofv_query_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain,
+			 uint32_t xrc_qp_num,
+			 struct ibv_qp_attr *attr, int attr_mask,
+			 struct ofv_qp_init_attr *init_attr)
+{
+	struct ibv_qp *qp;
+	uint32_t **qpn;
+
+	qpn = tfind(&xrc_qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	if (!qpn)
+		return EINVAL;
+
+	qp = ((struct ibv_qp *) ((void *) *qpn - offsetof(struct ibv_qp, qp_num)));
+	return ibv_query_qp(qp, attr, attr_mask,
+			    (struct ibv_qp_init_attr *) init_attr);
+}
+default_symver(__ofv_query_xrc_rcv_qp, ofv_query_xrc_rcv_qp);
+
+int ofv_reg_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain, uint32_t xrc_qp_num)
+{
+	struct ibv_qp *qp;
+	struct ibv_qp_open_attr attr;
+
+	attr.qp_context = xrc_domain;
+	attr.qp_num = xrc_qp_num;
+	attr.qp_type = IBV_QPT_XRC_RECV;
+
+	qp = ibv_open_qp(xrc_domain->xrcd, &attr);
+	if (!qp)
+		return ENOMEM;
+
+	tsearch(&qp->qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	return 0;
+}
+default_symver(__ofv_reg_xrc_rcv_qp, ofv_reg_xrc_rcv_qp);
+
+int ofv_unreg_xrc_rcv_qp(struct ofv_xrc_domain *xrc_domain, uint32_t xrc_qp_num)
+{
+	struct ibv_qp *qp;
+	uint32_t **qpn;
+
+	qpn = tfind(&xrc_qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	if (!qpn)
+		return EINVAL;
+
+	qp = ((struct ibv_qp *) ((void *) *qpn - offsetof(struct ibv_qp, qp_num)));
+	return ibv_destroy_qp(qp);
+}
+default_symver(__ofv_unreg_xrc_rcv_qp, ofv_unreg_xrc_rcv_qp);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
