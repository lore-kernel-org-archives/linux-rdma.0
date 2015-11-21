From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] staging/rdma/hfi1: Eliminate WARN_ON when VL is invalid
Date: Fri, 20 Nov 2015 19:43:47 -0500
Message-ID: <1448066627-18454-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

sdma_select_engine_vl only needs to protect itself from an invalid VL.
Something higher up the stack should be warning the user when they try
to use an SL which maps to an invalid VL.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Removed unlikely() in sdma_select_engine_vl()
Changes in v3:
	- Refreshed patch against latest staging-next

 drivers/staging/rdma/hfi1/sdma.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 90b7072..0710e2a 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -765,8 +765,14 @@ struct sdma_engine *sdma_select_engine_vl(
 	struct sdma_map_elem *e;
 	struct sdma_engine *rval;
 
-	if (WARN_ON(vl > 8))
-		return &dd->per_sdma[0];
+	/* NOTE This should only happen if SC->VL changed after the initial
+	 *      checks on the QP/AH
+	 *      Default will return engine 0 below
+	 */
+	if (vl >= num_vls) {
+		rval = NULL;
+		goto done;
+	}
 
 	rcu_read_lock();
 	m = rcu_dereference(dd->sdma_map);
@@ -778,6 +784,7 @@ struct sdma_engine *sdma_select_engine_vl(
 	rval = e->sde[selector & e->mask];
 	rcu_read_unlock();
 
+done:
 	rval =  !rval ? &dd->per_sdma[0] : rval;
 	trace_hfi1_sdma_engine_select(dd, selector, vl, rval->this_idx);
 	return rval;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
