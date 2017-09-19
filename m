From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] i40iw: Call i40iw_cm_disconn on modify QP to disconnect
Date: Tue, 19 Sep 2017 09:19:11 -0500
Message-ID: <20170919141913.10172-4-shiraz.saleem@intel.com>
References: <20170919141913.10172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170919141913.10172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If QP modify to closing/terminate/error fails, connection is
not torn down as there is no corresponding asynchronous
event that will initiate the teardown.

Add explicit call to i40iw_cm_disconn if not waiting in
modify QP, otherwise schedule it in CM timer.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 1aa4110..28b3d02 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1027,7 +1027,19 @@ int i40iw_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				iwqp->hw_tcp_state = I40IW_TCP_STATE_CLOSED;
 				iwqp->last_aeq = I40IW_AE_RESET_SENT;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
+				i40iw_cm_disconn(iwqp);
 			}
+		} else {
+			spin_lock_irqsave(&iwqp->lock, flags);
+			if (iwqp->cm_id) {
+				if (atomic_inc_return(&iwqp->close_timer_started) == 1) {
+					iwqp->cm_id->add_ref(iwqp->cm_id);
+					i40iw_schedule_cm_timer(iwqp->cm_node,
+								(struct i40iw_puda_buf *)iwqp,
+								 I40IW_TIMER_TYPE_CLOSE, 1, 0);
+				}
+			}
+			spin_unlock_irqrestore(&iwqp->lock, flags);
 		}
 	}
 	return 0;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
