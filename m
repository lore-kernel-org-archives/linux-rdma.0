From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 03/16] IB/hfi1: Validate SDMA user request index
Date: Thu, 28 Jul 2016 15:21:14 -0400
Message-ID: <1469733687-31738-4-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 6b8d1e8b6286..0a0281ae35f1 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -552,6 +552,14 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
 				     (u16 *)&info);
+
+	if (info.comp_idx >= hfi1_sdma_comp_ring_size) {
+		hfi1_cdbg(SDMA,
+			  "[%u:%u:%u:%u] Invalid comp index",
+			  dd->unit, uctxt->ctxt, fd->subctxt, info.comp_idx);
+		return -EINVAL;
+	}
+
 	if (cq->comps[info.comp_idx].status == QUEUED ||
 	    test_bit(SDMA_REQ_IN_USE, &pq->reqs[info.comp_idx].flags)) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
