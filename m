From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Tue, 22 Dec 2015 08:44:36 +0200
Message-ID: <5678F154.1040608@mellanox.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450710084-22547-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/2015 5:01 PM, Matan Barak wrote:
> Previously, cma_match_net_dev called cma_protocol_roce which
> tried to verify that the IB device uses RoCE protocol. However,
> if rdma_id didn't have a bounded port, it used the first port
> of the device.

maybe prefer a higher then code speak language e.g "if the rdma id 
didn't have"  also below "unbounded rdma ids"

>
> In VPI systems, the first port might be an IB port while the second
> one could be an Ethernet port. This made requests for unbounded rdma_ids
> that come from the Ethernet port fail.

add "to" --> "Ethernet port to fail"

> Fixing this by passing the port of the request and checking this port
> of the device.

OK, so this fix will work for both ib/eth and eth/ib configs, right? good.


>
> Fixes: b8cab5dab15f ('IB/cma: Accept connection without a valid netdev on RoCE')

Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Doug, the bug fixes a commit from from 4.3, lets fix it in 4.4 and later 
we will send it to -stable as well. So for 4.4 there's this one and the 
kvfree fix [1]

Or.

[1] https://patchwork.kernel.org/patch/7868481/


> ---
> Hi Doug,
>
> This patch fixes a bug in VPI systems, where the first port is configured
> as IB and the second one is configured as Ethernet.
> In this case, if the rdma_id isn't bounded to a port, cma_match_net_dev
> will try to verify that the first port is a RoCE port and fail.
> This is fixed by passing the port of the incoming request.
>
> Regards,
> Matan
>
>   drivers/infiniband/core/cma.c |   16 +++++++++-------
>   1 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index d2d5d00..c8a265c 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1265,15 +1265,17 @@ static bool cma_protocol_roce(const struct rdma_cm_id *id)
>   	return cma_protocol_roce_dev_port(device, port_num);
>   }
>   
> -static bool cma_match_net_dev(const struct rdma_id_private *id_priv,
> -			      const struct net_device *net_dev)
> +static bool cma_match_net_dev(const struct rdma_cm_id *id,
> +			      const struct net_device *net_dev,
> +			      u8 port_num)
>   {
> -	const struct rdma_addr *addr = &id_priv->id.route.addr;
> +	const struct rdma_addr *addr = &id->route.addr;
>   
>   	if (!net_dev)
>   		/* This request is an AF_IB request or a RoCE request */
> -		return addr->src_addr.ss_family == AF_IB ||
> -		       cma_protocol_roce(&id_priv->id);
> +		return (!id->port_num || id->port_num == port_num) &&
> +		       (addr->src_addr.ss_family == AF_IB ||
> +			cma_protocol_roce_dev_port(id->device, port_num));
>   
>   	return !addr->dev_addr.bound_dev_if ||
>   	       (net_eq(dev_net(net_dev), addr->dev_addr.net) &&
> @@ -1295,13 +1297,13 @@ static struct rdma_id_private *cma_find_listener(
>   	hlist_for_each_entry(id_priv, &bind_list->owners, node) {
>   		if (cma_match_private_data(id_priv, ib_event->private_data)) {
>   			if (id_priv->id.device == cm_id->device &&
> -			    cma_match_net_dev(id_priv, net_dev))
> +			    cma_match_net_dev(&id_priv->id, net_dev, req->port))
>   				return id_priv;
>   			list_for_each_entry(id_priv_dev,
>   					    &id_priv->listen_list,
>   					    listen_list) {
>   				if (id_priv_dev->id.device == cm_id->device &&
> -				    cma_match_net_dev(id_priv_dev, net_dev))
> +				    cma_match_net_dev(&id_priv_dev->id, net_dev, req->port))
>   					return id_priv_dev;
>   			}
>   		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
