From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/12] i40iw: Move cqp_cmd_head init to CQP initialization
Date: Mon, 16 Oct 2017 15:46:05 -0500
Message-ID: <20171016204605.37512-13-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Bob Sharp <Robert.O.Sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bob Sharp <Robert.O.Sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Control QP (CQP) command backlog list is initialized at
device initialization time.  It is not reinitialized in
the reset flow.  Move the initialization to CQP creation
time so the list can be initialized correctly for reset as well.

Fixes: 86dbcd0f12e9 ("i40iw: add file to handle cqp calls")
Signed-off-by: Bob Sharp <Robert.O.Sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 25625a4..eb95d23 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -482,6 +482,7 @@ static enum i40iw_status_code i40iw_sc_cqp_init(struct i40iw_sc_cqp *cqp,
 	I40IW_RING_INIT(cqp->sq_ring, cqp->sq_size);
 	cqp->dev->cqp_cmd_stats[OP_REQUESTED_COMMANDS] = 0;
 	cqp->dev->cqp_cmd_stats[OP_COMPLETED_COMMANDS] = 0;
+	INIT_LIST_HEAD(&cqp->dev->cqp_cmd_head);               /* for the cqp commands backlog. */
 
 	i40iw_wr32(cqp->dev->hw, I40E_PFPE_CQPTAIL, 0);
 	i40iw_wr32(cqp->dev->hw, I40E_PFPE_CQPDB, 0);
@@ -5066,7 +5067,6 @@ enum i40iw_status_code i40iw_device_init(struct i40iw_sc_dev *dev,
 	u8 db_size;
 
 	spin_lock_init(&dev->cqp_lock);
-	INIT_LIST_HEAD(&dev->cqp_cmd_head);             /* for the cqp commands backlog. */
 
 	i40iw_device_init_uk(&dev->dev_uk);
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
