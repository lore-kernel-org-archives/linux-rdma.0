From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] libhns: Set owner bit of SQWQE in user mode
Date: Wed, 1 Nov 2017 18:00:38 +0800
Message-ID: <1509530440-164400-2-git-send-email-oulijun@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509530440-164400-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In hip08, it needs to set owner field of sqwqe when posting
send wr. The owner field will be used by hardware. The set
algorithm as follows:
The value of owner should be 1 in the first lap, it should
be 0 in the second lap and in turn.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index 50059bf..900387c 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -473,6 +473,7 @@ static int hns_roce_u_v2_arm_cq(struct ibv_cq *ibvcq, int solicited)
 static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 				   struct ibv_send_wr **bad_wr)
 {
+	unsigned int sq_shift;
 	unsigned int ind_sge;
 	unsigned int ind;
 	int nreq;
@@ -542,6 +543,11 @@ static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		roce_set_bit(rc_sq_wqe->byte_4, RC_SQ_WQE_BYTE_4_SE_S,
 			     (wr->send_flags & IBV_SEND_SOLICITED) ? 1 : 0);
 
+		for (sq_shift = 0; (1 << sq_shift) < qp->sq.wqe_cnt; ++sq_shift)
+			;
+		roce_set_bit(rc_sq_wqe->byte_4, RC_SQ_WQE_BYTE_4_OWNER_S,
+			     ~(qp->sq.head >> sq_shift) & 0x1);
+
 		wqe += sizeof(struct hns_roce_rc_sq_wqe);
 		/* set remote addr segment */
 		switch (ibvqp->qp_type) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
