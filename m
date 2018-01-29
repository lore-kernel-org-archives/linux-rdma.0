From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 6/8] RDMA/core: Add resource tracking for
 create and destroy PDs
Date: Mon, 29 Jan 2018 07:14:38 +0200
Message-ID: <20180129051438.GB1393@mtr-leonro.local>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128091725.13103-7-leon@kernel.org>
 <20180128204858.GI23869@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5FNPeqk0egs0iuvD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128204858.GI23869-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5FNPeqk0egs0iuvD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 01:48:58PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 28, 2018 at 11:17:23AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Track create and destroy operations of PD objects.
> >
> > Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >  drivers/infiniband/core/uverbs_cmd.c | 2 ++
> >  drivers/infiniband/core/verbs.c      | 5 +++++
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index 3e95acd29de7..256934d1f64f 100644
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -340,6 +340,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
> >  	uobj->object = pd;
> >  	memset(&resp, 0, sizeof resp);
> >  	resp.pd_handle = uobj->id;
> > +	pd->res.type = RDMA_RESTRACK_PD;
> > +	rdma_restrack_add(&pd->res);
>
> This pattern happens a lot, any reason not to add type to the
> signature of rdma_restrack_add ?

In early versions, I used the suggested signature, but found it clumsy
and liked more this patter, where all restrack functions operates or on
the entry or on the root.

>
> Jason

--5FNPeqk0egs0iuvD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpurb0ACgkQ5GN7iDZy
WKdIVBAA0og8kBHhhpGJJ9efogOJWnFADFELh8XGrASsZ8Xam0BzT/JZgq20ZYtP
olUyw1D+zHH18wagW3goi0utXf+Gs3aUpHt8NpEskZJkGOSRGU1voHHvUDPqU5QI
gYzosU8dLno+VJHKs7IrUsqjaJTaCXJ0Em1IZU2EGApk2JN8BUPY/wDv0ZKjwdvE
O0wFb156tyFFBFVJBBX47pTrhf7sdSgZ2rXPQEDlv3Ojjg7Z+VbqsHCl1CWPHBrl
6EAvto/mcNewzpDOg9dfr39LFEyAh5n7w8IkNaWcxtGgBvPM9BtghQyRqi8nJ5eZ
4dC5A0w5i6off+/HeHTYKenjToGkDkhNKEd3GkDJC2ox/zCmUMOLaFDNhNSOqJSe
UsjEkFo1tb3GJ3JoYv2kvlRlzTgDz63cHCu7ipLU2vn2613opeEUkGTcbezez/YS
IRKLXhwVh2VYsRTggFoYysP3gP0pxYUhjRS13Wocn6tq9mLkSC9PEKZv09lfU4lL
40yiDEl22+sXE7aFUudOq5bRLzbcTzMfp1MMu14OwFDDJexpkWkk40Qe5KdXBk2s
HQgLvCMIwoJeV0XpBE0zRBoaYY9uqzuurx/S9sZATCXQZ7Cm0fOkzBAQEN3NKnNS
uObjD/0s+mQOL50K+euZCoeQ8T6critCWIqplozfxOKKt/jyguQ=
=qe0X
-----END PGP SIGNATURE-----

--5FNPeqk0egs0iuvD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
