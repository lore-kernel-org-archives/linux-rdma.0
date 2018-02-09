From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 rdma-core 1/2] libhns: Support rq record doorbell
Date: Fri, 9 Feb 2018 19:45:23 +0800
Message-ID: <1518176724-126991-2-git-send-email-liuyixian@huawei.com>
References: <1518176724-126991-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518176724-126991-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support rq record doorbell in the
user space driver.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/hns/CMakeLists.txt     |   1 +
 providers/hns/hns_roce_u.h       |  26 ++++++
 providers/hns/hns_roce_u_abi.h   |   4 +
 providers/hns/hns_roce_u_db.c    | 196 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_db.h    |   5 +
 providers/hns/hns_roce_u_hw_v2.c |  11 ++-
 providers/hns/hns_roce_u_hw_v2.h |   4 +
 providers/hns/hns_roce_u_verbs.c |  22 ++++-
 8 files changed, 265 insertions(+), 4 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_db.c

diff --git a/providers/hns/CMakeLists.txt b/providers/hns/CMakeLists.txt
index f136151..697dbd7 100644
--- a/providers/hns/CMakeLists.txt
+++ b/providers/hns/CMakeLists.txt
@@ -1,6 +1,7 @@
 rdma_provider(hns
   hns_roce_u.c
   hns_roce_u_buf.c
+  hns_roce_u_db.c
   hns_roce_u_hw_v1.c
   hns_roce_u_hw_v2.c
   hns_roce_u_verbs.c
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 0291246..95440e9 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -93,6 +93,26 @@ struct hns_roce_buf {
 	unsigned int			length;
 };
 
+#define BIT_CNT_PER_BYTE       8
+
+/* the sw db length, on behalf of the qp/cq/srq length from left to right; */
+static const unsigned int db_size[] = {4, 4};
+
+/* the sw doorbell type; */
+enum hns_roce_db_type {
+	HNS_ROCE_QP_TYPE_DB,
+	HNS_ROCE_CQ_TYPE_DB,
+	HNS_ROCE_DB_TYPE_NUM
+};
+
+struct hns_roce_db_page {
+	struct hns_roce_db_page	*prev, *next;
+	struct hns_roce_buf	buf;
+	unsigned int		num_db;
+	unsigned int		use_cnt;
+	unsigned long		*bitmap;
+};
+
 struct hns_roce_context {
 	struct verbs_context		ibv_ctx;
 	void				*uar;
@@ -110,6 +130,10 @@ struct hns_roce_context {
 	int				num_qps;
 	int				qp_table_shift;
 	int				qp_table_mask;
+
+	struct hns_roce_db_page		*db_list[HNS_ROCE_DB_TYPE_NUM];
+	pthread_mutex_t			db_list_mutex;
+
 	unsigned int			max_qp_wr;
 	unsigned int			max_sge;
 	int				max_cqe;
@@ -188,12 +212,14 @@ struct hns_roce_qp {
 	unsigned int			sq_signal_bits;
 	struct hns_roce_wq		sq;
 	struct hns_roce_wq		rq;
+	unsigned int			*rdb;
 	struct hns_roce_sge_ex		sge;
 	unsigned int			next_sge;
 	int				port_num;
 	int				sl;
 
 	struct hns_roce_rinl_buf	rq_rinl_buf;
+	unsigned int			flags;
 };
 
 struct hns_roce_u_hw {
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index 251a5c9..d67e4fc 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -68,4 +68,8 @@ struct hns_roce_create_qp {
 	__u8				reserved[5];
 };
 
+struct hns_roce_create_qp_resp {
+	struct ib_uverbs_create_qp_resp	base;
+	__u32				cap_flags;
+};
 #endif /* _HNS_ROCE_U_ABI_H */
diff --git a/providers/hns/hns_roce_u_db.c b/providers/hns/hns_roce_u_db.c
new file mode 100644
index 0000000..770f1ec
--- /dev/null
+++ b/providers/hns/hns_roce_u_db.c
@@ -0,0 +1,196 @@
+/*
+ * Copyright (c) 2017 Hisilicon Limited.
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
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include "hns_roce_u.h"
+#include "hns_roce_u_db.h"
+
+static inline uint32_t align_size(uint32_t size, uint32_t align)
+{
+	return (uint32_t) (size + align - 1) & (~(align - 1));
+}
+
+static struct hns_roce_db_page *hns_roce_add_db_page(
+						struct hns_roce_context *ctx,
+						enum hns_roce_db_type type)
+{
+	struct hns_roce_db_page *page;
+	uint32_t bitmap_num;
+	uint32_t page_size;
+	int i;
+
+	/* alloc db page */
+	page_size = (uint32_t)to_hr_dev(ctx->ibv_ctx.context.device)->page_size;
+	page = (struct hns_roce_db_page *)calloc(1, sizeof(*page));
+	if (!page)
+		goto err_page;
+
+	/* allocate bitmap space for sw db */
+	page->num_db = page_size / db_size[type];
+	page->use_cnt = 0;
+	bitmap_num = align_size(page->num_db,
+				BIT_CNT_PER_BYTE * sizeof(uint64_t));
+
+	page->bitmap = calloc(1, bitmap_num / BIT_CNT_PER_BYTE);
+	if (!page->bitmap)
+		goto err_map;
+
+	/* bitmap_num indicate the mount of u64 */
+	bitmap_num = bitmap_num / (BIT_CNT_PER_BYTE * sizeof(uint64_t));
+
+	if (hns_roce_alloc_buf(&(page->buf), page_size, (int)page_size))
+		goto err;
+
+	/* init the sw db bitmap */
+	for (i = 0; i < bitmap_num; ++i)
+		page->bitmap[i] = ~(0UL);
+
+	/* add the set ctx->db_list */
+	page->prev = NULL;
+	page->next = ctx->db_list[type];
+	ctx->db_list[type] = page;
+	if (page->next)
+		page->next->prev = page;
+
+	return page;
+err:
+	free(page->bitmap);
+	page->bitmap = NULL;
+
+err_map:
+	free(page);
+	page = NULL;
+
+err_page:
+	return NULL;
+}
+
+static void hns_roce_clear_db_page(struct hns_roce_db_page *page)
+{
+	if (!page) {
+		fprintf(stderr, "error clear: db page is NULL!\n");
+		return;
+	}
+
+	if (page->bitmap) {
+		free(page->bitmap);
+		page->bitmap = NULL;
+	}
+
+	hns_roce_free_buf(&(page->buf));
+}
+
+void *hns_roce_alloc_db(struct hns_roce_context *ctx,
+			enum hns_roce_db_type type)
+{
+	struct hns_roce_db_page *page;
+	void *db = NULL;
+	uint32_t bit_num;
+	uint32_t i;
+
+	pthread_mutex_lock((pthread_mutex_t *)&ctx->db_list_mutex);
+
+	for (page = ctx->db_list[type]; page != NULL; page = page->next)
+		if (page->use_cnt < page->num_db)
+			goto found;
+
+	page = hns_roce_add_db_page(ctx, type);
+	if (!page)
+		goto out;
+
+found:
+	++page->use_cnt;
+	/* if the bitmap is allocated, the bitmap[i] is set zero */
+	for (i = 0; page->bitmap[i] == 0; ++i)
+		;
+
+	bit_num = (uint32_t)ffsl(page->bitmap[i]);
+	page->bitmap[i] &= ~(1ULL << (bit_num - 1));
+
+	db = (void *)((uint8_t *)(page->buf.buf) +
+			(size_t)((i * sizeof(uint64_t) * BIT_CNT_PER_BYTE +
+			(bit_num - 1)) * db_size[type]));
+
+out:
+	pthread_mutex_unlock((pthread_mutex_t *)&ctx->db_list_mutex);
+
+	return db;
+}
+
+void hns_roce_free_db(struct hns_roce_context *ctx, unsigned int *db,
+		      enum hns_roce_db_type type)
+{
+	struct hns_roce_db_page *page;
+	uint32_t bit_num;
+	uint32_t page_size;
+
+	pthread_mutex_lock((pthread_mutex_t *)&ctx->db_list_mutex);
+
+	page_size = (uint32_t)to_hr_dev(ctx->ibv_ctx.context.device)->page_size;
+	for (page = ctx->db_list[type]; page != NULL; page = page->next)
+		if (((uintptr_t)db & (~((uintptr_t)page_size - 1))) ==
+						(uintptr_t)(page->buf.buf))
+			goto found;
+
+	fprintf(stderr, "db page can't be found!\n");
+	goto out;
+
+found:
+	--page->use_cnt;
+	if (!page->use_cnt) {
+		if (page->prev)
+			page->prev->next = page->next;
+		else
+			ctx->db_list[type] = page->next;
+
+		if (page->next)
+			page->next->prev = page->prev;
+
+		hns_roce_clear_db_page(page);
+		free(page);
+		page = NULL;
+
+		goto out;
+	}
+
+	bit_num = (uint32_t)(((uintptr_t)db - (uintptr_t)page->buf.buf) /
+								db_size[type]);
+	page->bitmap[bit_num / (sizeof(uint64_t) * BIT_CNT_PER_BYTE)] |=
+			     ((uint64_t)1ULL) <<
+			     (bit_num % (sizeof(uint64_t) * BIT_CNT_PER_BYTE));
+
+out:
+	pthread_mutex_unlock((pthread_mutex_t *)&ctx->db_list_mutex);
+}
diff --git a/providers/hns/hns_roce_u_db.h b/providers/hns/hns_roce_u_db.h
index 76d13ce..b44e64d 100644
--- a/providers/hns/hns_roce_u_db.h
+++ b/providers/hns/hns_roce_u_db.h
@@ -51,4 +51,9 @@ static inline void hns_roce_write64(uint32_t val[2],
 	*(volatile uint64_t *) (ctx->uar + offset) = HNS_ROCE_PAIR_TO_64(val);
 }
 
+void *hns_roce_alloc_db(struct hns_roce_context *ctx,
+			enum hns_roce_db_type type);
+void hns_roce_free_db(struct hns_roce_context *ctx, unsigned int *db,
+		      enum hns_roce_db_type type);
+
 #endif /* _HNS_ROCE_U_DB_H */
diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index 226f66d..bdb6ecc 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -829,8 +829,11 @@ out:
 	if (nreq) {
 		qp->rq.head += nreq;
 
-		hns_roce_update_rq_db(ctx, qp->ibv_qp.qp_num,
-				     qp->rq.head & ((qp->rq.wqe_cnt << 1) - 1));
+		if (qp->flags & HNS_ROCE_SUPPORT_RQ_RECORD_DB)
+			*qp->rdb = qp->rq.head & 0xffff;
+		else
+			hns_roce_update_rq_db(ctx, qp->ibv_qp.qp_num,
+				qp->rq.head & ((qp->rq.wqe_cnt << 1) - 1));
 	}
 
 	pthread_spin_unlock(&qp->rq.lock);
@@ -971,6 +974,10 @@ static int hns_roce_u_v2_destroy_qp(struct ibv_qp *ibqp)
 	hns_roce_unlock_cqs(ibqp);
 	pthread_mutex_unlock(&to_hr_ctx(ibqp->context)->qp_table_mutex);
 
+	if (qp->rq.max_gs)
+		hns_roce_free_db(to_hr_ctx(ibqp->context), qp->rdb,
+				 HNS_ROCE_QP_TYPE_DB);
+
 	hns_roce_free_buf(&qp->buf);
 	if (qp->rq_rinl_buf.wqe_list) {
 		if (qp->rq_rinl_buf.wqe_list[0].sg_list) {
diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
index 061ae54..15ac0ca 100644
--- a/providers/hns/hns_roce_u_hw_v2.h
+++ b/providers/hns/hns_roce_u_hw_v2.h
@@ -40,6 +40,10 @@
 
 #define HNS_ROCE_CMDSN_MASK			0x3
 
+enum {
+	HNS_ROCE_SUPPORT_RQ_RECORD_DB = 1 << 0,
+};
+
 /* V2 REG DEFINITION */
 #define ROCEE_VF_DB_CFG0_OFFSET			0x0230
 
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 11390de..6fd2e72 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -41,6 +41,7 @@
 #include <ccan/minmax.h>
 #include "hns_roce_u.h"
 #include "hns_roce_u_abi.h"
+#include "hns_roce_u_db.h"
 #include "hns_roce_u_hw_v1.h"
 #include "hns_roce_u_hw_v2.h"
 
@@ -502,7 +503,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 	int ret;
 	struct hns_roce_qp *qp = NULL;
 	struct hns_roce_create_qp cmd;
-	struct ib_uverbs_create_qp_resp resp;
+	struct hns_roce_create_qp_resp resp;
 	struct hns_roce_context *context = to_hr_ctx(pd->context);
 	unsigned int sge_ex_count;
 
@@ -548,6 +549,19 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 		goto err_free;
 	}
 
+	if ((to_hr_dev(pd->context->device)->hw_version != HNS_ROCE_HW_VER1) &&
+	    attr->cap.max_recv_sge) {
+		qp->rdb = hns_roce_alloc_db(context, HNS_ROCE_QP_TYPE_DB);
+		if (!qp->rdb) {
+			fprintf(stderr, "alloc rdb buffer failed!\n");
+			goto err_free;
+		}
+
+		*(qp->rdb) = 0;
+		cmd.db_addr = (uintptr_t) qp->rdb;
+	} else
+		cmd.db_addr = 0;
+
 	cmd.buf_addr = (uintptr_t) qp->buf.buf;
 	cmd.log_sq_stride = qp->sq.wqe_shift;
 	for (cmd.log_sq_bb_count = 0; qp->sq.wqe_cnt > 1 << cmd.log_sq_bb_count;
@@ -559,7 +573,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 	pthread_mutex_lock(&to_hr_ctx(pd->context)->qp_table_mutex);
 
 	ret = ibv_cmd_create_qp(pd, &qp->ibv_qp, attr, &cmd.ibv_cmd,
-				sizeof(cmd), &resp, sizeof(resp));
+				sizeof(cmd), &resp.base, sizeof(resp));
 	if (ret) {
 		fprintf(stderr, "ibv_cmd_create_qp failed!\n");
 		goto err_rq_db;
@@ -574,6 +588,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 
 	qp->rq.wqe_cnt = attr->cap.max_recv_wr;
 	qp->rq.max_gs	= attr->cap.max_recv_sge;
+	qp->flags	= resp.cap_flags;
 
 	/* adjust rq maxima to not exceed reported device maxima */
 	attr->cap.max_recv_wr = min(context->max_qp_wr, attr->cap.max_recv_wr);
@@ -591,6 +606,9 @@ err_destroy:
 
 err_rq_db:
 	pthread_mutex_unlock(&to_hr_ctx(pd->context)->qp_table_mutex);
+	if ((to_hr_dev(pd->context->device)->hw_version != HNS_ROCE_HW_VER1) &&
+	    attr->cap.max_recv_sge)
+		hns_roce_free_db(context, qp->rdb, HNS_ROCE_QP_TYPE_DB);
 
 err_free:
 	free(qp->sq.wrid);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
