From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/4] opensm/osm_perfmgr.c: issue ClassPortInfo as first
 query to each port.
Date: Mon, 04 Apr 2011 15:53:52 -0400
Message-ID: <4D9A21D0.4090409@dev.mellanox.co.il>
References: <20110324182047.1bb5b84b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110324182047.1bb5b84b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/24/2011 9:20 PM, Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-NlKtF6KlI8yLYFxP40JT4w@public.gmane.org>
> Date: Wed, 3 Nov 2010 13:23:23 -0700
> Subject: [PATCH] opensm/osm_perfmgr.c: issue ClassPortInfo as first query to each port.

Should it be an option as to whether or not to do this (and anything
dependent on ClassPortInfo like extended counters or transmit wait
clearing, etc.) ?

My comments are based on just reviewing the patch itself.

Nit: please review error codes to make sure not already used.

> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/opensm/osm_perfmgr.h |    4 +
>  opensm/osm_perfmgr.c         |  229 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 179 insertions(+), 54 deletions(-)
> 
> diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
> index 34925e8..cc51d1a 100644
> --- a/include/opensm/osm_perfmgr.h
> +++ b/include/opensm/osm_perfmgr.h
> @@ -100,6 +100,9 @@ typedef struct monitored_port {
>  	ib_net16_t lid;
>  	ib_net16_t pkey;
>  	ib_net32_t qp;
> +	/* ClassPortInfo fields */
> +	boolean_t cpi_valid;
> +	ib_net16_t cap_mask;
>  } monitored_port_t;
>  
>  /* Node to store information about nodes being monitored */
> @@ -107,6 +110,7 @@ typedef struct monitored_node {
>  	cl_map_item_t map_item;
>  	struct monitored_node *next;
>  	uint64_t guid;
> +	uint8_t node_type;
>  	boolean_t esp0;
>  	char *name;
>  	uint32_t num_ports;
> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
> index 6a1fa63..87ddee8 100644
> --- a/opensm/osm_perfmgr.c
> +++ b/opensm/osm_perfmgr.c
> @@ -346,17 +346,20 @@ static ib_net16_t get_lid(osm_node_t * p_node, uint8_t port,
>  	return get_base_lid(p_node, port);
>  }
>  
> +
>  /**********************************************************************
> - * Form and send the Port Counters MAD for a single port.
> + * Build a Performance Management class MAD
>   **********************************************************************/
> -static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
> -					   ib_net16_t dest_lid,
> -					   ib_net32_t dest_qp, uint16_t pkey_ix,
> -					   uint8_t port, uint8_t mad_method,
> -					   osm_madw_context_t * p_context)
> +static osm_madw_t *perfmgr_build_mad(osm_perfmgr_t * perfmgr,
> +				     ib_net16_t dest_lid,
> +				     uint8_t sl,
> +				     ib_net32_t dest_qp,
> +				     uint16_t pkey_ix,
> +				     uint8_t mad_method,
> +				     ib_net16_t attr_id,
> +				     osm_madw_context_t * p_context,
> +				     ib_perfmgt_mad_t ** p_pm_mad)
>  {
> -	ib_api_status_t status = IB_SUCCESS;
> -	ib_port_counters_t *port_counter = NULL;
>  	ib_perfmgt_mad_t *pm_mad = NULL;
>  	osm_madw_t *p_madw = NULL;
>  
> @@ -365,7 +368,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  	p_madw = osm_mad_pool_get(perfmgr->mad_pool, perfmgr->bind_handle,
>  				  MAD_BLOCK_SIZE, NULL);
>  	if (p_madw == NULL)
> -		return IB_INSUFFICIENT_MEMORY;
> +		return NULL;
>  
>  	pm_mad = osm_madw_get_perfmgt_mad_ptr(p_madw);
>  
> @@ -378,29 +381,38 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  	pm_mad->header.class_spec = 0;
>  	pm_mad->header.trans_id =
>  	    cl_hton64((uint64_t) cl_atomic_inc(&perfmgr->trans_id));
> -	pm_mad->header.attr_id = IB_MAD_ATTR_PORT_CNTRS;
> +	pm_mad->header.attr_id = attr_id;
>  	pm_mad->header.resv = 0;
>  	pm_mad->header.attr_mod = 0;
>  
> -	port_counter = (ib_port_counters_t *) & pm_mad->data;
> -	memset(port_counter, 0, sizeof(*port_counter));
> -	port_counter->port_select = port;
> -	port_counter->counter_select = 0xFFFF;
> -
>  	p_madw->mad_addr.dest_lid = dest_lid;
>  	p_madw->mad_addr.addr_type.gsi.remote_qp = dest_qp;
>  	p_madw->mad_addr.addr_type.gsi.remote_qkey =
>  	    cl_hton32(IB_QP1_WELL_KNOWN_Q_KEY);
>  	p_madw->mad_addr.addr_type.gsi.pkey_ix = pkey_ix;
> -	p_madw->mad_addr.addr_type.gsi.service_level = 0;
> +	p_madw->mad_addr.addr_type.gsi.service_level = sl;
>  	p_madw->mad_addr.addr_type.gsi.global_route = FALSE;
>  	p_madw->resp_expected = TRUE;
>  
>  	if (p_context)
>  		p_madw->context = *p_context;
>  
> -	status = osm_vendor_send(perfmgr->bind_handle, p_madw, TRUE);
> +        if (p_pm_mad)
> +                *p_pm_mad = pm_mad;
> +
> +	OSM_LOG_EXIT(perfmgr->log);
>  
> +	return (p_madw);
> +}
> +
> +/**********************************************************************
> + * Send a Performance Management class MAD
> + **********************************************************************/
> +static ib_api_status_t perfmgr_send_mad(osm_perfmgr_t *perfmgr,
> +					osm_madw_t * const p_madw)
> +{
> +	ib_api_status_t status = osm_vendor_send(perfmgr->bind_handle, p_madw,
> +						 TRUE);
>  	if (status == IB_SUCCESS) {
>  		/* pause thread if there are too many outstanding requests */
>  		cl_atomic_inc(&(perfmgr->outstanding_queries));
> @@ -412,6 +424,39 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  			perfmgr->sweep_state = PERFMGR_SWEEP_ACTIVE;
>  		}
>  	}
> +	return (status);
> +}
> +
> +
> +/**********************************************************************
> + * Form and send the PortCounters MAD for a single port.
> + **********************************************************************/
> +static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
> +					   ib_net16_t dest_lid,
> +					   ib_net32_t dest_qp, uint16_t pkey_ix,
> +					   uint8_t port, uint8_t mad_method,
> +					   osm_madw_context_t * p_context)

I would think SL should be an additional parameter to this API.

> +{
> +	ib_api_status_t status = IB_SUCCESS;
> +	ib_port_counters_t *port_counter = NULL;
> +	ib_perfmgt_mad_t *pm_mad = NULL;
> +	osm_madw_t *p_madw = NULL;
> +
> +	OSM_LOG_ENTER(perfmgr->log);
> +
> +	/* FIXME SL != 0 */
> +	p_madw = perfmgr_build_mad(perfmgr, dest_lid, 0, dest_qp, pkey_ix,
> +				mad_method, IB_MAD_ATTR_PORT_CNTRS, p_context,
> +				&pm_mad);
> +	if (p_madw == NULL)
> +		return IB_INSUFFICIENT_MEMORY;
> +
> +	port_counter = (ib_port_counters_t *) & pm_mad->data;
> +	memset(port_counter, 0, sizeof(*port_counter));
> +	port_counter->port_select = port;
> +	port_counter->counter_select = 0xFFFF;
> +
> +	status = perfmgr_send_mad(perfmgr, p_madw);
>  
>  	OSM_LOG_EXIT(perfmgr->log);
>  	return status;
> @@ -449,6 +494,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>  		mon_node->guid = node_guid;
>  		mon_node->name = strdup(node->print_desc);
>  		mon_node->num_ports = num_ports;
> +		mon_node->node_type = node->node_info.node_type;
>  		/* check for enhanced switch port 0 */
>  		mon_node->esp0 = (node->sw &&
>  				  ib_switch_info_is_enhanced_port0(&node->sw->
> @@ -456,6 +502,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>  		for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
>  			mon_node->port[port].orig_lid = get_base_lid(node, port);
>  			mon_node->port[port].valid = TRUE;
> +			mon_node->port[port].cpi_valid = FALSE;
>  		}
>  
>  		cl_qmap_insert(&pm->monitored_map, node_guid,
> @@ -467,6 +514,35 @@ Exit:
>  }
>  
>  /**********************************************************************
> + * Form and send the ClassPortInfo MAD for a single port.
> + **********************************************************************/
> +static ib_api_status_t perfmgr_send_cpi_mad(osm_perfmgr_t * pm,
> +					    ib_net16_t dest_lid,
> +					    ib_net32_t dest_qp,
> +					    uint16_t pkey_ix,
> +					    uint8_t port,
> +					    osm_madw_context_t * p_context)

I would think SL should be an additional parameter to this API.

> +{
> +	ib_api_status_t status = IB_SUCCESS;
> +	osm_madw_t *p_madw = NULL;
> +
> +	OSM_LOG_ENTER(pm->log);
> +
> +	/* FIXME SL != 0 */
> +	p_madw = perfmgr_build_mad(pm, dest_lid, 0, dest_qp,
> +				   pkey_ix, IB_MAD_METHOD_GET,
> +				   IB_MAD_ATTR_CLASS_PORT_INFO, p_context,
> +				   NULL);
> +	if (p_madw == NULL)
> +		return IB_INSUFFICIENT_MEMORY;
> +
> +	status = perfmgr_send_mad(pm, p_madw);
> +
> +	OSM_LOG_EXIT(pm->log);
> +	return status;
> +}
> +
> +/**********************************************************************
>   * query the Port Counters of all the nodes in the subnet.
>   **********************************************************************/
>  static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
> @@ -531,22 +607,41 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
>  		mad_context.perfmgr_context.node_guid = node_guid;
>  		mad_context.perfmgr_context.port = port;
>  		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_GET;
> +
> +		if (!mon_node->port[port].cpi_valid) {
> +			/* FIXME what about SL != 0 */
> +			status = perfmgr_send_cpi_mad(pm, lid, remote_qp,
> +						mon_node->port[port].pkey_ix,
> +						port, &mad_context);
> +			if (status != IB_SUCCESS)
> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C10: "
> +					"Failed to issue ClassPortInfo query "
> +					"for node 0x%" PRIx64
> +					" port %d (%s)\n",
> +					node->node_info.node_guid, port,
> +					node->print_desc);
> +			if (mon_node->node_type == IB_NODE_TYPE_SWITCH)
> +				goto Exit; /* only need to issue 1 CPI query
> +						for switches */
> +		} else {
> +
>  #if ENABLE_OSM_PERF_MGR_PROFILE
> -		gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
> +			gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
>  #endif
> -		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
> -			PRIx64 " port %d (lid %u) (%s)\n", node_guid, port,
> -			cl_ntoh16(lid), node->print_desc);
> -		status = perfmgr_send_pc_mad(pm, lid, remote_qp,
> -					     mon_node->port[port].pkey_ix,
> -					     port, IB_MAD_METHOD_GET,
> -					     &mad_context);
> -		if (status != IB_SUCCESS)
> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C09: "
> -				"Failed to issue port counter query for node 0x%"
> -				PRIx64 " port %d (%s)\n",
> -				node->node_info.node_guid, port,
> -				node->print_desc);
> +			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
> +				PRIx64 " port %d (lid %u) (%s)\n", node_guid, port,
> +				cl_ntoh16(lid), node->print_desc);
> +			status = perfmgr_send_pc_mad(pm, lid, remote_qp,
> +						     mon_node->port[port].pkey_ix,
> +						     port, IB_MAD_METHOD_GET,
> +						     &mad_context);
> +			if (status != IB_SUCCESS)
> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C09: "
> +					"Failed to issue port counter query for node 0x%"
> +					PRIx64 " port %d (%s)\n",
> +					node->node_info.node_guid, port,
> +					node->print_desc);
> +		}
>  	}
>  Exit:
>  	cl_plock_release(&pm->osm->lock);
> @@ -1162,6 +1257,7 @@ static void pc_recv_process(void *context, void *data)
>  	monitored_node_t *p_mon_node;
>  	int16_t pkey_ix = 0;
>  	boolean_t valid = TRUE;
> +	ib_class_port_info_t *cpi = NULL;
>  
>  	OSM_LOG_ENTER(pm->log);
>  
> @@ -1184,15 +1280,44 @@ static void pc_recv_process(void *context, void *data)
>  	CL_ASSERT(p_mad->attr_id == IB_MAD_ATTR_PORT_CNTRS ||
>  		  p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO);
>  
> +	/* capture CLASS_PORT_INFO data */
> +	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
> +		cpi = (ib_class_port_info_t *) &
> +		    (osm_madw_get_perfmgt_mad_ptr(p_madw)->data);
> +
> +		cl_plock_acquire(&pm->osm->lock);
> +		/* validate port number */
> +		if (port >= p_mon_node->num_ports) {
> +			cl_plock_release(&pm->osm->lock);
> +			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C13: "
> +				"Invalid port num %d for GUID 0x%016"
> +				PRIx64 " num ports %d\n", port, node_guid,
> +				p_mon_node->num_ports);
> +			goto Exit;
> +		}
> +		if (p_mon_node->node_type == IB_NODE_TYPE_SWITCH) {
> +			int i = 0;
> +			for (i = p_mon_node->esp0 ? 0 : 1;
> +			     i < p_mon_node->num_ports;
> +			     i++) {
> +				p_mon_node->port[i].cap_mask = cpi->cap_mask;
> +				p_mon_node->port[i].cpi_valid = TRUE;
> +			}
> +		} else {
> +			p_mon_node->port[port].cap_mask = cpi->cap_mask;
> +			p_mon_node->port[port].cpi_valid = TRUE;
> +		}
> +		cl_plock_release(&pm->osm->lock);
> +	}
> +
>  	/* Response could also be redirection (IBM eHCA PMA does this) */
> -	if (p_mad->status & IB_MAD_STATUS_REDIRECT &&
> -	    p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
> +	if (p_mad->status & IB_MAD_STATUS_REDIRECT) {
>  		char gid_str[INET6_ADDRSTRLEN];
> -		ib_class_port_info_t *cpi =
> -		    (ib_class_port_info_t *) &
> -		    (osm_madw_get_perfmgt_mad_ptr(p_madw)->data);
>  		ib_api_status_t status;
>  
> +		CL_ASSERT(cpi); /* Redirect should have returned CPI
> +					(processed in previous block) */
> +
>  		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>  			"Redirection to LID %u GID %s QP 0x%x received\n",
>  			cl_ntoh16(cpi->redir_lid),
> @@ -1244,15 +1369,6 @@ static void pc_recv_process(void *context, void *data)
>  
>  		/* LID redirection support (easier than GID redirection) */
>  		cl_plock_acquire(&pm->osm->lock);
> -		/* Now, validate port number */
> -		if (port >= p_mon_node->num_ports) {
> -			cl_plock_release(&pm->osm->lock);
> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C13: "
> -				"Invalid port num %d for GUID 0x%016"
> -				PRIx64 " num ports %d\n", port, node_guid,
> -				p_mon_node->num_ports);
> -			goto Exit;
> -		}
>  		p_mon_node->port[port].redirection = TRUE;
>  		p_mon_node->port[port].valid = valid;
>  		memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
> @@ -1267,20 +1383,25 @@ static void pc_recv_process(void *context, void *data)
>  		if (!valid)
>  			goto Exit;
>  
> -		/* Finally, reissue the query to the redirected location */
> -		status = perfmgr_send_pc_mad(pm, cpi->redir_lid, cpi->redir_qp,
> -					     pkey_ix, port,
> -					     mad_context->perfmgr_context.
> -					     mad_method, mad_context);
> +		/* Finally, issue a CPI query to the redirected location */
> +		p_mon_node->port[port].cpi_valid = FALSE;
> +		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
> +					      cpi->redir_qp, pkey_ix,
> +					      port, mad_context);

CPI would only need to be queried after redirection if cpi is not
known/valid for that new location. Otherwise, it should requery with the
original requested attribute ID (see flow on p. 760 of IBA 1.2.1 vol 1).

At least SL for that next query (after redirection) could come from
RedirectSL. In other cases (normal attribute queries), it would come
from a path query or some equivalent lookup via internal APIs.

After the redirection here, how/where does the query of the (original)
performance counter that was queried occur ? I missed that somehow...

-- Hal

>  		if (status != IB_SUCCESS)
>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C14: "
> -				"Failed to send redirected MAD with method 0x%x for node 0x%"
> -				PRIx64 " port %d\n",
> -				mad_context->perfmgr_context.mad_method,
> -				node_guid, port);
> +				"Failed to send redirected CPI MAD "
> +				"for node %s (0x%" PRIx64 ") port %d\n",
> +				p_mon_node->name, node_guid, port);
>  		goto Exit;
>  	}
>  
> +	/* ClassPortInfo needed to process optional Redirection
> +	 * now exit normally
> +	 */
> +	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO)
> +		goto Exit;
> +
>  	perfmgr_db_fill_err_read(wire_read, &err_reading);
>  	/* FIXME separate query for extended counters if they are supported
>  	 * on the port.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
