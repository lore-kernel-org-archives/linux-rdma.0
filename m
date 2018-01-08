From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/12] IB/srpt patches for kernel v4.16
Date: Mon, 08 Jan 2018 16:11:16 -0500
Message-ID: <1515445876.3403.93.camel@redhat.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qKgfum990rOTTiCfaUAc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-qKgfum990rOTTiCfaUAc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-08 at 11:00 -0800, Bart Van Assche wrote:
> Hello Jason,
>=20
> This series includes multiple small changes for the SRP target driver. Pl=
ease
> consider these changes for kernel v4.16.
>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (12):
>   IB/srpt: Remove an unused structure member
>   IB/srpt: Fix kernel-doc warnings in ib_srpt.c
>   IB/srpt: Document all structure members in ib_srpt.h
>   IB/srpt: Rename a local variable, a member variable and a constant
>   IB/srpt: Reduce the severity level of a log message
>   IB/srpt: Verify port numbers in srpt_event_handler()
>   IB/srpt: Use the IPv6 format for GIDs in log messages
>   IB/srpt: Convert a warning into a debug message
>   IB/srpt: Reduce frequency of receive failure messages
>   IB/srpt: Introduce srpt_format_guid()
>   IB/srpt: Inline srpt_get_cmd_state()
>   IB/srpt: Micro-optimize I/O context state manipulation
>=20
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 336 ++++++++++++++++++++--------=
------
>  drivers/infiniband/ulp/srpt/ib_srpt.h |  40 ++--
>  2 files changed, 221 insertions(+), 155 deletions(-)
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-qKgfum990rOTTiCfaUAc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT3nUACgkQuCajMw5X
L93fWw/7BgH0r9ceX8XrFPcLSYk7OpNkYtTrJanqKFR0OhqxFZf6mHCE+PTsPaD2
JRl6BhcnZT5QChMnn307QvVlzNJDJGIUgRvq5lhTBgGJiQx30f1iFsojTvXsbVdt
Fkdj7ogVXnTviQEwX3WgVa60kCNtCZQHx+IEPCTwDVL9EJ3GRKDDU1J46CGR+uy9
wGyupo5qmt9udD1+cTesR0nDwxXeu0OLCCj0v5E4Iyc/hpvQQ/T0A71eQTI/6UVo
Durj66tUqWQHnKXP8DhhQQ0/rv3GSOUb4/BWRzxYw/Bb9G/jfbfMPjGh1AFhWmzQ
UXa/OtPvAFSae95viDCWPqdbeRoY1/+GyALrxwmmA0GGZSIzOBE45UaO948TIAWz
NP+PrkjcKV90JfMwhCpCFPaGei2chTbXF3c2xI8Kxj//fzSkFYtUAxArMv13vo6K
XnI4WpRUfa3G3JIojyutGieNQ42XoOGjWuS+mFFyisQHJQ10GJHTg+Sx1G7cm90Y
gfG1/C22be+qp3P46xl95a5SDabxOw+ZGUO/LCJKL2bfRJhuuWjtZqseYOgbuvOE
Gj0cImp5PxLXdEIeNn17HngipC4ZNigsUWY7VbxUkrSQw/gJA7kOTgab2bmsIONn
dfn8qtVPZRdUBcqY5Rk5MJFE/2lABcBe/DmQdeAwpZglJzlZf7U=
=eVsx
-----END PGP SIGNATURE-----

--=-qKgfum990rOTTiCfaUAc--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
