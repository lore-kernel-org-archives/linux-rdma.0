From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH  v3 0/2] IB/mlx4: Enable debug print of SMPs and enhance
 output for MADs
Date: Tue, 16 Oct 2018 14:23:55 -0400
Message-ID: <5393ae97b20baf19e9352c3b3a155d83076e67e5.camel@redhat.com>
References: <20181009132740.2210085-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6T08wPwSugmjpZagFXdD"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009132740.2210085-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: leon@kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-6T08wPwSugmjpZagFXdD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-10-09 at 15:27 +0200, H=C3=A5kon Bugge wrote:
> SMPs were not printed at all. Added printing of port number and TID to
> all MADs
>=20
>=20
> H=C3=A5kon Bugge (2):
>   IB/mlx4: Enable debug print of SMPs
>   IB/mlx4: Add port and TID to MAD debug print
>=20
>  drivers/infiniband/hw/mlx4/mad.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>=20
> --
>=20
> v1 -> v2
>     * Fixed incorrect format for printing the TID for the second patch
> v2 -> v3
>    * Made v3 consistently for cover-letter and the two patches, my v2
>      was partly original submission plus a v2. That probably fooled
>      both the kbuild bot and patchwork
>=20
> 2.14.3

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-6T08wPwSugmjpZagFXdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvGLLsACgkQuCajMw5X
L916+w/+JY6knNWacHkwzA11/iUP3harzSISQ8bqPW2wL4MSb8buO9bvuA/oYZDU
SP3aQdeuXpkz7yjDHooPSlkXLr2WHJz82ZWFxyGW5B0iwg7JZam6zWEROw0HuQQH
WFJC6QaEBmEgJB5En3HDfZPM0Xgvr7BG3L/k4satp6hD6Ei0XAajVeu+GHR2gEmI
CB4pLHoEFqFL/TiUACpWkGvBRIdnsptNtCgRKiJjdmzwlxBqW6Aaw7GbTvncnoEg
mGcfQdvT9JmHBWxv2vRR36mhl0xdZ54DsSwaL9gr1hwIUeIQDvO+/ZX1Rg5JXNp9
UFUp6/o1waLHSPdDohxdGaFiljlg9o/fnTFd56vM6Tep2MeZbuf3hVE6R7gTD+5W
BJmD0KHNtt7+pBrve3DNYV1SU1soXQQLDw+cMUVHX2Ztxtugc+9n40m5CudhTRbK
2CXYJfcZWbtKU8JOguRLRSHvyM+erFnpDz8DBMJszT74axDF3xy6y77ImKCChlfu
0XW4M8gNhVwCk3HInD5X4X3zgOqoslh0C7BR9c/ptA51d5Nr137Acy8w43qTuGC5
4Vw32POBfvCfONB2eqbr7einMWNivaFTI+vl9QEIHrfpYfyyAUgvonPCfB74r3uh
VnrTK6CbBRxZzUZ5Ul9h1sAjz5mSnreUOnql3uQdJI77oWA5Wik=
=G90Z
-----END PGP SIGNATURE-----

--=-6T08wPwSugmjpZagFXdD--
