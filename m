From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [PATCH] mlx5: qp: variable may be used uninitialized
Date: Wed, 17 Jul 2013 19:06:04 +0300
Message-ID: <20130717160604.GG21894@mtldesk30>
References: <1373981701-15276-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373981701-15276-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Shyti <andi@etezian.org>
Cc: eli@mellanox.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Eli Cohen <eli@mellanox.com>

On Tue, Jul 16, 2013 at 03:35:01PM +0200, Andi Shyti wrote:
> in the sq_overhead() function, if qp_typ is equal to IB_QPT_RC,
> size will be used uninitialized.
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 16ac54c..045f8cd 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -199,7 +199,7 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
>  
>  static int sq_overhead(enum ib_qp_type qp_type)
>  {
> -	int size;
> +	int size = 0;
>  
>  	switch (qp_type) {
>  	case IB_QPT_XRC_INI:
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
