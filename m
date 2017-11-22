From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v5 4/4] nvme-rdma: Check remotely invalidated rkey matches our expected rkey
Date: Wed, 22 Nov 2017 20:58:38 +0200
Message-ID: <20171122185838.28855-5-sagi@grimberg.me>
References: <20171122185838.28855-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122185838.28855-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we got a remote invalidation on a bogus rkey, this is a protocol
error. fail if it happened.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 2ed6fd0d5551..581a85cb5ee7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1336,8 +1336,13 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	req->status = cqe->status;
 	req->result = cqe->result;
 
-	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
-	    wc->ex.invalidate_rkey == req->mr->rkey) {
+	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
+		if (unlikely(wc->ex.invalidate_rkey != req->mr->rkey)) {
+			dev_err(queue->ctrl->ctrl.device,
+				"Bogus remote invalidation for rkey %#x\n",
+				req->mr->rkey);
+			nvme_rdma_error_recovery(queue->ctrl);
+		}
 		req->mr->need_inval = false;
 	} else if (req->mr->need_inval) {
 		ret = nvme_rdma_inv_rkey(queue, req);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
