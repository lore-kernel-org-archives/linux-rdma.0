From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 4/6] libqedr: main
Date: Thu, 20 Oct 2016 12:49:10 +0300
Message-ID: <1476956952-17388-5-git-send-email-Ram.Amrani@cavium.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476956952-17388-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

Introducing main, responsible for initializing the driver
and allocating the user context.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h      | 320 +++++++++++++++++++++++++++++++++++++++++++++
 providers/qedr/qelr_main.c | 286 ++++++++++++++++++++++++++++++++++++++++
 providers/qedr/qelr_main.h |  83 ++++++++++++
 3 files changed, 689 insertions(+)
 create mode 100644 providers/qedr/qelr.h
 create mode 100644 providers/qedr/qelr_main.c
 create mode 100644 providers/qedr/qelr_main.h

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
new file mode 100644
index 0000000..e321195
--- /dev/null
+++ b/providers/qedr/qelr.h
@@ -0,0 +1,320 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#ifndef __QELR_H__
+#define __QELR_H__
+
+#include <inttypes.h>
+#include <stddef.h>
+#include <endian.h>
+#include <ccan/minmax.h>
+
+#include <infiniband/driver.h>
+#include <infiniband/arch.h>
+
+#define writel(b, p) (*(uint32_t *)(p) = (b))
+#define writeq(b, p) (*(uint64_t *)(p) = (b))
+
+#include "qelr_hsi.h"
+#include "qelr_chain.h"
+
+#define qelr_err(format, arg...) printf(format, ##arg)
+
+extern uint32_t qelr_dp_level;
+extern uint32_t qelr_dp_module;
+
+enum DP_MODULE {
+	QELR_MSG_CQ		= 0x10000,
+	QELR_MSG_RQ		= 0x20000,
+	QELR_MSG_SQ		= 0x40000,
+	QELR_MSG_QP		= (QELR_MSG_SQ | QELR_MSG_RQ),
+	QELR_MSG_MR		= 0x80000,
+	QELR_MSG_INIT		= 0x100000,
+	/* to be added...up to 0x8000000 */
+};
+
+enum DP_LEVEL {
+	QELR_LEVEL_VERBOSE	= 0x0,
+	QELR_LEVEL_INFO		= 0x1,
+	QELR_LEVEL_NOTICE	= 0x2,
+	QELR_LEVEL_ERR		= 0x3,
+};
+
+#define DP_ERR(fd, fmt, ...)					\
+do {								\
+	fprintf(fd, "[%s:%d]" fmt,				\
+		__func__, __LINE__,				\
+		##__VA_ARGS__);					\
+	fflush(fd); \
+} while (0)
+
+#define DP_NOTICE(fd, fmt, ...)					\
+do {								\
+	if (qelr_dp_level <= QELR_LEVEL_NOTICE)	{\
+		fprintf(fd, "[%s:%d]" fmt,			\
+		      __func__, __LINE__,			\
+		      ##__VA_ARGS__);				\
+		      fflush(fd); }				\
+} while (0)
+
+#define DP_INFO(fd, fmt, ...)					\
+do {								\
+	if (qelr_dp_level <= QELR_LEVEL_INFO)	{		\
+		fprintf(fd, "[%s:%d]" fmt,			\
+		      __func__, __LINE__,			\
+		      ##__VA_ARGS__); fflush(fd);		\
+	}							\
+} while (0)
+
+#define DP_VERBOSE(fd, module, fmt, ...)			\
+do {								\
+	if ((qelr_dp_level <= QELR_LEVEL_VERBOSE) &&		\
+		     (qelr_dp_module & (module))) {		\
+		fprintf(fd, "[%s:%d]" fmt,			\
+		      __func__, __LINE__,			\
+		      ##__VA_ARGS__);	fflush(fd); }		\
+} while (0)
+
+#define ROUND_UP_X(_val, _x) \
+	(((unsigned long)(_val) + ((_x)-1)) & (long)~((_x)-1))
+
+struct qelr_buf {
+	void		*addr;
+	size_t		len;		/* a 64 uint is used as s preparation
+					 * for double layer pbl.
+					 */
+};
+
+struct qelr_device {
+	struct ibv_device ibv_dev;
+};
+
+struct qelr_devctx {
+	struct ibv_context	ibv_ctx;
+	FILE			*dbg_fp;
+	void			*db_addr;
+	uint64_t		db_pa;
+	uint32_t		db_size;
+	uint8_t			disable_edpm;
+	uint32_t		kernel_page_size;
+
+	uint32_t		max_send_wr;
+	uint32_t		max_recv_wr;
+	uint32_t		sges_per_send_wr;
+	uint32_t		sges_per_recv_wr;
+	int			max_cqes;
+};
+
+struct qelr_pd {
+	struct ibv_pd		ibv_pd;
+	uint32_t		pd_id;
+};
+
+struct qelr_mr {
+	struct ibv_mr		ibv_mr;
+};
+
+union db_prod64 {
+	struct rdma_pwm_val32_data data;
+	uint64_t raw;
+};
+
+struct qelr_cq {
+	struct ibv_cq		ibv_cq;	/* must be first */
+
+	struct qelr_chain	chain;
+
+	void			*db_addr;
+	union db_prod64		db;
+
+	uint8_t			chain_toggle;
+	union rdma_cqe		*latest_cqe;
+	union rdma_cqe		*toggle_cqe;
+
+	uint8_t			arm_flags;
+};
+
+enum qelr_qp_state {
+	QELR_QPS_RST,
+	QELR_QPS_INIT,
+	QELR_QPS_RTR,
+	QELR_QPS_RTS,
+	QELR_QPS_SQD,
+	QELR_QPS_ERR,
+	QELR_QPS_SQE
+};
+
+union db_prod32 {
+	struct rdma_pwm_val16_data	data;
+	uint32_t			raw;
+};
+
+struct qelr_qp_hwq_info {
+	/* WQE */
+	struct qelr_chain			chain;
+	uint8_t					max_sges;
+
+	/* WQ */
+	uint16_t				prod;
+	uint16_t				wqe_cons;
+	uint16_t				cons;
+	uint16_t				max_wr;
+
+	/* DB */
+	void					*db;      /* Doorbell address */
+	void					*edpm_db;
+	union db_prod32				db_data;  /* Doorbell data */
+
+	uint16_t				icid;
+};
+
+struct qelr_rdma_ext {
+	uint64_t remote_va;
+	uint32_t remote_key;
+	uint32_t dma_length;
+};
+
+/* rdma extension, invalidate / immediate data + padding, inline data... */
+#define QELR_MAX_DPM_PAYLOAD (sizeof(struct qelr_rdma_ext) + sizeof(uint64_t) +\
+			       ROCE_REQ_MAX_INLINE_DATA_SIZE)
+struct qelr_edpm {
+	union {
+		struct db_roce_dpm_data	data;
+		uint64_t raw;
+	} msg;
+
+	uint8_t			dpm_payload[QELR_MAX_DPM_PAYLOAD];
+	uint32_t		dpm_payload_size;
+	uint32_t		dpm_payload_offset;
+	uint8_t			is_edpm;
+	struct qelr_rdma_ext    *rdma_ext;
+};
+
+struct qelr_qp {
+	struct ibv_qp				ibv_qp;
+	pthread_spinlock_t			q_lock;
+	enum qelr_qp_state			state;   /*  QP state */
+
+	struct qelr_qp_hwq_info			sq;
+	struct qelr_qp_hwq_info			rq;
+	struct {
+		uint64_t wr_id;
+		enum ibv_wc_opcode opcode;
+		uint32_t bytes_len;
+		uint8_t wqe_size;
+		uint8_t signaled;
+	} *wqe_wr_id;
+
+	struct {
+		uint64_t wr_id;
+		uint8_t wqe_size;
+	} *rqe_wr_id;
+
+	struct qelr_edpm			edpm;
+	uint8_t					prev_wqe_size;
+	uint32_t				max_inline_data;
+	uint32_t				qp_id;
+	int					sq_sig_all;
+	int					atomic_supported;
+
+};
+
+static inline struct qelr_devctx *get_qelr_ctx(struct ibv_context *ibctx)
+{
+	return container_of(ibctx, struct qelr_devctx, ibv_ctx);
+}
+
+static inline struct qelr_device *get_qelr_dev(struct ibv_device *ibdev)
+{
+	return container_of(ibdev, struct qelr_device, ibv_dev);
+}
+
+static inline struct qelr_qp *get_qelr_qp(struct ibv_qp *ibqp)
+{
+	return container_of(ibqp, struct qelr_qp, ibv_qp);
+}
+
+static inline struct qelr_pd *get_qelr_pd(struct ibv_pd *ibpd)
+{
+	return container_of(ibpd, struct qelr_pd, ibv_pd);
+}
+
+static inline struct qelr_cq *get_qelr_cq(struct ibv_cq *ibcq)
+{
+	return container_of(ibcq, struct qelr_cq, ibv_cq);
+}
+
+#define SET_FIELD(value, name, flag)				\
+	do {							\
+		(value) &= ~(name ## _MASK << name ## _SHIFT);	\
+		(value) |= ((flag) << (name ## _SHIFT));	\
+	} while (0)
+
+#define SET_FIELD2(value, name, flag)				\
+		((value) |= ((flag) << (name ## _SHIFT)))
+
+#define GET_FIELD(value, name) \
+	(((value) >> (name ## _SHIFT)) & name ## _MASK)
+
+#define ROCE_WQE_ELEM_SIZE	sizeof(struct rdma_sq_sge)
+
+#define QELR_RESP_IMM (RDMA_CQE_RESPONDER_IMM_FLG_MASK <<	\
+			RDMA_CQE_RESPONDER_IMM_FLG_SHIFT)
+#define QELR_RESP_RDMA (RDMA_CQE_RESPONDER_RDMA_FLG_MASK <<	\
+			RDMA_CQE_RESPONDER_RDMA_FLG_SHIFT)
+#define QELR_RESP_RDMA_IMM (QELR_RESP_IMM | QELR_RESP_RDMA)
+
+#define round_up(_val, _x) \
+	(((unsigned long)(_val) + ((_x)-1)) & (long)~((_x)-1))
+
+#define TYPEPTR_ADDR_SET(type_ptr, field, vaddr)			\
+	do {								\
+		(type_ptr)->field.hi = htole32(U64_HI(vaddr));	\
+		(type_ptr)->field.lo = htole32(U64_LO(vaddr));	\
+	} while (0)
+
+#define RQ_SGE_SET(sge, vaddr, vlength, vflags)			\
+	do {							\
+		TYPEPTR_ADDR_SET(sge, addr, vaddr);		\
+		(sge)->length = htole32(vlength);		\
+		(sge)->flags = htole32(vflags);		\
+	} while (0)
+
+#define U64_HI(val) ((uint32_t)(((uint64_t)(val)) >> 32))
+#define U64_LO(val) ((uint32_t)(((uint64_t)(val)) & 0xffffffff))
+#define HILO_U64(hi, lo)		((((uint64_t)(hi)) << 32) + (lo))
+
+#define QELR_MAX_RQ_WQE_SIZE (RDMA_MAX_SGE_PER_RQ_WQE)
+#define QELR_MAX_SQ_WQE_SIZE (ROCE_REQ_MAX_SINGLE_SQ_WQE_SIZE /	\
+			      ROCE_WQE_ELEM_SIZE)
+
+#endif /* __QELR_H__ */
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
new file mode 100644
index 0000000..386d7e6
--- /dev/null
+++ b/providers/qedr/qelr_main.c
@@ -0,0 +1,286 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#include <config.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <pthread.h>
+
+#include "qelr.h"
+#include "qelr_main.h"
+#include "qelr_abi.h"
+#include "qelr_chain.h"
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#define PCI_VENDOR_ID_QLOGIC           (0x1077)
+#define PCI_DEVICE_ID_QLOGIC_57980S    (0x1629)
+#define PCI_DEVICE_ID_QLOGIC_57980S_40 (0x1634)
+#define PCI_DEVICE_ID_QLOGIC_57980S_10 (0x1666)
+#define PCI_DEVICE_ID_QLOGIC_57980S_MF (0x1636)
+#define PCI_DEVICE_ID_QLOGIC_57980S_100 (0x1644)
+#define PCI_DEVICE_ID_QLOGIC_57980S_50  (0x1654)
+#define PCI_DEVICE_ID_QLOGIC_57980S_25  (0x1656)
+#define PCI_DEVICE_ID_QLOGIC_57980S_IOV (0x1664)
+#define PCI_DEVICE_ID_QLOGIC_AH_50G     (0x8070)
+#define PCI_DEVICE_ID_QLOGIC_AH_10G     (0x8071)
+#define PCI_DEVICE_ID_QLOGIC_AH_40G     (0x8072)
+#define PCI_DEVICE_ID_QLOGIC_AH_25G     (0x8073)
+#define PCI_DEVICE_ID_QLOGIC_AH_IOV     (0x8090)
+
+uint32_t qelr_dp_level;
+uint32_t qelr_dp_module;
+
+#define QHCA(d)					\
+	{ .vendor = PCI_VENDOR_ID_QLOGIC,	\
+	  .device = PCI_DEVICE_ID_QLOGIC_##d }
+
+struct {
+	unsigned int vendor;
+	unsigned int device;
+} hca_table[] = {
+	QHCA(57980S),
+	QHCA(57980S_40),
+	QHCA(57980S_10),
+	QHCA(57980S_MF),
+	QHCA(57980S_100),
+	QHCA(57980S_50),
+	QHCA(57980S_25),
+	QHCA(57980S_IOV),
+	QHCA(AH_50G),
+	QHCA(AH_10G),
+	QHCA(AH_40G),
+	QHCA(AH_25G),
+	QHCA(AH_IOV),
+};
+
+static struct ibv_context *qelr_alloc_context(struct ibv_device *, int);
+static void qelr_free_context(struct ibv_context *);
+
+static struct ibv_context_ops qelr_ctx_ops = {
+	.query_device = qelr_query_device,
+	.query_port = qelr_query_port,
+	.alloc_pd = qelr_alloc_pd,
+	.dealloc_pd = qelr_dealloc_pd,
+	.reg_mr = qelr_reg_mr,
+	.dereg_mr = qelr_dereg_mr,
+	.create_cq = qelr_create_cq,
+	.poll_cq = qelr_poll_cq,
+	.req_notify_cq = qelr_arm_cq,
+	.cq_event = qelr_cq_event,
+	.destroy_cq = qelr_destroy_cq,
+	.create_qp = qelr_create_qp,
+	.query_qp = qelr_query_qp,
+	.modify_qp = qelr_modify_qp,
+	.destroy_qp = qelr_destroy_qp,
+	.post_send = qelr_post_send,
+	.post_recv = qelr_post_recv,
+	.async_event = qelr_async_event,
+};
+
+static struct ibv_device_ops qelr_dev_ops = {
+	.alloc_context = qelr_alloc_context,
+	.free_context = qelr_free_context
+};
+
+static void qelr_open_debug_file(struct qelr_devctx *ctx)
+{
+	char *env;
+
+	env = getenv("QELR_DEBUG_FILE");
+	if (!env) {
+		ctx->dbg_fp = stderr;
+		DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT,
+			   "Debug file opened: stderr\n");
+		return;
+	}
+
+	ctx->dbg_fp = fopen(env, "aw+");
+	if (!ctx->dbg_fp) {
+		fprintf(stderr, "Failed opening debug file %s, using stderr\n",
+			env);
+		ctx->dbg_fp = stderr;
+		DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT,
+			   "Debug file opened: stderr\n");
+		return;
+	}
+
+	DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT, "Debug file opened: %s\n", env);
+}
+
+static void qelr_close_debug_file(struct qelr_devctx *ctx)
+{
+	if (ctx->dbg_fp && ctx->dbg_fp != stderr)
+		fclose(ctx->dbg_fp);
+}
+
+static void qelr_set_debug_mask(void)
+{
+	char *env;
+
+	qelr_dp_level = QELR_LEVEL_NOTICE;
+	qelr_dp_module = 0;
+
+	env = getenv("QELR_DP_LEVEL");
+	if (env)
+		qelr_dp_level = atoi(env);
+
+	env = getenv("QELR_DP_MODULE");
+	if (env)
+		qelr_dp_module = atoi(env);
+}
+
+static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
+					      int cmd_fd)
+{
+	struct qelr_devctx *ctx;
+	struct qelr_get_context cmd;
+	struct qelr_alloc_ucontext_resp resp;
+
+	ctx = calloc(1, sizeof(struct qelr_devctx));
+	if (!ctx)
+		return NULL;
+	memset(&resp, 0, sizeof(resp));
+
+	ctx->ibv_ctx.cmd_fd = cmd_fd;
+
+	qelr_open_debug_file(ctx);
+	qelr_set_debug_mask();
+
+	if (ibv_cmd_get_context(&ctx->ibv_ctx,
+				(struct ibv_get_context *)&cmd, sizeof(cmd),
+				&resp.ibv_resp, sizeof(resp)))
+		goto cmd_err;
+
+	ctx->kernel_page_size = sysconf(_SC_PAGESIZE);
+	ctx->ibv_ctx.device = ibdev;
+	ctx->ibv_ctx.ops = qelr_ctx_ops;
+	ctx->db_pa = resp.db_pa;
+	ctx->db_size = resp.db_size;
+	ctx->max_send_wr = resp.max_send_wr;
+	ctx->max_recv_wr = resp.max_recv_wr;
+	ctx->sges_per_send_wr = resp.sges_per_send_wr;
+	ctx->sges_per_recv_wr = resp.sges_per_recv_wr;
+	ctx->max_cqes = resp.max_cqes;
+
+	ctx->db_addr = mmap(NULL, ctx->db_size, PROT_WRITE, MAP_SHARED,
+			    cmd_fd, ctx->db_pa);
+
+	if (ctx->db_addr == MAP_FAILED) {
+		int errsv = errno;
+
+		DP_ERR(ctx->dbg_fp,
+		       "alloc context: doorbell mapping failed resp.db_pa = %llx resp.db_size=%d context->cmd_fd=%d errno=%d\n",
+		       resp.db_pa, resp.db_size, cmd_fd, errsv);
+		goto cmd_err;
+	}
+
+	return &ctx->ibv_ctx;
+
+cmd_err:
+	qelr_err("%s: Failed to allocate context for device.\n", __func__);
+	qelr_close_debug_file(ctx);
+	free(ctx);
+	return NULL;
+}
+
+static void qelr_free_context(struct ibv_context *ibctx)
+{
+	struct qelr_devctx *ctx = get_qelr_ctx(ibctx);
+
+	if (ctx->db_addr)
+		munmap(ctx->db_addr, ctx->db_size);
+
+	qelr_close_debug_file(ctx);
+	free(ctx);
+}
+
+struct ibv_device *qelr_driver_init(const char *uverbs_sys_path,
+				    int abi_version)
+{
+	char value[16];
+	struct qelr_device *dev;
+	unsigned int vendor, device;
+	int i;
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
+				value, sizeof(value)) < 0)
+		return NULL;
+
+	sscanf(value, "%i", &vendor);
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
+				value, sizeof(value)) < 0)
+		return NULL;
+
+	sscanf(value, "%i", &device);
+
+	for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i)
+		if (vendor == hca_table[i].vendor &&
+		    device == hca_table[i].device)
+			goto found;
+
+	return NULL;
+found:
+	if (abi_version != QELR_ABI_VERSION) {
+		fprintf(stderr,
+			"Fatal: libqedr ABI version %d of %s is not supported.\n",
+			abi_version, uverbs_sys_path);
+		return NULL;
+	}
+
+	dev = malloc(sizeof(*dev));
+	if (!dev) {
+		qelr_err("%s() Fatal: fail allocate device for libqedr\n",
+			 __func__);
+		return NULL;
+	}
+
+	bzero(dev, sizeof(*dev));
+
+	dev->ibv_dev.ops = qelr_dev_ops;
+
+	return &dev->ibv_dev;
+}
+
+static __attribute__ ((constructor))
+void qelr_register_driver(void)
+{
+	ibv_register_driver("qelr", qelr_driver_init);
+}
diff --git a/providers/qedr/qelr_main.h b/providers/qedr/qelr_main.h
new file mode 100644
index 0000000..1f65be6
--- /dev/null
+++ b/providers/qedr/qelr_main.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2015-2016  QLogic Corporation
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
+ *        disclaimer in the documentation and /or other materials
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
+#ifndef __QELR_MAIN_H__
+#define __QELR_MAIN_H__
+
+#include <inttypes.h>
+#include <stddef.h>
+#include <endian.h>
+
+#include <infiniband/driver.h>
+#include <infiniband/arch.h>
+
+struct ibv_device *qelr_driver_init(const char *, int);
+
+int qelr_query_device(struct ibv_context *, struct ibv_device_attr *);
+int qelr_query_port(struct ibv_context *, uint8_t, struct ibv_port_attr *);
+
+struct ibv_pd *qelr_alloc_pd(struct ibv_context *);
+int qelr_dealloc_pd(struct ibv_pd *);
+
+struct ibv_mr *qelr_reg_mr(struct ibv_pd *, void *, size_t,
+			   int ibv_access_flags);
+int qelr_dereg_mr(struct ibv_mr *);
+
+struct ibv_cq *qelr_create_cq(struct ibv_context *, int,
+			      struct ibv_comp_channel *, int);
+int qelr_destroy_cq(struct ibv_cq *);
+int qelr_poll_cq(struct ibv_cq *, int, struct ibv_wc *);
+void qelr_cq_event(struct ibv_cq *);
+int qelr_arm_cq(struct ibv_cq *, int);
+
+int qelr_query_srq(struct ibv_srq *ibv_srq, struct ibv_srq_attr *attr);
+int qelr_modify_srq(struct ibv_srq *ibv_srq, struct ibv_srq_attr *attr,
+		    int attr_mask);
+struct ibv_srq *qelr_create_srq(struct ibv_pd *, struct ibv_srq_init_attr *);
+int qelr_destroy_srq(struct ibv_srq *ibv_srq);
+int qelr_post_srq_recv(struct ibv_srq *, struct ibv_recv_wr *,
+		       struct ibv_recv_wr **bad_wr);
+
+struct ibv_qp *qelr_create_qp(struct ibv_pd *, struct ibv_qp_init_attr *);
+int qelr_modify_qp(struct ibv_qp *, struct ibv_qp_attr *,
+		   int ibv_qp_attr_mask);
+int qelr_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask,
+		  struct ibv_qp_init_attr *init_attr);
+int qelr_destroy_qp(struct ibv_qp *);
+
+int qelr_post_send(struct ibv_qp *, struct ibv_send_wr *,
+		   struct ibv_send_wr **);
+int qelr_post_recv(struct ibv_qp *, struct ibv_recv_wr *,
+		   struct ibv_recv_wr **);
+
+void qelr_async_event(struct ibv_async_event *event);
+#endif /* __QELR_MAIN_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
