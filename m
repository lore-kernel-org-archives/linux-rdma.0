From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 08/14] RDMA/uverbs: Properly check command
 supported mask
Date: Fri, 16 Feb 2018 09:31:47 +0200
Message-ID: <20180216073147.GL2197@mtr-leonro.local>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-9-leon@kernel.org>
 <20180214234714.GE1718@ziepe.ca>
 <20180215135628.GH2197@mtr-leonro.local>
 <20180215162603.GB18416@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yC91f7qSViS67v3c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180215162603.GB18416-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yC91f7qSViS67v3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 15, 2018 at 09:26:04AM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 15, 2018 at 03:56:28PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 14, 2018 at 04:47:14PM -0700, Jason Gunthorpe wrote:
> > > On Wed, Feb 14, 2018 at 02:38:38PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > The check based on index is not sufficient because
> > > >
> > > >   IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ
> > > >
> > > > and IB_USER_VERBS_CMD_CREATE_CQ <= IB_USER_VERBS_CMD_OPEN_QP,
> > > > so if we execute IB_USER_VERBS_EX_CMD_CREATE_CQ this code checks
> > > > ib_dev->uverbs_cmd_mask not ib_dev->uverbs_ex_cmd_mask.
> > > >
> > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >  drivers/infiniband/core/uverbs_main.c | 18 ++++++------------
> > > >  1 file changed, 6 insertions(+), 12 deletions(-)
> > >
> > > This seems like an RC fix to me, since we are not properly validating
> > > input commands... ??
> >
> > I don't think so, it looks harmless to me because all vendors except mlx4/mlx5
> > have zero in uverbs_ex_cmd_mask and mlx4 have all commands implemented.
>
> The issue is we check uverbs_cmd_mask when we should check
> uverbs_ex_cmd_mask, so drivers with a 0 in uverbs_ex_cmd_mask will
> still pass this check.
>
> and your later patch checks for null, so what happens if, say, rxe
> calls an ex command? kernel oops?

So actually, my latest patch (addition of NULL checks) should go to the
-rc and not this one.

I still prefer to leave this patch in this series (-next) and avoid
writing completely thrown away code for -rc, which will create only
merge conflicts between rdma-rc and rdma-next without any visible
benefits.

I'll reshuffle this series and resubmit.

Thanks

>
> Jason

--yC91f7qSViS67v3c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqGiOMACgkQ5GN7iDZy
WKcEhw/8C/ILqmCF7TZyKE1jX+OLmnkMZwLR4UVWnSDYPFFZkVnw5SIzz/y38ICi
LgllatSkMudj8DoMhu3rPUVh/hr7p7vHJZr9koy2cBHmDPMCvO0WCrWa/8sRhw87
0ef+yAtReUXQvmpqQsFnI0SG4irnK7yDLiDGCNXZRNbP5lkuoMsnpcOS67QwlYeb
N4AB7XB1+DlTBkmCpKTznfBjwf3wSUSHb+oE/9kZCqHQ5auMCD1ip3p0OwxVZp5R
gzzwb5rt93eY/XyK5LYZORmIOlUIez1NvztROQ7qoE1nMMNAyi6jjXwiEUP1XOvw
jRAMfdR5i404DX8vT0eBroAEph8wY44GVVcbvaX6Sj9MrZ3KutK933QKJQjZNvvz
jIhnikKm5mDgjYT4jiB1y1SmWDdmS93HBOIbotWsilCNWymtGpJnVdSFJ1hZ7e1a
B7HxRi9VCbYKLm+1J1VTclA9MVv1Xk/DcjYHTsyAAcxYGQOnLNx6YcjzSeSlfavZ
qhQCElhCdcMlLml5MrTm1JyQxMpMxanTXqbCbZnDVaFYcRyrGm3W4iiYLeiHSD6q
0mh3yNUlXTNsIgma8RTkayKP/XMXTueLXf3BzcAPLvwiT9c4C56Vmc466GojxS5U
pgITEd3cdzflpzo0mma5Cs+z9ztBkFvzcjLynNe/lm6lJDADv4I=
=0hf+
-----END PGP SIGNATURE-----

--yC91f7qSViS67v3c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
