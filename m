From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 01/10] IB: Replace ib_umem page_size by
 page_shift
Date: Wed, 5 Apr 2017 10:30:16 -0700
Message-ID: <82d156f6-ab82-3cf1-08e7-f76e1ea86d42@vmware.com>
References: <20170405062359.26623-1-leon@kernel.org>
 <20170405062359.26623-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue Apr 04 2017 23:23:50 GMT-0700 (PDT), Leon Romanovsky wrote:
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
> Change from v0:
>  * Remove temp variable (pg_shift) variable from i40iw driver.
> ---
>  drivers/infiniband/core/umem.c                 | 15 ++++++---------
>  drivers/infiniband/core/umem_odp.c             | 12 ++++++------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c       | 12 ++++++------
>  drivers/infiniband/hw/cxgb3/iwch_provider.c    |  4 ++--
>  drivers/infiniband/hw/cxgb4/mem.c              |  4 ++--
>  drivers/infiniband/hw/hns/hns_roce_cq.c        |  3 +--
>  drivers/infiniband/hw/hns/hns_roce_mr.c        |  9 +++++----
>  drivers/infiniband/hw/hns/hns_roce_qp.c        |  3 +--
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c      | 10 +++++-----
>  drivers/infiniband/hw/mlx4/cq.c                |  2 +-
>  drivers/infiniband/hw/mlx4/mr.c                |  6 +++---
>  drivers/infiniband/hw/mlx4/qp.c                |  2 +-
>  drivers/infiniband/hw/mlx4/srq.c               |  2 +-
>  drivers/infiniband/hw/mlx5/mem.c               |  4 ++--
>  drivers/infiniband/hw/mlx5/odp.c               |  2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c   |  5 ++---
>  drivers/infiniband/hw/nes/nes_verbs.c          |  4 ++--
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    | 15 ++++++---------
>  drivers/infiniband/hw/qedr/verbs.c             |  8 ++++----
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c |  2 +-
>  drivers/infiniband/sw/rdmavt/mr.c              |  8 ++++----
>  drivers/infiniband/sw/rxe/rxe_mr.c             |  8 +++-----
>  include/rdma/ib_umem.h                         |  4 ++--
>  23 files changed, 67 insertions(+), 77 deletions(-)

...

> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
> index 948b5ccd2a70..6ef4df6c8c4a 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
> @@ -194,7 +194,7 @@ int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
>  		len = sg_dma_len(sg) >> PAGE_SHIFT;
>  		for (j = 0; j < len; j++) {
>  			dma_addr_t addr = sg_dma_address(sg) +
> -					  umem->page_size * j;
> +					  (j << umem->page_shift);
> 
>  			ret = pvrdma_page_dir_insert_dma(pdir, i, addr);
>  			if (ret)

Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
