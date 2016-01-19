From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/12] IB/mlx4: Add RoCEv2 support
Date: Tue, 19 Jan 2016 15:50:23 -0500
Message-ID: <569EA18F.6010506@redhat.com>
References: <cover.1452780849.git.monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xctueaWubcsANFrd7eaguT3QB3SkhBr2X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xctueaWubcsANFrd7eaguT3QB3SkhBr2X
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/14/2016 10:50 AM, Moni Shoua wrote:
> RoCEv2 is the InfiniBand transport protocol encapsulated in ETH/IP/UDP =
link
> and network protocols.
> The implementation to the IB/core driver was added by Matan Barak as an=

> infrastructure for any vendor driver and this patch set uses it to add
> RoCEv2 support for ConnectX-3Pro NICs
>=20
> Matan Barak (1):
>   IB/mlx4: Advertise RoCE v2 support
>=20
> Moni Shoua (11):
>   net/mlx4: Query RoCE support
>   IB/mlx4: Add gid_type to GID properties
>   net/mlx4_core: Configure mlx4 hardware for mixed RoCE v1/v2 modes
>   IB/mlx4: Add support for setting RoCEv2 gids in hardware
>   net/mlx4_core: Add support for configuring RoCE v2 UDP port
>   net/mlx4_core: Add support for RoCE v2 entropy
>   IB/core: Add definition for the standard RoCE V2 UDP port
>   IB/mlx4: Support modify_qp for RoCE v2
>   IB/mlx4: Enable RoCE v2 when the IB device is added
>   IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
>   IB/mlx4: Create and use another QP1 for RoCEv2
>=20
>  drivers/infiniband/core/ud_header.c       |   2 +-
>  drivers/infiniband/hw/mlx4/main.c         | 101 ++++++++++--
>  drivers/infiniband/hw/mlx4/mlx4_ib.h      |   8 +
>  drivers/infiniband/hw/mlx4/qp.c           | 256 ++++++++++++++++++++++=
++++----
>  drivers/net/ethernet/mellanox/mlx4/fw.c   |  39 ++++-
>  drivers/net/ethernet/mellanox/mlx4/mlx4.h |   5 +-
>  drivers/net/ethernet/mellanox/mlx4/port.c |   7 +
>  drivers/net/ethernet/mellanox/mlx4/qp.c   |  26 +++
>  include/linux/mlx4/cmd.h                  |   3 +-
>  include/linux/mlx4/device.h               |  11 +-
>  include/linux/mlx4/qp.h                   |  15 +-
>  include/rdma/ib_pack.h                    |   4 +-
>  include/rdma/ib_verbs.h                   |   1 +
>  13 files changed, 425 insertions(+), 53 deletions(-)
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xctueaWubcsANFrd7eaguT3QB3SkhBr2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqGPAAoJELgmozMOVy/de7gP/jyltRMmpJufK+hYV/jtLVxq
v/HoGg83jJdEe28bvZ0ZpFJFkRkQy0W5sCLck9R3n+NN/8AX7mrm9AkbHdPU4fDE
Zn3V9LNulgtmkzawK14PfOPtesudgAabUKrQXmE8g+jDoWYJunLrOj0sK2x/efA/
D4dr00iS6C0Wj//qIpPUlQKENuJZfnd6SMMPbgYqDpUu+w3rWihsartDS/GOEpsH
PuosObBpy2cDhF53ZIaKRDzoI6fcPb9wbQP/an2v206FJ3KiP3Rd5zkNYX1EupPY
DBvAr4HvqUAXRpnfx6oprFMVuLhLTQvF8IqBQgfAMaQbvBoy6/pQFijgKhWc9GoO
T0M2Mjinw2osZiGiaYCyzG7VLFjfhW+wBKEphgR7CdNCxGsRuJ7rOsFB0tqmJmue
t6cPgJcoWghTHsphqqcr9xLACbEsOjGLo8PfsiNo6+jCqgCFDdDvmfhj7snovwEN
1ef5gmGVIbwUoGYjL1kiaOW6F1rXz/oMZLNv3KQG/FpXLO7X4XhjGd599RwTJzNB
NUBSCZeUrSVdWB8TT4cPTuI5ygqrwGH0LzgJBjKrBSZ9ga0IichnSmidRNlkqFYw
lKJCL+Jr6G/wbQvdFBt8gEV5ctR6aezQiU/z74qCbduaOcABgoe1TIbhZ02XRpgN
yB/u/u0eBWQIganQKH2v
=80L8
-----END PGP SIGNATURE-----

--xctueaWubcsANFrd7eaguT3QB3SkhBr2X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
