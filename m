From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] libibverbs: Support older providers that do not support
 extensions
Date: Thu, 20 Sep 2012 21:43:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E7F3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to support providers that do not handle extensions, including
providers built against an older version of ibverbs, add a compatibility
layer.  This allows most of the core ibverbs code to assume that
extensions are always available.  The compatibility layer is responsible
for converting between the extended verbs and the current structure
definitions.

The compatibility layer allows applications to make use of extended
structures, independent of the provider supporting them, and allows us
to extend existing structures which are normally allocated by the
provider: ibv_qp, ibv_srq, ibv_ah, ibv_mr, ibv_cq, ibv_pd, ibv_mw,
and ibv_comp_channel.  Existing applications are unaffected.

The compatibility layer is similar to the 1.0 compat code.  It allocates
the extended structures, which then point to the ones allocated by the
provider.  For the most part, the compatibility code is invoked by
directing the ibv_context ops into a compat function, which then redirects
the call to the provider.  This results in one extra level of indirection
when running with a provider that does not support extensions.

The exceptions to the indirection are opening and closing a device and
handling asynchronous events.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am                |    2 
 include/infiniband/verbs.h |   57 ++++-
 src/compat-ex.c            |  511 ++++++++++++++++++++++++++++++++++++++++++++
 src/device.c               |  112 +++++-----
 src/ibverbs.h              |   29 ++
 src/verbs.c                |    9 +
 6 files changed, 655 insertions(+), 65 deletions(-)
 create mode 100644 src/compat-ex.c

diff --git a/Makefile.am b/Makefile.am
index cd00a65..1cfb008 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,7 +11,7 @@ libibverbs_version_script = @LIBIBVERBS_VERSION_SCRIPT@
 
 src_libibverbs_la_SOURCES = src/cmd.c src/compat-1_0.c src/device.c src/init.c \
 			    src/marshall.c src/memory.c src/sysfs.c src/verbs.c \
-			    src/enum_strs.c
+			    src/enum_strs.c src/compat-ex.c
 src_libibverbs_la_LDFLAGS = -version-info 1 -export-dynamic \
     $(libibverbs_version_script)
 src_libibverbs_la_DEPENDENCIES = $(srcdir)/src/libibverbs.map
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index a2577d8..f3cb2fc 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -307,9 +307,14 @@ enum ibv_access_flags {
 	IBV_ACCESS_MW_BIND		= (1<<4)
 };
 
+enum ibv_pd_mask {
+	IBV_PD_RESERVED 		= 1 << 0
+};
+
 struct ibv_pd {
 	struct ibv_context     *context;
 	uint32_t		handle;
+	uint32_t		comp_mask;
 };
 
 enum ibv_rereg_mr_flags {
@@ -319,6 +324,10 @@ enum ibv_rereg_mr_flags {
 	IBV_REREG_MR_KEEP_VALID		= (1 << 3)
 };
 
+enum ibv_mr_mask {
+	IBV_MR_RESERVED			= 1 << 0
+};
+
 struct ibv_mr {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
@@ -327,6 +336,7 @@ struct ibv_mr {
 	uint32_t		handle;
 	uint32_t		lkey;
 	uint32_t		rkey;
+	uint32_t		comp_mask;
 };
 
 enum ibv_mw_type {
@@ -334,10 +344,15 @@ enum ibv_mw_type {
 	IBV_MW_TYPE_2			= 2
 };
 
+enum ibv_mw_mask {
+	IBV_MW_RESERVED			= 1 << 0
+};
+
 struct ibv_mw {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
 	uint32_t		rkey;
+	uint32_t		comp_mask;
 };
 
 struct ibv_global_route {
@@ -568,6 +583,10 @@ struct ibv_mw_bind {
 	int			mw_access_flags;
 };
 
+enum ibv_srq_mask {
+	IBV_SRQ_RESERVED		= 1 << 0
+};
+
 struct ibv_srq {
 	struct ibv_context     *context;
 	void		       *srq_context;
@@ -577,6 +596,12 @@ struct ibv_srq {
 	pthread_mutex_t		mutex;
 	pthread_cond_t		cond;
 	uint32_t		events_completed;
+
+	uint32_t		comp_mask;
+};
+
+enum ibv_qp_mask {
+	IBV_QP_RESERVED			= 1 << 0
 };
 
 struct ibv_qp {
@@ -594,12 +619,24 @@ struct ibv_qp {
 	pthread_mutex_t		mutex;
 	pthread_cond_t		cond;
 	uint32_t		events_completed;
+
+	uint32_t		comp_mask;
+};
+
+enum ibv_comp_channel_mask {
+	IBV_COMP_CHANNEL_RESERVED	= 1 << 0
 };
 
 struct ibv_comp_channel {
 	struct ibv_context     *context;
 	int			fd;
 	int			refcnt;
+
+	uint32_t		comp_mask;
+};
+
+enum ibv_cq_mask {
+	IBV_CQ_RESERVED			= 1 << 0
 };
 
 struct ibv_cq {
@@ -613,16 +650,25 @@ struct ibv_cq {
 	pthread_cond_t		cond;
 	uint32_t		comp_events_completed;
 	uint32_t		async_events_completed;
+
+	uint32_t		comp_mask;
+};
+
+enum ibv_ah_mask {
+	IBV_AH_RESERVED			= 1 << 0
 };
 
 struct ibv_ah {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
 	uint32_t		handle;
+
+	uint32_t		comp_mask;
 };
 
 struct ibv_device;
 struct ibv_context;
+struct verbs_context;
 
 struct ibv_device_ops {
 	struct ibv_context *	(*alloc_context)(struct ibv_device *device, int cmd_fd);
@@ -655,7 +701,7 @@ struct verbs_device {
 	int	(*init_context)(struct verbs_device *device,
 				struct ibv_context *ctx, int cmd_fd);
 	void	(*uninit_context)(struct verbs_device *device,
-				struct ibv_context *ctx);
+				  struct ibv_context *ctx);
 	/* future fields added here */
 };
 
@@ -739,17 +785,12 @@ struct verbs_context {
 	struct ibv_context context;/* Must be last field in the struct */
 };
 
-static inline struct verbs_context *verbs_get_ctx(
-					const struct ibv_context *ctx)
+static inline struct verbs_context *verbs_get_ctx(const struct ibv_context *ctx)
 {
-	if (ctx->abi_compat != ((uint8_t *)NULL)-1)
-		return NULL;
-
 	return container_of(ctx, struct verbs_context, context);
 }
 
-static inline struct verbs_device *verbs_get_device(
-					const struct ibv_device *dev)
+static inline struct verbs_device *verbs_get_device(const struct ibv_device *dev)
 {
 	return container_of(dev, struct verbs_device, device);
 }
diff --git a/src/compat-ex.c b/src/compat-ex.c
new file mode 100644
index 0000000..d335d70
--- /dev/null
+++ b/src/compat-ex.c
@@ -0,0 +1,511 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc.  All rights reserved.
+ * Copyright (c) 2012 Intel Corp., Inc.  All rights reserved.
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
+#include <string.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <alloca.h>
+
+#include "ibverbs.h"
+
+struct _ibv_pd_ex {
+	struct ibv_pd  pd;
+	struct ibv_pd *real_pd;
+};
+
+struct _ibv_mr_ex {
+	struct ibv_mr  mr;
+	struct ibv_mr *real_mr;
+};
+
+struct _ibv_srq_ex {
+	struct ibv_srq  srq;
+	struct ibv_srq *real_srq;
+};
+
+struct _ibv_qp_ex {
+	struct ibv_qp  qp;
+	struct ibv_qp *real_qp;
+};
+
+struct _ibv_cq_ex {
+	struct ibv_cq  cq;
+	struct ibv_cq *real_cq;
+};
+
+struct _ibv_ah_ex {
+	struct ibv_ah  ah;
+	struct ibv_ah *real_ah;
+};
+
+struct ibv_context *_ibv_real_context(struct ibv_context *context)
+{
+	struct verbs_context_private *priv_ctx = ibv_private_context(context);
+	return priv_ctx->real_context;
+}
+
+struct ibv_srq *_ibv_real_srq(struct ibv_srq *srq)
+{
+	struct _ibv_srq_ex *srq_ex;
+
+	if (ibv_support_ex(srq->context))
+		return srq;
+
+	srq_ex = container_of(srq, struct _ibv_srq_ex, srq);
+	return srq_ex->real_srq;
+}
+
+struct ibv_qp *_ibv_real_qp(struct ibv_qp *qp)
+{
+	struct _ibv_qp_ex *qp_ex;
+
+	if (ibv_support_ex(qp->context))
+		return qp;
+
+	qp_ex = container_of(qp, struct _ibv_qp_ex, qp);
+	return qp_ex->real_qp;
+}
+
+struct ibv_cq *_ibv_real_cq(struct ibv_cq *cq)
+{
+	struct _ibv_cq_ex *cq_ex;
+
+	if (ibv_support_ex(cq->context))
+		return cq;
+
+	cq_ex = container_of(cq, struct _ibv_cq_ex, cq);
+	return cq_ex->real_cq;
+}
+
+struct ibv_srq *_ibv_verbs_srq(struct ibv_srq *srq)
+{
+	return ibv_support_ex(srq->context) ? srq : (struct ibv_srq *) srq->srq_context;
+}
+
+struct ibv_qp  *_ibv_verbs_qp(struct ibv_qp *qp)
+{
+	return ibv_support_ex(qp->context) ? qp : (struct ibv_qp *) qp->qp_context;
+}
+
+struct ibv_cq  *_ibv_verbs_cq(struct ibv_cq *cq)
+{
+	return ibv_support_ex(cq->context) ? cq : (struct ibv_cq *) cq->cq_context;
+}
+
+static int _ibv_query_device_ex(struct ibv_context *context,
+				struct ibv_device_attr *device_attr)
+{
+	return ibv_query_device(_ibv_real_context(context), device_attr);
+}
+
+static int _ibv_query_port_ex(struct ibv_context *context, uint8_t port_num,
+			      struct ibv_port_attr *port_attr)
+{
+	return ibv_query_port(_ibv_real_context(context), port_num, port_attr);
+}
+
+static struct ibv_pd *_ibv_alloc_pd_ex(struct ibv_context *context)
+{
+	struct _ibv_pd_ex *pd_ex;
+
+	pd_ex = calloc(1, sizeof *pd_ex);
+	if (!pd_ex)
+		return NULL;
+
+	pd_ex->real_pd = ibv_alloc_pd(_ibv_real_context(context));
+	if (!pd_ex->real_pd) {
+		free(pd_ex);
+		return NULL;
+	}
+
+	return &pd_ex->pd;
+}
+
+static int _ibv_dealloc_pd_ex(struct ibv_pd *pd)
+{
+	struct _ibv_pd_ex *pd_ex = container_of(pd, struct _ibv_pd_ex, pd);
+	int ret;
+
+	ret = ibv_dealloc_pd(pd_ex->real_pd);
+	if (ret)
+		return ret;
+
+	free(pd_ex);
+	return 0;
+}
+
+static struct ibv_mr *_ibv_reg_mr_ex(struct ibv_pd *pd, void *addr, size_t length,
+				     int access)
+{
+	struct _ibv_pd_ex *pd_ex = container_of(pd, struct _ibv_pd_ex, pd);
+	struct _ibv_mr_ex *mr_ex;
+
+	mr_ex = calloc(1, sizeof *mr_ex);
+	if (!mr_ex)
+		return NULL;
+
+	mr_ex->real_mr = ibv_reg_mr(pd_ex->real_pd, addr, length, access);
+	if (!mr_ex->real_mr) {
+		free(mr_ex);
+		return NULL;
+	}
+
+	mr_ex->mr.lkey = mr_ex->real_mr->lkey;
+	mr_ex->mr.rkey = mr_ex->real_mr->rkey;
+	return &mr_ex->mr;
+}
+
+static int _ibv_dereg_mr_ex(struct ibv_mr *mr)
+{
+	struct _ibv_mr_ex *mr_ex = container_of(mr, struct _ibv_mr_ex, mr);
+	int ret;
+
+	ret = ibv_dereg_mr(mr_ex->real_mr);
+	if (ret)
+		return ret;
+
+	free(mr_ex);
+	return 0;
+}
+
+/*
+ * ibv_create_cq holds the channel mutex while calling the provider.  We
+ * cannot call ibv_create_cq recursively, so we need to call the provider
+ * directly and duplicate initializing the ibv_cq.
+ */
+struct ibv_cq *_ibv_create_cq_ex(struct ibv_context *context, int cqe,
+				 struct ibv_comp_channel *channel,
+				 int comp_vector)
+{
+	struct ibv_context *real_context= _ibv_real_context(context);
+	struct _ibv_cq_ex *cq_ex;
+
+	cq_ex = calloc(1, sizeof *cq_ex);
+	if (!cq_ex)
+		return NULL;
+
+	cq_ex->real_cq = real_context->ops.create_cq(real_context, cqe,
+						     channel, comp_vector);
+	if (!cq_ex->real_cq) {
+		free(cq_ex);
+		return NULL;
+	}
+
+	cq_ex->real_cq->context = real_context;
+	cq_ex->real_cq->channel = channel;
+	if (channel)
+		++channel->refcnt;
+	cq_ex->real_cq->cq_context = cq_ex;
+	cq_ex->real_cq->comp_events_completed  = 0;
+	cq_ex->real_cq->async_events_completed = 0;
+	pthread_mutex_init(&cq_ex->real_cq->mutex, NULL);
+	pthread_cond_init(&cq_ex->real_cq->cond, NULL);
+
+	cq_ex->cq.cqe = cq_ex->real_cq->cqe;
+	return &cq_ex->cq;
+}
+
+static int _ibv_poll_cq_ex(struct ibv_cq *cq, int num_entries, struct ibv_wc *wc)
+{
+	return ibv_poll_cq(_ibv_real_cq(cq), num_entries, wc);
+}
+
+static int _ibv_req_notify_cq_ex(struct ibv_cq *cq, int solicited_only)
+{
+	return ibv_req_notify_cq(_ibv_real_cq(cq), solicited_only);
+}
+
+static int _ibv_resize_cq_ex(struct ibv_cq *cq, int cqe)
+{
+	struct _ibv_cq_ex *cq_ex = container_of(cq, struct _ibv_cq_ex, cq);
+	int ret;
+
+	ret = ibv_resize_cq(cq_ex->real_cq, cqe);
+	if (ret)
+		return ret;
+
+	cq_ex->cq.cqe = cq_ex->real_cq->cqe;
+	return 0;
+}
+
+/*
+ * ibv_destroy_cq holds the mutex to any corresponding channel.  Call the
+ * provider directly.
+ */
+static int _ibv_destroy_cq_ex(struct ibv_cq *cq)
+{
+	struct _ibv_cq_ex *cq_ex = container_of(cq, struct _ibv_cq_ex, cq);
+	int ret;
+
+	ret = cq_ex->real_cq->context->ops.destroy_cq(cq_ex->real_cq);
+	if (ret)
+		return ret;
+
+	if (cq_ex->cq.channel)
+		--cq_ex->cq.channel->refcnt;
+
+	free(cq_ex);
+	return 0;
+}
+
+static struct ibv_srq *_ibv_create_srq_ex(struct ibv_pd *pd,
+					  struct ibv_srq_init_attr *srq_init_attr)
+{
+	struct _ibv_pd_ex *pd_ex = container_of(pd, struct _ibv_pd_ex, pd);
+	struct _ibv_srq_ex *srq_ex;
+
+	srq_ex = calloc(1, sizeof *srq_ex);
+	if (!srq_ex)
+		return NULL;
+
+	srq_ex->real_srq = ibv_create_srq(pd_ex->real_pd, srq_init_attr);
+	if (!srq_ex->real_srq) {
+		free(srq_ex);
+		return NULL;
+	}
+
+	return &srq_ex->srq;
+}
+
+static int _ibv_modify_srq_ex(struct ibv_srq *srq,
+			      struct ibv_srq_attr *srq_attr,
+			      int srq_attr_mask)
+{
+	return ibv_modify_srq(_ibv_real_srq(srq), srq_attr, srq_attr_mask);
+}
+
+static int _ibv_query_srq_ex(struct ibv_srq *srq,
+			     struct ibv_srq_attr *srq_attr)
+{
+	return ibv_query_srq(_ibv_real_srq(srq), srq_attr);
+}
+
+static int _ibv_destroy_srq_ex(struct ibv_srq *srq)
+{
+	struct _ibv_srq_ex *srq_ex = container_of(srq, struct _ibv_srq_ex, srq);
+	int ret;
+
+	ret = ibv_destroy_srq(srq_ex->real_srq);
+	if (ret)
+		return ret;
+
+	free(srq_ex);
+	return 0;
+}
+
+static int _ibv_post_srq_recv_ex(struct ibv_srq *srq,
+				 struct ibv_recv_wr *recv_wr,
+				 struct ibv_recv_wr **bad_recv_wr)
+{
+	struct _ibv_srq_ex *srq_ex = container_of(srq, struct _ibv_srq_ex, srq);
+	return ibv_post_srq_recv(srq_ex->real_srq, recv_wr, bad_recv_wr);
+}
+
+static struct ibv_qp *_ibv_create_qp_ex(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
+{
+	struct _ibv_pd_ex *pd_ex = container_of(pd, struct _ibv_pd_ex, pd);
+	struct _ibv_qp_ex *qp_ex;
+	struct ibv_qp_init_attr real_attr;
+
+	qp_ex = calloc(1, sizeof *qp_ex);
+	if (!qp_ex)
+		return NULL;
+
+	real_attr.qp_context = qp_ex;
+	real_attr.send_cq    = attr->send_cq ? _ibv_real_cq(attr->send_cq) : NULL;
+	real_attr.recv_cq    = attr->recv_cq ? _ibv_real_cq(attr->recv_cq) : NULL;
+	real_attr.srq        = attr->srq     ? _ibv_real_srq(attr->srq) : NULL;
+	real_attr.cap        = attr->cap;
+	real_attr.qp_type    = attr->qp_type;
+	real_attr.sq_sig_all = attr->sq_sig_all;
+
+	qp_ex->real_qp = ibv_create_qp(pd_ex->real_pd, &real_attr);
+	if (!qp_ex->real_qp) {
+		free(qp_ex);
+		return NULL;
+	}
+
+	qp_ex->qp.qp_num = qp_ex->real_qp->qp_num;
+	return &qp_ex->qp;
+}
+
+static int _ibv_query_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			    int attr_mask, struct ibv_qp_init_attr *init_attr)
+{
+	struct _ibv_qp_ex *qp_ex = container_of(qp, struct _ibv_qp_ex, qp);
+	int ret;
+
+	ret = ibv_query_qp(qp_ex->real_qp, attr, attr_mask, init_attr);
+	if (ret)
+		return ret;
+
+	init_attr->qp_context = qp_ex->qp.qp_context;
+	init_attr->send_cq = qp_ex->qp.send_cq;
+	init_attr->recv_cq = qp_ex->qp.recv_cq;
+	init_attr->srq = qp_ex->qp.srq;
+	return 0;
+}
+
+static int _ibv_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			     int attr_mask)
+{
+	return ibv_modify_qp(_ibv_real_qp(qp), attr, attr_mask);
+}
+
+static int _ibv_destroy_qp_ex(struct ibv_qp *qp)
+{
+	struct _ibv_qp_ex *qp_ex = container_of(qp, struct _ibv_qp_ex, qp);
+	int ret;
+
+	ret = ibv_destroy_qp(qp_ex->real_qp);
+	if (ret)
+		return ret;
+
+	free(qp_ex);
+	return 0;
+}
+
+static int _ibv_post_send_ex(struct ibv_qp *qp, struct ibv_send_wr *wr,
+			     struct ibv_send_wr **bad_wr)
+{
+	struct _ibv_qp_ex *qp_ex = container_of(qp, struct _ibv_qp_ex, qp);
+	struct _ibv_ah_ex *ah_ex;
+	struct ibv_send_wr real_wr, *cur_wr;
+	int ret;
+
+	if (qp->qp_type != IBV_QPT_UD)
+		return ibv_post_send(qp_ex->real_qp, wr, bad_wr);
+
+	for (cur_wr = wr, ret = 0; cur_wr && !ret; cur_wr = cur_wr->next) {
+		real_wr = *cur_wr;
+		real_wr.next = NULL;
+		ah_ex = container_of(cur_wr->wr.ud.ah, struct _ibv_ah_ex, ah);
+		real_wr.wr.ud.ah = ah_ex->real_ah;
+		ret = ibv_post_send(qp_ex->real_qp, &real_wr, bad_wr);
+	}
+	*bad_wr = cur_wr;
+	return ret;
+}
+
+static int _ibv_post_recv_ex(struct ibv_qp *qp, struct ibv_recv_wr *wr,
+			     struct ibv_recv_wr **bad_wr)
+{
+	struct _ibv_qp_ex *qp_ex = container_of(qp, struct _ibv_qp_ex, qp);
+	return ibv_post_recv(qp_ex->real_qp, wr, bad_wr);
+}
+
+static struct ibv_ah *_ibv_create_ah_ex(struct ibv_pd *pd, struct ibv_ah_attr *attr)
+{
+	struct _ibv_pd_ex *pd_ex = container_of(pd, struct _ibv_pd_ex, pd);
+	struct _ibv_ah_ex *ah_ex;
+
+	ah_ex = calloc(1, sizeof *ah_ex);
+	if (!ah_ex)
+		return NULL;
+
+	ah_ex->real_ah = ibv_create_ah(pd_ex->real_pd, attr);
+	if (!ah_ex->real_ah) {
+		free(ah_ex);
+		return NULL;
+	}
+
+	return &ah_ex->ah;
+}
+
+static int _ibv_destroy_ah_ex(struct ibv_ah *ah)
+{
+	struct _ibv_ah_ex *ah_ex = container_of(ah, struct _ibv_ah_ex, ah);
+	int ret;
+
+	ret = ibv_destroy_ah(ah_ex->real_ah);
+	if (ret)
+		return ret;
+
+	free(ah_ex);
+	return 0;
+}
+
+static int _ibv_attach_mcast_ex(struct ibv_qp *qp, const union ibv_gid *gid,
+				uint16_t lid)
+{
+	return ibv_attach_mcast(_ibv_real_qp(qp), gid, lid);
+}
+
+static int _ibv_detach_mcast_ex(struct ibv_qp *qp, const union ibv_gid *gid,
+				uint16_t lid)
+{
+	return ibv_detach_mcast(_ibv_real_qp(qp), gid, lid);
+}
+
+void _ibv_init_context(struct ibv_device *device,
+		       struct verbs_context_private *priv_ctx, int cmd_fd)
+{
+	struct ibv_context_ops *ops = &priv_ctx->context_ex.context.ops;
+
+	priv_ctx->real_context->device = device;
+	priv_ctx->real_context->cmd_fd = cmd_fd;
+	pthread_mutex_init(&priv_ctx->real_context->mutex, NULL);
+	priv_ctx->real_context->abi_compat = NULL;
+
+	ops->query_device  = _ibv_query_device_ex;
+	ops->query_port    = _ibv_query_port_ex;
+	ops->alloc_pd      = _ibv_alloc_pd_ex;
+	ops->dealloc_pd    = _ibv_dealloc_pd_ex;
+	ops->reg_mr        = _ibv_reg_mr_ex;
+	ops->dereg_mr      = _ibv_dereg_mr_ex;
+	ops->create_cq     = _ibv_create_cq_ex;
+	ops->poll_cq       = _ibv_poll_cq_ex;
+	ops->req_notify_cq = _ibv_req_notify_cq_ex;
+	ops->resize_cq     = _ibv_resize_cq_ex;
+	ops->destroy_cq    = _ibv_destroy_cq_ex;
+	ops->create_srq    = _ibv_create_srq_ex;
+	ops->modify_srq    = _ibv_modify_srq_ex;
+	ops->query_srq     = _ibv_query_srq_ex;
+	ops->destroy_srq   = _ibv_destroy_srq_ex;
+	ops->post_srq_recv = _ibv_post_srq_recv_ex;
+	ops->create_qp     = _ibv_create_qp_ex;
+	ops->query_qp      = _ibv_query_qp_ex;
+	ops->modify_qp     = _ibv_modify_qp_ex;
+	ops->destroy_qp    = _ibv_destroy_qp_ex;
+	ops->post_send     = _ibv_post_send_ex;
+	ops->post_recv     = _ibv_post_recv_ex;
+	ops->create_ah     = _ibv_create_ah_ex;
+	ops->destroy_ah    = _ibv_destroy_ah_ex;
+	ops->attach_mcast  = _ibv_attach_mcast_ex;
+	ops->detach_mcast  = _ibv_detach_mcast_ex;
+}
diff --git a/src/device.c b/src/device.c
index 9e43138..e9699b6 100644
--- a/src/device.c
+++ b/src/device.c
@@ -127,7 +127,9 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	char *devpath;
 	int cmd_fd;
 	struct ibv_context *context;
-	struct verbs_context *context_ex;
+	struct verbs_context_private *priv_ctx;
+	struct verbs_device *vdev;
+	size_t prov_ctx_size;
 
 	if (asprintf(&devpath, "/dev/infiniband/%s", device->dev_name) < 0)
 		return NULL;
@@ -144,49 +146,44 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 
 	context = device->ops.alloc_context(device, cmd_fd);
 	if (!context)
-		goto err;
-	if (context == (struct ibv_context *)(((uint8_t *)NULL)-1)) {
-		/* New provider that supports verbs extension was detected */
-		struct verbs_device *verbs_device =
-					verbs_get_device(device);
-		int ret;
-
-		/* Library now allocates the context */
-		context_ex = calloc(1, sizeof(*context_ex) +
-			verbs_device->size_of_context);
-
-		if (!context_ex) {
-			errno = ENOMEM;
-			goto err;
-		}
-		context = &context_ex->context;
-		/* Init new verbs_context */
-		context_ex->context.abi_compat  = ((uint8_t *)NULL)-1;
-		context_ex->sz = sizeof(*context_ex);
-
-		/* Call provider to initialize its calls first */
-		ret = verbs_device->init_context(verbs_device,
-					&context_ex->context, cmd_fd);
-		if (ret)
-			goto verbs_err;
-		/* initialize *all* library ops to either lib calls or
-		  * directly to provider calls.
-		context_ex-> lib_new_func1= __verbs_new_func1;
-		context_ex-> lib_new_func2= __verbs_new_func2;
-		*/
+		goto err1;
+
+	if (context == IBV_EXTENDED_VERBS) {
+		vdev = verbs_get_device(device);
+		prov_ctx_size = vdev->size_of_context;
+	} else {
+		vdev = NULL;
+		prov_ctx_size = 0;
 	}
 
-	context->device = device;
-	context->cmd_fd = cmd_fd;
-	pthread_mutex_init(&context->mutex, NULL);
+	priv_ctx = calloc(1, sizeof(*priv_ctx) + prov_ctx_size);
+	if (!priv_ctx) {
+		errno = ENOMEM;
+		goto err1;
+	}
 
-	return context;
+	priv_ctx->context_ex.sz = sizeof(struct verbs_context);
+	if (vdev) {
+		if (vdev->init_context(vdev, &priv_ctx->context_ex.context, cmd_fd))
+			goto err2;
+
+		priv_ctx->real_context = &priv_ctx->context_ex.context;
+		priv_ctx->context_ex.context.abi_compat = IBV_EXTENDED_VERBS;
+	} else {
+		priv_ctx->real_context = context;
+		priv_ctx->context_ex.context.abi_compat = NULL;
+		_ibv_init_context(device, priv_ctx, cmd_fd);
+	}
 
-verbs_err:
-	free(context_ex);
-err:
-	close(cmd_fd);
+	priv_ctx->context_ex.context.device = device;
+	priv_ctx->context_ex.context.cmd_fd = cmd_fd;
+	pthread_mutex_init(&priv_ctx->context_ex.context.mutex, NULL);
+	return &priv_ctx->context_ex.context;
 
+err2:
+	free(priv_ctx);
+err1:
+	close(cmd_fd);
 	return NULL;
 }
 default_symver(__ibv_open_device, ibv_open_device);
@@ -196,17 +193,15 @@ int __ibv_close_device(struct ibv_context *context)
 	int async_fd = context->async_fd;
 	int cmd_fd   = context->cmd_fd;
 	int cq_fd    = -1;
-	struct verbs_context *context_ex;
-
-	context_ex = verbs_get_ctx(context);
-	if (context_ex) {
-		struct verbs_device *verbs_device =
-					verbs_get_device(context->device);
-		/* Provider supports verbs extension */
-		verbs_device->uninit_context(verbs_device, context);
-		free(context_ex);
-	} else
-		context->device->ops.free_context(context);
+	struct verbs_context_private *priv_ctx = ibv_private_context(context);
+
+	if (ibv_support_ex(context)) {
+		struct verbs_device *verbs_device = verbs_get_device(context->device);
+		verbs_device->uninit_context(verbs_device, &priv_ctx->context_ex.context);
+	} else {
+		context->device->ops.free_context(priv_ctx->real_context);
+	}
+	free(priv_ctx);
 
 	close(async_fd);
 	close(cmd_fd);
@@ -221,6 +216,7 @@ int __ibv_get_async_event(struct ibv_context *context,
 			  struct ibv_async_event *event)
 {
 	struct ibv_kern_async_event ev;
+	int cqe = 0, qpe = 0, srqe = 0;
 
 	if (read(context->async_fd, &ev, sizeof ev) != sizeof ev)
 		return -1;
@@ -230,6 +226,7 @@ int __ibv_get_async_event(struct ibv_context *context,
 	switch (event->event_type) {
 	case IBV_EVENT_CQ_ERR:
 		event->element.cq = (void *) (uintptr_t) ev.element;
+		cqe = 1;
 		break;
 
 	case IBV_EVENT_QP_FATAL:
@@ -241,11 +238,13 @@ int __ibv_get_async_event(struct ibv_context *context,
 	case IBV_EVENT_PATH_MIG_ERR:
 	case IBV_EVENT_QP_LAST_WQE_REACHED:
 		event->element.qp = (void *) (uintptr_t) ev.element;
+		qpe = 1;
 		break;
 
 	case IBV_EVENT_SRQ_ERR:
 	case IBV_EVENT_SRQ_LIMIT_REACHED:
 		event->element.srq = (void *) (uintptr_t) ev.element;
+		srqe = 1;
 		break;
 
 	default:
@@ -256,6 +255,13 @@ int __ibv_get_async_event(struct ibv_context *context,
 	if (context->ops.async_event)
 		context->ops.async_event(event);
 
+	if (cqe)
+		event->element.cq = _ibv_verbs_cq(event->element.cq);
+	else if (qpe)
+		event->element.qp = _ibv_verbs_qp(event->element.qp);
+	else if (srqe)
+		event->element.srq = _ibv_verbs_srq(event->element.srq);
+
 	return 0;
 }
 default_symver(__ibv_get_async_event, ibv_get_async_event);
@@ -265,7 +271,7 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 	switch (event->event_type) {
 	case IBV_EVENT_CQ_ERR:
 	{
-		struct ibv_cq *cq = event->element.cq;
+		struct ibv_cq *cq = _ibv_real_cq(event->element.cq);
 
 		pthread_mutex_lock(&cq->mutex);
 		++cq->async_events_completed;
@@ -284,7 +290,7 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 	case IBV_EVENT_PATH_MIG_ERR:
 	case IBV_EVENT_QP_LAST_WQE_REACHED:
 	{
-		struct ibv_qp *qp = event->element.qp;
+		struct ibv_qp *qp = _ibv_real_qp(event->element.qp);
 
 		pthread_mutex_lock(&qp->mutex);
 		++qp->events_completed;
@@ -297,7 +303,7 @@ void __ibv_ack_async_event(struct ibv_async_event *event)
 	case IBV_EVENT_SRQ_ERR:
 	case IBV_EVENT_SRQ_LIMIT_REACHED:
 	{
-		struct ibv_srq *srq = event->element.srq;
+		struct ibv_srq *srq = _ibv_real_srq(event->element.srq);
 
 		pthread_mutex_lock(&srq->mutex);
 		++srq->events_completed;
diff --git a/src/ibverbs.h b/src/ibverbs.h
index fa6cd41..33049d4 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -102,4 +102,33 @@ HIDDEN int ibverbs_init(struct ibv_device ***list);
 		(cmd)->response  = (uintptr_t) (out);			\
 	} while (0)
 
+struct verbs_context_private {
+	struct ibv_context *real_context;
+	/* place internal data before verbs_context */
+	struct verbs_context context_ex;
+};
+
+#define IBV_EXTENDED_VERBS (((void *) NULL) - 1)
+
+static inline int ibv_support_ex(struct ibv_context *context)
+{
+	return context->abi_compat == IBV_EXTENDED_VERBS;
+}
+
+static inline struct verbs_context_private *
+ibv_private_context(struct ibv_context *context)
+{
+	return container_of(verbs_get_ctx(context),
+			    struct verbs_context_private, context_ex);
+}
+
+void _ibv_init_context(struct ibv_device *device,
+		       struct verbs_context_private *priv_ctx, int cmd_fd);
+struct ibv_srq *_ibv_real_srq(struct ibv_srq *srq);
+struct ibv_qp  *_ibv_real_qp(struct ibv_qp *qp);
+struct ibv_cq  *_ibv_real_cq(struct ibv_cq *cq);
+struct ibv_srq *_ibv_verbs_srq(struct ibv_srq *srq);
+struct ibv_qp  *_ibv_verbs_qp(struct ibv_qp *qp);
+struct ibv_cq  *_ibv_verbs_cq(struct ibv_cq *cq);
+
 #endif /* IB_VERBS_H */
diff --git a/src/verbs.c b/src/verbs.c
index b5938f2..7973afc 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -334,18 +334,21 @@ int __ibv_get_cq_event(struct ibv_comp_channel *channel,
 	if (read(channel->fd, &ev, sizeof ev) != sizeof ev)
 		return -1;
 
-	*cq         = (struct ibv_cq *) (uintptr_t) ev.cq_handle;
-	*cq_context = (*cq)->cq_context;
-
+	*cq = (struct ibv_cq *) (uintptr_t) ev.cq_handle;
 	if ((*cq)->context->ops.cq_event)
 		(*cq)->context->ops.cq_event(*cq);
 
+	if (!verbs_get_ctx((*cq)->context))
+		*cq = (struct ibv_cq *) (*cq)->cq_context;
+	*cq_context = (*cq)->cq_context;
+
 	return 0;
 }
 default_symver(__ibv_get_cq_event, ibv_get_cq_event);
 
 void __ibv_ack_cq_events(struct ibv_cq *cq, unsigned int nevents)
 {
+	cq = _ibv_real_cq(cq);
 	pthread_mutex_lock(&cq->mutex);
 	cq->comp_events_completed += nevents;
 	pthread_cond_signal(&cq->cond);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
