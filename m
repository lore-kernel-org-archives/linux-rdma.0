From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 03/10] IB/core: Add subnet prefix to port
 info
Date: Tue, 8 Mar 2016 10:57:52 -0700
Message-ID: <20160308175752.GD10805@obsidianresearch.com>
References: <1457455018-17638-1-git-send-email-eli@mellanox.com>
 <1457455018-17638-4-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457455018-17638-4-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 06:36:51PM +0200, Eli Cohen wrote:
> The subnet prefix is a part of the port_info MAD returned and should be
> available at the ib_port_attr struct. We define it here and provide a
> default implementation in case the hardware driver does not provide one.
> The subnet prefix is required when creating the address vector to access
> the SA in networks where GRH must be used.
> 
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Changes from V1:
> Removed the hardware level implementation and implement as part of
> ib_query_port.

Looks reasonable

Are you going to still send the mlx4/5 changes to avoid the other
callback?

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

> +++ b/include/rdma/ib_verbs.h
> @@ -509,6 +509,7 @@ struct ib_port_attr {
>  	u8			active_width;
>  	u8			active_speed;
>  	u8                      phys_state;
> +	u64			subnet_prefix;
>  };

This turned out to be aligned then?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
