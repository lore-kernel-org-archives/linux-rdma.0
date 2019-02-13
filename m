From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Followup changes to mlx5-next branch
Date: Wed, 13 Feb 2019 17:53:33 +0000
Message-ID: <20190213175331.GK21447@mtr-leonro.mtl.com>
References: <20190211115608.22677-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x1F0m3RQhDZyj8sd"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211115608.22677-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--x1F0m3RQhDZyj8sd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2019 at 01:56:06PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> There are two small cleanups needed after prefetch MR code was merged.
>
> Thanks
>
> Leon Romanovsky (2):
>   net/mlx5: Align ODP capability function with netdev coding style

This patch was applied.

>   net/mlx5: Factor out HCA capabilities functions

This will be resent.
>
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 62 ++++++++++++-------
>  1 file changed, 39 insertions(+), 23 deletions(-)
>
> --
> 2.19.1
>

--x1F0m3RQhDZyj8sd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcZFmbAAoJEORje4g2clin02MP/ROl4l/QQA9/l9fofsEBEp0g
FZx2zQp6RXOou+9pEDM7VezJsC/TWIFKl1cLZUIMySeA7DFXv9YBfzwMIz+ZzRYH
RbEiJko4BVj1Iv0Xv7sBPmTa8JoLr/LEE5A/SHastKokwThuPWXVjZJX2XDqZ/DJ
VvNKkSniC+Obxfyuq0wNs/sDEm2DGnczy7R/R5ZyCQBqsIHVT0Gnpfzn6bmURdtZ
3+VP6XsJLlF7pvzA0U2zz+NTGMe/3pQZV2MEUbyBLXxMUrLNjYe3SxM8aE2i/QLl
0yxXqJuXoosWNqrWSiV9e9EDza5Zw/qh+moBWpRcgQh/B1dvkaINuL5bQTscsRd6
f0iHzUQbfWd+SRdrq+azFH9+WpbuEtcaL/O2WOSvIGljofIqTT8buVs6asi3RSCr
QxCYQ3HY9hSeDwpRPxFOh8wrUY5W+yoAugP4vLtLU8gs42U/n1NCESh+lRvi0OoP
WOBJTSo0XwxBj10wqhyNuh3xzdLiGExYIB9A6yHCpuvmXsyIBokRPfbu27J/WbV3
HkgD9Jt8wQgdoeLrQ+SDMHNEgw2WXB1mFHUAmbpfDkCfVpSMzs4m6236rnG6frXq
TbAlr1H0YKsyYnkFOwTJKVBTSCdry78+sdZTGRoJvpRsB+dV/y7yWxDh7sS61xMi
VGOwnJIwceU0UgmFJJGj
=Ud7U
-----END PGP SIGNATURE-----

--x1F0m3RQhDZyj8sd--
