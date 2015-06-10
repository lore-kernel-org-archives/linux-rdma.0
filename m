From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't warn on no SA support in event handler
Date: Wed, 10 Jun 2015 12:12:28 +0200
Message-ID: <55780D8C.1070600@profitbricks.com>
References: <1433927612-20517-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433927612-20517-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Moni

On 06/10/2015 11:13 AM, Moni Shoua wrote:
> Registering an event handler is done for a device. This device may have
> one RoCE port (no SA cap) and one InfiniBand port (has SA cap).
> Therefore, warning from the event handler about a specific port that
> doesn't have SA cap is correct but pollutes the kernel log without a
> need.

Maybe we should think about register event handler per port :-P

Regards,
Michael Wang

> 
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/multicast.c | 2 +-
>  drivers/infiniband/core/sa_query.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
> index 605f20a..1244f02 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -780,7 +780,7 @@ static void mcast_event_handler(struct ib_event_handler *handler,
>  	int index;
>  
>  	dev = container_of(handler, struct mcast_device, event_handler);
> -	if (WARN_ON(!rdma_cap_ib_mcast(dev->device, event->element.port_num)))
> +	if (!rdma_cap_ib_mcast(dev->device, event->element.port_num))
>  		return;
>  
>  	index = event->element.port_num - dev->start_port;
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index 7f7c8c9..3d0b7b2 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
>  		struct ib_sa_port *port =
>  			&sa_dev->port[event->element.port_num - sa_dev->start_port];
>  
> -		if (WARN_ON(!rdma_cap_ib_sa(handler->device, port->port_num)))
> +		if (!rdma_cap_ib_sa(handler->device, port->port_num))
>  			return;
>  
>  		spin_lock_irqsave(&port->ah_lock, flags);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
