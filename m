From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 01/06] opensm/perfmgr: issue ClassPortInfo as first
 query to each port.
Date: Tue, 26 Feb 2013 13:07:11 -0800
Message-ID: <20130226130711.8d96c1834b47c55e2abef24e@llnl.gov>
References: <20130221133331.593f30977427848f4373b57a@llnl.gov>
	<512CCEC7.70304@dev.mellanox.co.il>
	<20130226105803.c3bae4bdd1d2af03bce373db@llnl.gov>
	<512D118A.5010503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512D118A.5010503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 26 Feb 2013 14:48:26 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 2/26/2013 1:58 PM, Ira Weiny wrote:
> > On Tue, 26 Feb 2013 10:03:35 -0500
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >> On 2/21/2013 4:33 PM, Ira Weiny wrote:
> >>>

[snip]

> >>> +/**********************************************************************
> >>>   * query the Port Counters of all the nodes in the subnet.
> >>>   **********************************************************************/
> >>>  static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
> >>> @@ -557,22 +632,42 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
> >>>  		mad_context.perfmgr_context.node_guid = node_guid;
> >>>  		mad_context.perfmgr_context.port = port;
> >>>  		mad_context.perfmgr_context.mad_method = IB_MAD_METHOD_GET;
> >>> +
> >>> +		if (!mon_node->port[port].cpi_valid) {
> >>> +			status = perfmgr_send_cpi_mad(pm, lid, remote_qp,
> >>> +						mon_node->port[port].pkey_ix,
> >>> +						port, &mad_context,
> >>> +						0); /* FIXME SL != 0 */
> >>> +			if (status != IB_SUCCESS)
> >>> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5410: "
> >>> +					"Failed to issue ClassPortInfo query "
> >>> +					"for node 0x%" PRIx64
> >>> +					" port %d (%s)\n",
> >>> +					node->node_info.node_guid, port,
> >>> +					node->print_desc);
> >>> +			if (mon_node->node_type == IB_NODE_TYPE_SWITCH)
> >>> +				goto Exit; /* only need to issue 1 CPI query
> >>> +						for switches */
> >>
> >> Have you tried switches with base SP0 ?
> > 
> > Yes.  Why?  I admit I may be confused about when SP0 is different from physical ports.
> 
> The reason I asked here is that the ClassPortInfo when BSP0 is being
> requested on port 1 not 0.
> 
> I'm not sure what you're referring to in terms of SP0 being different
> from physical ports so I'll elaborate on what I think you may be asking:
> 
> In general, BSP0 is different than ESP0 in terms of PMA attributes in
> that it is excluded in PortSelect. PortSelect says "However, 0 is
> only valid for the enhanced switch management port; it is
> ignored for the base switch management port."

Right, BSP0 doesn't have PM counters.  So why did you ask if I had tried this with base SP0?

To be clear I have tried this with both Enhanced SP0 and Base SP0 and it seems to work correctly.

Ira

> 
> SP0 is different from physical ports in that it's a virtual IB port
> (usually across CPU link or the like) and doesn't have a remote peer.
> 
> >>
> >>> +		} else {
> >>> +
> >>>  #ifdef ENABLE_OSM_PERF_MGR_PROFILE
> >>> -		gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
> >>> +			gettimeofday(&mad_context.perfmgr_context.query_start, NULL);
> >>>  #endif
> >>> -		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
> >>> -			PRIx64 " port %d (lid %u) (%s)\n", node_guid, port,
> >>> -			cl_ntoh16(lid), node->print_desc);
> >>> -		status = perfmgr_send_pc_mad(pm, lid, remote_qp,
> >>> -					     mon_node->port[port].pkey_ix,
> >>> -					     port, IB_MAD_METHOD_GET,
> >>> -					     &mad_context);
> >>> -		if (status != IB_SUCCESS)
> >>> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5409: "
> >>> -				"Failed to issue port counter query for node 0x%"
> >>> -				PRIx64 " port %d (%s)\n",
> >>> -				node->node_info.node_guid, port,
> >>> -				node->print_desc);
> >>> +			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Getting stats for node 0x%"
> >>> +				PRIx64 " port %d (lid %u) (%s)\n", node_guid, port,
> >>> +				cl_ntoh16(lid), node->print_desc);
> >>> +			status = perfmgr_send_pc_mad(pm, lid, remote_qp,
> >>> +						     mon_node->port[port].pkey_ix,
> >>> +						     port, IB_MAD_METHOD_GET,
> >>> +						     &mad_context,
> >>> +						     0); /* FIXME SL != 0 */
> >>> +			if (status != IB_SUCCESS)
> >>> +				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5409: "
> >>> +					"Failed to issue port counter query for node 0x%"
> >>> +					PRIx64 " port %d (%s)\n",
> >>> +					node->node_info.node_guid, port,
> >>> +					node->print_desc);
> >>> +		}
> >>>  	}
> >>>  Exit:
> >>>  	cl_plock_release(&pm->osm->lock);
> >>> @@ -1053,7 +1148,8 @@ static void perfmgr_check_overflow(osm_perfmgr_t * pm,
> >>>  		/* clear port counters */
> >>>  		status = perfmgr_send_pc_mad(pm, lid, remote_qp, pkey_ix,
> >>>  					     port, IB_MAD_METHOD_SET,
> >>> -					     &mad_context);
> >>> +					     &mad_context,
> >>> +					     0); /* FIXME SL != 0 */
> >>>  		if (status != IB_SUCCESS)
> >>>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr: ERR 5411: "
> >>>  				"Failed to send clear counters MAD for %s (0x%"
> >>> @@ -1187,6 +1283,7 @@ static void pc_recv_process(void *context, void *data)
> >>>  	monitored_node_t *p_mon_node;
> >>>  	int16_t pkey_ix = 0;
> >>>  	boolean_t valid = TRUE;
> >>> +	ib_class_port_info_t *cpi = NULL;
> >>>  
> >>>  	OSM_LOG_ENTER(pm->log);
> >>>  
> >>> @@ -1209,15 +1306,44 @@ static void pc_recv_process(void *context, void *data)
> >>>  	CL_ASSERT(p_mad->attr_id == IB_MAD_ATTR_PORT_CNTRS ||
> >>>  		  p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO);
> >>>  
> >>> +	/* capture CLASS_PORT_INFO data */
> >>> +	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
> >>> +		cpi = (ib_class_port_info_t *) &
> >>> +		    (osm_madw_get_perfmgt_mad_ptr(p_madw)->data);
> >>> +
> >>> +		cl_plock_acquire(&pm->osm->lock);
> >>> +		/* validate port number */
> >>> +		if (port >= p_mon_node->num_ports) {
> >>> +			cl_plock_release(&pm->osm->lock);
> >>> +			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5413: "
> >>> +				"Invalid port num %d for GUID 0x%016"
> >>> +				PRIx64 " num ports %d\n", port, node_guid,
> >>> +				p_mon_node->num_ports);
> >>> +			goto Exit;
> >>> +		}
> >>> +		if (p_mon_node->node_type == IB_NODE_TYPE_SWITCH) {
> >>> +			int i = 0;
> >>> +			for (i = p_mon_node->esp0 ? 0 : 1;
> >>> +			     i < p_mon_node->num_ports;
> >>> +			     i++) {
> >>> +				p_mon_node->port[i].cap_mask = cpi->cap_mask;
> >>> +				p_mon_node->port[i].cpi_valid = TRUE;
> >>> +			}
> >>> +		} else {
> >>> +			p_mon_node->port[port].cap_mask = cpi->cap_mask;
> >>> +			p_mon_node->port[port].cpi_valid = TRUE;
> >>> +		}
> >>> +		cl_plock_release(&pm->osm->lock);
> >>> +	}
> >>> +
> >>>  	/* Response could also be redirection (IBM eHCA PMA does this) */
> >>> -	if (p_mad->status & IB_MAD_STATUS_REDIRECT &&
> >>> -	    p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO) {
> >>> +	if (p_mad->status & IB_MAD_STATUS_REDIRECT) {
> >>
> >> Shouldn't this be part of if (p_mad->attr_id ==
> >> IB_MAD_ATTR_CLASS_PORT_INFO) clause ?
> >>
> > 
> > Yes but I took care of that in the next patch where I cleaned up the code and made that entire block a function "handle_redirect".
> 
> I see that now. The semantics here shouldn't have been changed but it's
> probably OK that the next patch fixes that again.
> 
> -- Hal
> 
> > Ira
> 
> <snip...>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
