From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 5/6] net/mlx5: Unexport functions that need not
 be exported
Date: Thu, 9 Aug 2018 07:34:07 +0300
Message-ID: <20180809043407.GC13378@mtr-leonro.mtl.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
 <20180808232353.15514-6-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huG+SbfbdD6eblZQ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180808232353.15514-6-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--huG+SbfbdD6eblZQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 08, 2018 at 04:23:52PM -0700, Saeed Mahameed wrote:
> From: Eli Cohen <eli@mellanox.com>
>
> mlx5_query_vport_state() and mlx5_modify_vport_admin_state() are used
> only from within mlx5_core  - unexport them.
>
> Signed-off-by: Eli Cohen <eli@mellanox.com>
> Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> index 7ec85747c450..702e235962aa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> @@ -62,7 +62,6 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
>
>  	return MLX5_GET(query_vport_state_out, out, state);
>  }
> -EXPORT_SYMBOL_GPL(mlx5_query_vport_state);
>

Hi Saeed,

I see that Dave is already applied it, so my comment is mostly for
future submission. This patch went to a right direction by reducing
export symbol pollution, but left function declarations in globally
visible include/linux/mlx5/vport.h header file.

Such situation leaves the mlx5 driver in limbo state
where mlx5_ib have access to those functions but can't use them.

Care to send followup patch to fix it?

>  int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
>  				  u16 vport, u8 state)
> @@ -80,7 +79,6 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
>
>  	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
>  }
> -EXPORT_SYMBOL_GPL(mlx5_modify_vport_admin_state);
>
>  static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
>  					u32 *out, int outlen)
> --
> 2.17.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--huG+SbfbdD6eblZQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJba8Q/AAoJEORje4g2clin6KEP/3ltrGbXZthM1qlCyCTihIve
qDzrVhlP+Y+RKwG2vWkD4brE46UQPgo6cODppQozh9FqPsa808mIKOYBExrfe3K7
nrGhe0mX9rUbaU3knvaeIqZYWYV39Mc4ipwKQI/uwdStvdYBsP+oN3VwhQoXwkK1
RLZnGqZ24+U9R1fEMdZ3VCwK/grxZfsPjgza3dbGWvovEKEPSgdoFS/yTJsPn9ne
AdjhDhDIk9QK3Oekzwvps93WNyFD4ww9lOfkk6nLTDdStOyxKhPvcME1B8XUHHNg
DlcfYHlkscOq1WznilMFUPzLdK60aqvJ3IHYHlfrikMjP5L4nIdNaNG98YMddvKl
U2atWa3heHup7jtc6Xkz0Pn3uKGJvhhcHANarK25O7Il0t80AJA3Dd0/7GIvbrWw
FgThLC0ROSXVHzbRx2eyskEa0Ftsu9KUAceeKxhd58z6KzQjFuujRDozaCRaRYRU
mjrSkfbm7Dav7ebfac7zzE5LYlrpcmMm43plgCQk4qQYHrlD43IveLx2xLD6SPnn
GXFYVJn/UOP2wpHC4w6M/rcxkWj+6qH68AE0L5v+f945y7f1NM3i9XmxZk+UeQoO
dW7zi5/UL+6mRf5uDe88CMybvpJDBLJaHqZ5308C5fxHG4u9vKfpu0ru/qXPHbSo
tOUdAe4mrELBOHjITNmz
=8UCk
-----END PGP SIGNATURE-----

--huG+SbfbdD6eblZQ--
