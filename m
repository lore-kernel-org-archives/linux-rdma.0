From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags/ibnetdiscover.c: Fix cap_mask endian
 for extended link speeds
Date: Wed, 31 Aug 2011 16:45:39 -0700
Message-ID: <20110831164539.6b090e10.weiny2@llnl.gov>
References: <4E5C0227.10901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E5C0227.10901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 29 Aug 2011 14:18:31 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

thanks applied,
Ira

> ---
> Changes since v1:
> Cosmetic formatting changes
> 
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index 0966217..09bd1c1 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -375,7 +375,7 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
>  	ext_port_str = out_ext_port(port->remoteport, group);
>  	cap_mask = mad_get_field(port->node->ports[0]->info, 0,
>  				 IB_PORT_CAPMASK_F);
> -	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
>  		espeed = mad_get_field(port->info, 0,
>  				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
>  	else
> @@ -433,7 +433,7 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
>  				       port->remoteport->node->nodedesc);
>  
>  	cap_mask = mad_get_field(port->info, 0, IB_PORT_CAPMASK_F);
> -	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
>  		espeed = mad_get_field(port->info, 0,
>  				       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
>  	else
> @@ -684,7 +684,7 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
>  		else
>  			info = (uint8_t *)&port->info;
>  		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
> -		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
> +		if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_EXT_SPEEDS))
>  			espeed = mad_get_field(port->info, 0,
>  					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
>  		else


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
