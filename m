From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [OFED] libibverbs: Translate OFED verbs to ibverbs
Date: Thu, 23 Jun 2011 00:45:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029C29@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here's a hack that attempts to translate the libibverbs API that shippe=
d with
OFED 1.5 to the upstream libibverbs API.  This would support existing a=
pps
that are compiled against the upstream libibverbs (ibverbs).  Applicati=
ons
that are coded to the OFED version of libibverbs (ofverbs) would need t=
o be
recompiled.

The idea is that a single version of libibverbs would support
both ibverbs and ofverbs via macro magic, with full compatibility with
ibverbs.  An app would need to be compiled with CFLAGS=3D-DOFED_VERBS t=
o
pick up the ofverbs.

This doesn't quite work seamlessly.  I downloaded mvapich2 and built it
with the following options:

--with-rdma=3Dgen2 -CFLAGS=3D-DOFED_VERBS

This failed with
=2E../reg_cache/avl.h:42: error: conflicting types for VISIT
/usr/include/search.h:126: note: previous declaration of VISIT was here

This can probably be worked around by moving the use of search.h into
an ofed-verbs.c file and exporting ofv_open_xrcd().  (I tried to minimi=
ze
the impact to the upstream libibverbs, hoping it would help make this
more acceptable for merging.)

Building with:

--with-rdma=3Dgen2 -CFLAGS=3D-DOFED_VERBS -CFLAGS=3D-D_ENABLE_XRC_

fails with
ch3_progress.c: In function =E2cm_send_pending_1sc_msg=E2:
ch3_progress.c:877: error: =E2struct ibv_send_wr=E2 has no member
named =E2xrc_remote_srq_num=E2

The macro magic failed, I suspect because mvapich defined a macro that
made use of ibv_send_wr before including verbs.h, but I got lost in
the mvapich code trying to track this down.

Anyway, the approach at least seems somewhat possible.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 Makefile.am                     |    3=20
 include/infiniband/ofed-verbs.h |  409 +++++++++++++++++++++++++++++++=
++++++++
 include/infiniband/verbs.h      |    4=20
 3 files changed, 415 insertions(+), 1 deletions(-)
 create mode 100644 include/infiniband/ofed-verbs.h

diff --git a/Makefile.am b/Makefile.am
index 4702a2b..c59f1ef 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,7 +37,8 @@ libibverbsincludedir =3D $(includedir)/infiniband
=20
 libibverbsinclude_HEADERS =3D include/infiniband/arch.h include/infini=
band/driver.h \
     include/infiniband/kern-abi.h include/infiniband/opcode.h include/=
infiniband/verbs.h \
-    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/i=
nfiniband/marshall.h
+    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/i=
nfiniband/marshall.h \
+    include/infiniband/ofed-verbs.h
=20
 man_MANS =3D man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	=
\
     man/ibv_rc_pingpong.1 man/ibv_uc_pingpong.1 man/ibv_ud_pingpong.1	=
\
diff --git a/include/infiniband/ofed-verbs.h b/include/infiniband/ofed-=
verbs.h
new file mode 100644
index 0000000..08b590e
--- /dev/null
+++ b/include/infiniband/ofed-verbs.h
@@ -0,0 +1,409 @@
+/*
+ * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserv=
ed.
+ * Copyright (c) 2004, 2011 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc.  All rights rese=
rved.
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
+#ifndef OFED_VERBS_H
+#define OFED_VERBS_H
+
+#include <stdint.h>
+#include <search.h>
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
+#if __GNUC__ >=3D 3
+#  define __attribute_const __attribute__((const))
+#else
+#  define __attribute_const
+#endif
+
+BEGIN_C_DECLS
+
+enum ofv_event_flags {
+	OFV_XRC_QP_EVENT_FLAG =3D 0x80000000,
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
+};
+
+struct ofv_xrcd {
+	struct ibv_context     *context;
+	uint32_t		handle;
+
+	struct ibv_xrcd	        *xrcd;
+	void                    *qp_tree;
+};
+
+static inline struct ofv_xrcd *
+ofv_open_xrcd(struct ibv_context *context, int fd, int oflags)
+{
+	struct ofv_xrcd *xrcd;
+
+	xrcd =3D calloc(1, sizeof *xrcd);
+	if (!xrcd)
+		return NULL;
+
+	xrcd->xrcd =3D ibv_open_xrcd(context, fd, oflags);
+	if (!xrcd->xrcd) {
+		free(xrcd);
+		return NULL;
+	}
+
+	xrcd->context =3D context;
+	xrcd->handle =3D xrcd->xrcd->handle;
+	return xrcd;
+}
+
+static void ofv_free_node(void *node)
+{
+}
+
+static inline int ofv_close_xrcd(struct ofv_xrcd *xrcd)
+{
+	int ret;
+
+	ret =3D ibv_close_xrcd(xrcd->xrcd);
+	if (ret)
+		return ret;
+
+	tdestroy(xrcd->qp_tree, ofv_free_node);
+	free(xrcd);
+	return 0;
+}
+
+enum {
+	OFV_QPT_XRC =3D IBV_QPT_XRC_SEND
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
+	struct ofv_xrcd        *xrc_domain;
+	struct ibv_cq          *xrc_cq;
+	uint32_t	 	xrc_srq_num;
+};
+
+static inline struct ofv_srq *
+ofv_create_srq(struct ibv_pd *pd, struct ibv_srq_init_attr *srq_init_a=
ttr)
+{
+	return (struct ofv_srq *) ibv_create_srq(pd, srq_init_attr);
+}
+
+static inline struct ofv_srq *
+ofv_create_xrc_srq(struct ibv_pd *pd, struct ofv_xrcd *xrc_domain,
+		   struct ibv_cq *xrc_cq, struct ibv_srq_init_attr *srq_init_attr)
+{
+	srq_init_attr->srq_type =3D IBV_SRQT_XRC;
+	srq_init_attr->ext.xrc.xrcd =3D xrc_domain->xrcd;
+	srq_init_attr->ext.xrc.cq =3D xrc_cq;
+	return (struct ofv_srq *) ibv_create_xsrq(pd, srq_init_attr);
+}
+
+static inline int
+ofv_modify_srq(struct ofv_srq *srq, struct ibv_srq_attr *srq_attr, int=
 srq_attr_mask)
+{
+	return ibv_modify_srq((struct ibv_srq *) srq, srq_attr, srq_attr_mask=
);
+}
+
+static inline int ofv_query_srq(struct ofv_srq *srq, struct ibv_srq_at=
tr *srq_attr)
+{
+	return ibv_query_srq((struct ibv_srq *) srq, srq_attr);
+}
+
+static inline int ofv_destroy_srq(struct ofv_srq *srq)
+{
+	return ibv_destroy_srq((struct ibv_srq *) srq);
+}
+
+static inline int ofv_post_srq_recv(struct ofv_srq *srq,
+				    struct ibv_recv_wr *recv_wr,
+				    struct ibv_recv_wr **bad_recv_wr)
+{
+	return ibv_post_srq_recv((struct ibv_srq *) srq, recv_wr, bad_recv_wr=
);
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
+	struct ofv_xrcd        *xrc_domain;
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
+	struct ofv_xrcd        *xrc_domain;
+};
+
+static inline struct ofv_qp *
+ofv_create_qp(struct ibv_pd *pd, struct ofv_qp_init_attr *qp_init_attr=
)
+{
+	return (struct ofv_qp *)
+		ibv_create_qp(pd, (struct ibv_qp_init_attr *) qp_init_attr);
+}
+
+static inline int ofv_modify_qp(struct ofv_qp *qp, struct ibv_qp_attr =
*attr,
+				int attr_mask)
+{
+	return ibv_modify_qp((struct ibv_qp *) qp, attr, attr_mask);
+}
+
+static inline int ofv_query_qp(struct ofv_qp *qp, struct ibv_qp_attr *=
attr,
+			       int attr_mask, struct ofv_qp_init_attr *init_attr)
+{
+	return ibv_query_qp((struct ibv_qp *) qp, attr, attr_mask,
+			    (struct ibv_qp_init_attr *) init_attr);
+}
+
+
+static inline int ofv_destroy_qp(struct ofv_qp *qp)
+{
+	return ibv_destroy_qp((struct ibv_qp *) qp);
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
+static inline int ofv_post_send(struct ofv_qp *qp, struct ofv_send_wr =
*wr,
+				struct ofv_send_wr **bad_wr)
+{
+	return ibv_post_send((struct ibv_qp *) qp, (struct ibv_send_wr *) wr,
+			     (struct ibv_send_wr **) bad_wr);
+}
+
+static inline int ofv_post_recv(struct ofv_qp *qp, struct ibv_recv_wr =
*wr,
+				struct ibv_recv_wr **bad_wr)
+{
+	return ibv_post_recv((struct ibv_qp *) qp, wr, bad_wr);
+}
+
+static inline int ofv_attach_mcast(struct ofv_qp *qp, const union ibv_=
gid *gid,
+				   uint16_t lid)
+{
+	return ibv_attach_mcast((struct ibv_qp *) qp, gid, lid);
+}
+
+static inline int ofv_detach_mcast(struct ofv_qp *qp, const union ibv_=
gid *gid,
+				   uint16_t lid)
+{
+	return ibv_detach_mcast((struct ibv_qp *) qp, gid, lid);
+}
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
+static inline int ofv_create_xrc_rcv_qp(struct ofv_qp_init_attr *init_=
attr,
+					uint32_t *xrc_rcv_qpn)
+{
+	struct ofv_xrcd *xrcd;
+	struct ibv_qp *qp;
+
+	xrcd =3D init_attr->xrc_domain;
+	init_attr->qp_type =3D IBV_QPT_XRC_RECV;
+	((struct ibv_qp_init_attr *) init_attr)->ext.xrc_recv.xrcd =3D xrcd->=
xrcd;
+	qp =3D ibv_create_qp(NULL, (struct ibv_qp_init_attr *) init_attr);
+	init_attr->xrc_domain =3D xrcd;
+	if (!qp)
+		return ENOMEM;
+
+	tsearch(&qp->qp_num, &xrcd->qp_tree, ofv_qp_compare);
+	*xrc_rcv_qpn =3D qp->qp_num;
+	return 0;
+}
+
+static inline int ofv_modify_xrc_rcv_qp(struct ofv_xrcd *xrc_domain,
+					uint32_t xrc_qp_num,
+					struct ibv_qp_attr *attr, int attr_mask)
+{
+	struct ibv_qp *qp;
+	uint32_t *qpn;
+
+	qpn =3D tfind(&xrc_qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	if (!qpn)
+		return EINVAL;
+
+	qp =3D ((struct ibv_qp *) ((void *) qpn - offsetof(struct ibv_qp, qp_=
num)));
+	return ibv_modify_qp(qp, attr, attr_mask);
+}
+
+static inline int ofv_query_xrc_rcv_qp(struct ofv_xrcd *xrc_domain,
+				       uint32_t xrc_qp_num,
+				       struct ibv_qp_attr *attr, int attr_mask,
+				       struct ofv_qp_init_attr *init_attr)
+{
+	struct ibv_qp *qp;
+	uint32_t *qpn;
+
+	qpn =3D tfind(&xrc_qp_num, &xrc_domain->qp_tree, ofv_qp_compare);
+	if (!qpn)
+		return EINVAL;
+
+	qp =3D ((struct ibv_qp *) ((void *) qpn - offsetof(struct ibv_qp, qp_=
num)));
+	return ibv_query_qp(qp, attr, attr_mask,
+			    (struct ibv_qp_init_attr *) init_attr);
+}
+
+/*
+ * If OFED_VERBS is defined, then we map ibverbs definitions to ofverb=
s.
+ * This should allow us to support apps written to ofverbs.
+ * Note that the user must include verbs.h before including this file.
+ */
+#ifdef OFED_VERBS
+#define ibv_open_xrc_domain(c,f,g)	ofv_open_xrcd(c,f,g)
+#define ibv_close_xrc_domain(d)		ofv_close_xrcd(d)
+#define ibv_xrc_domain			ofv_xrcd
+
+#define ibv_srq				ofv_srq
+#define ibv_create_srq(p,a)		ofv_create_srq(p,a)
+#define ibv_create_xrc_srq(p,d,c,a)	ofv_create_xrc_srq(p,d,c,a)
+#define ibv_modify_srq(s,a,m)		ofv_modify_srq(s,a,m)
+#define ibv_query_srq(s,a)		ofv_query_srq(s,a)
+#define ibv_destroy_srq(s)		ofv_destroy_srq(s)
+#define ibv_post_srq_recv(s,w,b)	ofv_post_srq_recv(s,w,b)
+
+#define IBV_QPT_XRC 			((enum ibv_qp_type) OFV_QPT_XRC)
+#define ibv_qp				ofv_qp
+#define ibv_qp_init_attr		ofv_qp_init_attr
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
+#define ibv_create_xrc_rcv_qp		ofv_create_xrc_rcv_qp
+#define ibv_modify_xrc_rcv_qp		ofv_modify_xrc_rcv_qp
+#define ibv_query_xrc_rcv_qp		ofv_query_xrc_rcv_qp
+#define ibv_reg_xrc_rcv_qp(d,q)		0
+#define ibv_unreg_xrc_rcv_qp(d,q)	0
+
+#define ibv_send_wr			ofv_send_wr
+#define ofa_event_flags			ibv_event_flags
+#define OFV_XRC_QP_EVENT_FLAG		IBV_XRC_QP_EVENT_FLAG
+#define ofa_async_event			ibv_async_event
+#endif /* OFED_VERBS */
+
+END_C_DECLS
+
+#  undef __attribute_const
+
+#endif /* OFED_VERBS_H */
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 183d171..d513d1f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1206,4 +1206,8 @@ END_C_DECLS
=20
 #  undef __attribute_const
=20
+#ifdef OFED_VERBS
+#include <infiniband/ofed-verbs.h>
+#endif /* OFED_VERBS */
+
 #endif /* INFINIBAND_VERBS_H */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
