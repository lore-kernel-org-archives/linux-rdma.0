From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] Mellanox ConnectX-3 Diagnostic Counters
Date: Wed, 20 Jul 2016 13:22:17 +0300
Message-ID: <20160720102217.GT20674@leon.nu>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="15k5Fuw+yLfT1d9X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468950898-9674-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--15k5Fuw+yLfT1d9X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2016 at 08:54:55PM +0300, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This patch series adds diagnostic hardware counters for Mellanox
> ConnectX-3 which uses the dynamic IB counters infrastructure.
>=20
> This series includes three patches, the first two add the necessary
> functions to read the counters from the firmware and check for
> firmware capability. The third patch exposes the functions needed
> for the counter infrastructure.
>=20
> The counters exposed are applicable for IB and RoCE.

Hi Doug,
Please drop this patch series because we want to update patch #1 to
eliminate future conflict in include/linux/mlx4/device.h file between
net and RDMA subsystems.

Thanks

>=20
> Mark Bloch (3):
>   net/mlx4: Add diagnostic counters capability bit
>   net/mlx4: Query performance and diagnostics counters
>   IB/mlx4: Add diagnostic hardware counters
>=20
>  drivers/infiniband/hw/mlx4/main.c       | 198 ++++++++++++++++++++++++++=
+++++-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   9 ++
>  drivers/net/ethernet/mellanox/mlx4/fw.c |  40 +++++++
>  include/linux/mlx4/device.h             |   7 ++
>  4 files changed, 253 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--15k5Fuw+yLfT1d9X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXj1DZAAoJEORje4g2clin7dMQALyVXjjuHRTYHiXvZ+um/5ig
ZnEMOnhhzS9WCBDYzlnc0IhHsWE2iOjKlhxI5l52mMAceGZqHQ2yiB7NInBTi+3E
sDcxz7h+dQ4bVffTCRmE5TePWAbr/+hU9DoirDvsBQONY7jg+z87QEeIHdxtKatd
1UimRx5sub+lwHdCk/WbG+3FOA5IVuKCa5lWlOHu1pd3XlotOOvKqmhg11HgSCnC
NRLVcC+q2eF9LK9JaKf/PPYT78sKCTz+cieaAPr0KObyxg6pobEKA+XQbnJjTXBm
jq0bfLxNdXDahQOiIy8hyd7qqMHYGbCs10EvRE+JCmjp4E2oYIOz26OuQPsOKnGv
8ZIZOuwgHJ99yN6LQTq1K7rl+FSpc/qxhU6hP1TIiT3P6tlvhWk+VFez0QknjKTp
HlVIUJRAoHFB2ddgL4gpxrIZUmpZc453PIc9FY4HTaI+WjgDgrCCEfjVsU2DRYPK
lEW1Qxy7D5Zk5/kOXxY2+WuKjVaxGNU8ZYMRkpT2kc69KSWx9QWrdZbZ9TAZqdMX
Yj5zNyjZOfh+zmKE8abugh4XmrzYo97mZyQKY+jq8eW+EOSuoDxsUu4HqyHeRcsz
6SRFQbASczLHbXxs+Y70DuAlGXNknI1+dEkXHXp46gSM81hNvBrAzK7W6yvrpJaf
3yx0OXPHKPSzGYfMrUZh
=vHyf
-----END PGP SIGNATURE-----

--15k5Fuw+yLfT1d9X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
