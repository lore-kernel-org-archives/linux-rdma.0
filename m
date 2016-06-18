From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] ib/rxe: double free on error
Date: Sat, 18 Jun 2016 14:00:03 +0300
Message-ID: <20160618110003.GJ32247@mwanda>
References: <20160618084021.GB21713@mwanda>
 <20160618103430.GC5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160618103430.GC5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 18, 2016 at 01:34:30PM +0300, Leon Romanovsky wrote:
>  drivers/infiniband/hw/rxe/rxe.c | 29 ++++++-----------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rxe/rxe.c
> index 48c41e00..156a1021 100644
> --- a/drivers/infiniband/hw/rxe/rxe.c
> +++ b/drivers/infiniband/hw/rxe/rxe.c
> @@ -165,42 +165,25 @@ static int rxe_init_port_param(struct rxe_port *port)
>   */
>  static int rxe_init_ports(struct rxe_dev *rxe)
>  {
> -	int err;
> -	struct rxe_port *port;
> -
> -	port = &rxe->port;
> +	struct rxe_port *port =  rxe->port;

This won't compile.

Just give me Reported-by credit not authorship.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
