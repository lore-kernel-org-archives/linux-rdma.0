From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net/mlx4_en: Fix an error handling path in
 'mlx4_en_init_netdev()'
Date: Wed, 9 May 2018 13:31:08 +0300
Message-ID: <b4f20eff-ccaf-9a0f-dd49-3522ba13a449@mellanox.com>
References: <20180508093426.11550-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508093426.11550-1-christophe.jaillet@wanadoo.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, davem@davemloft.net, tariqt@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 08/05/2018 12:34 PM, Christophe JAILLET wrote:
> If the 2nd memory allocation of the loop fails, we must undo the
> memory allocation done so far.
> 
> Fixes: 67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index e0adac4a9a19..bf078244e467 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -3331,7 +3331,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
>   		if (!priv->tx_cq[t]) {
>   			kfree(priv->tx_ring[t]);
>   			err = -ENOMEM;
> -			goto out;
> +			goto err_free_tx;
>   		}
>   	}
>   	priv->rx_ring_num = prof->rx_ring_num;
> 
Hi Christophe,

Thanks for re-sending this.

In your previous mail you referred to the call mlx4_en_destroy_netdev here:
https://elixir.bootlin.com/linux/v4.16-rc5/source/drivers/net/ethernet/mellanox/mlx4/en_main.c#L232

While I was referring to the one below, which is always called on failures:

https://elixir.bootlin.com/linux/v4.16-rc5/source/drivers/net/ethernet/mellanox/mlx4/en_netdev.c#L3587

I still believe that the err_free_tx label and its while loop is redundant.

Regards,
Tariq
