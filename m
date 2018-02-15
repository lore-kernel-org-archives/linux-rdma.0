From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 08/14] RDMA/uverbs: Properly check command
 supported mask
Date: Thu, 15 Feb 2018 15:56:28 +0200
Message-ID: <20180215135628.GH2197@mtr-leonro.local>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-9-leon@kernel.org>
 <20180214234714.GE1718@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="19HmC3QOnaNVzKTI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214234714.GE1718-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--19HmC3QOnaNVzKTI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 04:47:14PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 14, 2018 at 02:38:38PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The check based on index is not sufficient because
> >
> >   IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ
> >
> > and IB_USER_VERBS_CMD_CREATE_CQ <= IB_USER_VERBS_CMD_OPEN_QP,
> > so if we execute IB_USER_VERBS_EX_CMD_CREATE_CQ this code checks
> > ib_dev->uverbs_cmd_mask not ib_dev->uverbs_ex_cmd_mask.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/uverbs_main.c | 18 ++++++------------
> >  1 file changed, 6 insertions(+), 12 deletions(-)
>
> This seems like an RC fix to me, since we are not properly validating
> input commands... ??

I don't think so, it looks harmless to me because all vendors except mlx4/mlx5
have zero in uverbs_ex_cmd_mask and mlx4 have all commands implemented.

Thanks

>
> Jason

--19HmC3QOnaNVzKTI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqFkYwACgkQ5GN7iDZy
WKfjFg/3XG72QUnZ5nVPU7bmhc56/XscofYpJsdVv4ZG7gKm5i0kc1Z0Ffe+iRvC
VgbYLCsrZgjOvLQ7HFWswHmL33VnaU6uFm2wq/33DWaJQSR5dzRdqdzKg9LbmOY9
nUYHqglrtNeETqCBEVoLRor97XA5dVxMbinnrkouw7oFfq5C1j6eaC/VN/5U4a4P
uf3h3ReNT66dC0tytAIvCjNKkSydSmQDaNU7pXpnsFDydDo/608YNZOKfBkmj5VD
2IM3IZJv2M1CvmZe2XjFn158F3nEIsyUWlfydhV8YgxB2dMX9nx5GQO6kkhDp9mC
yV2MbqSiEfB55zMoragWcHYl/RKxyoGm/QEAHrIuxXEs+ml53MnYztfc9PQtlUw3
9pHRtz5/6Wb7mGlAmN3dp/Eh/R89Ma5hKnM2aXA1IoHGT6fc9Lo3okWfjzT0ZRGB
eesug2m4A7J+J3hD5RSI6rlsBW1paHaggpxVKdsUnBWKkDKahb03+2gseFZl9Zss
z0ujNKFbsDf+tqaRkiS0yX1SjLM+jZzgkN6sjiTTafeoTWtxXruOqzBMEdH6GITl
4XG4GE0iq7yRNGqyNBXoR65dQ66s4kVqTLo0hlADyw9cu2qkXuJowjSk2qQGcHjA
FDcXDyOTMYi9EJiUVh1XpPPJrTgMzEj+vlFO3BzKHGI9CgrZYA==
=tXoc
-----END PGP SIGNATURE-----

--19HmC3QOnaNVzKTI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
