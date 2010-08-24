From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/2]: Powerpc: Fix EHCA driver on relocatable kernel
Date: Tue, 24 Aug 2010 14:45:02 +1000
Message-ID: <1282625102.22370.502.camel@pasglop>
References: <20100820041019.GT16505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100820041019.GT16505-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-ppc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-08-19 at 23:10 -0500, Sonny Rao wrote:
> the eHCA driver registers a MR for all of kernel memory, but makes the
> assumption that valid memory exists at KERNELBASE.  This assumption
> may not be true in the case of a relocatable kernel, so use KERNELBASE
> + PHYSICAL_START to get the true beginning of usable kernel memory.
> 
> This patch depends on the earlier patch which exports the necessary
> symbol for PHYSICAL_START in a relocatable kernel.

I'm going to send patch 1/2 to Linus today or tomorrow, so this patch
can then be picked up by the infiniband maintainers.

Cheers,
Ben.
 
> cc: Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> cc: Hoan-Ham Hguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> 
> Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_mrmw.c
> ===================================================================
> --- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_mrmw.c	2010-08-09 22:16:57.688652613 -0500
> +++ linux-2.6/drivers/infiniband/hw/ehca/ehca_mrmw.c	2010-08-19 22:53:03.451507146 -0500
> @@ -171,7 +171,7 @@
>  		}
> 
>  		ret = ehca_reg_maxmr(shca, e_maxmr,
> -				     (void *)ehca_map_vaddr((void *)KERNELBASE),
> +				     (void *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START)),
>  				     mr_access_flags, e_pd,
>  				     &e_maxmr->ib.ib_mr.lkey,
>  				     &e_maxmr->ib.ib_mr.rkey);
> @@ -1636,7 +1636,7 @@
> 
>  	/* register internal max-MR on HCA */
>  	size_maxmr = ehca_mr_len;
> -	iova_start = (u64 *)ehca_map_vaddr((void *)KERNELBASE);
> +	iova_start = (u64 *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START));
>  	ib_pbuf.addr = 0;
>  	ib_pbuf.size = size_maxmr;
>  	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
> @@ -2209,7 +2209,7 @@
>  {
>  	/* a MR is treated as max-MR only if it fits following: */
>  	if ((size == ehca_mr_len) &&
> -	    (iova_start == (void *)ehca_map_vaddr((void *)KERNELBASE))) {
> +	    (iova_start == (void *)ehca_map_vaddr((void *)(KERNELBASE + PHYSICAL_START)))) {
>  		ehca_gen_dbg("this is a max-MR");
>  		return 1;
>  	} else
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
