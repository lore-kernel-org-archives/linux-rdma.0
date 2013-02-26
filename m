From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 02/06] opensm/perfmgr: clean up: break out redirect processing
 from pc_recv_process
Date: Tue, 26 Feb 2013 14:58:01 -0500
Message-ID: <512D13C9.4070309@dev.mellanox.co.il>
References: <20130221133341.0f4083019b5b62c4ca5f24a8@llnl.gov> <512CD620.80009@dev.mellanox.co.il> <20130226113455.e1a10ece200032d8cdf703aa@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130226113455.e1a10ece200032d8cdf703aa-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/26/2013 2:34 PM, Ira Weiny wrote:
> On Tue, 26 Feb 2013 10:34:56 -0500
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 2/21/2013 4:33 PM, Ira Weiny wrote:
>>>
>>>
>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  opensm/osm_perfmgr.c |  200 ++++++++++++++++++++++++--------------------------
>>>  1 files changed, 96 insertions(+), 104 deletions(-)
>>>
>>> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
>>> index c71111f..69b3d77 100644
>>> --- a/opensm/osm_perfmgr.c
>>> +++ b/opensm/osm_perfmgr.c
>>> @@ -1263,6 +1263,96 @@ Exit:
>>>  	return pkey_ix;
>>>  }
>>>  
>>> +static void handle_redirect(osm_perfmgr_t *pm,
>>> +			    ib_class_port_info_t *cpi,
>>> +			    monitored_node_t *p_mon_node,
>>> +			    uint8_t port,
>>> +			    osm_madw_context_t *mad_context)
>>> +{
>>> +	char gid_str[INET6_ADDRSTRLEN];
>>> +	ib_api_status_t status;
>>> +	boolean_t valid = TRUE;
>>> +	int16_t pkey_ix = 0;
>>> +
>>> +	OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> +		"Redirection to LID %u GID %s QP 0x%x received\n",
>>> +		cl_ntoh16(cpi->redir_lid),
>>> +		inet_ntop(AF_INET6, cpi->redir_gid.raw, gid_str,
>>> +			  sizeof gid_str), cl_ntoh32(cpi->redir_qp));
>>> +
>>> +	if (!pm->subn->opt.perfmgr_redir) {
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> +			"Redirection requested but disabled\n");
>>> +		valid = FALSE;
>>> +	}
>>> +
>>> +	/* valid redirection ? */
>>> +	if (cpi->redir_lid == 0) {
>>> +		if (!ib_gid_is_notzero(&cpi->redir_gid)) {
>>> +			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> +				"Invalid redirection "
>>> +				"(both redirect LID and GID are zero)\n");
>>> +			valid = FALSE;
>>> +		}
>>> +	}
>>> +	if (cpi->redir_qp == 0) {
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQP\n");
>>> +		valid = FALSE;
>>> +	}
>>> +	if (cpi->redir_pkey == 0) {
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectP_Key\n");
>>> +		valid = FALSE;
>>> +	}
>>> +	if (cpi->redir_qkey != IB_QP1_WELL_KNOWN_Q_KEY) {
> 
> <comment on my own patch>

This was a transposition of code that already exists and is being moved
into this routine so the comment goes back to that.

Also, this would be separate patch if it's the right thing to do.

> Actually I think this should only be checked if the redir_qp == 1, right?

I'm not sure. ClassPortInfo.RedirectQ_Key on p.747 says "The Q_Key
associated with the RedirectQP. This Q_Key shall be set to the
well known Q_Key".

> 
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQ_Key\n");
>>> +		valid = FALSE;
>>> +	}
>>> +
>>> +	pkey_ix = validate_redir_pkey(pm, cpi->redir_pkey);
>>> +	if (pkey_ix == -1) {
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> +			"Index for Pkey 0x%x not found\n",
>>> +			cl_ntoh16(cpi->redir_pkey));
>>> +		valid = FALSE;
>>> +	}
>>> +
>>> +	if (cpi->redir_lid == 0) {
>>> +		/* GID redirection: get PathRecord information */
>>> +		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> +			"GID redirection not currently supported\n");
>>> +		return;
>>> +	}
>>> +
>>
>> Better with:
>> 	if (!valid)
>> 		return;
>> here ?
>>
> 
> The intention was to mark the port as invalid which would disable polling on this port.  Upon review, I you are right that this is incorrect behaviour.
> 
> However, If you continue with the poll on the original port and the redirect is not supported then you will end up in a loop getting CPI responses without any indication of error...  

That wouldn't be good. Didn't mean to break the logic. I was just trying
to simplify this and maybe went a little too far.

> I would recommend changing the VERBOSE messages above to ERROR entries.  This would allow the user to see that a port is returning a redirect which OpenSM can't handle.

The reason it isn't ERROR level is so that the log isn't spammed with
these messages. To see the error, user could turn on VERBOSE for this
one module using PML.

-- Hal

> 
>>> +	/* LID redirection support (easier than GID redirection) */
>>> +	cl_plock_acquire(&pm->osm->lock);
>>
>> Port number is already validated before handle_redirect is called, right ?
> 
> Yes.
> 
>>
>>> +	p_mon_node->port[port].redirection = TRUE;
>>> +	p_mon_node->port[port].valid = valid;
>>> +	memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
>>> +	       sizeof(ib_gid_t));
>>> +	p_mon_node->port[port].lid = cpi->redir_lid;
>>> +	p_mon_node->port[port].qp = cpi->redir_qp;
>>> +	p_mon_node->port[port].pkey = cpi->redir_pkey;
>>> +	if (pkey_ix != -1)
>>> +		p_mon_node->port[port].pkey_ix = pkey_ix;
>>
>> Add:
>> 	p_mon_node->port[port].cpi_valid = FALSE;
>> here
>>
>>> +	cl_plock_release(&pm->osm->lock);
>>> +
>>> +	if (valid) {
>>
>> If check for valid above LID redirection comment, don't need if (valid)
>> clause here.
> 
> Right.
> 
>>
>>> +		/* Finally, issue a CPI query to the redirected location */
>>> +		cl_plock_acquire(&pm->osm->lock);
>>> +		p_mon_node->port[port].cpi_valid = FALSE;
>>> +		cl_plock_release(&pm->osm->lock);
>>
>> Eliminate extra lock/unlock and move cpi_valid above where indicated.
> 
> Agreed.
> 
> Ira
> 
>>
>> -- Hal
>>
>>> +		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
>>> +					      cpi->redir_qp, pkey_ix,
>>> +					      port, mad_context,
>>> +					      0); /* FIXME SL != 0 */
>>> +		if (status != IB_SUCCESS)
>>> +			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
>>> +				"Failed to send redirected CPI MAD "
>>> +				"for node %s (0x%" PRIx64 ") port %d\n",
>>> +				p_mon_node->name, p_mon_node->guid, port);
>>> +	}
>>> +}
>>> +
>>>  /**********************************************************************
>>>   * The dispatcher uses a thread pool which will call this function when
>>>   * there is a thread available to process the mad received on the wire.
>>> @@ -1281,8 +1371,6 @@ static void pc_recv_process(void *context, void *data)
>>>  	perfmgr_db_data_cnt_reading_t data_reading;
>>>  	cl_map_item_t *p_node;
>>>  	monitored_node_t *p_mon_node;
>>> -	int16_t pkey_ix = 0;
>>> -	boolean_t valid = TRUE;
>>>  	ib_class_port_info_t *cpi = NULL;
>>>  
>>>  	OSM_LOG_ENTER(pm->log);
>>> @@ -1334,112 +1422,15 @@ static void pc_recv_process(void *context, void *data)
>>>  			p_mon_node->port[port].cpi_valid = TRUE;
>>>  		}
>>>  		cl_plock_release(&pm->osm->lock);
>>> -	}
>>> -
>>> -	/* Response could also be redirection (IBM eHCA PMA does this) */
>>> -	if (p_mad->status & IB_MAD_STATUS_REDIRECT) {
>>> -		char gid_str[INET6_ADDRSTRLEN];
>>> -		ib_api_status_t status;
>>>  
>>> -		CL_ASSERT(cpi); /* Redirect should have returned CPI
>>> -					(processed in previous block) */
>>> -
>>> -		OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> -			"Redirection to LID %u GID %s QP 0x%x received\n",
>>> -			cl_ntoh16(cpi->redir_lid),
>>> -			inet_ntop(AF_INET6, cpi->redir_gid.raw, gid_str,
>>> -				  sizeof gid_str), cl_ntoh32(cpi->redir_qp));
>>> +		/* Response could also be redirection (IBM eHCA PMA does this) */
>>> +		if (p_mad->status & IB_MAD_STATUS_REDIRECT)
>>> +			handle_redirect(pm, cpi, p_mon_node, port,
>>> +					mad_context);
>>>  
>>> -		if (!pm->subn->opt.perfmgr_redir) {
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> -				"Redirection requested but disabled\n");
>>> -			valid = FALSE;
>>> -		}
>>> -
>>> -		/* valid redirection ? */
>>> -		if (cpi->redir_lid == 0) {
>>> -			if (!ib_gid_is_notzero(&cpi->redir_gid)) {
>>> -				OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> -					"Invalid redirection "
>>> -					"(both redirect LID and GID are zero)\n");
>>> -				valid = FALSE;
>>> -			}
>>> -		}
>>> -		if (cpi->redir_qp == 0) {
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQP\n");
>>> -			valid = FALSE;
>>> -		}
>>> -		if (cpi->redir_pkey == 0) {
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectP_Key\n");
>>> -			valid = FALSE;
>>> -		}
>>> -		if (cpi->redir_qkey != IB_QP1_WELL_KNOWN_Q_KEY) {
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE, "Invalid RedirectQ_Key\n");
>>> -			valid = FALSE;
>>> -		}
>>> -
>>> -		pkey_ix = validate_redir_pkey(pm, cpi->redir_pkey);
>>> -		if (pkey_ix == -1) {
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> -				"Index for Pkey 0x%x not found\n",
>>> -				cl_ntoh16(cpi->redir_pkey));
>>> -			valid = FALSE;
>>> -		}
>>> -
>>> -		if (cpi->redir_lid == 0) {
>>> -			/* GID redirection: get PathRecord information */
>>> -			OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>> -				"GID redirection not currently supported\n");
>>> -			goto Exit;
>>> -		}
>>> -
>>> -		/* LID redirection support (easier than GID redirection) */
>>> -		cl_plock_acquire(&pm->osm->lock);
>>> -		/* Now, validate port number */
>>> -		if (port >= p_mon_node->num_ports) {
>>> -			cl_plock_release(&pm->osm->lock);
>>> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5413: "
>>> -				"Invalid port num %d for GUID 0x%016"
>>> -				PRIx64 " num ports %d\n", port, node_guid,
>>> -				p_mon_node->num_ports);
>>> -			goto Exit;
>>> -		}
>>> -		p_mon_node->port[port].redirection = TRUE;
>>> -		p_mon_node->port[port].valid = valid;
>>> -		memcpy(&p_mon_node->port[port].gid, &cpi->redir_gid,
>>> -		       sizeof(ib_gid_t));
>>> -		p_mon_node->port[port].lid = cpi->redir_lid;
>>> -		p_mon_node->port[port].qp = cpi->redir_qp;
>>> -		p_mon_node->port[port].pkey = cpi->redir_pkey;
>>> -		if (pkey_ix != -1)
>>> -			p_mon_node->port[port].pkey_ix = pkey_ix;
>>> -		cl_plock_release(&pm->osm->lock);
>>> -
>>> -		if (!valid)
>>> -			goto Exit;
>>> -
>>> -		/* Finally, issue a CPI query to the redirected location */
>>> -		p_mon_node->port[port].cpi_valid = FALSE;
>>> -		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
>>> -					      cpi->redir_qp, pkey_ix,
>>> -					      port, mad_context,
>>> -					      0); /* FIXME SL != 0 */
>>> -		if (status != IB_SUCCESS)
>>> -			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5414: "
>>> -				"Failed to send redirected MAD "
>>> -				"with method 0x%x for node %s "
>>> -				"(NodeGuid 0x%" PRIx64 ") port %d\n",
>>> -				mad_context->perfmgr_context.mad_method,
>>> -				p_mon_node->name, node_guid, port);
>>>  		goto Exit;
>>>  	}
>>>  
>>> -	/* ClassPortInfo needed to process optional Redirection
>>> -	 * now exit normally
>>> -	 */
>>> -	if (p_mad->attr_id == IB_MAD_ATTR_CLASS_PORT_INFO)
>>> -		goto Exit;
>>> -
>>>  	perfmgr_db_fill_err_read(wire_read, &err_reading);
>>>  	/* FIXME separate query for extended counters if they are supported
>>>  	 * on the port.
>>> @@ -1465,7 +1456,8 @@ static void pc_recv_process(void *context, void *data)
>>>  		perfmgr_db_clear_prev_dc(pm->db, node_guid, port);
>>>  	}
>>>  
>>> -	perfmgr_check_overflow(pm, p_mon_node, pkey_ix, port, wire_read);
>>> +	perfmgr_check_overflow(pm, p_mon_node, p_mon_node->port[port].pkey_ix,
>>> +			       port, wire_read);
>>>  
>>>  #ifdef ENABLE_OSM_PERF_MGR_PROFILE
>>>  	do {
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
