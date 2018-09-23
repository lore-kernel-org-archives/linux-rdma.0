From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net/mlx4: Use cpumask_available for eq->affinity_mask
Date: Sun, 23 Sep 2018 10:52:02 +0300
Message-ID: <70856b54-cb69-d105-d14c-4b0fd7741b21@mellanox.com>
References: <20180921094412.15547-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921094412.15547-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 21/09/2018 12:44 PM, Nathan Chancellor wrote:
> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context:
> 
> drivers/net/ethernet/mellanox/mlx4/eq.c:243:11: warning: address of
> array 'eq->affinity_mask' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>          if (!eq->affinity_mask || cpumask_empty(eq->affinity_mask))
>              ~~~~~^~~~~~~~~~~~~
> 1 warning generated.
> 
> Use cpumask_available, introduced in commit f7e30f01a9e2 ("cpumask: Add
> helper cpumask_available()"), which does the proper checking and avoids
> this warning.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/86
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/eq.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
> index 1f3372c1802e..2df92dbd38e1 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
> @@ -240,7 +240,8 @@ static void mlx4_set_eq_affinity_hint(struct mlx4_priv *priv, int vec)
>   	struct mlx4_dev *dev = &priv->dev;
>   	struct mlx4_eq *eq = &priv->eq_table.eq[vec];
>   
> -	if (!eq->affinity_mask || cpumask_empty(eq->affinity_mask))
> +	if (!cpumask_available(eq->affinity_mask) ||
> +	    cpumask_empty(eq->affinity_mask))
>   		return;
>   
>   	hint_err = irq_set_affinity_hint(eq->irq, eq->affinity_mask);
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Thanks.
