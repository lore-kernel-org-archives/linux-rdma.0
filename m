From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] i40iw: Fix QP flush to not hang on empty queues or failure
Date: Tue,  6 Dec 2016 15:49:31 -0600
Message-ID: <20161206214935.41584-3-henry.orosco@intel.com>
References: <20161206214935.41584-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When flush QP and there are no pending work requests, signal completion
to unblock i40iw_drain_sq and i40iw_drain_rq which are waiting on
completion for iwqp->sq_drained and iwqp->sq_drained respectively.
Also, signal completion if flush QP fails to prevent the drain SQ or RQ
from being blocked indefintely.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h    |  9 ++++++---
 drivers/infiniband/hw/i40iw/i40iw_hw.c | 26 ++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 51b8280..2aab85b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -112,9 +112,12 @@
 #define I40IW_DRV_OPT_MCAST_LOGPORT_MAP    0x00000800
 
 #define IW_HMC_OBJ_TYPE_NUM ARRAY_SIZE(iw_hmc_obj_types)
-#define IW_CFG_FPM_QP_COUNT		32768
-#define I40IW_MAX_PAGES_PER_FMR		512
-#define I40IW_MIN_PAGES_PER_FMR		1
+#define IW_CFG_FPM_QP_COUNT               32768
+#define I40IW_MAX_PAGES_PER_FMR           512
+#define I40IW_MIN_PAGES_PER_FMR           1
+#define I40IW_CQP_COMPL_RQ_WQE_FLUSHED    2
+#define I40IW_CQP_COMPL_SQ_WQE_FLUSHED    3
+#define I40IW_CQP_COMPL_RQ_SQ_WQE_FLUSHED 4
 
 #define I40IW_MTU_TO_MSS		40
 #define I40IW_DEFAULT_MSS		1460
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index b2854b1..4394a67 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -622,6 +622,7 @@ enum i40iw_status_code i40iw_hw_flush_wqes(struct i40iw_device *iwdev,
 	struct i40iw_qp_flush_info *hw_info;
 	struct i40iw_cqp_request *cqp_request;
 	struct cqp_commands_info *cqp_info;
+	struct i40iw_qp *iwqp = (struct i40iw_qp *)qp->back_qp;
 
 	cqp_request = i40iw_get_cqp_request(&iwdev->cqp, wait);
 	if (!cqp_request)
@@ -636,9 +637,30 @@ enum i40iw_status_code i40iw_hw_flush_wqes(struct i40iw_device *iwdev,
 	cqp_info->in.u.qp_flush_wqes.qp = qp;
 	cqp_info->in.u.qp_flush_wqes.scratch = (uintptr_t)cqp_request;
 	status = i40iw_handle_cqp_op(iwdev, cqp_request);
-	if (status)
+	if (status) {
 		i40iw_pr_err("CQP-OP Flush WQE's fail");
-	return status;
+		complete(&iwqp->sq_drained);
+		complete(&iwqp->rq_drained);
+		return status;
+	}
+	if (!cqp_request->compl_info.maj_err_code) {
+		switch (cqp_request->compl_info.min_err_code) {
+		case I40IW_CQP_COMPL_RQ_WQE_FLUSHED:
+			complete(&iwqp->sq_drained);
+			break;
+		case I40IW_CQP_COMPL_SQ_WQE_FLUSHED:
+			complete(&iwqp->rq_drained);
+			break;
+		case I40IW_CQP_COMPL_RQ_SQ_WQE_FLUSHED:
+			break;
+		default:
+			complete(&iwqp->sq_drained);
+			complete(&iwqp->rq_drained);
+			break;
+		}
+	}
+
+	return 0;
 }
 
 /**
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
