From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_port: Add infrastructure for alias GUID
 support
Date: Wed, 20 Apr 2011 08:20:36 -0400
Message-ID: <4DAECF94.7000903@dev.mellanox.co.il>
References: <4DA31781.7070606@dev.mellanox.co.il> <20110420120854.GA28761@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110420120854.GA28761-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 4/20/2011 8:08 AM, Alex Netes wrote:
> Hi Hal,
> 
> On 11:00 Mon 11 Apr     , Hal Rosenstock wrote:
>>
>> alias GUIDs are those indicated in SM GUIDInfo attribute
>> (other than index 0) and are created/removed via SA Set/Delete
>> of GUIDInfoRecord per IBTA MgtWG errata RefIDs 4704-4706.
>>
>> Up to now, this attribute was unneeded by the SM as only base port
>> GUIDs were supported (and are available from the SM NodeInfo attribute).
>>
>> In order to support alias GUIDs, a new alias GUID table is to be added
>> indexed by alias GUID, each containing a pointer to the base port. The
>> routines for creating and removing alias GUID table entries are added
>> by this patch. Also, a pointer to the alias port GUIDs provided by the
>> SM GUIDInfo attribute is added to the osm_physp_t structure.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
>> index ee9feec..3433e31 100644
>> --- a/include/opensm/osm_port.h
>> +++ b/include/opensm/osm_port.h
>> @@ -1,6 +1,6 @@
>>  /*
>>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
>> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>>   *
>>   * This software is available to you under a choice of one of two
>> @@ -105,6 +105,7 @@ struct osm_mgrp;
>>  typedef struct osm_physp {
>>  	ib_port_info_t port_info;
>>  	ib_net64_t port_guid;
>> +	ib_net64_t (*p_guids)[];
> 
> Can we use only one array for port guids? 

I'm not 100% sure what you mean. There's only one array above. Do you
mean that port_guid could be removed ? If so, that's not the case
because the p_guids array is only allocated when alias GUIDs are being
used which is not the common case.

> I guess port_guid would be always the first element of p_guids[].

Yes, port_guid will also be present at index 0 of p_guids array when the
p_guids array is allocated.

-- Hal

> 
> -- Alex
> --
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
