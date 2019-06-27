From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 21/87] infiniband: cxgb4: Remove call to memset after dma_alloc_coherent in cq.c
Date: Fri, 28 Jun 2019 01:37:08 +0800
Message-ID: <20190627173708.2939-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Potnuri Bharat Teja <bharat@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 52ce586621c6..fcd161e3495b 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -104,7 +104,6 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		goto err3;
 	}
 	dma_unmap_addr_set(cq, mapping, cq->dma_addr);
-	memset(cq->queue, 0, cq->memsize);
 
 	if (user && ucontext->is_32b_cqe) {
 		cq->qp_errp = &((struct t4_status_page *)
-- 
2.11.0
