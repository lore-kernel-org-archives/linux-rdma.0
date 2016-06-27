From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.7] i40iw: Enable remote access rights for stag allocation
Date: Mon, 27 Jun 2016 16:52:14 -0500
Message-ID: <1467064334-12064-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix to enable remote access rights when allocating stag.

Fixes: b7aee855d3b9 ("RDMA/i40iw: Add base memory management extensions")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 33959ed..283b64c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1474,6 +1474,7 @@ static int i40iw_hw_alloc_stag(struct i40iw_device *iwdev, struct i40iw_mr *iwmr
 	info->stag_idx = iwmr->stag >> I40IW_CQPSQ_STAG_IDX_SHIFT;
 	info->pd_id = iwpd->sc_pd.pd_id;
 	info->total_len = iwmr->length;
+	info->remote_access = true;
 	cqp_info->cqp_cmd = OP_ALLOC_STAG;
 	cqp_info->post_sq = 1;
 	cqp_info->in.u.alloc_stag.dev = &iwdev->sc_dev;
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
