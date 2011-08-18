From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/2] infiniband-diags/ibnetdiscover.c: Changes for
 extended link speeds
Date: Thu, 18 Aug 2011 11:23:49 -0700
Message-ID: <20110818112349.c8c50f7a.weiny2@llnl.gov>
References: <4E4A744C.8060008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4A744C.8060008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 16 Aug 2011 06:44:44 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index 59304b6..0966217 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
>   * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
> + * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -99,6 +100,22 @@ char *dump_linkspeed_compat(uint32_t speed)
>  	return ("???");
>  }
>  
> +char *dump_linkspeedext_compat(uint32_t espeed, uint32_t speed)
> +{
> +	switch (espeed) {
> +	case 0:
> +		return dump_linkspeed_compat(speed);
> +		break;
> +	case 1:
> +		return ("FDR");
> +		break;
> +	case 2:
> +		return ("EDR");
> +		break;
> +	}
> +	return ("???");
> +}
> +
>  char *dump_linkwidth_compat(uint32_t width)
>  {
>  	switch (width) {
> @@ -341,6 +358,7 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>  					IB_PORT_LINK_WIDTH_ACTIVE_F);
>  	uint32_t ispeed = mad_get_field(port->info, 0,
>  					IB_PORT_LINK_SPEED_ACTIVE_F);
> +	uint32_t cap_mask, espeed;
>  
>  	DEBUG("port %p:%d remoteport %p\n", port, port->portnum,
>  	      port->remoteport);
> @@ -355,6 +373,13 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>  				       port->remoteport->node->nodedesc);
>  
>  	ext_port_str = out_ext_port(port->remoteport, group);
> +	cap_mask = mad_get_field(port->node->ports[0]->info, 0,
> +				 IB_PORT_CAPMASK_F);
> +	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +		espeed = mad_get_field(port->info, 0,
> +				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
> +	else
> +		espeed = 0;
>  	fprintf(f, "\t%s[%d]%s",
>  		node_name(port->remoteport->node), port->remoteport->portnum,
>  		ext_port_str ? ext_port_str : "");
> @@ -365,7 +390,10 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>  		port->remoteport->node->type == IB_NODE_SWITCH ?
>  		port->remoteport->node->smalid :
>  		port->remoteport->base_lid,
> -		dump_linkwidth_compat(iwidth), dump_linkspeed_compat(ispeed));
> +		dump_linkwidth_compat(iwidth),
> +		(ispeed != 4 && !espeed) ?
> +			dump_linkspeed_compat(ispeed) :
> +			dump_linkspeedext_compat(espeed, ispeed));
>  
>  	if (full_info)
>  		fprintf(f, " s=%d w=%d", ispeed, iwidth);
> @@ -387,6 +415,7 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
>  					IB_PORT_LINK_WIDTH_ACTIVE_F);
>  	uint32_t ispeed = mad_get_field(port->info, 0,
>  					IB_PORT_LINK_SPEED_ACTIVE_F);
> +	uint32_t cap_mask, espeed;
>  
>  	fprintf(f, "%s[%d]", out_prefix ? out_prefix : "", port->portnum);
>  	if (port->node->type != IB_NODE_SWITCH)
> @@ -403,12 +432,22 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
>  				       port->remoteport->node->guid,
>  				       port->remoteport->node->nodedesc);
>  
> +	cap_mask = mad_get_field(port->info, 0, IB_PORT_CAPMASK_F);
> +	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +		espeed = mad_get_field(port->info, 0,
> +				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
> +	else
> +		espeed = 0;
> +
>  	fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d %s%s",
>  		port->base_lid, port->lmc, rem_nodename,
>  		port->remoteport->node->type == IB_NODE_SWITCH ?
>  		port->remoteport->node->smalid :
>  		port->remoteport->base_lid,
> -		dump_linkwidth_compat(iwidth), dump_linkspeed_compat(ispeed));
> +		dump_linkwidth_compat(iwidth),
> +		(ispeed != 4 && !espeed) ?
> +			dump_linkspeed_compat(ispeed) :
> +			dump_linkspeedext_compat(espeed, ispeed));
>  
>  	if (full_info)
>  		fprintf(f, " s=%d w=%d", ispeed, iwidth);
> @@ -632,13 +671,24 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
>  	/* for each port */
>  	for (p = node->numports, port = node->ports[p]; p > 0;
>  	     port = node->ports[--p]) {
> -		uint32_t iwidth, ispeed;
> +		uint32_t iwidth, ispeed, espeed, cap_mask;
> +		uint8_t *info;
>  		if (port == NULL)
>  			continue;
>  		iwidth =
>  		    mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
>  		ispeed =
>  		    mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
> +		if (port->node->type == IB_NODE_SWITCH)
> +			info = (uint8_t *)&port->node->ports[0]->info;
> +		else
> +			info = (uint8_t *)&port->info;
> +		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> +		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +			espeed = mad_get_field(port->info, 0,
> +					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
> +		else
> +			espeed = 0;
>  		nodename = remap_node_name(node_name_map,
>  					   port->node->guid,
>  					   port->node->nodedesc);
> @@ -648,7 +698,9 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
>  			IB_NODE_SWITCH ? node->smalid : port->base_lid,
>  			port->portnum, port->guid,
>  			dump_linkwidth_compat(iwidth),
> -			dump_linkspeed_compat(ispeed));
> +			(ispeed != 4 && !espeed) ?
> +				dump_linkspeed_compat(ispeed) :
> +				dump_linkspeedext_compat(espeed, ispeed));
>  		if (port->remoteport) {
>  			rem_nodename = remap_node_name(node_name_map,
>  					      port->remoteport->node->guid,


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
