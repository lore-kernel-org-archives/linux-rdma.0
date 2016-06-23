From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH REPOST v3 0/2] libibverbs memory barrier fixes
Date: Thu, 23 Jun 2016 10:53:28 -0400
Message-ID: <8a33aeb7-5b76-d21b-7b7b-b5f9ceac11be@redhat.com>
References: <cover.1465310573.git.root@r9.asicdesigners.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kgIkmJ3Q6ajdvlWqvfuSU7G5N7r8AhbI4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1465310573.git.root-6HSsQxwzXLRrcEM49+0neVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kgIkmJ3Q6ajdvlWqvfuSU7G5N7r8AhbI4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/07/2016 10:42 AM, Steve Wise wrote:
> This series implements ARM64 memory barrier support, and fails compiles=

> if there is no platform implementation of the memory barriers.
>=20
> Changes since V3:
>=20
> white noise fix
>=20
> parens around asm macros (checkpatch recommendation)
>=20
> remove RFC tag
>=20
> Changes since V2:
>=20
> Implement the mb* macros from scratch
>=20
> Retested changes on ARM64
>=20
> Steve Wise (2):
>   libibverbs: add ARM64 memory barrier macros
>   Fail compiles if no platform specific memory barriers exist
>=20
>  include/infiniband/arch.h |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--kgIkmJ3Q6ajdvlWqvfuSU7G5N7r8AhbI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/fpAAoJELgmozMOVy/dNBcP/00v7W2c6pqIfHxpj194GJ2L
g37AklOIZaQO8rl8YKpGiWCP1xmyRRXhy7vOQoXDZi8MoLMDhRHwvMiNjELLxMSb
cB1xUWw7H6mx4aTkB+uFrkAYgSWy0TKVCh65Yem1cWS+T3u0/Tk4F2iiAt6JsvUd
JoO8JTOHye/aYsFQDc0QCMhKZWwHz0OKMMiVMQr+/OsCY5PHD6PrRnOdH2RdSUbL
/iCG+i3oxTdT+vYOUtZ1DoZCz0sSycgNPmb/SOMZhc1h9sfosXGJqWWBvaoS0CVW
TtFaS9aSxMFLU+fmnNA4djiv5scvCGAtZl9VCg97sSi17G2IwZUfiyQAFQfYSatg
dBM8rUHfwlw14+6I0GgflGaYB7pGkJGDeDxgWuTnzwPcWx5CbBQhMzHmi3EVXQgy
k28XV3VL981E/8o3fRqHltqbwsnHCxdB4pIKtKcTziD54uKyHLLwkeNuN1Dmp7Lj
zanKRqHN+11d3GB6YpWgqefGgkHqknr4ACBoJIZRApnOywG4vD3ce8OhMk7DBxYd
H9dnVOV+AV62JG/2VXguveTs/bEOltUGBnTyJnaH5MssrTQaWSY81KAS2Lx2IfC3
/vw6noSPJg2ez1S5gDd+yNkZG4hadPmFo0ZuiVg9yhUIc6i6vnEMEvhMTdFlKsXe
pU9XGgNTwFL9UjtGs06D
=O1JW
-----END PGP SIGNATURE-----

--kgIkmJ3Q6ajdvlWqvfuSU7G5N7r8AhbI4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
