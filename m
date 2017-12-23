From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 4/6] RDMA/hns: Filter for zero length of sge in hip08 kernel mode
Date: Sat, 23 Dec 2017 16:22:20 +0800
Message-ID: <1514017342-91468-5-git-send-email-oulijun@huawei.com>
References: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514017342-91468-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the length of sge is zero, the driver need to filter it

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 869e36f..a1d8ca0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -230,26 +230,37 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				     V2_RC_SEND_WQE_BYTE_4_INLINE_S, 1);
 		} else {
 			if (wr->num_sge <= 2) {
-				for (i = 0; i < wr->num_sge; i++)
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + i);
+				for (i = 0; i < wr->num_sge; i++) {
+					if (likely(wr->sg_list[i].length)) {
+						set_data_seg_v2(dseg,
+							       wr->sg_list + i);
+						dseg++;
+					}
+				}
 			} else {
 				roce_set_field(rc_sq_wqe->byte_20,
 				V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_M,
 				V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
 				sge_ind & (qp->sge.sge_cnt - 1));
 
-				for (i = 0; i < 2; i++)
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + i);
+				for (i = 0; i < 2; i++) {
+					if (likely(wr->sg_list[i].length)) {
+						set_data_seg_v2(dseg,
+							       wr->sg_list + i);
+						dseg++;
+					}
+				}
 
 				dseg = get_send_extend_sge(qp,
 					sge_ind & (qp->sge.sge_cnt - 1));
 
 				for (i = 0; i < wr->num_sge - 2; i++) {
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + 2 + i);
-					sge_ind++;
+					if (likely(wr->sg_list[i + 2].length)) {
+						set_data_seg_v2(dseg,
+							   wr->sg_list + 2 + i);
+						dseg++;
+						sge_ind++;
+					}
 				}
 			}
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
