From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/16] IB/hfi1: Validate SDMA user iovector count
Date: Thu, 28 Jul 2016 15:21:15 -0400
Message-ID: <1469733687-31738-5-git-send-email-ira.weiny@intel.com>
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
 drivers/infiniband/hw/hfi1/user_sdma.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 0a0281ae35f1..42cc371cdf95 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -560,6 +560,18 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		return -EINVAL;
 	}
 
+	/*
+	 * Sanity check the header io vector count.  Need at least 1 vector
+	 * (header) and cannot be larger than the actual io vector count.
+	 */
+	if (req_iovcnt(info.ctrl) < 1 || req_iovcnt(info.ctrl) > dim) {
+		hfi1_cdbg(SDMA,
+			  "[%u:%u:%u:%u] Invalid iov count %d, dim %ld",
+			  dd->unit, uctxt->ctxt, fd->subctxt, info.comp_idx,
+			  req_iovcnt(info.ctrl), dim);
+		return -EINVAL;
+	}
+
 	if (cq->comps[info.comp_idx].status == QUEUED ||
 	    test_bit(SDMA_REQ_IN_USE, &pq->reqs[info.comp_idx].flags)) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
@@ -583,7 +595,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	memset(req, 0, sizeof(*req));
 	/* Mark the request as IN_USE before we start filling it in. */
 	set_bit(SDMA_REQ_IN_USE, &req->flags);
-	req->data_iovs = req_iovcnt(info.ctrl) - 1;
+	req->data_iovs = req_iovcnt(info.ctrl) - 1; /* subtract header vector */
 	req->pq = pq;
 	req->cq = cq;
 	req->status = -1;
@@ -591,8 +603,16 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	memcpy(&req->info, &info, sizeof(info));
 
-	if (req_opcode(info.ctrl) == EXPECTED)
+	if (req_opcode(info.ctrl) == EXPECTED) {
+		/* expected must have a TID info and at least one data vector */
+		if (req->data_iovs < 2) {
+			SDMA_DBG(req,
+				 "Not enough vectors for expected request");
+			ret = -EINVAL;
+			goto free_req;
+		}
 		req->data_iovs--;
+	}
 
 	if (!info.npkts || req->data_iovs > MAX_VECTORS_PER_REQ) {
 		SDMA_DBG(req, "Too many vectors (%u/%u)", req->data_iovs,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
