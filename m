From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Sun, 29 May 2016 01:15:27 -0700
Message-ID: <20160529081527.GA5839@infradead.org>
References: <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
 <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com>
 <574728EC.9040802@grimberg.me>
 <57473025.5020801@grimberg.me>
 <20160526192351.GV25500@leon.nu>
 <alpine.DEB.2.20.1605261511230.8857@east.gentwo.org>
 <574A941D.9050404@grimberg.me>
 <20160529071749.GB24347@infradead.org>
 <574AA4BE.2060207@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <574AA4BE.2060207-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 29, 2016 at 11:13:50AM +0300, Sagi Grimberg wrote:
> 
> >>Really? It's used all over the stack...
> >>
> >>So the suggestion is to restrict the allocation does not
> >>cross the page boundary (which can easily be done with making
> >>MLX4_MR_PAGES_ALIGN be PAGE_SIZE or larger than PAGE_SIZE/2)?
> >
> >We could simply switch to alloc_pages, e.g. something like the patch below:
> 
> Patch below? :)

Here we go.

> 
> >But I have to admit I really like the coherent dma mapping version,
> >for all sane architectures that works much better, although it sucks
> >for some architetures where dma coherent mappings cause a bit of
> >overhead.
> 
> But this is specific to mlx4 which supports up 511 pages per MR, mlx5
> will need a coherent allocation anyways right (it supports up to 64K
> pages per MR)?

Why does that make a difference?

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mlx4-pages.diff"

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ba32817..7adfa4b 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -129,8 +129,6 @@ struct mlx4_ib_cq {
 	struct list_head		recv_qp_list;
 };
 
-#define MLX4_MR_PAGES_ALIGN 0x40
-
 struct mlx4_ib_mr {
 	struct ib_mr		ibmr;
 	__be64			*pages;
@@ -139,7 +137,6 @@ struct mlx4_ib_mr {
 	u32			max_pages;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
-	void			*pages_alloc;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index b04f623..3c6a21f 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -278,17 +278,13 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 		      int max_pages)
 {
 	int size = max_pages * sizeof(u64);
-	int add_size;
 	int ret;
 
-	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
-
-	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
-	if (!mr->pages_alloc)
+	mr->pages = (__be64 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+			get_order(size));
+	if (!mr->pages)
 		return -ENOMEM;
-
-	mr->pages = PTR_ALIGN(mr->pages_alloc, MLX4_MR_PAGES_ALIGN);
-
+	
 	mr->page_map = dma_map_single(device->dma_device, mr->pages,
 				      size, DMA_TO_DEVICE);
 
@@ -299,7 +295,7 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 
 	return 0;
 err:
-	kfree(mr->pages_alloc);
+	free_pages((unsigned long)mr->pages, get_order(size));
 
 	return ret;
 }
@@ -313,7 +309,7 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 
 		dma_unmap_single(device->dma_device, mr->page_map,
 				 size, DMA_TO_DEVICE);
-		kfree(mr->pages_alloc);
+		free_pages((unsigned long)mr->pages, get_order(size));
 		mr->pages = NULL;
 	}
 }

--PNTmBPCT7hxwcZjr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
