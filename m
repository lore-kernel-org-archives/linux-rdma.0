From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 01/10] IB: Replace ib_umem page_size by
 page_shift
Date: Wed, 5 Apr 2017 09:48:34 +0000
Message-ID: <SN1PR07MB22070821F1D2F8CBE6EC4D00F80A0@SN1PR07MB2207.namprd07.prod.outlook.com>
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
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Size of pages are held by struct ib_umem in page_size field.
>=20
> It is better to store it as an exponent, because page size by nature
> is always power-of-two and used as a factor, divisor or ilog2's argument.
>=20
> The conversion of page_size to be page_shift allows to have portable
> code and avoid following error while compiling on ARM:
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

...

> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/q=
edr/verbs.c
> index 6b3bb32803bd..e741cc662606 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -680,16 +680,16 @@ static void qedr_populate_pbls(struct qedr_dev *dev=
, struct ib_umem *umem,
>=20
>  	pbe_cnt =3D 0;
>=20
> -	shift =3D ilog2(umem->page_size);
> +	shift =3D umem->page_shift;
>=20
>  	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
>  		pages =3D sg_dma_len(sg) >> shift;
>  		for (pg_cnt =3D 0; pg_cnt < pages; pg_cnt++) {
>  			/* store the page address in pbe */
>  			pbe->lo =3D cpu_to_le32(sg_dma_address(sg) +
> -					      umem->page_size * pg_cnt);
> +					      (pg_cnt << shift));
>  			addr =3D upper_32_bits(sg_dma_address(sg) +
> -					     umem->page_size * pg_cnt);
> +					     (pg_cnt << shift));
>  			pbe->hi =3D cpu_to_le32(addr);
>  			pbe_cnt++;
>  			total_num_pbes++;
> @@ -2189,7 +2189,7 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, =
u64 start, u64 len,
>  	mr->hw_mr.pbl_ptr =3D mr->info.pbl_table[0].pa;
>  	mr->hw_mr.pbl_two_level =3D mr->info.pbl_info.two_layered;
>  	mr->hw_mr.pbl_page_size_log =3D ilog2(mr->info.pbl_info.pbl_size);
> -	mr->hw_mr.page_size_log =3D ilog2(mr->umem->page_size);
> +	mr->hw_mr.page_size_log =3D mr->umem->page_shift;
>  	mr->hw_mr.fbo =3D ib_umem_offset(mr->umem);
>  	mr->hw_mr.length =3D len;
>  	mr->hw_mr.vaddr =3D usr_addr;

Acked-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
