From: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Fri, 05 Apr 2013 16:17:36 -0400
Message-ID: <515F3160.4020007@linux.vnet.ibm.com>
References: <20130324155153.GA8597@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130324155153.GA8597-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The userland part of the patch was missing (IBV_ACCESS_GIFT).

I added flag that to /usr/include in addition to this patch and did a 
test RDMA migrate and it seems to work without any problems.

I also removed the IBV_*_WRITE flags on the sender-side and activated 
cgroups with the "memory.memsw.limit_in_bytes" activated and the 
migration with RDMA also succeeded without any problems (both with *and* 
without GIFT also worked).

Any additional tests you would like?


- Michael

On 03/24/2013 11:51 AM, Michael S. Tsirkin wrote:
> At the moment registering an MR breaks COW.  This breaks memory
> overcommit for users such as KVM: we have a lot of COW pages, e.g.
> instances of the zero page or pages shared using KSM.
>
> If the application does not care that adapter sees stale data (for
> example, it tracks writes reregisters and resends), it can use a new
> IBV_ACCESS_GIFT flag to prevent registration from breaking COW.
>
> The semantics are similar to that of SPLICE_F_GIFT thus the name.
>
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> Please review and consider for 3.10.
>
> Changes from v1:
> 	rename APP_READONLY to _GIFT: similar to vmsplice's F_GIFT.
>
>   drivers/infiniband/core/umem.c | 21 ++++++++++++---------
>   include/rdma/ib_verbs.h        |  9 ++++++++-
>   2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a841123..5dee86d 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -89,6 +89,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   	int ret;
>   	int off;
>   	int i;
> +	bool gift, writable;
>   	DEFINE_DMA_ATTRS(attrs);
>
>   	if (dmasync)
> @@ -96,6 +97,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>
>   	if (!can_do_mlock())
>   		return ERR_PTR(-EPERM);
> +	/*
> +	 * We ask for writable memory if any access flags other than
> +	 * "remote read" or "gift" are set.  "Local write" and "remote write"
> +	 * obviously require write access.  "Remote atomic" can do
> +	 * things like fetch and add, which will modify memory, and
> +	 * "MW bind" can change permissions by binding a window.
> +	 */
> +	gift  = access & IB_ACCESS_GIFT;
> +	writable = access & ~(IB_ACCESS_REMOTE_READ | IB_ACCESS_GIFT);
>
>   	umem = kmalloc(sizeof *umem, GFP_KERNEL);
>   	if (!umem)
> @@ -105,14 +115,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   	umem->length    = size;
>   	umem->offset    = addr & ~PAGE_MASK;
>   	umem->page_size = PAGE_SIZE;
> -	/*
> -	 * We ask for writable memory if any access flags other than
> -	 * "remote read" are set.  "Local write" and "remote write"
> -	 * obviously require write access.  "Remote atomic" can do
> -	 * things like fetch and add, which will modify memory, and
> -	 * "MW bind" can change permissions by binding a window.
> -	 */
> -	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
> +	umem->writable  = writable;
>
>   	/* We assume the memory is from hugetlb until proved otherwise */
>   	umem->hugetlb   = 1;
> @@ -152,7 +155,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   		ret = get_user_pages(current, current->mm, cur_base,
>   				     min_t(unsigned long, npages,
>   					   PAGE_SIZE / sizeof (struct page *)),
> -				     1, !umem->writable, page_list, vma_list);
> +				     !gift, !umem->writable, page_list, vma_list);
>
>   		if (ret < 0)
>   			goto out;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 98cc4b2..2e6e13c 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -871,7 +871,14 @@ enum ib_access_flags {
>   	IB_ACCESS_REMOTE_READ	= (1<<2),
>   	IB_ACCESS_REMOTE_ATOMIC	= (1<<3),
>   	IB_ACCESS_MW_BIND	= (1<<4),
> -	IB_ZERO_BASED		= (1<<5)
> +	IB_ZERO_BASED		= (1<<5),
> +	/*
> +	 * IB_ACCESS_GIFT: This memory is a gift to the adapter.  If memory is
> +	 * modified after registration, the local version and data seen by the
> +	 * adapter through this region rkey may differ.
> +	 * Only legal with IB_ACCESS_REMOTE_READ or no permissions.
> +	 */
> +	IB_ACCESS_GIFT		= (1<<6)
>   };
>
>   struct ib_phys_buf {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
