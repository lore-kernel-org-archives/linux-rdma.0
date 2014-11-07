From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: limit MRs to < 8GB for T4/T5 devices
Date: Fri,  7 Nov 2014 10:20:32 +0530
Message-ID: <1415335832-11413-3-git-send-email-hariprasad@chelsio.com>
References: <1415335832-11413-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415335832-11413-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T4/T5 hardware can't handle MRs >= 8GB due to a hardware bug.  So limit
registrations to < 8GB for thse devices.

Based on original work by Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index ec7a298..d5dd3f2 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -50,6 +50,13 @@ static int inline_threshold = C4IW_INLINE_THRESHOLD;
 module_param(inline_threshold, int, 0644);
 MODULE_PARM_DESC(inline_threshold, "inline vs dsgl threshold (default=128)");
 
+static int mr_exceeds_hw_limits(struct c4iw_dev *dev, u64 length)
+{
+	return (is_t4(dev->rdev.lldi.adapter_type) ||
+		is_t5(dev->rdev.lldi.adapter_type)) &&
+		length >= 8*1024*1024*1024ULL;
+}
+
 static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 				       u32 len, dma_addr_t data, int wait)
 {
@@ -536,6 +543,11 @@ int c4iw_reregister_phys_mem(struct ib_mr *mr, int mr_rereg_mask,
 			return ret;
 	}
 
+	if (mr_exceeds_hw_limits(rhp, total_size)) {
+		kfree(page_list);
+		return -EINVAL;
+	}
+
 	ret = reregister_mem(rhp, php, &mh, shift, npages);
 	kfree(page_list);
 	if (ret)
@@ -596,6 +608,12 @@ struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
 	if (ret)
 		goto err;
 
+	if (mr_exceeds_hw_limits(rhp, total_size)) {
+		kfree(page_list);
+		ret = -EINVAL;
+		goto err;
+	}
+
 	ret = alloc_pbl(mhp, npages);
 	if (ret) {
 		kfree(page_list);
@@ -699,6 +717,10 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	php = to_c4iw_pd(pd);
 	rhp = php->rhp;
+
+	if (mr_exceeds_hw_limits(rhp, length))
+		return ERR_PTR(-EINVAL);
+
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
 	if (!mhp)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
