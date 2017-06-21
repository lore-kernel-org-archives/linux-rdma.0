From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2] qedr: Set immediate data sent via EDPM as is.
Date: Wed, 21 Jun 2017 09:32:55 +0300
Message-ID: <1498026775-7927-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhanced Direct Packet Mode doesn't require flipping of bytes as it
is sent directly to the transmitting HW and isn't processed by the
FW that requires specific order.

Fixes: c0965e4fe6fe ("libqedr (qelr) verbs")

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 676b18c..68429df 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -1259,7 +1259,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		swqe->wqe_size = 2;
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
 		swqe->inv_key_or_imm_data = htobe32(htole32(wr->imm_data));
-		qelr_edpm_set_inv_imm(qp, &edpm, swqe->inv_key_or_imm_data);
+		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
 		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
 		qelr_edpm_set_msg_data(qp, &edpm,
 				       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
@@ -1291,7 +1291,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		rwqe->imm_data = htobe32(htole32(wr->imm_data));
 		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
 				       wr->wr.rdma.rkey);
-		qelr_edpm_set_inv_imm(qp, &edpm, rwqe->imm_data);
+		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
 		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
 		qelr_edpm_set_msg_data(qp, &edpm,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
