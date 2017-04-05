From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB: Replace ib_umem page_size by
 page_shift
Date: Wed, 5 Apr 2017 09:11:32 +0300
Message-ID: <20170405061132.GC20443@mtr-leonro.local>
References: <20170403100640.3332-1-leon@kernel.org>
 <20170403100640.3332-2-leon@kernel.org>
 <20170404225723.GA12652@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1kVeyRzorzGcO9ta"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404225723.GA12652-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1kVeyRzorzGcO9ta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 05:57:23PM -0500, Shiraz Saleem wrote:
> On Mon, Apr 03, 2017 at 01:06:31PM +0300, Leon Romanovsky wrote:
> > From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Size of pages are held by struct ib_umem in page_size field.
> >
> > It is better to store it as an exponent, because page size by nature
> > is always power-of-two and used as a factor, divisor or ilog2's argument.
> >
> > The conversion of page_size to be page_shift allows to have portable
> > code and avoid following error while compiling on ARM:
> >
> >   ERROR: "__aeabi_uldivmod" [drivers/infiniband/core/ib_core.ko] undefined!
> >
> > CC: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > CC: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > CC: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > index 9b2849979756..fb3a4ca354be 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > @@ -1354,14 +1354,15 @@ static void i40iw_copy_user_pgaddrs(struct i40iw_mr *iwmr,
> >
> >  	pinfo = (level == I40IW_LEVEL_1) ? NULL : palloc->level2.leaf;
> >
> > -	pg_shift = ffs(region->page_size) - 1;
> > +	pg_shift = region->page_shift;
> >  	for_each_sg(region->sg_head.sgl, sg, region->nmap, entry) {
> >  		chunk_pages = sg_dma_len(sg) >> pg_shift;
> >  		if ((iwmr->type == IW_MEMREG_TYPE_QP) &&
> >  		    !iwpbl->qp_mr.sq_page)
> >  			iwpbl->qp_mr.sq_page = sg_page(sg);
> >  		for (i = 0; i < chunk_pages; i++) {
> > -			pg_addr = sg_dma_address(sg) + region->page_size * i;
> > +			pg_addr = sg_dma_address(sg) +
> > +				(i << region->page_shift);
> >
>
> Remove pg_shift local variable and use region->page_shift directly in this function.

Sure, I'm sending v1 shortly.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1kVeyRzorzGcO9ta
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljkipQACgkQ5GN7iDZy
WKfkDxAArEtLMwMV6dAp/nh5Y03pEqwdZyciEYepXXtsPwL5dWDRvd2gD0gO2DV6
UW7Thbr8k37HIUTw+RtuxaM0NYN6MLv74aklrPrluuUfTt1Lrl49yTSM7Zlvr1Om
G1xXoJspV2lWGjWXaoJqINIqD/XOhWYBporE9y3TpqnDYXSDgT7WcqxKHW29mmRq
cxKnhGU9TRMVDzKOh00uiyWO8rokp/qSUYo+hJfKGsV9pPGGh/ykeM8KewkClgYU
SfeTtvwkTJd1Qppx0Ejt1j0WCd1DLML8sPkxvUdi28n7LnTA/82+xX3AvIhJWwwU
6iw6t/jvnd/gF0KjgBd58qVHfM9OfksC3Igb+ylDuBuziFPB82zOh9NmaPNtw4G4
ZFa5jxbclooM02KnIED9QoWlAf2nLTuVAcNCkec0B1W9bWAX86AdWkes1NQy0wJc
1mfg4L6criD2PDNXTzFj7skZXoXXATo61eV9FZIYuvglT6At/39yLBrFYUWQGW2Z
F4J9UUseGdj4ebIei3a1oNrAt5qDW5tjZ0g4lBbquh9uMvF3wHoFfzsrgGtu/DtT
65x7Y6enMztD5lfipvyK8jwoV6bn4MEQm8pLZAQv5nu7fGv2EFOHT+dVYM/ULxxD
zhamFxHvCyj3BzkfnCV2R2DBIqDkHzn9mTLgsI43vUeJSLXNzj8=
=2P6T
-----END PGP SIGNATURE-----

--1kVeyRzorzGcO9ta--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
