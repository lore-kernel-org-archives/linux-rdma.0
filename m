From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/6] i40iw: Fix potential fcn_id_array out of bounds
Date: Tue,  8 Aug 2017 20:38:48 -0500
Message-ID: <20170809013848.29080-7-henry.orosco@intel.com>
References: <20170809013848.29080-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809013848.29080-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Avoid out of bounds error by utilizing I40IW_MAX_STATS_COUNT
instead of I40IW_INVALID_FCN_ID.

Signed-off-by: Christopher N Bednarz <christoper.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 99d9613..d1f5345 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -4892,7 +4892,7 @@ void i40iw_vsi_stats_free(struct i40iw_sc_vsi *vsi)
 {
 	u8 fcn_id = vsi->fcn_id;
 
-	if ((vsi->stats_fcn_id_alloc) && (fcn_id != I40IW_INVALID_FCN_ID))
+	if (vsi->stats_fcn_id_alloc && fcn_id < I40IW_MAX_STATS_COUNT)
 		vsi->dev->fcn_id_array[fcn_id] = false;
 	i40iw_hw_stats_stop_timer(vsi);
 }
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
