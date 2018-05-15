From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 16:00:29 -0400
Message-ID: <d4a8a280c94dd8db969bc52abe057af1fde89a4b.camel@redhat.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
         <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
         <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
         <eb6edd23b76a176b876002cc19c546a0669cf66f.camel@redhat.com>
         <c9d9c8dd-682e-ab38-a3af-6159adbebba7@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-c0BWLrTma+UAoMMELHNK"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c9d9c8dd-682e-ab38-a3af-6159adbebba7@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-c0BWLrTma+UAoMMELHNK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 13:53 -0600, David Ahern wrote:
> sure for the above, but not the ones below.
>=20
> Before this patch, this program:
> $ cat a.c
> #include <uapi/rdma/rdma_netlink.h>
> #include <stdio.h>
>=20
> int main(void)
> {
>         printf("RDMA_NLDEV_ATTR_NDEV_INDEX =3D %d\n", RDMA_NLDEV_ATTR_NDE=
V_INDEX);
>=20
>         return 0;
> }
>=20
> prints this:
> $ ./a.out
> RDMA_NLDEV_ATTR_NDEV_INDEX =3D 50
>=20
> After this patch,
> $ ./a.out
> RDMA_NLDEV_ATTR_NDEV_INDEX =3D 58

I just sent an incremental fix to the list under separate cover.  You
can squash that fix into Steve's patch and it should resolve the issue.=20
Or Steve can respin the set.  Either way.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-c0BWLrTma+UAoMMELHNK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7PF0ACgkQuCajMw5X
L91OOg//TH3NQH84JM+1dsqGHVO1XbyOq3fQrCGOHR6Xr08uK/jr9/g6SIMHnluJ
MSSNM3dQK19bFaFjzePFpLPh5sn7F9qVJy3ugmmTL/Z2Ec+36hlZOnvv89+f0e+K
UXwdoubJWpDAHYWiUwLntQIQgv/1ApDwgQBeY356wTC2gJ6r6jPc5WqMScJLikCY
U2wbJ8kCCig9k4ZC5bwLplK7pnceyAA1jK8R6sZ0/VobLII6wsnlD8b7lKLnAckC
wbozstnhvluOhMOJ6mdhutzHukczPG+Eur8plqCnxiOGot+xV+Vk1TkJvnkO652c
DhXZe67VZdSTDMOqOYRkXtkO5QbfoKcnrwt94ffAdhRKO5Wwk7iBjOs1KXcycZxC
bsVhX/NRcmJ8tm7QCT2V1YsRZcZAL3lKHLHGb6X7Wpryjb33yHup7HBhIEE1i4VC
WiLTggZI+8g2cJE8ft94otfr3cJy7Bh+QeF1hNhwoEUTifZQSs1hyNTewfwYlJa8
SHjfjwHYUVthiiwyFIn/pe7SBMESIYPyu26sJA7Gk/NNxYcRY+Cq586lQuRifnXQ
TdMenz/u9Vo4eM0hQjgY5mbWDgxbzrXHkvZ3iyAY9Lyl6apNs60bOOB7gjSe2CH1
nEO2T+xm9oNu+H9nMiDkhsdiG29JK1OKBkHGjFkfPS5jlL5PM48=
=blN7
-----END PGP SIGNATURE-----

--=-c0BWLrTma+UAoMMELHNK--
