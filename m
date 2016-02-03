From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 50/54] staging/rdma/hfi1: Fix bug that could block the
 process on context exit
Date: Wed, 03 Feb 2016 14:37:41 -0800
Message-ID: <20160203223737.5923.45520.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A race was discovred in the user SDMA code, which could result
in an process being stuck in the kernel call indefinitely in
certain error conditions.

If, during the processing of a user SDMA request, there was an
error *and* all outstanding SDMA descriptor had been completed
by the time the that error case was handled in the calling function,
the state of the packet queue would not get correctly updated
resulting in the process subsequently getting stuck, thinking that
there are more descriptors to be completed.

To handle this scenario, the driver now checks the submitted
packet count vs. the completed. If all submitted packets have also
been completed, the driver can safely free the request and signal
user level. Otherwise, this will be handled by the completion
callback.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 55c7e6a..ac90309 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -678,7 +678,6 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	ret = user_sdma_send_pkts(req, pcount);
 	if (unlikely(ret < 0 && ret != -EBUSY)) {
 		req->status = ret;
-		atomic_dec(&pq->n_reqs);
 		goto free_req;
 	}
 
@@ -703,6 +702,9 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 			if (ret != -EBUSY) {
 				req->status = ret;
 				set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+				if (ACCESS_ONCE(req->seqcomp) ==
+				    req->seqsubmitted - 1)
+					goto free_req;
 				return ret;
 			}
 			wait_event_interruptible_timeout(
@@ -717,6 +719,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	return 0;
 free_req:
 	user_sdma_free_request(req, true);
+	pq_update(pq);
 	set_comp_state(pq, cq, info.comp_idx, ERROR, req->status);
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
