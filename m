From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/mlx5: Avoid memory leak in case of
 XRCD dealloc failure
Date: Sun, 28 Jan 2018 15:37:55 +0200
Message-ID: <20180128133755.GY1393@mtr-leonro.local>
References: <20180128092533.4156-1-leon@kernel.org>
 <20180128092533.4156-3-leon@kernel.org>
 <20180128110717.GA7001@yuvallap>
 <20180128125208.GX1393@mtr-leonro.local>
 <20180128132557.GB2930@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/1XGRQlv2BMqnS3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128132557.GB2930@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--W/1XGRQlv2BMqnS3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 03:25:58PM +0200, Yuval Shaia wrote:
> On Sun, Jan 28, 2018 at 02:52:08PM +0200, Leon Romanovsky wrote:
> > On Sun, Jan 28, 2018 at 01:07:18PM +0200, Yuval Shaia wrote:
> > > On Sun, Jan 28, 2018 at 11:25:30AM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > Failure in XRCD FW deallocation command leaves memory leaked and
> > > > returns error to the user which he can't do anything about it.
> > > >
> > > > This patch changes behavior to always free memory and always return
> > > > success to the user.
> > > >
> > > > Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> > > > Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/hw/mlx5/qp.c | 5 +----
> > > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > > > index b06a2f9a8df4..39d24bf694a8 100644
> > > > --- a/drivers/infiniband/hw/mlx5/qp.c
> > > > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > > > @@ -5066,13 +5066,10 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
> > > >  	int err;
> > > >
> > > >  	err = mlx5_core_xrcd_dealloc(dev->mdev, xrcdn);
> > > > -	if (err) {
> > > > +	if (err)
> > > >  		mlx5_ib_warn(dev, "failed to dealloc xrcdn 0x%x\n", xrcdn);
> > > > -		return err;
> > > > -	}
> > > >
> > > >  	kfree(xrcd);
> > > > -
> > > >  	return 0;
> > >
> > > In this case suggesting to make the function return void.
> >
> > It is part of global flow:
> > ib_uverbs_dealloc_xrcd -> ib_dealloc_xrcd -> xrcd->device->dealloc_xrcd
>
> I see, missed that code path.
>
> But for my understanding, as of now - all implementations of this hook
> (two) returns 0 always, right?

Right, both mlx4 and mlx5 always return 0, and it is related to mistake
in verbs API - various free and destroy functions return errors without
actual need for it.

>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks

>
> >
> > >
> > > >  }
> > > >
> > > > --
> > > > 2.16.1
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--W/1XGRQlv2BMqnS3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpt0jMACgkQ5GN7iDZy
WKfXJA//X5UoRHGMfgh2gZmYByFUHga+A/3oszhEbxulXWuTEmB0Mej08rt3ROv7
M/mreOJW7jI/oyIaYVEG7IJDEVsdYZSv/PpZnKeXx9hfjfgvWbSOpHRLYsJ7bc8k
kaimM32rHsm4B7f2btT3q+nQOPGEPpQlow1mtxPUmVNYlgoIm13+LolOYdstQifw
PO1yBITxT94I60Fx3oZEEFvwjdK2T6/GhNC6KUr21xjnYjKBdTnpQE0LQ/WINaF8
aSbKshI0JrjmGLMXeEA5LliUlD5vMEMkGjjkV0vWXfIPWeMt3odrfD/rGu1nxAVb
bS4efworZpz4WNqECBYtdr3bw42Th22m7qamB8nQO6R6wGLB2uoJHG0+9Xm5l71m
T+QRMz/pjanwk66UkeQ1uBx54+gCvRbiW0FWl+8+3kyw2PX1Y3nRfgSskkm7YVZC
6XFKMJ0npbQvJ2xfDzN55jcEn3DzKiO1xLHVfj4IDaUWkY6CEHTtvHdDOglIFW8d
7gEurR0TxspzK+ArHr+HXKfPgwxvC6G56+OLKcaXVerEklbgqusg1g08goAk97A6
qU53sCH4WnKFiR7jqqiRroN0WP+r5pQeeoOOIk6EMkK0vsQp2p2sgUnhZHxVAwdd
foix5y0KFXVHcd3UwvfRalVLc25gdJemlkhW9O9/BVFsqxISQbw=
=ByBr
-----END PGP SIGNATURE-----

--W/1XGRQlv2BMqnS3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
