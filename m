From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Small fix and code refactoring for mlx5
Date: Thu, 23 Jun 2016 11:21:08 -0400
Message-ID: <e0dd0d52-c26d-4444-2d06-d3f8a4565f5c@redhat.com>
References: <1466166812-730-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OExFUA4cojMjXoPaoE3U3UsOwCs4rK1Po"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466166812-730-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OExFUA4cojMjXoPaoE3U3UsOwCs4rK1Po
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 08:33 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> These two patches are intended for rdna-next and related
> to mlx5 only.
>=20
> Despite the fact that these patches were tested and found
> that no merge conflict is expected between IB and net parts
> of mlx5 driver, we would like to ask you to take into your
> tree this refactored code.
>=20
> Such move will give us enough time to respond in case other
> developers (non-Mellanox) will send patches in that area and
> will cause to merge conflicts during Linus's merge window.
>=20
> Thanks
>=20
> Artemy Kovalyov (2):
>   IB/mlx5: Fix MODIFY_QP command input structure
>   {net, IB}/mlx5: Refactor internal SRQ API
>=20
>  drivers/infiniband/hw/mlx5/srq.c              | 102 ++++------
>  drivers/net/ethernet/mellanox/mlx5/core/srq.c | 265 ++++++++++++++----=
--------
>  include/linux/mlx5/driver.h                   |   6 +-
>  include/linux/mlx5/qp.h                       |   5 +-
>  include/linux/mlx5/srq.h                      |  25 +++
>  5 files changed, 218 insertions(+), 185 deletions(-)
>=20

I had to fix up the fist patch to apply, but the second worked fine.
Series applied for 4.8, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--OExFUA4cojMjXoPaoE3U3UsOwCs4rK1Po
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/5kAAoJELgmozMOVy/dIccP/3omAYKvWVBekaTWzl0Ck3qB
LC/VsNid2KsPBLf7JxUbRUjobl3IKpfQEOKS1JHgnIEUvKtJQ8KO+BrOjgKUr7sF
Olj3CiI2IfIkLPm6EY0ZXvuMSK7l3C/iQeE2gqCw7OZ9Gm/SjC84CIB4vtCJCwPj
v6+FDQpZJl2ILg/XotO4QAlnHIVXSnaS1s/q2eM/o9FaUs+iqBLo/nPewEsjkQ6l
wWZY/Ir+DJ4NADZ7GdR5tlbGdfvQuPEMnAiN8aIioeEXX4riPNKe/S3TIUFTXHhf
et3FOjHVzg6IGHhCfNHLYr92cK+XBhdzvxnoyhjUjbvd++Q1bZhZprsm6KQsitzH
w6K3wZTA6VlIRnVNxf54AGtzZpu5ESu2/GprM7RRpyxaTBzUNVYVdg2MU3LTkPIQ
vlQcd77Kj2iqaJTCaWqChoMyRy1fOivNudZ0ksb7FZP/cNKqG8NQjTa7ntOctE5I
pt2hYCO4PVnNR1S7Upw5z+pqAMtp8kAx7EmQ30cGmb32q2GOFCYwVLgNi7Qh7HUY
MkF3sF0aePz9WbgAAcfnmaij+9xyFFuHcGGOUag9mW8DS/x2qmcb21PjoKsuNr+c
lMvrgJZTVagXZG4G89Ztxg6lk01GyByJGJkflvGsr/r70mcvle3ODsyuek7NE+4n
nr1G4f2WiHxzndBQRjRG
=3HVA
-----END PGP SIGNATURE-----

--OExFUA4cojMjXoPaoE3U3UsOwCs4rK1Po--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
