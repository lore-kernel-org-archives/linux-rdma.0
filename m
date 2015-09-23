From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v1 0/2] libmlx4: Add support for checksum offload
Date: Wed, 23 Sep 2015 12:17:25 -0400
Message-ID: <5602D095.8050702@redhat.com>
References: <1442953326-105006-1-git-send-email-bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BdOW5gHas3G4ffbJi85h2OOp2TsxB8umB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953326-105006-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BdOW5gHas3G4ffbJi85h2OOp2TsxB8umB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/22/2015 04:22 PM, wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Changes from v1:
>  * Update patches to use the device_cap_flags to get the checksum offlo=
ad caps
>   =20
> Bodong Wang (2):
>   libmlx4: Update ibv_create_flow/ibv_destroy_flow according to change
>     of libibverbs
>   libmlx4: Add support for TX/RX checksum offload
>=20
>  src/cq.c    |  6 ++++++
>  src/mlx4.c  |  4 ++--
>  src/mlx4.h  | 19 ++++++++++++++++++-
>  src/qp.c    | 19 +++++++++++++++++++
>  src/verbs.c | 24 ++++++++++++++++++++++++
>  src/wqe.h   |  8 +++++---
>  6 files changed, 74 insertions(+), 6 deletions(-)
>=20

For the series:

Reviewed-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BdOW5gHas3G4ffbJi85h2OOp2TsxB8umB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWAtCVAAoJELgmozMOVy/dPz4P/A8wkPuOxjT6beu5lWf9h0/W
nBR51v/ipvmWpZjYULfS71yJtFBl9+0T/0fJL6B3Sid17VAML2A1X2BQ2HYA2hun
J08hJ1SRRpaSZggWCOu1O+Xa6m0jivdM0YJMmcCndiZx4mffKlS2IBHtXUz+OeeV
nsX3f+Xf7SWrxjHjVT+/od01L50kXF8ubiRu0vgEriiKazDje5dG831iGGgFBSAP
biiS9ADaXgvfOrzXqSQIFxbOwgp85ELLbj2eQPmUt4mRjJNVptzOx4S1GgMuXI6z
0cBXurnLzVY+FDF+XXaUk0qST1X5K/DjI6Tre9WTziJrDzQ5/eE25tkqL5VzgiSi
lCdhW2ONFeqi4wglP6PtWKPjpMux7zojfHcOID6+iqCnFFixacm6VZJQmITvCk/w
T+D2NOLp66P4pnljiBQubYqJIEw6mr46TF09jDe3t/yT42pLGtWVtGnxHPZtUXMl
BSqa5xqch8mfpYObqIn58AuU7V/2PlLN5I4J4un2F/A9DS+xvlRo8AHLwKbczzkm
eM/qGKMJI4m/wsLzVIBX5fyyH2hcAKDYbteZsawdVy8ER5NFJZIwrj9ETXYgnQec
Y8JtzmTVLqtRvKLgvX4rKmfCKS4ZHKJcHA1vvwvcN0+17uWXsNPgASfP7HykhKRJ
IFaTtr03xkUFQo+BsDzu
=gyEe
-----END PGP SIGNATURE-----

--BdOW5gHas3G4ffbJi85h2OOp2TsxB8umB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
