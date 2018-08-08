From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH 24/33] net/mlx5e: Mark expected switch fall-throughs
Date: Wed, 8 Aug 2018 15:26:27 -0700
Message-ID: <CALzJLG-P9mZfF_kauDTd4R09a0Wq4pPvKTbyNt1KA_1654N9_Q@mail.gmail.com>
References: <cover.1533675546.git.gustavo@embeddedor.com> <3c523c58a8e3f3d240d4ff9363d672fb977c9d93.1533675546.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3c523c58a8e3f3d240d4ff9363d672fb977c9d93.1533675546.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "David S. Miller" <davem@davemloft.net>, Linux Netdev List <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 7, 2018 at 4:25 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Addresses-Coverity-ID: 114808 ("Missing break in switch")
> Addresses-Coverity-ID: 114802 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Saeed Mahameed <saeedm@mellanox.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 1881468..ad6d471 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -91,9 +91,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>                 return true;
>         default:
>                 bpf_warn_invalid_xdp_action(act);
> +               /* fall through */
>         case XDP_ABORTED:
>  xdp_abort:
>                 trace_xdp_exception(rq->netdev, prog, act);
> +               /* fall through */
>         case XDP_DROP:
>                 rq->stats->xdp_drop++;
>                 return true;
> --
> 2.7.4
>
