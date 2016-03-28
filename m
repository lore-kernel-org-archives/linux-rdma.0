From: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Subject: [PATCH] i40iw: Remove unnecessary synchronize_irq() before free_irq()
Date: Mon, 28 Mar 2016 11:31:26 +0200
Message-ID: <1459157486-23257-1-git-send-email-lars@metafoo.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Patch was generated using the following semantic patch:
// <smpl>
@@
expression irq;
@@
-synchronize_irq(irq);
 free_irq(irq, ...);
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 90e5af2..006c44f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -270,7 +270,6 @@ static void i40iw_disable_irq(struct i40iw_sc_dev *dev,
 		i40iw_wr32(dev->hw, I40E_PFINT_DYN_CTLN(msix_vec->idx - 1), 0);
 	else
 		i40iw_wr32(dev->hw, I40E_VFINT_DYN_CTLN1(msix_vec->idx - 1), 0);
-	synchronize_irq(msix_vec->irq);
 	free_irq(msix_vec->irq, dev_id);
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
