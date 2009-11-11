From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general] [PATCH 1/2 v4] opensm: Storage organization for
 multicast groups
Date: Thu, 12 Nov 2009 01:59:59 +0200
Message-ID: <20091111235959.GY7192@me>
References: <4AC2114E.3010303@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AC2114E.3010303-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Slava,

This patch is outdated (it was outdated at date of posting to the list),
in particular I cleaned up already a needs to resolve multicast group by
mlid for SA PathRecord queries with multicast destination and some
others.

On 15:53 Tue 29 Sep     , Slava Strebkov wrote:
> Main purpose is to prepare infrastructure for (many) mgids to one mlid
> compression.

When doing multicast cleanup, I've implemented this by myself too :).
I didn't post it then due to lack of any testing and switched to
something else. Basically it is very similar (even structure names), but
with few differences:

> Proposed the following changes:
> 1.Element in mlid array is now a multicast group box.
> 2.mgrp_box keeps a list of mgroups sharing same mlid.
> With introduction of compression, there will be many
> multicast groups per mlid. Current implementation keeps
> one mgid to one mlid ratio.
> 3.mgrp_box has a map of ports sharing same mlid. Ports sorted
> by port guid. Port map is necessary for building spanning
> tree per mgroup_box, not just for single mgroup.
> 4.Element in port map keeps a list of mgroups opened by this port.
> This allows quick deletion of mgroups when port changes
> state to DOWN.
> 5.Multicast processing functions use mgroup_box object instead
> of mgroup.

I don't have (3) and (4) - a port map per mbox is only useful when
OpenSM calculates multicast routing, so I decided instead of bothering
with updating such maps during at each MCM Record SA request to
generate local map internally when it is needed (in mcast_mgr).

I will post the patch for your review shortly.

> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Some comments are below anyway.

> diff --git a/opensm/opensm/osm_qos_policy.c b/opensm/opensm/osm_qos_policy.c
> index 9b72293..6c0a1e6 100644
> --- a/opensm/opensm/osm_qos_policy.c
> +++ b/opensm/opensm/osm_qos_policy.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -773,6 +773,8 @@ static void __qos_policy_validate_pkey(
>  	uint32_t flow;
>  	uint8_t hop;
>  	osm_mgrp_t * p_mgrp;
> +	osm_mgrp_box_t * p_mgrp_box;
> +	cl_list_item_t *p_item;
>  
>  	if (!p_qos_policy || !p_qos_match_rule || !p_prtn)
>  		return;
> @@ -796,28 +798,33 @@ static void __qos_policy_validate_pkey(
>  	if (!p_prtn->mlid)
>  		return;
>  
> -	p_mgrp = osm_get_mgrp_by_mlid(p_qos_policy->p_subn, p_prtn->mlid);
> -	if (!p_mgrp) {
> +	p_mgrp_box = osm_get_mgrp_box_by_mlid(p_qos_policy->p_subn, p_prtn->mlid);
> +	if (!p_mgrp_box) {
>  		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_ERROR,
> -			"ERR AC16: MCast group for partition with "
> +			"ERR AC16: MCast group box for partition with "
>  			"pkey 0x%04X not found\n",
>  			cl_ntoh16(p_prtn->pkey));
>  		return;
>  	}
>  
> -	CL_ASSERT((cl_ntoh16(p_mgrp->mcmember_rec.pkey) & 0x7fff) ==
> -		  (cl_ntoh16(p_prtn->pkey) & 0x7fff));
> -
> -	ib_member_get_sl_flow_hop(p_mgrp->mcmember_rec.sl_flow_hop,
> -				  &sl, &flow, &hop);
> -	if (sl != p_prtn->sl) {
> -		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_DEBUG,
> -			"Updating MCGroup (MLID 0x%04x) SL to "
> -			"match partition SL (%u)\n",
> -			cl_hton16(p_mgrp->mcmember_rec.mlid),
> -			p_prtn->sl);
> -		p_mgrp->mcmember_rec.sl_flow_hop =
> +	p_item = cl_qlist_head(&p_mgrp_box->mgrp_list);
> +	while (p_item != cl_qlist_end(&p_mgrp_box->mgrp_list)) {
> +		p_mgrp = (osm_mgrp_t *) PARENT_STRUCT(p_item, osm_mgrp_t,
> +			box_item);
> +		p_item = cl_qlist_next(p_item);
> +		CL_ASSERT((cl_ntoh16(p_mgrp->mcmember_rec.pkey) & 0x7fff) ==
> +			(cl_ntoh16(p_prtn->pkey) & 0x7fff));
> +		ib_member_get_sl_flow_hop(p_mgrp->mcmember_rec.sl_flow_hop,
> +			&sl, &flow, &hop);
> +		if (sl != p_prtn->sl) {
> +			OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_DEBUG,
> +				"Updating MCGroup (MLID 0x%04x) SL to "
> +				"match partition SL (%u)\n",
> +				cl_hton16(p_mgrp->mcmember_rec.mlid),
> +				p_prtn->sl);
> +			p_mgrp->mcmember_rec.sl_flow_hop =
>  			ib_member_set_sl_flow_hop(p_prtn->sl, flow, hop);
> +		}

Seems that when QoS requests using certain SL value on some partition
you instead of altering SL value for only multicast group associated with
given partition are going to change SL for all multicast groups which have
a same mlid. It doesn't seem correct to me.

I think that in proper implementation partition object instead of
keeping mlid (which can be shared by many multicast groups) should keep
pointer to its own group. I posted such patch to the list recently.

>  	}
>  }
>  
> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
> index 02737c2..a5d8945 100644
> --- a/opensm/opensm/osm_sa.c
> +++ b/opensm/opensm/osm_sa.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> @@ -706,18 +706,17 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
>  {
>  	struct opensm_dump_context dump_context;
>  	osm_mgrp_t *p_mgrp;
> -	int i;
>  
>  	dump_context.p_osm = p_osm;
>  	dump_context.file = file;
>  	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
>  	cl_plock_acquire(&p_osm->lock);
> -	for (i = 0; i <= p_osm->subn.max_mcast_lid_ho - IB_LID_MCAST_START_HO;
> -	     i++) {
> -		p_mgrp = p_osm->subn.mgroups[i];
> -		if (p_mgrp)
> -			sa_dump_one_mgrp(p_mgrp, &dump_context);
> +	p_mgrp = (osm_mgrp_t*)cl_fmap_head(&p_osm->subn.mgrp_mgid_tbl);
> +	while (p_mgrp != (osm_mgrp_t*)cl_fmap_end(&p_osm->subn.mgrp_mgid_tbl)) {
> +		sa_dump_one_mgrp(p_mgrp, &dump_context);
> +		p_mgrp = (osm_mgrp_t*) cl_fmap_next(&p_mgrp->map_item);
>  	}
> +
>  	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump inform\n");
>  	cl_qlist_apply_func(&p_osm->subn.sa_infr_list,
>  			    sa_dump_one_inform, &dump_context);
> @@ -740,22 +739,15 @@ static osm_mgrp_t *load_mcgroup(osm_opensm_t * p_osm, ib_net16_t mlid,
>  				unsigned well_known)
>  {
>  	ib_net64_t comp_mask;
> -	osm_mgrp_t *p_mgrp;
> +	osm_mgrp_t *p_mgrp = NULL;
> +	cl_fmap_item_t *p_fitem;
>  
>  	cl_plock_excl_acquire(&p_osm->lock);
>  
> -	p_mgrp = osm_get_mgrp_by_mlid(&p_osm->subn, mlid);
> -	if (p_mgrp) {
> -		if (!memcmp(&p_mgrp->mcmember_rec.mgid, &p_mcm_rec->mgid,
> -			    sizeof(ib_gid_t))) {
> -			OSM_LOG(&p_osm->log, OSM_LOG_DEBUG,
> -				"mgrp %04x is already here.", cl_ntoh16(mlid));
> -			goto _out;
> -		}
> -		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
> -			"mlid %04x is already used by another MC group. Will "
> -			"request clients reregistration.\n", cl_ntoh16(mlid));
> -		p_mgrp = NULL;
> +	p_fitem = cl_fmap_get(&p_osm->subn.mgrp_mgid_tbl, &p_mcm_rec->mgid);
> +	if (p_fitem != cl_fmap_end(&p_osm->subn.mgrp_mgid_tbl)) {
> +		OSM_LOG(&p_osm->log, OSM_LOG_DEBUG,
> +			"mgrp %04x is already here.", cl_ntoh16(mlid));
>  		goto _out;

Finally you are skipping mlid/mgid consistency check. Maybe it is not a
fatal in general, but likely may confuse a multicast group members where
MLID value was changes over SA DB reload.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
