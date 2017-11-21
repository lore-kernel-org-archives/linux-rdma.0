From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] i40iw: Change accelerated flag to bool
Date: Tue, 21 Nov 2017 21:06:05 +0200
Message-ID: <20171121190604.GA24195@yuvallap>
References: <20171121185234.13752-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121185234.13752-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 12:52:34PM -0600, Henry Orosco wrote:
> The accelerated flag only utilizes two values: 0 and 1.
> Modify accelerated flag in struct i40iw_cm_node to bool.

Can you also take care of the exact same thing in nes driver on the same
patch-set?

Besides that

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> 
> NOTE: This patch is dependent on the following patch.
>   "i40iw: Notify user of established connection after QP in RTS"
> 
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
>  drivers/infiniband/hw/i40iw/i40iw_cm.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index a2b242d..f41a302 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -3691,7 +3691,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>  	cm_node->qhash_set = false;
>  	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
>  
> -	cm_node->accelerated = 1;
> +	cm_node->accelerated = true;
>  	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_ESTABLISHED, 0);
>  	if (status)
>  		i40iw_debug(dev, I40IW_DEBUG_CM, "error sending cm event - ESTABLISHED\n");
> @@ -4056,7 +4056,7 @@ static void i40iw_cm_event_connected(struct i40iw_cm_event *event)
>  	cm_node->qhash_set = false;
>  	i40iw_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
>  
> -	cm_node->accelerated = 1;
> +	cm_node->accelerated = true;
>  	status = i40iw_send_cm_event(cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY, 0);
>  	if (status)
>  		i40iw_debug(dev, I40IW_DEBUG_CM, "error sending cm event - CONNECT_REPLY\n");
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
> index 0d5840d..e09b1f5 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
> @@ -337,7 +337,7 @@ struct i40iw_cm_node {
>  	u16     mpav2_ird_ord;
>  	struct iw_cm_id *cm_id;
>  	struct list_head list;
> -	int accelerated;
> +	bool accelerated;
>  	struct i40iw_cm_listener *listener;
>  	int apbvt_set;
>  	int accept_pend;
> -- 
> 2.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
