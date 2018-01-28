From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/mlx5: Avoid memory leak in case of
 XRCD dealloc failure
Date: Sun, 28 Jan 2018 14:52:08 +0200
Message-ID: <20180128125208.GX1393@mtr-leonro.local>
References: <20180128092533.4156-1-leon@kernel.org>
 <20180128092533.4156-3-leon@kernel.org>
 <20180128110717.GA7001@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZFN9GYGE3tAy85aa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128110717.GA7001@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZFN9GYGE3tAy85aa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 28, 2018 at 01:07:18PM +0200, Yuval Shaia wrote:
> On Sun, Jan 28, 2018 at 11:25:30AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Failure in XRCD FW deallocation command leaves memory leaked and
> > returns error to the user which he can't do anything about it.
> >
> > This patch changes behavior to always free memory and always return
> > success to the user.
> >
> > Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> > Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/qp.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > index b06a2f9a8df4..39d24bf694a8 100644
> > --- a/drivers/infiniband/hw/mlx5/qp.c
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -5066,13 +5066,10 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
> >  	int err;
> >
> >  	err = mlx5_core_xrcd_dealloc(dev->mdev, xrcdn);
> > -	if (err) {
> > +	if (err)
> >  		mlx5_ib_warn(dev, "failed to dealloc xrcdn 0x%x\n", xrcdn);
> > -		return err;
> > -	}
> >
> >  	kfree(xrcd);
> > -
> >  	return 0;
>
> In this case suggesting to make the function return void.

It is part of global flow:
ib_uverbs_dealloc_xrcd -> ib_dealloc_xrcd -> xrcd->device->dealloc_xrcd

>
> >  }
> >
> > --
> > 2.16.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZFN9GYGE3tAy85aa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlptx3gACgkQ5GN7iDZy
WKdNCg//eqBaRJ44iPGEKSE4w8X+v4XH4n3O0p0v92exrikyKs4ukNWP5EK9+7Wc
wXvAFrSC5K5GR5H3WW+/lkLiyBkXvwUIg4lLvvKiVPsG9bjrkxe8vulSkFVA3eZ5
dQbuTHQsfnE1vjFeaf3Lb8ji7AgUEPFUzNb0QUBh+cZa9y/Ux9W6LwZ4Ry9+Mbe1
+Wy8F7JNg+adk+KHjUDWKNVFYO2WdtMIpsv6kKB7S7KVvIR3x0ZNIhZJpjBq6fko
v7nxPmnVJiVw2m1TXkqFZUJh6gG4qm3rQuROiUDmEpezUSAhyZyt3M/x68TVkOZ0
4t7r0Xp7z1QZV/Yf0mWu3s0p9CYnSatInJBeM7NFKB8YWFpyQktyuk9r+KQPt2EV
llzUZZ6NH0teFBgxQFbQfCbfevJCBlfaaPXvIq5h+n8h70daNdGbrnZ76MrMSsZn
Rd8Tzx5/0WCR5fncFWihL2Yo8mpbOCVZqKMTetmxUR0hCiWBGYnlN3nlOSvD1Jdj
WU0aKP45kKatmK/6jaIiqX+PTMdp+/uFF8vs3G1VjrTt0c6LzKiCRdpf99aL87+0
rqMeMD0MHBzb1vyGec2u8BBIxiLMNBaJWBFUmewqjWfRjBQ4y6YcNDfFx0Gx5aNM
7Bk4RG3WnqBXnNJDb/hACfNro/zsFtPFbXNbyWGGbRy/OxBENC4=
=dA9R
-----END PGP SIGNATURE-----

--ZFN9GYGE3tAy85aa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
