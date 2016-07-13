From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next] IB/mlx5: Fix port counter ID association to QP
 offset
Date: Wed, 13 Jul 2016 14:09:51 +0000
Message-ID: <VI1PR05MB1391222EBF9C51484716FC6AD2310@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1468416311-25643-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468416311-25643-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Wednesday, July 13, 2016 4:25 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH for-next] IB/mlx5: Fix port counter ID association to QP
> offset
> 
> From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The q-counter-id is given in modify-QP command associates
> the QP with the counter. The offset to which the counter
> ID was set is incorrect, causing IB port counters not to
> count on QP.
> 
> Fixes: 0837e86a7a34 ('IB/mlx5: Add per port counters')
> Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c
> index 5ca14a2..40b2045 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2657,7 +2657,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
>  		struct mlx5_ib_port *mibport = &dev->port[port_num];
> 
>  		context->qp_counter_set_usr_page |=
> -			cpu_to_be32(mibport->q_cnt_id << 16);
> +			cpu_to_be32((u32)(mibport->q_cnt_id) << 24);
>  	}
> 
>  	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state ==
> IB_QPS_INIT)
> --
> 2.1.4
> 
> --

Alex thank for noticing and fixing this.

Tested-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
