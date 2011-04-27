From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm/osm_pkey_mgr.c: Handle osm_pkey_tbl_new_block_get
 returning NULL
Date: Wed, 27 Apr 2011 11:15:02 -0400
Message-ID: <4DB832F6.8070308@dev.mellanox.co.il>
References: <4DA358FF.3060200@dev.mellanox.co.il> <20110427145736.GA1903@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427145736.GA1903-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 4/27/2011 10:57 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 15:39 Mon 11 Apr     , Hal Rosenstock wrote:
>>
>> Fixes seg fault when ib_pkey_is_invalid called in last_used_pkey_index
>>
>> Introduced by commit aebd9f9d9cdd1c60c2b3784c0c03cfe8f4014019 
>> for better last block handling
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
>> index 06d9b1e..a2021e9 100644
>> --- a/opensm/osm_pkey_mgr.c
>> +++ b/opensm/osm_pkey_mgr.c
>> @@ -375,14 +375,19 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
>>  	return ret;
>>  }
>>  
>> -static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
>> -				     const osm_pkey_tbl_t * p_pkey_tbl)
>> +static int last_used_pkey_index(const osm_port_t * const p_port,
>> +				const osm_pkey_tbl_t * p_pkey_tbl,
>> +				uint16_t * p_last_index)
>>  {
>>  	ib_pkey_table_t *last_block;
>>  	uint16_t index, last_index = 0;
>>  
>> +	CL_ASSERT(p_last_index);
>> +
>>  	last_block = osm_pkey_tbl_new_block_get(p_pkey_tbl,
>>  						p_pkey_tbl->used_blocks - 1);
>> +	if (!last_block)
>> +		return 1;
>>  
>>  	if (p_pkey_tbl->used_blocks == p_pkey_tbl->max_blocks)
>>  		last_index = cl_ntoh16(p_port->p_node->node_info.partition_cap) % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
>> @@ -395,7 +400,8 @@ static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
>>  			break;
>>  	} while (index != 0);
>>  
>> -	return index;
>> +	*p_last_index = index;
> 
> I think it should be: *p_last_index = index + 1;
> You want to return the number of pkeys in the block and not the index in the
> array.

Isn't this the last_used_pkey_index as the routine name says and not one past the last index used ? 

The comparison is:

if (cl_ntoh16(p_node->sw->switch_info.enforce_cap) <= last_index)

and doesn't that take care of this ?

+			if (!last_used_pkey_index(p_port, p_peer_pkey_tbl,
+						  &last_index)) {
+				last_index += peer_block_idx * IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+				if (cl_ntoh16(p_node->sw->switch_info.enforce_cap) <= last_index) {
+					OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0507: "

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
