From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] mlx5: Remove a set-but-not-used variable
Date: Tue, 6 Dec 2016 16:24:41 +0200
Message-ID: <20161206142441.GA3437@mtr-leonro.local>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <f1351e2c-915d-9883-838b-d3c50f27da17@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f1351e2c-915d-9883-838b-d3c50f27da17-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 05, 2016 at 05:18:27PM -0800, Bart Van Assche wrote:
> This has been detected by building the mlx5 driver with W=1.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks,
Fixes: 1a412fb1caa2 ('net/mlx5: Fixes: 1a412fb1caa2 (IB/mlx5: Modify QP commands via mlx5 ifc')
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


> ---
>  drivers/infiniband/hw/mlx5/qp.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index d1e921816bfe..b2c6c13d44ac 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2577,7 +2577,6 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>  	struct mlx5_ib_port *mibport = NULL;
>  	enum mlx5_qp_state mlx5_cur, mlx5_new;
>  	enum mlx5_qp_optpar optpar;
> -	int sqd_event;
>  	int mlx5_st;
>  	int err;
>  	u16 op;
> @@ -2724,12 +2723,6 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>  	if (qp->rq.wqe_cnt && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
>  		context->db_rec_addr = cpu_to_be64(qp->db.dma);
>  
> -	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
> -	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
> -		sqd_event = 1;
> -	else
> -		sqd_event = 0;
> -
>  	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
>  		u8 port_num = (attr_mask & IB_QP_PORT ? attr->port_num :
>  			       qp->port) - 1;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
