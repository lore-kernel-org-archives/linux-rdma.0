From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/6] i40iw: Use correct alignment for CQ0 memory
Date: Tue,  8 Aug 2017 20:38:47 -0500
Message-ID: <20170809013848.29080-6-henry.orosco@intel.com>
References: <20170809013848.29080-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809013848.29080-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Utilize correct alignment variable when allocating
DMA memory for CQ0.

Signed-off-by: Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index 71050c5..7f5583d 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -685,7 +685,7 @@ static enum i40iw_status_code i40iw_puda_cq_create(struct i40iw_puda_rsrc *rsrc)
 	cqsize = rsrc->cq_size * (sizeof(struct i40iw_cqe));
 	tsize = cqsize + sizeof(struct i40iw_cq_shadow_area);
 	ret = i40iw_allocate_dma_mem(dev->hw, &rsrc->cqmem, tsize,
-				     I40IW_CQ0_ALIGNMENT_MASK);
+				     I40IW_CQ0_ALIGNMENT);
 	if (ret)
 		return ret;
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
