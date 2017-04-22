From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2 01/12] IB/ocrdma: Use kcalloc() in
 ocrdma_mbx_alloc_pd_range()
Date: Sat, 22 Apr 2017 16:30:29 +0200
Message-ID: <21442d70-e77b-8338-30f7-9c41d048a665@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 22 Apr 2017 11:33:25 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Delete the local variable "pd_bitmap_size" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aa6967197620..c868314222b9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1505,7 +1505,6 @@ int ocrdma_mbx_dealloc_pd(struct ocrdma_dev *dev, struct ocrdma_pd *pd)
 static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 {
 	int status = -ENOMEM;
-	size_t pd_bitmap_size;
 	struct ocrdma_alloc_pd_range *cmd;
 	struct ocrdma_alloc_pd_range_rsp *rsp;
 
@@ -1527,10 +1526,10 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 			dev->pd_mgr->pd_dpp_start = rsp->dpp_page_pdid &
 					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
 			dev->pd_mgr->max_dpp_pd = rsp->pd_count;
-			pd_bitmap_size =
-				BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
-			dev->pd_mgr->pd_dpp_bitmap = kzalloc(pd_bitmap_size,
-							     GFP_KERNEL);
+			dev->pd_mgr->pd_dpp_bitmap
+				= kcalloc(BITS_TO_LONGS(rsp->pd_count),
+							sizeof(long),
+							GFP_KERNEL);
 		}
 		kfree(cmd);
 	}
@@ -1546,9 +1545,10 @@ static int ocrdma_mbx_alloc_pd_range(struct ocrdma_dev *dev)
 		dev->pd_mgr->pd_norm_start = rsp->dpp_page_pdid &
 					OCRDMA_ALLOC_PD_RNG_RSP_START_PDID_MASK;
 		dev->pd_mgr->max_normal_pd = rsp->pd_count;
-		pd_bitmap_size = BITS_TO_LONGS(rsp->pd_count) * sizeof(long);
-		dev->pd_mgr->pd_norm_bitmap = kzalloc(pd_bitmap_size,
-						      GFP_KERNEL);
+		dev->pd_mgr->pd_norm_bitmap
+			= kcalloc(BITS_TO_LONGS(rsp->pd_count),
+						sizeof(long),
+						GFP_KERNEL);
 	}
 	kfree(cmd);
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
