From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1 2/2] RDMA/cma: Make sure that PSN is not over
 max allowed
Date: Tue, 28 Nov 2017 09:37:31 +0200
Message-ID: <20171128073731.GP29104@mtr-leonro.local>
References: <20171126182354.18709-1-leon@kernel.org>
 <20171126182354.18709-3-leon@kernel.org>
 <20171127183755.GB13966@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwbb4r/vLufKlfJs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127183755.GB13966-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--rwbb4r/vLufKlfJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2017 at 11:37:55AM -0700, Jason Gunthorpe wrote:
> On Sun, Nov 26, 2017 at 08:23:54PM +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch limits the initial value for PSN to 24 bits as
> > spec requires.
>
> Since this is for-rc, what is the user visible bug this corrects?
>
> I think it is because the QP setup can fail if reserved bits in the
> CMA message happen to be set?

It won't fail, but will print nasty warning down the road after commit
=66rom Majd "IB/core: Make sure that PSN does not overflow" will be
accepted.

The flow is PSN ->
		seq_num ->
			rq_psn ->
				rdma_init_qp_attr() ->
					ib_modify_qp ->
						ib_modify_qp_with_udata ->

1334                 if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffff=
ff) {
1335                         pr_warn("%s: %s rq_psn overflow, masking to 24=
 bits\n",
1336                                 __func__, qp->device->name);
1337                         attr->rq_psn &=3D 0xffffff;
1338                 }

Thanks

>
> Jason

--rwbb4r/vLufKlfJs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlodEjsACgkQ5GN7iDZy
WKd4VxAAsKGL4UbTIgyWVqywFIcrpHxQwiWkSaTwLQtvKCi3TpJ2oXumLioQEAoy
hTwghlK7uxsSP5uoehrCmNNL13hT3VjC3LOHJGM5Bv7gxUW6AQ6ap4M1Yz0uhG4V
9NpPjTVwSz3NIBgoRulQO3Kw3BMhuH64hsaw0vJWtWNCBCit4ykelHR+7P6vETdc
f9Riw/mw0LP/+7iB1s131Z2tgn2VsOkOPNHg3uslZr47p5Egw1c9fG6dmEX91T1t
pLf3kLviLm8yxrSe5oqapRxKiDgv3KXKVDcQUg7Uv0WIwf31FtJ8EYovRKO417l6
GjefqPxHDc5XxX+qnyshwA0jZKd9X/t2Oi/r4XNMdWXY/X+ZKhmNPFBEIzNzCAID
A9IJyAt479J3bjmXOHlf5+OH00VaWP6ditNvisX7x9lRQY4/TM/vbZlQWj+C3+Gj
fgvvk13NtDLK3VaaYyKI6CivCtNakKOZea+Na2z7xfSKxxmgt6nfd4PvHAW7yK1n
sDao1jZ/JsdLpHA2g16inJtaE8rS/gDAfJr+EkG+eUhTTxfWQKp7QFHcSGmMe6Fc
yER6ilRqzFHqBfRXY4yrmgUdYoOUKJy/JXKBxS0ZpbNAmBuIO1ZPOlcNXteP1gpT
pHW/uERmO+E5HCYYcco3gWTY9x/Gsg9XDEJf8Qp6hNor5R31pmk=
=XMhH
-----END PGP SIGNATURE-----

--rwbb4r/vLufKlfJs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
