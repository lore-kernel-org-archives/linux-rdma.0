From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/bnxt_re: Use zeroing memory allocator than allocator/memset
Date: Sun, 31 Dec 2017 18:02:38 +0530
Message-ID: <1514723558-5923-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
Cc: devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 4e10170..ad37d54 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -104,13 +104,12 @@ static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
 
 	if (!sghead) {
 		for (i = 0; i < pages; i++) {
-			pbl->pg_arr[i] = dma_alloc_coherent(&pdev->dev,
-							    pbl->pg_size,
-							    &pbl->pg_map_arr[i],
-							    GFP_KERNEL);
+			pbl->pg_arr[i] = dma_zalloc_coherent(&pdev->dev,
+							     pbl->pg_size,
+							     &pbl->pg_map_arr[i],
+							     GFP_KERNEL);
 			if (!pbl->pg_arr[i])
 				goto fail;
-			memset(pbl->pg_arr[i], 0, pbl->pg_size);
 			pbl->pg_count++;
 		}
 	} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
