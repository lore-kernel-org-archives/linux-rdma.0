From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Mon, 14 Jan 2019 15:16:54 -0700
Message-ID: <20190114221654.GE1208@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
 <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
 <20190112183752.GC16457@mellanox.com>
 <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190112190305.GA19436@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 12, 2019 at 01:03:05PM -0600, Shiraz Saleem wrote:
> On Sat, Jan 12, 2019 at 06:37:58PM +0000, Jason Gunthorpe wrote:
> > On Sat, Jan 12, 2019 at 12:27:05PM -0600, Shiraz Saleem wrote:
> > > On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> > > > Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> > > > backing pages") introduced the sg_page_iter_dma_address() function without
> > > > providing a way to use it in the general case. If the sg_dma_len is not
> > > > equal to the dma_length callers cannot safely use the
> > > > for_each_sg_page/sg_page_iter_dma_address combination.
> > > > 
> > > > Resolve this API mistake by providing a DMA specific iterator,
> > > > for_each_sg_dma_page(), that uses the right length so
> > > > sg_page_iter_dma_address() works as expected with all sglists. A new
> > > > iterator type is introduced to provide compile-time safety against wrongly
> > > > mixing accessors and iterators.
> > > [..]
> > > 
> > > >  
> > > > +/*
> > > > + * sg page iterator for DMA addresses
> > > > + *
> > > > + * This is the same as sg_page_iter however you can call
> > > > + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> > > > + * address. sg_page_iter_page() cannot be called on this iterator.
> > > > + */
> > > Does it make sense to have a variant of sg_page_iter_page() to get the
> > > page descriptor with this dma_iter? This can be used when walking DMA-mapped
> > > SG lists with for_each_sg_dma_page.
> > 
> > I think that would be a complicated cacluation to find the right
> > offset into the page sg list to get the page pointer back. We can't
> > just naively use the existing iterator location.
> > 
> > Probably places that need this are better to run with two iterators,
> > less computationally expensive.
> > 
> > Did you find a need for this? 
> > 
> 
> Well I was trying convert the RDMA drivers to use your new iterator variant
> and saw the need for it in locations where we need virtual address of the pages
> contained in the SGEs.
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> index 59eeac5..7d26903 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> @@ -85,7 +85,7 @@ static void __free_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>  static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>                        struct scatterlist *sghead, u32 pages, u32 pg_size)
>  {
> -       struct scatterlist *sg;
> +       struct sg_dma_page_iter sg_iter;
>         bool is_umem = false;
>         int i;
> 
> @@ -116,12 +116,13 @@ static int __alloc_pbl(struct pci_dev *pdev, struct bnxt_qplib_pbl *pbl,
>         } else {
>                 i = 0;
>                 is_umem = true;
> -               for_each_sg(sghead, sg, pages, i) {
> -                       pbl->pg_map_arr[i] = sg_dma_address(sg);
> -                       pbl->pg_arr[i] = sg_virt(sg);
> +               for_each_sg_dma_page(sghead, &sg_iter, pages, 0) {
> +                       pbl->pg_map_arr[i] = sg_page_iter_dma_address(&sg_iter);
> +                       pbl->pg_arr[i] = page_address(sg_page_iter_page(&sg_iter.base)); ???
> 					^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I concur with CH, pg_arr only looks used in the !umem case, so set to
NULL here. Check with Selvin & Devesh ?

> @@ -191,16 +190,16 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
>                 goto err1;
>         }
> 
> -       mem->page_shift         = umem->page_shift;
> -       mem->page_mask          = BIT(umem->page_shift) - 1;
> +       mem->page_shift         = PAGE_SHIFT;
> +       mem->page_mask          = PAGE_SIZE - 1;
> 
>         num_buf                 = 0;
>         map                     = mem->map;
>         if (length > 0) {
>                 buf = map[0]->buf;
> 
> -               for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
> -                       vaddr = page_address(sg_page(sg));
> +               for_each_sg_dma_page(umem->sg_head.sgl, &sg_iter, umem->nmap, 0) {
> +                       vaddr = page_address(sg_page_iter_page(&sg_iter.base));   ?????
> 				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

rxe doesn't use DMA addreses, so just leave as for_each_sg_page

Jason
