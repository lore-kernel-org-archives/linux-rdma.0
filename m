From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Protect from possible dereference
Date: Mon, 13 Nov 2017 13:53:58 -0500
Message-ID: <1510599238.3735.23.camel@redhat.com>
References: <20171029193435.314-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iyp05VgknuI82Ka4bxmy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029193435.314-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-iyp05VgknuI82Ka4bxmy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-10-29 at 21:34 +0200, Leon Romanovsky wrote:
> Smatch tool reports the following error:
>   drivers/infiniband/hw/cxgb4/qp.c:1886
>         c4iw_create_qp() error: we previously assumed 'ucontext'
>         could be null (see line 1804)
>=20
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-iyp05VgknuI82Ka4bxmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ6kYACgkQuCajMw5X
L90QlA/7BKMjbRMuBnoU9D3a9RaW/Oj8mxwMkjI5D/EVbCl0r0bO3+58IOl0XA1x
F8pIK7y0bA07wUAbAyw4yZYLVAd7rt45Mhu3g+hAJ2NCk5KwXSBEUQU/R6ea5iwH
vhOJgLJydDjDuLJwymvkGzr/ThcA3sTQC5uR8L1eKEKS2Um1INFjX6fxNn0LYuNE
Ewfepr00GyPW7x/YxTclJSDrq3oWk2tc2LqHcuKsmBfoEv6gOML6nHjWnAdFuydY
XCLYA6/4uoYEU8S3YMpL5cdLzZsFxJBIuQhTg+7/b39xVu7pnXnAzD4OQJ3DBcjO
/NdGOFrZ4NbzgvTp3USwhNOM5iEi7w8wyV5Wu2v9Za7Fzs4lEmn/VT5uXYkh2ShG
WQpzk4IJCYDMN/SueopxXslKavEL2RZyU6fTz+ZnKmHTqzwpj5Yn4Y7BSEUHWh6T
4WCGBpZUBI+wfPozxFr+wn5Xh6daH1ehYNibL0UNeWeqjxoq2mchNEUKVv8Gxc56
+TtnPIGTQyZyp4qqYXfoaecK+s4X1XQyxgFi0MAVni0l0TUJ1RNdcDMayAX//2XB
HqMGenL8VpNQo0Mzfgc7aPks/roEpjnH2UnUgFX3I/w85sjP06auVyLd+b9uiXnl
Vh+HyNLQNiKzYMSRkjW+L50I9IImL4Jd1BLpzRPhfJp+BlIOoR4=
=YynL
-----END PGP SIGNATURE-----

--=-iyp05VgknuI82Ka4bxmy--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
