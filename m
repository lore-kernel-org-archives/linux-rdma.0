From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/iblinkinfo.c: Changes for extended
 link speeds
Date: Thu, 18 Aug 2011 11:23:07 -0700
Message-ID: <20110818112307.de2cc478.weiny2@llnl.gov>
References: <4E4A4657.7060705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4A4657.7060705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 16 Aug 2011 03:28:39 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

thanks applied,
Ira

> ---
> diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
> index c07d33e..b282d07 100644
> --- a/src/iblinkinfo.c
> +++ b/src/iblinkinfo.c
> @@ -92,6 +92,8 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
>  {
>  	char buf[64];
>  	uint32_t max_speed = 0;
> +	uint32_t cap_mask, rem_cap_mask;
> +	uint8_t *info;
>  
>  	uint32_t max_width = get_max(mad_get_field(port->info, 0,
>  						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
> @@ -105,6 +107,21 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
>  			 mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F,
>  				      buf, 64, &max_width));
>  
> +	if (port->node->type == IB_NODE_SWITCH)
> +		info = (uint8_t *)&port->node->ports[0]->info;
> +	else
> +		info = (uint8_t *)&port->info;
> +	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> +
> +	if (port->remoteport->node->type == IB_NODE_SWITCH)
> +		info = (uint8_t *)&port->remoteport->node->ports[0]->info;
> +	else
> +		info = (uint8_t *)&port->remoteport->info;
> +	rem_cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> +	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
> +	    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +		goto check_ext_speed;
> +check_speed_supp:
>  	max_speed = get_max(mad_get_field(port->info, 0,
>  					  IB_PORT_LINK_SPEED_SUPPORTED_F)
>  			    & mad_get_field(port->remoteport->info, 0,
> @@ -116,6 +133,25 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
>  		snprintf(speed_msg, msg_size, "Could be %s",
>  			 mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F,
>  				      buf, 64, &max_speed));
> +	return;
> +
> +check_ext_speed:
> +	if (mad_get_field(port->info, 0,
> +			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0 ||
> +	    mad_get_field(port->remoteport->info, 0,
> +			  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F) == 0)
> +		goto check_speed_supp;
> +	max_speed = get_max(mad_get_field(port->info, 0,
> +					  IB_PORT_LINK_SPEED_EXT_SUPPORTED_F)
> +			    & mad_get_field(port->remoteport->info, 0,
> +					    IB_PORT_LINK_SPEED_EXT_SUPPORTED_F));
> +	if ((max_speed & mad_get_field(port->info, 0,
> +				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F)) == 0)
> +		// we are not at the max supported extended speed
> +		// print what we could be at.
> +		snprintf(speed_msg, msg_size, "Could be %s",
> +			 mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +				      buf, 64, &max_speed));
>  }
>  
>  int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
> @@ -151,14 +187,27 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
>  	char width_msg[256];
>  	char speed_msg[256];
>  	char ext_port_str[256];
> -	int iwidth, ispeed, istate, iphystate;
> +	int iwidth, ispeed, espeed, istate, iphystate, cap_mask;
>  	int n = 0;
> +	uint8_t *info;
>  
>  	if (!port)
>  		return;
>  
>  	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
>  	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
> +
> +	if (port->node->type == IB_NODE_SWITCH)
> +		info = (uint8_t *)&port->node->ports[0]->info;
> +	else
> +		info = (uint8_t *)&port->info;
> +	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> +	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +		espeed = mad_get_field(port->info, 0,
> +				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
> +	else
> +		espeed = 0;
> +
>  	istate = mad_get_field(port->info, 0, IB_PORT_STATE_F);
>  	iphystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
>  
> @@ -180,8 +229,11 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
>  		n = snprintf(link_str, 256, "(%3s %9s %6s/%8s)",
>  		     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64,
>  				  &iwidth),
> -		     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
> -				  &ispeed),
> +		     (ispeed != 4 || !espeed) ?
> +			mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64,
> +				     &ispeed) :
> +			mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64,
> +				     &espeed),
>  		     mad_dump_val(IB_PORT_STATE_F, state, 64, &istate),
>  		     mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64,
>  				  &iphystate));


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
