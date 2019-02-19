From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next v1] net/mlx5: Factor out HCA capabilities
 functions
Date: Tue, 19 Feb 2019 12:42:35 +0000
Message-ID: <20190219124224.GP16218@mtr-leonro.mtl.com>
References: <20190217111102.13608-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5uO961YFyoDlzFnP"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217111102.13608-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--5uO961YFyoDlzFnP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 17, 2019 at 01:11:02PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Combine all HCA capabilities setters under one function
> and compile out the ODP related function in case kernel
> was compiled without ODP support.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Changelog v0->v1:
>  * Embedded config option check into ODP capability function flow
> ---
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 46 +++++++++++++------
>  1 file changed, 31 insertions(+), 15 deletions(-)
>

Applied to mlx5-next branch,
37b6bb77c6fd net/mlx5: Factor out HCA capabilities functions

Thanks

--5uO961YFyoDlzFnP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJca/mwAAoJEORje4g2clinkxAP/1sbPcllZmP7RlWzVQAu4uhL
LtaSMTsA8u0bqxevFH0sRPgFnKMbfX/04bfcUnlR7tog0oDA6Ng4iFE566K2xpFt
VaWUxa4jlXeYULBXHMRnQYuj3GmY1fYzmTd4UIUYPW0oE2TMi21hkvhOlYHM8jjY
Lt2O7BtWxZRd4LJ/nwYfWMXoWYWGx89b2elVQsd1tcoIAodcXlFAwceAwVFpu6Nd
/T5hKjjM8d1q+IDPNuYKkeN8LymGr0DsEp/aZyRB4m9EO1XFun79mSFNCRixRdZm
XcmuWfJXHThxTe0QhfAbHpbNNVN4mzkk7O21Odrs5NRreH32i5SWqVn2A7Kgk7H7
c+A/HcfwD2P76rQzA4S16u55mcV4mxSQfmYkIYCu2c9kAE8ZDwSwE92jZY1/aiPq
m9Mxli/AM7Jj1Cpeb5OGitQBpWRhMLXv+C/s107aQiU63DCS1DEt7xj0WzNRrOBH
z/CsylkxG0Envqbb/0L+wP2xD1n6Hj/syF52Sp1d6P+ufbSvr+D+zPmVbTgOzwRx
NyVz14wyGNZ8Av0eZGPm/e1R2fjjPZzQhxPCDydUWyvhAdPFGabvxtlraRId2Ydx
OuHK3fxz5kKNOf2QfZ/l36bIkOSJYLF0onOc6it7um8BVX8NFIstw+xrqV4DlXV/
0NUXfyBc1/c4ARiQLvLq
=+e2H
-----END PGP SIGNATURE-----

--5uO961YFyoDlzFnP--
