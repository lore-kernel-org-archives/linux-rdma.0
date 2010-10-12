From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Limit num of fast reg WRs
Date: Tue, 12 Oct 2010 10:19:55 +0200
Message-ID: <20101012081955.GB1617@mtldesk30>
References: <20101007142416.GA11518@mtldesk30>
 <AANLkTinKiBHOT2sSA+_s5CGhqC8nEoDTp2_pGmo6MrQp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinKiBHOT2sSA+_s5CGhqC8nEoDTp2_pGmo6MrQp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 12:13:26AM +0200, Or Gerlitz wrote:
> Guys, can you clarify if the hardware limitation is 511 entries or its
> (PAGE_SIZE / sizeof(pointer)) - 1 which is 4096 / 8  - 1 = 511 but can
> change if the page size  gets bigger or smaller?
>

The limit is 511 entries.
After I posted this patch, I was told that there is yet another
constraint on the page list: The buffer containing the list must not
cross a page boundary. So I was thinking what is the best way to deal
with this. One way is to always allocate a whole page and map it using
dma_map_page(page, DMA_TO_DEVICE), something like this (not a complete
patch, just the idea).

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 83e3cc7..e9b2c8a 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -237,18 +237,23 @@ struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device
 	if (!mfrpl->ibfrpl.page_list)
 		goto err_free;
 
-	mfrpl->mapped_page_list = dma_alloc_coherent(&dev->dev->pdev->dev,
-						     size, &mfrpl->map,
-						     GFP_KERNEL);
+	mfrpl->mapped_page_list = (__be64 *)__get_free_page(GFP_KERNEL);
 	if (!mfrpl->mapped_page_list)
 		goto err_free;
 
-	WARN_ON(mfrpl->map & 0x3f);
+	mfrpl->map = dma_map_single(ibdev->dma_device, mfrpl->mapped_page_list,
+				    PAGE_SIZE, DMA_TO_DEVICE);
+	if (dma_mapping_error(ibdev->dma_device, mfrpl->map))
+		goto err_page;
+
+
 
 	return &mfrpl->ibfrpl;
 
+err_page:
+	free_page((unsigned long) mfrpl->mapped_page_list);
+
 err_free:
-	kfree(mfrpl->ibfrpl.page_list);
 	kfree(mfrpl);
 	return ERR_PTR(-ENOMEM);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
