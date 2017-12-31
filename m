From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] RDMA/qedr: Use zeroing memory allocator than allocator/memset
Date: Sun, 31 Dec 2017 18:01:03 +0530
Message-ID: <1514723463-5859-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Ram.Amrani@cavium.com, Michal.Kalderon@cavium.com, Ariel.Elior@cavium.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index b26aa88..3b9c898 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -604,12 +604,11 @@ static struct qedr_pbl *qedr_alloc_pbl_tbl(struct qedr_dev *dev,
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < pbl_info->num_pbls; i++) {
-		va = dma_alloc_coherent(&pdev->dev, pbl_info->pbl_size,
-					&pa, flags);
+		va = dma_zalloc_coherent(&pdev->dev, pbl_info->pbl_size,
+					 &pa, flags);
 		if (!va)
 			goto err;
 
-		memset(va, 0, pbl_info->pbl_size);
 		pbl_table[i].va = va;
 		pbl_table[i].pa = pa;
 	}
-- 
2.7.4
