From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_pkey_mgr.c: Pack switch peer port PKey
 tables
Date: Mon, 02 May 2011 19:45:05 -0400
Message-ID: <4DBF4201.7070901@dev.mellanox.co.il>
References: <4DA358F8.6070203@dev.mellanox.co.il> <20110502121244.GC2088@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502121244.GC2088-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 5/2/2011 8:12 AM, Alex Netes wrote:
> Hi Hal,
> 
> 
> On 15:39 Mon 11 Apr     , Hal Rosenstock wrote:
>>
>> In pkey_mgr_update_peer_port, rather than mirror the end port
>> PKey table, pack the peer switch's port PKey table to
>> eliminate any holes.
>>
> 
> Why don't you want to pack port's pkey table itself and mirror it packed to
> the peer's port?

It's disruptive to change end port pkey indices whereas that's not the
case on switch external ports and it has benefit there.

> 
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
>> index f6bc9d1..06d9b1e 100644
>> --- a/opensm/osm_pkey_mgr.c
>> +++ b/opensm/osm_pkey_mgr.c
>> @@ -398,6 +398,35 @@ static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
>>  	return index;
>>  }
>>  
>> +static int update_peer_block(osm_log_t * p_log, osm_sm_t * sm,
>> +			     osm_physp_t * peer,
>> +			     osm_pkey_tbl_t * p_peer_pkey_tbl,
>> +			     ib_pkey_table_t * new_peer_block,
>> +			     uint16_t peer_block_idx, osm_node_t * p_node)
>> +{
>> +	int ret = 0;
>> +	ib_pkey_table_t *peer_block;
>> +
>> +	peer_block = osm_pkey_tbl_block_get(p_peer_pkey_tbl, peer_block_idx);
>> +	if (!peer_block ||
>> +	    memcmp(peer_block, new_peer_block, sizeof(*peer_block))) {
>> +		if (pkey_mgr_update_pkey_entry(sm, peer, new_peer_block,
>> +					       peer_block_idx) != IB_SUCCESS) {
>> +			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0509: "
>> +				"pkey_mgr_update_pkey_entry() failed to update "
>> +				"pkey table block %d for node 0x%016"
>> +				PRIx64 " port %u (%s)\n",
>> +				peer_block_idx,
>> +				cl_ntoh64(osm_node_get_node_guid(p_node)),
>> +				osm_physp_get_port_num(peer),
>> +				p_node->print_desc);
>> +			ret = -1;
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>  static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
>>  				     const osm_subn_t * p_subn,
>>  				     const osm_port_t * const p_port,
>> @@ -405,15 +434,16 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
>>  {
>>  	osm_physp_t *p_physp, *peer;
>>  	osm_node_t *p_node;
>> -	ib_pkey_table_t *block, *peer_block;
>> +	ib_pkey_table_t *block;
>>  	const osm_pkey_tbl_t *p_pkey_tbl;
>>  	osm_pkey_tbl_t *p_peer_pkey_tbl;
>> -	uint16_t block_index;
>> +	uint16_t block_index, peer_block_idx;
>>  	uint16_t peer_max_blocks;
>>  	uint16_t last_index;
>> -	ib_api_status_t status = IB_SUCCESS;
>> -	ib_pkey_table_t empty_block;
>> -	int ret = 0;
>> +	ib_pkey_table_t new_peer_block;
>> +	uint16_t pkey_idx, peer_pkey_idx;
>> +	ib_net16_t pkey;
>> +	int ret = 0, loop_exit = 0;
>>  
>>  	p_physp = p_port->p_physp;
>>  	if (!p_physp)
>> @@ -425,70 +455,80 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
>>  	if (!p_node->sw || !p_node->sw->switch_info.enforce_cap)
>>  		return 0;
>>  
>> -	p_pkey_tbl = osm_physp_get_pkey_tbl(p_physp);
>> -	peer_max_blocks = pkey_mgr_get_physp_max_blocks(peer);
>> -	if (peer_max_blocks < p_pkey_tbl->used_blocks) {
>> -		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
>> -			"Not enough pkey blocks (%u < %u used) on switch 0x%016"
>> -			PRIx64 " port %u (%s). Clearing Enforcement bit\n",
>> -			peer_max_blocks, p_pkey_tbl->used_blocks,
>> -			cl_ntoh64(osm_node_get_node_guid(p_node)),
>> -			osm_physp_get_port_num(peer),
>> -			p_node->print_desc);
>> -		enforce = FALSE;
>> -		ret = -1;
>> -	} else if (peer_max_blocks == p_pkey_tbl->used_blocks) {
>> -		/* Is last used pkey index beyond switch peer port capacity ? */
>> -		last_index = (peer_max_blocks - 1) * IB_NUM_PKEY_ELEMENTS_IN_BLOCK +
>> -			     last_used_pkey_index(p_port, p_pkey_tbl);
>> -		if (cl_ntoh16(p_node->sw->switch_info.enforce_cap) <= last_index) {
>> -			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0507: "
>> -				"Not enough pkey entries (%u <= %u) on switch 0x%016"
>> -				PRIx64 " port %u (%s). Clearing Enforcement bit\n",
>> -				cl_ntoh16(p_node->sw->switch_info.enforce_cap),
>> -				last_index,
>> -				cl_ntoh64(osm_node_get_node_guid(p_node)),
>> -				osm_physp_get_port_num(peer),
>> -				p_node->print_desc);
>> -			enforce = FALSE;
>> -			ret = -1;
>> -		}
>> +	if (enforce == FALSE) {
>> +		pkey_mgr_enforce_partition(p_log, sm, peer, FALSE);
>> +		return -1;
> 
> Though it doesn't affect anything, why do you return -1 here?

I don't recall and it doesn't look right. It should probably just be
return ret there.

>>  	}
>>  
>> -	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce))
>> -		ret = -1;
>> -
>> -	if (enforce == FALSE)
>> -		return ret;
>> -
>> -	memset(&empty_block, 0, sizeof(ib_pkey_table_t));
>> -
>> +	p_pkey_tbl = osm_physp_get_pkey_tbl(p_physp);
>> +	peer_max_blocks = pkey_mgr_get_physp_max_blocks(peer);
>>  	p_peer_pkey_tbl = &peer->pkeys;
>> -	p_peer_pkey_tbl->used_blocks = p_pkey_tbl->used_blocks;
>> +	peer_block_idx = 0;
>> +	peer_pkey_idx = 0;
>>  	for (block_index = 0; block_index < p_pkey_tbl->used_blocks;
>>  	     block_index++) {
>> +		if (loop_exit)
>> +			break;
>>  		block = osm_pkey_tbl_new_block_get(p_pkey_tbl, block_index);
>>  		if (!block)
>> -			block = &empty_block;
>> -
>> -		peer_block =
>> -		    osm_pkey_tbl_block_get(p_peer_pkey_tbl, block_index);
>> -		if (!peer_block
>> -		    || memcmp(peer_block, block, sizeof(*peer_block))) {
>> -			status = pkey_mgr_update_pkey_entry(sm, peer, block,
>> -							    block_index);
>> -			if (status != IB_SUCCESS) {
>> -				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0509: "
>> -					"pkey_mgr_update_pkey_entry() failed to update "
>> -					"pkey table block %d for node 0x%016"
>> -					PRIx64 " port %u (%s)\n", block_index,
>> -					cl_ntoh64(osm_node_get_node_guid
>> -						  (p_node)),
>> +			continue;
>> +		for (pkey_idx = 0; pkey_idx < IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
>> +		     pkey_idx++) {
>> +			pkey = block->pkey_entry[pkey_idx];
>> +			if (ib_pkey_is_invalid(pkey))
>> +				continue;
>> +			new_peer_block.pkey_entry[peer_pkey_idx] = pkey;
>> +			if (peer_block_idx >= peer_max_blocks) {
>> +				loop_exit = 1;
>> +				break;
>> +			}
>> +			if (++peer_pkey_idx == IB_NUM_PKEY_ELEMENTS_IN_BLOCK) {
>> +				if (update_peer_block(p_log, sm, peer,
>> +						      p_peer_pkey_tbl,
>> +						      &new_peer_block,
>> +						      peer_block_idx, p_node))
>> +					ret = -1;
>> +				peer_pkey_idx = 0;
>> +				peer_block_idx++;
>> +			}
>> +		}
>> +	}
>> +
>> +	if (peer_block_idx < peer_max_blocks) {
>> +		if (peer_pkey_idx) {
>> +			/* Handle partial last block */
>> +			for (; peer_pkey_idx < IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
>> +			     peer_pkey_idx++)
>> +				new_peer_block.pkey_entry[peer_pkey_idx] = 0;
>> +			if (update_peer_block(p_log, sm, peer, p_peer_pkey_tbl,
>> +					      &new_peer_block, peer_block_idx,
>> +					      p_node))
>> +				ret = -1;
>> +		} else
>> +			peer_block_idx--;
>> +
>> +		p_peer_pkey_tbl->used_blocks = peer_block_idx + 1;
>> +		if (p_peer_pkey_tbl->used_blocks == peer_max_blocks) {
>> +			/* Is last used pkey index beyond switch peer port capacity ? */
>> +			last_index = peer_block_idx * IB_NUM_PKEY_ELEMENTS_IN_BLOCK +
>> +				     last_used_pkey_index(p_port,
>> +							  p_peer_pkey_tbl);
>> +			if (cl_ntoh16(p_node->sw->switch_info.enforce_cap) <= last_index) {
>> +				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0507: "
>> +					"Not enough pkey entries (%u <= %u) on switch 0x%016"
>> +					PRIx64 " port %u (%s). Clearing Enforcement bit\n",
>> +					cl_ntoh16(p_node->sw->switch_info.enforce_cap),
>> +					last_index,
>> +					cl_ntoh64(osm_node_get_node_guid(p_node)),
>>  					osm_physp_get_port_num(peer),
>>  					p_node->print_desc);
>> +				enforce = FALSE;
>>  				ret = -1;
>>  			}
>>  		}
>> +	} else {
>> +		p_peer_pkey_tbl->used_blocks = peer_max_blocks;
>> +		enforce = FALSE;
>>  	}
>>  
>>  	if (!ret)
> 
> Only if ret = 0,  "Pkey table was updated for node..." message is printed,
> however Pkey table might be changed even if ret = -1.

This is related to your comment above, right ? Or are there additional
places where pkey table is updated and ret is -1 ?

-- Hal

>> @@ -498,6 +538,9 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
>>  			cl_ntoh64(osm_node_get_node_guid(p_node)),
>>  			osm_physp_get_port_num(peer), p_node->print_desc);
>>  
>> +	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce))
>> +		ret = -1;
>> +
>>  	return ret;
>>  }
>>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
