From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Use actual page size
Date: Wed,  9 Nov 2016 21:33:32 -0600
Message-ID: <20161110033332.20784-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In i40iw_post_send, use the actual page size instead of
encoded page size. This is to be consistent with the
rest of the file.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..8f138b8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2142,7 +2142,6 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 		case IB_WR_REG_MR:
 		{
 			struct i40iw_mr *iwmr = to_iwmr(reg_wr(ib_wr)->mr);
-			int page_shift = ilog2(reg_wr(ib_wr)->mr->page_size);
 			int flags = reg_wr(ib_wr)->access;
 			struct i40iw_pble_alloc *palloc = &iwmr->iwpbl.pble_alloc;
 			struct i40iw_sc_dev *dev = &iwqp->iwdev->sc_dev;
@@ -2153,6 +2152,7 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			info.access_rights |= i40iw_get_user_access(flags);
 			info.stag_key = reg_wr(ib_wr)->key & 0xff;
 			info.stag_idx = reg_wr(ib_wr)->key >> 8;
+			info.page_size = reg_wr(ib_wr)->mr->page_size;
 			info.wr_id = ib_wr->wr_id;
 
 			info.addr_type = I40IW_ADDR_TYPE_VA_BASED;
@@ -2166,9 +2166,6 @@ static int i40iw_post_send(struct ib_qp *ibqp,
 			if (iwmr->npages > I40IW_MIN_PAGES_PER_FMR)
 				info.chunk_size = 1;
 
-			if (page_shift == 21)
-				info.page_size = 1; /* 2M page */
-
 			ret = dev->iw_priv_qp_ops->iw_mr_fast_register(&iwqp->sc_qp, &info, true);
 			if (ret)
 				err = -ENOMEM;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
