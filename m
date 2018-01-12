From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 3/5] i40iw: Remove limit on re-posting AEQ entries to HW
Date: Thu, 11 Jan 2018 18:10:52 -0600
Message-ID: <20180112001054.15572-4-shiraz.saleem@intel.com>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Sindhu Devale <sindhu.devale-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sindhu Devale <sindhu.devale-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, if the number of processed Asynchronous
Event Queue (AEQ) entries exceeds 255, they are
not returned to HW for re-use. During scale-up,
the unreturned AEQ entries can grow to the max AEQ size
and cause the HW to report an AEQ overflow.

Remove the check which limits the number of processed
AEQ entries returned to HW.

Fixes: 86dbcd0f12e9 ("RDMA/i40iw: add file to handle cqp calls")
Signed-off-by: Sindhu Devale <sindhu.devale-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 --
 drivers/infiniband/hw/i40iw/i40iw_user.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index c91dcfd..c74fd33 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -1893,8 +1893,6 @@ static enum i40iw_status_code i40iw_sc_get_next_aeqe(struct i40iw_sc_aeq *aeq,
 static enum i40iw_status_code i40iw_sc_repost_aeq_entries(struct i40iw_sc_dev *dev,
 							  u32 count)
 {
-	if (count > I40IW_MAX_AEQ_ALLOCATE_COUNT)
-		return I40IW_ERR_INVALID_SIZE;
 
 	if (dev->is_pf)
 		i40iw_wr32(dev->hw, I40E_PFPE_AEQALLOC, count);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 5467c6f..b125925 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -59,7 +59,6 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_CEQ_ENTRIES =			131071,
 	I40IW_MIN_CQ_SIZE =			1,
 	I40IW_MAX_CQ_SIZE =			1048575,
-	I40IW_MAX_AEQ_ALLOCATE_COUNT =		255,
 	I40IW_DB_ID_ZERO =			0,
 	I40IW_MAX_WQ_FRAGMENT_COUNT =		3,
 	I40IW_MAX_SGE_RD =			1,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
