From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 01/06] opensm/perfmgr: issue ClassPortInfo as first query
 to each port.
Date: Tue, 26 Feb 2013 10:03:35 -0500
Message-ID: <512CCEC7.70304@dev.mellanox.co.il>
References: <20130221133331.593f30977427848f4373b57a@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130221133331.593f30977427848f4373b57a-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/21/2013 4:33 PM, Ira Weiny wrote:
> 

So 2 round trips are now needed for first time ports now to determine
whether or not extended counters are supported. I don't see a better way
around this.

> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/opensm/osm_perfmgr.h |    4 +
>  opensm/osm_perfmgr.c         |  224 +++++++++++++++++++++++++++++++++---------
>  2 files changed, 183 insertions(+), 45 deletions(-)
> 
> diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
> index 26b1ae6..3fa42d5 100644
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
> index 9bc1154..c71111f 100644
> --- a/opensm/osm_perfmgr.c
> +++ b/opensm/osm_perfmgr.c
> @@ -356,17 +356,20 @@ static ib_net16_t get_lid(osm_node_t * p_node, uint8_t port,
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
> @@ -375,7 +378,7 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  	p_madw = osm_mad_pool_get(perfmgr->mad_pool, perfmgr->bind_handle,
>  				  MAD_BLOCK_SIZE, NULL);
>  	if (p_madw == NULL)
> -		return IB_INSUFFICIENT_MEMORY;
> +		return NULL;
>  
>  	pm_mad = osm_madw_get_perfmgt_mad_ptr(p_madw);
>  
> @@ -393,29 +396,38 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  		pm_mad->header.trans_id =
>  		    cl_hton64((uint64_t) cl_atomic_inc(&perfmgr->trans_id) &
>  			      (uint64_t) (0xFFFFFFFF));
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

Nit: formatting (tabs rather than spaces)

> +
> +	OSM_LOG_EXIT(perfmgr->log);
> +
> +	return (p_madw);
> +}
>  
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
> @@ -427,6 +439,39 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
>  		}
>  		perfmgr->sweep_state = PERFMGR_SWEEP_ACTIVE;
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
> +					   osm_madw_context_t * p_context,
> +					   uint8_t sl)
> +{
> +	ib_api_status_t status = IB_SUCCESS;
> +	ib_port_counters_t *port_counter = NULL;
> +	ib_perfmgt_mad_t *pm_mad = NULL;
> +	osm_madw_t *p_madw = NULL;
> +
> +	OSM_LOG_ENTER(perfmgr->log);
> +
> +	p_madw = perfmgr_build_mad(perfmgr, dest_lid, sl, dest_qp, pkey_ix,
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
> @@ -469,6 +514,7 @@ static void collect_guids(cl_map_item_t * p_map_item, void *context)
>  		mon_node->guid = node_guid;
>  		mon_node->name = strdup(node->print_desc);
>  		mon_node->num_ports = num_ports;
> +		mon_node->node_type = node->node_info.node_type;
>  		/* check for enhanced switch port 0 */
>  		mon_node->esp0 = (node->sw &&
>  				  ib_switch_info_is_enhanced_port0(&node->sw->
> @@ -491,6 +537,35 @@ Exit:
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
> +					    osm_madw_context_t * p_context,
> +					    uint8_t sl)
> +{
> +	ib_api_status_t status = IB_SUCCESS;
> +	osm_madw_t *p_madw = NULL;
> +
> +	OSM_LOG_ENTER(pm->log);
> +
> +	p_madw = perfmgr_build_mad(pm, dest_lid, sl, dest_qp,
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
> @@ -557,22 +632,42 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
>  		mad_context.perfmgr_context.node_guid = node_guid;
>  		mad_context.perfmgr_context.port = port;
>  		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_GET;
> +
> +		if (!mon_node->port[port].cpi_valid) {
> +			status = perfmgr_send_cpi_mad(pm, lid, remote_qp,
> +						mon_node->port[port].pkey_ix,
> +						port, &mad_context,
> +						0); /* FIXME SL != 0 */
> +			if (status != IB_SUCCESS)
> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5410: "
> +					"Failed to issue ClassPortInfo query "
> +					"for node 0x%" PRIx64
> +					" port %d (%s)\n",
> +					node->node_info.node_guid, port,
> +					node->print_desc);
> +			if (mon_node->node_type == IB_NODE_TYPE_SWITCH)
> +				goto Exit; /* only need to issue 1 CPI query
> +						for switches */

Have you tried switches with base SP0 ?

> +		} else {
> +
>  #ifdef ENABLE_OSM_PERF_MGR_PROFILE
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
> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5409: "
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
> +						     &mad_context,
> +						     0); /* FIXME SL != 0 */
> +			if (status != IB_SUCCESS)
> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5409: "
> +					"Failed to issue port counter query for node 0x%"
> +					PRIx64 " port %d (%s)\n",
> +					node->node_info.node_guid, port,
> +					node->print_desc);
> +		}
>  	}
>  Exit:
>  	cl_plock_release(&pm->osm->lock);
> @@ -1053,7 +1148,8 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
>  		/* clear port counters */
>  		status = perfmgr_send_pc_mad(pm, lid, remote_qp, pkey_ix,
>  					     port, IB_MAD_METHOD_SET,
> -					     &mad_context);
> +					     &mad_context,
> +					     0); /* FIXME SL != 0 */
>  		if (status != IB_SUCCESS)
>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 5411: "
>  				"Failed to send clear counters MAD for %s (0x%"
> @@ -1187,6 +1283,7 @@ static void pc_recv_process(void *context, void *data)
>  	monitored_node_t *p_mon_node;
>  	int16_t pkey_ix = 0;
>  	boolean_t valid = TRUE;
> +	ib_class_port_info_t *cpi = NULL;
>  
>  	OSM_LOG_ENTER(pm->log);
>  
> @@ -1209,15 +1306,44 @@ static void pc_recv_process(void *context, void *data)
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
> +			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5413: "
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

Shouldn't this be part of if (p_mad->attr_id ==
IB_MAD_ATTR_CLASS_PORT_INFO) clause ?

-- Hal

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
> @@ -1292,20 +1418,28 @@ static void pc_recv_process(void *context, void *data)
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
> +					      port, mad_context,
> +					      0); /* FIXME SL != 0 */
>  		if (status != IB_SUCCESS)
>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
> -				"Failed to send redirected MAD with method 0x%x for node 0x%"
> -				PRIx64 " port %d\n",
> +				"Failed to send redirected MAD "
> +				"with method 0x%x for node %s "
> +				"(NodeGuid 0x%" PRIx64 ") port %d\n",
>  				mad_context->perfmgr_context.mad_method,
> -				node_guid, port);
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
