From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm: Prepare for alias GUID support
Date: Wed, 20 Apr 2011 16:48:48 +0300
Message-ID: <20110420134848.GC28761@calypso.voltaire.com>
References: <4DA31792.2010403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA31792.2010403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 11:00 Mon 11 Apr     , Hal Rosenstock wrote:
> 
> This change prepares for support of alias GUIDs by adding an alias guid
> port table and currently populates it only with the base port GUID
> in the response to the SM NodeInfo attribute query.
> 
> Ultimately, base as well as alternate (alias) guids will be included
> in this table.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
> index a9499dd..83ef77e 100644
> --- a/include/opensm/osm_subnet.h
> +++ b/include/opensm/osm_subnet.h
> @@ -525,6 +525,7 @@ typedef struct osm_subn {
>  	cl_qmap_t sw_guid_tbl;
>  	cl_qmap_t node_guid_tbl;
>  	cl_qmap_t port_guid_tbl;
> +	cl_qmap_t alias_port_guid_tbl;
>  	cl_qmap_t rtr_guid_tbl;
>  	cl_qlist_t prefix_routes_list;
>  	cl_qmap_t prtn_pkey_tbl;
> @@ -1007,6 +1008,36 @@ struct osm_port *osm_get_port_by_lid_ho(const osm_subn_t * subn, uint16_t lid);
>  *       Subnet object, osm_port_t
>  *********/
>  
> +/****f* OpenSM: Subnet/osm_get_port_by_alias_guid
> +* NAME
> +*	osm_get_port_by_alias_guid
> +*
> +* DESCRIPTION
> +*	This looks for the given port guid in the subnet table of ports by
> +*	alias guid.
> +*  NOTE: this code is not thread safe. Need to grab the lock before
> +*  calling it.
> +*
> +* SYNOPSIS
> +*/
> +struct osm_port *osm_get_port_by_alias_guid(IN osm_subn_t const *p_subn,
> +					    IN ib_net64_t guid);
> +/*
> +* PARAMETERS
> +*	p_subn
> +*		[in] Pointer to an osm_subn_t object
> +*
> +*	guid
> +*		[in] The alias port guid in network order
> +*
> +* RETURN VALUES
> +*	The port structure pointer if found. NULL otherwise.
> +*
> +* SEE ALSO
> +*	Subnet object, osm_subn_construct, osm_subn_destroy,
> +*	osm_port_t
> +*********/
> +
>  /****f* OpenSM: Port/osm_get_port_by_lid
>  * NAME
>  *	osm_get_port_by_lid
> diff --git a/opensm/osm_console.c b/opensm/osm_console.c
> index 0ee528e..684d6ee 100644
> --- a/opensm/osm_console.c
> +++ b/opensm/osm_console.c
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
> + * Copyright (c) 2010 Mellanox Technologies LTD. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -1422,8 +1423,8 @@ typedef struct _regexp_list {
>  
>  static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
>  {
> -	cl_qmap_t *p_port_guid_tbl;
> -	osm_port_t *p_port, *p_next_port;
> +	cl_qmap_t *p_alias_port_guid_tbl;
> +	osm_alias_guid_t *p_alias_guid, *p_next_alias_guid;
>  	regexp_list_t *p_regexp, *p_head_regexp = NULL;
>  	FILE *output = out;
>  
> @@ -1472,22 +1473,23 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
>  
>  	/* Subnet doesn't need to be updated so we can carry on */
>  
> +	p_alias_port_guid_tbl = &(p_osm->sm.p_subn->alias_port_guid_tbl);
>  	CL_PLOCK_ACQUIRE(p_osm->sm.p_lock);
> -	p_port_guid_tbl = &(p_osm->sm.p_subn->port_guid_tbl);
>  
> -	p_next_port = (osm_port_t *) cl_qmap_head(p_port_guid_tbl);
> -	while (p_next_port != (osm_port_t *) cl_qmap_end(p_port_guid_tbl)) {
> +	p_next_alias_guid = (osm_alias_guid_t *) cl_qmap_head(p_alias_port_guid_tbl);
> +	while (p_next_alias_guid != (osm_alias_guid_t *) cl_qmap_end(p_alias_port_guid_tbl)) {
>  
> -		p_port = p_next_port;
> -		p_next_port =
> -		    (osm_port_t *) cl_qmap_next(&p_next_port->map_item);
> +		p_alias_guid = p_next_alias_guid;
> +		p_next_alias_guid =
> +		    (osm_alias_guid_t *) cl_qmap_next(&p_next_alias_guid->map_item);
>  
>  		for (p_regexp = p_head_regexp; p_regexp != NULL;
>  		     p_regexp = p_regexp->next)
> -			if (regexec(&p_regexp->exp, p_port->p_node->print_desc,
> +			if (regexec(&p_regexp->exp,
> +				    p_alias_guid->p_base_port->p_node->print_desc,
>  				    0, NULL, 0) == 0) {
>  				fprintf(output, "0x%" PRIxLEAST64 "\n",
> -					cl_ntoh64(p_port->p_physp->port_guid));
> +					cl_ntoh64(p_alias_guid->alias_guid));
>  				break;
>  			}
>  	}
> diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
> index 111582e..10b51e2 100644
> --- a/opensm/osm_drop_mgr.c
> +++ b/opensm/osm_drop_mgr.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>   *
> @@ -152,6 +152,7 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
>  {
>  	ib_net64_t port_guid;
>  	osm_port_t *p_port_check;
> +	cl_qmap_t *p_alias_guid_tbl;
>  	cl_qmap_t *p_sm_guid_tbl;
>  	osm_mcm_port_t *mcm_port;
>  	cl_ptr_vector_t *p_port_lid_tbl;
> @@ -160,6 +161,7 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
>  	uint16_t lid_ho;
>  	osm_node_t *p_node;
>  	osm_remote_sm_t *p_sm;
> +	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
>  	ib_gid_t port_gid;
>  	ib_mad_notice_attr_t notice;
>  	ib_api_status_t status;
> @@ -207,6 +209,21 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
>  			ib_get_err_str(status));
>  	}
>  
> +	p_alias_guid_tbl = &sm->p_subn->alias_port_guid_tbl;
> +	p_alias_guid_check = (osm_alias_guid_t *) cl_qmap_head(p_alias_guid_tbl);
> +	while (p_alias_guid_check != (osm_alias_guid_t *) cl_qmap_end(p_alias_guid_tbl)) {
> +		if (p_alias_guid_check->p_base_port == p_port)
> +			p_alias_guid = p_alias_guid_check;
> +		else
> +			p_alias_guid = NULL;
> +		p_alias_guid_check = (osm_alias_guid_t *) cl_qmap_next(&p_alias_guid_check->map_item);
> +		if (p_alias_guid) {
> +			cl_qmap_remove_item(p_alias_guid_tbl,
> +					    &p_alias_guid->map_item);
> +			osm_alias_guid_delete(&p_alias_guid);
> +		}
> +	}
> +
>  	p_sm_guid_tbl = &sm->p_subn->sm_guid_tbl;
>  	p_sm = (osm_remote_sm_t *) cl_qmap_remove(p_sm_guid_tbl, port_guid);
>  	if (p_sm != (osm_remote_sm_t *) cl_qmap_end(p_sm_guid_tbl)) {
> diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
> index ad0d2ca..bcb58dc 100644
> --- a/opensm/osm_node_info_rcv.c
> +++ b/opensm/osm_node_info_rcv.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
> @@ -376,6 +376,7 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
>  	osm_port_t *p_port_check;
>  	uint8_t port_num;
>  	osm_dr_path_t *p_dr_path;
> +	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
>  	osm_bind_handle_t h_bind;
>  
>  	OSM_LOG_ENTER(sm->p_log);
> @@ -425,6 +426,30 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
>  			goto Exit;
>  		}
>  
> +		p_alias_guid = osm_alias_guid_new(p_ni->port_guid,
> +						  p_port);
> +		if (!p_alias_guid) {
> +			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D11: "
> +				"alias guid memory allocation failed"
> +				" for port GUID 0x%" PRIx64 "\n",
> +				cl_ntoh64(p_ni->port_guid));
> +			goto alias_done;
> +		}
> +
> +		/* insert into alias guid table */
> +		p_alias_guid_check =
> +			(osm_alias_guid_t *) cl_qmap_insert(&sm->p_subn->alias_port_guid_tbl,
> +							    p_alias_guid->alias_guid,
> +							    &p_alias_guid->map_item);
> +		if (p_alias_guid_check != p_alias_guid) {
> +			/* alias GUID is a duplicate */
> +			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D13: "
> +				"Duplicate alias port GUID 0x%" PRIx64 "\n",
> +				cl_ntoh64(p_ni->port_guid));
> +			osm_alias_guid_delete(&p_alias_guid);

Isn't this error is critical enough to stop port creation?
How can you recover when your alias_port_guid_tbl isn't complete?

> +		}
> +

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
