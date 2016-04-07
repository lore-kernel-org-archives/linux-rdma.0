From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 07/16] i40iw: Set vendor_err only if there is an actual error
Date: Thu,  7 Apr 2016 11:30:55 -0500
Message-ID: <1460046664-552-8-git-send-email-mustafa.ismail@intel.com>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460046664-552-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a check for cq_poll_info.error before setting vendor_err
instead of always setting it.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 96f4ff1..590c699 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2047,10 +2047,12 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 		}
 		entry->wc_flags = 0;
 		entry->wr_id = cq_poll_info.wr_id;
-		if (!cq_poll_info.error)
-			entry->status = IB_WC_SUCCESS;
-		else
+		if (cq_poll_info.error) {
 			entry->status = IB_WC_WR_FLUSH_ERR;
+			entry->vendor_err = cq_poll_info.major_err << 16 | cq_poll_info.minor_err;
+		} else {
+			entry->status = IB_WC_SUCCESS;
+		}
 
 		switch (cq_poll_info.op_type) {
 		case I40IW_OP_TYPE_RDMA_WRITE:
@@ -2074,8 +2076,6 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 			break;
 		}
 
-		entry->vendor_err =
-		    cq_poll_info.major_err << 16 | cq_poll_info.minor_err;
 		entry->ex.imm_data = 0;
 		qp = (struct i40iw_sc_qp *)cq_poll_info.qp_handle;
 		entry->qp = (struct ib_qp *)qp->back_qp;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
