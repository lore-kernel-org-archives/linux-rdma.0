From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] RDMA/i40iw: Correct STag mask to min of 14 bits
Date: Fri, 22 Apr 2016 14:14:24 -0500
Message-ID: <1461352469-16504-3-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Chien Tin Tung <Chien.Tin.Tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

STag index mask is calculated incorrectly, missing
the 14 bits minimum requirement. Add max macro to use
either # of MRs or 14 bits in the mask size calculation.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 615e115..3ee0cad 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -107,7 +107,8 @@ u32 i40iw_initialize_hw_resources(struct i40iw_device *iwdev)
 
 	spin_lock_init(&iwdev->resource_lock);
 	spin_lock_init(&iwdev->qptable_lock);
-	mrdrvbits = 24 - get_count_order(iwdev->max_mr);
+	/* stag index mask has a minimum of 14 bits */
+	mrdrvbits = 24 - max(get_count_order(iwdev->max_mr), 14);
 	iwdev->mr_stagmask = ~(((1 << mrdrvbits) - 1) << (32 - mrdrvbits));
 	return 0;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
