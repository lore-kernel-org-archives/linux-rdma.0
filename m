From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/14] RDMA/cxgb3: Rename jump labels in cxio_create_qp()
Date: Wed, 8 Feb 2017 22:12:44 +0100
Message-ID: <79fb817a-bc53-8d18-9b09-c78f0ed99142@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 14:28:25 +0100

Adjust jump labels according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index aeb1dfa8bfe5..113f614b07d4 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -283,21 +283,21 @@ int cxio_create_qp(struct cxio_rdev *rdev_p, u32 kernel_domain,
 
 	wq->rq = kcalloc(depth, sizeof(*wq->rq), GFP_KERNEL);
 	if (!wq->rq)
-		goto err1;
+		goto put_pid;
 
 	wq->rq_addr = cxio_hal_rqtpool_alloc(rdev_p, rqsize);
 	if (!wq->rq_addr)
-		goto err2;
+		goto free_rq;
 
 	wq->sq = kcalloc(depth, sizeof(*wq->sq), GFP_KERNEL);
 	if (!wq->sq)
-		goto err3;
+		goto free_pool;
 
 	wq->queue = dma_alloc_coherent(&(rdev_p->rnic_info.pdev->dev),
 					     depth * sizeof(union t3_wr),
 					     &(wq->dma_addr), GFP_KERNEL);
 	if (!wq->queue)
-		goto err4;
+		goto free_sq;
 
 	memset(wq->queue, 0, depth * sizeof(union t3_wr));
 	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
@@ -309,13 +309,13 @@ int cxio_create_qp(struct cxio_rdev *rdev_p, u32 kernel_domain,
 	PDBG("%s qpid 0x%x doorbell 0x%p udb 0x%llx\n", __func__,
 	     wq->qpid, wq->doorbell, (unsigned long long) wq->udb);
 	return 0;
-err4:
+free_sq:
 	kfree(wq->sq);
-err3:
+free_pool:
 	cxio_hal_rqtpool_free(rdev_p, wq->rq_addr, rqsize);
-err2:
+free_rq:
 	kfree(wq->rq);
-err1:
+put_pid:
 	put_qpid(rdev_p, wq->qpid, uctx);
 	return -ENOMEM;
 }
-- 
2.11.1
