From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc 3/4] RDMA/ocrdma: Fix pkey_index returned by driver in rq work completion
Date: Fri,  5 Feb 2016 20:06:39 +0530
Message-ID: <1454683001-21275-4-git-send-email-selvin.xavier@broadcom.com>
References: <1454683001-21275-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454683001-21275-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently returning the pkey value instead of pkey index.
pkey index is always zero since ocrdma supports only default
pkey.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 7cf1324..37620b4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2726,8 +2726,7 @@ static int ocrdma_update_ud_rcqe(struct ib_wc *ibwc, struct ocrdma_cqe *cqe)
 		OCRDMA_CQE_UD_STATUS_MASK) >> OCRDMA_CQE_UD_STATUS_SHIFT;
 	ibwc->src_qp = le32_to_cpu(cqe->flags_status_srcqpn) &
 						OCRDMA_CQE_SRCQP_MASK;
-	ibwc->pkey_index = le32_to_cpu(cqe->ud.rxlen_pkey) &
-						OCRDMA_CQE_PKEY_MASK;
+	ibwc->pkey_index = 0;
 	ibwc->wc_flags = IB_WC_GRH;
 	ibwc->byte_len = (le32_to_cpu(cqe->ud.rxlen_pkey) >>
 					OCRDMA_CQE_UD_XFER_LEN_SHIFT);
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
