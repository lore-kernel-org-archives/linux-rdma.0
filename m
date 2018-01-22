From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] RDMA/cma: Check existence of netdevice
 during port validation
Date: Mon, 22 Jan 2018 11:48:07 -0700
Message-ID: <20180122184807.GN14358@mellanox.com>
References: <20180109135859.7676-1-leon@kernel.org>
 <20180109135859.7676-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109135859.7676-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 03:58:54PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> If valid netdevice is not found for RoCE, GID table should not be
> searched with NULL netdevice.
> 
> Fixes: abae1b71dd37 ("IB/cma: cma_validate_port should verify the port and netdevice")
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/core/cma.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 169d3a3bbf71..683428cffd54 100644
> +++ b/drivers/infiniband/core/cma.c
> @@ -624,11 +624,13 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
>  	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
>  		return ret;
>  
> -	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
> +	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port)) {
>  		ndev = dev_get_by_index(&init_net, bound_if_index);

Why are we using indexes as a long term handle to netdevs? Is there
some reason for this you know of?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
