From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/mlx5: Modify to work with arbitrary page size
Date: Sun, 14 Sep 2014 16:47:55 +0300
Message-ID: <1410702475-28826-7-git-send-email-eli@mellanox.com>
References: <1410702475-28826-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410702475-28826-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When dealing with umem objects, the driver assumed host page sizes defined by
PAGE_SHIFT. Modify the code to use arbitrary page shift provided by umem->page_shift
to support different page sizes.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index a3e81444c825..dae07eae9507 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -55,16 +55,17 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 	u64 pfn;
 	struct scatterlist *sg;
 	int entry;
+	unsigned long page_shift = ilog2(umem->page_size);
 
-	addr = addr >> PAGE_SHIFT;
+	addr = addr >> page_shift;
 	tmp = (unsigned long)addr;
 	m = find_first_bit(&tmp, sizeof(tmp));
 	skip = 1 << m;
 	mask = skip - 1;
 	i = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		len = sg_dma_len(sg) >> PAGE_SHIFT;
-		pfn = sg_dma_address(sg) >> PAGE_SHIFT;
+		len = sg_dma_len(sg) >> page_shift;
+		pfn = sg_dma_address(sg) >> page_shift;
 		for (k = 0; k < len; k++) {
 			if (!(i & mask)) {
 				tmp = (unsigned long)pfn;
@@ -103,14 +104,15 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 
 		*ncont = 0;
 	}
-	*shift = PAGE_SHIFT + m;
+	*shift = page_shift + m;
 	*count = i;
 }
 
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			  int page_shift, __be64 *pas, int umr)
 {
-	int shift = page_shift - PAGE_SHIFT;
+	unsigned long umem_page_shift = ilog2(umem->page_size);
+	int shift = page_shift - umem_page_shift;
 	int mask = (1 << shift) - 1;
 	int i, k;
 	u64 cur = 0;
@@ -121,11 +123,11 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 
 	i = 0;
 	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
-		len = sg_dma_len(sg) >> PAGE_SHIFT;
+		len = sg_dma_len(sg) >> umem_page_shift;
 		base = sg_dma_address(sg);
 		for (k = 0; k < len; k++) {
 			if (!(i & mask)) {
-				cur = base + (k << PAGE_SHIFT);
+				cur = base + (k << umem_page_shift);
 				if (umr)
 					cur |= 3;
 
@@ -134,7 +136,7 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 					    i >> shift, be64_to_cpu(pas[i >> shift]));
 			}  else
 				mlx5_ib_dbg(dev, "=====> 0x%llx\n",
-					    base + (k << PAGE_SHIFT));
+					    base + (k << umem_page_shift));
 			i++;
 		}
 	}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
