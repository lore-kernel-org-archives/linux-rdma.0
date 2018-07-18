From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH net-next] net/mlx5: fix an unused-function warning
Date: Tue, 17 Jul 2018 17:42:25 -0700
Message-ID: <CALzJLG_r5pkBWGvyE+e7PVtPOnLnXS8oee_ka+=UEAkbqDP-Kg@mail.gmail.com>
References: <20180717135009.3584984-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717135009.3584984-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 17, 2018 at 6:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> These dummy helpers are all intended to be inline functions,
> but one of them by accident came without the 'inline' keyword,
> causing a harmless warning:
>
> In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:63:
> drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h:79:1: error: 'mlx5_accel_tls_add_flow' defined but not used [-Werror=unused-function]
>  mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
>
> Fixes: ab412e1dd7db ("net/mlx5: Accel, add TLS rx offload routines")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Saeed Mahameed <saeedm@mellanox.com>

Dave, you can take this one to net-next.

Thanks!

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
> index 2228c1083528..def4093ebfae 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
> @@ -75,7 +75,7 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev);
>
>  #else
>
> -static int
> +static inline int
>  mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
>                         struct tls_crypto_info *crypto_info,
>                         u32 start_offload_tcp_sn, u32 *p_swid,
> --
> 2.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
