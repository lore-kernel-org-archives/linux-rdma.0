From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] staging/rdma/hfi1: Eliminate WARN_ON when VL is invalid
Date: Mon,  9 Nov 2015 19:18:21 -0500
Message-ID: <1447114701-11003-3-git-send-email-jubin.john@intel.com>
References: <1447114701-11003-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447114701-11003-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
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
 drivers/staging/rdma/hfi1/sdma.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 2a1da21..d7982a7 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -777,8 +777,14 @@ struct sdma_engine *sdma_select_engine_vl(
 	struct sdma_map_elem *e;
 	struct sdma_engine *rval;
 
-	if (WARN_ON(vl > 8))
-		return NULL;
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
@@ -790,6 +796,8 @@ struct sdma_engine *sdma_select_engine_vl(
 	rval = e->sde[selector & e->mask];
 	rcu_read_unlock();
 
+done:
+	rval =  !rval ? &dd->per_sdma[0] : rval;
 	trace_hfi1_sdma_engine_select(dd, selector, vl, rval->this_idx);
 	return rval;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
