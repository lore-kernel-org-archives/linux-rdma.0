From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] i40iw: Enable level-1 PBL for fast memory registration
Date: Tue, 14 Jun 2016 16:54:19 -0500
Message-ID: <1465941259-4492-5-git-send-email-shiraz.saleem@intel.com>
References: <1465941259-4492-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465941259-4492-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set the chunk_size to enable level-1 PBL support when the fast memory
page count is more than one.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       | 1 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 14f16a2..b738acd 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -114,6 +114,7 @@
 #define IW_HMC_OBJ_TYPE_NUM ARRAY_SIZE(iw_hmc_obj_types)
 #define IW_CFG_FPM_QP_COUNT		32768
 #define I40IW_MAX_PAGES_PER_FMR		512
+#define I40IW_MIN_PAGES_PER_FMR		1
 
 #define I40IW_MTU_TO_MSS		40
 #define I40IW_DEFAULT_MSS		1460
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 31eda323..33959ed 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2150,6 +2150,7 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			struct i40iw_sc_dev *dev = &iwqp->iwdev->sc_dev;
 			struct i40iw_fast_reg_stag_info info;
 
+			memset(&info, 0, sizeof(info));
 			info.access_rights = I40IW_ACCESS_FLAGS_LOCALREAD;
 			info.access_rights |= i40iw_get_user_access(flags);
 			info.stag_key = reg_wr(ib_wr)->key & 0xff;
@@ -2159,10 +2160,14 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			info.addr_type = I40IW_ADDR_TYPE_VA_BASED;
 			info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
 			info.total_len = iwmr->ibmr.length;
+			info.reg_addr_pa = *(u64 *)palloc->level1.addr;
 			info.first_pm_pbl_index = palloc->level1.idx;
 			info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
 			info.signaled = ib_wr->send_flags & IB_SEND_SIGNALED;
 
+			if (iwmr->npages > I40IW_MIN_PAGES_PER_FMR)
+				info.chunk_size = 1;
+
 			if (page_shift == 21)
 				info.page_size = 1; /* 2M page */
 
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
