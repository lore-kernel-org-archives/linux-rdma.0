From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net: ethernet: mlx4: Remove unnecessary parentheses
Date: Sun, 3 Jun 2018 10:15:07 +0300
Message-ID: <afe2c643-ba7d-5bf5-11ce-7e13be1bee4b@mellanox.com>
References: <20180601020049.3704-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601020049.3704-1-rvarsha016@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 01/06/2018 5:00 AM, Varsha Rao wrote:
> This patch fixes the clang warning of extraneous parentheses, with the
> following coccinelle script.
> 
> @@
> identifier i;
> expression e;
> statement s;
> @@
> if (
> -(i == e)
> +i == e
>   )
> s
> 
> Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/port.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
> index 3ef3406ff4cb..10fcc22f4590 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/port.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/port.c
> @@ -614,9 +614,9 @@ int __mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan,
>   		int index_at_dup_port = -1;
>   
>   		for (i = MLX4_VLAN_REGULAR; i < MLX4_MAX_VLAN_NUM; i++) {
> -			if ((vlan == (MLX4_VLAN_MASK & be32_to_cpu(table->entries[i]))))
> +			if (vlan == (MLX4_VLAN_MASK & be32_to_cpu(table->entries[i])))
>   				index_at_port = i;
> -			if ((vlan == (MLX4_VLAN_MASK & be32_to_cpu(dup_table->entries[i]))))
> +			if (vlan == (MLX4_VLAN_MASK & be32_to_cpu(dup_table->entries[i])))
>   				index_at_dup_port = i;
>   		}
>   		/* check that same vlan is not in the tables at different indices */
> 

Acked-by: Tariq Toukan <tariqt@mellanox.com>

Thanks for your patch,
Tariq
