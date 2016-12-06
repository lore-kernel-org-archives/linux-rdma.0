From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] i40iw: Fix memory leak in CQP destroy when in reset
Date: Tue,  6 Dec 2016 15:49:32 -0600
Message-ID: <20161206214935.41584-4-henry.orosco@intel.com>
References: <20161206214935.41584-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On a device close, the control QP (CQP) is destroyed by calling
cqp_destroy which destroys the CQP and frees its SD buffer memory.
However, if the reset flag is true, cqp_destroy is never called and
leads to a memory leak on SD buffer memory. Fix this by always calling
cqp_destroy, on device close, regardless of reset. The exception to this
when CQP create fails. In this case, the SD buffer memory is already
freed on an error check and there is no need to call cqp_destroy.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 4ce05b8..85d8fa6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -237,14 +237,11 @@ static irqreturn_t i40iw_irq_handler(int irq, void *data)
  */
 static void i40iw_destroy_cqp(struct i40iw_device *iwdev, bool free_hwcqp)
 {
-	enum i40iw_status_code status = 0;
 	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
 	struct i40iw_cqp *cqp = &iwdev->cqp;
 
-	if (free_hwcqp && dev->cqp_ops->cqp_destroy)
-		status = dev->cqp_ops->cqp_destroy(dev->cqp);
-	if (status)
-		i40iw_pr_err("destroy cqp failed");
+	if (free_hwcqp)
+		dev->cqp_ops->cqp_destroy(dev->cqp);
 
 	i40iw_free_dma_mem(dev->hw, &cqp->sq);
 	kfree(cqp->scratch_array);
@@ -1475,7 +1472,7 @@ static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset)
 		i40iw_del_hmc_objects(dev, dev->hmc_info, true, reset);
 		/* fallthrough */
 	case CQP_CREATED:
-		i40iw_destroy_cqp(iwdev, !reset);
+		i40iw_destroy_cqp(iwdev, true);
 		/* fallthrough */
 	case INITIAL_STATE:
 		i40iw_cleanup_cm_core(&iwdev->cm_core);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
