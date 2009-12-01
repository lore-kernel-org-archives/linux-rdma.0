From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Multicast root switch calculation
Date: Tue, 1 Dec 2009 05:18:06 +0200
Message-ID: <20091201031806.GJ16607@me>
References: <4AEE8D55.2050602@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AEE8D55.2050602-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Slava,

On 09:42 Mon 02 Nov     , Slava Strebkov wrote:
> Proposed new algorithm for calculation of root switch for multicast
> spanning tree. Only edge switches(those connected to hosts) and
> switches - multicast members themselves are involved in root calculation.
> This gives improvement, especially on large fabrics, since number of
> switches usually much less then the number of ports, shared same mcast
> group.

Seems like a good idea for me. Do you have any performance numbers
related to this optimization?

Probably you want to rebase this using currently existing work object
list. Anyway some comments are below.

> 
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/include/opensm/osm_switch.h |   14 ++++-
>  opensm/opensm/osm_mcast_mgr.c      |  132 ++++++++++++++++++++++++++++++++----
>  2 files changed, 132 insertions(+), 14 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
> index 655491d..6204b37 100644
> --- a/opensm/include/opensm/osm_switch.h
> +++ b/opensm/include/opensm/osm_switch.h
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
> @@ -109,6 +109,9 @@ typedef struct osm_switch {
>  	unsigned endport_links;
>  	unsigned need_update;
>  	void *priv;
> +	cl_map_item_t mcast_item;
> +	uint32_t num_of_mcm;
> +	uint8_t	is_mc_member;
>  } osm_switch_t;
>  /*
>  * FIELDS
> @@ -151,6 +154,15 @@ typedef struct osm_switch {
>  *		When set indicates that switch was probably reset, so
>  *		fwd tables and rest cached data should be flushed
>  *
> +*	mcast_item
> +*		map item for switch in building mcast tree
> +*
> +*	num_of_mcm
> +*		number of mcast members(ports) connected to switch
> +*
> +*	is_mc_member
> +*		whether switch is a mcast member itself
> +*
>  * SEE ALSO
>  *	Switch object
>  *********/
> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
> index 0ee689c..c9c93a2 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -203,25 +203,132 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm,
>  	return (float)max_hops;
>  }
>  
> +static void mcast_mgr_build_switch_map(osm_sm_t * sm,
> +			const osm_mgrp_t * p_mgrp,
> +			cl_qmap_t *p_mcast_member_sw_tbl)
> +{
> +	osm_switch_t	*remote_sw;
> +	const osm_mcm_port_t *p_mcm_port;
> +	const cl_qmap_t *p_mcm_tbl;
> +	osm_port_t *p_port;
> +	ib_net64_t	port_guid;
> +	osm_physp_t	*p_physp_remote;
> +	osm_node_t *remote_node;
> +
> +	OSM_LOG_ENTER(sm->p_log);
> +
> +	cl_qmap_init(p_mcast_member_sw_tbl);
> +	p_mcm_tbl = &p_mgrp->mcm_port_tbl;
> +	for (p_mcm_port = (osm_mcm_port_t *) cl_qmap_head(p_mcm_tbl);
> +		p_mcm_port != (osm_mcm_port_t *) cl_qmap_end(p_mcm_tbl);
> +		p_mcm_port = (osm_mcm_port_t *) cl_qmap_next(&p_mcm_port->map_item)) {
> +		p_port = (osm_port_t*)osm_get_port_by_guid(sm->p_subn,
> +			ib_gid_get_guid(&p_mcm_port->port_gid));

A port object is referenced directly by mcm_port structure 'port' field,
so it is not necessary to resolve it by guid.

> +		if (!p_port)
> +			continue;
> +		if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA) {
> +			p_physp_remote = osm_physp_get_remote(p_port->p_physp);
> +			remote_node = osm_physp_get_node_ptr(p_physp_remote);
> +		}
> +		else {
> +			/* for switches - remote switch would be the switch itself*/
> +			remote_node = osm_physp_get_node_ptr( p_port->p_physp);
> +		}
> +		/* get the remote switch of the mcmember */
> +		remote_sw = remote_node->sw;
> +		port_guid = osm_node_get_node_guid(remote_node);
> +		if (cl_qmap_get(p_mcast_member_sw_tbl, port_guid) ==
> +			cl_qmap_end(p_mcast_member_sw_tbl)) {
> +			/* insert switch to table */
> +			cl_qmap_insert(p_mcast_member_sw_tbl, port_guid, &remote_sw->mcast_item);
> +			/* New element in the table */
> +			if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA) {

'if (node->sw)' check could be simpler.

Also a braces around single operation is not needed (here and in some
other places in the patch).

> +				/* for HCA update the MC count on the remote switch */
> +				remote_sw->num_of_mcm++;
> +			}
> +			else
> +				remote_sw->is_mc_member = 1; /* the switch is MC memeber */
> +		}
> +	}
> +	OSM_LOG_EXIT(sm->p_log);
> +}
> +
> +static void mcast_mgr_destroy_switch_map(osm_sm_t * sm,
> +			cl_qmap_t *p_mcast_member_sw_tbl)
> +{
> +	cl_map_item_t *p_item;
> +	osm_switch_t *p_sw;
> +
> +	OSM_LOG_ENTER(sm->p_log);
> +
> +	p_item = cl_qmap_head(p_mcast_member_sw_tbl);
> +	while (p_item != cl_qmap_end(p_mcast_member_sw_tbl)) {
> +		p_sw = PARENT_STRUCT(p_item, osm_switch_t, mcast_item);
> +			p_sw->num_of_mcm = 0;
> +			p_sw->is_mc_member = 0;
> +			p_item = cl_qmap_next(p_item);

Here and in many other places please existing keep indentation.

Sasha

> +	}
> +	cl_qmap_remove_all(p_mcast_member_sw_tbl);
> +	OSM_LOG_EXIT(sm->p_log);
> +}
> +
> +static float
> +osm_mcast_mgr_compute_avg_hops_weight(osm_sm_t * sm,
> +		const osm_switch_t *const p_sw_cur,
> +		const cl_qmap_t	*p_sw_tbl )
> +{
> +	float avg_hops_weight = 0;
> +	uint32_t hops = 0;
> +	uint32_t num_ports = 0;
> +	uint16_t base_lid_ho;
> +	uint32_t tmp_hops;
> +	uint32_t least_hops;
> +	osm_switch_t *p_sw;
> +	cl_map_item_t *p_item;
> +
> +	OSM_LOG_ENTER(sm->p_log);
> +	/*
> +		For each member of the multicast group, compute the
> +		number of hops to its base LID.
> +	*/
> +	for( p_item = cl_qmap_head( p_sw_tbl);
> +		p_item != cl_qmap_end( p_sw_tbl);
> +		p_item = cl_qmap_next(p_item )) {
> +		p_sw =  (osm_switch_t*)PARENT_STRUCT(p_item, osm_switch_t, mcast_item);
> +		base_lid_ho = cl_ntoh16( osm_node_get_base_lid(p_sw->p_node,0 ));
> +		least_hops = osm_switch_get_least_hops( p_sw_cur, base_lid_ho );
> +		/* for all host that are MC members and attached to the switch,
> +		we should add the (least_hops + 1) * number_of_such_hosts.
> +		If switch itself is in the MC, we should add the least_hops only */
> +		tmp_hops = (least_hops + 1) * p_sw->num_of_mcm + least_hops * p_sw->is_mc_member;
> +		hops += tmp_hops;
> +		num_ports+=p_sw->num_of_mcm + p_sw->is_mc_member;
> +	}
> +
> +	CL_ASSERT( num_ports );
> +	if( num_ports != 0 ) {
> +		avg_hops_weight = (hops ) / num_ports;
> +	}
> +
> +	OSM_LOG_EXIT(sm->p_log);
> +	return( avg_hops_weight );
> +}
> +
>  /**********************************************************************
>     This function attempts to locate the optimal switch for the
>     center of the spanning tree.  The current algorithm chooses
> -   a switch with the lowest average hop count to the members
> +   a switch with the lowest average weight of the members
>     of the multicast group.
>  **********************************************************************/
>  static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
> -						   const osm_mgrp_t * p_mgrp)
> +						  const osm_mgrp_t * p_mgrp)
>  {
>  	cl_qmap_t *p_sw_tbl;
> -	const osm_switch_t *p_sw;
> +	osm_switch_t *p_sw;
>  	const osm_switch_t *p_best_sw = NULL;
>  	float hops = 0;
>  	float best_hops = 10000;	/* any big # will do */
> -#ifdef OSM_VENDOR_INTF_ANAFA
> -	boolean_t use_avg_hops = TRUE;	/* anafa2 - bug hca on switch *//* use max hops for root */
> -#else
> -	boolean_t use_avg_hops = FALSE;	/* use max hops for root */
> -#endif
> +	cl_qmap_t mcast_member_sw_tbl;
>  
>  	OSM_LOG_ENTER(sm->p_log);
>  
> @@ -229,16 +336,14 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
>  
>  	CL_ASSERT(!osm_mgrp_is_empty(p_mgrp));
>  
> +	mcast_mgr_build_switch_map(sm, p_mgrp, &mcast_member_sw_tbl);
>  	for (p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
>  	     p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl);
>  	     p_sw = (osm_switch_t *) cl_qmap_next(&p_sw->map_item)) {
>  		if (!osm_switch_supports_mcast(p_sw))
>  			continue;
>  
> -		if (use_avg_hops)
> -			hops = osm_mcast_mgr_compute_avg_hops(sm, p_mgrp, p_sw);
> -		else
> -			hops = osm_mcast_mgr_compute_max_hops(sm, p_mgrp, p_sw);
> +		hops = osm_mcast_mgr_compute_avg_hops_weight(sm, p_sw, &mcast_member_sw_tbl);
>  
>  		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
>  			"Switch 0x%016" PRIx64 ", hops = %f\n",
> @@ -259,6 +364,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
>  		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>  			"No multicast capable switches detected\n");
>  
> +	mcast_mgr_destroy_switch_map(sm, &mcast_member_sw_tbl);
>  	OSM_LOG_EXIT(sm->p_log);
>  	return (osm_switch_t *) p_best_sw;
>  }
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
