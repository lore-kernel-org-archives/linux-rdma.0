From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] RDMA/i40iw: Fix for checking if the QP is destroyed
Date: Fri, 22 Apr 2016 14:14:28 -0500
Message-ID: <1461352469-16504-7-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for checking if the QP associated with a completion
has been destroyed while processing CQ elements.
If that is the case, move the CQ head to the next element
and continue completion processing.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_status.h | 1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c     | 5 +++++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c  | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_status.h b/drivers/infiniband/hw/i40iw/i40iw_status.h
index b0110c1..91c4217 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_status.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_status.h
@@ -95,6 +95,7 @@ enum i40iw_status_code {
 	I40IW_ERR_INVALID_MAC_ADDR = -65,
 	I40IW_ERR_BAD_STAG      = -66,
 	I40IW_ERR_CQ_COMPL_ERROR = -67,
+	I40IW_ERR_QUEUE_DESTROYED = -68
 
 };
 #endif
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 2cd9091..e35faea8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -802,6 +802,10 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 	info->is_srq = (bool)RS_64(qword3, I40IWCQ_SRQ);
 
 	qp = (struct i40iw_qp_uk *)(unsigned long)comp_ctx;
+	if (!qp) {
+		ret_code = I40IW_ERR_QUEUE_DESTROYED;
+		goto exit;
+	}
 	wqe_idx = (u32)RS_64(qword3, I40IW_CQ_WQEIDX);
 	info->qp_handle = (i40iw_qp_handle)(unsigned long)qp;
 
@@ -859,6 +863,7 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 
 	ret_code = 0;
 
+exit:
 	if (!ret_code &&
 	    (info->comp_status == I40IW_COMPL_STATUS_FLUSHED))
 		if (pring && (I40IW_RING_MORE_WORK(*pring)))
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 45f70f5..eaa79c9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2259,6 +2259,8 @@ static int i40iw_poll_cq(struct ib_cq *ibcq,
 		ret = ukcq->ops.iw_cq_poll_completion(ukcq, &cq_poll_info, true);
 		if (ret == I40IW_ERR_QUEUE_EMPTY) {
 			break;
+		} else if (ret == I40IW_ERR_QUEUE_DESTROYED) {
+			continue;
 		} else if (ret) {
 			if (!cqe_count)
 				cqe_count = -1;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
