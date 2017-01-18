From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Set maj_err and min_err in i40iw_sc_cqp_create
Date: Wed, 18 Jan 2017 11:48:29 -0600
Message-ID: <1484761709-6072-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set maj_err and min_err in i40iw_sc_cqp_create so that it
returns correct values for all return cases. This also
addresses an uninitialized variable warning for maj_err and
min_err in i40iw_create_cqp.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 2c4b4d0..47a2529 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -315,6 +315,9 @@ static enum i40iw_status_code i40iw_sc_cqp_create(struct i40iw_sc_cqp *cqp,
 	u32 cnt = 0, p1, p2, val = 0, err_code;
 	enum i40iw_status_code ret_code;
 
+	*maj_err = 0;
+	*min_err = 0;
+
 	ret_code = i40iw_allocate_dma_mem(cqp->dev->hw,
 					  &cqp->sdbuf,
 					  128,
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
