From: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 01/10] IB: Replace ib_umem page_size by
 page_shift
Date: Wed, 5 Apr 2017 16:38:45 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7302F0A29@fmsmsx116.amr.corp.intel.com>
References: <20170405062359.26623-1-leon@kernel.org>
 <20170405062359.26623-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Size of pages are held by struct ib_umem in page_size field.
>=20
> It is better to store it as an exponent, because page size by nature is a=
lways
> power-of-two and used as a factor, divisor or ilog2's argument.
>=20
> The conversion of page_size to be page_shift allows to have portable code=
 and
> avoid following error while compiling on ARM:
>=20
>   ERROR: "__aeabi_uldivmod" [drivers/infiniband/core/ib_core.ko] undefine=
d!
>=20
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
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> index 9b2849979756..378c75759be4 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> @@ -1345,7 +1345,7 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr
> *iwmr,  {
>  	struct ib_umem *region =3D iwmr->region;
>  	struct i40iw_pbl *iwpbl =3D &iwmr->iwpbl;
> -	int chunk_pages, entry, pg_shift, i;
> +	int chunk_pages, entry, i;
>  	struct i40iw_pble_alloc *palloc =3D &iwpbl->pble_alloc;
>  	struct i40iw_pble_info *pinfo;
>  	struct scatterlist *sg;
> @@ -1354,14 +1354,14 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_=
mr
> *iwmr,
>=20
>  	pinfo =3D (level =3D=3D I40IW_LEVEL_1) ? NULL : palloc->level2.leaf;
>=20
> -	pg_shift =3D ffs(region->page_size) - 1;
>  	for_each_sg(region->sg_head.sgl, sg, region->nmap, entry) {
> -		chunk_pages =3D sg_dma_len(sg) >> pg_shift;
> +		chunk_pages =3D sg_dma_len(sg) >> region->page_shift;
>  		if ((iwmr->type =3D=3D IW_MEMREG_TYPE_QP) &&
>  		    !iwpbl->qp_mr.sq_page)
>  			iwpbl->qp_mr.sq_page =3D sg_page(sg);
>  		for (i =3D 0; i < chunk_pages; i++) {
> -			pg_addr =3D sg_dma_address(sg) + region->page_size * i;
> +			pg_addr =3D sg_dma_address(sg) +
> +				(i << region->page_shift);
>=20
>  			if ((entry + i) =3D=3D 0)
>  				*pbl =3D cpu_to_le64(pg_addr & iwmr->page_msk);
> @@ -1847,7 +1847,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd=
 *pd,
>  	iwmr->ibmr.device =3D pd->device;
>  	ucontext =3D to_ucontext(pd->uobject->context);
>=20
> -	iwmr->page_size =3D region->page_size;
> +	iwmr->page_size =3D PAGE_SIZE;
>  	iwmr->page_msk =3D PAGE_MASK;
>=20

Thank you!

Acked-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
