From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] IB/mlx5: Fix mkey flag wrong assignment
Date: Thu, 20 Feb 2014 10:47:32 -0800
Message-ID: <1392922052.29525.5.camel@haakon3.risingtidesystems.com>
References: <1392918239-25250-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392918239-25250-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-02-20 at 19:43 +0200, Sagi Grimberg wrote:
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---

Applied + squashed into target-pending/rdma-dif for commit:

  IB/mlx5: Collect signature error completion

--nab

>  drivers/infiniband/hw/mlx5/qp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 22db279..5036a2e 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -1756,7 +1756,6 @@ static __be64 frwr_mkey_mask(void)
>  	result = MLX5_MKEY_MASK_LEN		|
>  		MLX5_MKEY_MASK_PAGE_SIZE	|
>  		MLX5_MKEY_MASK_START_ADDR	|
> -		MLX5_MKEY_MASK_EN_SIGERR	|
>  		MLX5_MKEY_MASK_EN_RINVAL	|
>  		MLX5_MKEY_MASK_KEY		|
>  		MLX5_MKEY_MASK_LR		|
> @@ -1778,6 +1777,7 @@ static __be64 sig_mkey_mask(void)
>  		MLX5_MKEY_MASK_PAGE_SIZE	|
>  		MLX5_MKEY_MASK_START_ADDR	|
>  		MLX5_MKEY_MASK_EN_RINVAL	|
> +		MLX5_MKEY_MASK_EN_SIGERR	|
>  		MLX5_MKEY_MASK_KEY		|
>  		MLX5_MKEY_MASK_LR		|
>  		MLX5_MKEY_MASK_LW		|
