From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] libhns: Filter for zero length of sge in hip08 userspace
Date: Sat, 18 Nov 2017 18:21:36 +0800
Message-ID: <1511000496-181604-3-git-send-email-oulijun@huawei.com>
References: <1511000496-181604-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511000496-181604-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In hip08, the driver should filt it when the sge's length
is zero.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index e7a34b7..13abbcf 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -664,8 +664,11 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 			/* set sge */
 			if (wr->num_sge <= 2) {
 				for (i = 0; i < wr->num_sge; i++)
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + i);
+					if (likely(wr->sg_list[i].length)) {
+						set_data_seg_v2(dseg,
+							       wr->sg_list + i);
+						dseg++;
+					}
 			} else {
 				roce_set_field(rc_sq_wqe->byte_20,
 					RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_M,
@@ -673,16 +676,22 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 					ind_sge & (qp->sge.sge_cnt - 1));
 
 				for (i = 0; i < 2; i++)
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + i);
+					if (likely(wr->sg_list[i].length)) {
+						set_data_seg_v2(dseg,
+							       wr->sg_list + i);
+						dseg++;
+					}
 
 				dseg = get_send_sge_ex(qp, ind_sge &
 						    (qp->sge.sge_cnt - 1));
 
 				for (i = 0; i < wr->num_sge - 2; i++) {
-					set_data_seg_v2(dseg + i,
-							wr->sg_list + 2 + i);
-					ind_sge++;
+					if (likely(wr->sg_list[i + 2].length)) {
+						set_data_seg_v2(dseg,
+							   wr->sg_list + 2 + i);
+						dseg++;
+						ind_sge++;
+					}
 				}
 			}
 		}
@@ -745,8 +754,17 @@ static int hns_roce_u_v2_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
 		wqe = get_recv_wqe_v2(qp, ind);
 		dseg = (struct hns_roce_v2_wqe_data_seg *)wqe;
 
-		for (i = 0; i < wr->num_sge; i++)
-			set_data_seg_v2(dseg + i, wr->sg_list + i);
+		for (i = 0; i < wr->num_sge; i++) {
+			if (!wr->sg_list[i].length)
+				continue;
+			set_data_seg_v2(dseg, wr->sg_list + i);
+			dseg++;
+		}
+
+		if (i < qp->rq.max_gs) {
+			dseg[i].lkey = htole32(0x100);
+			dseg[i].addr = 0;
+		}
 
 		qp->rq.wrid[ind] = wr->wr_id;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
