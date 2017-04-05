From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 08/10] IB/umem: Add support to huge ODP
Date: Wed, 5 Apr 2017 11:45:39 -0500
Message-ID: <20170405164539.GA9232@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170405062359.26623-1-leon@kernel.org>
 <20170405062359.26623-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170405062359.26623-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 05, 2017 at 09:23:57AM +0300, Leon Romanovsky wrote:
> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add IB_ACCESS_HUGETLB ib_reg_mr flag.
> Hugetlb region registered with this flag
> will use single translation entry per huge page.
> 
> Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/umem.c     |  2 +-
>  drivers/infiniband/core/umem_odp.c | 19 +++++++++++++++++--
>  include/rdma/ib_umem_odp.h         |  6 ++++--
>  include/rdma/ib_verbs.h            |  1 +
>  4 files changed, 23 insertions(+), 5 deletions(-)
> 
> @@ -315,6 +317,20 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
>  	if (!mm)
>  		return -EINVAL;
>  
> +	if (access & IB_ACCESS_HUGETLB) {
> +		struct vm_area_struct *vma;
> +		struct hstate *h;
> +
> +		vma = find_vma(mm, ib_umem_start(umem));
> +		if (!vma || !is_vm_hugetlb_page(vma))
> +			return -EINVAL;
> +		h = hstate_vma(vma);
> +		umem->page_shift = huge_page_shift(h);
> +		umem->hugetlb = 1;

User memory buffer could span multiple VMAs right? So shouldn’t we check all VMAs of the umem 
before setting the hugetlb flag?

> +	} else {
> +		umem->hugetlb = 0;
> +	}
> +
>  	/* Prevent creating ODP MRs in child processes */
>  	rcu_read_lock();
>  	our_pid = get_task_pid(current->group_leader, PIDTYPE_PID);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
