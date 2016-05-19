From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] IB/hfi1: Fix bug that blocks process on exit after port
 bounce
Date: Thu, 19 May 2016 05:21:57 -0700
Message-ID: <20160519122155.30706.53916.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During the processing of a user SDMA request, if there was an
error before the request counter was increased, the state of
the packet queue could be updated incorrectly, causing the
counter to underflow. As the result, the process could get
stuck later since the counter could never get back to 0.

This patch adds a condition to guard the packet queue update
so that the counter is only decreased if it has been increased
before the error happens.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index aed2878..29f4795 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -510,6 +510,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	struct sdma_req_info info;
 	struct user_sdma_request *req;
 	u8 opcode, sc, vl;
+	int req_queued = 0;
 
 	if (iovec[idx].iov_len < sizeof(info) + sizeof(req->hdr)) {
 		hfi1_cdbg(
@@ -706,6 +707,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	set_comp_state(pq, cq, info.comp_idx, QUEUED, 0);
 	atomic_inc(&pq->n_reqs);
+	req_queued = 1;
 	/* Send the first N packets in the request to buy us some time */
 	ret = user_sdma_send_pkts(req, pcount);
 	if (unlikely(ret < 0 && ret != -EBUSY)) {
@@ -750,7 +752,8 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	return 0;
 free_req:
 	user_sdma_free_request(req, true);
-	pq_update(pq);
+	if (req_queued)
+		pq_update(pq);
 	set_comp_state(pq, cq, info.comp_idx, ERROR, req->status);
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
