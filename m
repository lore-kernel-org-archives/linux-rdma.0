From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 03/13] RDMA/bnxt_re: Fix WQE Size posted to HW to prevent it from throwing error
Date: Thu, 29 Jun 2017 12:28:09 -0700
Message-ID: <1498764499-24157-4-git-send-email-selvin.xavier@broadcom.com>
References: <1498764499-24157-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Posting WQE size of 2 results in a WQE_FORMAT_ERROR
thrown by the HW as it requires host to supply WQE Size with room
for atleast one SGE so that the resulting WQE size be atleast 3.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index f05500bc..8ef39df 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1128,6 +1128,11 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		}
 		/* Each SGE entry = 1 WQE size16 */
 		wqe_size16 = wqe->num_sge;
+		/* HW requires wqe size has room for atleast one SGE even if
+		 * none was supplied by ULP
+		 */
+		if (!wqe->num_sge)
+			wqe_size16++;
 	}
 
 	/* Specifics */
@@ -1364,6 +1369,11 @@ int bnxt_qplib_post_recv(struct bnxt_qplib_qp *qp,
 	rqe->flags = wqe->flags;
 	rqe->wqe_size = wqe->num_sge +
 			((offsetof(typeof(*rqe), data) + 15) >> 4);
+	/* HW requires wqe size has room for atleast one SGE even if none
+	 * was supplied by ULP
+	 */
+	if (!wqe->num_sge)
+		rqe->wqe_size++;
 
 	/* Supply the rqe->wr_id index to the wr_id_tbl for now */
 	rqe->wr_id[0] = cpu_to_le32(sw_prod);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
