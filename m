From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid
 port.  Otherwise leave it as 0
Date: Sun, 17 Apr 2011 11:21:09 -0400
Message-ID: <4DAB0565.8020505@dev.mellanox.co.il>
References: <20110415151736.809c550b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110415151736.809c550b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/15/2011 6:17 PM, Ira Weiny wrote:
> 
> Subject: [PATCH] opensm: perfmgr, only set orig_lid when we have a valid port.  Otherwise leave it as 0
> 
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  opensm/osm_perfmgr.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
> index 6a1fa63..3e1575a 100644
> --- a/opensm/osm_perfmgr.c
> +++ b/opensm/osm_perfmgr.c
> @@ -454,7 +454,9 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>  				  ib_switch_info_is_enhanced_port0(&node->sw->
>  								   switch_info));
>  		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
> -			mon_node->port[port].orig_lid = get_base_lid(node, port);
> +			mon_node->port[port].orig_lid = 0;
> +			if (osm_physp_is_valid(&node->physp_table[port]))
> +				mon_node->port[port].orig_lid = get_base_lid(node, port);
>  			mon_node->port[port].valid = TRUE;
>  		}
>  

There are several other calls to get_base_lid. Is it also an issue there
too or is port always valid there ? If it's not always valid for those
cases, why not just move this check into get_base_lid ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
