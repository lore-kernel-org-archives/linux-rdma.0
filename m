From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: delete some stray tabs
Date: Fri, 29 Sep 2017 09:26:25 -0500
Message-ID: <20170929142625.GA15568@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170929074943.cs2jea5xttk2r6vm@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929074943.cs2jea5xttk2r6vm@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 29, 2017 at 10:49:43AM +0300, Dan Carpenter wrote:
> These lines were indented too far by mistake.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 5230dd3c938c..9017c1cc51d4 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -1524,8 +1524,8 @@ static bool i40iw_port_in_use(struct i40iw_cm_core *cm_core, u16 port, bool acti
>  				break;
>  			}
>  		}
> -			if (!ret)
> -				clear_bit(port, cm_core->active_side_ports);
> +		if (!ret)
> +			clear_bit(port, cm_core->active_side_ports);
>  		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
>  	} else {
>  		spin_lock_irqsave(&cm_core->listen_list_lock, flags);
> --

Thanks Dan!
Acked-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
