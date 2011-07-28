From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Fix the release func to be consistent with the allocation one
Date: Thu, 28 Jul 2011 10:59:49 +0300
Message-ID: <201107281059.50171.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the memory release function to be consistent with the memory allocation one
to prevent problems where the implementation of pci_free_consistent and
dma_free_coherent are different.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

---

diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index 7aecc34..31177ce 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -489,7 +489,7 @@ static void mlx4_free_eq(struct mlx4_dev *dev,
 
 	mlx4_mtt_cleanup(dev, &eq->mtt);
 	for (i = 0; i < npages; ++i)
-		pci_free_consistent(dev->pdev, PAGE_SIZE,
+		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
 				    eq->page_list[i].buf,
 				    eq->page_list[i].map);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
