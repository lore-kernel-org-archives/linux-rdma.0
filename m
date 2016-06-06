From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-rc 1/7] IB/core: Fix query port failure in RoCE
Date: Mon, 6 Jun 2016 10:43:24 -0500
Message-ID: <018701d1c00a$29507640$7bf162c0$@opengridcomputing.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org> <1465042524-25852-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Eli Cohen' <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Currently ib_query_port always attempts to to read the subnet prefix by
> calling ib_query_gid(). For RoCE there is no subnet manager and no
> subnet prefix. Fix this by querying GID[0] only for IB networks.
> 
> Fixes: fad61ad4e755 ('IB/core: Add subnet prefix to port info')
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c
b/drivers/infiniband/core/device.c
> index 5516fb0..05e25a3 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -661,6 +661,9 @@ int ib_query_port(struct ib_device *device,
>  	if (err || port_attr->subnet_prefix)
>  		return err;
> 
> +	if (rdma_port_get_link_layer(device, port_num) !=
> IB_LINK_LAYER_INFINIBAND)
> +		return 0;
> +
>  	err = ib_query_gid(device, port_num, 0, &gid, NULL);
>  	if (err)
>  		return err;

This change assumes IB_LINK_LAYER_ETHERNET == RoCE, which isn't true for iWARP
devices.  Still, the change is good for iWARP too, but the comment should
perhaps reflect this.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
