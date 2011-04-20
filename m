From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_port: Add infrastructure for alias GUID
 support
Date: Wed, 20 Apr 2011 09:00:24 -0400
Message-ID: <4DAED8E8.3080805@dev.mellanox.co.il>
References: <4DA31781.7070606@dev.mellanox.co.il> <20110420120854.GA28761@calypso.voltaire.com> <4DAECF94.7000903@dev.mellanox.co.il> <20110420123947.GB28761@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110420123947.GB28761-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/20/2011 8:39 AM, Alex Netes wrote:
> On 08:20 Wed 20 Apr     , Hal Rosenstock wrote:
>> Hi Alex,
>>
>> On 4/20/2011 8:08 AM, Alex Netes wrote:
>>> Hi Hal,
>>>
>>> On 11:00 Mon 11 Apr     , Hal Rosenstock wrote:
>>>>
>>>> alias GUIDs are those indicated in SM GUIDInfo attribute
>>>> (other than index 0) and are created/removed via SA Set/Delete
>>>> of GUIDInfoRecord per IBTA MgtWG errata RefIDs 4704-4706.
>>>>
>>>> Up to now, this attribute was unneeded by the SM as only base port
>>>> GUIDs were supported (and are available from the SM NodeInfo attribute).
>>>>
>>>> In order to support alias GUIDs, a new alias GUID table is to be added
>>>> indexed by alias GUID, each containing a pointer to the base port. The
>>>> routines for creating and removing alias GUID table entries are added
>>>> by this patch. Also, a pointer to the alias port GUIDs provided by the
>>>> SM GUIDInfo attribute is added to the osm_physp_t structure.
>>>>
>>>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>> diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
>>>> index ee9feec..3433e31 100644
>>>> --- a/include/opensm/osm_port.h
>>>> +++ b/include/opensm/osm_port.h
>>>> @@ -1,6 +1,6 @@
>>>>  /*
>>>>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>>>> - * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
>>>> + * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
>>>>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>>>>   *
>>>>   * This software is available to you under a choice of one of two
>>>> @@ -105,6 +105,7 @@ struct osm_mgrp;
>>>>  typedef struct osm_physp {
>>>>  	ib_port_info_t port_info;
>>>>  	ib_net64_t port_guid;
>>>> +	ib_net64_t (*p_guids)[];
>>>
>>> Can we use only one array for port guids? 
>>
>> I'm not 100% sure what you mean. There's only one array above. Do you
>> mean that port_guid could be removed ? If so, that's not the case
>> because the p_guids array is only allocated when alias GUIDs are being
>> used which is not the common case.
> 
> I haven't seen the use you make of p_guids in your patches yet. 

These haven;t been submitted yet.

> The initialization of port_guid is done in osm_physp_init(). I guess it's
> possible to initialize p_guids[0] there instead of port_guid and use
> p_guids[0] in every places port_guid is used.

It's possible but it requires the array to be allocated always even when
alias GUIDs are not in use which is the common case. So it's a tradeoff
in using one additional 64 bit field in the alias GUID case versus
additional memory for the entire GUID table in the non alias GUID cases.
It also would mean more code would need to change (access index 0 rather
than port_guid in all such places). I chose the former approach for the
reasons stated above.

-- Hal

>>
>>> I guess port_guid would be always the first element of p_guids[].
>>
>> Yes, port_guid will also be present at index 0 of p_guids array when the
>> p_guids array is allocated.
>>
>> -- Hal
>>
>>>
>>> -- Alex
>>> --
\
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
