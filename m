From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 06/11] {topost} RDMA/hns: Set sq_cur_sge_blk_addr field in QPC in hip08
Date: Fri, 10 Nov 2017 16:55:48 +0800
Message-ID: <1510304153-91394-7-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the extend sges exist, the sq_cur_sge_blk_addr field in QPC
(qp context) should be configured.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 16 ++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b2513bd..ee2d832 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2566,6 +2566,7 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
 	struct device *dev = hr_dev->dev;
 	dma_addr_t dma_handle;
+	u32 page_size;
 	u64 *mtts;
 
 	/* Search qp buf's mtts */
@@ -2608,6 +2609,21 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_168_SQ_CUR_BLK_ADDR_M,
 		       V2_QPC_BYTE_168_SQ_CUR_BLK_ADDR_S, 0);
 
+	page_size = 1 << (hr_dev->caps.mtt_buf_pg_sz + PAGE_SHIFT);
+	context->sq_cur_sge_blk_addr = hr_qp->sq.max_gs > 2 ?
+				      ((u32)(mtts[hr_qp->sge.offset / page_size]
+				      >> PAGE_ADDR_SHIFT)) : 0;
+	roce_set_field(context->byte_184_irrl_idx,
+		       V2_QPC_BYTE_184_SQ_CUR_SGE_BLK_ADDR_M,
+		       V2_QPC_BYTE_184_SQ_CUR_SGE_BLK_ADDR_S,
+		       hr_qp->sq.max_gs > 2 ?
+		       (mtts[hr_qp->sge.offset / page_size] >>
+		       (32 + PAGE_ADDR_SHIFT)) : 0);
+	qpc_mask->sq_cur_sge_blk_addr = 0;
+	roce_set_field(qpc_mask->byte_184_irrl_idx,
+		       V2_QPC_BYTE_184_SQ_CUR_SGE_BLK_ADDR_M,
+		       V2_QPC_BYTE_184_SQ_CUR_SGE_BLK_ADDR_S, 0);
+
 	context->rx_sq_cur_blk_addr = (u32)(mtts[0] >> PAGE_ADDR_SHIFT);
 	roce_set_field(context->byte_232_irrl_sge,
 		       V2_QPC_BYTE_232_RX_SQ_CUR_BLK_ADDR_M,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index ea14225..3d9114e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -353,7 +353,7 @@ struct hns_roce_v2_qp_context {
 	u32	byte_168_irrl_idx;
 	u32	byte_172_sq_psn;
 	u32	byte_176_msg_pktn;
-	u32	sq_cur_sqe_blk_addr;
+	u32	sq_cur_sge_blk_addr;
 	u32	byte_184_irrl_idx;
 	u32	cur_sge_offset;
 	u32	byte_192_ext_sge;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
