From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] vmw_pvrdma: Add SRQ support
Date: Sun, 29 Oct 2017 15:44:46 -0700
Message-ID: <20171029224429.GA21993@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enable userlevel applications to use SRQs.

Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 buildlib/fixup-include/rdma-vmw_pvrdma-abi.h |   4 +
 providers/vmw_pvrdma/pvrdma-abi-fix.h        |  10 +
 providers/vmw_pvrdma/pvrdma.h                |  41 ++++
 providers/vmw_pvrdma/pvrdma_main.c           |   6 +
 providers/vmw_pvrdma/pvrdma_ring.h           |   1 -
 providers/vmw_pvrdma/qp.c                    | 319 +++++++++++++++++++++++----
 6 files changed, 333 insertions(+), 48 deletions(-)

diff --git a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
index c8c1d2d..464d497 100644
--- a/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
+++ b/buildlib/fixup-include/rdma-vmw_pvrdma-abi.h
@@ -57,6 +57,8 @@
 #define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
 #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
 #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
+#define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
+#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
 
 enum pvrdma_wr_opcode {
 	PVRDMA_WR_RDMA_WRITE,
@@ -157,6 +159,8 @@ struct pvrdma_resize_cq {
 
 struct pvrdma_create_srq {
 	__u64 buf_addr;
+	__u32 buf_size;
+	__u32 reserved;
 };
 
 struct pvrdma_create_srq_resp {
diff --git a/providers/vmw_pvrdma/pvrdma-abi-fix.h b/providers/vmw_pvrdma/pvrdma-abi-fix.h
index 83916db..8ff9d7c 100644
--- a/providers/vmw_pvrdma/pvrdma-abi-fix.h
+++ b/providers/vmw_pvrdma/pvrdma-abi-fix.h
@@ -69,6 +69,16 @@ struct user_pvrdma_create_cq_resp {
 	struct pvrdma_create_cq_resp	udata;
 };
 
+struct user_pvrdma_create_srq {
+	struct ibv_create_srq		ibv_cmd;
+	struct pvrdma_create_srq	udata;
+};
+
+struct user_pvrdma_create_srq_resp {
+	struct ibv_create_srq_resp	ibv_resp;
+	struct pvrdma_create_srq_resp	udata;
+};
+
 struct user_pvrdma_create_qp {
 	struct ibv_create_qp		ibv_cmd;
 	struct pvrdma_create_qp		udata;
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index 7840e11..5a7b171 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -135,6 +135,21 @@ struct pvrdma_cq {
 	uint32_t			cqn;
 };
 
+struct pvrdma_srq {
+	struct ibv_srq			ibv_srq;
+	struct pvrdma_buf		buf;
+	pthread_spinlock_t		lock;
+	uint64_t			*wrid;
+	uint32_t			srqn;
+	int				wqe_cnt;
+	int				wqe_size;
+	int				max_gs;
+	int				wqe_shift;
+	struct pvrdma_ring_state	*ring_state;
+	uint16_t			counter;
+	int				offset;
+};
+
 struct pvrdma_wq {
 	uint64_t			*wrid;
 	pthread_spinlock_t		lock;
@@ -156,6 +171,7 @@ struct pvrdma_qp {
 	int				sq_spare_wqes;
 	struct pvrdma_wq		sq;
 	struct pvrdma_wq		rq;
+	int				is_srq;
 };
 
 struct pvrdma_ah {
@@ -198,6 +214,11 @@ static inline struct pvrdma_cq *to_vcq(struct ibv_cq *ibcq)
 	return container_of(ibcq, struct pvrdma_cq, ibv_cq);
 }
 
+static inline struct pvrdma_srq *to_vsrq(struct ibv_srq *ibsrq)
+{
+	return container_of(ibsrq, struct pvrdma_srq, ibv_srq);
+}
+
 static inline struct pvrdma_qp *to_vqp(struct ibv_qp *ibqp)
 {
 	return container_of(ibqp, struct pvrdma_qp, ibv_qp);
@@ -218,6 +239,11 @@ static inline void pvrdma_write_uar_cq(void *uar, unsigned value)
 	*(__le32 *)(uar + PVRDMA_UAR_CQ_OFFSET) = htole32(value);
 }
 
+static inline void pvrdma_write_uar_srq(void *uar, unsigned int value)
+{
+	*(__le32 *)(uar + PVRDMA_UAR_SRQ_OFFSET) = htole32(value);
+}
+
 static inline int ibv_send_flags_to_pvrdma(int flags)
 {
 	return flags;
@@ -301,6 +327,21 @@ int pvrdma_store_qp(struct pvrdma_context *ctx, uint32_t qpn,
 		    struct pvrdma_qp *qp);
 void pvrdma_clear_qp(struct pvrdma_context *ctx, uint32_t qpn);
 
+struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
+				  struct ibv_srq_init_attr *attr);
+int pvrdma_modify_srq(struct ibv_srq *srq, struct ibv_srq_attr *attr,
+		      int attr_mask);
+int pvrdma_query_srq(struct ibv_srq *srq,
+		     struct ibv_srq_attr *attr);
+int pvrdma_destroy_srq(struct ibv_srq *srq);
+int pvrdma_alloc_srq_buf(struct pvrdma_device *dev,
+			 struct ibv_srq_attr *attr,
+			 struct pvrdma_srq *srq);
+int pvrdma_post_srq_recv(struct ibv_srq *ibsrq,
+			 struct ibv_recv_wr *wr,
+			 struct ibv_recv_wr **bad_wr);
+void pvrdma_init_srq_queue(struct pvrdma_srq *srq);
+
 struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
 int pvrdma_destroy_ah(struct ibv_ah *ah);
 
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 0826629..17736cd 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -69,6 +69,12 @@ static struct ibv_context_ops pvrdma_ctx_ops = {
 	.modify_qp = pvrdma_modify_qp,
 	.destroy_qp = pvrdma_destroy_qp,
 
+	.create_srq = pvrdma_create_srq,
+	.modify_srq = pvrdma_modify_srq,
+	.query_srq = pvrdma_query_srq,
+	.destroy_srq = pvrdma_destroy_srq,
+	.post_srq_recv = pvrdma_post_srq_recv,
+
 	.post_send = pvrdma_post_send,
 	.post_recv = pvrdma_post_recv,
 	.create_ah = pvrdma_create_ah,
diff --git a/providers/vmw_pvrdma/pvrdma_ring.h b/providers/vmw_pvrdma/pvrdma_ring.h
index e247231..565b45c 100644
--- a/providers/vmw_pvrdma/pvrdma_ring.h
+++ b/providers/vmw_pvrdma/pvrdma_ring.h
@@ -47,7 +47,6 @@
 #ifndef __PVRDMA_RING_H__
 #define __PVRDMA_RING_H__
 
-#include <stdint.h>
 #include <linux/types.h>
 
 #define PVRDMA_INVALID_IDX	-1	/* Invalid index. */
diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
index f5e2486..25b4841 100644
--- a/providers/vmw_pvrdma/qp.c
+++ b/providers/vmw_pvrdma/qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ * Copyright (c) 2012-2017 VMware, Inc.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of EITHER the GNU General Public License
@@ -54,37 +54,145 @@ int pvrdma_alloc_qp_buf(struct pvrdma_device *dev, struct ibv_qp_cap *cap,
 	if (!qp->sq.wrid)
 		return -1;
 
-	qp->rq.wrid = calloc(qp->rq.wqe_cnt, sizeof(uint64_t));
-	if (!qp->rq.wrid) {
-		free(qp->sq.wrid);
-		return -1;
-	}
-
-	/* Align page size for [rq][sq] */
-	qp->rbuf.length = align(qp->rq.offset +
-				qp->rq.wqe_cnt * qp->rq.wqe_size,
-				dev->page_size);
+	/* Align page size for sq */
 	qp->sbuf.length = align(qp->sq.offset +
 				qp->sq.wqe_cnt * qp->sq.wqe_size,
 				dev->page_size);
-	qp->buf_size = qp->rbuf.length + qp->sbuf.length;
-
-	if (pvrdma_alloc_buf(&qp->rbuf, qp->rbuf.length, dev->page_size)) {
-		free(qp->sq.wrid);
-		free(qp->rq.wrid);
-		return -1;
-	}
 
 	if (pvrdma_alloc_buf(&qp->sbuf, qp->sbuf.length, dev->page_size)) {
 		free(qp->sq.wrid);
-		free(qp->rq.wrid);
-		pvrdma_free_buf(&qp->rbuf);
 		return -1;
 	}
 
-	memset(qp->rbuf.buf, 0, qp->rbuf.length);
 	memset(qp->sbuf.buf, 0, qp->sbuf.length);
 
+	if (!qp->is_srq) {
+		qp->rq.wrid = calloc(qp->rq.wqe_cnt, sizeof(uint64_t));
+		if (!qp->rq.wrid) {
+			pvrdma_free_buf(&qp->sbuf);
+			free(qp->sq.wrid);
+			return -1;
+		}
+
+		/* Align page size for rq */
+		qp->rbuf.length = align(qp->rq.offset +
+					qp->rq.wqe_cnt * qp->rq.wqe_size,
+					dev->page_size);
+
+		if (pvrdma_alloc_buf(&qp->rbuf, qp->rbuf.length,
+				     dev->page_size)) {
+			free(qp->sq.wrid);
+			free(qp->rq.wrid);
+			pvrdma_free_buf(&qp->sbuf);
+			return -1;
+		}
+		memset(qp->rbuf.buf, 0, qp->rbuf.length);
+	} else {
+		qp->rbuf.buf = NULL;
+		qp->rbuf.length = 0;
+	}
+
+	qp->buf_size = qp->rbuf.length + qp->sbuf.length;
+
+	return 0;
+}
+
+void pvrdma_init_srq_queue(struct pvrdma_srq *srq)
+{
+	srq->ring_state->rx.cons_head = 0;
+	srq->ring_state->rx.prod_tail = 0;
+}
+
+struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
+				  struct ibv_srq_init_attr *attr)
+{
+	struct pvrdma_device *dev = to_vdev(pd->context->device);
+	struct user_pvrdma_create_srq cmd;
+	struct ibv_create_srq_resp resp;
+	struct pvrdma_srq *srq;
+	int ret;
+
+	attr->attr.max_wr = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_wr));
+	attr->attr.max_sge = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_sge));
+
+	srq = malloc(sizeof(*srq));
+	if (!srq)
+		return NULL;
+
+	if (pthread_spin_init(&srq->lock, PTHREAD_PROCESS_PRIVATE))
+		goto err;
+
+	srq->wqe_cnt = attr->attr.max_wr;
+	srq->max_gs = attr->attr.max_sge;
+	srq->wqe_size = align_next_power2(sizeof(struct pvrdma_rq_wqe_hdr) +
+					  sizeof(struct ibv_sge) *
+					  srq->max_gs);
+	/* Page reserved for queue metadata */
+	srq->offset = dev->page_size;
+
+	if (pvrdma_alloc_srq_buf(dev, &attr->attr, srq))
+		goto err_spinlock;
+
+	srq->ring_state = srq->buf.buf;
+	pvrdma_init_srq_queue(srq);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.udata.buf_addr = (uintptr_t) srq->buf.buf;
+	cmd.udata.buf_size = srq->buf.length;
+
+	ret = ibv_cmd_create_srq(pd, &srq->ibv_srq, attr,
+				 &cmd.ibv_cmd, sizeof(cmd),
+				 &resp, sizeof(resp));
+
+	if (ret)
+		goto err_free;
+
+	srq->srqn = resp.srqn;
+
+	return &srq->ibv_srq;
+
+err_free:
+	free(srq->wrid);
+	pvrdma_free_buf(&srq->buf);
+err_spinlock:
+	pthread_spin_destroy(&srq->lock);
+err:
+	free(srq);
+
+	return NULL;
+}
+
+int pvrdma_modify_srq(struct ibv_srq *srq,
+		      struct ibv_srq_attr *attr,
+		      int attr_mask)
+{
+	struct ibv_modify_srq cmd;
+
+	return ibv_cmd_modify_srq(srq, attr, attr_mask, &cmd, sizeof(cmd));
+}
+
+int pvrdma_query_srq(struct ibv_srq *srq,
+		     struct ibv_srq_attr *attr)
+{
+	struct ibv_query_srq cmd;
+
+	return ibv_cmd_query_srq(srq, attr, &cmd, sizeof(cmd));
+}
+
+int pvrdma_destroy_srq(struct ibv_srq *ibsrq)
+{
+	struct pvrdma_srq *srq = to_vsrq(ibsrq);
+	int ret;
+
+	ret = ibv_cmd_destroy_srq(ibsrq);
+	if (ret)
+		return ret;
+
+	pthread_spin_destroy(&srq->lock);
+	pvrdma_free_buf(&srq->buf);
+	free(srq->wrid);
+	free(srq);
+
 	return 0;
 }
 
@@ -92,8 +200,10 @@ static void pvrdma_init_qp_queue(struct pvrdma_qp *qp)
 {
 	qp->sq.ring_state->cons_head = 0;
 	qp->sq.ring_state->prod_tail = 0;
-	qp->rq.ring_state->cons_head = 0;
-	qp->rq.ring_state->prod_tail = 0;
+	if (qp->rq.ring_state) {
+		qp->rq.ring_state->cons_head = 0;
+		qp->rq.ring_state->prod_tail = 0;
+	}
 }
 
 struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
@@ -104,26 +214,28 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 	struct ibv_create_qp_resp resp;
 	struct pvrdma_qp *qp;
 	int ret;
+	int is_srq = !!(attr->srq);
 
-	attr->cap.max_recv_sge =
-		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_sge));
-	attr->cap.max_recv_wr =
-		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_wr));
 	attr->cap.max_send_sge =
 		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_sge));
 	attr->cap.max_send_wr =
 		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_wr));
 
+	if (!is_srq) {
+		attr->cap.max_recv_sge =
+			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_sge));
+		attr->cap.max_recv_wr =
+			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_wr));
+	} else {
+		attr->cap.max_recv_sge = 0;
+		attr->cap.max_recv_wr = 0;
+	}
+
 	qp = calloc(1, sizeof(*qp));
 	if (!qp)
 		return NULL;
 
-	qp->rq.max_gs = attr->cap.max_recv_sge;
-	qp->rq.wqe_cnt = attr->cap.max_recv_wr;
-	qp->rq.offset = 0;
-	qp->rq.wqe_size = align_next_power2(sizeof(struct pvrdma_rq_wqe_hdr) +
-					    sizeof(struct ibv_sge) *
-					    qp->rq.max_gs);
+	qp->is_srq = is_srq;
 
 	qp->sq.max_gs = attr->cap.max_send_sge;
 	qp->sq.wqe_cnt = attr->cap.max_send_wr;
@@ -133,10 +245,18 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 					    sizeof(struct ibv_sge) *
 					    qp->sq.max_gs);
 
-	/* Reset attr.cap, no srq for now */
-	if (attr->srq) {
-		attr->cap.max_recv_wr = 0;
+	if (!is_srq) {
+		qp->rq.max_gs = attr->cap.max_recv_sge;
+		qp->rq.wqe_cnt = attr->cap.max_recv_wr;
+		qp->rq.offset = 0;
+		qp->rq.wqe_size = align_next_power2(sizeof(struct pvrdma_rq_wqe_hdr) +
+						    sizeof(struct ibv_sge) *
+						    qp->rq.max_gs);
+	} else {
+		qp->rq.max_gs = 0;
 		qp->rq.wqe_cnt = 0;
+		qp->rq.offset = 0;
+		qp->rq.wqe_size = 0;
 	}
 
 	/* Allocate [rq][sq] memory */
@@ -144,18 +264,24 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 		goto err;
 
 	qp->sq.ring_state = qp->sbuf.buf;
-	qp->rq.ring_state = (struct pvrdma_ring *)&qp->sq.ring_state[1];
-	pvrdma_init_qp_queue(qp);
-
-	if (pthread_spin_init(&qp->sq.lock, PTHREAD_PROCESS_PRIVATE) ||
-	    pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
+	if (pthread_spin_init(&qp->sq.lock, PTHREAD_PROCESS_PRIVATE))
 		goto err_free;
 
+	if (!is_srq) {
+		qp->rq.ring_state = (struct pvrdma_ring *)&qp->sq.ring_state[1];
+		if (pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
+			goto err_free;
+	} else {
+		qp->rq.ring_state = NULL;
+	}
+
+	pvrdma_init_qp_queue(qp);
+
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.udata.rbuf_addr = (uintptr_t)qp->rbuf.buf;
-	cmd.udata.rbuf_size = qp->rbuf.length;
 	cmd.udata.sbuf_addr = (uintptr_t)qp->sbuf.buf;
 	cmd.udata.sbuf_size = qp->sbuf.length;
+	cmd.udata.rbuf_addr = (uintptr_t)qp->rbuf.buf;
+	cmd.udata.rbuf_size = qp->rbuf.length;
 	cmd.udata.qp_addr = (uintptr_t) qp;
 
 	ret = ibv_cmd_create_qp(pd, &qp->ibv_qp, attr,
@@ -240,9 +366,9 @@ static void pvrdma_lock_cqs(struct ibv_qp *qp)
 	struct pvrdma_cq *send_cq = to_vcq(qp->send_cq);
 	struct pvrdma_cq *recv_cq = to_vcq(qp->recv_cq);
 
-	if (send_cq == recv_cq)
+	if (send_cq == recv_cq) {
 		pthread_spin_lock(&send_cq->lock);
-	else if (send_cq->cqn < recv_cq->cqn) {
+	} else if (send_cq->cqn < recv_cq->cqn) {
 		pthread_spin_lock(&send_cq->lock);
 		pthread_spin_lock(&recv_cq->lock);
 	} else {
@@ -256,9 +382,9 @@ static void pvrdma_unlock_cqs(struct ibv_qp *qp)
 	struct pvrdma_cq *send_cq = to_vcq(qp->send_cq);
 	struct pvrdma_cq *recv_cq = to_vcq(qp->recv_cq);
 
-	if (send_cq == recv_cq)
+	if (send_cq == recv_cq) {
 		pthread_spin_unlock(&send_cq->lock);
-	else if (send_cq->cqn < recv_cq->cqn) {
+	} else if (send_cq->cqn < recv_cq->cqn) {
 		pthread_spin_unlock(&recv_cq->lock);
 		pthread_spin_unlock(&send_cq->lock);
 	} else {
@@ -296,6 +422,11 @@ int pvrdma_destroy_qp(struct ibv_qp *ibqp)
 	return 0;
 }
 
+static void *get_srq_wqe(struct pvrdma_srq *srq, int n)
+{
+	return srq->buf.buf + srq->offset + (n * srq->wqe_size);
+}
+
 static void *get_rq_wqe(struct pvrdma_qp *qp, int n)
 {
 	return qp->rbuf.buf + qp->rq.offset + (n * qp->rq.wqe_size);
@@ -438,6 +569,9 @@ int pvrdma_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	int i;
 	int ret = 0;
 
+	if (qp->is_srq)
+		return EINVAL;
+
 	if (!wr || !bad_wr)
 		return EINVAL;
 
@@ -503,3 +637,94 @@ out:
 	pthread_spin_unlock(&qp->rq.lock);
 	return ret;
 }
+
+int pvrdma_post_srq_recv(struct ibv_srq *ibsrq,
+			 struct ibv_recv_wr *wr,
+			 struct ibv_recv_wr **bad_wr)
+{
+	struct pvrdma_context *ctx = to_vctx(ibsrq->context);
+	struct pvrdma_srq *srq = to_vsrq(ibsrq);
+	struct pvrdma_rq_wqe_hdr *wqe_hdr;
+	struct ibv_sge *sge;
+	int nreq;
+	int ind;
+	int i;
+	int ret = 0;
+
+	if (!wr || !bad_wr)
+		return EINVAL;
+
+	pthread_spin_lock(&srq->lock);
+
+	ind = pvrdma_idx(&(srq->ring_state->rx.prod_tail), srq->wqe_cnt);
+	if (ind < 0) {
+		pthread_spin_unlock(&srq->lock);
+		*bad_wr = wr;
+		return EINVAL;
+	}
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		unsigned int tail;
+
+		if (pvrdma_idx_ring_has_space(&srq->ring_state->rx,
+					      srq->wqe_cnt, &tail) <= 0) {
+			ret = ENOMEM;
+			*bad_wr = wr;
+			break;
+		}
+
+		if (wr->num_sge > srq->max_gs) {
+			ret = EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		/* Fetch wqe */
+		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_srq_wqe(srq, ind);
+		wqe_hdr->wr_id = wr->wr_id;
+		wqe_hdr->num_sge = wr->num_sge;
+
+		sge = (struct ibv_sge *)(wqe_hdr + 1);
+		for (i = 0; i < wr->num_sge; ++i) {
+			sge->addr = (uint64_t)wr->sg_list[i].addr;
+			sge->length = wr->sg_list[i].length;
+			sge->lkey = wr->sg_list[i].lkey;
+			sge++;
+		}
+
+		pvrdma_idx_ring_inc(&srq->ring_state->rx.prod_tail,
+				    srq->wqe_cnt);
+
+		srq->wrid[ind] = wr->wr_id;
+		ind = (ind + 1) & (srq->wqe_cnt - 1);
+	}
+
+	if (nreq)
+		pvrdma_write_uar_srq(ctx->uar,
+				     PVRDMA_UAR_SRQ_RECV | srq->srqn);
+
+	pthread_spin_unlock(&srq->lock);
+
+	return ret;
+}
+
+int pvrdma_alloc_srq_buf(struct pvrdma_device *dev,
+			 struct ibv_srq_attr *attr,
+			 struct pvrdma_srq *srq)
+{
+	srq->wrid = calloc(srq->wqe_cnt, sizeof(uint64_t));
+	if (!srq->wrid)
+		return -1;
+
+	srq->buf.length = align(srq->offset, dev->page_size);
+	srq->buf.length += 2 * align(srq->wqe_cnt * srq->wqe_size, dev->page_size);
+
+	if (pvrdma_alloc_buf(&srq->buf, srq->buf.length, dev->page_size)) {
+		free(srq->wrid);
+		return -1;
+	}
+
+	memset(srq->buf.buf, 0, srq->buf.length);
+
+	return 0;
+}
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
