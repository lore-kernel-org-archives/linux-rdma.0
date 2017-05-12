From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/hfi1: Remove unnecessary initialization
 from tx request
Date: Fri, 12 May 2017 09:19:36 -0700
Message-ID: <20170512161930.1290.44487.stgit@scvm10.sc.intel.com>
References: <20170512161106.1290.45891.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512161106.1290.45891.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The tx request is unnecessarily initialized in the hot
code path with memset(), however, there's no need to do
this as most fields are initialized later on. this
initialization shows to be costly in the profile.
Remove unnecessary initialization from tx request and make
sure all variables are initialized properly.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index d55339f..16fd519 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -607,12 +607,19 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Using req/comp entry %u\n", dd->unit,
 		  uctxt->ctxt, fd->subctxt, info.comp_idx);
 	req = pq->reqs + info.comp_idx;
-	memset(req, 0, sizeof(*req));
 	req->data_iovs = req_iovcnt(info.ctrl) - 1; /* subtract header vector */
+	req->data_len  = 0;
 	req->pq = pq;
 	req->cq = cq;
 	req->status = -1;
 	req->ahg_idx = -1;
+	req->iov_idx = 0;
+	req->sent = 0;
+	req->seqnum = 0;
+	req->seqcomp = 0;
+	req->seqsubmitted = 0;
+	req->flags = 0;
+	req->tids = NULL;
 	INIT_LIST_HEAD(&req->txps);
 
 	memcpy(&req->info, &info, sizeof(info));
@@ -701,12 +708,14 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 
 	/* Save all the IO vector structures */
 	for (i = 0; i < req->data_iovs; i++) {
+		req->iovs[i].offset = 0;
 		INIT_LIST_HEAD(&req->iovs[i].list);
 		memcpy(&req->iovs[i].iov,
 		       iovec + idx++,
 		       sizeof(req->iovs[i].iov));
 		ret = pin_vector_pages(req, &req->iovs[i]);
 		if (ret) {
+			req->data_iovs = i;
 			req->status = ret;
 			goto free_req;
 		}
@@ -749,6 +758,7 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 		}
 		req->tids = tmp;
 		req->n_tids = ntids;
+		req->tididx = 0;
 		idx++;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
