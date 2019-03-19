From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] net: mlx5: Add a missing check on idr_find
Date: Tue, 19 Mar 2019 08:14:31 +0200
Message-ID: <20190319061431.GL4823@mtr-leonro.mtl.com>
References: <20190318221924.7034-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190318221924.7034-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>, Boris Pismeny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 18, 2019 at 05:18:51PM -0500, Aditya Pakki wrote:
> idr_find() can return a NULL value to 'flow' which is used without a check.
> The patch adds a check to avoid potential NULL pointer dereference.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> index 5cf5f2a9d51f..3df468acdffc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> @@ -226,6 +226,8 @@ int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
>  	rcu_read_lock();
>  	flow = idr_find(&mdev->fpga->tls->rx_idr, ntohl(handle));
>  	rcu_read_unlock();
> +	if (!flow)
> +		return -EINVAL;

It is wrong and whole function is wrong too.
In such case, you will leak "buf" allocated above.

The function mlx5_fpga_sbu_conn_sendmsg() which is used below can fail
and it will leave "buf" unfreed too.

Thanks


>  	mlx5_fpga_tls_flow_to_cmd(flow, cmd);
>
>  	MLX5_SET(tls_cmd, cmd, swid, ntohl(handle));
> --
> 2.17.1
>

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJckIjHAAoJEORje4g2clin+iIQAI6aublc3HGEI5E/b4t52jAG
pQTUj1oD9JEMzwc3LxmjuVVF3Lmmj9iRbY7Svq7Q9eMVIe3L8z5Wo2AMcgwN1jJL
IX3Ap9IPwnV35qj9jeFGfb/EyiuEvu4HbeBLQL+DsyYGhJzl1WOgAF0Qr6GLpfma
95f4+ySbbPRU/cH8vu13asGGPqJvkqKYiSyTAzxUlZTivl1Xjoe3zC+Cwh3aFxr/
UahAJN1qZX/7IBJ8qSq9D5iHoJt+ODwmdEQm2HYppeUC+nFuWOmXh/UylDw9JPDh
5ZLh4aZxqViggE0jRQY/LzhBGLgb4v+8/A1B4Mmtv6NbE7nKnWvsQpd7exvA+a84
PPrvLP7PY7oWdEiN6hl2SRHjN/Jx5FniD6zJcLmxumk7vEHlut6sodFGCsxohExZ
E/HbIXLLIfoUuW/RBUEDHmDI9KLMM+a1tZ/tTWbr+5jAe+9poIhLZ/iXZj02CUNE
ZS0nsfkebg7hj7fGICnYD4TaAWvvyIDfhtarJ3zP0xYTNK93S+KEpUBCuqAD9C58
hFpUX2swbdzAfNmfraXm2uQo8kQQ5l65vjKZZkiFftJGBl8C4vNgh5kWOQg3pgAU
GqNrDVHaTJ/xY2s3g7iM+oOZ3RPPTVEkBvr5Ibhkabrdl9FGL+THiKQ+JN/AYmc5
nhzqw5UciZW82vo7fja1
=nczu
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
