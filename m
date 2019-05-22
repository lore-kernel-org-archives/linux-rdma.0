From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Tue, 21 May 2019 21:52:25 -0300
Message-ID: <20190522005225.GA30819@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
 <20190506195657.GA30261@ziepe.ca>
 <20190521205321.GC3331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521205321.GC3331@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 21, 2019 at 04:53:22PM -0400, Jerome Glisse wrote:
> On Mon, May 06, 2019 at 04:56:57PM -0300, Jason Gunthorpe wrote:
> > On Thu, Apr 11, 2019 at 02:13:13PM -0400, jglisse@redhat.com wrote:
> > > From: Jérôme Glisse <jglisse@redhat.com>
> > > 
> > > Just fixed Kconfig and build when ODP was not enabled, other than that
> > > this is the same as v3. Here is previous cover letter:
> > > 
> > > Git tree with all prerequisite:
> > > https://cgit.freedesktop.org/~glisse/linux/log/?h=rdma-odp-hmm-v4
> > > 
> > > This patchset convert RDMA ODP to use HMM underneath this is motivated
> > > by stronger code sharing for same feature (share virtual memory SVM or
> > > Share Virtual Address SVA) and also stronger integration with mm code to
> > > achieve that. It depends on HMM patchset posted for inclusion in 5.2 [2]
> > > and [3].
> > > 
> > > It has been tested with pingpong test with -o and others flags to test
> > > different size/features associated with ODP.
> > > 
> > > Moreover they are some features of HMM in the works like peer to peer
> > > support, fast CPU page table snapshot, fast IOMMU mapping update ...
> > > It will be easier for RDMA devices with ODP to leverage those if they
> > > use HMM underneath.
> > > 
> > > Quick summary of what HMM is:
> > >     HMM is a toolbox for device driver to implement software support for
> > >     Share Virtual Memory (SVM). Not only it provides helpers to mirror a
> > >     process address space on a device (hmm_mirror). It also provides
> > >     helper to allow to use device memory to back regular valid virtual
> > >     address of a process (any valid mmap that is not an mmap of a device
> > >     or a DAX mapping). They are two kinds of device memory. Private memory
> > >     that is not accessible to CPU because it does not have all the expected
> > >     properties (this is for all PCIE devices) or public memory which can
> > >     also be access by CPU without restriction (with OpenCAPI or CCIX or
> > >     similar cache-coherent and atomic inter-connect).
> > > 
> > >     Device driver can use each of HMM tools separatly. You do not have to
> > >     use all the tools it provides.
> > > 
> > > For RDMA device i do not expect a need to use the device memory support
> > > of HMM. This device memory support is geared toward accelerator like GPU.
> > > 
> > > 
> > > You can find a branch [1] with all the prerequisite in. This patch is on
> > > top of rdma-next with the HMM patchset [2] and mmu notifier patchset [3]
> > > applied on top of it.
> > > 
> > > [1] https://cgit.freedesktop.org/~glisse/linux/log/?h=rdma-odp-hmm-v4
> > > [2] https://lkml.org/lkml/2019/4/3/1032
> > > [3] https://lkml.org/lkml/2019/3/26/900
> > 
> > Jerome, please let me know if these dependent series are merged during
> > the first week of the merge window.
> > 
> > This patch has been tested and could go along next week if the
> > dependencies are met.
> > 
> 
> So attached is a rebase on top of 5.2-rc1, i have tested with pingpong
> (prefetch and not and different sizes). Seems to work ok.

Urk, it already doesn't apply to the rdma tree :(

The conflicts are a little more extensive than I'd prefer to handle..
Can I ask you to rebase it on top of this branch please:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-for-next

Specifically it conflicts with this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-next&id=d2183c6f1958e6b6dfdde279f4cee04280710e34

> +long ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp,
> +			       struct hmm_range *range)
>  {
> +	struct device *device = umem_odp->umem.context->device->dma_device;
> +	struct ib_ucontext_per_mm *per_mm = umem_odp->per_mm;
>  	struct ib_umem *umem = &umem_odp->umem;
> -	struct task_struct *owning_process  = NULL;
> -	struct mm_struct *owning_mm = umem_odp->umem.owning_mm;
> -	struct page       **local_page_list = NULL;
> -	u64 page_mask, off;
> -	int j, k, ret = 0, start_idx, npages = 0, page_shift;
> -	unsigned int flags = 0;
> -	phys_addr_t p = 0;
> -
> -	if (access_mask == 0)
> +	struct mm_struct *mm = per_mm->mm;
> +	unsigned long idx, npages;
> +	long ret;
> +
> +	if (mm == NULL)
> +		return -ENOENT;
> +
> +	/* Only drivers with invalidate support can use this function. */
> +	if (!umem->context->invalidate_range)
>  		return -EINVAL;
>  
> -	if (user_virt < ib_umem_start(umem) ||
> -	    user_virt + bcnt > ib_umem_end(umem))
> -		return -EFAULT;
> +	/* Sanity checks. */
> +	if (range->default_flags == 0)
> +		return -EINVAL;
>  
> -	local_page_list = (struct page **)__get_free_page(GFP_KERNEL);
> -	if (!local_page_list)
> -		return -ENOMEM;
> +	if (range->start < ib_umem_start(umem) ||
> +	    range->end > ib_umem_end(umem))
> +		return -EINVAL;
>  
> -	page_shift = umem->page_shift;
> -	page_mask = ~(BIT(page_shift) - 1);
> -	off = user_virt & (~page_mask);
> -	user_virt = user_virt & page_mask;
> -	bcnt += off; /* Charge for the first page offset as well. */
> +	idx = (range->start - ib_umem_start(umem)) >> umem->page_shift;

Is this math OK? What is supposed to happen if the range->start is not
page aligned to the internal page size?

> +	range->pfns = &umem_odp->pfns[idx];
> +	range->pfn_shift = ODP_FLAGS_BITS;
> +	range->values = odp_hmm_values;
> +	range->flags = odp_hmm_flags;
>  
>  	/*
> -	 * owning_process is allowed to be NULL, this means somehow the mm is
> -	 * existing beyond the lifetime of the originating process.. Presumably
> -	 * mmget_not_zero will fail in this case.
> +	 * If mm is dying just bail out early without trying to take mmap_sem.
> +	 * Note that this might race with mm destruction but that is fine the
> +	 * is properly refcounted so are all HMM structure.
>  	 */
> -	owning_process = get_pid_task(umem_odp->per_mm->tgid, PIDTYPE_PID);
> -	if (!owning_process || !mmget_not_zero(owning_mm)) {

But we are not in a HMM context here, and per_mm is not a HMM
structure. 

So why is mm suddenly guarenteed valid? It was a bug report that
triggered the race the mmget_not_zero is fixing, so I need a better
explanation why it is now safe. From what I see the hmm_range_fault
is doing stuff like find_vma without an active mmget??

> @@ -603,11 +603,29 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
>  
>  next_mr:
>  	size = min_t(size_t, bcnt, ib_umem_end(&odp->umem) - io_virt);
> -
>  	page_shift = mr->umem->page_shift;
>  	page_mask = ~(BIT(page_shift) - 1);
> +	/*
> +	 * We need to align io_virt on page size so off is the extra bytes we
> +	 * will be faulting and fault_size is the page aligned size we are
> +	 * faulting.
> +	 */
> +	io_virt = io_virt & page_mask;
> +	off = (io_virt & (~page_mask));
> +	fault_size = ALIGN(size + off, 1UL << page_shift);
> +
> +	if (io_virt < ib_umem_start(&odp->umem))
> +		return -EINVAL;
> +
>  	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
> -	access_mask = ODP_READ_ALLOWED_BIT;
> +
> +	if (odp_mr->per_mm == NULL || odp_mr->per_mm->mm == NULL)
> +		return -ENOENT;

How can this happen? Where is the locking?

per_mm is supposed to outlive any odp_mr's the refer to it, and the mm
is supposed to remain grab'd as long as the per_mm exists..

> diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
> index eeec4e53c448..70b2df8e5a6c 100644
> +++ b/include/rdma/ib_umem_odp.h
> @@ -36,6 +36,7 @@
>  #include <rdma/ib_umem.h>
>  #include <rdma/ib_verbs.h>
>  #include <linux/interval_tree.h>
> +#include <linux/hmm.h>
>  
>  struct umem_odp_node {
>  	u64 __subtree_last;
> @@ -47,11 +48,11 @@ struct ib_umem_odp {
>  	struct ib_ucontext_per_mm *per_mm;
>  
>  	/*
> -	 * An array of the pages included in the on-demand paging umem.
> -	 * Indices of pages that are currently not mapped into the device will
> -	 * contain NULL.
> +	 * An array of the pages included in the on-demand paging umem. Indices
> +	 * of pages that are currently not mapped into the device will contain
> +	 * 0.
>  	 */
> -	struct page		**page_list;
> +	uint64_t *pfns;

Are these actually pfns, or are they mangled with some shift? (what is range->pfn_shift?)

Jason
