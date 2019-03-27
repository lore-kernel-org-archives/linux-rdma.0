From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Decrease default mr cache size
Date: Wed, 27 Mar 2019 12:07:54 +0200
Message-ID: <CAJ3xEMiMphpkF6B-Ns-+wPcso1Lk=12=jn3ZqLoAB5a-GLfVcw@mail.gmail.com>
References: <20190319092439.10701-1-leon@kernel.org> <20190319092439.10701-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190319092439.10701-4-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 19, 2019 at 11:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> From: Artemy Kovalyov <artemyko@mellanox.com>
>
> Delete initialization of high order entries in mr cache to decrease initial
> memory footprint. When required, the administrator can populate the
> entries with memory keys via the /sys interface.

Please add here:

This approach is very helpful to reduce the per HW function memory
footprint in environments such as VMs. Before the patch we see
consumption of 0.9GB per function and after the patch about 0.1GB

> Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Reported-by:  Shalom Toledo <shalomt@mellanox.com>
Acked-by: Or Gerlitz <ogerlitz@mellanox.com>

Lets push it into stable kernels, a Fixes tag here will cause that
to happen more easily, so please consider that.

> ---
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 20 -------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 70cc906a102b..76716419370d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -164,26 +164,6 @@ static struct mlx5_profile profile[] = {
>                         .size   = 8,
>                         .limit  = 4
>                 },
> -               .mr_cache[16]   = {
> -                       .size   = 8,
> -                       .limit  = 4
> -               },
> -               .mr_cache[17]   = {
> -                       .size   = 8,
> -                       .limit  = 4
> -               },
> -               .mr_cache[18]   = {
> -                       .size   = 8,
> -                       .limit  = 4
> -               },
> -               .mr_cache[19]   = {
> -                       .size   = 4,
> -                       .limit  = 2
> -               },
> -               .mr_cache[20]   = {
> -                       .size   = 4,
> -                       .limit  = 2
> -               },
>         },
>  };
>
> --
> 2.20.1
>
