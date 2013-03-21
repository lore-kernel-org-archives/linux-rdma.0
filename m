From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 07/07] opensm/perfmgr: add sl support
Date: Thu, 21 Mar 2013 11:00:55 -0400
Message-ID: <514B20A7.100@dev.mellanox.co.il>
References: <51485F74.1010701@dev.mellanox.co.il> <5148936C.4010605@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510EBB3F3B@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB3F3B-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/19/2013 9:00 PM, Weiny, Ira wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
>> Sent: Tuesday, March 19, 2013 9:34 AM
>> To: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>> Subject: Re: [PATCH 07/07] opensm/perfmgr: add sl support
>>
>>
>> This doesn't appear to have made it to the list so I'm resending.
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH 07/07] opensm/perfmgr: add sl support
>> Date: Tue, 19 Mar 2013 08:52:04 -0400
>> From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> Reply-To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> To: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> CC: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> On 2/28/2013 8:09 PM, Ira Weiny wrote:
>>>
>>> SL's are queried internally when running in a master SM
>>
>> Similarly, does PerfMgr really need it's own discovery code when not in
>> standalone mode or could this also be gleaned from existing data SM
>> structures ?
> 
> Yes it could be, however, issuing internal "queries" seemed cleaner.
> 
>>
>>> and queried from the SA when running in a standby or inactive SM.
>>>
>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  include/opensm/osm_perfmgr.h |   11 ++
>>>  opensm/osm_perfmgr.c         |  345
>> +++++++++++++++++++++++++++++++++++++++---
>>>  2 files changed, 336 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/include/opensm/osm_perfmgr.h
>>> b/include/opensm/osm_perfmgr.h index 4141d41..5ca1cf4 100644
>>> --- a/include/opensm/osm_perfmgr.h
>>> +++ b/include/opensm/osm_perfmgr.h
>>> @@ -2,6 +2,7 @@
>>>   * Copyright (c) 2007 The Regents of the University of California.
>>>   * Copyright (c) 2007-2009 Voltaire, Inc. All rights reserved.
>>>   * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
>>> + * Copyright (c) 2013 Lawrence Livermore National Security, All
>>> + rights reserved
>>>   *
>>>   * This software is available to you under a choice of one of two
>>>   * licenses.  You may choose to be licensed under the terms of the
>>> GNU @@ -90,6 +91,11 @@ typedef enum {
>>>  	PERFMGR_SWEEP_SUSPENDED
>>>  } osm_perfmgr_sweep_state_t;
>>>
>>> +typedef struct pr_map_item {
>>> +	cl_map_item_t map_item;
>>> +	ib_path_rec_t pr;
>>> +} pr_map_item_t;
>>> +
>>>  typedef struct monitored_port {
>>>  	uint16_t pkey_ix;
>>>  	ib_net16_t orig_lid;
>>> @@ -150,6 +156,11 @@ typedef struct osm_perfmgr {
>>>  	int16_t local_port;
>>>  	int rm_nodes;
>>>  	boolean_t query_cpi;
>>> +	cl_qmap_t path_rec_map;
>>
>> Where does cleanup of path_rec_map occur ? Did I miss that ?
> 
> Insert_pr_map will remove entries when new ones with that DLID are added.
> 
> I did not clean up on exit.  I'll add that.
> 
>>
>>> +	/* when operating in stand alone mode we are required to query the
>>> +	 * remote master SA */
>>> +	osm_bind_handle_t sa_bind_handle;
>>> +	int pr_query_outstanding;
>>>  } osm_perfmgr_t;
>>>  /*
>>>  * FIELDS
>>> diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c index
>>> 9df28f9..b1cd419 100644
>>> --- a/opensm/osm_perfmgr.c
>>> +++ b/opensm/osm_perfmgr.c
>>> @@ -2,7 +2,7 @@
>>>   * Copyright (c) 2007 The Regents of the University of California.
>>>   * Copyright (c) 2007-2009 Voltaire, Inc. All rights reserved.
>>>   * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
>>> - * Copyright (c) 2013 Lawrence Livermore National Security. All rights *
>> reserved.
>>> + * Copyright (c) 2013 Lawrence Livermore National Security. All rights
>> reserved.
>>>   *
>>>   * This software is available to you under a choice of one of two
>>>   * licenses.  You may choose to be licensed under the terms of the
>>> GNU @@ -123,6 +123,7 @@ static inline void diff_time(struct timeval
>>> *before, struct timeval *after,  static void
>>> init_monitored_nodes(osm_perfmgr_t * pm)  {
>>>  	cl_qmap_init(&pm->monitored_map);
>>> +	cl_qmap_init(&pm->path_rec_map);
>>>  	pm->remove_list = NULL;
>>>  	cl_event_construct(&pm->sig_query);
>>>  	cl_event_init(&pm->sig_query, FALSE); @@ -254,6 +255,10 @@ Exit:
>>>  	OSM_LOG_EXIT(pm->log);
>>>  }
>>>
>>> +static void perfmgr_sa_mad_recv_cb(osm_madw_t * p_madw, void
>> *bind_context,
>>> +				osm_madw_t * p_req_madw);
>>> +static void perfmgr_sa_mad_send_err_cb(void *bind_context,
>>> +				osm_madw_t * p_madw);
>>>
>> /**********************************************************
>> ************
>>>   * Bind the PerfMgr to the vendor layer for MAD sends/receives
>>>
>>>
>> **********************************************************
>> ************
>>> / @@ -294,6 +299,22 @@ ib_api_status_t
>> osm_perfmgr_bind(osm_perfmgr_t
>>> * pm, ib_net64_t port_guid)
>>>  		OSM_LOG(pm->log, OSM_LOG_ERROR,
>>>  			"ERR 5404: Vendor specific bind failed (%s)\n",
>>>  			ib_get_err_str(status));
>>> +		goto Exit;
>>> +	}
>>> +
>>> +	bind_info.mad_class = IB_MCLASS_SUBN_ADM;
>>> +	bind_info.class_version = 2;
>>
>> Are any other bind parameters needed ?
> 
> None that are different from the previous bind.  One could argue for different timeout/retry parameters 
> but we would have to add those to the config file which don't exist now.

OK; I see those parameters set by the existing bind for PerfMgr class.

> 
>>
>>> +
>>> +	pm->sa_bind_handle = osm_vendor_bind(pm->vendor, &bind_info,
>>> +					     pm->mad_pool,
>>> +					     perfmgr_sa_mad_recv_cb,
>>> +					     perfmgr_sa_mad_send_err_cb,
>> pm);
>>
>> Why not only do this when in standalone mode ? Is that due to the bind
>> being needed based on SM state and that isn't known here ?
> 
> Yes.  Also we could be master and then be reduced to standby mode later.  
> The bind is inexpensive and seemed reasonable to just have available regardless of mode.

It's not the expense of the bind that concerns me; it's opening the
unnecessary "door" for additional received MADs that does.

> 
>>
>>> +
>>> +	if (pm->sa_bind_handle == OSM_BIND_INVALID_HANDLE) {
>>> +		status = IB_ERROR;
>>> +		OSM_LOG(pm->log, OSM_LOG_ERROR,
>>> +			"ERR 540E: PM SA bind failed (%s)\n",
>>> +			ib_get_err_str(status));
>>>  	}
>>>
>>>  Exit:
>>> @@ -307,12 +328,17 @@ Exit:
>>>  static void perfmgr_mad_unbind(osm_perfmgr_t * pm)  {
>>>  	OSM_LOG_ENTER(pm->log);
>>> -	if (pm->bind_handle == OSM_BIND_INVALID_HANDLE) {
>>> +
>>> +	if (pm->bind_handle == OSM_BIND_INVALID_HANDLE)
>>>  		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 5405: No
>> previous bind\n");
>>> -		goto Exit;
>>> -	}
>>> -	osm_vendor_unbind(pm->bind_handle);
>>> -Exit:
>>> +	else
>>> +		osm_vendor_unbind(pm->bind_handle);
>>> +
>>> +	if (pm->sa_bind_handle == OSM_BIND_INVALID_HANDLE)
>>> +		OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 540F: No
>> previous SA bind\n");
>>> +	else
>>> +		osm_vendor_unbind(pm->sa_bind_handle);
>>> +
>>>  	OSM_LOG_EXIT(pm->log);
>>>  }
>>>
>>> @@ -330,6 +356,250 @@ static ib_net32_t get_qp(monitored_node_t *
>> mon_node, uint8_t port)
>>>  	return qp;
>>>  }
>>>
>>> +static inline boolean_t sm_not_active(osm_perfmgr_t *pm) {
>>> +	return (pm->subn->sm_state == IB_SMINFO_STATE_STANDBY ||
>>> +		pm->subn->sm_state == IB_SMINFO_STATE_NOTACTIVE); }
>>> +
>>> +static int get_sm_info(osm_perfmgr_t *pm, ib_net16_t *smlid, uint8_t
>>> +*smsl) {
>>> +	int i, rc = -1;
>>> +	uint32_t num_ports = 32;
>>> +	ib_port_attr_t attr_array[32];
>>
>> 64 is better as there are 36 port switches. Also, this should be a define.
> 
> Agreed.  However, in the case of a switch the PM should be running on port 0 only right?

Yes, in the case of a switch, PM could run on port 0.

>>
>>> +
>>> +	osm_vendor_get_all_port_attr(pm->vendor, attr_array,
>> &num_ports);
>>> +
>>> +	for(i = 0; i<num_ports; i++) {
>>> +		if (attr_array[i].port_guid == pm->port_guid) {
>>> +			*smlid = attr_array[i].sm_lid;
>>> +			*smsl = attr_array[i].sm_sl;
>>> +			rc = 0;
>>> +		}
>>> +	}
>>> +
>>> +	return (rc);
>>> +}
>>> +
>>> +static void insert_pr_map(osm_perfmgr_t *pm,  ib_path_rec_t *pr) {
>>> +	pr_map_item_t *mi = calloc(1, sizeof(*mi));
>>> +	if (mi) {
>>> +		cl_map_item_t *tmp;
>>> +		if ((tmp = cl_qmap_get(&pm->path_rec_map, (uint64_t)pr-
>>> dlid))
>>> +				!= cl_qmap_end(&pm->path_rec_map)) {
>>> +			cl_qmap_remove_item(&pm->path_rec_map, tmp);
>>> +			free(tmp);
>>> +		}
>>> +		memcpy(&mi->pr, pr, sizeof(mi->pr));
>>> +		cl_qmap_insert(&pm->path_rec_map, (uint64_t)pr->dlid,
>>> +		       (cl_map_item_t *) mi);
>>> +	} else {
>>> +		OSM_LOG(pm->log, OSM_LOG_ERROR,
>>> +			"ERR 54FC: Failed to allocate path "
>>> +			"record map item for DLID %d",
>>
>> LIDs should be formatted as %u
> 
> Ok.
> 
>>
>>> +			cl_ntoh16(pr->dlid));
>>> +	}
>>> +}
>>> +
>>> +/**
>>>
>> +=========================================================
>> ============
>>> +====
>>> + * SA query call backs for the sa_bind_handle  */ static void
>>> +perfmgr_sa_mad_recv_cb(osm_madw_t * p_madw, void *bind_context,
>>> +				   osm_madw_t * p_req_madw)
>>> +{
>>> +	osm_perfmgr_t *pm = (osm_perfmgr_t *) bind_context;
>>> +	ib_sa_mad_t *sa_mad;
>>> +	int num_results;
>>> +	int i;
>>> +
>>> +	OSM_LOG_ENTER(pm->log);
>>> +
>>> +	osm_madw_copy_context(p_madw, p_req_madw);
>>> +	osm_mad_pool_put(pm->mad_pool, p_req_madw);
>>> +
>>> +	sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
>>> +
>>> +	num_results = (p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
>>> +				(sa_mad->attr_offset << 3);
>>> +
>>> +	for (i = 0; i < num_results; i++) {
>>> +		ib_path_rec_t *pr = (ib_path_rec_t *)
>>> +				(sa_mad->data + (i*sizeof(ib_path_rec_t)));
>>> +
>>> +		/* only want reversible paths */
>>> +		if ((pr->num_path & 0x80) == 0)
>>
>> Shouldn't this just be part of the query and wouldn't need checking here ?
> 
> Yea that would be better.
> 
>>
>>> +			continue;
>>> +
>>> +		insert_pr_map(pm, pr);
>>> +	}
>>> +
>>> +	osm_mad_pool_put(pm->mad_pool, p_madw);
>>> +	pm->pr_query_outstanding = 0;
>>> +
>>> +	OSM_LOG_EXIT(pm->log);
>>> +}
>>> +
>>> +static void perfmgr_sa_mad_send_err_cb(void *bind_context,
>> osm_madw_t
>>> +* p_madw) {
>>> +	osm_perfmgr_t *pm = (osm_perfmgr_t *) bind_context;
>>> +	OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 540D: PM PathRecord
>> query "
>>> +		"failed; sm LID %u MAD TID 0x%" PRIx64 "\n",
>>> +		cl_ntoh16(p_madw->mad_addr.dest_lid),
>>> +		cl_ntoh64(p_madw->p_mad->trans_id));
>>> +	pm->pr_query_outstanding = -1;
>>> +}
>>> +
>>> +static void create_half_world_query(osm_perfmgr_t *pm, ib_sa_mad_t
>>> +*sa_mad) {
>>> +	ib_path_rec_t *pr = (ib_path_rec_t *)sa_mad->data;
>>> +
>>> +	sa_mad->base_ver = 1;
>>> +	sa_mad->mgmt_class = IB_MCLASS_SUBN_ADM;
>>> +	sa_mad->class_ver = 2;
>>> +	sa_mad->method = IB_MAD_METHOD_GETTABLE;
>>> +	sa_mad->status = 0;
>>> +	sa_mad->trans_id =
>>> +	    cl_hton64((uint64_t) cl_atomic_inc(&pm->trans_id) &
>>> +		      (uint64_t) (0xFFFFFFFF));
>>> +	if (sa_mad->trans_id == 0)
>>> +		sa_mad->trans_id =
>>> +		    cl_hton64((uint64_t) cl_atomic_inc(&pm->trans_id) &
>>> +			      (uint64_t) (0xFFFFFFFF));
>>> +	sa_mad->attr_id = IB_MAD_ATTR_PATH_RECORD;
>>> +	sa_mad->attr_mod = 0;
>>> +
>>> +	pr->slid = osm_port_get_base_lid(osm_get_port_by_guid(pm-
>>> subn,
>>> +							pm->port_guid));
>>> +	sa_mad->comp_mask = IB_PR_COMPMASK_SLID;
>>
>> Although OpenSM supports this, it would be best to have this as compliant
>> query which requires NumbPath and SGID. Also, previously discussed adding
>> in Reversible.
> 
> Agreed.
> 
>>
>>> +}
>>> +
>>> +static int send_sa_pr_query(osm_perfmgr_t *pm) {
>>> +	ib_sa_mad_t *sa_mad = NULL;
>>> +	osm_madw_t *p_madw = NULL;
>>> +	ib_net16_t smlid;
>>> +	uint8_t smsl;
>>> +
>>> +	if (get_sm_info(pm, &smlid, &smsl) < 0) {
>>> +	        OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 54FE: "
>>> +	                "PM failed to find SM LID & SL for PR query\n");
>>> +		return (-1);
>>> +	}
>>> +
>>> +	p_madw = osm_mad_pool_get(pm->mad_pool, pm-
>>> sa_bind_handle,
>>> +				  MAD_BLOCK_SIZE, NULL);
>>> +	if (p_madw == NULL)
>>> +		return -1;
>>> +
>>> +	sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
>>> +
>>> +	create_half_world_query(pm, sa_mad);
>>> +
>>> +	p_madw->mad_addr.dest_lid = smlid;
>>> +	p_madw->mad_addr.addr_type.gsi.remote_qp = 1;
>>> +	p_madw->mad_addr.addr_type.gsi.remote_qkey =
>>> +	    cl_hton32(IB_QP1_WELL_KNOWN_Q_KEY);
>>> +	p_madw->mad_addr.addr_type.gsi.pkey_ix = 0;
>>> +	p_madw->mad_addr.addr_type.gsi.service_level = smsl;
>>> +	p_madw->mad_addr.addr_type.gsi.global_route = FALSE;
>>> +	p_madw->resp_expected = TRUE;
>>> +
>>> +	if (osm_vendor_send(pm->sa_bind_handle, p_madw, TRUE)
>>> +	    != IB_SUCCESS)
>>> +		return (-1);
>>> +
>>> +	return (0);
>>> +}
>>> +
>>> +static int get_internal_pr(osm_perfmgr_t *pm) {
>>> +	ib_sa_mad_t sa_mad;
>>> +	const osm_alias_guid_t *p_src_alias_guid, *p_dest_alias_guid;
>>> +	const osm_port_t *p_src_port, *p_dest_port;
>>> +	const ib_gid_t *p_sgid = NULL, *p_dgid = NULL;
>>> +	osm_port_t *p_local_port;
>>> +	cl_qlist_t pr_list;
>>> +	cl_list_item_t *item;
>>> +	unsigned num_rec, i;
>>> +
>>> +	create_half_world_query(pm, &sa_mad);
>>> +
>>
>> Doesn't the SMDB RO lock needs to be held here or is it already held when
>> reaching here ?
> 
> Yes, I think so.  I think I had it locked around get_internal_pr in a previous version but it is not now.  So yes.
> 
>>
>>> +	osm_pr_get_end_points(&pm->osm->sa, &sa_mad,
>>> +			&p_src_alias_guid, &p_dest_alias_guid,
>>> +			&p_src_port, &p_dest_port,
>>> +			&p_sgid, &p_dgid);
>>> +
>>> +	cl_qlist_init(&pr_list);
>>> +	p_local_port = osm_get_port_by_guid(pm->subn, pm->port_guid);
>>> +
>>> +	/* Get all alias GUIDs for the src port */
>>> +	p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&pm->subn-
>>> alias_port_guid_tbl);
>>> +	while (p_src_alias_guid !=
>>> +	       (osm_alias_guid_t *)
>>> +cl_qmap_end(&pm->subn->alias_port_guid_tbl)) {
>>> +
>>> +		if (osm_get_port_by_alias_guid(pm->subn,
>> p_src_alias_guid->alias_guid)
>>> +		    == p_src_port) {
>>
>> Only base port GUIDs need checking.
> 
> So you just need this?
> 
> 	osm_pr_process_half(&pm->osm->sa, &sa_mad, p_local_port,
> 						p_src_alias_guid,
> 						p_dest_alias_guid,
> 						p_sgid, p_dgid, &pr_list);
> 
> No loop?

A loop is needed to filter the response and only use the base port GUIDs.

>>
>>> +			osm_pr_process_half(&pm->osm->sa, &sa_mad,
>> p_local_port,
>>> +						p_src_alias_guid,
>> p_dest_alias_guid,
>>> +						p_sgid, p_dgid, &pr_list);
>>> +		}
>>> +
>>> +		p_src_alias_guid = (osm_alias_guid_t *)
>> cl_qmap_next(&p_src_alias_guid->map_item);
>>> +	}
>>> +
>>
>> SMDB RO lock would be released here if it's grabbed above.
> 
> Yes
> 
>>
>>> +	num_rec = cl_qlist_count(&pr_list);
>>> +	for (i = 0; i < num_rec; i++) {
>>> +		ib_path_rec_t *pr;
>>> +		item = cl_qlist_remove_head(&pr_list);
>>> +		pr = (ib_path_rec_t *)((osm_sa_item_t *)item)->resp.data;
>>> +
>>> +		/* only want reversible paths */
>>> +		if ((pr->num_path & 0x80) == 0)
>>> +			continue;
>>> +
>>> +		insert_pr_map(pm, pr);
>>> +		free(item);
>>> +	}
>>> +	pm->pr_query_outstanding = 0;
>>> +	return (0);
>>> +}
>>> +
>>> +static ib_path_rec_t * get_pr_from_pr_map(osm_perfmgr_t *pm,
>>> +ib_net16_t dlid) {
>>> +	cl_map_item_t *mi;
>>> +	if ((mi = cl_qmap_get(&pm->path_rec_map, (uint64_t)dlid)) !=
>>> +	     cl_qmap_end(&pm->path_rec_map)) {
>>> +		pr_map_item_t *pr = (pr_map_item_t *)mi;
>>> +		return (&pr->pr);
>>> +	}
>>> +	return (NULL);
>>> +}
>>> +
>>> +static int8_t get_sl(osm_perfmgr_t *pm, monitored_node_t *
>> mon_node,
>>> +uint8_t port) {
>>> +	uint16_t dlid;
>>> +	ib_path_rec_t *pr;
>>> +
>>> +	if (!mon_node || port >= mon_node->num_ports)
>>> +		return (-1);
>>> +
>>> +	dlid = mon_node->port[port].redirection ?
>>> +				mon_node->port[port].lid :
>>> +				mon_node->port[port].orig_lid;
>>> +	pr = get_pr_from_pr_map(pm, dlid);
>>> +	if (pr) {
>>> +		OSM_LOG(pm->log, OSM_LOG_DEBUG, "PM %s port %d ->
>> SL 0x%x\n",
>>> +			mon_node->name, port, ib_path_rec_sl(pr));
>>> +		return ((int8_t)ib_path_rec_sl(pr));
>>> +	}
>>> +
>>> +	OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 54FD: "
>>> +		"PM failed to find SL for %s port %d\n",
>>> +		mon_node->name, port);
>>> +	return (-1);
>>> +}
>>> +
>>>  static ib_net16_t get_base_lid(osm_node_t * p_node, uint8_t port)  {
>>>  	switch (p_node->node_info.node_type) { @@ -683,6 +953,7 @@
>> static
>>> void perfmgr_query_counters(cl_map_item_t * p_map_item, void
>> *context)
>>>  	/* issue the query for each port */
>>>  	for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
>>>  		ib_net16_t lid;
>>> +		int8_t sl;
>>>
>>>  		if (!osm_node_get_physp_ptr(node, port))
>>>  			continue;
>>> @@ -700,6 +971,9 @@ static void perfmgr_query_counters(cl_map_item_t
>> * p_map_item, void *context)
>>>  		}
>>>
>>>  		remote_qp = get_qp(mon_node, port);
>>> +		sl = get_sl(pm, mon_node, port);
>>> +		if (sl < 0)
>>> +			continue;
>>>
>>>  		mad_context.perfmgr_context.node_guid = node_guid;
>>>  		mad_context.perfmgr_context.port = port; @@ -709,7
>> +983,7 @@ static
>>> void perfmgr_query_counters(cl_map_item_t * p_map_item, void
>> *context)
>>>  			status = perfmgr_send_cpi_mad(pm, lid, remote_qp,
>>>  						mon_node-
>>> port[port].pkey_ix,
>>>  						port, &mad_context,
>>> -						0); /* FIXME SL != 0 */
>>> +						sl);
>>>  			if (status != IB_SUCCESS)
>>>  				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR
>> 5410: "
>>>  					"Failed to issue ClassPortInfo query "
>>> @@ -733,7 +1007,7 @@ static void
>> perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
>>>  						     port,
>> IB_MAD_METHOD_GET,
>>>  						     0xffff,
>>>  						     &mad_context,
>>> -						     0); /* FIXME SL != 0 */
>>> +						     sl);
>>>  			if (status != IB_SUCCESS)
>>>  				OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR
>> 5409: "
>>>  					"Failed to issue port counter query
>> for node 0x%"
>>> @@ -751,7 +1025,7 @@ static void
>> perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
>>>  							      port,
>>>
>> IB_MAD_METHOD_GET,
>>>  							      &mad_context,
>>> -							      0); /* FIXME SL !=
>> 0 */
>>> +							      sl);
>>>  				if (status != IB_SUCCESS)
>>>  					OSM_LOG(pm->log,
>> OSM_LOG_ERROR,
>>>  						"ERR 5417: Failed to issue "
>>> @@ -1007,8 +1281,7 @@ void osm_perfmgr_process(osm_perfmgr_t *
>> pm)
>>>  	pm->sweep_state = PERFMGR_SWEEP_ACTIVE;
>>>  	cl_spinlock_release(&pm->lock);
>>>
>>> -	if (pm->subn->sm_state == IB_SMINFO_STATE_STANDBY ||
>>> -	    pm->subn->sm_state == IB_SMINFO_STATE_NOTACTIVE)
>>> +	if (sm_not_active(pm))
>>>  		perfmgr_discovery(pm->subn->p_osm);
>>>
>>>  	/* if redirection enabled, determine local port */ @@ -1034,6
>>> +1307,18 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)  #ifdef
>>> ENABLE_OSM_PERF_MGR_PROFILE
>>>  	gettimeofday(&before, NULL);
>>>  #endif
>>> +	pm->pr_query_outstanding = 1;
>>> +	if (sm_not_active(pm)) {
>>> +		/* FIXME register for UnPath/RePath rather than reissue
>> query */
>>> +		if (send_sa_pr_query(pm)) {
>>> +			OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 542F: "
>>> +					"PM PathRecord query send
>> failed\n");
>>> +			pm->pr_query_outstanding = -1;
>>> +		}
>>> +	} else {
>>> +		get_internal_pr(pm);
>>> +	}
>>> +
>>>  	/* With the global lock held, collect the node guids */
>>>  	/* FIXME we should be able to track SA notices
>>>  	 * and not have to sweep the node_guid_tbl each pass @@ -1043,8
>>> +1328,15 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
>>>  	cl_qmap_apply_func(&pm->subn->node_guid_tbl, collect_guids,
>> pm);
>>>  	cl_plock_release(&pm->osm->lock);
>>>
>>> -	/* then for each node query their counters */
>>> -	cl_qmap_apply_func(&pm->monitored_map,
>> perfmgr_query_counters, pm);
>>> +	/* Wait for PR query to complete */
>>> +	while(pm->pr_query_outstanding == 1)
>>> +		;
>>
>> A better way to wait for PR response/timeout should be used.
> 
> What is most concerning, the fear of an endless loop, or the busy waiting?

I was concerned with the busy waiting.

> In the former the vendor mad layer would have to fail.  
> For the later we could add sleeps but that seemed inefficient.
> Adding another timer also seems like a waste since in the stand alone mode we are simply waiting for the query to return and in the integrated mode this is effectively a no-op.

In standalone mode, aren't there still other threads ? While this thread
is busy waiting, what are the other threads doing ?

-- Hal

> Ira
> 
>>
>> -- Hal
>>
>>> +
>>> +	if (pm->pr_query_outstanding == 0) {
>>> +		cl_qmap_apply_func(&pm->monitored_map,
>> perfmgr_query_counters, pm);
>>> +	} else {
>>> +		pm->pr_query_outstanding = 0;
>>> +	}
>>>
>>>  	/* clean out any nodes found to be removed during the sweep */
>>>  	remove_marked_nodes(pm);
>>> @@ -1235,6 +1527,7 @@ static void
>> perfmgr_check_overflow(osm_perfmgr_t * pm,
>>>  	     counter_overflow_32(pc->rcv_pkts)))) {
>>>  		osm_node_t *p_node = NULL;
>>>  		ib_net16_t lid = 0;
>>> +		int8_t sl;
>>>
>>>  		if (!mon_node->port[port].valid)
>>>  			goto Exit;
>>> @@ -1244,6 +1537,9 @@ static void
>> perfmgr_check_overflow(osm_perfmgr_t * pm,
>>>  			   ") port %d; clearing counters\n",
>>>  			   mon_node->name, mon_node->guid, port);
>>>
>>> +		if ((sl = get_sl(pm, mon_node, port)) < 0)
>>> +			goto Exit;
>>> +
>>>  		cl_plock_acquire(&pm->osm->lock);
>>>  		p_node =
>>>  		    osm_get_node_by_guid(pm->subn,
>> cl_hton64(mon_node->guid)); @@
>>> -1276,8 +1572,7 @@ static void perfmgr_check_overflow(osm_perfmgr_t *
>> pm,
>>>  		status = perfmgr_send_pc_mad(pm, lid, remote_qp,
>> pkey_ix,
>>>  					     port, IB_MAD_METHOD_SET,
>>>  					     counter_select,
>>> -					     &mad_context,
>>> -					     0); /* FIXME SL != 0 */
>>> +					     &mad_context, sl);
>>>  		if (status != IB_SUCCESS)
>>>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr:
>> ERR 5411: "
>>>  				"Failed to send clear counters MAD for %s
>> (0x%"
>>> @@ -1320,6 +1615,7 @@ static void
>> perfmgr_check_pce_overflow(osm_perfmgr_t * pm,
>>>  	    counter_overflow_64(pc->multicast_rcv_pkts)))) {
>>>  		osm_node_t *p_node = NULL;
>>>  		ib_net16_t lid = 0;
>>> +		int8_t sl;
>>>
>>>  		if (!mon_node->port[port].valid)
>>>  			goto Exit;
>>> @@ -1329,6 +1625,9 @@ static void
>> perfmgr_check_pce_overflow(osm_perfmgr_t * pm,
>>>  			PRIx64 ") port %d; clearing counters\n",
>>>  			mon_node->name, mon_node->guid, port);
>>>
>>> +		if ((sl = get_sl(pm, mon_node, port)) < 0)
>>> +			goto Exit;
>>> +
>>>  		cl_plock_acquire(&pm->osm->lock);
>>>  		p_node =
>>>  		    osm_get_node_by_guid(pm->subn,
>> cl_hton64(mon_node->guid)); @@
>>> -1350,8 +1649,7 @@ static void
>> perfmgr_check_pce_overflow(osm_perfmgr_t * pm,
>>>  		/* clear port counters */
>>>  		status = perfmgr_send_pce_mad(pm, lid, remote_qp,
>> pkey_ix,
>>>  					      port, IB_MAD_METHOD_SET,
>>> -					      &mad_context,
>>> -					      0); /* FIXME SL != 0 */
>>> +					      &mad_context, sl);
>>>  		if (status != IB_SUCCESS)
>>>  			OSM_LOG(pm->log, OSM_LOG_ERROR, "PerfMgr:
>> ERR 5419: "
>>>  				"Failed to send clear counters MAD for %s
>> (0x%"
>>> @@ -1475,6 +1773,7 @@ static boolean_t handle_redirect(osm_perfmgr_t
>> *pm,
>>>  	boolean_t valid = TRUE;
>>>  	int16_t pkey_ix = 0;
>>>  	uint8_t mad_method;
>>> +	int8_t sl;
>>>
>>>  	OSM_LOG(pm->log, OSM_LOG_VERBOSE,
>>>  		"Redirection to LID %u GID %s QP 0x%x received\n", @@ -
>> 1528,6
>>> +1827,12 @@ static boolean_t handle_redirect(osm_perfmgr_t *pm,
>>>  	if (!valid)
>>>  		goto Exit;
>>>
>>> +	sl = get_sl(pm, p_mon_node, port);
>>> +	if (sl < 0) {
>>> +		valid = FALSE;
>>> +		goto Exit;
>>> +	}
>>> +
>>>  	/* LID redirection support (easier than GID redirection) */
>>>  	cl_plock_acquire(&pm->osm->lock);
>>>  	p_mon_node->port[port].redirection = TRUE; @@ -1550,7 +1855,7
>> @@
>>> static boolean_t handle_redirect(osm_perfmgr_t *pm,
>>>  		status = perfmgr_send_cpi_mad(pm, cpi->redir_lid,
>>>  						cpi->redir_qp, pkey_ix,
>>>  						port, mad_context,
>>> -						0); /* FIXME SL != 0 */
>>> +						sl);
>>>  	} else {
>>>  		/* reissue the original query to the redirected location */
>>>  		mad_method = mad_context-
>>> perfmgr_context.mad_method;
>>> @@ -1561,14 +1866,14 @@ static boolean_t
>> handle_redirect(osm_perfmgr_t *pm,
>>>  						     mad_method,
>>>  						     0xffff,
>>>  						     mad_context,
>>> -						     0); /* FIXME SL != 0 */
>>> +						     sl);
>>>  		} else {
>>>  			status = perfmgr_send_pce_mad(pm, cpi->redir_lid,
>>>  						      cpi->redir_qp,
>>>  						      pkey_ix, port,
>>>  						      mad_method,
>>>  						      mad_context,
>>> -						      0); /* FIXME SL != 0 */
>>> +						      sl);
>>>  		}
>>>  	}
>>>  	if (status != IB_SUCCESS)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
