From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 06/16] RDMA/i40iw: Add qp table lock around AE processing
Date: Wed, 13 Apr 2016 09:30:42 -0500
Message-ID: <1460557852-10824-7-git-send-email-mustafa.ismail@intel.com>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

QP may be freed during Async Event processing.
Add a lock around QP table to prevent it.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       | 1 +
 drivers/infiniband/hw/i40iw/i40iw_hw.c    | 7 +++++++
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 9 +++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 8197676..bf3627f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -254,6 +254,7 @@ struct i40iw_device {
 	u32 arp_table_size;
 	u32 next_arp_index;
 	spinlock_t resource_lock; /* hw resource access */
+	spinlock_t qptable_lock;
 	u32 vendor_id;
 	u32 vendor_part_id;
 	u32 of_device_registered;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 9fd3024..27cfdd8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -106,6 +106,7 @@ u32 i40iw_initialize_hw_resources(struct i40iw_device *iwdev)
 	set_bit(2, iwdev->allocated_pds);
 
 	spin_lock_init(&iwdev->resource_lock);
+	spin_lock_init(&iwdev->qptable_lock);
 	mrdrvbits = 24 - get_count_order(iwdev->max_mr);
 	iwdev->mr_stagmask = ~(((1 << mrdrvbits) - 1) << (32 - mrdrvbits));
 	return 0;
@@ -301,11 +302,15 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 			    "%s ae_id = 0x%x bool qp=%d qp_id = %d\n",
 			    __func__, info->ae_id, info->qp, info->qp_cq_id);
 		if (info->qp) {
+			spin_lock_irqsave(&iwdev->qptable_lock, flags);
 			iwqp = iwdev->qp_table[info->qp_cq_id];
 			if (!iwqp) {
+				spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
 				i40iw_pr_err("qp_id %d is already freed\n", info->qp_cq_id);
 				continue;
 			}
+			i40iw_add_ref(&iwqp->ibqp);
+			spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
 			qp = &iwqp->sc_qp;
 			spin_lock_irqsave(&iwqp->lock, flags);
 			iwqp->hw_tcp_state = info->tcp_state;
@@ -411,6 +416,8 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 				i40iw_terminate_connection(qp, info);
 				break;
 		}
+		if (info->qp)
+			i40iw_rem_ref(&iwqp->ibqp);
 	} while (1);
 
 	if (aeqcnt)
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 1ceec81..7ed998c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -506,14 +506,19 @@ void i40iw_rem_ref(struct ib_qp *ibqp)
 	struct cqp_commands_info *cqp_info;
 	struct i40iw_device *iwdev;
 	u32 qp_num;
+	unsigned long flags;
 
 	iwqp = to_iwqp(ibqp);
-	if (!atomic_dec_and_test(&iwqp->refcount))
+	iwdev = iwqp->iwdev;
+	spin_lock_irqsave(&iwdev->qptable_lock, flags);
+	if (!atomic_dec_and_test(&iwqp->refcount)) {
+		spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
 		return;
+	}
 
-	iwdev = iwqp->iwdev;
 	qp_num = iwqp->ibqp.qp_num;
 	iwdev->qp_table[qp_num] = NULL;
+	spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
 	cqp_request = i40iw_get_cqp_request(&iwdev->cqp, false);
 	if (!cqp_request)
 		return;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
