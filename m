From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 rdma-core 4/7] libhns: Add verbs of cq support
Date: Thu, 10 Nov 2016 20:46:14 +0800
Message-ID: <1478781977-116803-5-git-send-email-oulijun@huawei.com>
References: <1478781977-116803-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478781977-116803-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly introduces the relatived cq verbs for userspace
of hns, include:
    1. create_cq
    2. poll_cq
    3. req_notify_cq
    4. cq_event
    5. destroy_cq

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v3:
-  No change over the v2

v2:
- Delete the unused code

v1:
- The initial submit
---
 providers/hns/hns_roce_u.c       |  57 +++++-
 providers/hns/hns_roce_u.h       |  94 ++++++++++
 providers/hns/hns_roce_u_abi.h   |  12 ++
 providers/hns/hns_roce_u_buf.c   |  61 +++++++
 providers/hns/hns_roce_u_db.h    |  54 ++++++
 providers/hns/hns_roce_u_hw_v1.c | 370 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v1.h | 163 +++++++++++++++++
 providers/hns/hns_roce_u_verbs.c | 116 ++++++++++++
 8 files changed, 922 insertions(+), 5 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_buf.c
 create mode 100644 providers/hns/hns_roce_u_db.h
 create mode 100644 providers/hns/hns_roce_u_hw_v1.c
 create mode 100644 providers/hns/hns_roce_u_hw_v1.h

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 53e2720..e435bea 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -46,15 +46,19 @@
 
 static const struct {
 	char	 hid[HID_LEN];
+	void	 *data;
+	int	 version;
 } acpi_table[] = {
-	{"acpi:HISI00D1:"},
-	{},
+	 {"acpi:HISI00D1:", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
+	 {},
 };
 
 static const struct {
 	char	 compatible[DEV_MATCH_LEN];
+	void	 *data;
+	int	 version;
 } dt_table[] = {
-	{"hisilicon,hns-roce-v1"},
+	{"hisilicon,hns-roce-v1", &hns_roce_u_hw_v1, HNS_ROCE_HW_VER1},
 	{},
 };
 
@@ -93,6 +97,21 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 		goto err_free;
 	}
 
+	if (hr_dev->hw_version == HNS_ROCE_HW_VER1) {
+		/*
+		 * when vma->vm_pgoff is 1, the cq_tptr_base includes 64K CQ,
+		 * a pointer of CQ need 2B size
+		 */
+		context->cq_tptr_base = mmap(NULL, HNS_ROCE_CQ_DB_BUF_SIZE,
+					     PROT_READ | PROT_WRITE, MAP_SHARED,
+					     cmd_fd, HNS_ROCE_TPTR_OFFSET);
+		if (context->cq_tptr_base == MAP_FAILED) {
+			fprintf(stderr,
+				PFX "Warning: Failed to mmap cq_tptr page.\n");
+			goto db_free;
+		}
+	}
+
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
 	context->ibv_ctx.ops.query_device  = hns_roce_u_query_device;
@@ -102,6 +121,12 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	context->ibv_ctx.ops.reg_mr	   = hns_roce_u_reg_mr;
 	context->ibv_ctx.ops.dereg_mr	   = hns_roce_u_dereg_mr;
 
+	context->ibv_ctx.ops.create_cq     = hns_roce_u_create_cq;
+	context->ibv_ctx.ops.poll_cq	   = hr_dev->u_hw->poll_cq;
+	context->ibv_ctx.ops.req_notify_cq = hr_dev->u_hw->arm_cq;
+	context->ibv_ctx.ops.cq_event	   = hns_roce_u_cq_event;
+	context->ibv_ctx.ops.destroy_cq    = hns_roce_u_destroy_cq;
+
 	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
 		goto tptr_free;
 
@@ -112,6 +137,16 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	return &context->ibv_ctx;
 
 tptr_free:
+	if (hr_dev->hw_version == HNS_ROCE_HW_VER1) {
+		if (munmap(context->cq_tptr_base, HNS_ROCE_CQ_DB_BUF_SIZE))
+			fprintf(stderr, PFX "Warning: Munmap tptr failed.\n");
+			context->cq_tptr_base = NULL;
+	}
+
+db_free:
+	munmap(context->uar, to_hr_dev(ibdev)->page_size);
+	context->uar = NULL;
+
 err_free:
 	free(context);
 	return NULL;
@@ -122,6 +157,8 @@ static void hns_roce_free_context(struct ibv_context *ibctx)
 	struct hns_roce_context *context = to_hr_ctx(ibctx);
 
 	munmap(context->uar, to_hr_dev(ibctx->device)->page_size);
+	if (to_hr_dev(ibctx->device)->hw_version == HNS_ROCE_HW_VER1)
+		munmap(context->cq_tptr_base, HNS_ROCE_CQ_DB_BUF_SIZE);
 
 	context->uar = NULL;
 
@@ -140,18 +177,26 @@ static struct ibv_device *hns_roce_driver_init(const char *uverbs_sys_path,
 	struct hns_roce_device  *dev;
 	char			 value[128];
 	int			 i;
+	void			 *u_hw;
+	int			 hw_version;
 
 	if (ibv_read_sysfs_file(uverbs_sys_path, "device/modalias",
 				value, sizeof(value)) > 0)
 		for (i = 0; i < sizeof(acpi_table) / sizeof(acpi_table[0]); ++i)
-			if (!strcmp(value, acpi_table[i].hid))
+			if (!strcmp(value, acpi_table[i].hid)) {
+				u_hw = acpi_table[i].data;
+				hw_version = acpi_table[i].version;
 				goto found;
+			}
 
 	if (ibv_read_sysfs_file(uverbs_sys_path, "device/of_node/compatible",
 				value, sizeof(value)) > 0)
 		for (i = 0; i < sizeof(dt_table) / sizeof(dt_table[0]); ++i)
-			if (!strcmp(value, dt_table[i].compatible))
+			if (!strcmp(value, dt_table[i].compatible)) {
+				u_hw = dt_table[i].data;
+				hw_version = dt_table[i].version;
 				goto found;
+			}
 
 	return NULL;
 
@@ -164,6 +209,8 @@ found:
 	}
 
 	dev->ibv_dev.ops = hns_roce_dev_ops;
+	dev->u_hw = (struct hns_roce_u_hw *)u_hw;
+	dev->hw_version = hw_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	return &dev->ibv_dev;
 }
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 5b73794..c3e364d 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -40,18 +40,53 @@
 #include <infiniband/verbs.h>
 #include <ccan/container_of.h>
 
+#define HNS_ROCE_CQE_ENTRY_SIZE		0x20
+
+#define HNS_ROCE_MAX_CQ_NUM		0x10000
+#define HNS_ROCE_MIN_CQE_NUM		0x40
+#define HNS_ROCE_CQ_DB_BUF_SIZE		((HNS_ROCE_MAX_CQ_NUM >> 11) << 12)
+#define HNS_ROCE_TPTR_OFFSET		0x1000
 #define HNS_ROCE_HW_VER1		('h' << 24 | 'i' << 16 | '0' << 8 | '6')
 
 #define PFX				"hns: "
 
+#define roce_get_field(origin, mask, shift) \
+	(((origin) & (mask)) >> (shift))
+
+#define roce_get_bit(origin, shift) \
+	roce_get_field((origin), (1ul << (shift)), (shift))
+
+#define roce_set_field(origin, mask, shift, val) \
+	do { \
+		(origin) &= (~(mask)); \
+		(origin) |= (((unsigned int)(val) << (shift)) & (mask)); \
+	} while (0)
+
+#define roce_set_bit(origin, shift, val) \
+	roce_set_field((origin), (1ul << (shift)), (shift), (val))
+
 enum {
 	HNS_ROCE_QP_TABLE_BITS		= 8,
 	HNS_ROCE_QP_TABLE_SIZE		= 1 << HNS_ROCE_QP_TABLE_BITS,
 };
 
+/* operation type list */
+enum {
+	/* rq&srq operation */
+	HNS_ROCE_OPCODE_SEND_DATA_RECEIVE         = 0x06,
+	HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE     = 0x07,
+};
+
 struct hns_roce_device {
 	struct ibv_device		ibv_dev;
 	int				page_size;
+	struct hns_roce_u_hw		*u_hw;
+	int				hw_version;
+};
+
+struct hns_roce_buf {
+	void				*buf;
+	unsigned int			length;
 };
 
 struct hns_roce_context {
@@ -59,7 +94,10 @@ struct hns_roce_context {
 	void				*uar;
 	pthread_spinlock_t		uar_lock;
 
+	void				*cq_tptr_base;
+
 	struct {
+		struct hns_roce_qp	**table;
 		int			refcnt;
 	} qp_table[HNS_ROCE_QP_TABLE_SIZE];
 
@@ -78,6 +116,44 @@ struct hns_roce_pd {
 	unsigned int			pdn;
 };
 
+struct hns_roce_cq {
+	struct ibv_cq			ibv_cq;
+	struct hns_roce_buf		buf;
+	pthread_spinlock_t		lock;
+	unsigned int			cqn;
+	unsigned int			cq_depth;
+	unsigned int			cons_index;
+	unsigned int			*set_ci_db;
+	unsigned int			*arm_db;
+	int				arm_sn;
+};
+
+struct hns_roce_wq {
+	unsigned long			*wrid;
+	unsigned int			wqe_cnt;
+	unsigned int			tail;
+	int				wqe_shift;
+	int				offset;
+};
+
+struct hns_roce_qp {
+	struct ibv_qp			ibv_qp;
+	struct hns_roce_buf		buf;
+	unsigned int			sq_signal_bits;
+	struct hns_roce_wq		sq;
+	struct hns_roce_wq		rq;
+};
+
+struct hns_roce_u_hw {
+	int (*poll_cq)(struct ibv_cq *ibvcq, int ne, struct ibv_wc *wc);
+	int (*arm_cq)(struct ibv_cq *ibvcq, int solicited);
+};
+
+static inline unsigned long align(unsigned long val, unsigned long align)
+{
+	return (val + align - 1) & ~(align - 1);
+}
+
 static inline struct hns_roce_device *to_hr_dev(struct ibv_device *ibv_dev)
 {
 	return container_of(ibv_dev, struct hns_roce_device, ibv_dev);
@@ -93,6 +169,11 @@ static inline struct hns_roce_pd *to_hr_pd(struct ibv_pd *ibv_pd)
 	return container_of(ibv_pd, struct hns_roce_pd, ibv_pd);
 }
 
+static inline struct hns_roce_cq *to_hr_cq(struct ibv_cq *ibv_cq)
+{
+	return container_of(ibv_cq, struct hns_roce_cq, ibv_cq);
+}
+
 int hns_roce_u_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr);
 int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
@@ -105,4 +186,17 @@ struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 				 int access);
 int hns_roce_u_dereg_mr(struct ibv_mr *mr);
 
+struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
+				    struct ibv_comp_channel *channel,
+				    int comp_vector);
+
+int hns_roce_u_destroy_cq(struct ibv_cq *cq);
+void hns_roce_u_cq_event(struct ibv_cq *cq);
+
+int hns_roce_alloc_buf(struct hns_roce_buf *buf, unsigned int size,
+		       int page_size);
+void hns_roce_free_buf(struct hns_roce_buf *buf);
+
+extern struct hns_roce_u_hw hns_roce_u_hw_v1;
+
 #endif /* _HNS_ROCE_U_H */
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index 0a0cd0c..1e62a7e 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -46,4 +46,16 @@ struct hns_roce_alloc_pd_resp {
 	__u32				reserved;
 };
 
+struct hns_roce_create_cq {
+	struct ibv_create_cq		ibv_cmd;
+	__u64				buf_addr;
+	__u64				db_addr;
+};
+
+struct hns_roce_create_cq_resp {
+	struct ibv_create_cq_resp	ibv_resp;
+	__u32				cqn;
+	__u32				reserved;
+};
+
 #endif /* _HNS_ROCE_U_ABI_H */
diff --git a/providers/hns/hns_roce_u_buf.c b/providers/hns/hns_roce_u_buf.c
new file mode 100644
index 0000000..f92ea65
--- /dev/null
+++ b/providers/hns/hns_roce_u_buf.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#include <errno.h>
+#include <sys/mman.h>
+
+#include "hns_roce_u.h"
+
+int hns_roce_alloc_buf(struct hns_roce_buf *buf, unsigned int size,
+		       int page_size)
+{
+	int ret;
+
+	buf->length = align(size, page_size);
+	buf->buf = mmap(NULL, buf->length, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (buf->buf == MAP_FAILED)
+		return errno;
+
+	ret = ibv_dontfork_range(buf->buf, size);
+	if (ret)
+		munmap(buf->buf, buf->length);
+
+	return ret;
+}
+
+void hns_roce_free_buf(struct hns_roce_buf *buf)
+{
+	ibv_dofork_range(buf->buf, buf->length);
+
+	munmap(buf->buf, buf->length);
+}
diff --git a/providers/hns/hns_roce_u_db.h b/providers/hns/hns_roce_u_db.h
new file mode 100644
index 0000000..76d13ce
--- /dev/null
+++ b/providers/hns/hns_roce_u_db.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#include <linux/types.h>
+
+#include "hns_roce_u.h"
+
+#ifndef _HNS_ROCE_U_DB_H
+#define _HNS_ROCE_U_DB_H
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define HNS_ROCE_PAIR_TO_64(val) ((uint64_t) val[1] << 32 | val[0])
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define HNS_ROCE_PAIR_TO_64(val) ((uint64_t) val[0] << 32 | val[1])
+#else
+#error __BYTE_ORDER not defined
+#endif
+
+static inline void hns_roce_write64(uint32_t val[2],
+				    struct hns_roce_context *ctx, int offset)
+{
+	*(volatile uint64_t *) (ctx->uar + offset) = HNS_ROCE_PAIR_TO_64(val);
+}
+
+#endif /* _HNS_ROCE_U_DB_H */
diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
new file mode 100644
index 0000000..2676021
--- /dev/null
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#include <stdio.h>
+#include <string.h>
+#include <malloc.h>
+#include "hns_roce_u_db.h"
+#include "hns_roce_u_hw_v1.h"
+#include "hns_roce_u.h"
+
+static void hns_roce_update_cq_cons_index(struct hns_roce_context *ctx,
+					  struct hns_roce_cq *cq)
+{
+	struct hns_roce_cq_db cq_db;
+
+	cq_db.u32_4 = 0;
+	cq_db.u32_8 = 0;
+
+	roce_set_bit(cq_db.u32_8, CQ_DB_U32_8_HW_SYNC_S, 1);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CMD_M, CQ_DB_U32_8_CMD_S, 3);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CMD_MDF_M,
+		       CQ_DB_U32_8_CMD_MDF_S, 0);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CQN_M, CQ_DB_U32_8_CQN_S,
+		       cq->cqn);
+	roce_set_field(cq_db.u32_4, CQ_DB_U32_4_CONS_IDX_M,
+		       CQ_DB_U32_4_CONS_IDX_S,
+		       cq->cons_index & ((cq->cq_depth << 1) - 1));
+
+	hns_roce_write64((uint32_t *)&cq_db, ctx, ROCEE_DB_OTHERS_L_0_REG);
+}
+
+static void hns_roce_handle_error_cqe(struct hns_roce_cqe *cqe,
+				      struct ibv_wc *wc)
+{
+	switch (roce_get_field(cqe->cqe_byte_4,
+			       CQE_BYTE_4_STATUS_OF_THE_OPERATION_M,
+			       CQE_BYTE_4_STATUS_OF_THE_OPERATION_S) &
+		HNS_ROCE_CQE_STATUS_MASK) {
+		fprintf(stderr, PFX "error cqe!\n");
+	case HNS_ROCE_CQE_SYNDROME_LOCAL_LENGTH_ERR:
+		wc->status = IBV_WC_LOC_LEN_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_LOCAL_QP_OP_ERR:
+		wc->status = IBV_WC_LOC_QP_OP_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_LOCAL_PROT_ERR:
+		wc->status = IBV_WC_LOC_PROT_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_WR_FLUSH_ERR:
+		wc->status = IBV_WC_WR_FLUSH_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_MEM_MANAGE_OPERATE_ERR:
+		wc->status = IBV_WC_MW_BIND_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_BAD_RESP_ERR:
+		wc->status = IBV_WC_BAD_RESP_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_LOCAL_ACCESS_ERR:
+		wc->status = IBV_WC_LOC_ACCESS_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
+		wc->status = IBV_WC_REM_INV_REQ_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_REMOTE_ACCESS_ERR:
+		wc->status = IBV_WC_REM_ACCESS_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_REMOTE_OP_ERR:
+		wc->status = IBV_WC_REM_OP_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
+		wc->status = IBV_WC_RETRY_EXC_ERR;
+		break;
+	case HNS_ROCE_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
+		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
+		break;
+	default:
+		wc->status = IBV_WC_GENERAL_ERR;
+		break;
+	}
+}
+
+static struct hns_roce_cqe *get_cqe(struct hns_roce_cq *cq, int entry)
+{
+	return cq->buf.buf + entry * HNS_ROCE_CQE_ENTRY_SIZE;
+}
+
+static void *get_sw_cqe(struct hns_roce_cq *cq, int n)
+{
+	struct hns_roce_cqe *cqe = get_cqe(cq, n & cq->ibv_cq.cqe);
+
+	return (!!(roce_get_bit(cqe->cqe_byte_4, CQE_BYTE_4_OWNER_S)) ^
+		!!(n & (cq->ibv_cq.cqe + 1))) ? cqe : NULL;
+}
+
+static struct hns_roce_cqe *next_cqe_sw(struct hns_roce_cq *cq)
+{
+	return get_sw_cqe(cq, cq->cons_index);
+}
+
+static void *get_send_wqe(struct hns_roce_qp *qp, int n)
+{
+	if ((n < 0) || (n > qp->sq.wqe_cnt)) {
+		printf("sq wqe index:%d,sq wqe cnt:%d\r\n", n, qp->sq.wqe_cnt);
+		return NULL;
+	}
+
+	return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
+				  (n << qp->sq.wqe_shift));
+}
+
+static struct hns_roce_qp *hns_roce_find_qp(struct hns_roce_context *ctx,
+					    uint32_t qpn)
+{
+	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
+
+	if (ctx->qp_table[tind].refcnt) {
+		return ctx->qp_table[tind].table[qpn & ctx->qp_table_mask];
+	} else {
+		printf("hns_roce_find_qp fail!\n");
+		return NULL;
+	}
+}
+
+static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
+				struct hns_roce_qp **cur_qp, struct ibv_wc *wc)
+{
+	uint32_t qpn;
+	int is_send;
+	uint16_t wqe_ctr;
+	uint32_t local_qpn;
+	struct hns_roce_wq *wq = NULL;
+	struct hns_roce_cqe *cqe = NULL;
+	struct hns_roce_wqe_ctrl_seg *sq_wqe = NULL;
+
+	/* According to CI, find the relative cqe */
+	cqe = next_cqe_sw(cq);
+	if (!cqe)
+		return CQ_EMPTY;
+
+	/* Get the next cqe, CI will be added gradually */
+	++cq->cons_index;
+
+	rmb();
+
+	qpn = roce_get_field(cqe->cqe_byte_16, CQE_BYTE_16_LOCAL_QPN_M,
+			     CQE_BYTE_16_LOCAL_QPN_S);
+
+	is_send = (roce_get_bit(cqe->cqe_byte_4, CQE_BYTE_4_SQ_RQ_FLAG_S) ==
+		   HNS_ROCE_CQE_IS_SQ);
+
+	local_qpn = roce_get_field(cqe->cqe_byte_16, CQE_BYTE_16_LOCAL_QPN_M,
+				   CQE_BYTE_16_LOCAL_QPN_S);
+
+	/* if qp is zero, it will not get the correct qpn */
+	if (!*cur_qp ||
+	    (local_qpn & HNS_ROCE_CQE_QPN_MASK) != (*cur_qp)->ibv_qp.qp_num) {
+
+		*cur_qp = hns_roce_find_qp(to_hr_ctx(cq->ibv_cq.context),
+					   qpn & 0xffffff);
+		if (!*cur_qp) {
+			fprintf(stderr, PFX "can't find qp!\n");
+			return CQ_POLL_ERR;
+		}
+	}
+	wc->qp_num = qpn & 0xffffff;
+
+	if (is_send) {
+		wq = &(*cur_qp)->sq;
+		/*
+		 * if sq_signal_bits is 1, the tail pointer first update to
+		 * the wqe corresponding the current cqe
+		 */
+		if ((*cur_qp)->sq_signal_bits) {
+			wqe_ctr = (uint16_t)(roce_get_field(cqe->cqe_byte_4,
+						CQE_BYTE_4_WQE_INDEX_M,
+						CQE_BYTE_4_WQE_INDEX_S));
+			/*
+			 * wq->tail will plus a positive number every time,
+			 * when wq->tail exceeds 32b, it is 0 and acc
+			 */
+			wq->tail += (wqe_ctr - (uint16_t) wq->tail) &
+				    (wq->wqe_cnt - 1);
+		}
+		/* write the wr_id of wq into the wc */
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		++wq->tail;
+	} else {
+		wq = &(*cur_qp)->rq;
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		++wq->tail;
+	}
+
+	/*
+	 * HW maintains wc status, set the err type and directly return, after
+	 * generated the incorrect CQE
+	 */
+	if (roce_get_field(cqe->cqe_byte_4,
+	    CQE_BYTE_4_STATUS_OF_THE_OPERATION_M,
+	    CQE_BYTE_4_STATUS_OF_THE_OPERATION_S) != HNS_ROCE_CQE_SUCCESS) {
+		hns_roce_handle_error_cqe(cqe, wc);
+		return CQ_OK;
+	}
+	wc->status = IBV_WC_SUCCESS;
+
+	/*
+	 * According to the opcode type of cqe, mark the opcode and other
+	 * information of wc
+	 */
+	if (is_send) {
+		/* Get opcode and flag before update the tail point for send */
+		sq_wqe = (struct hns_roce_wqe_ctrl_seg *)
+			 (uint64_t)get_send_wqe(*cur_qp,
+						roce_get_field(cqe->cqe_byte_4,
+						CQE_BYTE_4_WQE_INDEX_M,
+						CQE_BYTE_4_WQE_INDEX_S));
+		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
+		case HNS_ROCE_WQE_OPCODE_SEND:
+			wc->opcode = IBV_WC_SEND;
+			break;
+		case HNS_ROCE_WQE_OPCODE_RDMA_READ:
+			wc->opcode = IBV_WC_RDMA_READ;
+			wc->byte_len = cqe->byte_cnt;
+			break;
+		case HNS_ROCE_WQE_OPCODE_RDMA_WRITE:
+			wc->opcode = IBV_WC_RDMA_WRITE;
+			break;
+		case HNS_ROCE_WQE_OPCODE_BIND_MW2:
+			wc->opcode = IBV_WC_BIND_MW;
+			break;
+		default:
+			wc->status = IBV_WC_GENERAL_ERR;
+			break;
+		}
+		wc->wc_flags = (sq_wqe->flag & HNS_ROCE_WQE_IMM ?
+				IBV_WC_WITH_IMM : 0);
+	} else {
+		/* Get opcode and flag in rq&srq */
+		wc->byte_len = (cqe->byte_cnt);
+
+		switch (roce_get_field(cqe->cqe_byte_4,
+				       CQE_BYTE_4_OPERATION_TYPE_M,
+				       CQE_BYTE_4_OPERATION_TYPE_S) &
+			HNS_ROCE_CQE_OPCODE_MASK) {
+		case HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE:
+			wc->opcode   = IBV_WC_RECV_RDMA_WITH_IMM;
+			wc->wc_flags = IBV_WC_WITH_IMM;
+			wc->imm_data = cqe->immediate_data;
+			break;
+		case HNS_ROCE_OPCODE_SEND_DATA_RECEIVE:
+			if (roce_get_bit(cqe->cqe_byte_4,
+					 CQE_BYTE_4_IMMEDIATE_DATA_FLAG_S)) {
+				wc->opcode   = IBV_WC_RECV;
+				wc->wc_flags = IBV_WC_WITH_IMM;
+				wc->imm_data = cqe->immediate_data;
+			} else {
+				wc->opcode   = IBV_WC_RECV;
+				wc->wc_flags = 0;
+			}
+			break;
+		default:
+			wc->status = IBV_WC_GENERAL_ERR;
+			break;
+		}
+	}
+
+	return CQ_OK;
+}
+
+static int hns_roce_u_v1_poll_cq(struct ibv_cq *ibvcq, int ne,
+				 struct ibv_wc *wc)
+{
+	int npolled;
+	int err = CQ_OK;
+	struct hns_roce_qp *qp = NULL;
+	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvcq->context);
+	struct hns_roce_device *dev = to_hr_dev(ibvcq->context->device);
+
+	pthread_spin_lock(&cq->lock);
+
+	for (npolled = 0; npolled < ne; ++npolled) {
+		err = hns_roce_v1_poll_one(cq, &qp, wc + npolled);
+		if (err != CQ_OK)
+			break;
+	}
+
+	if (npolled) {
+		if (dev->hw_version == HNS_ROCE_HW_VER1) {
+			*cq->set_ci_db = (unsigned short)(cq->cons_index &
+					 ((cq->cq_depth << 1) - 1));
+			mb();
+		}
+
+		hns_roce_update_cq_cons_index(ctx, cq);
+	}
+
+	pthread_spin_unlock(&cq->lock);
+
+	return err == CQ_POLL_ERR ? err : npolled;
+}
+
+/**
+ * hns_roce_u_v1_arm_cq - request completion notification on a CQ
+ * @ibvcq: The completion queue to request notification for.
+ * @solicited: If non-zero, a event will be generated only for
+ *	      the next solicited CQ entry. If zero, any CQ entry,
+ *	      solicited or not, will generate an event
+ */
+static int hns_roce_u_v1_arm_cq(struct ibv_cq *ibvcq, int solicited)
+{
+	uint32_t ci;
+	uint32_t solicited_flag;
+	struct hns_roce_cq_db cq_db;
+	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
+
+	ci  = cq->cons_index & ((cq->cq_depth << 1) - 1);
+	solicited_flag = solicited ? HNS_ROCE_CQ_DB_REQ_SOL :
+				     HNS_ROCE_CQ_DB_REQ_NEXT;
+
+	cq_db.u32_4 = 0;
+	cq_db.u32_8 = 0;
+
+	roce_set_bit(cq_db.u32_8, CQ_DB_U32_8_HW_SYNC_S, 1);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CMD_M, CQ_DB_U32_8_CMD_S, 3);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CMD_MDF_M,
+		       CQ_DB_U32_8_CMD_MDF_S, 1);
+	roce_set_bit(cq_db.u32_8, CQ_DB_U32_8_NOTIFY_TYPE_S, solicited_flag);
+	roce_set_field(cq_db.u32_8, CQ_DB_U32_8_CQN_M, CQ_DB_U32_8_CQN_S,
+		       cq->cqn);
+	roce_set_field(cq_db.u32_4, CQ_DB_U32_4_CONS_IDX_M,
+		       CQ_DB_U32_4_CONS_IDX_S, ci);
+
+	hns_roce_write64((uint32_t *)&cq_db, to_hr_ctx(ibvcq->context),
+			  ROCEE_DB_OTHERS_L_0_REG);
+	return 0;
+}
+
+struct hns_roce_u_hw hns_roce_u_hw_v1 = {
+	.poll_cq = hns_roce_u_v1_poll_cq,
+	.arm_cq = hns_roce_u_v1_arm_cq,
+};
diff --git a/providers/hns/hns_roce_u_hw_v1.h b/providers/hns/hns_roce_u_hw_v1.h
new file mode 100644
index 0000000..b249f54
--- /dev/null
+++ b/providers/hns/hns_roce_u_hw_v1.h
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2016 Hisilicon Limited.
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
+#ifndef _HNS_ROCE_U_HW_V1_H
+#define _HNS_ROCE_U_HW_V1_H
+
+#define HNS_ROCE_CQ_DB_REQ_SOL			1
+#define HNS_ROCE_CQ_DB_REQ_NEXT			0
+
+#define HNS_ROCE_CQE_IS_SQ			0
+
+#define HNS_ROCE_RC_WQE_INLINE_DATA_MAX_LEN	32
+
+enum {
+	HNS_ROCE_WQE_IMM		= 1 << 23,
+	HNS_ROCE_WQE_OPCODE_SEND        = 0 << 16,
+	HNS_ROCE_WQE_OPCODE_RDMA_READ   = 1 << 16,
+	HNS_ROCE_WQE_OPCODE_RDMA_WRITE  = 2 << 16,
+	HNS_ROCE_WQE_OPCODE_BIND_MW2    = 6 << 16,
+	HNS_ROCE_WQE_OPCODE_MASK        = 15 << 16,
+};
+
+struct hns_roce_wqe_ctrl_seg {
+	__be32		sgl_pa_h;
+	__be32		flag;
+};
+
+enum {
+	CQ_OK				=  0,
+	CQ_EMPTY			= -1,
+	CQ_POLL_ERR			= -2,
+};
+
+enum {
+	HNS_ROCE_CQE_QPN_MASK		= 0x3ffff,
+	HNS_ROCE_CQE_STATUS_MASK	= 0x1f,
+	HNS_ROCE_CQE_OPCODE_MASK	= 0xf,
+};
+
+enum {
+	HNS_ROCE_CQE_SUCCESS,
+	HNS_ROCE_CQE_SYNDROME_LOCAL_LENGTH_ERR,
+	HNS_ROCE_CQE_SYNDROME_LOCAL_QP_OP_ERR,
+	HNS_ROCE_CQE_SYNDROME_LOCAL_PROT_ERR,
+	HNS_ROCE_CQE_SYNDROME_WR_FLUSH_ERR,
+	HNS_ROCE_CQE_SYNDROME_MEM_MANAGE_OPERATE_ERR,
+	HNS_ROCE_CQE_SYNDROME_BAD_RESP_ERR,
+	HNS_ROCE_CQE_SYNDROME_LOCAL_ACCESS_ERR,
+	HNS_ROCE_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR,
+	HNS_ROCE_CQE_SYNDROME_REMOTE_ACCESS_ERR,
+	HNS_ROCE_CQE_SYNDROME_REMOTE_OP_ERR,
+	HNS_ROCE_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR,
+	HNS_ROCE_CQE_SYNDROME_RNR_RETRY_EXC_ERR,
+};
+
+struct hns_roce_cq_db {
+	unsigned int u32_4;
+	unsigned int u32_8;
+};
+#define CQ_DB_U32_4_CONS_IDX_S 0
+#define CQ_DB_U32_4_CONS_IDX_M   (((1UL << 16) - 1) << CQ_DB_U32_4_CONS_IDX_S)
+
+#define CQ_DB_U32_8_CQN_S 0
+#define CQ_DB_U32_8_CQN_M   (((1UL << 16) - 1) << CQ_DB_U32_8_CQN_S)
+
+#define CQ_DB_U32_8_NOTIFY_TYPE_S 16
+
+#define CQ_DB_U32_8_CMD_MDF_S 24
+#define CQ_DB_U32_8_CMD_MDF_M   (((1UL << 4) - 1) << CQ_DB_U32_8_CMD_MDF_S)
+
+#define CQ_DB_U32_8_CMD_S 28
+#define CQ_DB_U32_8_CMD_M   (((1UL << 3) - 1) << CQ_DB_U32_8_CMD_S)
+
+#define CQ_DB_U32_8_HW_SYNC_S 31
+
+struct hns_roce_cqe {
+	unsigned int cqe_byte_4;
+	union {
+		unsigned int r_key;
+		unsigned int immediate_data;
+	};
+	unsigned int byte_cnt;
+	unsigned int cqe_byte_16;
+	unsigned int cqe_byte_20;
+	unsigned int s_mac_l;
+	unsigned int cqe_byte_28;
+	unsigned int reserved;
+};
+#define CQE_BYTE_4_OPERATION_TYPE_S 0
+#define CQE_BYTE_4_OPERATION_TYPE_M   \
+	(((1UL << 4) - 1) << CQE_BYTE_4_OPERATION_TYPE_S)
+
+#define CQE_BYTE_4_OWNER_S 7
+
+#define CQE_BYTE_4_STATUS_OF_THE_OPERATION_S 8
+#define CQE_BYTE_4_STATUS_OF_THE_OPERATION_M   \
+	(((1UL << 5) - 1) << CQE_BYTE_4_STATUS_OF_THE_OPERATION_S)
+
+#define CQE_BYTE_4_SQ_RQ_FLAG_S 14
+
+#define CQE_BYTE_4_IMMEDIATE_DATA_FLAG_S 15
+
+#define CQE_BYTE_4_WQE_INDEX_S 16
+#define CQE_BYTE_4_WQE_INDEX_M	(((1UL << 14) - 1) << CQE_BYTE_4_WQE_INDEX_S)
+
+#define CQE_BYTE_16_LOCAL_QPN_S 0
+#define CQE_BYTE_16_LOCAL_QPN_M	(((1UL << 24) - 1) << CQE_BYTE_16_LOCAL_QPN_S)
+
+#define ROCEE_DB_SQ_L_0_REG				0x230
+
+#define ROCEE_DB_OTHERS_L_0_REG				0x238
+
+struct hns_roce_rc_send_wqe {
+	unsigned int sgl_ba_31_0;
+	unsigned int u32_1;
+	union {
+		unsigned int r_key;
+		unsigned int immediate_data;
+	};
+	unsigned int msg_length;
+	unsigned int rvd_3;
+	unsigned int rvd_4;
+	unsigned int rvd_5;
+	unsigned int rvd_6;
+	uint64_t     va0;
+	unsigned int l_key0;
+	unsigned int length0;
+
+	uint64_t     va1;
+	unsigned int l_key1;
+	unsigned int length1;
+};
+
+#endif /* _HNS_ROCE_U_HW_V1_H */
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 476b6ba..61f48f1 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -40,6 +40,8 @@
 #include <unistd.h>
 
 #include "hns_roce_u.h"
+#include "hns_roce_u_abi.h"
+#include "hns_roce_u_hw_v1.h"
 
 int hns_roce_u_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr)
@@ -150,3 +152,117 @@ int hns_roce_u_dereg_mr(struct ibv_mr *mr)
 
 	return ret;
 }
+
+static int align_cq_size(int req)
+{
+	int nent;
+
+	for (nent = HNS_ROCE_MIN_CQE_NUM; nent < req; nent <<= 1)
+		;
+
+	return nent;
+}
+
+static int hns_roce_verify_cq(int *cqe, struct hns_roce_context *context)
+{
+	if (*cqe < HNS_ROCE_MIN_CQE_NUM) {
+		fprintf(stderr, "cqe = %d, less than minimum CQE number.\n",
+			*cqe);
+		*cqe = HNS_ROCE_MIN_CQE_NUM;
+	}
+
+	if (*cqe > context->max_cqe)
+		return -1;
+
+	return 0;
+}
+
+static int hns_roce_alloc_cq_buf(struct hns_roce_device *dev,
+				 struct hns_roce_buf *buf, int nent)
+{
+	if (hns_roce_alloc_buf(buf,
+			align(nent * HNS_ROCE_CQE_ENTRY_SIZE, dev->page_size),
+			dev->page_size))
+		return -1;
+	memset(buf->buf, 0, nent * HNS_ROCE_CQE_ENTRY_SIZE);
+
+	return 0;
+}
+
+struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
+				    struct ibv_comp_channel *channel,
+				    int comp_vector)
+{
+	struct hns_roce_create_cq	cmd;
+	struct hns_roce_create_cq_resp	resp;
+	struct hns_roce_cq		*cq;
+	int				ret;
+
+	if (hns_roce_verify_cq(&cqe, to_hr_ctx(context)))
+		return NULL;
+
+	cq = malloc(sizeof(*cq));
+	if (!cq)
+		return NULL;
+
+	cq->cons_index = 0;
+
+	if (pthread_spin_init(&cq->lock, PTHREAD_PROCESS_PRIVATE))
+		goto err;
+
+	cqe = align_cq_size(cqe);
+
+	if (hns_roce_alloc_cq_buf(to_hr_dev(context->device), &cq->buf, cqe))
+		goto err;
+
+	cmd.buf_addr = (uintptr_t) cq->buf.buf;
+
+	ret = ibv_cmd_create_cq(context, cqe, channel, comp_vector,
+				&cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
+				&resp.ibv_resp, sizeof(resp));
+	if (ret)
+		goto err_db;
+
+	cq->cqn = resp.cqn;
+	cq->cq_depth = cqe;
+
+	if (to_hr_dev(context->device)->hw_version == HNS_ROCE_HW_VER1)
+		cq->set_ci_db = to_hr_ctx(context)->cq_tptr_base + cq->cqn * 2;
+	else
+		cq->set_ci_db = to_hr_ctx(context)->uar +
+				ROCEE_DB_OTHERS_L_0_REG;
+
+	cq->arm_db    = cq->set_ci_db;
+	cq->arm_sn    = 1;
+	*(cq->set_ci_db) = 0;
+	*(cq->arm_db) = 0;
+
+	return &cq->ibv_cq;
+
+err_db:
+	hns_roce_free_buf(&cq->buf);
+
+err:
+	free(cq);
+
+	return NULL;
+}
+
+void hns_roce_u_cq_event(struct ibv_cq *cq)
+{
+	to_hr_cq(cq)->arm_sn++;
+}
+
+int hns_roce_u_destroy_cq(struct ibv_cq *cq)
+{
+	int ret;
+
+	ret = ibv_cmd_destroy_cq(cq);
+	if (ret)
+		return ret;
+
+	hns_roce_free_buf(&to_hr_cq(cq)->buf);
+	free(to_hr_cq(cq));
+
+	return ret;
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
