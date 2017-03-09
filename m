From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 06/10] IB/cq: Don't force IB_POLL_DIRECT poll context for ib_process_cq_direct
Date: Thu,  9 Mar 2017 15:16:38 +0200
Message-ID: <1489065402-14757-7-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

polling the completion queue directly does not interfere
with the existing polling logic, hence drop the requirement.

This can be used for polling mode ULPs.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/core/cq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 21d1a38af489..7f6ae0ecb0c5 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -64,8 +64,6 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
  */
 int ib_process_cq_direct(struct ib_cq *cq, int budget)
 {
-	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
-
 	return __ib_process_cq(cq, budget);
 }
 EXPORT_SYMBOL(ib_process_cq_direct);
-- 
2.7.4
