From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 07/10] nvme-rdma: Don't rearm the CQ when polling directly
Date: Thu,  9 Mar 2017 15:16:39 +0200
Message-ID: <1489065402-14757-8-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We don't need it as the core polling context will take
are of rearming the completion queue.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 7bad791a7fe9..a17eef3ef6ff 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1474,7 +1474,6 @@ static int nvme_rdma_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
 	struct ib_wc wc;
 	int found = 0;
 
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		struct ib_cqe *cqe = wc.wr_cqe;
 
-- 
2.7.4
