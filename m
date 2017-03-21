From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] IB/umem: Drop hugetlb variable and VMA
 allocation
Date: Tue, 21 Mar 2017 09:06:44 -0500
Message-ID: <20170321140644.GA26628@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170319085557.6023-1-leon@kernel.org>
 <20170319085557.6023-3-leon@kernel.org>
 <20170321021936.GA18356@ssaleem-MOBL4.amr.corp.intel.com>
 <20170321081408.GZ2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170321081408.GZ2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 21, 2017 at 10:14:08AM +0200, Leon Romanovsky wrote:
> On Mon, Mar 20, 2017 at 09:19:36PM -0500, Shiraz Saleem wrote:
> > On Sun, Mar 19, 2017 at 10:55:56AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > IB umem structure has field hugetlb which was assigned, but except
> > > i40iw driver, it was actually never used.
> > >
> > > This patch drops that variable out of the struct ib_umem, removes
> > > all writes to it, get rids of VMA allocation which wasn't used and
> > > removes check hugetlb from i40iw driver, because it is checked anyway in
> > > i40iw_set_hugetlb_values() routine.
> > >
> > > @@ -143,9 +141,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> > >
> > >  	umem->odp_data = NULL;
> > >
> > > -	/* We assume the memory is from hugetlb until proved otherwise */
> > > -	umem->hugetlb   = 1;
> > > -
> > >  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> > >  	if (!page_list) {
> > >  		put_pid(umem->pid);
> > > @@ -153,14 +148,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> > >  		return ERR_PTR(-ENOMEM);
> > >  	}
> > >
> > > -	/*
> > > -	 * if we can't alloc the vma_list, it's not so bad;
> > > -	 * just assume the memory is not hugetlb memory
> > > -	 */
> > > -	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
> > > -	if (!vma_list)
> > > -		umem->hugetlb = 0;
> > > -
> > >  	npages = ib_umem_num_pages(umem);
> > >
> > >  	down_write(&current->mm->mmap_sem);
> > > @@ -194,7 +181,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> > >  		ret = get_user_pages(cur_base,
> > >  				     min_t(unsigned long, npages,
> > >  					   PAGE_SIZE / sizeof (struct page *)),
> > > -				     gup_flags, page_list, vma_list);
> > > +				     gup_flags, page_list, NULL);
> > >
> > >  		if (ret < 0)
> > >  			goto out;
> > > @@ -203,12 +190,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> > >  		cur_base += ret * PAGE_SIZE;
> > >  		npages   -= ret;
> > >
> > > -		for_each_sg(sg_list_start, sg, ret, i) {
> > > -			if (vma_list && !is_vm_hugetlb_page(vma_list[i]))
> > > -				umem->hugetlb = 0;
> > > -
> > > +		for_each_sg(sg_list_start, sg, ret, i)
> > >  			sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
> > > -		}
> > >
> > >  		/* preparing for next loop */
> > >  		sg_list_start = sg;
> >
> > > diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > > index 9b2849979756..59c8d74e3704 100644
> > > --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > > +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > > @@ -1850,7 +1850,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
> > >  	iwmr->page_size = region->page_size;
> > >  	iwmr->page_msk = PAGE_MASK;
> > >
> > > -	if (region->hugetlb && (req.reg_type == IW_MEMREG_TYPE_MEM))
> > > +	if (req.reg_type == IW_MEMREG_TYPE_MEM)
> > >  		i40iw_set_hugetlb_values(start, iwmr);
> >
> > The code in ib_umem_get iterates through __all__ VMA’s corresponding to the
> > user-space buffer and hugetlb field of the umem struct is set only if they
> > are all using huge_pages. So in the essence, umem->hugetlb provides the
> > driver info on whether __all__ pages of the memory region uses huge pages
> > or not.
> >
> > i40iw_set_hugetlb_values only finds the VMA w.r.t the start virtual address of
> > the user-space buffer and checks if __this__ VMA uses hugetlb pages or not.
> > It is a sanity check done on the VMA found.
> 
> >
> > So the question is -- Do we know that only a single VMA represents the user-space
> > buffer backed by huge pages?
> > If not, it doesnt appear that the check in i40iw_set_hugetlb_values will suffice to
> > identify if the entire memory region is composed of huge pages since it doesnt
> > check all the VMAs. umem->hugetlb would be required for it.
> 
> You are right and thank you for pointing that. User memory buffer indeed can
> span more than one VMA. For example one reg_mr with READ property for
> two adjacent VAMs, one with READ properties and another with READ-WRITE.
> 
> However, relying on hugetlb which was set during creation is not best
> thing too. It can be changed during the application run. The mlx5 relies on
> the mlx5_ib_cont_pages() function to understand the actual layout.
> 

The patch as is, will break us. We believe ib_umem_get is the correct 
place to scan the VMAs and report if the MR is composed of hugetlb pages via the
hugetlb field of umem. This way it can be done in one place and not in each 
individual driver.

Not sure I understand what you mean by MR changing during application run. And how
mlx5_ib_cont_pages is helping if this happens.         
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
