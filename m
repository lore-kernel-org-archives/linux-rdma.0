From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/3] Add tunnel support
Date: Mon, 4 Dec 2017 06:28:04 +0200
Message-ID: <20171204042804.GB2110@mtr-leonro.local>
References: <1512317017-6223-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512317017-6223-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 03, 2017 at 06:03:34PM +0200, Yishai Hadas wrote:
> Sending V1 to handle few notes from GITHUB, details below.
>
> This series from Maor is the supplementary part of the kernel series that was
> merged into 4.15.
>
> It introduces the following support for tunneling packets:
> 1) RSS on the tunneled packet.
> 2) Tunneling offloads support for mlx5 devices via the DV API.
>
> PR:
> https://github.com/linux-rdma/rdma-core/pull/265
>
> Changes from V0:
> - Moved to use (1UL << 31) for IBV_RX_HASH_INNER as part of the enum.
> - Improved the man page to better describe the inner/outer terms.
> - Sorted the names of the exported symbols from mlx5 that were introduced
>   as part of this V16 release.
>
> Yishai
>
> Maor Gottlieb (3):
>   verbs: Add support in RSS of the inner packet
>   mlx5: Add tunnel offloads support in direct verbs
>   mlx5: Report tunneling offloads capabilities
>
>  debian/ibverbs-providers.symbols         |  1 +
>  libibverbs/man/ibv_create_qp_ex.3        | 20 ++++++++++++
>  libibverbs/verbs.h                       |  3 +-
>  providers/mlx5/libmlx5.map               |  1 +
>  providers/mlx5/man/mlx5dv_query_device.3 | 15 ++++++++-
>  providers/mlx5/mlx5-abi.h                |  5 ++-
>  providers/mlx5/mlx5.c                    |  5 +++
>  providers/mlx5/mlx5.h                    |  1 +
>  providers/mlx5/mlx5dv.h                  | 27 +++++++++++++++-
>  providers/mlx5/verbs.c                   | 53 ++++++++++++++++++++++++++++----
>  10 files changed, 121 insertions(+), 10 deletions(-)
>

Thanks, merged.

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlokztQACgkQ5GN7iDZy
WKfK5g//W2FjYcHdJZhz2XWXWOMv2d/VcbXnL9X1rY8/0wFn59B/CpXzm7dWa72V
2nTAqGm4D2G0muuvbgPRdXSyzImRR3GkxcExzsfBRvPsUfQZEn/aRvheh+Q6YJy3
p1aqESXbQErz/anrD7zjoZhLmahhs80wf9RhEkowwGGPHxI8VPhgfrvm1+yXlq6c
1wlPhi07mzWQjLdz4UyfH7EVtrTBweOtRlSGV1+xrSFPtDPGESKBx8sg7kVIUqWC
XQFgV5Pdt3XwOVKktvhyA+/q1JwGVtgOr71RAkWZbyzQ9J/nW0gkyMqnobmLwmwn
Dcg+mghgdzVU6HSO+5GCESPGpPbGV9FHdgqoeNitbLiRFr9F55PU6LdBCQx8GGev
0GfT7b8asCpoSLmPyMffkcidGZMMaArDGr3DOEghu6S8LOJmGiDCfN7HlvMK4Qgo
PuNQr0U/iPL8mkgYi3sHCYbCUNkMd1A7XFlzl+Gf4wvCYt3Nr3BF8FirBRSgQBz0
y2Litr96TBWS4HChlQN53wu7kYvIL91R2ttzN2gRzSt8iWvtT9SvgiYnlHaqQFYY
HgU1lHFE3flehPmhdLH/Zec4seIAmcsQIBDV/lT6vgzdK6xmkdfKGBouq1N4iz91
0dKBm/XZKm1gKlYBJp1Q04ulwTJQc1fxBO4SQH225jmgW3NlFz8=
=Jor/
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
