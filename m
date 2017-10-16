From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 03/12] i40iw: Remove unused static_rsrc from i40iw_create_qp_info
Date: Mon, 16 Oct 2017 15:45:56 -0500
Message-ID: <20171016204605.37512-4-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The field static_rsrc in i40iw_create_qp_info is unused
and not needed. Remove it.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 --
 drivers/infiniband/hw/i40iw/i40iw_d.h    | 3 ---
 drivers/infiniband/hw/i40iw/i40iw_type.h | 2 --
 3 files changed, 7 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 810fdda..f75144e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2448,7 +2448,6 @@ static enum i40iw_status_code i40iw_sc_qp_create(
 		 LS_64(qp->qp_type, I40IW_CQPSQ_QP_QPTYPE) |
 		 LS_64(qp->virtual_map, I40IW_CQPSQ_QP_VQ) |
 		 LS_64(info->cq_num_valid, I40IW_CQPSQ_QP_CQNUMVALID) |
-		 LS_64(info->static_rsrc, I40IW_CQPSQ_QP_STATRSRC) |
 		 LS_64(info->arp_cache_idx_valid, I40IW_CQPSQ_QP_ARPTABIDXVALID) |
 		 LS_64(info->next_iwarp_state, I40IW_CQPSQ_QP_NEXTIWSTATE) |
 		 LS_64(cqp->polarity, I40IW_CQPSQ_WQEVALID);
@@ -2511,7 +2510,6 @@ static enum i40iw_status_code i40iw_sc_qp_modify(
 		 LS_64(info->cq_num_valid, I40IW_CQPSQ_QP_CQNUMVALID) |
 		 LS_64(info->force_loopback, I40IW_CQPSQ_QP_FORCELOOPBACK) |
 		 LS_64(qp->qp_type, I40IW_CQPSQ_QP_QPTYPE) |
-		 LS_64(info->static_rsrc, I40IW_CQPSQ_QP_STATRSRC) |
 		 LS_64(info->remove_hash_idx, I40IW_CQPSQ_QP_REMOVEHASHENTRY) |
 		 LS_64(term_actions, I40IW_CQPSQ_QP_TERMACT) |
 		 LS_64(info->reset_tcp_conn, I40IW_CQPSQ_QP_RESETCON) |
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index 60c785a..40d4743 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -540,9 +540,6 @@
 #define I40IW_CQPSQ_QP_MSSCHANGE_SHIFT 52
 #define I40IW_CQPSQ_QP_MSSCHANGE_MASK (1ULL << I40IW_CQPSQ_QP_MSSCHANGE_SHIFT)
 
-#define I40IW_CQPSQ_QP_STATRSRC_SHIFT 53
-#define I40IW_CQPSQ_QP_STATRSRC_MASK (1ULL << I40IW_CQPSQ_QP_STATRSRC_SHIFT)
-
 #define I40IW_CQPSQ_QP_IGNOREMWBOUND_SHIFT 54
 #define I40IW_CQPSQ_QP_IGNOREMWBOUND_MASK       \
 	(1ULL << I40IW_CQPSQ_QP_IGNOREMWBOUND_SHIFT)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
index 63118f6..0ee450d4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_type.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
@@ -534,7 +534,6 @@ struct i40iw_create_qp_info {
 	bool ord_valid;
 	bool tcp_ctx_valid;
 	bool cq_num_valid;
-	bool static_rsrc;
 	bool arp_cache_idx_valid;
 };
 
@@ -546,7 +545,6 @@ struct i40iw_modify_qp_info {
 	bool ord_valid;
 	bool tcp_ctx_valid;
 	bool cq_num_valid;
-	bool static_rsrc;
 	bool arp_cache_idx_valid;
 	bool reset_tcp_conn;
 	bool remove_hash_idx;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
