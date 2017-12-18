From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] nes: Change accelerated flag to bool
Date: Mon, 18 Dec 2017 10:20:37 +0200
Message-ID: <20171218082036.GA2632@yuvallap>
References: <20171217182139.17096-1-shiraz.saleem@intel.com>
 <20171217182139.17096-2-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171217182139.17096-2-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 17, 2017 at 12:21:38PM -0600, Shiraz Saleem wrote:
> The accelerated flag only utilizes two values: 0 and 1.
> Modify accelerated flag in struct nes_cm_node to bool.
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/nes/nes_cm.c | 2 +-
>  drivers/infiniband/hw/nes/nes_cm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
> index c56ca2a..6cdfbf8 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -1365,7 +1365,7 @@ static int mini_cm_del_listen(struct nes_cm_core *cm_core,
>  static inline int mini_cm_accelerated(struct nes_cm_core *cm_core,
>  				      struct nes_cm_node *cm_node)
>  {
> -	cm_node->accelerated = 1;
> +	cm_node->accelerated = true;
>  
>  	if (cm_node->accept_pend) {
>  		BUG_ON(!cm_node->listener);
> diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
> index d827d03..d462797 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.h
> +++ b/drivers/infiniband/hw/nes/nes_cm.h
> @@ -341,7 +341,7 @@ struct nes_cm_node {
>  	u16                       mpa_frame_size;
>  	struct iw_cm_id           *cm_id;
>  	struct list_head          list;
> -	int                       accelerated;
> +	bool                      accelerated;
>  	struct nes_cm_listener    *listener;
>  	enum nes_cm_conn_type     conn_type;
>  	struct nes_vnic           *nesvnic;
> -- 

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

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
