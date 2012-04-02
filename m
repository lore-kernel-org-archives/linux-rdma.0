From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 02 Apr 2012 12:35:36 -0400
Message-ID: <4F79D558.1000908@dev.mellanox.co.il>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333377921-8349-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 10:45 AM, Or Gerlitz wrote:
> When the IB port is down, the active_speed value returned by the MAD_IFC
> command equals seven (7) which isn't among the IB speeds defined by the
> ib_port_speed enum. This results in invalid speed value seen by higher
> layers or applications who do port query. Fix that by setting the speed
> to be SDR - the lowest possible when the port is down.
> ---
>  drivers/infiniband/hw/mlx4/main.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 75d3056..b727094 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -253,6 +253,10 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
>  		if (out_mad->data[15] & 0x1)
>  			props->active_speed = IB_SPEED_FDR10;
>  	}
> +
> +	/* avoid wrong speed value returned by FW if the IB link is down */
> +	if (props->state == IB_PORT_DOWN)
> +		 props->active_speed = IB_SPEED_SDR;

Rather than always overwriting active_speed in this case, wouldn't it be
better to only do that for invalid values ?

-- Hal

>  out:
>  	kfree(in_mad);
>  	kfree(out_mad);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
