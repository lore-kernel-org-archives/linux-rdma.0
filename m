From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibportstate.c: Fix PortInfo sets with
 extended speeds
Date: Fri, 4 Jan 2013 15:38:34 -0800
Message-ID: <20130104153834.2d89ffbd2083dc86541610fb@llnl.gov>
References: <50CB3382.6060106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB3382.6060106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 14 Dec 2012 09:11:14 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Attribute Modifier bit 31 should be on (set to 1) in this case
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied, thanks,
Ira

> ---
> diff --git a/src/ibportstate.c b/src/ibportstate.c
> index 1d8dc81..053b0a2 100644
> --- a/src/ibportstate.c
> +++ b/src/ibportstate.c
> @@ -236,7 +236,12 @@ static void show_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
>  static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
>  			  int espeed_cap, int is_switch)
>  {
> -	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
> +	unsigned mod;
> +
> +	mod = portnum;
> +	if (espeed_cap)
> +		mod |= 1<<31;
> +	if (!smp_set_via(data, dest, IB_ATTR_PORT_INFO, mod, 0, srcport))
>  		IBERROR("smp set portinfo failed");
>  
>  	printf("\nAfter PortInfo set:\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
