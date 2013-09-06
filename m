From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: Clean up event subscriptions if a port goes away
Date: Fri, 06 Sep 2013 07:56:30 -0400
Message-ID: <5229C2EE.7060506@dev.mellanox.co.il>
References: <5757eac9-e734-4f39-a828-03a9f95e6835@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5757eac9-e734-4f39-a828-03a9f95e6835@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/5/2013 4:55 AM, Line Holen wrote:
> Event subscriptions needs to be cleaned up if a port goes away.
> If the port comes online again later it may no longer want to
> receive the events on the same QPN. If the "old" QPN is used for
> something else the SM forwarding events may cause QKey violations.

As many current applications do not handle client reregistration
properly and the current OpenSM behavior is not to do this, this
behavior should be introduced "gradually" by conditionalizing this on a
new option like drop_event_subscriptions which would default to FALSE.

This is a start on this and associated issues. I'll comment more once we
get past this first patch.

> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> diff --git a/include/opensm/osm_inform.h b/include/opensm/osm_inform.h
> index f737441..8cefc20 100644
> --- a/include/opensm/osm_inform.h
> +++ b/include/opensm/osm_inform.h
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -200,6 +201,35 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  			     IN osm_infr_t * p_infr);
>  
> +/****f* OpenSM: Inform Record/osm_infr_remove_subscriptions
> +* NAME
> +*	osm_infr_remove_subscriptions
> +*
> +* DESCRIPTION
> +*	Remove all event subscriptions of a port
> +*
> +* SYNOPSIS
> +*/
> +ib_api_status_t
> +osm_infr_remove_subscriptions(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
> +			      IN ib_net64_t port_guid);
> +/*
> +* PARAMETERS
> +*	p_subn
> +*		[in] Pointer to the subnet object
> +*
> +*	p_log
> +*		[in] Pointer to the log object
> +*
> +*	port_guid
> +*		[in] PortGUID of the subscriber that should be removed
> +*
> +* RETURN
> +*	CL_SUCCESS if port_guid had any subscriptions being removed
> +*	CL_NOT_FOUND if port_guid did not have any active subscriptions
> +* SEE ALSO
> +*********/
> +
>  /****f* OpenSM: Inform Record/osm_report_notice
>  * NAME
>  *	osm_report_notice
> diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
> index b309273..5f9181a 100644
> --- a/opensm/osm_drop_mgr.c
> +++ b/opensm/osm_drop_mgr.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> + * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -276,6 +277,13 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
>  
>  	drop_mgr_clean_physp(sm, p_port->p_physp);
>  
> +	/* Delete event forwarding subscriptions */
> +	if (osm_infr_remove_subscriptions(sm->p_subn, sm->p_log, port_guid)
> +	    == CL_SUCCESS)
> +		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
> +		    "Removed event subscriptions for port 0x%016" PRIx64 "\n",
> +		    cl_ntoh64(port_guid));
> +
>  	/* initialize the p_node - may need to get node_desc later */
>  	p_node = p_port->p_node;
>  
> diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
> index 804c414..6318700 100644
> --- a/opensm/osm_inform.c
> +++ b/opensm/osm_inform.c
> @@ -282,6 +282,41 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
>  	OSM_LOG_EXIT(p_log);
>  }
>  
> +ib_api_status_t osm_infr_remove_subscriptions(IN osm_subn_t * p_subn,
> +					      IN osm_log_t * p_log,
> +					      IN ib_net64_t port_guid)
> +{
> +	ib_gid_t gid;
> +	cl_list_item_t *p_list_item;
> +	osm_infr_t *p_infr;
> +	ib_api_status_t status = CL_NOT_FOUND;
> +
> +	OSM_LOG_ENTER(p_log);
> +
> +	gid.unicast.interface_id = port_guid;
> +	gid.unicast.prefix = p_subn->opt.subnet_prefix;
> +
> +	/* go over all inform info available at the subnet */
> +	/* match to the given GID and delete subscriptions if match */
> +	p_list_item = cl_qlist_head(&p_subn->sa_infr_list);
> +	while (p_list_item != cl_qlist_end(&p_subn->sa_infr_list)) {
> +
> +		p_infr = (osm_infr_t *)p_list_item;
> +		p_list_item = cl_qlist_next(p_list_item);
> +
> +		if (memcmp(&(p_infr->inform_record.subscriber_gid), &gid, sizeof(ib_gid_t)))

Would:
if (port_guid != p_infr->inform_record.subscriber_gid.unicast.interface_id)
be simpler here ?

-- Hal

> +			continue;
> +
> +		/* Remove this event subscription */
> +		osm_infr_remove_from_db(p_subn, p_log, p_infr);
> +
> +		status = CL_SUCCESS;
> +	}
> +
> +	OSM_LOG_EXIT(p_log);
> +	return (status);
> +}
> +
>  /**********************************************************************
>   * Send a report:
>   * Given a target address to send to and the notice.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
