From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB: Replace ib_umem page_size by
 page_shift
Date: Tue, 4 Apr 2017 17:57:23 -0500
Message-ID: <20170404225723.GA12652@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170403100640.3332-1-leon@kernel.org>
 <20170403100640.3332-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170403100640.3332-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 03, 2017 at 01:06:31PM +0300, Leon Romanovsky wrote:
> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Size of pages are held by struct ib_umem in page_size field.
> 
> It is better to store it as an exponent, because page size by nature
> is always power-of-two and used as a factor, divisor or ilog2's argument.
> 
> The conversion of page_size to be page_shift allows to have portable
> code and avoid following error while compiling on ARM:
> 
>   ERROR: "__aeabi_uldivmod" [drivers/infiniband/core/ib_core.ko] undefined!
> 
> CC: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> index 9b2849979756..fb3a4ca354be 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> @@ -1354,14 +1354,15 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,
> 
>  	pinfo = (level == I40IW_LEVEL_1) ? NULL : palloc->level2.leaf;
> 
> -	pg_shift = ffs(region->page_size) - 1;
> +	pg_shift = region->page_shift;
>  	for_each_sg(region->sg_head.sgl, sg, region->nmap, entry) {
>  		chunk_pages = sg_dma_len(sg) >> pg_shift;
>  		if ((iwmr->type == IW_MEMREG_TYPE_QP) &&
>  		    !iwpbl->qp_mr.sq_page)
>  			iwpbl->qp_mr.sq_page = sg_page(sg);
>  		for (i = 0; i < chunk_pages; i++) {
> -			pg_addr = sg_dma_address(sg) + region->page_size * i;
> +			pg_addr = sg_dma_address(sg) +
> +				(i << region->page_shift);
>

Remove pg_shift local variable and use region->page_shift directly in this function. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
