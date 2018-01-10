From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH][next] IB/mlx5: remove redundant assignment of mdev
Date: Wed, 10 Jan 2018 16:53:41 -0500
Message-ID: <1515621221.3403.171.camel@redhat.com>
References: <20180109155543.15027-1-colin.king@canonical.com>
         <20180110074003.GG7368@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wtA3h/kQyuZdtfr0FAXN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110074003.GG7368-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-wtA3h/kQyuZdtfr0FAXN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-10 at 09:40 +0200, Leon Romanovsky wrote:
> On Tue, Jan 09, 2018 at 03:55:43PM +0000, Colin King wrote:
> > From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >=20
> > The initial assignment to mdev is redundant as mdev is re-assigned
> > later and the first assigned value is never read. Remove this
> > redundant assignment.
> >=20
> > Cleans up clang warning:
> > drivers/infiniband/hw/mlx5/main.c:359:24: warning: Value stored
> > to 'mdev' during its initialization is never read
> >=20
> > Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
>=20
> Thanks,
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-wtA3h/kQyuZdtfr0FAXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWi2UACgkQuCajMw5X
L92+OQ/+MfK9s+NsUdSb+NVAf/DkFuXmkWPmPFHIjwVqHHTovJweqZgQORm/uBah
HkcflMAw4fLghmGkEKsMK0JciO2mMBfSLPngsWvgsNckHlRNDL1rzllHrYdeE2bb
xXZ3KhVKZWLIYRadEOcLVId79YncBng1z1grjtScCcmQ8cBhnxrKZ92P4zODlUpa
gCFg7xLQZQxP7r8zURvnuqf6X+16H2LXAl7V/FquqzBWSps/1OWN+hrqiQXmJF+R
nmGjtSkwgnS468iK0d2aycTqfcIj+JeUXGqX9VKJt/iOsmwRkFdDXS6An56GK+8t
/CaXUmp5JhiU2T+Rvzc3CsNIJ0UFG2YqLH2NCCmw8wu/z+/VHz8/IyG+9A4t1nsd
zuUU/gcjo9POZeI75xGKzIpSbtdFtiOJ2AW1bZ7i3mtPXiGkeyIbRvxNvtpqIOMp
058VPLSsnS4tJ+6XSo8iuAEL/e3jtSav7orzMnS5VFE0WNlv7zkz9NpxF2n8RvOF
YC6b9apqTpf/XiRNwmxwX0FR9Q7uF9yd80u5t2JUXdkbmEaAKDRbkd0TavPxNFxA
VsJmgQTLEVQILSrFnIFjdtNYJRfJbWbwzoUQeh2ZC4YzM9tFxl9decZ/x0A9uE8z
ydrOSp9lbT2gr0P1uCGbcBo9tr6o9WWcEuSv40xYyvTcN0TwDRU=
=g9Hh
-----END PGP SIGNATURE-----

--=-wtA3h/kQyuZdtfr0FAXN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
