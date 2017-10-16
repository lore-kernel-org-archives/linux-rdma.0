From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/12] i40iw: Clear CQP Head/Tail during initialization
Date: Mon, 16 Oct 2017 15:46:03 -0500
Message-ID: <20171016204605.37512-11-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christopher Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christopher Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clear Control Queue Pair (CQP) Head/Tail on CQP
initialization as during an adapter reset, these
values are not reinitialized. Tail is cleared by
writing 0 to CQP's tail register. Head is cleared
by writing 0 to CQP's doorbell register.

Fixes: 86dbcd0f12e9 ("i40iw: add file to handle cqp calls")
Signed-off-by: Christopher Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index c790f8b..70d86bc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -483,6 +483,9 @@ static enum i40iw_status_code i40iw_sc_cqp_init(struct i40iw_sc_cqp *cqp,
 	cqp->dev->cqp_cmd_stats[OP_REQUESTED_COMMANDS] = 0;
 	cqp->dev->cqp_cmd_stats[OP_COMPLETED_COMMANDS] = 0;
 
+	i40iw_wr32(cqp->dev->hw, I40E_PFPE_CQPTAIL, 0);
+	i40iw_wr32(cqp->dev->hw, I40E_PFPE_CQPDB, 0);
+
 	i40iw_debug(cqp->dev, I40IW_DEBUG_WQE,
 		    "%s: sq_size[%04d] hw_sq_size[%04d] sq_base[%p] sq_pa[%llxh] cqp[%p] polarity[x%04X]\n",
 		    __func__, cqp->sq_size, cqp->hw_sq_size,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
