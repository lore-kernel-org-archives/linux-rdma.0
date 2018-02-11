From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 1/4] RDMA/hns: Support rq record doorbell for the user space
Date: Sun, 11 Feb 2018 20:40:50 +0800
Message-ID: <1518352853-80652-2-git-send-email-liuyixian@huawei.com>
References: <1518352853-80652-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518352853-80652-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds interfaces and definitions to support the rq record
doorbell for the user space.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hns/Makefile          |  2 +-
 drivers/infiniband/hw/hns/hns_roce_db.c     | 95 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_device.h | 46 +++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 26 +++++++-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  5 ++
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 51 +++++++++++++++-
 include/uapi/rdma/hns-abi.h                 |  6 ++
 7 files changed, 226 insertions(+), 5 deletions(-)
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_db.c

diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
index 97bf2cd..cf03404 100644
--- a/drivers/infiniband/hw/hns/Makefile
+++ b/drivers/infiniband/hw/hns/Makefile
@@ -7,7 +7,7 @@ ccflags-y :=  -Idrivers/net/ethernet/hisilicon/hns3
 obj-$(CONFIG_INFINIBAND_HNS) += hns-roce.o
 hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
 	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
-	hns_roce_cq.o hns_roce_alloc.o
+	hns_roce_cq.o hns_roce_alloc.o hns_roce_db.o
 obj-$(CONFIG_INFINIBAND_HNS_HIP06) += hns-roce-hw-v1.o
 hns-roce-hw-v1-objs := hns_roce_hw_v1.o
 obj-$(CONFIG_INFINIBAND_HNS_HIP08) += hns-roce-hw-v2.o
diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
new file mode 100644
index 0000000..1604c95
--- /dev/null
+++ b/drivers/infiniband/hw/hns/hns_roce_db.c
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause */
+/*
+ * Copyright (c) 2017 Hisilicon Limited.
+ * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
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
+#include <linux/platform_device.h>
+#include <rdma/ib_umem.h>
+#include "hns_roce_device.h"
+
+int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
+			 struct hns_roce_db *db)
+{
+	struct hns_roce_user_db_page *db_page;
+	int ret = 0;
+
+	mutex_lock(&context->db_page_mutex);
+
+	list_for_each_entry(db_page, &context->db_page_list, list)
+		if (db_page->user_virt == (virt & PAGE_MASK))
+			goto found;
+
+	db_page = kmalloc(sizeof(*db_page), GFP_KERNEL);
+	if (!db_page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	db_page->user_virt = (virt & PAGE_MASK);
+	db_page->refcount_t = 0;
+	db_page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
+					 PAGE_SIZE, 0, 0);
+	if (IS_ERR(db_page->umem)) {
+		ret = PTR_ERR(db_page->umem);
+		kfree(db_page);
+		goto out;
+	}
+
+	list_add(&db_page->list, &context->db_page_list);
+
+found:
+	db->dma = sg_dma_address(db_page->umem->sg_head.sgl) +
+		  (virt & ~PAGE_MASK);
+	db->u.user_page = db_page;
+	++db_page->refcount_t;
+
+out:
+	mutex_unlock(&context->db_page_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(hns_roce_db_map_user);
+
+void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
+			    struct hns_roce_db *db)
+{
+	mutex_lock(&context->db_page_mutex);
+
+	if (!--db->u.user_page->refcount_t) {
+		list_del(&db->u.user_page->list);
+		ib_umem_release(db->u.user_page->umem);
+		kfree(db->u.user_page);
+	}
+
+	mutex_unlock(&context->db_page_mutex);
+}
+EXPORT_SYMBOL(hns_roce_db_unmap_user);
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 165a09b..e436282 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -105,6 +105,10 @@
 #define PAGES_SHIFT_24				24
 #define PAGES_SHIFT_32				32
 
+enum {
+	HNS_ROCE_SUPPORT_RQ_RECORD_DB = 1 << 0,
+};
+
 enum hns_roce_qp_state {
 	HNS_ROCE_QP_STATE_RST,
 	HNS_ROCE_QP_STATE_INIT,
@@ -178,7 +182,8 @@ enum {
 enum {
 	HNS_ROCE_CAP_FLAG_REREG_MR		= BIT(0),
 	HNS_ROCE_CAP_FLAG_ROCE_V1_V2		= BIT(1),
-	HNS_ROCE_CAP_FLAG_RQ_INLINE		= BIT(2)
+	HNS_ROCE_CAP_FLAG_RQ_INLINE		= BIT(2),
+	HNS_ROCE_CAP_FLAG_RECORD_DB		= BIT(3)
 };
 
 enum hns_roce_mtt_type {
@@ -186,6 +191,10 @@ enum hns_roce_mtt_type {
 	MTT_TYPE_CQE,
 };
 
+enum {
+	HNS_ROCE_DB_PER_PAGE = PAGE_SIZE / 4
+};
+
 #define HNS_ROCE_CMD_SUCCESS			1
 
 #define HNS_ROCE_PORT_DOWN			0
@@ -203,6 +212,8 @@ struct hns_roce_uar {
 struct hns_roce_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct hns_roce_uar	uar;
+	struct list_head	db_page_list;
+	struct mutex		db_page_mutex;
 };
 
 struct hns_roce_pd {
@@ -335,6 +346,33 @@ struct hns_roce_buf {
 	int				page_shift;
 };
 
+struct hns_roce_db_pgdir {
+	struct list_head	list;
+	DECLARE_BITMAP(order0, HNS_ROCE_DB_PER_PAGE);
+	DECLARE_BITMAP(order1, HNS_ROCE_DB_PER_PAGE / 2);
+	unsigned long		*bits[2];
+	u32			*db_page;
+	dma_addr_t		db_dma;
+};
+
+struct hns_roce_user_db_page {
+	struct list_head	list;
+	struct ib_umem		*umem;
+	unsigned long		user_virt;
+	int			refcount_t;
+};
+
+struct hns_roce_db {
+	u32		*db_record;
+	union {
+		struct hns_roce_db_pgdir *pgdir;
+		struct hns_roce_user_db_page *user_page;
+	} u;
+	dma_addr_t	dma;
+	int		index;
+	int		order;
+};
+
 struct hns_roce_cq_buf {
 	struct hns_roce_buf hr_buf;
 	struct hns_roce_mtt hr_mtt;
@@ -465,6 +503,8 @@ struct hns_roce_rinl_buf {
 struct hns_roce_qp {
 	struct ib_qp		ibqp;
 	struct hns_roce_buf	hr_buf;
+	struct hns_roce_db	rdb;
+	u8			rdb_en;
 	struct hns_roce_wq	rq;
 	u32			doorbell_qpn;
 	__le32			sq_signal_bits;
@@ -930,6 +970,10 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 int hns_roce_ib_destroy_cq(struct ib_cq *ib_cq);
 void hns_roce_free_cq(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq);
 
+int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
+			 struct hns_roce_db *db);
+void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
+			    struct hns_roce_db *db);
 void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn);
 void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type);
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index db2ff35..275ee84 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1168,7 +1168,8 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 
 	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
 				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2 |
-				  HNS_ROCE_CAP_FLAG_RQ_INLINE;
+				  HNS_ROCE_CAP_FLAG_RQ_INLINE |
+				  HNS_ROCE_CAP_FLAG_RECORD_DB;
 	caps->pkey_table_len[0] = 1;
 	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
 	caps->ceqe_depth	= HNS_ROCE_V2_COMP_EQE_NUM;
@@ -2274,6 +2275,23 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 		hr_qp->qkey = attr->qkey;
 	}
 
+	if (hr_qp->rdb_en) {
+		roce_set_bit(context->byte_68_rq_db,
+			     V2_QPC_BYTE_68_RQ_RECORD_EN_S, 1);
+		roce_set_bit(qpc_mask->byte_68_rq_db,
+			     V2_QPC_BYTE_68_RQ_RECORD_EN_S, 0);
+	}
+
+	roce_set_field(context->byte_68_rq_db,
+		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_M,
+		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_S,
+		       ((u32)hr_qp->rdb.dma) >> 1);
+	roce_set_field(qpc_mask->byte_68_rq_db,
+		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_M,
+		       V2_QPC_BYTE_68_RQ_DB_RECORD_ADDR_S, 0);
+	context->rq_db_record_addr = hr_qp->rdb.dma >> 32;
+	qpc_mask->rq_db_record_addr = 0;
+
 	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 1);
 	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 0);
 
@@ -3211,6 +3229,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		hr_qp->sq.tail = 0;
 		hr_qp->sq_next_wqe = 0;
 		hr_qp->next_sge = 0;
+		if (hr_qp->rq.wqe_cnt)
+			*hr_qp->rdb.db_record = 0;
 	}
 
 out:
@@ -3437,6 +3457,10 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 	hns_roce_mtt_cleanup(hr_dev, &hr_qp->mtt);
 
 	if (is_user) {
+		if (hr_qp->rq.wqe_cnt)
+			hns_roce_db_unmap_user(
+				to_hr_ucontext(hr_qp->ibqp.uobject->context),
+				&hr_qp->rdb);
 		ib_umem_release(hr_qp->umem);
 	} else {
 		kfree(hr_qp->sq.wrid);
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index eb9a69f..8b15283 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -350,6 +350,11 @@ static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
 	if (ret)
 		goto error_fail_uar_alloc;
 
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
+		INIT_LIST_HEAD(&context->db_page_list);
+		mutex_init(&context->db_page_mutex);
+	}
+
 	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
 	if (ret)
 		goto error_fail_copy_to_udata;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 088973a..0b1c46a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -489,6 +489,15 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 	return 0;
 }
 
+static int hns_roce_qp_has_rq(struct ib_qp_init_attr *attr)
+{
+	if (attr->qp_type == IB_QPT_XRC_INI ||
+	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq)
+		return 0;
+
+	return 1;
+}
+
 static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				     struct ib_pd *ib_pd,
 				     struct ib_qp_init_attr *init_attr,
@@ -497,6 +506,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_ib_create_qp ucmd;
+	struct hns_roce_ib_create_qp_resp resp;
 	unsigned long qpn = 0;
 	int ret = 0;
 	u32 page_shift;
@@ -602,6 +612,17 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 			dev_err(dev, "hns_roce_ib_umem_write_mtt error for create qp\n");
 			goto err_mtt;
 		}
+
+		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
+		    hns_roce_qp_has_rq(init_attr)) {
+			ret = hns_roce_db_map_user(
+					to_hr_ucontext(ib_pd->uobject->context),
+					ucmd.db_addr, &hr_qp->rdb);
+			if (ret) {
+				dev_err(dev, "rp record doorbell map failed!\n");
+				goto err_mtt;
+			}
+		}
 	} else {
 		if (init_attr->create_flags &
 		    IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
@@ -698,17 +719,43 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	else
 		hr_qp->doorbell_qpn = cpu_to_le64(hr_qp->qpn);
 
+	if (ib_pd->uobject && (udata->outlen == sizeof(resp)) &&
+		(hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB)) {
+
+		/* indicate kernel supports record db */
+		resp.cap_flags |= HNS_ROCE_SUPPORT_RQ_RECORD_DB;
+		ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (ret)
+			goto err_qp;
+
+		hr_qp->rdb_en = 1;
+	}
 	hr_qp->event = hns_roce_ib_qp_event;
 
 	return 0;
 
+err_qp:
+	if (init_attr->qp_type == IB_QPT_GSI &&
+		hr_dev->hw_rev == HNS_ROCE_HW_VER1)
+		hns_roce_qp_remove(hr_dev, hr_qp);
+	else
+		hns_roce_qp_free(hr_dev, hr_qp);
+
 err_qpn:
 	if (!sqpn)
 		hns_roce_release_range_qp(hr_dev, qpn, 1);
 
 err_wrid:
-	kfree(hr_qp->sq.wrid);
-	kfree(hr_qp->rq.wrid);
+	if (ib_pd->uobject) {
+		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
+		    hns_roce_qp_has_rq(init_attr))
+			hns_roce_db_unmap_user(
+					to_hr_ucontext(ib_pd->uobject->context),
+					&hr_qp->rdb);
+	} else {
+		kfree(hr_qp->sq.wrid);
+		kfree(hr_qp->rq.wrid);
+	}
 
 err_mtt:
 	hns_roce_mtt_cleanup(hr_dev, &hr_qp->mtt);
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index a9c03b0..390ba59 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -49,7 +49,13 @@ struct hns_roce_ib_create_qp {
 	__u8    reserved[5];
 };
 
+struct hns_roce_ib_create_qp_resp {
+	__u32	cap_flags;
+	__u32	reserved;
+};
+
 struct hns_roce_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
+	__u32	reserved;
 };
 #endif /* HNS_ABI_USER_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
