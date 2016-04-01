From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Expose correct max_sge_rd limit
Date: Fri, 1 Apr 2016 03:04:26 +0300
Message-ID: <20160401000426.GF2670@leon.nu>
References: <1459440205-25208-1-git-send-email-sagig@grimberg.me>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459440205-25208-1-git-send-email-sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 31, 2016 at 07:03:25PM +0300, Sagi Grimberg wrote:
> mlx5 devices (Connect-IB, ConnectX-4, ConnectX-4-LX) has a limitation
> where rdma read work queue entries cannot exceed 512 bytes.
> A rdma_read wqe needs to fit in 512 bytes:
> - wqe control segment (16 bytes)
> - rdma segment (16 bytes)
> - scatter elements (16 bytes each)
> 
> So max_sge_rd should be: (512 - 16 - 16) / 16 = 30.
> 
> Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Tested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Thanks Sagi,

Excellent catch, the same as in commit: a5e4ba334e2
("mlx4: Expose correct max_sge_rd limit")

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/hw/mlx5/main.c |  2 +-
>  include/linux/mlx5/device.h       | 11 +++++++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 03c418ccbc98..ed9cefa1f6f1 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -517,7 +517,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>  		     sizeof(struct mlx5_wqe_ctrl_seg)) /
>  		     sizeof(struct mlx5_wqe_data_seg);
>  	props->max_sge = min(max_rq_sg, max_sq_sg);
> -	props->max_sge_rd = props->max_sge;
> +	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
>  	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
>  	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
>  	props->max_mr		   = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> index 987764afa65c..f8b83792939b 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -363,6 +363,17 @@ enum {
>  	MLX5_CAP_OFF_CMDIF_CSUM		= 46,
>  };
>  
> +enum {
> +	/*
> +	 * Max wqe size for rdma read is 512 bytes, so this
> +	 * limits our max_sge_rd as the wqe needs to fit:
> +	 * - ctrl segment (16 bytes)
> +	 * - rdma segment (16 bytes)
> +	 * - scatter elements (16 bytes each)
> +	 */
> +	MLX5_MAX_SGE_RD	= (512 - 16 - 16) / 16
> +};
> +
>  struct mlx5_inbox_hdr {
>  	__be16		opcode;
>  	u8		rsvd[4];
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
