From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/10] Add RoCE support to the mlx5 driver
Date: Wed, 23 Dec 2015 11:07:31 -0500
Message-ID: <567AC6C3.5070102@redhat.com>
References: <1450876674-21695-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s1vLF1DUWB2Bu7NvtHITXKakuKdUP4WCn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450876674-21695-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s1vLF1DUWB2Bu7NvtHITXKakuKdUP4WCn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 08:17 AM, Matan Barak wrote:
> Hi Doug,
>=20
> This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
> driver.
>=20
> This patchset was applied and tested over the third version of
> "Add RoCE v2 support".
>=20
> Regards,
> Achiad
>=20
> Changes from V0:
>  - Fixed using rwlock before initializing it.
>  - Rebased over Doug's k.o/for-4.5 branch.
>=20
> Achiad Shochat (10):
>   IB/mlx5: Support IB device's callback for getting the link layer
>   IB/mlx5: Support IB device's callback for getting its netdev
>   net/mlx5_core: Break down the vport mac address query function
>   net/mlx5_core: Introduce access functions to enable/disable RoCE
>   net/mlx5_core: Introduce access functions to query vport RoCE fields
>   IB/mlx5: Extend query_device/port to support RoCE
>   IB/mlx5: Set network_hdr_type upon RoCE responder completion
>   IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
>   IB/mlx5: Add RoCE fields to Address Vector
>   IB/mlx5: Support RoCE
>=20
>  drivers/infiniband/hw/mlx5/ah.c                 |  32 ++-
>  drivers/infiniband/hw/mlx5/cq.c                 |  17 ++
>  drivers/infiniband/hw/mlx5/main.c               | 318 ++++++++++++++++=
++++++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |  15 +-
>  drivers/infiniband/hw/mlx5/qp.c                 |  42 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c | 139 ++++++++++-
>  include/linux/mlx5/device.h                     |  26 ++
>  include/linux/mlx5/driver.h                     |   7 -
>  include/linux/mlx5/mlx5_ifc.h                   |  10 +-
>  include/linux/mlx5/qp.h                         |  21 +-
>  include/linux/mlx5/vport.h                      |   8 +
>  11 files changed, 578 insertions(+), 57 deletions(-)
>=20

This series doesn't apply to my tree even after the GID table lock
series and the RoCEv2-V3 series.  I'm guessing you have some other mlx5
specific series in your tree?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--s1vLF1DUWB2Bu7NvtHITXKakuKdUP4WCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesbDAAoJELgmozMOVy/dPv4P/1nJ6nSfKfjixnlO66yaovPq
t92Uc3SgJdNGFNCWxjk7xd9Eex+I5qvEH/e4Rsj/26la0HcmzNqVvwHwSoAcdAHT
1I5/Phgzrv+6ZoIxuUkC+kmY39lyRRdaMYCrh+dyjJUPwBKTe8BJrRTB1Lr+W8Dk
2yGPygKijNe0BgCeYBK96164ryQgeCLeX4DRSZNONPtXOfzWJvB7YmPYefL9QUYU
oTWQb3+MVLHcJh6pllumQOHygsKum0meyfFQBITJJcuCuNO6b/aH6WgKeh2b2hn+
UzeiMDxrisam9dxgihUHnM8y4P/dqoW1w2tJ+Lk+xXGhRik86TvYyQ+uxThZfUem
P3NI1/SGIdyJc58aphQyOt2ixW0NJaeTEGIgQo0fTVgGamqV4aG/pfzTBtCgf8Ql
zfOffeUemvPI+eNaQWs9LbRnRnLw2WCt3fMk8K9XGaShAnvNeCw8Be7wSZYetQQV
bGlB8PSIFFx90WatGZpOMJBtmcn8gG+dBwmTaO1DYhhJUlFrbK3d/1F02E0c4WO0
dphx4nuuemjcss2gwlxEmNQgFkk8kKWERudtvGaV8I4H/Z4oldxuOpUvMH1QxPQC
Dcz+WkCz2fUmxXaETCaO5luNH6LczK08uLf7ZIF4pv9wT0YLnt1tdmcQPIw/oy6S
9nAJw8eYNNeEskD7U2Hv
=4O6K
-----END PGP SIGNATURE-----

--s1vLF1DUWB2Bu7NvtHITXKakuKdUP4WCn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
