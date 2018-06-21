From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add RoCE RX ICRC encapsulated
 counter
Date: Thu, 21 Jun 2018 20:53:17 +0300
Message-ID: <20180621175317.GM17747@mtr-leonro.mtl.com>
References: <20180621123756.32645-1-leon@kernel.org>
 <20180621123756.32645-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180621123756.32645-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Talat Batheesh <talatb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2018 at 03:37:55PM +0300, Leon Romanovsky wrote:
> From: Talat Batheesh <talatb@mellanox.com>
>
> Add capability bit in PCAM register and RoCE ICRC error counter
> to PPCNT register.
>
> Signed-off-by: Talat Batheesh <talatb@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index b4302ccb63a6..9e8682489951 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -1687,7 +1687,11 @@ struct mlx5_ifc_eth_extended_cntrs_grp_data_layout_bits {
>
>  	u8         rx_buffer_full_low[0x20];
>
> -	u8         reserved_at_1c0[0x600];
> +	u8         rx_icrc_encapsulated_high[0x20];
> +
> +	u8         rx_icrc_encapsulated_low[0x20];
> +
> +	u8         reserved_at_3c0[0x5c0];

reserved_at_3c0 should be reserved_at_200, fixed and applied to mlx5-next.

Commit 0af5107cd0640ee3424e337b492e4b11b450ce28 in mlx5-next.

Thanks

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbK+YNAAoJEORje4g2clin9eMP/iLWa+QdGldrPeTBqsKbXFvw
vu9oiOZ22PIaTllTb2dSwgtCBfcLBqra5IZCfHIT7HFqvkZ+XVlaF4rvzYFfy7dr
eo4ReOr792Z462qCq317LyNehOBhYrow/v+OtZYkCHLkOr2l6BxeFzG+Fldip+Ec
IFs8H+h+ZfuQyV5Hqw4iaWs9elIEDNsbAVTpydwqz+lVhJNykHOWPPz20hZqOtOG
3QHkiy5Vu/I9Zd5lFZNzzo3/9T05XflwEH/blF55RmBxdgipp9kT25xDeRouMubB
VPbwHZZ1H6Um1u1NJyeMX0A8RWOjoz6ijNoOWoFmIM4L+tP8oU2QASfPVxExnDbT
XyIOs6Bp7Cz/QpD1gQwggSMxH1C+UPcCiL+a76JMqdCELViUSnQnGSLM3gJcZm4W
rzvbVEBgdPgCabSBSDv7J4o4qmBw25pAIA7dtE98BLtN+4YBihV+zqS2T/SquLXH
KpCC3Y6XT6j/rOxEyI4Cg3U8mIwYv0GvPDciw/ynetH1DKZNzyTWami54A8YnQnT
XrCu3/wA+0bEZ8OylTwbwO7xVOkHUgLotbB4D6ef/agOtX8PiM8rNTobCY6KuWep
ovSnrbyFSESYOnkob9/O5B0v3wB39eRvFz5lQexFFK/G60Gvl2Em+YThR7AkQHd/
5F59x46zWcT5kzH5b7j5
=Oq5q
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
