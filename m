From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 10/10] i40iw: Remove SQ size constraint
Date: Thu,  8 Dec 2016 12:16:41 -0600
Message-ID: <1481221001-1044-11-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481221001-1044-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Pre-production firmware does not invalidate RQ PBL indexes
if the RQ base is not cache aligned. Remove the workaround
which constraints SQ depth to be a multiple of 1024.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_d.h      | 3 ---
 providers/i40iw/i40iw_uverbs.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/providers/i40iw/i40iw_d.h b/providers/i40iw/i40iw_d.h
index 1906cbf..174115c 100644
--- a/providers/i40iw/i40iw_d.h
+++ b/providers/i40iw/i40iw_d.h
@@ -1318,9 +1318,6 @@
 /* wqe size considering 32 bytes per wqe*/
 #define I40IWQP_SW_MIN_WQSIZE 4		/* 128 bytes */
 #define I40IWQP_SW_MAX_WQSIZE 2048	/* 2048 bytes */
-
-#define I40IWQP_SW_WQSIZE_1024 1024
-
 #define I40IWQP_OP_RDMA_WRITE 0
 #define I40IWQP_OP_RDMA_READ 1
 #define I40IWQP_OP_RDMA_SEND 3
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 85ed77c..75b7cb0 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -537,8 +537,6 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	struct ibv_reg_mr_resp reg_mr_resp;
 
 	memset(&reg_mr_cmd, 0, sizeof(reg_mr_cmd));
-	if ((sqdepth % I40IWQP_SW_WQSIZE_1024))
-		sqdepth = sqdepth + I40IWQP_SW_WQSIZE_1024 - (sqdepth % I40IWQP_SW_WQSIZE_1024);
 	sqsize = sqdepth * I40IW_QP_WQE_MIN_SIZE;
 	rqsize = rqdepth * I40IW_QP_WQE_MIN_SIZE;
 
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
