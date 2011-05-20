From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/13] opensm: Dump/load SA GUIDInfoRecords
Date: Fri, 20 May 2011 15:50:05 -0400
Message-ID: <4DD6C5ED.8000802@dev.mellanox.co.il>
References: <4DBABCB2.9050405@dev.mellanox.co.il> <20110515145235.GC30064@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110515145235.GC30064-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/15/2011 10:52 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 09:27 Fri 29 Apr     , Hal Rosenstock wrote:
>> From b587d02d3ab47e3fe47f98b2c8115c7686e6104e Mon Sep 17 00:00:00 2001
>> From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Date: Thu, 28 Apr 2011 22:53:34 +0300
>> Subject: [PATCH] opensm: Dump/load SA GUIDInfoRecords
>>
>> into port alias guid table
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  opensm/osm_sa.c                 |  146 ++++++++++++++++++++++++++++++++++++++-
>>  opensm/osm_sa_guidinfo_record.c |    8 ++-
>>  2 files changed, 150 insertions(+), 4 deletions(-)
>>
>> diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
>> index bbd1a56..0142b59 100644
>> --- a/opensm/osm_sa.c
>> +++ b/opensm/osm_sa.c
>> @@ -1,6 +1,6 @@
>>  /*
>>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
>>   *
>> @@ -680,6 +680,40 @@ static void sa_dump_one_service(cl_list_item_t * p_list_item, void *cxt)
>>  		p_svcr->modified_time, p_svcr->lease_period);
>>  }
>>  
>> +static void sa_dump_one_port_guidinfo(cl_map_item_t * p_map_item, void *cxt)
>> +{
>> +	FILE *file = ((struct opensm_dump_context *)cxt)->file;
>> +	osm_port_t *p_port = (osm_port_t *) p_map_item;
>> +	uint32_t max_block;
>> +	int block_num;
>> +
>> +	if (!p_port->p_physp->p_guids)
>> +		return;
>> +
>> +	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
>> +		     GUID_TABLE_MAX_ENTRIES;
>> +
>> +	for (block_num = 0; block_num < max_block; block_num++) {
>> +		fprintf(file, "GUIDInfo Record:"
>> +			" base_guid=0x%016" PRIx64 " lid=0x%04x block_num=0x%x"
>> +			" guid0=0x%016" PRIx64 " guid1=0x%016" PRIx64
>> +			" guid2=0x%016" PRIx64 " guid3=0x%016" PRIx64
>> +			" guid4=0x%016" PRIx64 " guid5=0x%016" PRIx64
>> +			" guid6=0x%016" PRIx64 " guid7=0x%016" PRIx64
>> +			"\n\n",
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[0]),
>> +			cl_ntoh16(osm_port_get_base_lid(p_port)), block_num,
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 1]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 2]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 3]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 4]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 5]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 6]),
>> +			cl_ntoh64((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES + 7]));
>> +	}
>> +}
>> +
>>  static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
>>  {
>>  	struct opensm_dump_context dump_context;
>> @@ -687,8 +721,11 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
>>  
>>  	dump_context.p_osm = p_osm;
>>  	dump_context.file = file;
>> -	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
>> +	OSM_LOG(&p_osm->log, OSM_LOG_ERROR /* DEBUG */, "Dump guidinfo\n");
>>  	cl_plock_acquire(&p_osm->lock);
>> +	cl_qmap_apply_func(&p_osm->subn.port_guid_tbl,
>> +			   sa_dump_one_port_guidinfo, &dump_context);
>> +	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
>>  	for (p_mgrp = (osm_mgrp_t *) cl_fmap_head(&p_osm->subn.mgrp_mgid_tbl);
>>  	     p_mgrp != (osm_mgrp_t *) cl_fmap_end(&p_osm->subn.mgrp_mgid_tbl);
>>  	     p_mgrp = (osm_mgrp_t *) cl_fmap_next(&p_mgrp->map_item))
>> @@ -834,6 +871,81 @@ _out:
>>  	return ret;
>>  }
>>  
>> +static int load_guidinfo(osm_opensm_t * p_osm, ib_net64_t base_guid,
>> +			 ib_guidinfo_record_t *gir)
>> +{
>> +	osm_port_t *p_port;
>> +	uint32_t max_block;
>> +	int i, ret = 0;
>> +	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
>> +
>> +	cl_plock_excl_acquire(&p_osm->lock);
>> +
>> +	p_port = osm_get_port_by_guid(&p_osm->subn, base_guid);
>> +	if (!p_port)
>> +		goto _out;
>> +
>> +	if (!p_port->p_physp->p_guids) {
>> +		max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
>> +			     GUID_TABLE_MAX_ENTRIES;
>> +		p_port->p_physp->p_guids = calloc(max_block * GUID_TABLE_MAX_ENTRIES,
>> +						  sizeof(ib_net64_t));
>> +		if (!p_port->p_physp->p_guids) {
>> +			OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
>> +				"cannot allocate GUID table for port "
>> +				"GUID 0x%" PRIx64 "\n",
>> +				cl_ntoh64(p_port->p_physp->port_guid));
>> +			goto _out;
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < GUID_TABLE_MAX_ENTRIES; i++) {
>> +		if (!gir->guid_info.guid[i])
>> +			continue;
>> +		/* skip block 0 index 0 */
>> +		if (gir->block_num == 0 && i == 0)
>> +			continue;
>> +		if (gir->block_num * GUID_TABLE_MAX_ENTRIES + i >
>> +		    p_port->p_physp->port_info.guid_cap)
> 
> I guess we can just use break here.

Fixed in v2 of this patch.

-- Hal

> 
>> +			continue;
>> +
> 
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
