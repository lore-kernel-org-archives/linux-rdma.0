From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Tue, 6 Oct 2015 11:49:29 -0700
Message-ID: <561417B9.2080505@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <560AE099.2080004@sandisk.com> <560AFB71.3010003@dev.mellanox.co.il>
 <560C30F4.50900@sandisk.com> <560C42CE.6090000@sandisk.com>
 <560CDDBC.8000400@dev.mellanox.co.il> <560D730C.9000302@sandisk.com>
 <560D9E69.70604@sandisk.com>
 <35618B90-4D6E-4036-A69B-4405F020D440@dev.mellanox.co.il>
 <560EA4A1.3080709@sandisk.com> <56138854.4040209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56138854.4040209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/06/2015 01:37 AM, Sagi Grimberg wrote:
> I see now the error you are referring to.
> 
> The issue is that the device requires the MR page array to have
> an alignment (0x40 for mlx4 and 0x400 for mlx5). When I modified the
> page array allocation to be non-coherent I didn't take care of
> alignment.
> 
> Taking care of this alignment may result in a higher order allocation
> as we'd need to add (alignment - 1) to the allocation size.
> 
> e.g. a 512 pages on mlx4 will become:
> 512 * 8 + 0x40 - 1 = 4159
> 
> I'm leaning towards this approach. Any preference?
> 
> I think this patch should take care of mlx4:
> [ ... ]

Hello Sagi,

Thanks for the patch. But since the patch included in the previous
e-mail mapped a memory range that could be outside the bounds of the
allocated memory I have been testing the patch below:

---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +++
 drivers/infiniband/hw/mlx4/mr.c      | 19 ++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index de6eab3..864d595 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -129,6 +129,8 @@ struct mlx4_ib_cq {
 	struct list_head		recv_qp_list;
 };
 
+#define MLX4_MR_PAGES_ALIGN 0x40
+
 struct mlx4_ib_mr {
 	struct ib_mr		ibmr;
 	__be64			*pages;
@@ -137,6 +139,7 @@ struct mlx4_ib_mr {
 	u32			max_pages;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
+	void                   *pages_alloc;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index fa01f75..8121c1c 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -277,12 +277,17 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 		      int max_pages)
 {
 	int size = max_pages * sizeof(u64);
+	int add_size;
 	int ret;
 
-	mr->pages = kzalloc(size, GFP_KERNEL);
-	if (!mr->pages)
+	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
+
+	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
+	if (!mr->pages_alloc)
 		return -ENOMEM;
 
+	mr->pages = PTR_ALIGN(mr->pages_alloc, MLX4_MR_PAGES_ALIGN);
+
 	mr->page_map = dma_map_single(device->dma_device, mr->pages,
 				      size, DMA_TO_DEVICE);
 
@@ -293,20 +298,20 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 
 	return 0;
 err:
-	kfree(mr->pages);
+	kfree(mr->pages_alloc);
 	return ret;
 }
 
 static void
 mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 {
-	struct ib_device *device = mr->ibmr.device;
-	int size = mr->max_pages * sizeof(u64);
-
 	if (mr->pages) {
+		struct ib_device *device = mr->ibmr.device;
+		int size = mr->max_pages * sizeof(u64);
+
 		dma_unmap_single(device->dma_device, mr->page_map,
 				 size, DMA_TO_DEVICE);
-		kfree(mr->pages);
+		kfree(mr->pages_alloc);
 		mr->pages = NULL;
 	}
 }
-- 
2.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
