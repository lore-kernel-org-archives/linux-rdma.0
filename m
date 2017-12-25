From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 14/15] IB/mlx5: Don't advertise RAW QP support
 in dual port mode
Date: Mon, 25 Dec 2017 09:16:13 +0200
Message-ID: <20171225071613.GW2942@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-15-leon@kernel.org>
 <CAJ3xEMgAtd1PKN2h1NFj=Mt72msuU5bpFy0jO4KFXxXxGRf7hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jJVMc5+FiwMz9o91"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgAtd1PKN2h1NFj=Mt72msuU5bpFy0jO4KFXxXxGRf7hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jJVMc5+FiwMz9o91
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 25, 2017 at 12:16:15AM +0200, Or Gerlitz wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When operating in dual port RoCE mode RAW QPs are not supposed
> > to work on the slave port.
>
> why?

HW create flow table restriction.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jJVMc5+FiwMz9o91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpApb0ACgkQ5GN7iDZy
WKe1nQ//Tf36QZg6fwcRS2w8h61ewE0H+7ZJ/QjYHX1iHUciBJb5DBbbWR56YYP/
aSm3bh9opEmyabE/67qyJPuNxnIW1jyGJTtILMQ702eHXDoUpGRN28qCjE75gva1
5hm4I/D31NkxVDHWe+2G0IXJJCMWOIQMmumLyD1IyGrnuQqxdiOf0Y+xR90zWItm
i97NwAqSEMphvLc3qBoKsgNRiJcUaqc2xWjHnO1UABWW/XpMoMQypZtt0tQ8nqqt
h/jtqPkx+hJDQWozY8UCMKThO8Vv8SwUyJeq6gvMnG+/G14lR8z5T1iHNW9mI0fZ
7cYpQcYi1kQS/xM907RC0uYHQb6eNDh+97AQx4/Ymvs4+/ruWPGaSbLgtdvHh/hz
VpLWnuVGRyE/IIChXlKOR5zbBqVgH7+6bBZAEwWQdTO6tE02g0UYiA5Wri22tUeC
bcqs2gGvhoahoBMSyrexFRDpDcUO7dxbyaoxdOogywrQQNtjOIqI0TCNtRuJb+9x
EH5M6ZYfyXx9TTAhdL+tOwbYCv7eer8Rp7viDnb2ci8OVbp9b62cfPFhJWZ2e1Pn
lj09GEzLhC88PYSzf2poNDE8yNuiWFISVFtyfE4BIMTOV/+0+zIU85xfBAKpKrUS
Jnkxj2p9M2CZ5wELa80c4xI56NT/vj2xz+vc2ElktPqDnc7M0kA=
=uSZh
-----END PGP SIGNATURE-----

--jJVMc5+FiwMz9o91--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
